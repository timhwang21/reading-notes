import           Data.Char

-- any small functions that catch my attention are logged here

sentenceCase :: String -> String
sentenceCase []     = []
sentenceCase (x:xs) = toUpper x : map toLower xs

capLast :: [String] -> [String]
capLast []     = []
capLast (x:[]) = (sentenceCase x) : []
capLast (x:xs) = (map toLower x) : (capLast xs)

sentenceReverse :: String -> String
sentenceReverse = (unwords . reverse . capLast . words)

nonetrue :: [Bool] -> Bool
nonetrue []         = False
nonetrue (True:xs)  = False
nonetrue (False:xs) = nonetrue $ tail xs

onetrue :: [Bool] -> Bool
onetrue []         = False
onetrue (True:xs)  = nonetrue $ tail xs
onetrue (False:xs) = onetrue $ tail xs

data Tree a = Leaf
            | Branch (Tree a) (Tree a)

fibonacci :: (Num a, Eq a) => a -> [a]
fibonacci 0 = [1]
fibonacci 1 = [1, 1]
fibonacci n = head list + head (tail list) : list
  where
  list = fibonacci (n - 1)

quickSort :: Ord t => [t] -> [t]
quickSort [] = []
quickSort (x:xs) = (quickSort less) ++ [x] ++ (quickSort more)
    where
      (less, more) = splitAtPivot x xs

splitAtPivot :: Ord t => t -> [t] -> ([t], [t])
splitAtPivot _ [] = ([], [])
splitAtPivot n (x:xs)
  | x < n     = (x : fst split, snd split)
  | otherwise = (fst split, x : snd split)
  where
    split = splitAtPivot n xs

mergeSort :: Ord t => [t] -> [t]
mergeSort [] = []
mergeSort [x] = [x]
mergeSort xs = merge (mergeSort fstHalf) (mergeSort sndHalf)
    where
        fstHalf = take halfLen xs
        sndHalf = drop halfLen xs
        halfLen = length xs `div` 2

merge :: Ord t => [t] -> [t] -> [t]
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys)
  | x <= y    = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

houserobber :: [Int] -> Int
houserobber = snd . (foldr f (0, 0)) . reverse
  where
    f n (prevMax, currMax) = (currMax, max currMax (prevMax + n))
