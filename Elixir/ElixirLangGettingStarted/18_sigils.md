# Sigils

Kind of like Javascript tagged template literals.

Literals are:

1. `~`
2. a single char tag
3. opening delimiter
4. some content
5. closing delimiter
6. optional modifiers

```elixir
regex = ~r/foo|bar/i
# also works, reads better than / delimiters
regex = ~r(^https?://)i
"foo" =~ regex

~w/foo bar baz/
# => ["foo", "bar", "baz"]

~w/foo bar baz/a # also c, s
# => [:foo, :bar, :baz]
```

Other useful ones:

* `~s` allows for easy strings that have lots of `"` or `'`
* `~S` is `~s` that doesn't recognize escape chars

`~S` is especially useful for heredocs:

```elixir
defmodule SomeRegexModule
  @doc ~S"""
  This documentation contains lots of backslashes \ and escaping them all
  would be tedious.

  We can type /\w+/ without any unexpected escapes!
  """
end
```

# Implementation

`~r/foo/i` is a macro that desugars to `sigil_r(<<"foo">>, 'i')`.

```elixir
defmodule MySigils do
  def sigil_x(string, tokens), do: something
end
```
