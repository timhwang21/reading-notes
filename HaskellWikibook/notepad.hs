replicate' :: Int -> a -> [a]
replicate' 0 _ = []
replicate' n a = a : replicate' (n - 1) a

getAt :: [a] -> Int -> a
getAt (x:_) 0  = x
getAt (_:xs) n = getAt xs (n - 1)

zip' :: [a] -> [b] -> [(a, b)]
zip' [] _ = []
zip' _ [] = []
zip' (x1:xs1) (x2:xs2) = (x1,x2) : zip' xs1 xs2

take' :: Int -> [a] -> [a]
take' 0 _ = []
take' _ [] = []
take' n (x:xs) = x : take' (n - 1) xs