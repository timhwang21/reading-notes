# Processes

Processes are an implementation of the actor model. Processes are lightweight entities that don't have shared state and function in parallel.

## `spawn`

`spawn((() -> any())) :: pid()`

`spawn/1` takes a function as an argument and creates a process. Once the function is finished evaluating, the process is killed.

Generally, the function passed to `spawn` will `send` a message upon completion, which is `receive`d by some other process. Contrast this approach to callbacks, where you might `spawn/2` a process in some context, with a callback being passed as the second argument, and instead of sending a message, the callback is invoked with the output.

`Process.register/2` registers a `pid` with an `atom`.

Differences:

* With message passing, the receiver does not have to be the creator of the sender. Any process can be sent to.
* ...

## `send` and `receive`

`send(dest :: Process.dest(), message) :: message when message: any()`

Sends some message to any process. Idiomatically, message is a tuple where the first element is an atom like `:ok`. The message is stored in the receiver's mailbox, where it stays until handled by `receive/1`.

`receive` is a macro using do-notation that pattern matches on the received message. When invoked, it causes the current process to block, and evaluates the next message that arrives in the mailbox. Every call to `receive` will handle a single message.

`receive` can take a timeout via the `after` keyword. A timeout of zero will instantly exit unless a message already exists in the mailbox.

## Links

When a process errors, it doesn't affect the parent process, as processes are isolated. Thus, when an unlinked process dies, its error is lost.

`spawn_link/1` spawns a process linked to the current process. When the linked process errors, that error propagates to the current process.

`Process.link/1` will link the calling process to the process provided in the argument.

Links are bidirectional rather than parent-child only. Two "sibling" processes can notify the other when one fails.

Links do NOT share state, they just share errors. In fault-tolerant systems, many processes are linked under a supervisor, which is responsible for re-`spawn`ing new processes as they fail. Because no state is shared, one process error cannot corrupt another process. Supervisors act as an alternative to constructs like `try/catch`.

## Tasks

`spawn/1` and `spawn_link/1` are the primitives for building processes. Tasks exist at a higher level of abstraction:

* Tasks have a standard message format (tuples starting with an atom)
* Does more error handling automatically (easier to implement supervisors)
* A nicer API

## State

Processes can be used to store state. By having a `receive` call itself recursively, we can have a persistent data store:

```elixir
defmodule KeyValStore do
  # spawn a process with initial value of %{}
  def start_link, do: Task.start_link(fn -> receive_recurse(%{}))

  defp receive_recurse(store) do
    receive do
      {:get, key, caller} ->
        send caller, Map.get(store, key)
        receive_recurse(store)
      {:put, key, value} ->
        receive_recurse(Map.put(store, key, value))
    end
  end
end
```

Elixir implements this as `Agent`.
