# Alias, require, and import

* `alias` - Declares a module under a new variable.
* `require` - Makes all macros on required module available in the module's namespace.
* `import` - Makes the imported thing available in the local namespace. Can import individual items, `:macros`, and `:functions`. Automatically `require`s.
* `use` - `require`s and allows the required module to run arbitrary code. Sort of like `require` that permits side effects.

## Aliases in depth

`alias/2` simply takes a module and assigns it to an alias. An alias is a PascalCased representation of an `:atom`. For example, `String` is an alias for `:string`.

Because modules are internally represented as atoms, `alias/2` allows for straightforward renaming.

## Nesting modules

Global modules are implicitly under the `Elixir` namespace:

```elixir
List == Elixir.List
# => true
```

Nesting modules is just sugar:

```elixir
defmodule Foo do
  defmodule Bar do
  end
end

# is the same as...

defmodule Elixir.Foo do
  defmodule Elixir.Foo.Bar do
  end

  alias Elixir.Foo.Bar, as: Bar
end
```

