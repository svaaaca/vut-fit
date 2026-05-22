# Využití AI nástroje Google Gemini

- **Autor**: David Kvaček (xkvace00@stud.fit.vutbr.cz)
- **Datum**: 2026-04-22

## Typická konverzace (otázka)

I have almost finished the implementation of a testing function in Haskell.
The logic is working, but I need to polish it before submitting it to the project repository.
Please perform the following adjustments: Haddock documentation, standardize variable names, code cleanup and formatting.

```
-- Execute a Combined test case.
-- A combined test runs the parser first, then (if it succeeds) runs the interpreter
-- on the parser's output. The execution proceeds in two phases:
-- phase 1 (parser): run the parser with the test's source code on stdin,
-- if the parser exits with a code not in the expected list, the test immediately
-- fails with result 'ParseFail', otherwise, the parser's output becomes the input
-- to the interpreter,
-- phase 2 (interpreter): write the parser's output to a temporary file and
-- run the interpreter with --source <tempfile> (and optionally --input <stdin>
-- if the test has an .in file), the result is determined by checking the
-- interpreter's exit code and optionally diffing its output against .out.
-- The test report includes both parser and interpreter output, exit codes, and
-- diff output (if applicable).
executeCombined :: FilePath -> FilePath -> TestCaseDefinition -> IO TestCaseReport
executeCombined parserPath interpPath test = do
  -- phase 1: run the parser on the source code
  (pExitCode, pOut, pErr) <- runParser parserPath (tcdSourceCode test)
  let pCode = exitCodeToInt pExitCode
      expectedParserCodes = fromMaybe [0] (tcdExpectedParserExitCodes test)
  if pCode `elem` expectedParserCodes
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
    else withTempSource pOut $ \tmpPath -> do
      (iExitCode, iOut, iErr) <- runInterpreter interpPath tmpPath (tcdStdinFile test)
      let iCode = exitCodeToInt iExitCode
          expectedInterpCodes = fromMaybe [] (tcdExpectedInterpreterExitCodes test)
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
```

## Typická konverzace (odpověď)

```
-- | Execute a 'Combined' test case.
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
```

## Typická konverzace (otázka)

The following function buildExitCodes is working properly, but the code is currently a mess in terms of formatting and readability.
I also need to add proper Haddock documentation for it.
Please perform the following adjustments: format the code, Haddock documentation and refine the logic.

```
-- Build the expected exit code lists from the parsed header and inferred type.
-- The exit code lists depend on the test type:
-- 'ParseOnly' – parser exit codes are expected; interpreter exit codes are not used,
-- 'ExecuteOnly' – interpreter exit codes are expected; parser exit codes are not used,
-- 'Combined' – both parser and interpreter exit codes may be expected.
-- For each exit code field, 'Nothing' means the exit code was not specified
-- (implicitly, 0 is expected). 'Just' a non-empty list means those specific codes
-- are acceptable. An empty list should not appear in the output.
-- For 'Combined' tests: if no !C! codes were given, 'tcdExpectedParserExitCodes'
-- is 'Nothing' (the parser must exit 0, which is implicit and not stored in the
-- list); if !C! 0 was explicit, it is stored as Just [0].
buildExitCodes :: TestCaseType -> ParsedHeader -> (Maybe [Int], Maybe [Int])
buildExitCodes testType hdr = let
  parserExitCodes = case testType of
    ParseOnly -> if null (phParserCodes hdr) then Nothing else Just (phParserCodes hdr)
    ExecuteOnly -> Nothing
    Combined -> if null (phParserCodes hdr) then Nothing else Just (phParserCodes hdr)
  interpreterExitCodes = case testType of
    ParseOnly -> Nothing
    ExecuteOnly -> if null (phInterpreterCodes hdr) then Nothing else Just (phInterpreterCodes hdr)
    Combined -> if null (phInterpreterCodes hdr) then Nothing else Just (phInterpreterCodes hdr)
  in (parserExitCodes, interpreterExitCodes)
```

## Typická konverzace (odpověď)

```
-- | Build the expected exit code lists from the parsed header and inferred type.
--
-- The exit code lists depend on the test type:
--
-- * 'ParseOnly' – parser exit codes are expected; interpreter exit codes are not used,
-- * 'ExecuteOnly' – interpreter exit codes are expected; parser exit codes are not used,
-- * 'Combined' – both parser and interpreter exit codes may be expected.
--
-- For each exit code field, 'Nothing' means the exit code was not specified
-- (implicitly, 0 is expected). 'Just' a non-empty list means those specific codes
-- are acceptable. An empty list should not appear in the output.
--
-- For 'Combined' tests: if no @!C!@ codes were given, 'tcdExpectedParserExitCodes'
-- is 'Nothing' (the parser must exit 0, which is implicit and not stored in the
-- list); if @!C! 0@ was explicit, it is stored as @Just [0]@.
buildExitCodes :: TestCaseType -> ParsedHeader -> (Maybe [Int], Maybe [Int])
buildExitCodes testType hdr =
  let -- determine expected parser exit codes based on test type
      parserExitCodes =
        case testType of
          -- ParseOnly: use parser codes from header if present
          ParseOnly -> 
            if null (phParserCodes hdr) 
              then Nothing 
              else Just (phParserCodes hdr)
          -- ExecuteOnly: no parser codes expected
          ExecuteOnly -> Nothing
          -- Combined: use parser codes if explicit, otherwise Nothing (implicit 0)
          Combined -> 
            if null (phParserCodes hdr) 
              then Nothing 
              else Just (phParserCodes hdr)
      -- determine expected interpreter exit codes based on test type
      interpreterExitCodes =
        case testType of
          -- ParseOnly: no interpreter codes expected
          ParseOnly -> Nothing
          -- ExecuteOnly: use interpreter codes from header if present
          ExecuteOnly -> 
            if null (phInterpreterCodes hdr) 
              then Nothing 
              else Just (phInterpreterCodes hdr)
          -- Combined: use interpreter codes from header if present
          Combined -> 
            if null (phInterpreterCodes hdr) 
              then Nothing 
              else Just (phInterpreterCodes hdr)
   in (parserExitCodes, interpreterExitCodes)
```
