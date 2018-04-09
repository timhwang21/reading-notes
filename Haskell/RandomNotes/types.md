# Types

* A **type** is an algebraic structure; i.e. it is a set of finite values and the morphisms (functions) defined over them.
* a **typeclass** is a set of types. Each type is an instance that defines some operation for the type. E.g:
  * `List` has an instance of `Functor` that defines `fmap`
  * `List` has an instance of `Monad` that defines `bind`
