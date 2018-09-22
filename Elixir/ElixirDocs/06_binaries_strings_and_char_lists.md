# Strings

Two types of "strings":

* `"String"`: binary of characters, equivalent to `<<83, 116, 114, 105, 110, 103>>`. Sort of like "packed" strings.
* `'String'`: list of characters, equivalent to `[83,116,114,105,110,103]`. Conceptually equivalent to Haskell strings.

In general, use the binary version. The list version is generally for Erlang interop, and lists are generally less efficient for the types of operations commonly done on strings.

## Binaries

Sequence of bytes. Like a Javascript `ArrayBuffer` or a Python `ByteArray`. A string is simply a UTF-8 encoded binary.

Values are integer representation of bytes. If the value goes over 255, the value overflows.

```elixir
<<256>> == <<0>> # true
```

Can use `::` to cast a value to a different size.

```elixir
# Cast as 16-bit
<<256 :: size(16)>> == <<1, 0>>

# Cast as code point
<<97>> == "a"
<<97 :: utf8>> == "a"
<<256>> == <<0>>
<<256 :: utf8>> == "Ā"
```

Pattern matching works as expected. However, unlike lists or tuples, we can match binaries of unknown size by casting to binary.

```elixir
<<a, b, c>> = <<1, 2, 3>>
<<a, b, c>> = <<1, 2, 3, 4>> # MatchError
<<a, b, c :: binary>> = <<1, 2, 3, 4>> # c = <<2, 3>>:
```
