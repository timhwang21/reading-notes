# Syntax

## GHCI

* `ghci`: REPL
* `:load`, `:l`: compile script
* `:module +[MODULE]`, `:m +[MODULE]`: shortcut for `import`
* `:quit`, `:q`

## Syntax

* `import` -- `import Foo.Bar`

* `where`

```haskell
heron a b c = sqrt (s * (s - a) * (s - b) * (s - c))
    where
    s = (a + b + c) / 2
```

```javascript
heron = (a, b, c) => {
    const s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
};
```

* `let`

`let` variables have to be defined `in` the context they're used in:

```haskell
roots a b c = ((-b + sdisc) / (2 * a),
               (-b - sdisc) / (2 * a))
               where
               sdisc = sqrt (b * b - 4 * a * c)

roots a b c =
    let sdisc = sqrt (b * b - 4 * a * c)
    in ((-b + sdisc) / (2 * a),
        (-b - sdisc) / (2 * a))
```

Multiple variables can also be declared:

```haskell
contrivedFunc a =
    let foo = a * 2
        bar = a * 3
    in foo + bar
```

* Guards

```haskell
absolute_value x
    | x < 0  = -x
    | x >= 0 = x
```

* Composition (`.`)

```haskell
foo x = x + 3
bar x = x * x

-- All of the following are equivalent
foobar x = foo(bar x)
foobar x = (foo . bar) x
foobar = foo . bar
```

## Functions

Functions in Haskell have a very terse syntax -- `foo x = ...` is all you need, where the first term will be the function name and the rest will be arguments.

Alternatively, arrow notation can be used: `foo = \x -> ...`

### Infix functions

`+`, `==`, etc. can all be called when wrapped with parentheses.

Infix functions can be called like regular functions. `a == b` is equivalent to `(==) a b`.

The reverse is also true. `foo a b` is equivalent to `a ``foo`` b`.

## Equality & Conditionals

Haskell equality `==` is typed. Comparing two variables of different types throws an error.

`'a' == 1 -- errors: 'No instance for (Num Char) arising from the literal ‘1’'`

Haskell inequality is `/=`, not `!=`.

### Guards

**Guards** are syntactic sugar for what is basically a "case expression."

```haskell
absolute_value x
    | x < 0  = -x
    | x >= 0 = x
```

`otherwise` may be used as a catch-all.

Alternative syntax:

```haskell
absolute_value x < 0 = -x
absolute_value x >= 0 = x
```

Example with local variable:

```haskell
numSolutionsQuadratic a b c
    | disc > 0  = 2
    | disc == 0 = 1
    | otherwise = 0
        where
        disc = b^2 - 4*a*c
```
