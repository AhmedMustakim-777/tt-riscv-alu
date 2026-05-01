[![GDS](../../actions/workflows/gds.yaml/badge.svg)](../../actions/workflows/gds.yaml)
[![Docs](../../actions/workflows/docs.yaml/badge.svg)](../../actions/workflows/docs.yaml)
[![Test](../../actions/workflows/test.yaml/badge.svg)](../../actions/workflows/test.yaml)
[![FPGA](../../actions/workflows/fpga.yaml/badge.svg)](../../actions/workflows/fpga.yaml)

# rv32i RISC-V ALU


## Overview

Full 32-bit RISC-V rv32i ALU implementing all integer
arithmetic and logic operations. This is the arithmetic
core extracted from a complete rv32imsu RISC-V SoC
designed in Synopsys DC Shell and Synopsys ICC2 on the
SkyWater sky130A 130nm PDK for EEE-5390C Full Custom
VLSI Design at University of Central Florida (UCF).

## Supported Operations

| op[3:0] | Hex | Operation              | Example          |
|---------|-----|------------------------|------------------|
| 0001    | 0x1 | SLL — shift left       | 1 << 3 = 8       |
| 0010    | 0x2 | SRL — shift right      | 8 >> 3 = 1       |
| 0011    | 0x3 | SRA — arithmetic shift | -8 >> 1 = -4     |
| 0100    | 0x4 | ADD — addition         | 5 + 3 = 8        |
| 0110    | 0x6 | SUB — subtraction      | 10 - 3 = 7       |
| 0111    | 0x7 | AND — bitwise and      | 0xF & 0x5 = 0x5  |
| 1000    | 0x8 | OR  — bitwise or       | 0xA or 0x5 = 0xF |
| 1001    | 0x9 | XOR — bitwise xor      | 0xF ^ 0xF = 0    |
| 1010    | 0xA | SLT — less than        | 3 < 5 = 1        |
| 1011    | 0xB | SLTS — less than signed| -1 < 1 = 1       |

## Pin Assignment

| Pin | Direction | Function |
|-----|-----------|----------|
| ui_in[7:4] | Input | Operand A (4-bit) |
| ui_in[3:0] | Input | Operand B (4-bit) |
| uio_in[3:0] | Input | ALU operation select |
| uo_out[7:0] | Output | Result (8-bit) |

## How to test

Set ui_in[7:4] to operand A (values 0-15).
Set ui_in[3:0] to operand B (values 0-15).
Set uio_in[3:0] to the ALU operation.
Read result from uo_out[7:0].

Example — ADD 5 + 3:
  ui_in   = 8'b0101_0011  (A=5, B=3)
  uio_in  = 8'b0000_0100  (op=ADD=0x4)
  uo_out  = 8'b0000_1000  (result=8)

Example — AND 0xF & 0x5:
  ui_in   = 8'b1111_0101  (A=15, B=5)
  uio_in  = 8'b0000_0111  (op=AND=0x7)
  uo_out  = 8'b0000_0101  (result=5)


## Reuse

This ALU can be reused in any RISC-V implementation.
The riscv_alu.v file is self-contained and requires
only riscv_defs.v for the opcode definitions.
Both files are directly usable in other designs.

## External hardware

None required.

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Set up your Verilog project

1. Add your Verilog files to the `src` folder.
2. Edit the [info.yaml](info.yaml) and update information about your project, paying special attention to the `source_files` and `top_module` properties. If you are upgrading an$
3. Edit [docs/info.md](docs/info.md) and add a description of your project.
4. Adapt the testbench to your design. See [test/README.md](test/README.md) for more information.

The GitHub action will automatically build the ASIC files using [LibreLane](https://www.zerotoasiccourse.com/terminology/librelane/).

## Enable GitHub actions to build the results page

- [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://www.tinytapeout.com/guides/local-hardening/)

## What next?

- [Submit your design to the next shuttle](https://app.tinytapeout.com/).
- Edit [this README](README.md) and explain your design, how it works, and how to test it.
- Share your project on your social network of choice:
  - LinkedIn [#tinytapeout](https://www.linkedin.com/search/results/content/?keywords=%23tinytapeout) [@TinyTapeout](https://www.linkedin.com/company/100708654/)
  - Mastodon [#tinytapeout](https://chaos.social/tags/tinytapeout) [@matthewvenn](https://chaos.social/@matthewvenn)
  - X (formerly Twitter) [#tinytapeout](https://twitter.com/hashtag/tinytapeout) [@tinytapeout](https://twitter.com/tinytapeout)
  - Bluesky [@tinytapeout.com](https://bsky.app/profile/tinytapeout.com)

