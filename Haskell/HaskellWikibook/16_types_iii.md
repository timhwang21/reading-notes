# Types III

## Enumerations

Types that are entirely "valueless". In other words, a type where no constructor takes parameters.

Examples: `Bool`, `Ordering`

`data Color = Black | White | Gray Int` is NOT an enumeration, as the last argument takes an argument.

## Named Fields (records)

Very often a data type does not need any particular behavior, and is just defined for type safety. This is a **record type**. With many parameters, though, it gets confusing; therefore, we use named parameters (fields).

```haskell
-- confusing and very hard to refactor
data Configuration = Configuration
  String
  String
  String
  Bool
  Bool
  String
  String
  Integer
  deriving (Eq, Show)

getUserName = (Configuration un _ _ _ _ _ _ _) = un

-- clearer
data Configuration = Configuration
  { username  :: String
  , localHost :: String
  ... etc.
  }
```

The latter also automatically generates getters:

```haskell
username :: Configuration -> String

-- Immutable setter
setUsername :: Configuration -> String -> Configuration
setUsername cfg newUN = cfg { username = newUN }
```

You can also pattern match against named fields:

```haskell
myFunc (Configuration { username = un }) = un
```

There is an extension `NamedFieldPuns` that is like Javascript object property shorthand:

```haskell
-- :set -XNamedFieldPuns
-- or
{-# LANGUAGE NamedFieldPuns #-}
-- or
-- ghci -XNamedFieldPuns when compiling
myFunc (Configuration { username }) = username
```

### Warning: no nulls when using record types!

Remember that there is no real first-class null in Haskell:

```haskell
myConfig = Configuration { username = "Foo" }
localHost myConfig
-- throws an error on access, but will compile successfully!!
```

## Parameterized Types

Types that take arguments are "template" types:

```haskell
data Maybe a = Nothing | Just a
```

