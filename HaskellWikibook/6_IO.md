#I/O

## Syntax

* `putStr :: String -> IO ()`
  * IO action that returns `()`
  * `IO` type representing I/O
  * `()` - "unit" (0-tuple); here, the return value of the I/O action
* `getLine :: IO String`
  * Doesn't take arguments; returns a string
* `do`
  * Lets you string actions together imperatively
  * The last statement must be an expression (e.g. not an `<-` assignment)
  * Final type of `do` is type of last expression
  * Can assign local variables with `let`, without needing `in` context (`in` is
    basically the `do` block)
* `<-` - assigns value of `IO` to variable
* `read` - casts strings; used for user input
  * `readInt :: String -> Int` `readInt "5" == 5 -- True`
  * `readBool :: String -> Bool` `readBool "True" == True -- True`

```haskell
main :: IO ()
main = do
  putStrLn "What is your name?"
  name <- getLine
  putStrLn ("Hello, " ++ name ++ ", how are you?")
  status <- getLine
  putStrLn (status ++ "? Amazing!")
```