# Actors

A fault-tolerant, low-overhead model for handling concurrency.

[**Link**](https://www.youtube.com/watch?v=7erJ1DV_Tlo)

## Purpose

Actors handle:

* Processing
* Data storage
* Communication

## When reciving messages

Actors receive messages via their **addresses**.

Actors can:

* Create more actors
* Message an actor (possibly itself)
* Designate how it will handle the next message it receives -- in other words, what internal state you will "present" to the next message (current message cannot access this "next" state)

**Message processing** is synchronous (using a queue) but **message receiving** is async. Think of a physical mailbox: your stack of mail is not guaranteed to be in the order of sending, but you can only process them one at a time.

**Message delivery** is best-effort. For more, see [fault tolerance](#fault-tolerance)

## Futures

While an action is being computed, you can create an address that represents where the eventual computation will be. Sort of like a promise.

Futures can be used to send recursive messages and avoid deadlocks.

## Difference from "immutable object"

One can imagine a similar system:

1. Object A tells Object B to increment
2. Object B creates a new instance of itself where `self.state` is `self.state + 1` of the previous state

However, this fails when handling concurrency: if Object A messages Object B twice:

1. Object A1 tells Object B to increment
2. Object A2 tells Object B to increment
3. Object B handles message of Object A1; creates a new object B1 where `self.state` is 1 greater than that of Object B
4. Object B shifts Message A1 from the queue, processes Message B2; creates a new object B2 based on its own state
5. Now we have a "forked" state B1 and B2 that both have state 1 greater than that of B

This is because when B creates B1, Message A2 isn't "magically" transferred to B2's mailbox.

Instead:

1. Actor A1 tells Actor B to increment
2. Actor A2 tells Actor B to increment
3. Actor B handles message of Actor A1; designates that it will handle the next message (whatever it is) with its internal state incremented by 1
4. Actor B handles message of Actor A2
5. We get our expected result where the next message is handled with state 2 greater than that of the initial state

## Address vs. identity

An address is NOT a memory address, object identity, etc.

* One actor can have MANY addresses (for proxies, etc.).
* Many actors can share ONE address (for replication).
* One actor can have one address as well (simple case).

There is (intentionally) no concept of identity regarding actors, as **actors are not meant to be seen as values**. There is no way to "lookup" an actor by its address -- **an address is merely something to send a message to**. When sending a message to an address, you do not know anything about the actor(s) associated with the address.

Analogy: when accessing `google.com`, you are associating a single address with an indeterminate amount of load balancers, servers, etc. However, you still get a single response to your message.

## Integrity of addresses

The guarantee of integrity of addresses seems to be an implementation detail, like that of object identity. Initial academic implementation in `Dennis & Van Horn (1966)` had no guarantee at all! However, for all reasonable use cases it's safe to assume that a given address is correct.

## Fault tolerance

Actors strive to be fault tolerant rather than error free. Thus, many things one might expect are not guaranteed.

### Not guaranteed

* Message delivery is "best-effort"
* Order of message delivery is not guaranteed

### Guaranteed

* Messages are delivered zero or one times; duplication is not possible

## Message mediation

Unlike CSP and other evented architectures, actors directly communicate with each other. There are no "channels," "event busses," and other intermediary to mediate this. The goal is to avoid the issue of two actors fighting over a single message.

However, actors are a primitive, and channels are a concept. There is nothing stopping someone from implementing a channel-based communication system via actors (the intermediary would simply be another actor). **The complaint is not with channels as a whole; it is with channels as a primitive.**

Similarly, while sequentiality of message reception is not guaranteed, there is nothing stopping someone from implementing a sequencer that collects messages, orders them, and then batch sends them. The actor primitive doesn't guarantee this because of the overhead associated. When this behavior is needed, the overhead must be self-implemented. (Or you could send your message as a list of `Future` messages, so while they may resolve in an arbitrary order, the final list ordering is correct.)

## Comparison to FSM

FSMs have finite state; however, because actor messages can take an indeterminate amount of time to arrive and be processed, it adds communication to the pure state-based approach of FSMs.

## Comparison to objects in the context of threads

When objects call methods on each other, the thread handling the caller then handles the callee. This causes issues in multithreaded environments, as there is no guarantee that invariants are maintained when two threads are interacting with an object simultaneously.

The object-oriented solution to this is locks, but they are problematic in their own way (not scaleable, risk of deadlocks, hard to reason about, etc.).

Actors send messages instead of calling messages. However, response execution is handled independently from message sending. For example, in a multithreaded environment, the thread handling the messenger does NOT handle the messagee -- it goes back to handling whatever the actor that sent the message should be handling. Similarly, the thread handling the messagee handles the message, and then goes back to handling whatever else the messagee should be handling. There is no "crossing" of threads. Because actors process messages sequentially, there is also no need for locks.

Summary: **message passing decouples signaling (method calls, message passing) from execution**. This preserves encapsulation in multithreaded environments.