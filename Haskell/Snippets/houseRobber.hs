module HouseRobber where

houserobber :: [Int] -> Int
houserobber = snd . foldr f (0, 0) . reverse
  where f n (prevMax, currMax) = (currMax, max currMax (prevMax + n))
