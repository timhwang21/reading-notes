# Higher-order Functions

Core premise of FP is that functions are values. Higher-order functions are functions that take functions as parameters.

## Example: Quicksort

```haskell
quickSort :: (Ord a) -> [a] -> [a]
quickSort [] = []
quickSort (x:xs) = (quickSort less) ++ [x] ++ (quickSort more)
  where
    less = filter (< x) xs
    more = filter (>= x) xs
```

### `Ord`

The function `compare` must be defined for types `deriving (Ord)`:

```haskell
data Foo = Bar | Baz deriving (Eq, Ord)

compare Bar Bar = EQ
compare Baz Baz = EQ
compare Bar Baz = LT
compare Baz Bar = GT
-- Bar > Baz gives False

-- Alternatively, you can define the <. ==, > operators as shorthand
Bar < Baz = True
(<) Bar Baz = True

-- These operators are something like:
(<) :: (Ord a) => a -> a -> Bool
x < y = x `compare ` y == LT
```

### Adding custom comparators

If we want our quicksort to be flexible, we should allow the user to pass a `compare` function:

```haskell
quickSort' :: (Ord a) => (a -> a -> Ordering) -> [a] -> [a]
quickSort' _ [] = []
quickSort' compare (x:xs) = (quicksort compare less) ++ [x] ++ (quicksirt compare more)
  where
    less = filter (\y -> y `compare` x == LT) xs
    more = filter (\y -> y `compare` x == EQ || y `compare` x == GT) xs

quickSort' compare [1,3,2,5,4]
-- => [1,2,3,4,5]
quickSort' (flip compare) [1,3,2,5,4]
-- => [5,4,3,2,1]
```

### Currying

Note that we can do:

`originalQuickSort = quickSort' compare` which returns a quicksort that uses the default `compare`. Our previously defined quicksort had signature `[a] -> [a]`.

Also note that by adding parenthese, our signature is:

`quickSort' :: (Ord a) => (a -> a -> Ordering) -> (quicksort's signature)`

## Exercises

### For-loop

```haskell
-- Strategy
-- for :: iterator -> end condition for iterator -> iterate the iterator -> make side effect
for :: i -> (i -> Bool) -> (i -> i) -> (a -> IO ()) -> IO ()
for i p f job =
  if p i
    then do
      job i
      for (f i) p f job
    else return ()
```

### `map` with `IO`

```haskell
mapIO :: (a -> IO b) -> [a] -> IO [b]
mapIO _ [] = return []
mapIO f (i:is) = do
  o <- f i
  os <- mapIO f is
  return (o:os)
```

## Other common HOFs

### `flip`

`flip :: (a -> b -> c) -> b -> a -> c`

### `compose`

`(.) :: (b -> c) -> (a -> b) -> a -> c`

### `apply`

`($) :: (a -> b) -> a -> b` -- note that while this seemingly does nothing, it has lower priority than normal, so it can be used to break precedence:

```haskell
func1 (func2 foo)
func1 $ func2 foo
-- these two are identical
```

Also, because `$` *applies functions*, it can be used to do a "reverse map", where a value is mapped over several functions:

```haskell
map ($ [1,2,3]) [take 2, drop 2, reverse]
-- [[1,2], [3], [3,2,1]]
```

### `uncurry`

`uncurry :: (a -> b -> c) -> (a, b) -> c`

Converts a binary function into a unary function that takes a 2-tuple.

### `curry`

`curry :: ((a, b) -> c) -> a -> b -> c`

### Identities

`id :: a -> a`
`const :: a -> b -> a`
