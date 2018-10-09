# Module Attributes

## Annotations

Look like decorators used within modules:

```elixir
defmodule Tim do
  @vsn 2          # sets version for hot reloading; generates a random hash if omitted
  @moduledoc      # like python docstring at module level
  @doc            # like docstring at function / macro level. uses markdown WOW
  @behaviour      # not important for now
  @before_compile # can be used for metaprogramming, like supermacros
end
```

## Custom annotations

Custom annotations can be used like Ruby local variables:

```elixir
defmodule Tim do
  @initial_state %{foo: true, bar: false}
end
```

Note that these values are COMPILE TIME values! Despite being locally accessible, every access takes a "screenshot" of the current value of the attribute.
