# Learn the Kotlin programming language

## Variables

- `var` is JS `let`
- `val` is JS `const`
- Lazy initialization: `val x by lazy { ... }`

## Types

### Type assertions

```kotlin
when (x) {
    is Foo -> ...
    is Bar -> ...
    else   -> ...
}
```

### Generics

- Constraints: `fun <T : Comparable<T>>` is like Typescript `function<T extends Comparable<T>>`

## Control flow

### `if`-`else`

- Just like JS, but are expressions:

```kotlin
val foo = if (cond) {
    "bar"
} else {
    print("Implicit returns")
    "baz"
}

// Inline
val foo = if (cond) then "bar" else "baz"
```

### `when`

- Similar to Haskell guards
- Are expressions and not statements (so can be used for assignment)

```kotlin
// With argument and value cases
val answerString = when (count) {
    42 -> "I have the answer."
    41, 43 -> "The answer is close."
    in 0..39 -> "Too low"
    is String -> "Give a number, not a string"
    else -> "The answer eludes me."
}

// With no argument, cases become top-down boolean expressions
val answerString = when {
    count == 42 -> "I have the answer."
    count > 35 -> "The answer is close."
    else -> "The answer eludes me."
}

// Can declare a variable as argument
val answerString = when (val count = getRandomNumber()) {
    42 -> "I have the answer."
    41, 43 -> "The answer is close."
    in 0..39 -> "Too low"
    is String -> "Give a number, not a string"
    else -> "The answer eludes me."
}
```

### `for..in`

- Works on any value with a member- or extension-function `iterator()` that returns a value with methods `next(): T` and `hasNext(): Boolean`

```kotlin
for (item: Int in ints) {
// ...
}
```

## Labels

Certain things can be annotated with @-labels to indicate some form of scope or ownership

- `this@A` means A's `this`
- `return@f` means a local return for lambda `f`
- `break@loop1` means break at a given loop (e.g. when there are nested loops)

## Keywords

- `tailrec` - indicates a function is tail-recursive and should be unrolled
- `operator` - indicates a function meant to be used as an infix operator
- `inline` - indicates a compiler optimization to inline functions into call sites should be done
