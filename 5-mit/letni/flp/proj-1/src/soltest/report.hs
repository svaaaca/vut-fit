-- | Building the final test report and computing statistics.
--
-- This module assembles a 'TestReport' from the results of test execution,
-- computes aggregate statistics, and builds the per-category success-rate
-- histogram.
module SOLTest.Report
  ( buildReport,
    groupByCategory,
    computeStats,
    computeHistogram,
    rateToBin,
  )
where

import Data.Map.Strict (Map)
import Data.Map.Strict qualified as Map
import SOLTest.Types

-- ---------------------------------------------------------------------------
-- Top-level report assembly
-- ---------------------------------------------------------------------------

-- | Assemble the complete 'TestReport'.
--
-- Parameters:
--
-- * @discovered@ – all 'TestCaseDefinition' values that were successfully parsed.
-- * @unexecuted@ – tests that were not executed for any reason (filtered, malformed, etc.).
-- * @executionResults@ – 'Nothing' in dry-run mode; otherwise the map of test
--   results keyed by test name.
-- * @selected@ – the tests that were selected for execution (used for stats).
-- * @foundCount@ – total number of @.test@ files discovered on disk.
buildReport ::
  [TestCaseDefinition] ->
  Map String UnexecutedReason ->
  Maybe (Map String TestCaseReport) ->
  [TestCaseDefinition] ->
  Int ->
  TestReport
buildReport discovered unexecuted mResults selected foundCount =
  let mCategoryResults = fmap (groupByCategory selected) mResults
      stats = computeStats foundCount (length discovered) (length selected) mCategoryResults
   in TestReport
        { trDiscoveredTestCases = discovered,
          trUnexecuted = unexecuted,
          trResults = mCategoryResults,
          trStats = stats
        }

-- ---------------------------------------------------------------------------
-- Grouping and category reports
-- ---------------------------------------------------------------------------

-- | Group a flat map of test results into a map of 'CategoryReport' values,
-- one per category.
--
-- Co-Author : (c) 2026 Google Gemini
--                 2026 OpenAI ChatGPT
--
-- This function takes a flat 'Map' of test results and reorganizes them into
-- a map of 'CategoryReport' values, one per unique category found in the test
-- definitions, for each test result, the function looks up the test's definition
-- to find its category and point value, then accumulates the results into
-- the appropriate category bucket.
--
-- Each 'CategoryReport' contains:
--
-- * @crTotalPoints@ – the sum of all point values for tests in this category
-- * @crPassedPoints@ – the sum of point values for only the tests that passed
-- * @crTestResults@ – a map of all test results in this category (indexed by name)
--
-- The @definitions@ list is used to look up each test's category and points.
-- If a test result references a test name not in the definitions, it is silently
-- skipped (this should not happen in normal operation).
groupByCategory ::
  [TestCaseDefinition] ->
  Map String TestCaseReport ->
  Map String CategoryReport
groupByCategory definitions results =
  -- build a lookup table: test name -> test definition
  let defMap = Map.fromList [(tcdName def, def) | def <- definitions]
      -- fold over test results, accumulating categories
      categoryMap = Map.foldlWithKey' (\acc testName testResult ->
        -- look up this test's definition
        case Map.lookup testName defMap of
          Nothing -> acc  -- test not found; skip it
          Just def ->
            let category = tcdCategory def
                points = tcdPoints def
                -- determine if test passed and how many points it earned
                isPassed = tcrResult testResult == Passed
                passedPoints = if isPassed then points else 0
            in Map.insertWith
                 -- merge logic: combine a new category report with an existing one
                 (\new old ->
                   CategoryReport
                     { crTotalPoints = crTotalPoints old + crTotalPoints new,
                       crPassedPoints = crPassedPoints old + crPassedPoints new,
                       crTestResults = Map.union (crTestResults new) (crTestResults old)
                     })
                 category
                 -- new category report for this test
                 (CategoryReport
                   { crTotalPoints = points,
                     crPassedPoints = passedPoints,
                     crTestResults = Map.singleton testName testResult
                   })
                 acc
        ) Map.empty results
   in categoryMap

-- ---------------------------------------------------------------------------
-- Statistics
-- ---------------------------------------------------------------------------

-- | Compute the 'TestStats' from available information.
--
-- Co-Author : (c) 2026 OpenAI ChatGPT
--
-- This function assembles statistics about test discovery, loading, selection,
-- and execution, it requires four input parameters:
--
-- * @foundCount@ – the total number of @.test@ files discovered on disk,
-- * @loadedCount@ – the number of tests successfully parsed from those files,
-- * @selectedCount@ – the number of tests that passed the filtering phase,
-- * @mCategoryResults@ – the category reports (available unless in dry-run mode).
--
-- The statistics computed include:
--
-- * number of tests that passed (computed from category results, or 0 in dry-run),
-- * a histogram of per-category success rates (computed from category results).
--
-- In dry-run mode, @mCategoryResults@ is 'Nothing', so the passed test count is 0
-- and the histogram contains all ten bins with count 0.
computeStats ::
  -- | Total @.test@ files found on disk.
  Int ->
  -- | Number of successfully parsed tests.
  Int ->
  -- | Number of tests selected after filtering.
  Int ->
  -- | Category reports (Nothing in dry-run mode).
  Maybe (Map String CategoryReport) ->
  TestStats
computeStats foundCount loadedCount selectedCount mCategoryResults =
  let (passedCount, histogram) =
        case mCategoryResults of
          Nothing ->
            -- dry-run mode: no execution, so no passed tests and histogram with all zeros
            (0, Map.fromList [(show (i `div` 10 :: Int) ++ "." ++ show (i `mod` 10 :: Int), 0) | i <- [0..9]])
          Just categoryResults ->
            -- normal mode: count passed tests and compute histogram
            let passedTests = 
                  sum [length (filter (\r -> tcrResult r == Passed) (Map.elems (crTestResults cat))) 
                       | cat <- Map.elems categoryResults]
                histogramResult = computeHistogram categoryResults
             in (passedTests, histogramResult)
   in TestStats
        { tsFoundTestFiles = foundCount,
          tsLoadedTests = loadedCount,
          tsSelectedTests = selectedCount,
          tsPassedTests = passedCount,
          tsHistogram = histogram
        }

-- ---------------------------------------------------------------------------
-- Histogram
-- ---------------------------------------------------------------------------

-- | Compute the success-rate histogram from the category reports.
--
-- Co-Author : (c) 2026 Google Gemini
--
-- This function analyzes the pass rate of each category and distributes them
-- into histogram bins, for each category, the pass rate is computed as:
--
-- @rate = passed_test_count \/ total_test_count@
--
-- The rate is mapped to a bin key (@\"0.0\"@ through @\"0.9\"@) and the count
-- of categories in each bin is accumulated, all ten bins are always present in
-- the result, even if their count is 0.
--
-- __Note on interpretation:__ A rate of 1.0 (100% pass rate) maps to the @\"0.9\"@
-- bin, not @\"1.0\"@, because the bins represent intervals @[0.0, 0.1)@, @[0.1, 0.2)@,
-- etc., up to @[0.9, 1.0]@.
--
-- __Edge case:__ If a category has 0 tests, the rate is treated as 0.0, mapping
-- to the @\"0.0\"@ bin.
computeHistogram :: Map String CategoryReport -> Map String Int
computeHistogram categories =
  -- initialize all ten bins to 0
  let emptyHistogram = 
        Map.fromList [(show (i `div` 10 :: Int) ++ "." ++ show (i `mod` 10 :: Int), 0) | i <- [0..9]]
      -- fold over categories, incrementing the appropriate bin for each
      finalHistogram = Map.foldl' (\acc cat ->
        -- count total and passed tests in this category
        let totalTests = length (crTestResults cat)
            passedTests = length (filter (\r -> tcrResult r == Passed) (Map.elems (crTestResults cat)))
            -- compute pass rate (0.0 if no tests)
            rate = if totalTests == 0 then 0.0 else fromIntegral passedTests / fromIntegral totalTests
            -- map rate to bin key
            bin = rateToBin rate
        -- increment the bin for this category
        in Map.adjust (+ 1) bin acc
        ) emptyHistogram categories
   in finalHistogram

-- | Map a pass rate in @[0, 1]@ to a histogram bin key.
--
-- Bins are defined as @[0.0, 0.1)@, @[0.1, 0.2)@, ..., @[0.9, 1.0]@.
-- A rate of exactly @1.0@ maps to the @\"0.9\"@ bin.
rateToBin :: Double -> String
rateToBin rate =
  let binIndex = min 9 (floor (rate * 10) :: Int)
      -- Format as "0.N" for bin index N
      whole = binIndex `div` 10
      frac = binIndex `mod` 10
   in show whole ++ "." ++ show frac
