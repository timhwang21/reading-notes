# Generics

## Implementation

Problem statement: we have a "collection" data structure that we want to be generic.

### Boxing

- Put data on the heap, and store pointers to the data in the collection.
- Benefit: "smart", allows dynamic runtime behavior
- Downside: Extra memory allocation, dynamic lookup
- Downside: sometimes requires lots of typecasts when reading from/writing to collection (covariance / contravariance issue); when improperly used can lead to runtime crashes
- Solution: typed generics with type erasure. Allow generics to receive a type in code, which is entirely ignored at runtime

### Monomorphization

- Have many similar but slightly different implementations of the collection data structure for every type that can go in it
- Benefit: fast
- Downside: code bloat, longer compile time
- Aside -- code generation falls into the land of macros, of which there are different types
   - string -> string: C
   - tokens -> tokens (-> strings): Rust procedural macros
   - AST -> AST: Lisp(s)

## Resources

- [A tour of metaprogramming models for generics](https://thume.ca/2019/07/14/a-tour-of-metaprogramming-models-for-generics/)
