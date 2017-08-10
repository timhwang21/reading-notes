# Lists & Tuples

## Definitions

* List - linked list with fixed type and variable length
* Tuple - structure with fixed length and variable type
* Projection - a function that gets data out of a data structure; a getter

## Syntax

### Lists
`:` - "cons" operator -- list constructor `(:) :: a -> [a] -> [a]`
`,` - tuple constructor -- `(,) :: a -> b -> (a, b)`
`,,` - 3-tuple (triple) constructor -- `(,,) :: a -> b -> c -> (a, b, c)` and so on (this isn't magic -- it's hardcoded!)
`++` - concat operator `(++) :: [a] -> [a] -> [a]`
`head :: [a] -> a`
`tail :: [a] -> [a]`

### Tuples
`fst :: (a, b) -> a` (`a` and `b` are polymorphic types)
`snd :: (a, b) -> b`

## Lists

Lists in Haskell are typed. You cannot mix types.

Cons-ing prepends items to lists.

`0 : [1, 2, 3] == [0, 1, 2, 3]`

Signature: `(:) :: a -> [a] -> [a]`

`0 : 1 : 2 : 3 : [] = [0, 1, 2, 3]`

Note that `cons` is right-associative: the preceding is evaluated as:

`(0 : (1 : (2 : (3 : []))))`

Also note that if you call `cons` as a prefix, lists are just the output of a function call:

```haskell
cons a b = a : b

cons 1 [2] == cons 1 (cons 2 [])

[0, 1, 2, 3] == 0 : 1 : 2 : 3 : [] == cons 0 (cons 1 (cons 2 (cons 3 [])))

-- preview -- $ infix operator
[0, 1, 2, 3] == cons 0 $ cons 1 $ cons 2 $ cons 3 []
```

```javascript
cons(0, cons(1, cons(2, cons(3, []))));

// assuming currying
compose(
  cons(0)
  cons(1)
  cons(2)
  cons(3)
)([]);
```

Strings are lists: `"hello" == 'h':'e':'l':'l':'o':[]`

A list's type depends on its contents: `[1,2,3] :: Num t => [t]`, `['a','b','c'] :: [Char]`

## Tuples

`(True, False) :: (Bool, Bool)`
`(True, 'a', 1) :: Num t => (Bool, Char, t)`
`[(1, 2), (3, 4)] :: Num t => [(t, t)]`
`[(1, 2), ('a', 'b')]` is invalid!
`[(1), (1, 2)]` is also invalid! Unlike lists, size also factors into type.

## Exercises

Get head and tail of list:

```haskell
headAndTail list
    | []        = ()
    | otherwise = (head list, head $ tail list)
```