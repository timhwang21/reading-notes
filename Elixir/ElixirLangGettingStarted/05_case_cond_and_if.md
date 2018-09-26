# `case`, `cond`, and `if`

Three control flow **macros**. They actually wrap 2-arity functions.

This is a notable illustration of Elixir as an expression-oriented language. Control flow isn't a separate, statement-based syntax, it's just expression-based syntax disguised via macros.

Note that while operators are also functions like in Ruby and Haskell, Elixir doesn't make it as easy to define custom operators (or infix functions in general). Elixir only allows for monkey-patching of existing infixes, and provides a list of unimplemented infixes for this purpose: `\\, <-, |, ~>>, <<~, ~>, <~, <~>, <|>, <<<, >>>, |||, &&&, ^^^`. There is also no notion of infix priority, `infixl`, `infixr`, etc.

## `case`

Like Haskell guards:

```elixir
case some_array do
  []     -> "handle empty array"
  [x]    -> "handle single element array"
  [x|xs] -> "whatever recursive fuckery you want"
  _      -> "like Haskell otherwise"
end
```

You can also specify conditional cases:

```elixir
case some_array do
  [x|xs] when x > 0 -> "do something when x > 0"
  [x|xs] when x < 0 -> "do something when x < 0"
```

Errors do not "bubble," instead they are swallowed. However, if no match occurs we get a `CaseClauseError` (like non-exhaustive pattern error in Haskell). For example, matching `[x|xs]` against the empty list `[]` normally errors; however if this is the first condition in a case statement that receives `[]`, we don't get an error thrown.

## `cond`

Like case, but does not specify a variable to run cases against. Instead, the "cases" are arbitrary expressions. So closer to a terser `else if` than a case statement.

```elixir
cond do
  1 + 1 = 2 -> "something"
  true      -> "since there's nothing to match against, we can't use _, so we just assert true"
end
```

Keep in mind that Elixir's only falsey values are `false` and `nil` (or the atoms `:false` and `:nil`).

## `if` and `unless`

Sample one-liner:

```elixir
# macro
if foo do
  bar
else
  baz
end

# direct function call
if(foo, do: bar, else: baz)

# without parens
if foo, do: bar, else: baz
```

## `do`-notation

As mentioned at the start, these control flow statements are just macros wrapping functions. `do` is similarly syntactic sugar. `do: foo` and `else: bar` are **keyword lists**. They serve the same purpose as named parameters in Python.
