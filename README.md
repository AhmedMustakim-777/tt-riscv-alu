# rv32i RISC-V ALU

## What it does

Full 32-bit RISC-V rv32i ALU implementing ADD, SUB,
AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU operations.
Part of rv32imsu SoC designed in Synopsys ICC2 on
sky130A at UCF EEE-5390C.

## How it works

32-bit operands loaded one byte at a time via uio pins.
ALU operation selected by ui_in[5:2]. Result read back
one byte at a time using out_sel on uio[7:6].

## How to test

Load A: ui_in[7:6]=byte_sel, ui_in[5:2]=op, uio=data, clock
Load B: ui_in[1:0]=byte_sel, uio=data, clock
Read:   uio[7:6]=result_byte_sel, read uo_out

## External hardware

None required.
