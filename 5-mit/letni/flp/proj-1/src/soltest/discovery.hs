-- | Discovering @.test@ files and their companion @.in@\/@.out@ files.
module SOLTest.Discovery (discoverTests) where

-- | forM is used to map over file paths and perform I/O operations for each
import Control.Monad (forM)
import SOLTest.Types
import System.Directory
  ( doesDirectoryExist, -- needed to check if an entry is a directory for recursive traversal
    doesFileExist,
    listDirectory,
  )
import System.FilePath
  ( replaceExtension,
    takeBaseName,
    takeExtension,  -- checks if file has .test extension
    (</>),
  )

-- | Discover all @.test@ files in a directory.
--
-- Co-Author : (c) 2026 Google Gemini
--
-- When @recursive@ is 'True', subdirectories are searched recursively and their
-- test files are included in the result, when 'False', only the specified directory
-- is searched (subdirectories are skipped).
--
-- Returns a list of 'TestCaseFile' records, one per @.test@ file found, each record
-- includes the path to the @.test@ file and paths to any companion @.in@ and @.out@
-- files that exist in the same directory.
--
-- The list is ordered by file system traversal order (not alphabetically sorted).
discoverTests :: Bool -> FilePath -> IO [TestCaseFile]
discoverTests recursive dir = do
  -- list all entries in the directory
  entries <- listDirectory dir
  -- convert relative paths to absolute paths
  let fullPaths = map (dir </>) entries
  -- process each entry and collect results
  allResults <- forM fullPaths $ \fullPath -> do
    isDir <- doesDirectoryExist fullPath
    -- if entry is a directory, optionally recurse; otherwise check if it's a .test file
    if isDir
      then if recursive
        then discoverTests recursive fullPath
        else return []
      else if takeExtension fullPath == ".test"
        then do
          testFile <- findCompanionFiles fullPath
          return [testFile]
        else return []
  -- concatenate all the results from processing each entry
  return (concat allResults)

-- | Build a 'TestCaseFile' for a given @.test@ file path, checking for
-- companion @.in@ and @.out@ files in the same directory.
findCompanionFiles :: FilePath -> IO TestCaseFile
findCompanionFiles testPath = do
  let baseName = takeBaseName testPath
      inFile = replaceExtension testPath ".in"
      outFile = replaceExtension testPath ".out"
  hasIn <- doesFileExist inFile
  hasOut <- doesFileExist outFile
  return
    TestCaseFile
      { tcfName = baseName,
        tcfTestSourcePath = testPath,
        tcfStdinFile = if hasIn then Just inFile else Nothing,
        tcfExpectedStdout = if hasOut then Just outFile else Nothing
      }
