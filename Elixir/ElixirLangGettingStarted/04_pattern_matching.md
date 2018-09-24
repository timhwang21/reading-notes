# Pattern Matching

`=` is not exactly assignment, as it is in other languages. It is instead the **match operator**.

As Elixir is an expression-based language, `=` returns the right side of the expression.

Matching can operate on the following:
* Values
* Shape
* Type

```elixir
# bind the match to x, which is 1
x = 1

# extract the value of x and match against 1; this implies = can sort of be used for comparison
1 = x

# errors -- 2 does not match with 1
2 = x

# errors -- variables cannot be bound on the right side
1 = y

# pattern matching "destructures" based on the type of the right side
[foo, bar, baz] = [1,2,3]
{foo, bar, baz} = {1,2,3}

# errors -- if the pattern does not match in type and/or shape we get an error
[foo, bar, baz, quux] = [1,2,3]
[foo] = [1,2,3]
[foo, bar, baz] = {1,2,3}

# use _ to signify unused matches
[foo, _, _] = [1,2,3]

# we can combine shape-based matching and value-based matching
# it is conventional to return the atom :ok for operations that may fail
{:ok, res} = some_failable_operation
# if operation succeeds, res gets the result
# if operation fails, e.g. first element is :error, we throw MatchError

# Lists have some special syntax
# note that this fails on the empty list, as nothing matches head
[head | tail] = [1,2,3]

# | is like Haskell :, can also build lists with it
# the difference is that this happens inside the braces rather than outside
[0 | [1,2,3]] # valid
0 | [1,2,3]   # invalid
# you also can't chain as easily
[0 | [1 | [2 | []]]] # valid but ugly
0 | 1 | 2 | []       # invalid

# Function calls can happen in the right side for pseudo-comparisons, but not on the left.
2 = 1 + 1 # valid
1 + 1 = 2 # invalid

# However, we can use concatenation functions on the left
[1] ++ rest = [1,2,3,4]
<<1>> <> rest = <<1,2,3,4>>
```

## Pinning

There is some ambiguity because `=` serves the dual purpose of variable binding and pattern matching.

```elixir
ok = :ok

{ok, res} = {:error, some_stack_trace}
# we expect MatchError, but instead ok is rebound to :error
```

Pinning allows us to pattern match on the left side without rebinding.

```elixir
ok = :ok

{^ok, res} = {:error, some_stack_trace}
# we get our MatchError as expected
# ok is no longer re-bound to :error
```

Pinned variables are referentially transparent to their values: if `x = 1`, `^x = 2` is equivalent to `1 = 2`.
