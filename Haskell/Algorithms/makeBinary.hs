module MakeBinary where

makeBinary :: Int -> [Int]
makeBinary 0 = []
makeBinary 1 = [0, 1]
makeBinary n = prevList ++ newList
 where
  prevList = makeBinary (n - 1)
  newList  = map (\x -> x + 10 ^ (n - 1)) prevList
