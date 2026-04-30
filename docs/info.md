<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any sections that are not relevant to your project. You can also include images in this folder and reference them in the datasheet.

-->

## How it works

Full 32-bit RISC-V rv32i ALU implementing all integer
arithmetic and logic operations from the rv32imsu SoC
designed in Synopsys DC Shell and ICC2 on sky130A 130nm
PDK for EEE-5390C Full Custom VLSI Design at UCF.

Operands A and B are 32-bit values loaded one byte at
a time using the ui_in byte select pins and uio data bus.
The ALU operation is selected by op[3:0] and the 32-bit
result is read back one byte at a time.

Supported operations: ADD, SUB, AND, OR, XOR,
SLL (shift left logical), SRL (shift right logical),
SRA (shift right arithmetic), SLT (set less than unsigned),
SLTU (set less than signed).

## How to test

Load operand A one byte at a time:
Set ui_in[7:6] to byte index (00=byte0 to 11=byte3),
set ui_in[5:2] to ALU operation when loading byte 0,
set uio[7:0] to the data byte value, pulse clock.

Load operand B one byte at a time:
Set ui_in[1:0] to byte index, set uio[7:0] to data byte,
pulse clock.

Read result one byte at a time:
Set uio[7:6] to result byte index, read uo_out[7:0].

Example: ADD 5 + 3 = 8
  Cycle 1: ui_in=8'b00_0100_00 uio=8'h05 (A byte0, op=ADD)
  Cycle 2: ui_in=8'bxx_xxxx_00 uio=8'h03 (B byte0)
  Cycle 3: uio[7:6]=2'b00, read uo_out = 8'h08

## External hardware

None required.
