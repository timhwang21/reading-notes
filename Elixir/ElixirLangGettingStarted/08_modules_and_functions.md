# Modules and Functions

## Functions

* `def` - function (inside a module)
* `defp` - private function (can only be invoked from within the same module)

### Guards and other variations

```elixir
# Elixir
defmodule Math do
  def zero?(0) do
    true
  end

  def zero?(x) when is_integer(x) do
    false
  end

  # intentionally no definition for non-integers
end
```

Equivalent to:

```haskell
-- Haskell
module Math where

zero :: Integer -> Boolean
zero 0 = True
zero n = False
```

Elixir...

* does NOT enforce exhaustive pattern matches (nonexhaustive match is now a runtime error -- SAD!)
    * However, unreachable patterns ARE caught at compile time
* can NOT pattern match on type (instead pattern matches on a typechecking function that returns a boolean)
* does NOT make you want to die
* DOES iterate through patterns top-down like Haskell

### Desugared

Similar to if-else, `do` can be desugared:

```elixir
defmodule Math do
  def desugared(), do: "def is just a function"
end
```

### Capturing functions

Like Ruby lambda-ifying or proc-ifying:

```elixir
# Elixir
defmodule Test
  def some_func do
    # stuff
  end
end

captured = &Test.some_func/0
# need to specify arity to capture

# invoke -- it's now a lambda, so need the dot
captured.()
```

```ruby
# Ruby
def some_func
  # stuff
end

lambdafied = lambda(&method(:some_func))
# or even the following, since everything's an object
lambdafied2 = method(:some_func)

# invoking
lambdafied.call
```

Elixir, Ruby, and some others are Lisp-2 languages. Functions and other variables are in a different namespace. Lambdafying is in the "other variable" namespace so we need an alternate call syntax to invoke, in order to reduce ambiguity.

### Lambda syntax

There is the "regular" anonymous function syntax:

```elixir
lambda = (a, b) -> a <> " " <> b end
```

There is also the function capture syntax, which can sometimes be shorter. Warning: super ugly!

```elixir
# Elixir
lambda = &(&1 <> " " <> &2)
lambda.("hello", "world")
# => "hello world"
```

Uniquely, Elixir uses a bash-like syntax for variables, rather than declaring them up front.

Compare:

```ruby
# Ruby
# pretty vanilla
my_lambda = lambda { |a, b| a + ' ' + b }
my_lambda.call('hello', 'world')
```

```javascript
// Javascript
// terse, but loses points for weak typing
// lisp-1 so there's no distinction between function and lambda
const lambda = (a, b) => a + ' ' + b;
lambda('hello', 'world');
```

```typescript
// Typescript
// better
const lambda = (a: string, b: string): string => a + ' ' + b;
lambda('hello', 'world');
```

```haskell
-- Haskell
# no special function declaration statement, so everything is basically a lambda
lambda :: string -> string -> string
lambda a b = a ++ " " ++ b
lambda "hello" "world"
```

### Default arguments

Defined using the `\\` keyword.

Default arguments **change the arity of your function**:

```elixir
defmodule Test do
  def func(x \\ 1) do
    # foo
  end
end

h Test.func/1 # returns something
h Test.func/0 # also returns something! Two for one!
```

Lambdas **do not support default arguments** (wtf?). Default arguments change the arity of a function, and in Elixir lambdas can only have a single arity.

Default arguments **are not evaluated during define time**:

```elixir
defmodule Test do
  def func(x \\ 1 + 2 + 3) do
    # foo
  end
end

# 1 + 2 + 3 is evaluated every time the function is called without an argument
```

Default arguments **have to be in a header when there are multiple clauses**:

```elixir
defmodule Test do
  def func(x \\ 1)
  # notice there's no function body!

  def func(0) do
    # foo
  end

  def func(1) do
    # bar
  end
end
```

Keep in mind that default functions reduce arity, so you may accidentally make an unreachable definition:

```elixir
defmodule Test do
  def func() do
    "I will always be reached"
  end

  # actually has arity zero when using all defaults so will never be reached if called with no args
  def func(x \\ 1, y \\ 2, z \\ 3) do
    "I will never be reached"
  end
end
```

## Modules

```elixir
defmodule ModuleName do
  def func(arg1, arg2) do
    # something
  end
end
```

## Compilation

* `elixir` - runs Elixir file
* `elixirc` - compiles `.ex` Elixir file into bytecode (`Elixir.ModuleName.beam`)
* `mix` - compiles entire projects

`.ex` files are meant to be compiled. `.exs` (**e**li**x**ir **s**cript) files are meant to be run with `elixir`. **This is just a convention, there's no actual difference in how the files are handled.**

When invoking `iex` in the same directory as a `*.beam` file, that module is made available in the local namespace.

### Standard project directory

```
Project/
  > ebin/
    > *.beam
  > lib/
    > *.ex
  > test
    > *.exs
```
