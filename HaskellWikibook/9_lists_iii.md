# Lists III

## Syntax

### Folds

#### `foldr`

Right-associative fold; collapses list from right-to-left.

Note that the list is still evaluated left-to-right; "right-to-left" describes the parentheses:
* List is traversed left-to-right
* Function is evaluated left-to-right
* Accumulator is "folded" with argument **right-to-left**

`foldr` can evaluate infinite lists if `f` is not strict. A **strict** function is one that requires both arguments to evaluate.

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f acc []     = acc
foldr f acc (x:xs) = f x foldr (f acc xs)

-- foldr f acc (a:b:c:[]) = f a (f b (f c acc))

1 - (2 - (3 - 6))

--   :                         f
--  / \                       / \
-- a   :       foldr f acc   a   f
--    / \    ------------->     / \
--   b   :                     b   f
--      / \                       / \
--     c  []                     c   acc
```

Notes
* Rule of thumb: the *right* fold is the *right fold* to use!
* When `foldr`ing an infinite list, because the accumulator is applied to the rightmost element, it is actually never used. One convention is to use `undefined` as the accumulator, so the function will error when applied to finite lists.
* While `foldr` can be applied to infinite lists (if the folding function can early exit), it can still overflow when applied to a long, finite list with a strict function. If the function also does not care about order (e.g. `(+)`), `foldl'` can be more performant (see below). Note that left folds cannot short circuit.
* The *left* fold is often *left out*. (Not the *left tick* fold, though!)

#### `foldl` - left-associative fold; collapses list from left-to-right

```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f acc []     = acc
foldl f acc (x:xs) = foldl f (f acc x) xs

-- foldl f acc (a:b:c:[]) = f (f (f acc a) b) c

--   :                            f
--  / \                          / \
-- a   :       foldl f acc      f   c
--    / \    ------------->    / \
--   b   :                    f   b
--      / \                  / \
--     c  []                acc a
```

`foldl` is **tail recursive**, meaning it recurses immediately. If you had a very long list, `foldr` would just give `f x (unevaluated function with acc and xs)`. `foldl` will give the entire uncomputed expansion immediately and will run out of memory. `fold'` is an eagerly evaluated `foldl`.

#### `foldl'` - eagerly evaluated left-associative fold

With finite but very large lists, and a strict function, both `foldr` and `foldl` may lead to stack overflows.
* `foldr` errors because you run out of memory before you get to the rightmost element to start folding
* `foldl` errors because while you start folding from the left, all reduced expressions are created before evaluation is started (lazy)
* `foldl'` solves this by eagerly evaluating the redexes (**red**ucible **ex**pressions)
  * The inner redex is evaluated before the next thunk is created

More: [Haskell wiki](https://wiki.haskell.org/Foldr_Foldl_Foldl')

#### `foldr1`, `foldl1` -  type-strict versions

Treats the starting element as the accumulator.

```haskell
foldr1 :: (a -> a -> a) -> [a] -> a
foldr1 f [x]    = x
foldr1 f (x:xs) = f x (foldr1 f xs)
foldr1 _ []     = error "empty list"

foldl1 :: (a -> a -> a) -> [a] -> a
foldl1 f (x:xs) = foldl1 f x xs
foldl1 _ []     = error "empty list"

#### `foldr` vs. `foldl`

Because the call to `foldr` is within the call to `f`, it can be called on infinite lists.

```haskell
foldr f _ [1..]
-- gives...
f 1 $ foldr f _ [2..]
f 1 $ f 2 $ foldr f _ [3...]
-- if f is a function where the first argument MAY determine the result, e.g. boolean or, can be evaluated
-- the recursive call in foldr is CONDITIONAL on f not 'early returning' on the first argument

foldl f _ [1..]
-- gives...
foldl f (f _ 1) [2..]
foldl f (f (f _ 1) 2) [3..]
foldl f (f (f (f _ 1) 2) 3) [4..]
-- cannot be partially evaluated -- lazy evaluation evaluates the leftmost function first, which always produces another foldl as the leftmost function
-- the recursive call is UNCONDITIONAL -- it is happening no matter what
```

Intuitive explanation:

```haskell
-- foldr over infinite list
f 1 ( f 2 ( f 3 ( ... f n acc ) ... ))

-- foldl over infinite list
f ( f ( f ( ... f acc 1 ) 2 ) 3 ) ... n
```

`foldr` and `foldl` are not 'reverse' of each other:

```haskell
foldr (-) 6 [1,2,3] = (1 - (2 - (3 - 6)))
foldl (-) 6 [3,2,1] = (((6 - 3) - 2) - 1)
```

```haskell
sum :: [Integer] -> Integer
sum []     = 0
sum (x:xs) = x + sum xs
```

### Scans

#### `scanl`, `scanr`, `scanl1`, `scanr1`

Creates a list of progressive folds

```haskell
scanr :: (a -> b -> b) -> a -> [b] -> [a]
scanr f acc xs = foldr (\x xs -> (f (x $ head xs)):xs) [acc] xs

scanl :: (a -> b -> a) -> a -> [b] -> [a]
scanl f acc xs = foldl (\xs x -> xs ++ (f (last xs) x):[])) [acc] cs
```

### Filter

```haskell
filter :: (a -> Bool) -> [a] -> [a]
```

### List comprehensions

```haskell
-- haskell
retainEven xs = [n | n <- xs, isEven n]
```

```python
# python
def retain_even(xs):
  return [n for n in xs if isEven(n)]
```

```ruby
# ruby
# not really a list comprehension, but block syntax is reminiscent
def retain_even xs
  xs.select { |n| isEven n }
end
```

```javascript
// javascript
// completely different
function retain_even(xs) {
  return xs.filter(n => isEven(n));
}
```

Many filter conditions can be applied:

```haskell
foo xs = [n | n <- xs, n `mod` 3 == 0, n `mod` 5 == 0, n < 100 ]
-- foo [1..1000]
-- => [15,30,45,60,75,90]
```

List comprehensions can also map:

```haskell
foo xs = [sqrt n | n <- xs, n < 100]
```

List comprehensions can pattern match:

```haskell
pythagoreanLC :: Floating t => [(t, t)] -> [t]
pythagoreanLC ps = [sqrt (p^2 + q^2) | (p, q) <- ps]

combine xs = [(x0, x1) | x0 <- xs, x1 <- xs]
```

## Exercises

### Folds

```haskell
and' :: [Bool] -> Bool
and' []     = True
and' (x:xs) = x && and xs

and'' = foldr (&&) True

or' :: [Bool] -> Bool
or' []     = False
or' (x:xs) = x || or xs

or'' = foldr (||) False

-- note point-free style
maximum' :: Ord a => [a] -> a
maximum' [] = error "empty list"
maximum'    = foldr1 max

minimum' :: Ord a => [a] -> a
minimum' [] = error "empty list"
minimum'    = foldr1 min

reverse' :: [a] -> [a]
reverse' [] = []
reverse'    = foldl (\xs x -> x:xs) []
```

### List Comprehensions

```haskell
returnDivisible :: Int -> [Int] -> [Int]
-- with list comprehension
returnDivisible divisor ns = [n | n <- ns, mod n divisor == 0]
-- with filter
returnDivisible' divisor ns = filter (\n -> mod n divisor == 0) ns

choosingTails :: [[Int]] -> [[Int]]
choosingTails ls = [tail l | l <- ls, not $ null l, head l > 5]
choosingTails' ls = [xs | (x:xs) <- ls, x > 5]
```
