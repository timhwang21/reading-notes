# [Typeclassopedia](https://wiki.haskell.org/Typeclassopedia)

A **type class** is a category of types. Individual types of a particular type class are **instances** of that type class. For example, the type `List` (`[]`) is an **instance** of the `functor` **type class** (among other type classes).

Type classes are sort of like interfaces for types (without the concept of `this`, of course).

Examples (abridged):
* Functors: Implements `fmap (<$>)` - "function -> container -> container"
* Applicatives: Implements `lift (<*>)` - "containerized function -> container -> container"
* Monads: Implements `bind (>>=)` - "function returning container -> container -> container"

## Functors

### Intro

* Definition: type that contains `a` and can apply functions uniformly across all `a`
* Functions
  * `fmap :: Functor f => (a -> b) -> f a -> f b`
    * `fmap` applies function to container contents without altering container
    * `s/container/context`
  * `(<$) :: Functor f => a -> f b -> f a`
    * Like `fmap` with a function returning a constant, basically a setter
* Laws
  * `fmap id == id`
  * `fmap (f . g) == fmap f . fmap g`
* Example

```haskell
-- list type
instance Functor [] where
  fmap :: (a -> b) -> [a] -> [b]
  fmap _ []     = []
  fmap f (x:xs) = f x : fmap f xs

instance Functor Maybe where
  fmap :: (a -> b) -> Maybe a -> Maybe b
  fmap _ Nothing  = Nothing
  fmap f (Just a) = Just (f a)

instance Functor Either where
  fmap :: (a -> b) -> Either a a -> Either a b
  fmap f (Left a) = Left a
  fmap f (Right a) = Right (f a)

instance Functor IO where
  fmap :: (a -> b) -> IO a -> IO b
  fmap f (IO a) -> IO (f a)

-- prelude types
instance Functor ((,) e) where
  fmap :: (a -> b) -> (e, a) -> (e, b)
  fmap f (e, a) = (e, f a)

instance Functor ((->) e) where
  fmap :: (b -> c) -> (a -> b) -> a -> c
  fmap = (.)
  -- this is just compose. Functions are functors!
  -- actually super cool. fmap add2 add3 == add5!

-- sample recursive type
data Tree a = Leaf
            | Branch a (Tree a Tree a)

instance Functor Tree where
  fmap :: (a -> b) -> Tree a -> Tree b
  fmap f Leaf = Leaf
  fmap f (Branch a left right) = Branch (f a) (fmap f left) (fmap f right)
```

### Lifting

* `(a -> b) -> f a -> f b` can have parentheses added because of currying: `(a -> b) -> (f a -> f b)`
* This shows that it's basically transforming a function to operator on functors
* This is known as **lifting** (more when we get to **applicatives**!)

### Other

* Previously, `(<$)` defined to be "assignment"
* There is also `($>)` which reverses argument order, and `(<$>)` which is an **synonym** (alias) for `fmap`
  * `($>) :: f b -> a -> f a`
  * Formally: `($>) = flip (<$)` where `flip :: (a -> b -> c) -> b -> a -> c`
* `void :: Functor f => f a -> f ()`
  * Formally: `void = (<$) ()`
* These are **infix** operators, equivalent to how `+ - * /` work
  * `function functor == function $ functor`
  * `(<$) function functor == function <$ functor`, e.g. `'goodbye' <$ myType('hello') == myType('goodbye')`
  * `($>) functor function == functor $> function`, e.g. `myType('hello') $> 'goodbye' == myType('goodbye')`
  * `(<$>) function functor == function <$> functor`, e.g. `sum <$> [1, 2, 3] == 6`
* [More on infix operators](https://haskell-lang.org/tutorial/operators)

## Applicative

[Continue here!](https://wiki.haskell.org/Typeclassopedia#Applicative)