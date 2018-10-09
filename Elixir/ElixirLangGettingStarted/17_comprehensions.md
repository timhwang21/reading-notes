# Comprehensions

```elixir
# elixir
for n <- [1,2,3], n > 1, do: n * n
```

```python
# python
[n * n for n in [1,2,3] if n > 1]
```

```haskell
-- haskell
[n * n | n <- [1,2,3], n > 1]
```

Unlike in the other languages, Elixir generators can also do their own filtering via pattern matching, which can allow for terser syntax:

```elixir
for {:ok, n} <- some_array_of_msgs, do: n
# ...is equivalent to...
for msg <- some_array_of_msgs, elem(msg, 0) == :ok, do: elem(msg, 1)
```

## `into:`

Allows list comprehensions to be used like reducers. `:into` needs to be passed a type that implements `Collectable`.

```elixir
# Convert argument list into map
for {k, v} <- [a: 1, b: 2, c: 3], into: %{}, do: {k, v}
# => %{a: 1, b: 2, c: 3}
```

This is also useful for iterating over maps:

```elixir
for {k, v} <- %{a: 1, b: 2, c: 3}, into: %{}, do: {k, v * v}
# ...is equivalent to...
Enum.into (Enum.map %{a: 1, b: 2, c: 3}, fn {k, v} -> {k, v * v} end), %{}
```

Note that both `Enum.map` and list comprehensions "destructure" the map into an argument list by default if `:into` or `Enum.into` is not used.
