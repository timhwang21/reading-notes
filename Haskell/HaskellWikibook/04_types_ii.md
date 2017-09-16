# Types II

## Definitions

* Typeclass - group of types

## Syntax

## Numbers

The `Num` type actually encompasses `Fractional`, `Floating`, etc.

### Type of functions that take numbers

Earlier we noticed: `(+) :: Num a => a -> a -> a`

In other words, `Num` is a **typeclass**. `Fractional` etc. are instances of `Num`.

Some instances:

* `Int`: Like 'smallnum'
* `Integer`: Like 'bignum'
* `Float`: 'smalldecimal'
* `Double`: 'bigdecimal'

### Type of numbers themselves

We also noticed: `123 :: Num a => a`

It's not just `+` that is polymorphic, `123` itself is polymorphic!

### Gotchas

While directly inputted numerical values are polymorphic, output of functions that return numbers may not be:

`length :: Foldable t => t a -> Int`

For now, we can consider `length` to only apply to lists:

`length :: [a] -> Int`

This means doing something like this would cause an error:

`divByListLength num list = num / (length list)`

Why?

`(/) :: Fractional a => a -> a -> a`

`1 / 2` works because these are of type `Num a => a`. However, `length` explicitly gives an `Int` which is an instance of `Num`, and cannot be polymorphically used as a `Fractional`.

Solution:

`fromIntegral :: (Integral a, Num b) => a -> b` -- converts an integral into a polymorphic number type.

## Other typeclasses

From the above example, `Foldable` is a typeclass that `[]` belongs to.

We also saw `Eq` from `==`. One note for now is that functions do not belong to `Eq` -- proving two functions are identical is impossible according to Rice's theorem.