# rv32i RISC-V ALU

## What it does

Full 32-bit RISC-V rv32i ALU supporting all integer
arithmetic and logic operations. This is a component
of a complete rv32imsu RISC-V SoC implemented in
Synopsys DC Shell and ICC2 on sky130A 130nm PDK for
EEE-5390C Full Custom VLSI Design at UCF.

## Operations

| op[3:0] | Hex  | Operation        |
|---------|------|------------------|
| 0001    | 0x1  | SLL shift left   |
| 0010    | 0x2  | SRL shift right  |
| 0011    | 0x3  | SRA arith shift  |
| 0100    | 0x4  | ADD              |
| 0101    | 0x5  | SUB              |
| 0110    | 0x6  | AND              |
| 0111    | 0x7  | OR               |
| 1000    | 0x8  | XOR              |
| 1001    | 0x9  | SLT unsigned     |
| 1010    | 0xA  | SLT signed       |

## How to test

Load operand A — set ui_in[7:6] to byte index
(00=byte0, 01=byte1, 10=byte2, 11=byte3),
set ui_in[5:2] to ALU op when loading byte 0,
set uio[7:0] to the data byte, pulse clock.

Load operand B — set ui_in[1:0] to byte index,
set uio[7:0] to data byte, pulse clock.

Read result — set uio[7:6] to result byte index,
read uo_out[7:0] on next clock.

Example ADD 5 + 3:
  Load A byte0: ui_in=8'b00_0100_00, uio=8'h05
  Load B byte0: ui_in=8'bxx_xxxx_00, uio=8'h03
  Read result:  uio[7:6]=00, uo_out=8'h08

## External hardware

None required.

