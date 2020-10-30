# Software transactional memory

## Problem

- You have a value that you've read while a write is going on; the read value is now stale
- You have a value two processes are attempting to write to simultaneously; you have a lost update

## Solution 1: pessimistic locks

- When a value is about to be written to, lock it; any other process that attempts to write to it will pause and wait for unlock
- _Transactional contexts_: contexts that are treated as transactions (e.g. Ruby ActiveRecord transactions)
- Problem: risks deadlocks; imagine one process tries to transact from A -> B and another tries to transact from B -> A
   - One solution is to have deterministic ordering of locks
- Problem: overlocking; if write target is conditional, you need to lock every possible write target

## A higher level abstraction: transactional memory

- Implementation: track all reads and writes, if at the end of a transaction, another transaction has written to a value you read, undo and retry your transaction; eventual consistency
- Do not need to figure out read set beforehand (which can be sizable) for use in pessimistic locking
- _Transactional variables_: values with transactionality baked in
- Overhead: transactional variables are wrapped values with some degree of observability; ideally this cost is counterbalanced by the payoff of parallelization. Trades compute for time.
- Cases
   - Two threads don't read the same values -- no problem
   - Two threads read the same values, but don't write -- no problem (strictly better than pessimistic lock approach since no lock was needed here)
   - Two threads write to the same values -- one thread will rollback and retry

## Relationship with types

- TVars are like promises -- they are an impure wrapper type; functions need special ceremony to "extract" the value from the container; you cannot have a non-STM function extract a value from a STM function like how you can't have a sync function extract a value from an async function
   - Monads try to solve this; they allow these impure functions to be composed like pure ones
- Problem with STM in dynamically typed languages: just compare using promises in JS to promises in TS. Nuff said.

## Other thoughts

- C++ and Java's solution is to use threads that can modify anything at any time, with manual synchronization and no compile-time verification. The pro is that there is no ned to differentiate between kinds, and the con is that it's hard and error prone, and complexity scales with number of objects (see [Concurrency in Gameplay Simulation](https://www.st.cs.uni-saarland.de//edu/seminare/2005/advanced-fp/docs/sweeny.pdf)).
- Go's solution to the concurrency issue is _basically_ to put _all_ code inside a shared impure monad. However, this is equivalent to hardcoding a single specific monad into the language itself; there is no similar general way to handle, e.g., eithers. Another downside is that _everything_ can be effectful and impure and there is _no way to tell._
- This whole transactional/nontransactional, async/sync, unsafe/safe, etc. thing signifies that functions can have different kinds beyond just input and output types. These are exactly what higher-kinded types are.

## Resources

- [Context on STM in Ruby](https://chrisseaton.com/truffleruby/ruby-stm/)
- [What color is your function?](https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/)
- [Wikipedia](https://en.wikipedia.org/wiki/Software_transactional_memory)
