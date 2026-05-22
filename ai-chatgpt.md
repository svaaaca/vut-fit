# Využití AI nástroje OpenAI ChatGPT

- **Autor**: David Kvaček (xkvace00@stud.fit.vutbr.cz)
- **Datum**: 2026-04-22

## Typická konverzace (otázka)

A detailed explanation of how the requested `buildFilterSpec` function should work within a Haskell project, though without a specific implementation.

## Typická konverzace (odpověď)

At a high level, buildFilterSpec is a pure “assembly” function: it takes the raw lists of strings produced by the CLI parser and turns them into a properly structured FilterSpec value using the FilterCriterion constructors.

Even without writing code, you can think of it as a normalization step between untyped CLI input and typed internal representation.

⸻

1. What inputs does buildFilterSpec receive?

From filterSpecParser, the function is applied to six lists of String values:

* includeAny :: [String] (from -i / --include)
* excludeAny :: [String] (from -e / --exclude)
* includeCategory :: [String] (from --ic)
* includeTag :: [String] (from --it)
* excludeCategory :: [String] (from --ec)
* excludeTag :: [String] (from --et)

Each list corresponds to a different kind of filtering instruction.

⸻

2. What should the function produce?

It must return a single:

FilterSpec
  { fsIncludes :: [FilterCriterion]
  , fsExcludes :: [FilterCriterion]
  , fsUseRegex :: Bool
  }

So the job is:

1. Convert raw Strings → FilterCriterion
2. Merge them into two final lists:
    * includes
    * excludes
3. Decide what to do with fsUseRegex

⸻

3. Mapping strings to FilterCriterion

Each CLI option maps directly to a constructor:

Include side

CLI flag	Meaning	Constructor
-i, --include	match anything	ByAny
--ic	category only	ByCategory
--it	tag only	ByTag

So conceptually:

map ByAny includeAny
map ByCategory includeCategory
map ByTag includeTag

Exclude side

Same idea:

CLI flag	Constructor
-e, --exclude	ByAny
--ec	ByCategory
--et	ByTag

⸻

4. Combining criteria

After mapping, you simply concatenate the lists:

Includes

fsIncludes =
  map ByAny includeAny
  ++ map ByCategory includeCategory
  ++ map ByTag includeTag

Excludes

fsExcludes =
  map ByAny excludeAny
  ++ map ByCategory excludeCategory
  ++ map ByTag excludeTag

Order usually doesn’t matter unless later logic depends on precedence (in most designs, it doesn’t).

⸻

5. Meaning of empty lists

A subtle but important design rule:

* fsIncludes = [] means “include everything (no restriction)”
* fsExcludes = [] means “exclude nothing”

This is already documented in:

-- | Include criteria. Empty means include all tests.

So buildFilterSpec should not try to “fix” empty lists—just pass them through.

⸻

6. What about fsUseRegex?

You have two possibilities depending on assignment scope:

(A) Regex NOT implemented (most common)

Set a constant:

fsUseRegex = False

(B) Regex extension implemented

Then this flag would come from CLI (not present here), or you’d infer it (not recommended).

So practically: just hardcode False.

⸻

7. Conceptual behavior in the pipeline

It helps to see where this function sits:

CLI args (strings)
      ↓
optparse-applicative
      ↓
[Strings grouped by flags]
      ↓
buildFilterSpec   ← YOU ARE HERE
      ↓
FilterSpec (typed, structured)
      ↓
Filtering engine

So buildFilterSpec is purely about structure, not logic.

⸻

8. Example

CLI input

--include foo --include bar --ic math --et slow

Parsed lists

includeAny       = ["foo", "bar"]
includeCategory  = ["math"]
includeTag       = []
excludeAny       = []
excludeCategory  = []
excludeTag       = ["slow"]

Resulting FilterSpec

FilterSpec
  { fsIncludes =
      [ ByAny "foo"
      , ByAny "bar"
      , ByCategory "math"
      ]
  , fsExcludes =
      [ ByTag "slow" ]
  , fsUseRegex = False
  }

⸻

9. Design philosophy

This function should:

* Be pure and simple
* Do no validation
* Do no filtering logic
* Only perform mechanical transformation

Think of it as a typed constructor helper, not a decision-making function.

⸻

10. Common mistakes to avoid

* ❌ Mixing include/exclude lists together
* ❌ Forgetting to wrap strings with correct constructors
* ❌ Trying to interpret matching semantics here
* ❌ Treating empty includes as “match nothing” (wrong!)
* ❌ Overcomplicating fsUseRegex

⸻

Final intuition

If you strip everything away:

buildFilterSpec just says:
“Take these six buckets of strings and label each string with what it means.”

That’s it.

## Typická konverzace (otázka)

How could the built-in functions mentioned above be used when implementing the required discoverTests function?

## Typická konverzace (odpověď)

When implementing discoverTests, the “hinted” built-in functions are there to help you solve three core subproblems:

1. Distinguish files vs directories
2. Filter only .test files
3. Traverse (optionally recursively) and build results in IO

Let’s walk through how each suggested function fits into that pipeline.

⸻

1. listDirectory + (</>) → building full paths

You already have:

entries <- listDirectory dir
let fullPaths = map (dir </>) entries

This transforms:

["a.test", "subdir", "b.txt"]

into:

["dir/a.test", "dir/subdir", "dir/b.txt"]

So now you can work with real paths, not just names.

⸻

2. doesDirectoryExist → deciding recursion

You need to know whether each path is:

* a directory → maybe recurse
* a file → maybe process

Conceptually:

isDir <- doesDirectoryExist path

Usage pattern

Inside a loop:

if isDir
  then ...
  else ...

Role in recursion

* If recursive == True, call discoverTests again
* Otherwise, ignore directories

⸻

3. takeExtension → filtering .test files

You only want files ending with .test.

takeExtension path == ".test"

This is your file filter condition.

⸻

4. mapM / forM → handling IO lists

This is the most important functional piece.

Problem

You need to:

* Process a list of paths
* Each step produces IO [TestCaseFile] or IO TestCaseFile
* Combine results into a single IO [...]

Solution

Use:

* mapM → transform [a] into IO [b]
* forM → same thing, nicer syntax

⸻

Typical pattern

results <- forM fullPaths $ \path -> do
  isDir <- doesDirectoryExist path
  if isDir
    then ...
    else ...

Each branch must return:

IO [TestCaseFile]

⸻

5. findCompanionFiles → constructing results

Once you detect a .test file:

if takeExtension path == ".test"
  then do
    t <- findCompanionFiles path
    return [t]

Why [t]?

Because your recursive structure works with lists of results, so everything must return [TestCaseFile].

⸻

6. Putting it all together (logic flow)

For each path:

Case 1: Directory

if isDir
  then
    if recursive
      then discoverTests recursive path   -- recurse
      else return []                      -- ignore

⸻

Case 2: File

else
  if takeExtension path == ".test"
    then do
      t <- findCompanionFiles path
      return [t]
    else return []

⸻

7. Flattening the result

After forM, you’ll get:

[[TestCaseFile]]

You need:

[TestCaseFile]

So use:

return (concat results)

⸻

8. Full mental model

The function behaves like:

discoverTests recursive dir =
  for each entry in directory:
    if directory:
      recurse (if allowed)
    if .test file:
      build TestCaseFile
    else:
      ignore
  flatten all results

⸻

9. Why these functions matter

Function	Role
listDirectory	get directory contents
(</>)	build correct paths
doesDirectoryExist	decide recursion
takeExtension	filter .test files
mapM / forM	sequence IO computations
findCompanionFiles	construct final data

⸻

10. Common pitfalls

* ❌ Forgetting to recurse only when recursive == True
* ❌ Returning TestCaseFile instead of [TestCaseFile]
* ❌ Not flattening (concat)
* ❌ Using map instead of mapM (breaks IO)
* ❌ Checking extension before confirming it’s a file (minor but cleaner to separate)

⸻

Final intuition

You’re essentially writing a mini file-system traversal where:

* doesDirectoryExist decides where to go
* takeExtension decides what to keep
* mapM stitches all the IO actions together
* findCompanionFiles builds your final structured result

If you think in those four roles, the implementation becomes straightforward.

## Typická konverzace (otázka)

When implementing the matchesAny function, what elegant solutions are available for situations where the first boolean parameter, useRegex, is not used within the function body?

## Typická konverzace (odpověď)

This is a classic small Haskell design question: what do you do with a parameter that exists for API completeness but isn’t (yet) used? There are several clean, idiomatic options—some better than others depending on your goals.

⸻

1. The simplest and most idiomatic: prefix with _

If you’re not implementing regex support, the cleanest solution is:

matchesAny :: Bool -> [FilterCriterion] -> TestCaseDefinition -> Bool
matchesAny _ criteria test =
  any (matchesCriterion False test) criteria

or even:

matchesAny _ criteria test =
  any (matchesCriterion False test) criteria

Why this is good:

* _ explicitly signals: “this parameter is intentionally unused”
* avoids compiler warnings
* keeps the type signature unchanged (important for assignment consistency)

⸻

2. Pass it through but ignore it downstream

Since matchesAny already passes useRegex to matchesCriterion, the real unused parameter problem is actually in matchesCriterion, not here.

So a more consistent approach is:

matchesAny useRegex criteria test =
  any (matchesCriterion useRegex test) criteria

and then inside matchesCriterion:

matchesCriterion _ test criterion = ...

Why this is better:

* preserves the intended design
* keeps future regex support trivial to add
* avoids “hardcoding False” in multiple places

👉 This is usually the best practical solution.

⸻

3. Use a wildcard pattern with a named variable (rare but valid)

If you want readability while still ignoring:

matchesAny useRegex criteria test =
  let _ = useRegex
  in any (matchesCriterion False test) criteria

This is technically valid but not idiomatic—it’s more of a workaround.

⸻

4. Remove the parameter entirely (only if allowed)

If the assignment explicitly allows it:

matchesAny :: [FilterCriterion] -> TestCaseDefinition -> Bool

But this requires:

* changing all call sites
* modifying FilterSpec logic expectations

👉 Usually not recommended unless the instructions explicitly say so.

⸻

5. Pattern matching trick (less common but elegant)

You can also pattern-match directly in arguments:

matchesAny _ criteria test =
  any (matchesCriterion False test) criteria

This is essentially the same as option #1, just reinforcing that _ is the idiomatic choice.

⸻

6. What NOT to do

Avoid:

matchesAny useRegex criteria test =
  if useRegex
    then any (matchesCriterion useRegex test) criteria
    else any (matchesCriterion useRegex test) criteria

This:

* uses the variable but adds no meaning
* is misleading
* defeats clarity

⸻

Final recommendation

The cleanest and most future-proof approach is:

matchesAny useRegex criteria test =
  any (matchesCriterion useRegex test) criteria

and then in matchesCriterion:

matchesCriterion _ test criterion = ...

This way:

* the API stays consistent
* regex support can be added later without refactoring
* unused parameters are handled idiomatically

⸻

Intuition

Think of useRegex as a feature flag placeholder:

matchesAny should respect the interface,
matchesCriterion decides whether the flag actually matters.

That separation keeps your design clean and extensible.
