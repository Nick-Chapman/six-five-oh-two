
module Honesty.PPU.Regs(
    Name(..),
    Effect(..),
    inter,
    State, state0,
    setVBlank, isEnabledNMI,
    Control(..), decodeControl,
    Mask(..), decodeMask,
    ) where

import Data.Bits

import Honesty.Addr
import Honesty.Byte
import Honesty.Six502.Cycles
import qualified Honesty.CHR as CHR
import qualified Honesty.PPU.PMem as PMem

import Control.Monad (ap,liftM)
instance Functor Effect where fmap = liftM
instance Applicative Effect where pure = return; (<*>) = ap
instance Monad Effect where return = Ret; (>>=) = Bind

data Name
    = PPUCTRL
    | PPUMASK
    | PPUSTATUS
    | OAMADDR
    | OAMDATA
    | PPUSCROLL
    | PPUADDR
    | PPUDATA

data Effect a where
    Ret :: a -> Effect a
    Bind :: Effect a -> (a -> Effect b) -> Effect b
    Read :: Name -> Effect Byte
    Write :: Name -> Byte -> Effect ()

data State = State
    { control :: !Byte
    , mask :: !Byte
    , status :: !Byte
    , addr_latch :: !AddrLatch
    , addr_hi :: !Byte
    , addr_lo :: !Byte
    , oam_addr :: !Byte
    } deriving Show

state0 :: State
state0 = State
    { control = 0x0
    , mask = 0x0
    , status = 0x00
    , addr_latch = Hi
    , addr_hi= 0x0
    , addr_lo = 0x0
    , oam_addr = 0x0
    }

setVBlank :: State -> Bool -> State
setVBlank state@State{status} bool =
    state { status = (if bool then setBit else clearBit) status 7 }

isEnabledNMI :: State -> Bool
isEnabledNMI State{control} = testBit control 7

data AddrLatch = Hi | Lo deriving (Show)

inter :: Cycles -> CHR.ROM -> State -> Effect a -> PMem.Effect (State, a)
inter cc chr state@State{status,addr_latch,addr_hi,addr_lo,oam_addr} = \case

    Ret x -> return (state,x)
    Bind e f -> do (state',a) <- inter cc chr state e; inter cc chr state' (f a)

    Read PPUCTRL -> error "Read PPUCTRL"
    Read PPUMASK -> error "Read PPUMASK"
    Read PPUSTATUS -> do
        let state' = state { addr_latch = Hi , status = clearBit status 7 }
        return (state',status)
    Read OAMADDR -> error "Read OAMADDR"
    Read OAMDATA -> error "Read OAMDATA"
    Read PPUSCROLL -> error "Read PPUSCROLL"
    Read PPUADDR -> error "Read PPUADDR"
    Read PPUDATA -> do
        let addr = addrOfHiLo addr_hi addr_lo
        b <- PMem.Read addr
        return (bumpAddr state, b)

    Write PPUCTRL b -> return (state { control = b }, ())
    Write PPUMASK b -> return (state { mask = b }, ())
    Write PPUSTATUS _ -> error "Write PPUSTATUS"

    Write OAMADDR b -> return (state { oam_addr = b }, ())

    Write OAMDATA b -> do
        PMem.WriteOam oam_addr b
        return (state { oam_addr = oam_addr + 1 }, ()) -- TODO: does this do required byte wrap?

    Write PPUSCROLL _ -> do return (state, ()) -- TODO: dont ignore for scrolling
    Write PPUADDR b -> do
        case addr_latch of
            Hi -> return (state { addr_hi = b, addr_latch = Lo }, ())
            Lo -> return (state { addr_lo = b, addr_latch = Hi }, ())
    Write PPUDATA b -> do
        let addr = addrOfHiLo addr_hi addr_lo
        PMem.Write addr b
        return (bumpAddr state, ())

bumpAddr :: State -> State
bumpAddr s@State{control,addr_hi=hi, addr_lo=lo} = do
    let bumpV = testBit control 2
    let bump = if bumpV then 32 else 1
    let a = addrOfHiLo hi lo
    let (hi',lo') = addrToHiLo (a `addAddr` bump)
    s { addr_hi=hi', addr_lo=lo'}


data Control = Control
    { nmiEnabled :: Bool
    , masterSlave :: Bool
    , spriteHeight :: Bool
    , backgroundTileSelect :: Bool
    , spriteTileSelect :: Bool
    , incrementMode :: Bool
    , nameTableSelect1 :: Bool
    , nameTableSelect0 :: Bool
    }

decodeControl :: State -> Control
decodeControl State{control} = Control
    { nmiEnabled = sel 7
    , masterSlave  = sel 6
    , spriteHeight = sel 5
    , backgroundTileSelect = sel 4
    , spriteTileSelect = sel 3
    , incrementMode = sel 2
    , nameTableSelect1 = sel 1
    , nameTableSelect0 = sel 0
    }
    where sel n = control `testBit` n

data Mask = Mask
    { blueEmphasis :: Bool
    , greenEmphasis :: Bool
    , redEmphasis :: Bool
    , spriteEnable :: Bool
    , backgroundEnable :: Bool
    , spriteLeftColumnEnable :: Bool
    , backgroundLeftColumnEnable :: Bool
    , greyScale :: Bool
    }

decodeMask :: State -> Mask
decodeMask State{mask} = Mask
    { blueEmphasis = sel 7
    , greenEmphasis = sel 6
    , redEmphasis = sel 5
    , spriteEnable = sel 4
    , backgroundEnable = sel 3
    , spriteLeftColumnEnable = sel 2
    , backgroundLeftColumnEnable = sel 1
    , greyScale = sel 0
    }
    where sel n = mask `testBit` n
