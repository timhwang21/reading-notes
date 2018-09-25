# Recursion

Conditions can be an elegant way to handle base cases:

```elixir
defmodule Recursion do
  # with patterns
  def fibonacci(0), do: 0
  def fibonacci(1), do: 0
  def fibonacci(n), do: fibonacci (n-1) + fibonacci (n-2)

  # with guards
  def fibonacci2(n) when n <= 1, do: 0
  def fibonacci2(n), do: fibonacci (n-1) + fibonacci (n-2)
end
```

## List operations

```elixir
defmodule Math do
  def sum_list(list, acc \\ 0)
  def sum_list([x|xs], acc), do: sum_list(xs, acc + x)
  def sum_list([], acc), do: acc
end
```
