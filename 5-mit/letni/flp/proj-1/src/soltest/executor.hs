-- | Executing test cases by running external parser and interpreter processes.
--
-- Each test case is executed according to its 'TestCaseType':
--
-- * 'ParseOnly': run the parser with source on stdin, check exit code.
-- * 'ExecuteOnly': write XML to a temp file, run the interpreter, check
--   exit code, optionally diff stdout against @.out@.
-- * 'Combined': run the parser first (must exit 0), write its output to a
--   temp file, then run the interpreter as in 'ExecuteOnly'.
module SOLTest.Executor
  ( executeTest,
    runParser,
    runInterpreter,
    runDiff,
  )
where

import Data.Maybe (fromMaybe)
import SOLTest.Types
-- | getPermissions retrieves file permissions,
-- executable checks if the file has executable bit set
import System.Directory (doesFileExist, getPermissions, executable)
import System.Exit (ExitCode (..))
import System.IO (hClose, hPutStr)
import System.IO.Temp (withSystemTempFile)
import System.Process (proc, readCreateProcessWithExitCode)

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

-- | Execute a single test case and return a @TestCaseReport@.
--
-- Returns @Left UnexecutedReason@ when execution cannot proceed (e.g.
-- the required executable is missing or not executable).
executeTest ::
  -- | Path to the parser executable (required for 'ParseOnly' and 'Combined').
  Maybe FilePath ->
  -- | Path to the interpreter executable (required for 'ExecuteOnly' and 'Combined').
  Maybe FilePath ->
  TestCaseDefinition ->
  IO (Either UnexecutedReason TestCaseReport)
executeTest mParser mInterp test =
  case tcdTestType test of
    ParseOnly ->
      withExecutable mParser $ \parserPath ->
        Right <$> executeParseOnly parserPath test
    ExecuteOnly ->
      withExecutable mInterp $ \interpPath ->
        Right <$> executeExecuteOnly interpPath test
    Combined ->
      withExecutable mParser $ \parserPath ->
        withExecutable mInterp $ \interpPath ->
          Right <$> executeCombined parserPath interpPath test

-- ---------------------------------------------------------------------------
-- Per-type execution
-- ---------------------------------------------------------------------------

-- | Execute a 'ParseOnly' test case.
executeParseOnly :: FilePath -> TestCaseDefinition -> IO TestCaseReport
executeParseOnly parserPath test = do
  (exitCode, pOut, pErr) <- runParser parserPath (tcdSourceCode test)
  let code = exitCodeToInt exitCode
      result
        | code `elem` expectedCodes = Passed
        | otherwise = ParseFail
      expectedCodes = fromMaybe [] (tcdExpectedParserExitCodes test)
  return
    TestCaseReport
      { tcrResult = result,
        tcrParserExitCode = Just code,
        tcrInterpreterExitCode = Nothing,
        tcrParserStdout = Just pOut,
        tcrParserStderr = Just pErr,
        tcrInterpreterStdout = Nothing,
        tcrInterpreterStderr = Nothing,
        tcrDiffOutput = Nothing
      }

-- | Execute an 'ExecuteOnly' test case.
executeExecuteOnly :: FilePath -> TestCaseDefinition -> IO TestCaseReport
executeExecuteOnly interpPath test =
  withTempSource (tcdSourceCode test) $ \tmpPath -> do
    (exitCode, iOut, iErr) <- runInterpreter interpPath tmpPath (tcdStdinFile test)
    let code = exitCodeToInt exitCode
        expectedCodes = fromMaybe [] (tcdExpectedInterpreterExitCodes test)
    (result, diffOut) <- checkInterpreterResult code expectedCodes iOut (tcdExpectedStdoutFile test)
    return
      TestCaseReport
        { tcrResult = result,
          tcrParserExitCode = Nothing,
          tcrInterpreterExitCode = Just code,
          tcrParserStdout = Nothing,
          tcrParserStderr = Nothing,
          tcrInterpreterStdout = Just iOut,
          tcrInterpreterStderr = Just iErr,
          tcrDiffOutput = diffOut
        }

-- | Execute a 'Combined' test case.
--
-- Co-Author : (c) 2026 Google Gemini
--                 2026 OpenAI ChatGPT
--
-- A combined test runs the parser first, then (if it succeeds) runs the interpreter
-- on the parser's output. The execution proceeds in two phases:
--
-- * __phase 1 (parser):__ run the parser with the test's source code on stdin,
-- if the parser exits with a code not in the expected list, the test immediately
-- fails with result 'ParseFail', otherwise, the parser's output becomes the input
-- to the interpreter,
--
-- * __phase 2 (interpreter):__ write the parser's output to a temporary file and
-- run the interpreter with @--source \<tempfile\>@ (and optionally @--input \<stdin\>@
-- if the test has an @.in@ file), the result is determined by checking the
-- interpreter's exit code and optionally diffing its output against @.out@.
--
-- The test report includes both parser and interpreter output, exit codes, and
-- diff output (if applicable).
executeCombined :: FilePath -> FilePath -> TestCaseDefinition -> IO TestCaseReport
executeCombined parserPath interpPath test = do
  -- phase 1: run the parser on the source code
  (pExitCode, pOut, pErr) <- runParser parserPath (tcdSourceCode test)
  let pCode = exitCodeToInt pExitCode
      -- parser codes default to [0] if not explicitly specified
      expectedParserCodes = fromMaybe [0] (tcdExpectedParserExitCodes test)
  -- if parser failed, return immediately with ParseFail result
  if pCode `notElem` expectedParserCodes
    then return
      TestCaseReport
        { tcrResult = ParseFail,
          tcrParserExitCode = Just pCode,
          tcrInterpreterExitCode = Nothing,
          tcrParserStdout = Just pOut,
          tcrParserStderr = Just pErr,
          tcrInterpreterStdout = Nothing,
          tcrInterpreterStderr = Nothing,
          tcrDiffOutput = Nothing
        }
    -- parser succeeded; proceed to phase 2 with the parser output as interpreter input
    else withTempSource pOut $ \tmpPath -> do
      (iExitCode, iOut, iErr) <- runInterpreter interpPath tmpPath (tcdStdinFile test)
      let iCode = exitCodeToInt iExitCode
          expectedInterpCodes = fromMaybe [] (tcdExpectedInterpreterExitCodes test)
      -- check interpreter result and optionally diff output
      (result, diffOut) <- checkInterpreterResult iCode expectedInterpCodes iOut (tcdExpectedStdoutFile test)
      return
        TestCaseReport
          { tcrResult = result,
            tcrParserExitCode = Just pCode,
            tcrInterpreterExitCode = Just iCode,
            tcrParserStdout = Just pOut,
            tcrParserStderr = Just pErr,
            tcrInterpreterStdout = Just iOut,
            tcrInterpreterStderr = Just iErr,
            tcrDiffOutput = diffOut
          }

-- ---------------------------------------------------------------------------
-- Process wrappers
-- ---------------------------------------------------------------------------

-- | Run the SOL26 parser by feeding @sourceCode@ on its stdin.
--
-- Returns @(exitCode, stdout, stderr)@.
runParser :: FilePath -> String -> IO (ExitCode, String, String)
runParser parserPath = readCreateProcessWithExitCode (proc parserPath [])

-- | Run the interpreter with @--source \<xmlFile\>@ and, optionally,
-- @--input \<stdinFile\>@.
--
-- Returns @(exitCode, stdout, stderr)@.
runInterpreter ::
  FilePath ->
  FilePath ->
  Maybe FilePath ->
  IO (ExitCode, String, String)
runInterpreter interpPath xmlFile mInputFile = do
  let args = ["--source", xmlFile] ++ maybe [] (\f -> ["--input", f]) mInputFile
  readCreateProcessWithExitCode (proc interpPath args) ""

-- | Run GNU @diff@ between two files (no additional flags).
--
-- Returns @(exitCode, diffOutput)@. Exit code 0 means no differences;
-- exit code 1 means differences were found.
runDiff :: FilePath -> FilePath -> IO (ExitCode, String)
runDiff actualFile expectedFile = do
  (exitCode, out, _) <- readCreateProcessWithExitCode (proc "diff" [actualFile, expectedFile]) ""
  return (exitCode, out)

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- | Check the interpreter's result and optionally run diff.
--
-- Co-Author : (c) 2026 OpenAI ChatGPT
--
-- This function determines the test result based on the interpreter's exit code
-- and optionally compares its output against an expected output file.
--
-- The logic is as follows:
--
-- 1. if the interpreter's exit code is not in the expected list, return 'IntFail'
--    with no diff output (the interpreter failed, don't check output),
--
-- 2. if the interpreter exited with code 0 and an expected output file is provided,
--    write the interpreter's stdout to a temporary file and diff it against the
--    expected output, the result is 'Passed' if diff succeeds, 'DiffFail' otherwise,
--
-- 3. otherwise, return 'Passed' (interpreter succeeded and either no output file
--    is provided or the exit code is non-zero).
checkInterpreterResult ::
  -- | Actual interpreter exit code.
  Int ->
  -- | Expected interpreter exit codes.
  [Int] ->
  -- | Interpreter stdout.
  String ->
  -- | Path to the @.out@ file, if present.
  Maybe FilePath ->
  IO (TestResult, Maybe String)
checkInterpreterResult actualCode expectedCodes iOut mOutFile =
  -- if exit code is not expected, test fails immediately
  if actualCode `notElem` expectedCodes
    then return (IntFail, Nothing)
    -- if exit code is 0 and expected output, diff the outputs
    else
      case mOutFile of
        Just outFile | actualCode == 0 -> runDiffOnOutput iOut outFile
        -- otherwise, test passed (no output check needed)
        _ -> return (Passed, Nothing)

-- | Write a string to a temporary file and pass its path to an action.
-- The file is deleted when the action returns.
withTempSource :: String -> (FilePath -> IO a) -> IO a
withTempSource content action =
  withSystemTempFile "sol-source.xml" $ \tmpPath tmpHandle -> do
    hPutStr tmpHandle content
    hClose tmpHandle
    action tmpPath

-- | Write the interpreter stdout to a temp file and diff it against @.out@.
-- The file is deleted when the action returns.
--
-- This function creates a temporary file, writes the interpreter's output to it,
-- and then runs the standard Unix @diff@ tool to compare the temporary file against
-- the expected output file.
--
-- Returns:
--
-- * @(Passed, Nothing)@ if diff exits with code 0 (files are identical),
-- * @(DiffFail, Just diffOutput)@ if diff exits with code 1 (files differ);
--   the diff output is included in the result.
--
-- The temporary file is automatically deleted when the function returns.
runDiffOnOutput :: String -> FilePath -> IO (TestResult, Maybe String)
runDiffOnOutput iOut outFile =
  -- create a temporary file and pass its path to an action
  withSystemTempFile "interpreter-output" $ \tmpPath tmpHandle -> do
    -- write the interpreter output to the temporary file
    hPutStr tmpHandle iOut
    hClose tmpHandle
    -- run diff between the temporary file and the expected output file
    (exitCode, diffOutput) <- runDiff tmpPath outFile
    -- determine result based on diff exit code
    case exitCode of
      ExitSuccess -> return (Passed, Nothing)
      _ -> return (DiffFail, Just diffOutput)

-- | Ensure an executable path is provided and the file is executable,
-- then run an action with it.  Returns 'Left' 'CannotExecute' if the
-- path is missing or the file is not executable.
withExecutable ::
  Maybe FilePath ->
  (FilePath -> IO (Either UnexecutedReason TestCaseReport)) ->
  IO (Either UnexecutedReason TestCaseReport)
withExecutable Nothing _ =
  return
    ( Left
        UnexecutedReason
          { urCode = CannotExecute,
            urMessage = Just "Required executable path was not provided"
          }
    )
withExecutable (Just path) action = do
  check <- checkExecutable path
  case check of
    Just reason -> return (Left reason)
    Nothing -> action path

-- | Check that a file exists and has its executable bit set.
-- The IO action returns 'Nothing' if the file is usable, or 'Just'
-- an 'UnexecutedReason' describing the problem.
--
-- Co-Author : (c) 2026 OpenAI ChatGPT
--
-- This function performs two checks on the provided file path:
--
-- 1. __existence:__ verifies that the file exists on the file system,
--    returns an error with message @\"File not found: <path>\"@ if it does not,
--
-- 2. __executability:__ verifies that the file has the executable permission bit set,
--    returns an error with message @\"File is not executable: <path>\"@ if it does not.
--
-- Returns:
--
-- * 'Nothing' if the file exists and is executable,
-- * @Just UnexecutedReason@ with code 'CannotExecute' and a descriptive message
--   if either check fails.
checkExecutable :: FilePath -> IO (Maybe UnexecutedReason)
checkExecutable path = do
  -- check if the file exists
  fileExists <- doesFileExist path
  if not fileExists
    then return (Just (UnexecutedReason CannotExecute (Just ("File not found: " ++ path))))
    else do
      -- if file exists, check if it has the executable permission bit
      perms <- getPermissions path
      if executable perms
        then return Nothing
        else return (Just (UnexecutedReason CannotExecute (Just ("File is not executable: " ++ path))))

-- | Convert 'ExitCode' to an 'Int'.
exitCodeToInt :: ExitCode -> Int
exitCodeToInt ExitSuccess = 0
exitCodeToInt (ExitFailure n) = n
