# Types

## Definitions

* `::` - a type signature

## GHCI

* `:type` is like `typeof`

## Type signatures in GHCi

```haskell
let xor :: Bool -> Bool -> Bool; xor a b = (a || b) && not (a && b)
```

## Introductory Types

```haskell
:type True
-- True :: Bool

:t 'a'
-- 'a' :: Char

:t "a"
-- "a" :: [Char]
-- double quoted characters are strings, which are lists of characters

:t 'hello world'
-- Error! Single quotes are for chars only

:t "hello world"
-- "hello world" :: [Char]

:t 1
-- 1 :: Num t => t

:t 1.1
-- 1.1 :: Fractional t => t
```

## Functional Types

A function's type is composed of its input and output types

```haskell
myAdd x y = x + y
:t myAdd
-- myAdd :: Num a => a -> a -> a
```

## Type inference

Example 1: `myfun c = c == 'c'`

1. Haskell knows that the output of `x == y` must be a boolean.
2. Haskell knows that `c` is being compared to `'c'` so it must share a type. Thus, `c` is a char.

Therefore: `myfun :: Char -> Bool`

Example 2: `myfun a b = a == b`

1. Same as 1. above
2. Haskell knows that types that implement `==` are of the type class `Eq`
3. Thus, the type signature is **polymorphic**, with the restriction that `a` must fulfill `Eq`. here, `a` is a **type variable**.

Therefore: `myfun :: Eq a => a -> a -> Bool`

Example 3: `myfun2 n = n == 1`

In some cases GHC doesn't have perfect information, so makes informed guesses, or gives flexible types:

Therefore:  `myfun2 :: (Eq a, Num a) => a -> Bool`

## Use of types

1. Readability
2. Error catching