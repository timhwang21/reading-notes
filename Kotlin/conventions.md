# Principle of conventions

Kotlin is quite opinionated when it comes to implicit identifiers, with stuff like `it` for implicit variables in unary lambdas. In other words, specific language constructs work on functions with specific names, which informs coding style.

## Magic method names

### `plus|minus|times|div|mod(Assign?)`

- If your class has a unary method defined as `operator fun plus`, Kotlin will automatically allow the `+` operator
- `plusAssign` etc. will override `+=` etc.

### `equals`

- `==`, `!=`

### `compareTo`

- `<`, `>`, `<=`, `>=`

### `get`, `set`

- `foo[1]` becomes `foo.get(1)`
- `foo[1] = x` becomes `foo.set(1, x)`

### `contains`

- `x in arr` becomes `arr.contains(x)`

### `rangeTo`

- `foo..bar` becomes `foo.rangeTo(bar)`

### `iterator`

`for (x in list)` becomes `list.iterator()` and a bunch of `next()` calls

### `invoke`

You can call instances of a class as functions if the class has `operator fun invoke(...)` defined. This is often used for classes representing actions and is similar to function factories:

```kotlin
class Mailer(...) {
    operator fun invoke(...)
}

val mail = Mailer(someMailerOptions)

// Calls Mailer::invoke() with args
mail('timhwang21@gmail.com', 'Click here for free money')
```

### `component1, component2...`

`val (a, b, c) = foo` becomes:

```kotlin
val a = foo.component1()
val b = foo.component2()
val c = foo.component3()
```

## Magic variables

### `this`

- Pretty much the same as JS `this` but cleverer; supports labels
- Refers to target in extension functions and functions with receivers
- Refers to instance in classes
- Refers to target in `run()`, `with()`, `apply()`

```kotlin
class A {
    implicit class B {
        fun Int.foo() { // some extension
            this // what's this?
            this@A // A's this
            this@B // B's this
            this@foo // the receiver of type `Int`
        }
    }
}
```

### `it`

- Refers to the argument in a unary function without a default value where the type can be derived
- Also provided for `let()` and `also()`

# Style guide

[Kotlin has a first-party style guide.](https://kotlinlang.org/docs/reference/coding-conventions.html)
