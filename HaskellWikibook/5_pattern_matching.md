# Pattern Matching

## Definitions

## Syntax

* `if`

```haskell
-- guards
myfun x
    | x < 0  = -1
    | x > 0  = 1
    | x == 0 = 0

-- if
myfun x =
    if x < 0
      then -1
      else if x > 0
        then 1
        else 0
```

* Pattern matching
```haskell
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)
```

## Pattern Matching

* Useful when conditionals depend on structure or value, but not on conditionals
* Useful for accessing parts of complex value

```haskell
-- pattern matching
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

-- guards
fib x
    | x <= 1    = 1
    | otherwise = fib (x - 1) + fib (x - 2)

-- if
fib x =
    if x <= 1
      then 1
      else fib (x - 1) + fib (x - 2)
```

All of these can be mixed:

```haskell
contrivedFunc 0 = 0
contrivedFunc 1 = 1
contrivedFunc x
    | x < 10    = x * 2
    | otherwise = x * 3
```

## Bool matching

```haskell
(||) :: Bool -> Bool -> Bool
False || False = False
_     || _     = True
```

## Tuple matching

```haskell
fst :: (a, b) -> a
fst (x, _) = x

snd :: (a, b) -> b
snd (_, x) = x

-- note that fst and snd are only defined for 2-tuples
```

## List matching

```haskell
head :: [a] -> a
head []    = error "Empty List"
head (x:_) = x

tail :: [a] -> [a]
tail []     = error "Empty List"
tail (_:xs) = xs

-- note that empty lists have no head or tail
```
## Pattern Matching Errors

* Patterns must be mutually exclusive: an input cannot match >1 patterns
* Patterns must be exhaustive: all input must match >0 patterns