# Modules and Functions

## Functions

* `def` - function (inside a module)
* `defp` - private function (can only be invoked from within the same module)

### Guards and other variations

```elixir
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
module Math where

zero :: Integer -> Boolean
zero 0 = True
zero n = False
```

Elixir...

* does NOT enforce exhaustive pattern matches
* can NOT pattern match on type (instead pattern matches on a typechecking function that returns a boolean)
* does NOT make you want to die
* DOES iterate through patterns top-down like Haskell

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


