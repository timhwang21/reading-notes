import Data.Char

import Data.Char

sentenceCase :: String -> String
sentenceCase [] = []
sentenceCase (x:xs) = toUpper x : map toLower xs

capLast :: [String] -> [String]
capLast [] = []
capLast (x:[]) = (sentenceCase x) : []
capLast (x:xs) = (map toLower x) : (capLast xs)

sentenceReverse :: String -> String
sentenceReverse = (unwords . reverse . capLast . words)

nonetrue :: [Bool] -> Bool
nonetrue [] = False
nonetrue (True:xs) = False
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

