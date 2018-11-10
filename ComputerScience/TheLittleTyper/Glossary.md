# Glossary

## Expressions

Everything is an **expression**.

An expression preceded by a constructor is a **value**. An expression may or may not be evaluated into a value.

A value that can no longer be evaluated is **normal**. Two expressions are the same if they have the same normal forms, and vice versa.

An expression that cannot be evaluated is **neutral**. This can be because the expression contains a variable that has not yet been supplied. Two neutral expressions are the same if their bodies are the same post-substitution of variable names.

## Types

A **constructor** for a given type generates a value with the given type with (optional) arguments.

> `cons` is a constructor for `Pair`s. `cons : a -> b -> Pair a b`

A **eliminator** for a given type generates values from an argument of the given type.

> `car` and `cdr` are destructors for `Pair`s. `car : Pair a b -> a`, `cdr : Pair a b -> b`

A **universe** `U` is the type of all types but itself. Types containing `U` are not `U`s, but are `U(1)`s (see Russell's Paradox).

> `Atom`, `Nat`, `Pair Atom Atom` are `U`s. `cons Atom Atom` is a `Pair U U`. `U` and `Pair U U` are `U(1)`s. `U(n)` is a `U(n+1)`.
