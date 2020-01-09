module MergeSort where

mergeSort :: Ord t => [t] -> [t]
mergeSort []  = []
mergeSort [x] = [x]
mergeSort xs  = merge (mergeSort fstHalf) (mergeSort sndHalf)
 where
  fstHalf = take halfLen xs
  sndHalf = drop halfLen xs
  halfLen = length xs `div` 2

merge :: Ord t => [t] -> [t] -> [t]
merge xs [] = xs
merge [] ys = ys
merge (x : xs) (y : ys) | x <= y    = x : merge xs (y : ys)
                        | otherwise = y : merge (x : xs) ys
