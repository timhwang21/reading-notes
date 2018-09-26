# Enumerables and Streams

## Enumerables

`Enumerable` is a **protocol**. Protocols are like Haskell typeclasses in that they're a mechanism for handling ad-hoc polymorphism. However, in Elixir only structs implement protocols, whereas in Haskell all data types might have instances of a typeclass. Also, protocols use a heuristic and just dispatch on the first argument, whereas Haskell uses actual type inference to figure out which instance to use. (**TODO** maybe move this to the section on protocols)

`Enum` contains useful stuff like map, reduce, filter, etc.

`Stream` contains lazy versions of the above. The stream is computed when enumerated over.

## Pipes

Basically the same as bash pipes. Only pipes forwards the first argument, and "injects" it before the first argument of the next function. Sort of weird.

```elixir
defmodule Test do
  def two_arity(a, b), do: "First = " <> a <> ", second = " <> b
end

"hello" |> Test.two_arity("world")
# => "First = hello, second = world"
# You might expect First = world, second = hello instead, but Elixir does not support currying by default
# The piped arg is prepended to the parameter list. Test.two_arity("world") looks like a function invocation but it's not
```

