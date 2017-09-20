# Control Structures

## `if`

* `if`s are expressions in Haskel1.
  * This means that `if then else` behaves more like a ternary than if-statements in other languages.
  * This also means that `then` and `else` can't be omitted.
* `if`s and guards are mostly interchangeable:

```haskell
badNumToChar n =
  if c == 1
    then 'a'
    else if c == 2
      then 'b'
      else "dunno"

badNumToChar n
  | n == 1 = 'a'
  | n == 2 = 'b'
  | otherwise = "dunno"
```

## `case`

* Sort of like the `if` statements of pattern matching
* Because the case statement is matching against expressions
  * This also enables pattern matching and binding

```haskell
f 1 = 'a'
f 2 = 'b'
f _ = "dunno"

f x =
  case x of
    1 -> 'a'
    2 -> 'b'
    _ -> "dunno"
```

One important difference is that pattern matching is a statement while `case` is an expression like `if`:

```haskell
data Color = Black | White | RGB Int Int Int

getColor :: Color -> String

One important difference is that pattern matching is a statement while `case` is an expression like `if`:

```haskell
data Color = Black | White | RGB Int Int Int

describeColor :: Color -> String
describeColor Black             = "Black"
describeColor White             = "White"
describeColor (RGB 0 0 0)       = "Black"
describeColor (RGB 255 255 255) = "White"
describeColor (RGB r g b)
  | r > g && r > b              = "Red(ish)"
  | g > r && g > b              = "Green(ish)"
  | b > r && b > g              = "Blue(ish)"
  | otherwise                   = "Something"

describeColor2 :: Color -> String
describeColor2 c =
  "This looks like" ++ -- can't do this with pattern match
  case c of
    Black -> "Black"
    White -> "White"
    (RGB 0 0 0) -> "Black"
    (RGB 255 255 255) -> "White"
```

Example of case statement instead of nested if-then:

```haskell
doGuess num = do
  guess <- getLine
  case compare (read guess) num of
    LT -> do putStrLn "Too low"
          doGuess num
    GT -> do putStrLn "Too high"
          doGuess num
    EQ -> putStrLn "Correct"
```

Note: `LT` is **l**ess **t**han, `GT` is **g**reater **t**han, `EQ` is **eq**ual.

Compared to `>`, `<`, `==`: the former are values of type `Ordering`, while the latter are infix functions.
