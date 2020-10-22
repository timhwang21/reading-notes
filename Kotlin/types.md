# Types

## Strings

- Allow template interpolation with `$` for variables and `${}` for expressions
- Raw strings are like heredocs
- `"\$"` to print a dollar sign in a regular string
- `${'$'}` to print a dollar sign to a raw string (lol)

```kotlin
val rawString = """
Whitespace is preserved.
    This line will have leading spaces.
    |To remove leading spaces, use `trimMargin()`.
    >TrimMargin can be called with a prefix character (defaults to |).
""".trimMargin()
```

## Numbers

- [`Int`, `Byte`, `Short`, `Long`, `Float`, `Double`]

## Nulls

- Nullability: `val nullable: String? = null`
- Not-null assertion: `foo.bar!!.baz`
- Safe access: `foo.bar?.baz`
- Type refinement: checking if `val != null` removes `null` from `val`'s type

### `Unit`

- `void`, basically

## Arrays

- No array literal syntax :( must use `arrayOf(v1, v2, v3)`

### Similar structures

- `Array`s are mutable, fixed-size containers; factory `arrayOf()`
- `ArrayList`s are mutable, variable-size containers; factory `arrayListOf()` or `mutableListOf()`
- `List`s are immutable, fixed-size containers; factory `listOf()`

### Primitive type arrays

- Same API as arrays, but do not inherit from `Array` (and thus avoid boxing overhead)
- `IntArray`, `ByteArray` etc.

## Maps

- `mapOf("a" to 1, "b" to 2, "c" to 3)`
