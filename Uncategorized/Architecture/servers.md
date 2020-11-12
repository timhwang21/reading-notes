# Servers

## Threaded

- Thread-based; each request is handled in its entirety by a single thread
- Rails, Spring, .NET, etc.
- Async operations track state via state-local storage
- Best for compute scaling where I/O scaling isn't as much of a concern, e.g. machine learning
- Pros
  - One thread crashing does not affect system as a whole
  - Once you overcome complexities of multithreading, horizontal scaling is easy
- Cons
  - Threads have overhead, so if your requests are cheap but you are concerned with a large number of connections, you will waste a lot of resources

## Event loop

- Single-threaded with nonblocking operations
- Async operations track state on the call stack (passing as args, in closures, etc.)
- Best for data-intensive but cheap tasks in high traffic environment (real-time, "glue" interface between services, etc.)
- Pros
  - Efficiently scales with many cheap connections; good for real-time stuff like chat
  - Even if there is a bottleneck like job processing, you can send job confirmation in real time and then send success notification later (in other words, built in simple background processing)
  - Can handle long-running jobs in chunks and do stuff in between (e.g. file upload which is bottlenecked by network speeds); in a threaded environment the waiting time could be wasted
- Cons
  - Expensive processes don't just affect a thread, they affect the entire application
  - If an exception bubbles up and Node crashes, everything dies
  - No thread local storage; as code complexity increases handling request / response context can get complicated

## Processes (Erlang, Elixir, Phoenix)

- Threads are abstracted away into processes (like virtual OS processes, but with cheap startup and communication of threads)
- Process memory is dynamically allocated meaning with cheap operations you don't have lots of wasted resources as you might with threads
- Not directly related to processes, but Erlang / Elixir enforces immutability which adds to ease of parallelization
- Trades off individual thread performance for better context switching; additionally, language paradigms optimize for parallelization
- Pros
  - Programming model is built for parallelism
- Cons
  - Because of the process abstraction, single-threaded behavior is not optimized for and is therefore slow (stuff like Ruby optimizes for single threaded performance with things like GIL which makes garbage collection faster as it guarantees thread safety)

### Elixir comparisons

- Scripting languauges (Python, Ruby, etc.) use stuff like a GIL so parallelization isn't first class
- Java can parallelize like Elixir, but inherent OOP means we need stuff like locks
- JS can scale up lightweight processes like Elixir, but is inherently single-threaded due to its underlying abstraction
- Rust can be safe like Elixir, but is at a lower level of abstraction (same for Go, C...) so it serves different goals (systems programming)
