
module PPU.NewGraphics(
    PAT, patFromBS,
    Screen, forceScreen,
    screenToBitmapByteString,screenWidth,screenHeight,
    screenTiles,
    screenBG,
    Palettes(..),Palette(..),
    ) where

import Data.Array
import Data.Bits
import qualified Data.List as List
import qualified Data.ByteString as BS

import Byte
import PPU.Colour as Colour

newtype PAT = PAT (Array Int Byte)

patFromBS :: [Byte] -> PAT
patFromBS = PAT . listArray (0,4095)

mkBS :: [Colour] -> BS.ByteString
mkBS cols = BS.pack $ map fromIntegral $ concat $ do
    col <- cols
    let (r,g,b) = Colour.toRGB col
    return [r,g,b,255]

data Screen = Screen {height,width :: Int, cols :: [Colour] }

screenToBitmapByteString :: Screen -> BS.ByteString
screenToBitmapByteString Screen{cols} = mkBS cols

screenWidth :: Screen -> Int
screenWidth Screen{width} = width

screenHeight :: Screen -> Int
screenHeight Screen{height} = height

forceScreen :: Screen -> Int
forceScreen Screen{cols} = do
    let xs = map fromIntegral $ concat $ do
            col <- cols
            let (r,g,b) = Colour.toRGB col
            return [r,g,b]
    List.foldr (+) 0 xs

data ColourSelect = BG | CS1 | CS2 | CS3
data PaletteSelect = Pal1 | Pal2 | Pal3 | Pal4
data Palette = Palette { c1,c2,c3 :: Colour }
data Palettes = Palettes { p1,p2,p3,p4 :: Palette, bg :: Colour }

selectColour :: Colour -> Palette -> ColourSelect -> Colour
selectColour bg Palette{c1,c2,c3} = \case
    BG -> bg
    CS1 -> c1
    CS2 -> c2
    CS3 -> c3

selectPalette :: Palettes -> PaletteSelect -> Palette
selectPalette Palettes{p1,p2,p3,p4} = \case
    Pal1 -> p1
    Pal2 -> p2
    Pal3 -> p3
    Pal4 -> p4

screenTiles :: PAT -> Screen -- see all 256 tiles in the PAT
screenTiles (PAT pt) = do
    let (bg,somePalette) = do
            let black = Colour.ofByte 0x0F
            let red = Colour.ofByte 0x06
            let green = Colour.ofByte 0x2a
            let white = Colour.ofByte 0x20
            (black, Palette { c1 = red, c2 = green, c3 = white })
    let ntSmall = listArray (0,255) [0..255]
    let cols = do
            y <- [0..127]
            x <- [0..127]
            let nti = 8*(y`div`8) + x`div`8
            let ti = fromIntegral $ unByte $ ntSmall ! nti
            let pti = 16*ti + y`mod`8
            let tileByteA = pt ! pti
            let tileByteB = pt ! (pti+8)
            let tileBitA = tileByteA `testBit` (7 - x`mod`8)
            let tileBitB = tileByteB `testBit` (7 - x`mod`8)
            let cSel =
                    if tileBitA
                    then (if tileBitB then CS3 else CS2)
                    else (if tileBitB then CS1 else BG)
            return $ selectColour bg somePalette cSel
    Screen { height = 128, width = 128, cols}


screenBG :: Palettes -> [Byte] -> PAT -> Screen
screenBG pals kb (PAT pt) = do
    let Palettes{bg} = pals
    let nt = listArray (0,959) (take 960 kb)
    let at = listArray (0,63) (drop 960 kb)
    let cols = do
            yDiv8 <- [0..29::Int]
            let y4 = yDiv8 `testBit` 1
            let yDiv32 = yDiv8 `div` 4
            yMod8 <- [0..7::Int]
            xDiv32 <- [0..7] -- x765
            let ati = 8 * yDiv32 + xDiv32
            let atByte  = at ! ati
            x43 <- [0..3]
            let x4 = x43 `testBit` 1
            let quad = if y4 then (if x4 then 3 else 2) else (if x4 then 2 else 0) -- 0..3
            let atBitA = atByte `testBit` (7 - 2*quad)
            let atBitB = atByte `testBit` (6 - 2*quad)
            let pSel =
                    if atBitA
                    then (if atBitB then Pal4 else Pal3)
                    else (if atBitB then Pal2 else Pal1)
            let pal = selectPalette pals pSel
            let xDiv8 = xDiv32 * 4 + x43
            let nti = 32 * yDiv8 + xDiv8
            let ti = fromIntegral $ unByte $ nt ! nti
            let pti = 16*ti + yMod8
            let tileByteA = pt ! pti
            let tileByteB = pt ! (pti+8)
            xMod8 <- [0..7]
            let tileBitA = tileByteA `testBit` (7 - xMod8)
            let tileBitB = tileByteB `testBit` (7 - xMod8)
            let cSel =
                    if tileBitA
                    then (if tileBitB then CS3 else CS2)
                    else (if tileBitB then CS1 else BG)
            return $ selectColour bg pal cSel
    Screen { height = 240, width = 256, cols }


{-
screenBG :: Palettes -> [Byte] -> PAT -> Screen
screenBG pals kb (PAT pt) = do
    let nt = listArray (0,959) (take 960 kb)
    let at = listArray (0,63) (drop 960 kb)
    let cols = do
            y <- [0..239]
            x <- [0..255]
            let nti = 32*(y`div`8) + x`div`8
            let ti = fromIntegral $ unByte $ nt ! nti
            let pti = 16*ti + y`mod`8
            let tileByteA = pt ! pti
            let tileByteB = pt ! (pti+8)
            let tileBitA = tileByteA `testBit` (7 - x`mod`8)
            let tileBitB = tileByteB `testBit` (7 - x`mod`8)
            let cSel =
                    if tileBitA
                    then (if tileBitB then CS3 else CS2)
                    else (if tileBitB then CS1 else BG)
            let ati = 8*(y`div`32) + x`div`32
            let atByte  = at ! ati
            let x4 = x `testBit` 4
            let y4 = y `testBit` 4
            let quad = if y4 then (if x4 then 3 else 2) else (if x4 then 2 else 0) -- 0..3
            let atBitA = atByte `testBit` (7 - 2*quad)
            let atBitB = atByte `testBit` (6 - 2*quad)
            let pSel =
                    if atBitA
                    then (if atBitB then Pal4 else Pal3)
                    else (if atBitB then Pal2 else Pal1)
            let pal = selectPalette pals pSel
            let Palettes{bg} = pals
            return $ selectColour bg pal cSel
    Screen { height = 240, width = 256, cols }
-}
