-- | Filtering test cases by include and exclude criteria.
--
-- The filtering algorithm is a two-phase set operation:
--
-- 1. __Include__: if no include criteria are given, all tests are included;
--    otherwise only tests matching at least one include criterion are kept.
--
-- 2. __Exclude__: tests matching any exclude criterion are removed from the
--    included set.
module SOLTest.Filter
  ( filterTests,
    matchesCriterion,
    matchesAny,
    trimFilterId,
  )
where

import Data.Char (isSpace)
-- | (\\) is the list difference operator, used to compute which tests were filtered out
import Data.List ((\\))
import SOLTest.Types

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

-- | Apply a 'FilterSpec' to a list of test definitions.
--
-- Co-Author : (c) 2026 OpenAI ChatGPT
--
-- Returns a pair @(selected, filteredOut)@ where:
--
-- * @selected@ are the tests that passed both include and exclude checks.
-- * @filteredOut@ are the tests that were removed by filtering.
--
-- The union of @selected@ and @filteredOut@ always equals the input list.
filterTests ::
  FilterSpec ->
  [TestCaseDefinition] ->
  ([TestCaseDefinition], [TestCaseDefinition])
filterTests spec tests =
  let useRegex = fsUseRegex spec
      -- include phase: if no includes, all tests pass; otherwise only those matching an include criterion
      afterInclude =
        if null (fsIncludes spec)
          then tests
          else filter (matchesAny useRegex (fsIncludes spec)) tests
      -- exclude phase: remove tests matching any exclude criterion
      selected = filter (not . matchesAny useRegex (fsExcludes spec)) afterInclude
      filteredOut = tests \\ selected
   in (selected, filteredOut)

-- | Check whether a test matches at least one criterion in the list.
matchesAny :: Bool -> [FilterCriterion] -> TestCaseDefinition -> Bool
matchesAny useRegex criteria test =
  any (matchesCriterion useRegex test) criteria

-- | Check whether a test matches a single 'FilterCriterion'.
--
-- Co-Author : (c) 2026 OpenAI ChatGPT
--
-- The matching rule depends on the criterion type:
--
-- * 'ByAny' – matches if the value equals the test name, appears in the test's
--   tag list, or equals the test's category,
-- * 'ByCategory' – matches only if the value equals the test's category,
-- * 'ByTag' – matches only if the value appears in the test's tag list.
--
-- The first boolean parameter is provided for potential regex extension but is
-- currently ignored (all matching is case-sensitive string equality).
matchesCriterion :: Bool -> TestCaseDefinition -> FilterCriterion -> Bool
matchesCriterion _ test criterion =
  case criterion of
    -- for ByAny: match if it's the name, in the tags, or the category
    ByAny value ->
      value == tcdName test
        || value `elem` tcdTags test
        || value == tcdCategory test
    -- for ByCategory: only match if it's the category
    ByCategory value -> value == tcdCategory test
    -- for ByTag: match if it appears in the tags list
    ByTag value -> value `elem` tcdTags test

-- | Trim leading and trailing whitespace from a filter identifier.
trimFilterId :: String -> String
trimFilterId = reverse . dropWhile isSpace . reverse . dropWhile isSpace
