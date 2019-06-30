# Algebraic structures

A loosely organized set of notes about algebraic data types, written on a 24+ hour plane ride.

Notes:

- Code is either written in Haskell or Haskell-like pseudocode. I generally replace algebraic symbols with explicit names.
- Some of my observations and comments are obvious / banal as I don't have a background in category theory, so please ignore those.
- These are my personal notes and as such are likely to have glaring inaccuracies. I'll attempt to correct these over time.

## What are structures?

A structure is an n-ple of *sets* and binary *operations*. At a bare minimum (magma), they are a tuple of a single set and a single binary operation. On a higher level, rings are n-ples of a single set, one or more operations, and one or more special elements from the set with specific properties.

Operations must be closed, meaning that all possible outputs must themselves be members of the set the operation operates on. For example, subtraction over the set of positive integers is not closed, as negative numbers (which are not set members) can be produced.

A specific structure has some constraint or property on the set and/or the operation. For example, monoids require the existince of a particular element within the set, while groups require the operation to behave a certain way.

In the context of code (specifically Haskell), sets generally correspond to *types*, and operations are functions that operate on that type. For example, `Number` is a type that corresponds to the set of all integers. `[x]` is a type that corresponds to the set of all possible lists of `x`. (It's not a perfect analogy, but is enough for now.)

Similarly to how sets correspond to types, structures correspond to *typeclasses*. For example, `(x, (++), [])` can be described as a monoid over the set `[x]` or an instance of the `Monoid` typeclass for the list type. The typeclass defintion is basically the parameterized structure definition, and a typeclass `instance` is the structure defined for a particular type.

Numbers, strings, and sets are common example types used to express and grok structures. However, there's a discrepancy between category theory sets and Haskell (or any typed) sets, as sets in category theory are not parameterized (they're basically all `Set any`s).

Remember that structures are, at minimum, a tuple of a set and an operation; similarly, an instance of a typeclass is at minimum a tuple of a type and a function. Many types form many valid structure (or have many instances of typeclasses) via its functions. Thus, in Haskell we use `newtype` to identify which structure we're referring to.

## General Syntax and Terminology

- `A x A`: Cartesian product of all terms in a set. All possible tuples of `(A, A)`. Analogue: product type.
- `u`: Identity element. Formally, an element that is neutral under a given binary operation. `(x * u == u * x == x)` Also known as the *unit* and sometimes simply written as `1`. Examples:
  - `1` is the identity for the monoid `(Num, (*), 1)`
  - `[]` is the identity for the monoid `([a], (++), [])`
- Annihilator: `(x * 0 == 0 * x == 0)`. Sometimes simply written as `0`.
- `\\`: Set deletion. `A \ x` means set `A` without element `x`.
- `-`: Additive inverse function. `('') :: Monoid a => a -> a` Examples:
  - `\x -> x + (-1)` for the group `(Num, (+), 0)`
- `'`: Multiplicative inverse function, or 'complement'. `('') :: Monoid a => a -> a` Examples:
  - `\x -> x * 1 / x` for the group `(Num \ 0, (*), 1)`
- `*` and `+`: Generic binary operators. They don't imply operation on numbers, and are only labeled as such via analogy to the integer monoid's addition and multiplication operation (as those are easy to grok).
  - Like addition, `+` is treated as commutative, with 0 being the identity and `-` being the inverse.
  - Like multiplication, `*` is treated as commutative, with 1 being the identity, 0 being the annihilator, and `'` being the inverse. `*` distributes over `+`.
- Domain / codomain: analogues to input and output type (singular -- remember our scope is limited to binary operations).
- Isomorphism: Within category `C`, `f :: (C a, C b) => a -> b` is an isomorphism if there exists an inverse `g :: (C a, C b) => b -> a` such that `f . g` and `g . f` are the identity function of their respective types. `g` can also be written as `f^-1`.

## Properties

### Distributive
- `(x * (y + z)) = x * y + x * z`
- Qualification for rings: operation A is distributed over B; akin to a map
- Examples
  - Quasiring where the two monoids are `(Num, (+), 0)` and `(Num, (*), 1)`

### Associative
- Where order of operation doesn't matter; or, when order of reduction of terms doesn't matter
- `(x * y) * z = x * (y * z)`
- Examples
  - `(+) :: Num a => a -> a -> a`
  - `(*) :: Num a => a -> a -> a`
  - `(++) :: [a] -> [a] -> [a]`

### Commutative
- Where order of **terms** doesn't matter
- `x * y = y * x`
- Also described as *abelian* -- a structure whose operation(s) are commutative

### Idempotent
- When describing elements, an element is idempotent with respect to an operation if `x (operation) x == x`
- When describing operations, an operation is idempotent if `x (operation) x == x` for every `x` in the set.
- If a structure has an identity or an annihilator, those elements are idempotent.
- Where element is unchanged when operation is applied to element
- `x * x = x`

### Closed
- When describing sets, a set is closed when all results of a binary operation on elements of a set are also in the set.
- Numbers are not a closed set with addition because for any set of numbers, the largest element in the set `succ` 1 will never be in the set.

### Trivial
- Where a structure (set) only has a single element

## Simple structures

### Sets

A structure `S` with no operations.

## Group-likes

### Magma

A set with a binary operation. Specifically, a tuple `(Set s, Operation :: Set s => s -> s -> s)`

```haskell
(magma) a => a -> a -> a
```

### Semigroup

A magma where the operation is also associative.

#### Constraints

- Set
  - None
- Operation
  - Associative

#### Notes

- One immediate use case for semigroups in CS / programming is that semigroups are left- and right-foldable identically, because their operation is associative. Note that any magma is foldable; however, without the associativity property, the result of a left fold might not equal that of a right fold.
  - Addition of elements from the set including negative numbers is the easiest example.
  - Tree traversal folding differ based on if traversal is pre- or post-order.
- A semigroup *homomorphism* is a function that preserves semigroup structure of two semigroups across one or more sets, such that a function `f :: Semigroup a, b => a -> b` exists where `f(a*b) == f(a) * f(b)`
  - Looks familiar? Spoiler alert: Let `a :: y -> z` and `b :: x -> y`. What function `f` provides a homomorphism for `a` and `b` when `*` is `.` (function composition)?
  - `f :: Functor f => a -> b -> f a -> f b`, where `f(a . b) == f(a) . f(b)`. What's `f`? It's `fmap`!
  - Specifically, functors are morphisms between categories.

```haskell
(semigroup) a => a -> a -> a

-- For all elements x, y, z from set a...
-- x `semigroup` (y `semigroup` z)
-- ...is equivalent to...
-- (x `semigroup` y) `semigroup` z
```

### Monoid

A semigroup where the set has a two-sided identity (gives counterpart when passed as both first or last argument to morphism).

#### Constraints

- Set
  - Identity
- Operation
  - Associative

#### Examples

- `(Number, (+), 0)`
- `(Number \ 0, 0, (*), 1)`
  - `0 :: Number` is not a part of this set, as `0 * id != id`
  - Note, however, that this is a semigroup as it is associative, and is a magma.
- `(Number, (max), 0)`
- `(Finite set of numbers, (min), max)`
- `(Set x, (and), Set x)`
- `(Set x, (or), Set ())`
- Boolean monoids `Any :: Bool -> Any` and `All :: Bool -> All`
- Maybe monoids `First :: Maybe a -> First a` and `Last :: Maybe a -> Last a`

#### Functions

- `<> :: Semigroup a => a -> a -> a`: the boolean combinator from `Semigroup`
- `mempty :: a`: the identity element

#### Notes

- A semigroup that is not a monoid can be turned into a monoid if an identity element is added. It also follows that any monoid where the identity is removed because a semigroup that isn;t a monoid. E.g., `Nat \ {0,1}, (*)` is a semigroup but not a monoid.
- Similarly, a semigroup can be derived from any monoid by simply removing the identity element.
- While semigroups that aren't monoids don't have "true" identities, they can have one-sided identities, e.g. `x (semigroup) y == x` but `y (semigroup) x != x`, etc. A "true" (loose term) identity is two-sided.
  - As an example, `(Number, \a b -> 2*a + b)` would not form a valid monoid, as no two-sided identity exists. (The left identity is `0` while no right identity exists.)
- As previously mentioned, functors are a `(Monoid A, Monoid B, fmap, id)`.

```haskell
(monoid) a => a -> a -> a
id :: a

-- For all elements x from set a...
-- x `monoid` id == x
-- x `monoid` id == id `monoid` x is trivial as monoids are semigroups
```

### Group

A monoid where the operation has an inverse.

#### Constraints

- Set
  - Identity
- Operation
  - Associative
  - Has inverse

```haskell
(group) a => a -> a -> a
inverse a => a -> a

-- For all elements x from set a...
-- x `group` inverse x == id
-- Note that while x `group` inverse x is commutative, (group) need not be
-- commutative for other terms. For that, see below!
```

### Abelian group

A group where the operation is also commutative.

#### Constraints

- Set
  - Identity
- Operation
  - Associative
  - Has inverse
  - Commutative

#### Notes

- One common example of an associative but non-commutative operation is matrix multiplication.

```haskell
(abelianGroup) a => a -> a -> a

-- For all elements x from set a...
-- x `abelianGroup` y == y `abelianGroup` x
```

### Idempotent group

A group where the operation is idempotent. Or, a group where the operation applied to any element in the group returns the element.

#### Constraints

- Set
  - Identity
  - Trivial
- Operation
  - Associative
  - Has inverse
  - Idempotent

#### Examples

- `(0, (*), 0)`
- `(0, (+), 0)`
- `[], (++), []`

#### Notes

Note that the identity element is by definition the only element in the trivial set.

The reason why the set has to be trivial can be proven thus:

1. Groups must have an identity. `x (op) id == x`, and `id (op) x == id`.
2. Because `id` is a commutative element, `id (op) x == x`. Hence, `id == x`.
3. Groups must have an inverse. `x (op) inverse x == id`. This is also commutative, so following above logic, `inverse x == x`.
4. The operation in idempotent groups thus must give both the identity and the inverse for every element, and every element must give itself. The only valid group is the group for which the set is trivial and only contains the identity for the operation, as a monoid's identity is unique, and inverse pairs are also unique.

However, because this depends on both identity and inverse, idempotent magmas and monoids need not also be trivial.

```haskell
id (idempotentGroup) id = id
```

## Ring-likes

### Quasiring

Two monoids that share a set where:

1. one monoid's operation (named "addition") *distributes* over the other monoid's (named "multiplication")
2. the addition monad's identity element is the multiplication monad's annihilator, such that `x + id == x` and `x * id == id`

#### Constraints

- Addition
  - Monoid
- Multiplication
  - Monoid

#### Examples

- `(Number, (+), (*), 0, 1)` is a quasiring composed of the monoids `(Number, (+), 0)` and `(Number, (*), 1)`. `1 + 0 == 1` and `1 * 0 == 0`.
- `([x], (++), (matrixMult), [], [1])` is a quasiring composed of the monoids `([x], (++), [])` and `([x], (matrixMult), [1]  )`
- `(Set x, (or), (and), Set (), Set x)`.

```haskell
set1 `and` (set2 `or` set3) == (set1 `and` set2) `or` (set1 `and` set3)
```

### Nearring

A quasiring where the addition monoid is a group (has an inverse).

#### Constraints

- Addition
  - Monoid
  - Inverse
- Multiplication
  - Monoid

### Semiring

A quasiring where the addition monoid is commutative. Intuitively, it can be understood as any type where addition and multiplication behave "as expected" like numbers.

Also known as a rig (a ring with no *n*egative).

#### Constraints

- Addition
  - Monoid
  - Commutative
- Multiplication
  - Monoid

#### Notes

The integer monoids addition and multiplication are sort of the canonical semiring example, as it's easy to understand. However, note that not all addition and multiplication operations on sets form semirings; for example, vector addition is a commutative monoid, but vector multiplication does not have a single identity function and thus does not fulfill the criteria.

```haskell
class Semiring a where
  -- Commutative identity
  zero :: a
  -- Associative identity
  one  :: a
  -- Commutative operation
  (+)  :: a -> a -> a
  -- Associative operation that distributes over commutative operation
  (*)  :: a -> a -> a
```

### Rng

A ring with no *i*dentities; or, a quasiring with two semigroups.

#### Constraints

- Addition
  - Semigroup
- Multiplication
  - Semigroup

### Ring

A quasiring where the addition monoid is a commutative group (abelian group). Or, a quasiring that's also a nearring and semiring. Or, a quasiring where addition is an abelian group.

#### Constraints

- Addition
  - Monoid
  - Inverse
  - Commutative
- Multiplication
  - Monoid

### Division algebra

A ring with multiplicative inverse. Or, a quasiring where addition is an abelian group and multiplication is a group.

#### Notes

The multiplicative inverse `'` operates on set `A` with the additive identity removed (as it is the multiplicative annihilator, which cannot be inverted).

#### Constraints

- Addition
  - Monoid
  - Inverse
  - Commutative
- Multiplication
  - Monoid
  - Inverse

### Field

A division algebra with commutative multiplication. Or, a ring where both monoids are abelian groups.

#### Constraints

- Addition
  - Monoid
  - Inverse
  - Commutative
- Multiplication
  - Monoid
  - Inverse
  - Commutative

## Lattice-likes

### Semilattice

A magma where the operation is commutative, associative, and idempotent (or a commutative, idempotent semigroup, or an idempotent abelian semigroup).

#### Examples

- `(Bool, (&&))`
- `(Bool, (||))`
- `(Nat \ {0}, (min))`
- `(Nat \ {0}, (max))`
- `(Set x, (and))`
- `(Set x, (or))`

#### Notes

Just like how the monoids in a ring are termed 'addition' and 'deletion', the first semilattice of each set is termed `/\\`, 'meet', or 'and', while the second is termed `\/`, 'join', or 'or'.

### Lattice

Two semigroups that share a set where:

1. the semigroups' operations satisfy *absorption laws* (or, the semigroups are meet and join).
2. the semigroups are both idempotent and commutative

#### Constraints

- Addition
  - Semigroup
  - Commutative
  - Idempotent
- Multiplication
  - Semigroup
  - Commutative
  - Idempotent

#### Examples

- `(Boolean, (&&), (||))`
- `(Nat, (min), (max))`
- `(Set x, (and), (or))`

#### Notes

Note the similarity to semirings. Here, the both structures are commutative (whereas only addition is for semirings), and both structures do not need identities (or, do not have to be monoids). As a new constraint, both have to be idempotent.

A lattice is similar to two semilattices that relate to each other (in terms of absorption laws), like how semirings are two monoids that relate to each other (in terms of distribution).

For all lattices, `x /\ (x \/ y) == x \/ (x /\ y) == x`

```haskell
-- Demonstrating (Boolean, (&&), (||) is a lattice
False || (False && True) == False
False && (False || True) == False
True || (True && False) == True
True && (True || False) == True

-- Demonstrating (Nat, (min), (max)) is a lattice
0 `min` (0 `max` 1) = 0
0 `max` (0 `min` 1) = 0
1 `min` (1 `max` 0) = 1
1 `max` (1 `min` 0) = 1
-- can prove rest via induction
```

### Bounded lattice

A lattice where the semigroups have identities (or, a lattice where the semigroups are monoids).

#### Examples

- `(Boolean, (&&), (||), False, True)` is a bounded lattice
- The `Nat` and `Set` lattices cannot be bounded, because the identity for `\/` is either infinity or the infinit set.
  - `x :: Nat \/ y == x` for all `x` only if `y` is infinity

### Complemented lattice

A bounded lattice where each element has a complement `'`.

Again, booleans are a good example.

### Boolean algebra

A bounded lattice where each element has a complement, the operations distribute over each other, and there is an *implication* operation `=>` (not to be confused with the Haskell syntax for parameterized types).

The implication is distributed over `/\\` and `\/`. `x => x = id`

## References

- https://argumatronic.com//posts/2019-06-21-algebra-cheatsheet.html
- Wikipedia pages on category theory, monoids, semigroups
- [Leinster, T. (2017). *Basic category theory.* Cambridge: Cambridge University Press.](https://arxiv.org/pdf/1612.09375.pdf)
