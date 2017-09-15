# Type Declarations

Benefits of types
* Write code to fit problem
* Colocate data in meaningful ways
* Leverage Haskell's type system

## Syntax

### `data`

Defines a new data type using existing types. Creates **algebraic data types**.

```haskell
data Anniversary = Birthday String Int Int Int       -- name, y, m, d
                 | Wedding String String Int Int Int -- name1, name2, y, m, d
```

`Birthday` and `Wedding` are **constructors** for `Anniversary`.

Note that `:t Birthday` gives `String -> Int -> Int -> Int -> Anniversary` -- this is the signature for the constructor. Also note that `:t Anniversary` doesn't give anything: `Anniversary`s can only be created via the two constructors, and they will be of type `Anniversary`.

Constructors are just functions (no `new`, etc.):

```haskell
-- note signature for variable
me :: Anniversary
me = Birthday "Tim Hwang" 1900 1 1
meWedding :: Anniversary -- note same type
meWedding = Wedding "Tim Hwang" "My Spouse" 1900 1 1

-- these are treated as the same type
myAnniversaries :: [Anniversary]
myAnniversaries = me : meWedding
```

#### Deconstructing Types

```haskell
showDate :: Int -> Int -> Int -> String
showDate y m d = show m ++ show d ++ ", " ++ show y

showAnniversary :: Anniversary -> String
showAnniversary (Birthday name y m d) = name ++ " was born on " ++ showDate y m d
showAnniversary (Wedding name1 name2 y m d) = name1 ++ " married " ++ name2 ++ " on " ++ showDate y m d
```

Note the syntax for accessing values in the data types. Compare to lists:

```haskell
foo :: [a] -> [a]
-- the following two are identical
foo (x:xs)     = x:xs
foo ((:) x xs) = x:xs
-- here we use cons like we used the type constructor above
```

#### `type`

Types are used for type synonyms or aliases of existing types:

```haskell
type FirstName = String
type LastName = String
-- now we can write more descriptive functions that work with names
-- now we can write 

-- String itself is an alias
type String = [Char]
```

### `newtype`

`newtype` is used to rename types and add new constructors; will be explored in a later chapter.
