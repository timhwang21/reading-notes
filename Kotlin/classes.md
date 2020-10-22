# Classes

## Definition

### Constructors, initializer blocks, and properties

```kotlin
// Single primary constructor; is more of an argument and has no initialization
// code
class InitOrderDemo(
    name: String,
    val inlineProperty: String,
    var inlineMutableProperty: String,
) {
    // Ctor can be used in class properties
    val firstProperty = "First property: $name".also(::println)

    // Multiple initializer blocks can appear and are executed in order
    init {
        println("First initializer block that prints ${name}")
    }

    val secondProperty = "Second property: ${name.length}".also(::println)

    init {
        println("Second initializer block that prints ${name.length}")
    }

    // Properties can be nullable in that `null` is a valid state
    var nullableProperty: String? = null

    fun someOtherMethod() {
        nullableProperty = "No longer null"
    }

    // `lateinit` is used for properties where `null` is invalid, but cannot be
    // set on initialization for some reason
    lateinit val lateInitProperty: String

    fun someOtherMethod() {
        lateInitProperty = "Created after init"
    }
}

// Single secondary constructor; allows initialization code
class InitOrderDemo {
    constructor(name: String) {
        // Do setup here
    }
}

// Both primary and secondary constructor; secondary ctor must delegate to
// primary ctor; this is done via `this()` which is like `super()`
class InitOrderDemo(val name: String) {
    constructor(name: String, parent: InitOrderDemo) : this(name) {

    }
}

// If annotations are used, the keyword `constructor` is required
// In this declaration, `name` is a public property
class Customer public @Inject constructor(name: String) { /*...*/ }

```

- `init` blocks are called by the primary constructor
- The delegation to the primary constructor always happens as the first action in a secondary constructor (contrary to other languages where the `super()` call can be placed anywhere)
- If the primary constructor is omitted, a nullary `public constructor()` is inserted
  - Thus, secondary constructors always implicitly delegate to a primary constructor
- Fields are evaluated top-down; `init` blocks can precede secondary constructors

### Functions

- Basically methods

## Instantiation

- Simply call classes as functions (`Customer("Tim")`)
