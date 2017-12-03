# Indentation

## Core Rules

Code in an expression should be indented further than the beginning of the expression:

```haskell
-- wrong: let, a, and b must be indented beyond foo
foo =
let
a = 1
b = 2
  in a + b

-- correct
if foo
  then bar
  else baz
```

Syntactically parallel keywords must line up:

```haskell
--wrong: a and b must line up
foo =
  let
    a = 1
     b = 2
  in a + b
```

Only leading indentation is syntactically relevant: intermediary whitespace is purely aesthetic:

```haskell
myFunc []                   = "spaces between [] and = are optional"
myFunc (a:b:c:d:e:f:g:h:is) = "something contrived"
myFunc (l:a:z:y) = "also valid"
```

## Character-based indentation (for whitespace haters)

1. Layout keywords (`let`, `do` etc.) followed by `{`
2. Anything that should be indented to the same level followed by `;`
3. Anything that should be indented less followed by `}`

```haskell
-- ugly but valid syntax
foo :: Double -> Double
foo x =
  let {
s = sin x;
            c = cos x;
}
  in a + b
```

## Gotcha: `if` in `do`

```haskell
-- wrong -- compiler can't tell when if ends
main = do thing
          if foo
          then bar
          else baz
          thing2

-- right 1
main = do thing
          if foo
            then bar
            else baz
          thing2

-- valid but bad practice
main = do
  thing
  if foo
  then bar
  else baz
  thing2

-- right 2
main = do
  thing
  if foo
    then bar
    else baz
  thing2
```
