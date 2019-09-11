{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Six502.OpCode (table) where

import Six502.Types (Instruction(..),Mode(..),Byte)

table :: [(Instruction,Mode,Byte)]
table =
    [ (ADC, Immediate, 0x69)
    , (ADC, Absolute, 0x6d)
    , (ADC, AbsoluteX, 0x7d)
    , (ADC, AbsoluteY, 0x79)
    , (ADC, ZeroPage, 0x65)
    , (ADC, ZeroPageX, 0x75)
    , (ADC, IndexedIndirect, 0x61)
    , (ADC, IndirectIndexed, 0x71)
    , (AND, Immediate, 0x29)
    , (AND, Absolute, 0x2d)
    , (AND, AbsoluteX, 0x3d)
    , (AND, AbsoluteY, 0x39)
    , (AND, ZeroPage, 0x25)
    , (AND, ZeroPageX, 0x35)
    , (AND, IndexedIndirect, 0x21)
    , (AND, IndirectIndexed, 0x31)
    , (ASL, Accumulator, 0x0a)
    , (ASL, Absolute, 0x0e)
    , (ASL, AbsoluteX, 0x1e)
    , (ASL, ZeroPage, 0x06)
    , (ASL, ZeroPageX, 0x16)
    , (BCC, Relative, 0x90)
    , (BCS, Relative, 0xb0)
    , (BEQ, Relative, 0xf0)
    , (BIT, Absolute, 0x2c)
    , (BIT, ZeroPage, 0x24)
    , (BMI, Relative, 0x30)
    , (BNE, Relative, 0xd0)
    , (BPL, Relative, 0x10)
    , (BRK, Implied, 0x00)
    , (BVC, Relative, 0x50)
    , (BVS, Relative, 0x70)
    , (CLC, Implied, 0x18)
    , (CLD, Implied, 0xd8)
    , (CLI, Implied, 0x58)
    , (CLV, Implied, 0xb8)
    , (CMP, Immediate, 0xc9)
    , (CMP, Absolute, 0xcd)
    , (CMP, AbsoluteX, 0xdd)
    , (CMP, AbsoluteY, 0xd9)
    , (CMP, ZeroPage, 0xc5)
    , (CMP, ZeroPageX, 0xd5)
    , (CMP, IndexedIndirect, 0xc1)
    , (CMP, IndirectIndexed, 0xd1)
    , (CPX, Immediate, 0xe0)
    , (CPX, Absolute, 0xec)
    , (CPX, ZeroPage, 0xe4)
    , (CPY, Immediate, 0xc0)
    , (CPY, Absolute, 0xcc)
    , (CPY, ZeroPage, 0xc4)
    , (DEC, Absolute, 0xce)
    , (DEC, AbsoluteX, 0xde)
    , (DEC, ZeroPage, 0xc6)
    , (DEC, ZeroPageX, 0xd6)
    , (DEX, Implied, 0xca)
    , (DEY, Implied, 0x88)
    , (EOR, Immediate, 0x49)
    , (EOR, Absolute, 0x4d)
    , (EOR, AbsoluteX, 0x5d)
    , (EOR, AbsoluteY, 0x59)
    , (EOR, ZeroPage, 0x45)
    , (EOR, ZeroPageX, 0x55)
    , (EOR, IndexedIndirect, 0x41)
    , (EOR, IndirectIndexed, 0x51)
    , (INC, Absolute, 0xee)
    , (INC, AbsoluteX, 0xfe)
    , (INC, ZeroPage, 0xe6)
    , (INC, ZeroPageX, 0xf6)
    , (INX, Implied, 0xe8)
    , (INY, Implied, 0xc8)
    , (JMP, Absolute, 0x4c)
    , (JMP, Indirect, 0x6c)
    , (JSR, Absolute, 0x20)
    , (LDA, Immediate, 0xa9)
    , (LDA, Absolute, 0xad)
    , (LDA, AbsoluteX, 0xbd)
    , (LDA, AbsoluteY, 0xb9)
    , (LDA, ZeroPage, 0xa5)
    , (LDA, ZeroPageX, 0xb5)
    , (LDA, IndexedIndirect, 0xa1)
    , (LDA, IndirectIndexed, 0xb1)
    , (LDX, Immediate, 0xa2)
    , (LDX, Absolute, 0xae)
    , (LDX, AbsoluteY, 0xbe)
    , (LDX, ZeroPage, 0xa6)
    , (LDX, ZeroPageY, 0xb6)
    , (LDY, Immediate, 0xa0)
    , (LDY, Absolute, 0xac)
    , (LDY, AbsoluteX, 0xbc)
    , (LDY, ZeroPage, 0xa4)
    , (LDY, ZeroPageX, 0xb4)
    , (LSR, Accumulator, 0x4a)
    , (LSR, Absolute, 0x4e)
    , (LSR, AbsoluteX, 0x5e)
    , (LSR, ZeroPage, 0x46)
    , (LSR, ZeroPageX, 0x56)
    , (NOP, Implied, 0xea)
    , (ORA, Immediate, 0x09)
    , (ORA, Absolute, 0x0d)
    , (ORA, AbsoluteX, 0x1d)
    , (ORA, AbsoluteY, 0x19)
    , (ORA, ZeroPage, 0x05)
    , (ORA, ZeroPageX, 0x15)
    , (ORA, IndexedIndirect, 0x01)
    , (ORA, IndirectIndexed, 0x11)
    , (PHA, Implied, 0x48)
    , (PHP, Implied, 0x08)
    , (PLA, Implied, 0x68)
    , (PLP, Implied, 0x28)
    , (ROL, Accumulator, 0x2a)
    , (ROL, Absolute, 0x2e)
    , (ROL, AbsoluteX, 0x3e)
    , (ROL, ZeroPage, 0x26)
    , (ROL, ZeroPageX, 0x36)
    , (ROR, Accumulator, 0x6a)
    , (ROR, Absolute, 0x6e) -- emulator101 had op-code for this line and next swapped
    , (ROR, AbsoluteX, 0x7e)
    , (ROR, ZeroPage, 0x66)
    , (ROR, ZeroPageX, 0x76)
    , (RTI, Implied, 0x40)
    , (RTS, Implied, 0x60)
    , (SBC, Immediate, 0xe9)
    , (SBC, Absolute, 0xed)
    , (SBC, AbsoluteX, 0xfd)
    , (SBC, AbsoluteY, 0xf9)
    , (SBC, ZeroPage, 0xe5)
    , (SBC, ZeroPageX, 0xf5)
    , (SBC, IndexedIndirect, 0xe1)
    , (SBC, IndirectIndexed, 0xf1)
    , (SEC, Implied, 0x38)
    , (SED, Implied, 0xf8)
    , (SEI, Implied, 0x78)
    , (STA, Absolute, 0x8d)
    , (STA, AbsoluteX, 0x9d)
    , (STA, AbsoluteY, 0x99)
    , (STA, ZeroPage, 0x85)
    , (STA, ZeroPageX, 0x95)
    , (STA, IndexedIndirect, 0x81)
    , (STA, IndirectIndexed, 0x91)
    , (STX, Absolute, 0x8e)
    , (STX, ZeroPage, 0x86)
    , (STX, ZeroPageY, 0x96)
    , (STY, Absolute, 0x8c)
    , (STY, ZeroPage, 0x84)
    , (STY, ZeroPageX, 0x94)
    , (TAX, Implied, 0xaa)
    , (TAY, Implied, 0xa8)
    , (TSX, Implied, 0xba)
    , (TXA, Implied, 0x8a)
    , (TXS, Implied, 0x9a)
    , (TYA, Implied, 0x98)

    , (SBC_extra, Immediate, 0xEB)

    , (LAX, IndexedIndirect, 0xA3)
    , (LAX, ZeroPage, 0xA7)
    , (LAX, Absolute, 0xAF)
    , (LAX, IndirectIndexed, 0xB3)
    , (LAX, ZeroPageY, 0xB7)
    , (LAX, AbsoluteY, 0xBF)
    , (DCP, IndexedIndirect, 0xC3)
    , (DCP, ZeroPage, 0xC7)
    , (DCP, Absolute, 0xCF)
    , (DCP, IndirectIndexed, 0xD3)
    , (DCP, ZeroPageX, 0xD7)
    , (DCP, AbsoluteY, 0xDB)
    , (DCP, AbsoluteX, 0xDF)
    , (SAX, IndexedIndirect, 0x83)
    , (SAX, ZeroPage, 0x87)
    , (SAX, Absolute, 0x8F)
    , (SAX, ZeroPageY, 0x97)
    , (ISB, IndexedIndirect, 0xE3)
    , (ISB, ZeroPage, 0xE7)
    , (ISB, Absolute, 0xEF)
    , (ISB, IndirectIndexed, 0xF3)
    , (ISB, ZeroPageX, 0xF7)
    , (ISB, AbsoluteY, 0xFB)
    , (ISB, AbsoluteX, 0xFF)
    , (SLO, IndexedIndirect, 0x03)
    , (SLO, ZeroPage, 0x07)
    , (SLO, Absolute, 0x0F)
    , (SLO, IndirectIndexed, 0x13)
    , (SLO, ZeroPageX, 0x17)
    , (SLO, AbsoluteY, 0x1B)
    , (SLO, AbsoluteX, 0x1F)
    , (RLA, IndexedIndirect, 0x23)
    , (RLA, ZeroPage, 0x27)
    , (RLA, Absolute, 0x2F)
    , (RLA, IndirectIndexed, 0x33)
    , (RLA, ZeroPageX, 0x37)
    , (RLA, AbsoluteY, 0x3B)
    , (RLA, AbsoluteX, 0x3F)
    , (SRE, IndexedIndirect, 0x43)
    , (SRE, ZeroPage, 0x47)
    , (SRE, Absolute, 0x4F)
    , (SRE, IndirectIndexed, 0x53)
    , (SRE, ZeroPageX, 0x57)
    , (SRE, AbsoluteY, 0x5B)
    , (SRE, AbsoluteX, 0x5F)
    , (RRA, IndexedIndirect, 0x63)
    , (RRA, ZeroPage, 0x67)
    , (RRA, Absolute, 0x6F)
    , (RRA, IndirectIndexed, 0x73)
    , (RRA, ZeroPageX, 0x77)
    , (RRA, AbsoluteY, 0x7B)
    , (RRA, AbsoluteX, 0x7F)

    , (NOP_04, ZeroPage, 0x04)
    , (NOP_44, ZeroPage, 0x44)
    , (NOP_64, ZeroPage, 0x64)
    , (NOP_0C, Absolute, 0x0C)
    , (NOP_14, ZeroPageX, 0x14)
    , (NOP_34, ZeroPageX, 0x34)
    , (NOP_54, ZeroPageX, 0x54)
    , (NOP_74, ZeroPageX, 0x74)
    , (NOP_D4, ZeroPageX, 0xD4)
    , (NOP_F4, ZeroPageX, 0xF4)
    , (NOP_1A, Implied, 0x1A)
    , (NOP_3A, Implied, 0x3A)
    , (NOP_5A, Implied, 0x5A)
    , (NOP_7A, Implied, 0x7A)
    , (NOP_DA, Implied, 0xDA)
    , (NOP_FA, Implied, 0xFA)
    , (NOP_80, Immediate, 0x80)
    , (NOP_1C, AbsoluteX, 0x1C)
    , (NOP_3C, AbsoluteX, 0x3C)
    , (NOP_5C, AbsoluteX, 0x5C)
    , (NOP_7C, AbsoluteX, 0x7C)
    , (NOP_DC, AbsoluteX, 0xDC)
    , (NOP_FC, AbsoluteX, 0xFC)

    ]
