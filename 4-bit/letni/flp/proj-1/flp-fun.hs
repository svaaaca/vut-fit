--
-- @file flp-fun.hs
-- @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
-- @brief Implementation of the FLP course functional project.
-- @date 2025-03-29
--

import Data.List (intercalate, maximumBy, minimumBy, nub, sort)
import Data.Ord (comparing)
import System.Environment (getArgs)

-- decision tree type representation
data DecisionTree
  = Node Int Float DecisionTree DecisionTree
  | Leaf String
  deriving (Eq, Show)

-- tuple of integer and decision tree
type TupleDT = (Int, DecisionTree)

-- tuple of float list and string
type TrainDT = ([Float], String)

-- calculation of the initial string indentation
getIndent :: String -> Int
getIndent = length . takeWhile (== ' ')

-- splitting a string into a list using a delimiter
splitOn :: Char -> String -> [String]
splitOn _ ""   = []
splitOn ch str =
  let (x, xs) = break (== ch) str
  in
    x : case xs of
      []     -> []
      (_:ys) -> splitOn ch ys

-- value update in the associative list using key
updateKV :: Eq a => a -> [(a, Int)] -> [(a, Int)]
updateKV key list =
  let found = lookup key list
  in
    case found of
      Just _  ->
        map (\(k, v) -> if k == key then (k, v + 1) else (k, v)) list
      Nothing -> (key, 1) : list

-- recognition of a decision tree node or leaf
lineDT :: String -> TupleDT
lineDT str =
  let n  = getIndent str
      dt = drop n str
  in
    if take 5 dt == "Node:" then
      nodeDT n (drop 6 dt)
    else if take 5 dt == "Leaf:" then
      leafDT n (drop 6 dt)
    else
      error "[lineDT] ERROR: Unknown input format!"

-- node processing
nodeDT :: Int -> String -> TupleDT
nodeDT n str =
  let idx       = takeWhile (/= ',') str
      th        = drop (length idx) str
      index     = read idx :: Int
      threshold = read (drop 1 (dropWhile (== ' ') th)) :: Float
  in
    (n, Node index threshold (Leaf "") (Leaf ""))

-- leaf processing
leafDT :: Int -> String -> TupleDT
leafDT n str = (n, Leaf str)

-- creation of a decision tree from a node list
buildDT :: [TupleDT] -> (DecisionTree, [TupleDT])
buildDT [] = error "[buildDT] ERROR: Empty node list!"
buildDT ((_, Leaf str) : xs) = (Leaf str, xs)
buildDT ((n, Node idx th _ _) : xs) =
  let (left, ys)  = subDT n xs
      (right, zs) = subDT n ys
  in
    (Node idx th left right, zs)

-- creation of a sub decision tree using indentation and node
subDT :: Int -> [TupleDT] -> (DecisionTree, [TupleDT])
subDT _ [] = (Leaf "", [])
subDT indent ((n, dt) : xs)
  | n > indent = buildDT ((n, dt) : xs)
  | otherwise  = (Leaf "", (n, dt) : xs)

-- loading and parsing decision tree from input text
parseDT :: String -> DecisionTree
parseDT str =
  let dt = map lineDT (lines str)
  in
    fst (buildDT dt)

-- single input line classification
classify :: DecisionTree -> [Float] -> String
classify (Leaf str) _ = str
classify (Node idx th left right) flag
  | idx < length flag && flag !! idx <= th = classify left flag
  | idx < length flag                      = classify right flag
  | otherwise                              = "Unknown class"

-- decision tree input classification
classifyDT :: DecisionTree -> String -> String
classifyDT dt str =
  let line = map (map read . splitOn ',') (lines str)
      cls  = map (classify dt) line
  in
    intercalate "\n" cls

-- loading training data
loadData :: String -> [TrainDT]
loadData str = map parseData (lines str)
  where
    parseData input =
      let item = splitOn ',' input
      in
        (map read (init item), last item)

-- counting the specific class frequency in training data
countClass :: [TrainDT] -> [(String, Int)]
countClass dt = getCount dt []
  where
    getCount [] acc              = acc
    getCount ((_, cls) : xs) acc = getCount xs (updateKV cls acc)

-- finding the most common class in training data
commonClass :: [TrainDT] -> String
commonClass dt = fst $ maximumBy (comparing snd) (countClass dt)

-- probabilities of each class in the data list
probability :: [TrainDT] -> [(String, Float)]
probability dt =
  let count = countClass dt
      total = fromIntegral (length dt)
  in
    [(cls, fromIntegral cnt / total) | (cls, cnt) <- count]

-- calculation of the Gini index for a given dataset
indexGini :: [TrainDT] -> Float
indexGini dt =
  let p = probability dt
  in
    1.0 - sum [x * x | (_, x) <- p]

-- data division into two parts by threshold
splitData :: Int -> Float -> [TrainDT] -> ([TrainDT], [TrainDT])
splitData idx th dt =
  let left  = [x | x@(xs, _) <- dt, xs !! idx <= th]
      right = [x | x@(xs, _) <- dt, xs !! idx > th]
  in
    (left, right)

-- calculation of the score of a given distribution (weighted average)
splitScore :: [TrainDT] -> ([TrainDT], [TrainDT]) -> Float
splitScore dt (left, right) =
  let total  = fromIntegral (length dt)
      ratioL = fromIntegral (length left) / total
      ratioR = fromIntegral (length right) / total
  in
    ratioL * indexGini left + ratioR * indexGini right

-- obtaining possible value as threshold for the distribution
obtainTH :: Int -> [TrainDT] -> [Float]
obtainTH idx th =
  let value = [x !! idx | (x, _) <- th]
  in
    nub (sort value)

-- finding the best distribution
bestSplit :: [TrainDT] -> (Int, Float, [TrainDT], [TrainDT])
bestSplit dt =
  let num   = length (fst (head dt))
      split = [(idx, th, splitData idx th dt) 
              | idx <- [0..num-1], th <- obtainTH idx dt]
      best  = minimumBy (\(_,_,s1) (_,_,s2)
              -> compare (splitScore dt s1) (splitScore dt s2)) split
  in
    case best of
      (idx, th, (left, right)) -> (idx, th, left, right)

-- decision tree construction
constructDT :: [TrainDT] -> DecisionTree
constructDT dt
  | null dt = Leaf ""
  | length (nub (map snd dt)) == 1 = Leaf (snd (head dt))
  | otherwise =
      let (idx, th, left, right) = bestSplit dt
      in
        if null left || null right then
          Leaf (commonClass dt)
        else
          Node idx th (constructDT left) (constructDT right)

-- loading and training the decision tree
trainDT :: String -> DecisionTree
trainDT str =
  let dt = loadData str
  in
    constructDT dt

-- formatting and printing the decision tree
printDT :: DecisionTree -> Int -> String
printDT (Leaf cls) indent = replicate indent ' ' ++ "Leaf: " ++ cls
printDT (Node idx th left right) indent =
  replicate indent ' ' ++ "Node: " ++ show idx ++ ", " ++ show th ++ "\n"
  ++ printDT left (indent + 2) ++ "\n"
  ++ printDT right (indent + 2)

-- main program function
main :: IO ()
main = do
  args <- getArgs
  case args of
    ["-1", tree, newData] -> do
      dt <- parseDT <$> readFile tree
      classified <- classifyDT dt <$> readFile newData
      putStrLn classified

    ["-2", trainData] -> do
      dt <- trainDT <$> readFile trainData
      putStrLn (printDT dt 0)

    _ -> do
      putStrLn "Usage:"
      putStrLn "  ./flp-fun -1 <tree_file> <new_data_file>"
      putStrLn "  ./flp-fun -2 <train_data_file>"
