permute :: [a] -> [[a]]

--rotate constructs "rotations" of a list, e.g.:
--GHCi> rotate [1,2,3,4]
--[[1,2,3,4],[2,3,4,1],[3,4,1,2],[4,1,2,3]]
rotate x = rotate' x [] 0 where
	rotate' src dest n
		| n == length x = dest
		| otherwise = rotate' (tail src ++ [head src]) (dest ++ [src]) (n + 1)

--permTail gives permutations of the list's tail, e.g.:
--GHCi> permTail [1,2,3,4]
--[[1,2,3,4],[1,3,4,2],[1,4,2,3]]
permTail (x:xs) = map (x:) $ rotate xs

permute [] = [[]]
permute x = concat $ map (\x -> permTail x) $ rotate x


-- layer 0 [1,2,3,4]: [[1,2,3,4],[2,3,4,1],[3,4,1,2],[4,1,2,3]], like rotate
-- layer 1 [1,2,3,4]: [[1,2,3,4],[1,3,4,2],[1,4,2,3]]
-- layer 2 [1,2,3,4]: [[1,2,3,4],[1,2,4,3]]
layer n lst = [  take n lst ++ x | x <- rotate $ drop n lst ]

-- Formula: map $ layer n + 1 $ layer n element from rotate input
-- Condition: length input - 2 > 1, only one rotation for the last element

layerize lst = layerize' (layer 0 lst) 1 where
	layerize' src counter
		| length lst - counter == 1 = src
		| otherwise = layerize' (concat $ map (layer counter) $ src) (counter + 1)

--length $ layerize [1,2,3,4] = 24

--concat $ map (layer 2) $ concat $ map (layer 1) $ layer 0 [1,2,3,4]:
--[
--[1,2,3,4],[1,2,4,3],[1,3,4,2],[1,3,2,4],[1,4,2,3],[1,4,3,2],
--[2,3,4,1],[2,3,1,4],[2,4,1,3],[2,4,3,1],[2,1,3,4],[2,1,4,3],
--[3,4,1,2],[3,4,2,1],[3,1,2,4],[3,1,4,2],[3,2,4,1],[3,2,1,4],
--[4,1,2,3],[4,1,3,2],[4,2,3,1],[4,2,1,3],[4,3,1,2],[4,3,2,1]
--]

--length $ layerize [1,2,3,4,5] = 120

--concat $ map (layer 3) $ concat $ map (layer 2) $ concat $ map (layer 1) $ layer 0 [1,2,3,4,5]
--[
--[1,2,3,4,5],[1,2,3,5,4],[1,2,4,5,3],[1,2,4,3,5],[1,2,5,3,4],[1,2,5,4,3],
--[1,3,4,5,2],[1,3,4,2,5],[1,3,5,2,4],[1,3,5,4,2],[1,3,2,4,5],[1,3,2,5,4],
--[1,4,5,2,3],[1,4,5,3,2],[1,4,2,3,5],[1,4,2,5,3],[1,4,3,5,2],[1,4,3,2,5],
--[1,5,2,3,4],[1,5,2,4,3],[1,5,3,4,2],[1,5,3,2,4],[1,5,4,2,3],[1,5,4,3,2],
--[2,3,4,5,1],[2,3,4,1,5],[2,3,5,1,4],[2,3,5,4,1],[2,3,1,4,5],[2,3,1,5,4],
--[2,4,5,1,3],[2,4,5,3,1],[2,4,1,3,5],[2,4,1,5,3],[2,4,3,5,1],[2,4,3,1,5],
--[2,5,1,3,4],[2,5,1,4,3],[2,5,3,4,1],[2,5,3,1,4],[2,5,4,1,3],[2,5,4,3,1],
--[2,1,3,4,5],[2,1,3,5,4],[2,1,4,5,3],[2,1,4,3,5],[2,1,5,3,4],[2,1,5,4,3],
--[3,4,5,1,2],[3,4,5,2,1],[3,4,1,2,5],[3,4,1,5,2],[3,4,2,5,1],[3,4,2,1,5],
--[3,5,1,2,4],[3,5,1,4,2],[3,5,2,4,1],[3,5,2,1,4],[3,5,4,1,2],[3,5,4,2,1],
--[3,1,2,4,5],[3,1,2,5,4],[3,1,4,5,2],[3,1,4,2,5],[3,1,5,2,4],[3,1,5,4,2],
--[3,2,4,5,1],[3,2,4,1,5],[3,2,5,1,4],[3,2,5,4,1],[3,2,1,4,5],[3,2,1,5,4],
--[4,5,1,2,3],[4,5,1,3,2],[4,5,2,3,1],[4,5,2,1,3],[4,5,3,1,2],[4,5,3,2,1],
--[4,1,2,3,5],[4,1,2,5,3],[4,1,3,5,2],[4,1,3,2,5],[4,1,5,2,3],[4,1,5,3,2],
--[4,2,3,5,1],[4,2,3,1,5],[4,2,5,1,3],[4,2,5,3,1],[4,2,1,3,5],[4,2,1,5,3],
--[4,3,5,1,2],[4,3,5,2,1],[4,3,1,2,5],[4,3,1,5,2],[4,3,2,5,1],[4,3,2,1,5],
--[5,1,2,3,4],[5,1,2,4,3],[5,1,3,4,2],[5,1,3,2,4],[5,1,4,2,3],[5,1,4,3,2],
--[5,2,3,4,1],[5,2,3,1,4],[5,2,4,1,3],[5,2,4,3,1],[5,2,1,3,4],[5,2,1,4,3],
--[5,3,4,1,2],[5,3,4,2,1],[5,3,1,2,4],[5,3,1,4,2],[5,3,2,4,1],[5,3,2,1,4],
--[5,4,1,2,3],[5,4,1,3,2],[5,4,2,3,1],[5,4,2,1,3],[5,4,3,1,2],[5,4,3,2,1]
--]
