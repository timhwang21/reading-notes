# Typespecs and behavior

## Typespecs

Allow adding gradual typing to an Elixir program. Like Facebook's Flow.

Can be used to declare function signatures, as well as define custom types.

```elixir
# elixir
defmodule Math do
  @spec add(number, number) :: number
  def add(x, y), do: x + y
end
```

```haskell
-- haskell
add :: Num a => a -> a -> a
add x y = x + y
```

```typescript
// typescript
function add(a: number, b: number): number {
  return a + b;
}
```

Elixir is like ML languages in that the signature is separate from the function definition.

## Custom types

```elixir
defmodule Math do
  @typedoc """
  Represents ints as a tuple of a nat and a type.
  """

  @type integer :: {number, :positive} | {number, :negative}

  @spec add(integer, integer) :: integer
  def add({n1, s1}, {n2, s2}) do
    # ...
  end
end
```

## Behaviours

> Note the British spelling!

Like Java class interfaces.

### Difference from Protocols

Protocols are for **parametric polymorphism**: `Enum.Map` accepts parameters of many types.

Behaviours are for **duck typing**: two modules with the same behaviours implemented can be called with the same functions that take the same signatures.

```elixir
defmodule Parser do
  @callback parse(String.t) :: {:ok, term} | {:error, String.t}
  @callback extensions() :: [String.t]
end

defmodule JSONParser do
  @behaviour Parser

  def parse(str), do: # ...parse JSON
  def extensions, do: ["yml"]
end

defmodule XMLParser do
  @behaviour Parser

  ...
end
```

### Dynamic dispatch

```elixir
defmodule Parser do
  @callback parse(String.t) :: something

  def parse!(implementation, contents) do
    case implementation.parse(contents) do
      {:ok, body} -> body
      {:error, error} -> raise error
    end
  end
end
```

This lets us call `Parser.parse!` as a "static method" and pass in the parser implementation we want to use.
