# Modules

## Syntax

* `ghc --make -o OUTPUT input.hs`

### Defining modules

`module ModuleName where` -- `ModuleName.hs`

### Imports

#### Modules

Also see [haskell.org docs](https://wiki.haskell.org/Import).

##### Regular

```
-- imports all exports as qualified (namespaced) and global
import Path.To.Module

-- naming imports
import Path.To.Module as M

-- imports selected exports
import Path.To.Module (namedImport, namedImport2)

-- imports all but some exports
import Path.To.Module hiding (unwantedImport)
```

##### Qualified

Import namespaced only.

```haskell
import qualified Path.To.Module

Path.To.Module.myFunc
```

#### Types

`import ModuleName (Type(Constructor))`

#### Modules

```haskell
module MyModule (foo, bar) where

foo x = x

bar y = y

-- baz is not exported
baz z = z
```

### Exporting

#### Types

```haskell
module MyTree (Tree(Branch, Leaf)) where

data Tree a = Branch { left, right :: Tree a }
            | Leaf a
```

#### Programs

```haskell
module Main where
-- notice no named exports

main :: IO ()
main = do whatever
```

```bash
ghc --make -o myProgram file.hs
./myProgram
```
