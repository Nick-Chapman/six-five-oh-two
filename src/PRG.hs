
module PRG(
    ROM,
    init, read,
    bytes,
    ) where

import Prelude hiding (init,read)
import Data.Array(Array,(!),array)

import Six502.Values

data ROM = ROM { bytes :: [Byte], bytesA :: Array Int Byte }

size :: Int
size = 0x4000 -- 16k

init :: [Byte] -> ROM
init bytes = if
    | n == size -> ROM { bytes, bytesA = array (0,size-1) $ zip [0..] bytes }
    | otherwise -> error $ "PRG.init: " <> show n
    where
        n = length bytes

quick :: Bool
quick = True -- fps: 1.25 --> 15

read :: ROM -> Int -> Byte
read rom a = if
    | inRange a -> if
          | quick -> bytesA rom ! a
          | otherwise -> bytes rom !! a -- pre optimization -- this was terrible!
    | otherwise ->
      error $ "PRG.read: " <> show a

inRange :: Int -> Bool
inRange a = a >= 0 && a < size
