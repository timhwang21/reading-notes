# Categories

Categories are a class of morphisms ('maps') over algebraic structures (objects), such that:
- For any 2 objects `a` and `b` within the class `C`, a collection of morphisms exist `morphism :: (C a, C b) => a -> b`
- For any 3 objects `a`, `b`, and `c` within the class `C`, an operation `.` (composition) exists such that `f :: (C a, C b) => a -> b` and `g :: (C b, C c) => b -> c` can be composed as `f . g` such that `(f . g) x == f(g(x))`, and such that the following hold:
  - Associativity: `(f . g) . h == f . (g . h)`
  - Identity: for every `x` there is an identity `x -> x`

A *class* is simply a collection of algebraic structures that share some property in common.

Categories are tuples `(structure, morphism)`.

## Categories of structures

This statement comes up a lot and I find it very unintuitive, so I'm writing down my understanding so I can refer back to it (and improve / correct it) in the future:

> A group is a category with a single object, and in which all maps are isomorphisms.

Remember that groups are monoids whose binary operation is isomorphic, and that categories are a class of algebraic objects, and that objects are analogous to typeclasses. As there is only one object in the category, all maps are of type `a -> a`. This singular object corresponds the set of all possible elements and maps within the group. However, when discussing sets, we talk about collections of elements and morphisms, while when talking about categories, we treat this collection simply as a single black box. This illustrates how category theory operates at a higher level of abstraction, and is concerned about how different groups (or any kind of object) relate, rather than how interior elements of the object relate to each other.

Explaining the latter part: remember that one defining aspect of groups is the presence of identity. The map between any element of a group thus necessarily must have an inverse.

As a top-down explanation, remember that categories are objects composed of a class of objects and all the mappings between each. What if we had a category with a single object, and where all maps just happened to be invertible? This means that all operations are of type `(Object a, Object b) => a -> b` with the appropriate inverse. This fits the criteria for a group.

Interestingly enough, what if we ignore the invertibility constraint? We then get a category with a single object, where all operations are of type `(Object a, Object b) => a -> b` without an inverse. This is just a monoid! This exercise can be extended for the other algebraic structures we've seen.

We've now seen that any single structure is a category with a single object that posses the same constraints as the structure. What about the category that didn't just have a single object, but instead had all objects that fit the given constraints? We then arrive at "canonical" categories of structures, e.g. `Set` being the category of all sets, `Grp` being the category of all groups, etc.

## Category morphisms? Functors

As categories are themselves structures, there is a category for all categories `(category, morphism)` where the morphisms are functors.

## What is a functor?

A functor is a pair of:

1. a function `a -> f a` that means "for every element in a category, there is a corresponding element in the counterpart category."
2. for every element in `a`, a function `a -> b -> f a -> f b` that means "for every map between elements of a category, there is a corresponding map between elements of the counterpart category."

Additionally, functors must satisfy the following axioms:

1. `f (func1 . func2) == f func1 . f func2` when functions are in category (distribution)
2. `f (id a) == id (f a)` (identity)

From these laws we can derive other interesting properties, e.g. for every composition chain `f1 -> f2 -> ... -> fn` where each has type `a -> a`, there is exactly one function `f a -> f a` (as per rule 2).

## Functors of functors? Natural transformations

The functors between two categories itself is a category `(functor, morphism)` where the morphisms are the *natural transformations* between the functors. Given the two categories `C` and `D` and two functors between them `f` and `g`, the natural transformation must map `f a -> g a` for every `a` in `C`. (Remember that `f :: C a => a -> f a` and `g :: C a => a -> g a`.)

More formally, we can illustrate the natural transformation between the following two functors which produce this map between categories `a` and `b`. First we start with an illustration of a functor. Below, the following functor creates a mapping of `x` to `f x` for every `x` in `a`, and a mapping of `x -> y` to `f x -> f y` for every `x -> y` in `a`:

```
  a ->   b
 v   v  v
f a -> f b
```

(This is an example of a *commutative diagram*. If we take the first `->` to be `f1 :: a -> b` and the last `v` to be `g1 :: b -> f b`, along with the first `v` to be `f2` and the last `->` to be `g2` the operation is commutative if `g1 . f1` is identical to `g2 . f2`. Based on the functor laws, this operation always commutes.)

Similarly, the natural transformation produces a map between categories `a` and `b`. The natural transformation is the commutative mapping of `f x` to `g x` for every `x` in `a`, and the mapping of `f x -> f y` to `g x -> g y` for every `f x -> f y` and `g x -> g y`.

```
f a -> f b
 v   v  v
g a -> g b
```

Put intuitively:

- Operations are maps between elements of a structure. `operation :: a -> a -> a`
- Functors are maps between categories (which are composed of structures and arrows; thus, a functor maps objects to objects and arrows to arrows). `functor :: a -> b -> f a -> f b`
- Natural transformations are maps between functors. `naturalTransformation :: (Functor f, Functor g) => f a -> f b -> g a -> g b`

