```haskell
map :: (a -> b) -> [a] -> [b]
-- no alias

-- fmap is generic map; technically wherever you can use map you can use fmap
-- a type is a functor if it has a lawful implementation of fmap
fmap :: Functor f => (a -> b) -> f a -> f b
<$> = fmap = lifted $ :: (a -> b) -> a -> b
<&> = flip fmap

bind :: Monad m => (a -> m b) -> m a -> m b
-- a type is a monad if it has a lawful implementation of bind
-- actually not defined as `bind`
=<< = bind
>>= = flip bind

-- note that Haskell compiler doesn't verify lawfulness so technically in
-- Haskell a monad is any type with any implementation of bind that compiles
```
