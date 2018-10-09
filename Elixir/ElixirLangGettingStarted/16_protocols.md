# Protocols

Philosophically like typeclasses. In terms of usage, very different.

Whereas types define instances of typeclasses, protocols define implementations for types:

* Typeclasses: A type contains instances of 0 or more typeclasses
* Protocols: A protocol comtains implementations of 0 or more "types" (or structs etc.)

```elixir
defprotocol Size do
  @doc "foobar"
  def size(data) # header
end

defimpl Size, for SomeType do
  def size(data) do
    # impl
  end
end

defimpl Size, for SomeOtherType do
  def size(data do
    # other impl
  end
end
```

Protocols can be implemented for

* all standard types (array, map, etc.)
* any struct
* `Any`

## `Any`

Acts as a "default implementation."

* Types can `@derive [MyProtocol]` to use `Any` as defined by `MyProtocol`
* Protocols can use `@fallback_to_any true` to use `Any` whenever called for a type for which a definition doesn't exist

Note that erroring when calling for a type with no definition is probably correct, so be careful with defaults.

## Built-in protocols

* `Enum` module functions are implemented by the `Enumerable` protocol
* `to_string` is implemented by the `String.Chars` protocol

Note that in the typeclass approach these implementations would be organized under the type, not under the protocol.

## Protocol consolidation at compile time

Namespace checking can be expensive -- on every function call we need to check if an implementation is defined for the given argument(s). This checking is done at compile time, which results in fast calls.
