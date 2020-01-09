module LongestPalindrome where

type Range = (Int, Int)

-- | Given length n of some string, generates a list of ranges that correspond
-- to possible palindrome centers for that string.
centerRanges :: Int -> [Range]
centerRanges = centerRanges' []
 where
  centerRanges' centers 0 = centers
  centerRanges' centers 1 = (0, 0) : centers
  centerRanges' centers n =
    centerRanges' ((n - 2, n - 1) : (n - 1, n - 1) : centers) (n - 1)

-- | Takes a substring of a string given a start and end index.
substring :: Int -> Int -> String -> String
substring start end = drop start . take (end + 1)

-- | Gets the longest palindrome for a given string.
-- Because the list will only ever contain 1-2 length strings or palindromes,
-- our validity check simply compares the first and last chars.
longestPalindrome :: String -> String
longestPalindrome s = longestPalindrome' "" (centerRanges $ length s)
 where
  longestPalindrome' longest [] = longest
  longestPalindrome' longest ((start, end) : ranges)
    | head center == last center = longestPalindrome' newLongest newRanges
    | otherwise                  = longestPalindrome' longest ranges
   where
    center     = substring start end s
    newLongest = if length longest > length center then longest else center
    newRanges  = if start > 0 && end < length s - 1
      then ranges ++ [(start - 1, end + 1)]
      else ranges
