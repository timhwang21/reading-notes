# Dispatching

## Static vs. dynamic dispatch

Static dispatches are jumps to method addresses based on method name (e.g. C function calls). These are known as **direct calls**, where the argument to the `call()` instruction is a fixed address. When dealing with polymorphism, the correct method implementation is selected at compile time based on type information.

One problem with static dispatch arises with inheritance. Given a derived class and its base class, an instance of the derived class may be referred to via a pointer of either the base or derived class type. If the derived class overrides some base class methods, it is now unclear which implementation should be used in the given instance. Virtual functions and dynamic dispatch allow calling the function according to the actual runtime type of the instance.

Dynamic dispatches are jumps to method addresses where the method name and address are decoupled. These are **indirect calls**, where `call()` is invoked with some non-fixed pointer and the method to be called is not known at compile time. Most common "modern" languages use virtual methods by default.

Dynamic dispatch is a hallmark of object-oriented languages, where method names are decoupled from method addresses. Thus, a single method name can map to many method addresses (e.g. different methods for subclasses). The process of resolving this ambiguity is up to the compiler or interpreter.

Dynamic dispatch results in **ad-hoc polymorphmism**, where many functions with a shared name are each capable of handling input of a specific type. This is in contrast to **parametric polymorphism**, where a single statically dispatched function is capable of generically handling input of multiple types. These multiple types are bound by some sort of restriction, e.g. "types that support equality." Haskell implements these restrictions as typeclasses.

### Dispatch mechanisms

#### Vtables (virtual function tables)

Used by C++, C#, and related languages. At compile time, every possible virtual method is mapped to a pointer for each class instance. When overrides are present, the pointer points to the subclass method implementation. This results in every class having access to a "method map", and every instance of the class having pointers to keys of the vtable.

This is fast but inflexible and can result in more complex code. For example, C++ does not support late binding (closed classes), and virtual methods must be manually annotated with the `virtual` keyword.

#### Ancestor-walking

Used by Smalltalk, Ruby, JS. Every instance has a type with a map of methods, and may have an ancestor. If a called method isn't found on the current type, ancestors are traversed until a method is found or the root is reached (at which point an error is thrown). This is flexible but slow (but can be improved by clever caching and language design).

### Example

Given an object `o` that may be one of multiple classes, each of which implements a method `save`, the program needs to know which implementation to call when `o.save()` is invoked. In OOP, the caller simply passes a `save` message to `o` without caring what type `o` is.

Further complications:

- In dynamic languages, methods can be defined, modified, or removed at runtime (late / dynamic binding), so whatever lookup table is used needs to account for this.
- Indirect calls (e.g. cached calls) can't be inlined (the cache is mutable) which is giving up a big optimization. A workaround is to speculatively inline, and decompile if incorrect (JS does this; JS has lots of small methods and prototype methods instead of class methods, so lookup is expensive since anything can be a prototype).

### Duck typing

Duck typing is a convention where the program does not care about types at all, and only cares if the message recipient can respond to a particular method. This generally requires reflection; e.g. it's a common pattern in Ruby to do the following:

```ruby
unknown_obj.message if unknown_obj.respond_to?(:message)
```

## Single vs. multiple dispatch

Single dispatch dispatches based only on the method receiver, e.g. `foo.method(bar)` will dispatch based on `foo` but will ignore `bar`. The convention of method calls, where `foo` precedes the dot, indicates `foo`'s status as somehow being special (it is the single value responsible for dispatch).

Multiple dispatch will dispatch based on both the receiver and the argument. This is a rarer dispatch system (seemingly only actively used in Lispy languages, and math-oriented languages like Julia... basically, non-OO languages where functions don't "belong" to an owner). Generally, methods are not associated with classes (as this association is only required because of single dispatch).
