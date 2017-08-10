# Recursion

## Syntax

* `go` -- a tail-recursive worker function, can be used to simulate loops

```haskell
factorial n
  | n < 2   = 1
  | otherwise = factorial (n - 1) * n

factorial n = go n 1
  where
  go n accumulator
    | n > 1     = go (n - 1) (res * n)
    | otherwise = accumulator
```

## Exercises

```haskell
replicate' :: Int -> a -> [a]
replicate' 0 _ = []
replicate' n a = a : replicate' (n - 1) a

getAt :: [a] -> Int -> a
getAt (x:_) 0  = x
getAt (_:xs) n = getAt xs (n - 1)

zip' :: [a] -> [b] -> [(a, b)]
zip' [] _ = []
zip' _ [] = []
zip' (x1:xs1) (x2:xs2) = (x1,x2) : zip' xs1 xs2
```