# Try, catch, and rescue

## Errors

Pretty much like Ruby.

```elixir
raise "foo" # => ** (RuntimeError) oops

raise ArgumentError, message: "foo" # unknown arg list keys are ignored

defmodule TimError do
  defexception message: "foobar"
end

raise TimError # => ** (TimError) "foobar"
raise TimError, message: "baz" # => ** (TimError) "baz"
```

`try` and `rescue` are basically the same as Ruby, except `rescue` can pattern match on the error.

## Exceptions vs. error tuples

Elixir tends to use error tuples in favor of exceptions for errors. Often failing functions will return an `{:error, x}` tuple instead of raising.

The general pattern is:

* `canfail()` returns `{:ok, body}` or `{:error, reason}`
* `canfail!()` returns `body` or raises an exception

## Throw

In cases where we cannot retrieve and handle an error later, we use `throw` and `catch`. This is generally used as glue when dealing with poorly written libraries.

Specifically:

* `{:error, reason}` should be used for control flow for expected failures
* `raise` and `rescue` should be used for true exceptions (programmer error, etc.)
* `throw` and `catch` should be used for control flow when `{:error, reason}` is not implemented

## `exit`

When a process dies, it sends an `exit` message. Generally, it is preferred to have a supervisor listen for `exit` messages and restart the process, rather than handling via try/catch or similar constructs. This ties into the "fail fast and safely" vs. "account for all errors" philosophy.

## `after`

Executes regardless of whether a process succeeded or failed.

## `else`

Reverse-rescue. Matches on a success instead.
