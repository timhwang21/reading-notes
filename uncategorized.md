# Uncategorized

## Evaluation strategy

Haskell is neither **call by reference** or **call by value**. Instead, it is **call by name**.

**Call by name** is a **non-strict** (lazy) evaluation strategy. Arguments are not evaluated until the function tries to access the value of the argument. (So, if an argument is passed but not used, it is not accessed.)

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
