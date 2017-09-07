# Lists II

## Syntax

* `..` -- same as Ruby. `[1..10]` = list of numbers from 1 to 10
* `[0..]` is an infinite list of integers from 0 to infinity
  * `take 10 [0..]` would throw an error in an eagerly evaluated language, because `[0..]` has to be evaluated before running `take` on it.
  * Can chain functions arbitrarily as long as the final function only takes a finite subset: `take 10 (map doubleList [0..])`

## Currying

* `->` -- function signature arrow is **right associative**. Essentially, it means that passing an incomplete amount of arguments returns a function that accepts the remaining arguments. In other words, functions are **automatically curried**.

## Pure & Lazy

As a pure language, compiler makes most of decisions on when to evaluate

As a lazy language, an expression usually doesn't evaluate until its value is needed (e.g. accessed)

## Exercises

```haskell
takeInt :: (Eq a, Num a) => a -> [t] -> [t]
takeInt 0 _      = []
takeInt _ []     = []
takeInt n (x:xs) = x : (takeInt (n - 1) xs)

dropInt :: (Eq a, Num a) => a -> [t] -> [t]
dropInt 0 list   = list
dropInt _ []     = []
dropInt n (_:xs) = dropInt (n - 1) xs

sumInt :: (Eq a, Num a) => [a] -> a
sumInt []     = 0
sumInt (x:xs) = x + sumInt xs

scanSum :: (Eq a, Num a) => [a] -> [a]
scanSum []     = []
scanSum (x:[]) = [x]
scanSum (x:xs) = x : scanSum ((x + head xs) : tail xs)
-- alternatively, use pattern matching
-- cleaner / clearer because head and tail need to check for empty list
-- scanSum (x1:x2:xs) = x1 : scanSum ((x2 + xs) : xs)

diffs :: (Eq a, Num a) => [a] -> [a]
diffs []         = []
diffs (x:[])     = [x]
diffs (x1:x2:[]) = (x1 - x2) : []
diffs (x1:x2:xs) = (x1 - x2) : diffs (x2:xs)
```

## `map`

```haskell
applyToInt :: (Integer -> Integer) -> [Integer] -> [Integer]
applyToInt _ [] = []
applyToInt f (x:xs) = (f x) : applyToInt f xs

applyToString :: (String -> String) -> String -> String
-- etc.

map :: (a -> b) -> [a] -> [b]
-- generic version
```

## Exercises II

```haskell
import Data.List

negation :: Int -> Int
negation x = (- x)

mapNegation :: [Int] -> [Int]
mapNegation = map negation
mapNegation' = map (\x -> (- x))

tupleCount :: String -> (Int, Char)
tupleCount string = (length string, head string)

runLengthEncoding :: String -> [(Int, Char)]
runLengthEncoding = (map tupleCount) . group

tupleToString :: (Int, Char) -> String
tupleToString (0, _) = []
tupleToString (n, c) = c : tupleToString (n - 1, c)

runLengthDecoding :: [(Int, Char)] -> String
runLengthDecoding = concat . (map tupleToString)

last' :: [a] -> [a]
last' []     = error "Empty list"
last' (x:[]) = []
last' (x:xs) = x : last xs
```