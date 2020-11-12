# Functions

- Argument type annotations are _required_
- Return type annotation is required unless:
  - The function is an expression and the type is inferrable
  - The return type is `Unit`
- Can refer to functions as objects by prepending `::`; e.g. `::square`

```kotlin
// Function statement
fun square(x: Int): Int {
    return x ** 2
}
// Function expression
fun square(x: Int): Int = x ** 2
// Anonymous function
fun(x: Int): Int = x ** 2
```

## Modifiers and keywords

- `vararg` is like spread parameters, except they don't need to be trailing; however, if not trailing, trailing arguments _must_ be called with named argument syntax
  - On the calling side, Ruby's splat operator exists for arrays
- Functions can be prepended with the `infix` keyword which does what you'd expect, if 1) they are methods or member functions; 2) they are unary and don't use `vararg`
  - Note that infix functions cannot use implicit receivers, e.g. no implicit `this`
- `tailrec` can be added in front of appropriate recursive functions to be optimized as non-recursive functions (why is this not automatically done...)
- `inline` causes the function (and all functions passed as parameters) to be inlined into the call site

## Lambdas

- Implicit returns (if last statement is an expression, returns it)
- Looks like TS, but types don't need names (but you can supply them if you wish)
- Non-local returns (kind of the opposite of Ruby); but can do local returns with special weird-looking syntax
- Differs from anonymous functions in that anonymous functions have local returns
- Otherwise same semantics as your standard lambda w.r.t. closures, etc.
- In unary lambdas, the argument is implicitly named `it`

```kotlin
// Full
val square: (Int) -> Int = { x: Int -> x * 2 }
// Abridged
val square = { x: Int -> x * 2 }
// Super abridged -- infers type from context
max(nums, { a, b -> a > b})
// Super super abridged -- only for unary lambdas with inferred type
nums.map { it + 1 }
// Qualified return -- regular return is nonlocal in lambdas
nums.map {
    return@map it + 1
}
```

## Higher-order functions

- Just like JS, with some Ruby-isms

```kotlin
fun foldR<A, B>(f: (B, A) -> B, acc: B, arr: A[]): B = f(foldR(f, acc, arr.drop(1)), arr.first())
fun foldL<A, B>(f: (B, A) -> B, acc: B, arr: A[]): B = foldL(f, f(acc, arr.first()), arr.drop(1))

// When last argument is function, can place outside like a Ruby block
ints.map({ x -> x ** 2 })
ints.map { x -> x ** 2 }
ints.map { it ** 2 }
ints.fold(0, { acc, e -> acc + e })
ints.fold(0) { acc, e -> acc + e }
// cannot use it-syntax with 2-ary function
```

## Extensions

- Feels like a way to "simulate" method monkey-patching
- However, no patching actually occurs, just adds sugar to make functions callable in dot-notation
- Extensions are static dispatch, meaning their resolution is based on parameter type, not the type of object the "method" is (or, appears to be) called on
- If an extension has the same name and signature as an actual method, it is a no-op; the method always wins
- However, if the signature is different, you can get parametric polymorphism
- Receiver is implicitly named `this`

```kotlin
fun Int.sum(x: Int): Int = this + x
```

## Functions with receivers

- Receiver is implicitly named `this`
- Semantically identical to extension functions, but generally intended to be used as arguments for higher-order functions, while extensions are for monkey-patching (kind of)
- Lambdas can access the properties of the receiver implicitly, as if they were defined inside the class (see `plus()` example below)

```kotlin
val sum: Int.(Int) -> Int = { x -> plus(x) }
val sum: fun Int.(x: Int): Int = this.plus(x)
// standard call
sum(1, 2)
// Extension-like call
1.sum(2)
```

## [Scope functions](https://kotlinlang.org/docs/reference/scope-functions.html#functions)

[Usage guide](https://kotlinlang.org/docs/reference/scope-functions.html#function-selection)

### `apply`

- "Apply these changes to this object"
- Refers to context object as `this`
- Returns context object (`this`)
- Used to call some methods on `this`
- Also used with objects to set properties; `obj.apply { prop1 = 1; prop2 = 2; etc. }`

### `run`

- "Run this statement using this object"
- Refers to context object as `this`
- Returns lambda result
- Is not an extension function
- Used with mutative methods, e.g. `arr.run { add(1) }`
- Feels a lot like `let`, but more method-oriented
- Also used to convert any statement to an expression, e.g. `val result = run { ...multiline initialization... }`

### `with`

- "Do something with this object without modifying the object"
- Refers to context object as `this`
- Returns lambda result
- Is not an extension function
- Used with getter methods, e.g. `arr.with { first() }`

### `also`

- Also do something with this object
- Refers to context object as lambda argument
- Returns context object (`this`)
- Used as forking side effect, e.g. `x.also { println("Value: $it") }`
- Should not be used with pure functions, e.g. `x.also { transform(it) }` is a no-op if `transform` does not mutate its argument
- Like Ruby `#tap`

### `let`

- Refers to context object as lambda argument
- Returns lambda result
- Used for mapping, e.g. `arr.let { transform(it) }`
- Notably also used for nullable mapping: `arr?.let { transform(it) }`
- Also used to define intermediary variables in a smaller scope without affecting outside closure; `arr.first().let { ...block using first item... }`
- Like Ruby `#then`

## Function types

```kotlin
typealias NumberFn = (Int) -> Int
```

## Calling functions

```kotlin
// Member function
List<Int>::size
// Top-level function
::isOdd
// Bound methods: unlike JS, can't just omit () to access methods as values
val foo: Int = 123
val boundFn = foo::toString
boundFn() // "123"
```

- Functions with default arguments are automatically treated like argument lists; you can specify the name and then omit / reorder arguments
