# Uncategorized

## Evaluation strategy

Haskell is neither **call by reference** or **call by value**. Instead, it is **call by need**.

**Call by need** is a **non-strict** (lazy) evaluation strategy that is a specific type of **call by name** (the difference being that call by need is memoized). Arguments are not evaluated until the function tries to access the value of the argument. (So, if an argument is passed but not used, it is not accessed.)

```ruby
def foo used, unused
  used
end

# This does not evaluate even though the second arg isn't used
foo "I am used", [*0..Float::INFINITY]
```

```haskell
foo :: a -> b -> a
foo used unused = used

-- this evaluates
foo "I am used" [0..]
-- but more specifically, [0..] is never evaluated. However, calling [0..] in GHCI causes an infinite stream of numbers to be printed to console
```

## Why FP?

* Common problem: applying transformation uniformly over some collection
* Give example of traditional iteration -- a large proportion of the code is boilerplate meant to handle the iteration logic

Hallmarks of FP

* Pure -- output deterministic based on input
	* This usually means *stateless* and *non-mutative*

Outcomes

* Parallelizability -- if generation of output is pure, it can be done in separate operations
* Optimizations -- if computations are guaranteed to be stateless, computations can be delayed or reordered arbitrarily
	* Example: lazy evaluation
* Easier to reason about -- do not have to figure out current state
	* Only consider input and output, not input + output + state

## Unorganized functor thoughts

* Functors wrap types T to produce a new type F(T).
* `map` takes a function meant to accept T and makes it accept F(T) (it "lifts" the function)
* Monad `unit` takes a value and "containerizes" it in the functor.
* Monad `join` takes a multiply nested value and un-nests it.
* Some laws:
	`join . map` is an identity

## Intuitive explanation of `foldr`

`[1,2,3,4,5]`

Write a list using `cons` syntax:

`1:2:3:4:5:[]`

Switch `:` from infix to prefix syntax (remember right-associativity):

`(:) 1 (:) 2 (:) 3 (:) 4 (:) 5 []`

Replace `[]` with the accumulator (`acc`) and `cons` with `f`:

`f 1 (f 2 (f 3 (f 4 (f 5 acc))))`

(Or use an intuitive infix function)

`foldl` is the same but with left-associativity.

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f acc []     = acc
foldr f acc (x:xs) = f x foldr (f acc xs)

foldl :: (a -> b -> a) -> a -> [b] -> a
foldl f acc []     = acc
foldl f acc (x:xs) = foldl f (f acc x) xs

foldr `eats` [] [human, shark, fish, algae]
-- human eats (shark eats (fish eats (algae)))

foldl `eats` [] [human, shark, fish, algae]
-- (((human eats shark) eats fish) eats algae)
```

## What are Javascript promises and async/await?

Promises resemble IO monads in terms of intended use, but more closely resemble Either monads in behavior, as promises aren't limited to IO operations.

Some think that `async/await` truly unwraps promises, but remember that all `async` functions always return promises. So regardless of what it looks like is happening inside the function body, you've never left the "promise monad." In particular, note how closely `async/await` and do-notation resemble each other.

```typescript
function getFoo(): Promise<Foo>
function useFoo(foo: Foo): Promise<Bar>

getFoo().then(useFoo)

// async/await
async function() {
  const foo = await getFoo()
  return useFoo(foo)
}
```

```haskell

getFoo :: IO Foo
useFoo :: Foo -> IO Bar

getFoo >>= useFoo

-- do-notation
do
  foo <- getFoo
  return (useFoo(foo))
```

Note that the regular promise usage and the bind (`>>=`) usage make it more clear that you are still dealing with a container type. In contrast, both `async/await` and do-notation make it look like `foo` is a `Foo` instead of a `Promise<Foo>` / `IO Foo`. However, the final "return value" of the async function / do block is wrapped in the container.

We can expand our example to add exception handling:

```typescript
async function() {
  try {
    const foo = await getFoo()
    return useFoo(foo)
  } catch(e) {
    throw e
  }
}
```

```haskell
do
  foo <- getFoo()
  case foo of
    Right foo ->
      return (useFoo(foo))
    Left e ->
      ioError e
```

Note that we usually put `Left` handling first, but I put it last for more parallel structure with JS. Also note that do-notation lets you naively return `foo` without error handling, which results in something similar to JS (the entire computation will just exit with the `Left` value).
