# Pattern Matching II

Pattern matching **matches** values against **patterns** and **binds** variables to successful matches.

```haskell
map _ []     = []
map f (x:xs) = f x : map f xs
```

* `_` is a wildcard; it does not bind (does not assign to `_`)
* `[]` matches the empty list; it does not bind
* `f` is a binding wildcard
* `(x:xs)` matches a non-empty list and binds to `x` and `xs`

## Syntax

The most basic match is matching literals:

```haskell
fooFunc 1 = 2
fooFunc 'a' = 'b'
fooFunc _ = []
-- preview: True and False aren't literals in Haskell
-- instead they are data types Bool = False | True
```

Patterns can also be expressions. `(x:xs)` is a valid pattern and uses the cons function. However, not all functions are permitted in patterns; only **type constructors** are permitted.

```haskell
data Foo = Bar
         | Baz Int

fooFunc = Foo -> Int
fooFunc Bar     = 1
fooFunc (Baz n) = n
```

### Pattern matching lists

Lists are *sort of* like the following data type:

```haskell
-- pseudocode
data List   = EmptyList | NonEmptyList
type []     = EmptyList
type (x:xs) = NonEmptyList

listFunc []     = something
listFunc (x:xs) = something else
```

Therefore, when matching against lists, we can match against the two list constructors, `[]` and `(x:xs)`.

Earlier we saw the pattern `(x1:x2:xs)`. As `:` is the list constructor that is perfectly valid.

### Pattern matching tuples

Acts similarly to lists, but with set parameter count

```haskell
norm3D :: (Floating a) => (a, a, a) -> a
norm3D (x, y, z) = sqrt (x^2 + y^2 + z^2)
```

### Pattern matching literals

Things like integers and chars can be used in pattern matching:

```haskell
badCaps :: String -> String
badCaps ('a':xs) = 'A':xs
badCaps ('b':xs) = 'B':xs
badCaps _        = "Dunno"
```

Note that `True` and `False` are NOT literals!

`data Bool = True | False`

### Pattern matching different types

Haskell (intentionally?) makes it difficult to pattern match on drastically different types, e.g. matching on a `String` OR a `Int`. One alternative that also aids documention and clarity is to define a more specific data type.

```haskell
-- bad
-- note: not a valid type signature
truncateYearsBad :: (String || Int) -> String
truncateYearsBad (String) = drop 2
truncateYearsBad (Int) = (`mod` 100) -- (operators can be curried in either direction)

-- better
data Year = YearStr String
          | YearInt Int
          deriving (Show)

truncateYearsBetter :: Year -> String
truncateYearsBetter (YearStr s) = drop 2 s
truncateYearsBetter (YearInt i) = (`mod` 100) i
```

### Sugar: As-patterns (`@`)

`var@pattern` binds the entire match to `var`, while still binding the pattern.

Regular `map` is `map :: (a -> b) -> [a] -> [b]`. Let's say we want to write a `map` that also gives the function access to the entire array:

```haskell
map2 :: ([a] -> a -> b) -> [a] -> [b]
map2 _ []   = []
map2 f (x:xs) = f (x:xs) x : map2 f xs -- needless cons call
map2LessBad f list = f list (head list) : map2 f (tail list) -- verbose
```

We can abbreviate the last match as:

```haskell
map2 f list@(x:xs) = f list x : map2 f xs
```

In the past, we've often used `head` and `tail` within our functions because we want to refer to the argument as `list` for whatever reason. This gives the best of both worlds.

### Records

```haskell
data Person = Person { name :: String, age :: Int }

-- initialization
tim  = Person "Tim" 25                   -- arguments applied sequentially
tim2 = Person { name = "Tim", age = 25 } -- named arguments

-- toy functions -- Haskell records come with getters; see below
getName :: Person -> String
getName Person { name = name } = name

getAge :: Person -> Int
getAge Person { age = age } = age

-- built in getters and setters
getAllNames :: [Person] -> [String]
getAllNames = map name - note that the record label is a function

birthday :: Person -> Person
birthday p = p { age = age p + 1 }
-- birthday tim == Person { name = "Tim", age = 26 }

-- for shorthand record syntax, use -XNamedFieldPuns setting
getName Person { name } = name
```

Gotcha: record selectors pollute the global namespace. Two different types of records cannot have the same labels.

```haskell
data Superhero = Superhero { name :: String, age :: Int, power :: String }
-- error: Multiple declarations of 'name'
```

## Uses

Pattern matching can be done wherever variables are bound.

### Equations

We've been doing this from the start!

### `let` and `where`

```haskell
dumbHead list = let x = head list
                in x
dumbHead list = x
                where x = head list

-- with pattern matching
lessDumbHead list = let (x:_) = list
                    in x

lessDumbHead list = x
                    where (x:_) = list
```

### Lambdas

```haskell
lHead = \list -> head list
lHead2 = \(x:_) -> x
```

Note that lambdas can only have a single pattern.

### List comprehensions

```haskell
getHeads :: [[a]] -> [a]
getHeads ls = [x | (x:_) <- ls]
-- getHeads [[1,2,3], [2,3,4], [3,4,5]] == [1,2,3]
```

### `do`

```haskell
putFirstChar = do
    (c:_) <- getLine
    putStrLn [c]
```
