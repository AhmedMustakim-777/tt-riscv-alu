# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

# ALU opcodes — exact values from riscv_defs.v
ALU_NONE         = 0x0
ALU_SHIFTL       = 0x1
ALU_SHIFTR       = 0x2
ALU_SHIFTR_ARITH = 0x3
ALU_ADD          = 0x4
# 0x5 does not exist
ALU_SUB          = 0x6
ALU_AND          = 0x7
ALU_OR           = 0x8
ALU_XOR          = 0x9
ALU_LESS_THAN    = 0xA
ALU_LESS_THAN_S  = 0xB

async def load_operand_a(dut, value, op):
    """Load 32-bit operand A one byte at a time"""
    for i in range(4):
        b = (value >> (8*i)) & 0xFF
        if i == 0:
            dut.ui_in.value = (i << 6) | (op << 2) | 0
        else:
            dut.ui_in.value = (i << 6)
        dut.uio_in.value = b
        await ClockCycles(dut.clk, 1)

async def load_operand_b(dut, value):
    """Load 32-bit operand B one byte at a time"""
    for i in range(4):
        b = (value >> (8*i)) & 0xFF
        dut.ui_in.value = i & 0x3
        dut.uio_in.value = b
        await ClockCycles(dut.clk, 1)

async def read_result(dut):
    """Read 32-bit result one byte at a time"""
    result = 0
    for i in range(4):
        dut.uio_in.value = (i << 6)
        await ClockCycles(dut.clk, 1)
        result |= (int(dut.uo_out.value) << (8*i))
    return result

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value    = 1
    dut.ui_in.value  = 0
    dut.uio_in.value = 0
    dut.rst_n.value  = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value  = 1
    await ClockCycles(dut.clk, 2)

    # Test 1: ADD 5 + 3 = 8
    dut._log.info("Test ADD: 5 + 3 = 8")
    await load_operand_a(dut, 5, ALU_ADD)
    await load_operand_b(dut, 3)
    result = await read_result(dut)
    dut._log.info(f"ADD result: {result}")
    assert result == 8, f"ADD failed: expected 8 got {result}"

    # Test 2: SUB 10 - 3 = 7
    dut._log.info("Test SUB: 10 - 3 = 7")
    await load_operand_a(dut, 10, ALU_SUB)
    await load_operand_b(dut, 3)
    result = await read_result(dut)
    dut._log.info(f"SUB result: {result}")
    assert result == 7, f"SUB failed: expected 7 got {result}"

    # Test 3: AND 0xFF & 0x0F = 0x0F
    dut._log.info("Test AND: 0xFF & 0x0F = 0x0F")
    await load_operand_a(dut, 0xFF, ALU_AND)
    await load_operand_b(dut, 0x0F)
    result = await read_result(dut)
    dut._log.info(f"AND result: {hex(result)}")
    assert result == 0x0F, f"AND failed: expected 0x0F got {hex(result)}"

    # Test 4: OR 0xF0 | 0x0F = 0xFF
    dut._log.info("Test OR: 0xF0 | 0x0F = 0xFF")
    await load_operand_a(dut, 0xF0, ALU_OR)
    await load_operand_b(dut, 0x0F)
    result = await read_result(dut)
    dut._log.info(f"OR result: {hex(result)}")
    assert result == 0xFF, f"OR failed: expected 0xFF got {hex(result)}"

    # Test 5: XOR 0xFF ^ 0xFF = 0
    dut._log.info("Test XOR: 0xFF ^ 0xFF = 0")
    await load_operand_a(dut, 0xFF, ALU_XOR)
    await load_operand_b(dut, 0xFF)
    result = await read_result(dut)
    dut._log.info(f"XOR result: {result}")
    assert result == 0, f"XOR failed: expected 0 got {result}"

    # Test 6: SLT 3 < 5 = 1
    dut._log.info("Test SLT: 3 < 5 = 1")
    await load_operand_a(dut, 3, ALU_LESS_THAN)
    await load_operand_b(dut, 5)
    result = await read_result(dut)
    dut._log.info(f"SLT result: {result}")
    assert result == 1, f"SLT failed: expected 1 got {result}"

    # Test 7: SLT 5 < 3 = 0
    dut._log.info("Test SLT: 5 < 3 = 0")
    await load_operand_a(dut, 5, ALU_LESS_THAN)
    await load_operand_b(dut, 3)
    result = await read_result(dut)
    dut._log.info(f"SLT result: {result}")
    assert result == 0, f"SLT failed: expected 0 got {result}"

    # Test 8: SLL 1 << 4 = 16
    dut._log.info("Test SLL: 1 << 4 = 16")
    await load_operand_a(dut, 1, ALU_SHIFTL)
    await load_operand_b(dut, 4)
    result = await read_result(dut)
    dut._log.info(f"SLL result: {result}")
    assert result == 16, f"SLL failed: expected 16 got {result}"

    # Test 9: ADD large 32-bit
    dut._log.info("Test ADD 32-bit: 0x12345678 + 0xFF = 0x12345777")
    await load_operand_a(dut, 0x12345678, ALU_ADD)
    await load_operand_b(dut, 0xFF)
    result = await read_result(dut)
    expected = (0x12345678 + 0xFF) & 0xFFFFFFFF
    dut._log.info(f"ADD 32-bit result: {hex(result)}")
    assert result == expected, \
        f"ADD 32-bit failed: expected {hex(expected)} got {hex(result)}"

    dut._log.info("All tests passed!")
