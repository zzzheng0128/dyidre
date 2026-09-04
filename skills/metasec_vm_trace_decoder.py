#!/usr/bin/env python3
"""
Decode the metasec VM bytecode path observed in a GumTrace log.

This is intentionally a trace-driven decoder:

  GumTrace native log
      -> VM-page word reads
      -> low6 opcode
      -> observed handler target
      -> asm-like listing + stats

It does not pretend to be a complete offline VM lifter yet.  The first
iteration keeps the ground truth from the trace visible so new opcode
semantics can be filled in safely.
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Sequence


DEFAULT_LOG = Path("dyidre/runs/350101/gumtrace/20260829_4cc10/gumtrace_4cc10.log")
PAGE_SIZE = 0x1000


OP_INFO: dict[int, tuple[str, str]] = {
    0x00: ("OP00", "current 350.101 native handler is not recovered"),
    0x01: ("LD32S", "dst = *(int32_t *)(src + simm16), static handler +0x55714"),
    0x02: ("LD64", "dst = *(uint64_t *)(src + simm16), from z/ws/vm64.cpp"),
    0x08: ("LD8S", "dst = *(int8_t *)(src + simm16), from z/ws/vm64.cpp"),
    0x0A: ("ST64_UNALIGNED_R", "unaligned 64-bit store/merge variant, from z/ws/vm64.cpp"),
    0x0B: ("ST32_MASKED_L", "alignment-dependent masked u32 store, static handler +0x5685C"),
    0x0D: ("JMP_ABS26", "pc = vm_base + target26*4, static handler +0x53540"),
    0x0E: ("ST8", "*(src + simm16) = dst.u8, from z/ws/vm64.cpp"),
    0x0F: ("ADD64_IMM", "dst = src + simm16, static handler +0x52984"),
    0x10: ("ST8", "*(u8 *)(base + simm16) = value.u8, static handler +0x56B00"),
    0x11: ("SUBOP_DISPATCH", "handler +0x4CE54 dispatches on bits11:6; no unified op11 semantic"),
    0x13: ("ST64_MASKED_L", "alignment-dependent masked u64 store, static handler +0x55FD4"),
    0x14: ("BNE", "if (lhs != rhs) pc = pc + 4 + simm16*4, static handler +0x54020"),
    0x15: ("ADD32S_IMM", "dst = (int32_t)src + simm16, from z/ws/vm64.cpp"),
    0x16: ("ST32", "*(u32 *)(base + simm16) = value.u32, static handler +0x56E70"),
    0x18: ("LD64", "dst = *(uint64_t *)(src + simm16), static handler +0x54A1C"),
    0x1A: ("ST64", "*(uint64_t *)(base + simm16) = value, static handler +0x561B4"),
    0x21: ("ULT64_S16", "dst = (u64)src < (u64)simm16, static handler +0x52F34"),
    0x24: ("ST32_UNALIGNED_L", "unaligned 32-bit store/merge variant, from z/ws/vm64.cpp"),
    0x28: ("LD8U", "dst = *(uint8_t *)(src + simm16), static handler +0x55908"),
    0x2B: ("BGTZ", "if ((i64)reg > 0) pc = pc + 4 + simm16*4, static handler +0x53B68"),
    0x2C: ("BR_COND", "conditional VM-PC control family, from z/ws/vm64.cpp"),
    0x2D: ("BEQ", "if (lhs == rhs) pc = pc + 4 + simm16*4, static handler +0x53DB0"),
    0x2E: ("ST32_MASKED_R", "alignment-dependent masked u32 store, static handler +0x565E0"),
    0x30: ("OR64_IMM", "dst = src | imm16, static handler +0x5332C"),
    0x33: ("OP33", "current 350.101 native handler is not recovered"),
    0x34: ("MOV32HI_S", "dst = sign_extend32(imm16 << 16), static handler +0x531E4"),
    0x35: ("AND32_IMM", "dst = (u32)src & imm16, static handler +0x5309C"),
    0x36: ("ST32", "*(src + simm16) = dst.u32, from z/ws/vm64.cpp"),
    0x38: ("XOR_IMM", "dst = src ^ imm16, from z/ws/vm64.cpp"),
    0x3A: ("BR_COND", "conditional VM-PC control family, from z/ws/vm64.cpp"),
    0x3B: ("ADD32S_IMM", "dst = sign_extend32(src) + simm16, static handler +0x52D04"),
    0x3E: ("ST64_MASKED_R", "alignment-dependent masked u64 store, static handler +0x55D20"),
    0x3F: ("BR_COND", "conditional VM-PC control family, from z/ws/vm64.cpp"),
}


# ``op=0x11`` is a prefix whose bits[11:6] select another current handler.
# This table records only selectors reached in the 1F7860 trace and recovered
# from their 350.101 handler bodies. Other selectors remain intentionally
# undecoded.
OP11_SUBOP_INFO: dict[int, tuple[str, str]] = {
    0x03: ("SLL32S", "dst = sign_extend32((u32)src << shift), handler +0x4DC54"),
    0x0E: ("ADD64_REG", "dst = left + right, handler +0x4E0BC"),
    0x17: ("SLL64", "dst = src << encoded_shift, handler +0x4CF20"),
    0x1D: ("XOR64_REG", "dst = left ^ right, handler +0x4F728"),
    0x1E: ("JMP_REG", "pc = target register on normal VM path, handler +0x4F860"),
    0x2B: ("SLT64", "dst = ((i64)left < (i64)right), handler +0x4F1C0"),
    0x2C: ("OR64_REG", "dst = left | right, handler +0x4F500"),
    0x32: ("CALL_REG", "link = pc+4; pc = target register on normal VM path, handler +0x4F830"),
}


# Handler target offsets observed in dyidre/runs/350101/gumtrace/20260829_4cc10/gumtrace_4cc10.log.
# These are not the full VM table, only the handlers reached by this run.
HANDLER_INFO: dict[int, tuple[int | None, str]] = {
    0x54A1C: (0x18, "primary op18 handler"),
    0x4CE54: (0x11, "primary op11 handler"),
    0x561B4: (0x1A, "primary op1a handler"),
    0x52984: (0x0F, "primary op0f handler"),
    0x531E4: (0x34, "primary op34 handler"),
    0x5332C: (0x30, "primary op30 handler"),
    0x52D04: (0x3B, "primary op3b handler"),
    0x54020: (0x14, "primary op14 handler"),
    0x56B00: (0x10, "primary op10 handler"),
    0x56E70: (0x16, "primary op16 handler"),
    0x55714: (0x01, "primary op01 handler"),
    0x55D20: (0x3E, "primary op3e handler"),
    0x55FD4: (0x13, "primary op13 handler"),
    0x53DB0: (0x2D, "primary op2d handler"),
    0x565E0: (0x2E, "primary op2e handler"),
    0x5685C: (0x0B, "primary op0b handler"),
    0x53540: (0x0D, "primary op0d handler"),
    0x52F34: (0x21, "primary op21 handler"),
    0x4CF20: (None, "SLL64 op11 selector 0x17 handler"),
    0x4E0BC: (None, "ADD64_REG op11 selector 0x0e handler"),
    0x55908: (0x28, "primary op28 handler"),
    0x53B68: (0x2B, "primary op2b handler"),
    0x5309C: (0x35, "primary op35 handler"),
    0x4DC54: (None, "SLL32S op11 selector 0x03 handler"),
    0x4F728: (None, "XOR64_REG op11 selector 0x1d handler"),
    0x4F860: (None, "JMP_REG op11 selector 0x1e handler"),
    0x4F1C0: (None, "SLT64 op11 selector 0x2b handler"),
    0x4F500: (None, "OR64_REG op11 selector 0x2c handler"),
    0x4F830: (None, "CALL_REG op11 selector 0x32 handler"),
}


LINE_RE = re.compile(
    r"^\[libmetasec_ml\.so\]\s+"
    r"(?P<runtime>0x[0-9a-fA-F]+)!"
    r"(?P<offset>0x[0-9a-fA-F]+)\s+"
    r"(?P<insn>[^;]+);(?P<tail>.*)$"
)
MEM_R_RE = re.compile(r"\bmem_r=(0x[0-9a-fA-F]+)")
WORD_RESULT_RE = re.compile(r"->.*?\bw\d+=(0x[0-9a-fA-F]+)")
X8_RE = re.compile(r"\bx8=(0x[0-9a-fA-F]+)")
# A VM instruction fetch is a 32-bit W-register load.  ``mem_r`` alone is
# insufficient: byte/halfword data reads from a VM-code page can otherwise be
# mistaken for VM words whose low byte happens to be an opcode.
VM_WORD_LOAD_RE = re.compile(r"^(?:ldr|ldur)\s+w(?:\d+|zr),\s*\[")


@dataclass(frozen=True)
class NativeRow:
    line_no: int
    runtime: int
    offset: int
    insn: str
    tail: str


@dataclass(frozen=True)
class VmRead:
    line_no: int
    native_offset: int
    vm_pc: int
    word: int
    insn: str

    @property
    def op(self) -> int:
        return self.word & 0x3F


@dataclass(frozen=True)
class DispatchEvent:
    seq: int
    br_line: int
    br_site: int
    target: int
    read: VmRead | None


def parse_int(text: str) -> int:
    return int(text, 16)


def sign_extend(value: int, bits: int) -> int:
    sign = 1 << (bits - 1)
    mask = (1 << bits) - 1
    value &= mask
    return (value ^ sign) - sign


def bit(value: int, src_bit: int, dst_bit: int) -> int:
    return ((value >> src_bit) & 1) << dst_bit


def bits(value: int, shift: int, width: int) -> int:
    return (value >> shift) & ((1 << width) - 1)


def reg(value: int, shift: int) -> int:
    return bits(value, shift, 5)


def imm16_common(word: int) -> int:
    """
    Common scattered immediate expression seen repeatedly in z/ws/vm64.cpp:

      (i & 0xF000)
      | ((i & 0x04000000) >> 20)
      | ((i >> 6) & 0x3F)
      | ((i & 0x08000000) >> 20)
      | ((i & 0x10000000) >> 20)
      | ((i & 0x20000000) >> 20)
      | ((i & 0x40000000) >> 20)
      | ((i & 0x80000000) >> 20)
    """
    return (
        (word & 0xF000)
        | ((word & 0x04000000) >> 20)
        | ((word >> 6) & 0x3F)
        | ((word & 0x08000000) >> 20)
        | ((word & 0x10000000) >> 20)
        | ((word & 0x20000000) >> 20)
        | ((word & 0x40000000) >> 20)
        | ((word & 0x80000000) >> 20)
    ) & 0xFFFF


def fields(word: int) -> dict[str, int]:
    imm16 = imm16_common(word)
    return {
        "op": word & 0x3F,
        "lo12": word & 0xFFF,
        "sub6": bits(word, 6, 6),
        "r6": reg(word, 6),
        "r11": reg(word, 11),
        "r16": reg(word, 16),
        "r21": reg(word, 21),
        "r27": reg(word, 27),
        "imm16": imm16,
        "simm16": sign_extend(imm16, 16),
        "br_delta": sign_extend(imm16, 16) << 2,
    }


def op0d_target26(word: int) -> int:
    """Return the absolute VM-word index decoded by 350.101 op0d.

    Handler +0x53540 reconstructs this 26-bit value, multiplies it by four,
    and adds the program base held in x5.  It is an absolute VM jump, not the
    older reconstruction's ADD64-immediate form.
    """
    return (
        ((word >> 16) & 0x1F)
        | (((word >> 11) & 0x1F) << 5)
        | (((word >> 26) & 0x1F) << 10)
        | (((word >> 6) & 0x1F) << 15)
        | (((word >> 21) & 0x1F) << 20)
        | (((word >> 31) & 1) << 25)
    )


def op11_selector(word: int) -> int:
    """Return the 6-bit secondary opcode selected by the ``op=0x11`` prefix."""
    return (word >> 6) & 0x3F


def op11_fields(word: int) -> tuple[int, int, int, int]:
    """Return the four full-width register fields in bit-position order.

    ``op=0x11`` does not have one uniform operand encoding.  Its selected
    handler assigns roles to the fields at bits ``[16:12]``, ``[21:17]``,
    ``[26:22]``, and ``[31:27]`` independently.  Keeping their physical
    order here makes each selector's use explicit at the call site.
    """
    return (
        (word >> 12) & 0x1F,
        (word >> 17) & 0x1F,
        (word >> 22) & 0x1F,
        (word >> 27) & 0x1F,
    )


def op18_regs(word: int) -> tuple[int, int]:
    """Return ``(dst, src)`` for the 350.101 op18/LD64 encoding.

    Handler +0x54A1C builds source from word[10:7] plus word[31], and
    destination from word[25:22] plus word[6]. This differs from the common
    load family and is verified against the current 350.101 handler.
    """
    src = (((word >> 31) & 1) << 4) | ((word >> 7) & 0xF)
    dst = (((word >> 6) & 1) << 4) | ((word >> 22) & 0xF)
    return dst, src


def op01_regs(word: int) -> tuple[int, int]:
    """Return ``(dst, src)`` for 350.101 op01/LD32S."""
    src = (((word >> 31) & 1) << 4) | ((word >> 12) & 0xF)
    dst = (((word >> 11) & 1) << 4) | ((word >> 27) & 0xF)
    return dst, src


def op01_imm16(word: int) -> int:
    """Return the custom scattered signed offset used by op01."""
    return (
        ((word >> 16) & 0x3FF)
        | (((word >> 6) & 1) << 10)
        | (((word >> 7) & 1) << 11)
        | (((word >> 8) & 1) << 12)
        | (((word >> 9) & 1) << 13)
        | (((word >> 10) & 1) << 14)
        | (((word >> 26) & 1) << 15)
    )


def op01_simm16(word: int) -> int:
    return sign_extend(op01_imm16(word), 16)


def op10_regs(word: int) -> tuple[int, int]:
    """Return ``(base, value)`` for 350.101 op10/ST8."""
    base = (((word >> 31) & 1) << 4) | ((word >> 17) & 0xF)
    value = (((word >> 16) & 1) << 4) | ((word >> 7) & 0xF)
    return base, value


def op10_imm16(word: int) -> int:
    """Return the signed byte-store offset reconstructed at +0x56B00."""
    return (
        ((word >> 21) & 0x3FF)
        | (((word >> 11) & 0x1F) << 10)
        | (((word >> 6) & 1) << 15)
    )


def op10_simm16(word: int) -> int:
    return sign_extend(op10_imm16(word), 16)


def op0b_regs(word: int) -> tuple[int, int]:
    """Return ``(base, value)`` for the 350.101 op0b masked-store path.

    The handler at ``+0x5685C`` builds the base from bit 31 plus bits
    ``[20:17]`` and the value slot from bit 16 plus bits ``[10:7]``.  It
    loads that slot with ``ldr w``; only the low 32 bits participate.
    """
    base = (((word >> 31) & 1) << 4) | ((word >> 17) & 0xF)
    value = (((word >> 16) & 1) << 4) | ((word >> 7) & 0xF)
    return base, value


def op0b_simm16(word: int) -> int:
    """Return op0b's signed offset reconstructed at ``+0x5685C``."""
    immediate = (
        ((word >> 11) & 0x1F)
        | (((word >> 21) & 0x3FF) << 5)
        | (((word >> 6) & 1) << 15)
    )
    return sign_extend(immediate, 16)


def op13_regs(word: int) -> tuple[int, int]:
    """Return ``(base, value)`` for the 350.101 op13 masked-store path.

    The handler at ``+0x55FD4`` resolves its base with bit 31 plus bits
    ``[25:22]`` and its value from the full five-bit field ``[21:17]``.  The
    normal path writes no virtual destination slot.
    """
    base = (((word >> 31) & 1) << 4) | ((word >> 22) & 0xF)
    value = (word >> 17) & 0x1F
    return base, value


def op13_simm16(word: int) -> int:
    """Return op13's signed offset reconstructed at ``+0x55FD4``.

    The low five bits come from word ``[30:26]``.  The remaining eleven bits
    are the contiguous word range ``[16:6]`` shifted into immediate
    ``[15:5]``.  This deliberately differs from both op1a and op3e.
    """
    immediate = ((word >> 26) & 0x1F) | (((word >> 6) & 0x7FF) << 5)
    return sign_extend(immediate, 16)


def op14_regs(word: int) -> tuple[int, int]:
    """Return ``(lhs, rhs)`` for 350.101 op14/BNE.

    ``rhs`` uses word bit 21 as its fifth bit. In the native handler this is
    reconstructed as ``(word >> 17) & 0x10``; shifting by 17 there must not be
    confused with selecting source bit 17.
    """
    lhs = (((word >> 31) & 1) << 4) | ((word >> 22) & 0xF)
    rhs = (((word >> 21) & 1) << 4) | ((word >> 27) & 0xF)
    return lhs, rhs


def op14_imm16(word: int) -> int:
    """Return the signed word displacement used by op14/BNE."""
    return (
        ((word >> 16) & 0x1F)
        | (((word >> 6) & 0x3FF) << 5)
        | (((word >> 26) & 1) << 15)
    )


def op14_simm16(word: int) -> int:
    return sign_extend(op14_imm16(word), 16)


def op16_regs(word: int) -> tuple[int, int]:
    """Return ``(base, value)`` for the current 350.101 op16/ST32."""
    base = (((word >> 31) & 1) << 4) | ((word >> 22) & 0xF)
    value = (((word >> 21) & 1) << 4) | ((word >> 12) & 0xF)
    return base, value


def op16_imm16(word: int) -> int:
    """Return the signed 32-bit-store offset reconstructed at +0x56E70."""
    return (
        ((word >> 16) & 0x1F)
        | (((word >> 6) & 0x1F) << 5)
        | (((word >> 26) & 0x1F) << 10)
        | (((word >> 11) & 1) << 15)
    )


def op16_simm16(word: int) -> int:
    return sign_extend(op16_imm16(word), 16)


def op1a_regs(word: int) -> tuple[int, int]:
    """Return ``(base, value)`` for 350.101 op1a/ST64.

    At +0x561B4, ``x10`` indexes the base pointer from x27 and ``x11``
    indexes the qword value. The handler uses its own scattered 16-bit
    displacement and stores ``x11`` to ``x10 + imm``. It is a different
    encoding from both the common immediate and op3b.
    """
    base = (((word >> 31) & 1) << 4) | ((word >> 17) & 0xF)
    value = (((word >> 16) & 1) << 4) | ((word >> 7) & 0xF)
    return base, value


def op1a_imm16(word: int) -> int:
    """Return the scattered displacement reconstructed by ST64 at +0x561B4.

    The native code takes bits [30:26], [10:6], [15:11], and bit 6 into
    destination ranges [4:0], [9:5], [14:10], and 15 respectively, then
    sign-extends the assembled halfword.  In particular, this is *not*
    ``imm16_common``: the captured word ``0xa03b2f9a`` decodes to ``0x04a8``
    here but to ``0x2a3e`` under the common layout.
    """
    return (
        ((word >> 26) & 0x1F)
        | ((word >> 6) & 0x03E0)
        | ((word >> 11) & 0x7C00)
        | ((word << 9) & 0x8000)
    )


def op1a_simm16(word: int) -> int:
    return sign_extend(op1a_imm16(word), 16)


def op21_regs(word: int) -> tuple[int, int]:
    """Return ``(dst, src)`` for 350.101 op21/ULT64_S16."""
    src = (((word >> 31) & 1) << 4) | ((word >> 12) & 0xF)
    dst = (word >> 7) & 0x1F
    return dst, src


def op21_imm16(word: int) -> int:
    """Return the signed comparison operand reconstructed at +0x52F34."""
    return (
        ((word >> 26) & 0x1F)
        | (((word >> 21) & 0x1F) << 5)
        | (((word >> 16) & 0x1F) << 10)
        | (((word >> 6) & 1) << 15)
    )


def op21_simm16(word: int) -> int:
    return sign_extend(op21_imm16(word), 16)


def op0f_regs(word: int) -> tuple[int, int]:
    """Return ``(dst, src)`` for 350.101 op0f/ADD64_IMM.

    The substantive path at +0x529D4 loads x27[src], adds the sign-extended
    scattered immediate, then writes x27[dst]. The initial +0x52984 range
    check is dispatcher hardening; it does not make op0f a VM branch.
    """
    src = (((word >> 31) & 1) << 4) | ((word >> 17) & 0xF)
    dst = (((word >> 16) & 1) << 4) | ((word >> 27) & 0xF)
    return dst, src


def op0f_imm16(word: int) -> int:
    """Return the non-common immediate field used by 350.101 op0f."""
    return (
        ((word >> 11) & 0x1F)
        | (((word >> 21) & 0x1F) << 5)
        | (((word >> 6) & 0x1F) << 10)
        | (((word >> 26) & 1) << 15)
    )


def op0f_simm16(word: int) -> int:
    return sign_extend(op0f_imm16(word), 16)


def op2d_regs(word: int) -> tuple[int, int]:
    """Return ``(lhs, rhs)`` for 350.101 op2d/BEQ."""
    lhs = (((word >> 31) & 1) << 4) | ((word >> 17) & 0xF)
    rhs = (word >> 12) & 0x1F
    return lhs, rhs


def op2d_imm16(word: int) -> int:
    """Return the non-common branch displacement field used by op2d."""
    return (
        ((word >> 6) & 0x1F)
        | (((word >> 26) & 1) << 5)
        | (((word >> 27) & 0xF) << 6)
        | (((word >> 21) & 0x1F) << 10)
        | (((word >> 11) & 1) << 15)
    )


def op2d_simm16(word: int) -> int:
    return sign_extend(op2d_imm16(word), 16)


def op2e_regs(word: int) -> tuple[int, int]:
    """Return ``(base, value)`` for the 350.101 op2e masked-store path.

    The normal handler at ``+0x565E0`` reads the base qword from bit 31 plus
    bits ``[20:17]`` and loads the value slot ``[16:12]`` through ``ldr w``.
    It is a store, despite its former ``LD32_UNALIGNED`` label.
    """
    base = (((word >> 31) & 1) << 4) | ((word >> 17) & 0xF)
    value = (word >> 12) & 0x1F
    return base, value


def op2e_simm16(word: int) -> int:
    """Return op2e's signed offset reconstructed at ``+0x565E0``."""
    immediate = (
        ((word >> 26) & 0x1F)
        | (((word >> 6) & 0x1F) << 5)
        | (((word >> 21) & 0x1F) << 10)
        | (((word >> 11) & 1) << 15)
    )
    return sign_extend(immediate, 16)


def op28_regs(word: int) -> tuple[int, int]:
    """Return ``(dst, src)`` for 350.101 op28/LD8U.

    The true top-level handler is `+0x55908`. The commonly reached
    `+0x4E0BC` ADD64 body instead belongs to op11 selector `0x0e`; the two
    must not be conflated merely because their dispatch tails are adjacent in
    a trace.
    """
    src = (((word >> 31) & 1) << 4) | ((word >> 7) & 0xF)
    dst = (((word >> 6) & 1) << 4) | ((word >> 27) & 0xF)
    return dst, src


def op28_imm16(word: int) -> int:
    """Return the signed byte-load offset reconstructed at `+0x55908`."""
    return (
        ((word >> 21) & 0x1F)
        | (((word >> 16) & 0x1F) << 5)
        | (((word >> 11) & 0x1F) << 10)
        | (((word >> 26) & 1) << 15)
    )


def op28_simm16(word: int) -> int:
    return sign_extend(op28_imm16(word), 16)


def op2b_reg(word: int) -> int:
    """Return the signed-GT-zero register selected by 350.101 op2b."""
    return (word >> 27) & 0x1F


def op2b_imm16(word: int) -> int:
    """Return the signed branch displacement reconstructed at +0x53B68."""
    return (
        ((word >> 16) & 0x1F)
        | (((word >> 6) & 0x1F) << 5)
        | (((word >> 21) & 0x1F) << 10)
        | (((word >> 11) & 1) << 15)
    )


def op2b_simm16(word: int) -> int:
    return sign_extend(op2b_imm16(word), 16)


def op30_regs(word: int) -> tuple[int, int]:
    """Return ``(dst, src)`` for 350.101 op30/OR64_IMM."""
    src = (((word >> 31) & 1) << 4) | ((word >> 7) & 0xF)
    dst = (((word >> 6) & 1) << 4) | ((word >> 17) & 0xF)
    return dst, src


def op30_imm16(word: int) -> int:
    """Return the unsigned OR mask reconstructed at +0x5332C."""
    return (
        ((word >> 21) & 0x1F)
        | (((word >> 11) & 0x1F) << 5)
        | (((word >> 26) & 0x1F) << 10)
        | (((word >> 16) & 1) << 15)
    )


def op34_dst(word: int) -> int:
    """Return the destination slot of 350.101 op34/MOV32HI_S.

    Handler `+0x531E4` obtains the high register bit from bit 21 via
    ``(word >> 17) & 0x10``, then inserts word bits `[30:27]` below it.
    """
    return (((word >> 21) & 1) << 4) | ((word >> 27) & 0xF)


def op34_imm16(word: int) -> int:
    """Return the immediate used by op34's sign-extended ``<< 16`` write."""
    return (
        ((word >> 11) & 0x3FF)
        | (((word >> 6) & 0x1F) << 10)
        | (((word >> 26) & 1) << 15)
    )


def op35_regs(word: int) -> tuple[int, int]:
    """Return ``(dst, src)`` for 350.101 op35/AND32_IMM."""
    src = (((word >> 31) & 1) << 4) | ((word >> 12) & 0xF)
    dst = (word >> 7) & 0x1F
    return dst, src


def op35_imm16(word: int) -> int:
    """Return the unsigned low-32 AND mask reconstructed at +0x5309C."""
    return (
        ((word >> 16) & 0x1F)
        | (((word >> 26) & 0x1F) << 5)
        | (((word >> 21) & 0x1F) << 10)
        | (((word >> 6) & 1) << 15)
    )


def op3e_regs(word: int) -> tuple[int, int]:
    """Return ``(base, value)`` for the 350.101 op3e masked-store path.

    The current handler at ``+0x55D20`` reconstructs different register
    fields from both the historical common-immediate family and op1a.  It
    never writes a virtual destination register on the normal VM path.
    """
    base = (((word >> 31) & 1) << 4) | ((word >> 22) & 0xF)
    value = (((word >> 21) & 1) << 4) | ((word >> 7) & 0xF)
    return base, value


def op3e_simm16(word: int) -> int:
    """Return op3e's signed scattered offset from its ``+0x55D20`` path.

    The field order is deliberately separate from op1a: native reconstruction
    places word bits ``[30:26]``, ``[20:16]``, ``[15:11]``, and ``[6]`` into
    immediate ranges ``[4:0]``, ``[9:5]``, ``[14:10]``, and ``[15]``.
    """
    immediate = (
        ((word >> 26) & 0x1F)
        | (((word >> 16) & 0x1F) << 5)
        | (((word >> 11) & 0x1F) << 10)
        | (((word >> 6) & 1) << 15)
    )
    return sign_extend(immediate, 16)


def op3b_regs(word: int) -> tuple[int, int]:
    """Return ``(dst, src)`` for 350.101 op3b/ADD32S_IMM."""
    return op01_regs(word)


def op3b_imm16(word: int) -> int:
    """Return the signed immediate used by op3b at +0x52D04."""
    return op01_imm16(word)


def op3b_simm16(word: int) -> int:
    return sign_extend(op3b_imm16(word), 16)


def decode_word(word: int) -> tuple[str, str]:
    op = word & 0x3F
    name, note = OP_INFO.get(op, (f"UNK_{op:02X}", "unknown opcode"))
    f = fields(word)

    if op == 0x0D:
        text = f"pc = vm_base + 0x{op0d_target26(word) * 4:x}"
    elif op == 0x01:
        dst, src = op01_regs(word)
        text = f"v{dst} = load_i32 [v{src} + {op01_simm16(word):+#x}]"
    elif op == 0x0F:
        dst, src = op0f_regs(word)
        text = f"v{dst} = v{src} + {op0f_simm16(word):+#x}"
    elif op == 0x0B:
        base, value = op0b_regs(word)
        text = (
            f"store_u32_masked_left [v{base}{op0b_simm16(word):+#x}], "
            f"v{value}.u32"
        )
    elif op == 0x10:
        base, value = op10_regs(word)
        text = f"store_u8 [v{base} + {op10_simm16(word):+#x}], v{value}"
    elif op == 0x13:
        base, value = op13_regs(word)
        text = (
            f"store_u64_masked_left [v{base}{op13_simm16(word):+#x}], "
            f"v{value}"
        )
    elif op == 0x11:
        selector = op11_selector(word)
        subop = OP11_SUBOP_INFO.get(selector)
        r12, r17, r22, r27 = op11_fields(word)
        if subop is None:
            text = f"subop_dispatch? selector=0x{selector:02x}"
        else:
            name, note = subop
            if selector == 0x03:
                text = f"v{r27} = sign_extend32((u32)v{r12} << {r17})"
            elif selector == 0x0E:
                text = f"v{r27} = v{r17} + v{r22}"
            elif selector == 0x17:
                text = f"v{r27} = v{r22} << {r17}"
            elif selector == 0x1D:
                text = f"v{r12} = v{r22} ^ v{r27}"
            elif selector == 0x1E:
                text = f"pc = v{r22}"
            elif selector == 0x2B:
                text = f"v{r27} = ((i64)v{r12} < (i64)v{r22})"
            elif selector == 0x2C:
                text = f"v{r27} = v{r12} | v{r22}"
            elif selector == 0x32:
                text = f"v{r12} = pc+4; pc = v{r27}"
            else:
                # A table entry without a renderer is deliberately still
                # visible as a dispatch rather than guessed from common fields.
                text = f"subop_dispatch? selector=0x{selector:02x}"
    elif op == 0x14:
        lhs, rhs = op14_regs(word)
        text = f"if (v{lhs} != v{rhs}) pc = pc+4{op14_simm16(word) << 2:+#x}"
    elif op == 0x16:
        base, value = op16_regs(word)
        text = f"store_u32 [v{base} + {op16_simm16(word):+#x}], v{value}"
    elif op == 0x18:
        dst, src = op18_regs(word)
        text = f"v{dst} = load_u64 [v{src} + {f['simm16']:+#x}]"
    elif op == 0x1A:
        base, value = op1a_regs(word)
        text = f"store_u64 [v{base} + {op1a_simm16(word):+#x}], v{value}"
    elif op == 0x21:
        dst, src = op21_regs(word)
        text = f"v{dst} = (u64)v{src} < (u64){op21_simm16(word):+#x}"
    elif op == 0x28:
        dst, src = op28_regs(word)
        text = f"v{dst} = load_u8 [v{src} + {op28_simm16(word):+#x}]"
    elif op == 0x2B:
        reg_index = op2b_reg(word)
        text = f"if ((i64)v{reg_index} > 0) pc = pc+4{op2b_simm16(word) << 2:+#x}"
    elif op == 0x2D:
        lhs, rhs = op2d_regs(word)
        text = f"if (v{lhs} == v{rhs}) pc = pc+4{op2d_simm16(word) << 2:+#x}"
    elif op == 0x2E:
        base, value = op2e_regs(word)
        text = (
            f"store_u32_masked_right [v{base}{op2e_simm16(word):+#x}], "
            f"v{value}.u32"
        )
    elif op == 0x30:
        dst, src = op30_regs(word)
        text = f"v{dst} = v{src} | 0x{op30_imm16(word):04x}"
    elif op == 0x34:
        text = f"v{op34_dst(word)} = sign_extend32(0x{op34_imm16(word):04x} << 16)"
    elif op == 0x35:
        dst, src = op35_regs(word)
        text = f"v{dst} = (u32)v{src} & 0x{op35_imm16(word):04x}"
    elif op == 0x3E:
        base, value = op3e_regs(word)
        text = (
            f"store_u64_masked_right [v{base}{op3e_simm16(word):+#x}], "
            f"v{value}"
        )
    elif op == 0x3B:
        dst, src = op3b_regs(word)
        text = f"v{dst} = sign_extend32(v{src}) + {op3b_simm16(word):+#x}"
    elif op in (0x02, 0x08, 0x33):
        width = {
            0x02: "u64",
            0x08: "i8",
            0x33: "u32",
        }[op]
        text = f"v{f['r16']} = load_{width} [v{f['r21']} + {f['simm16']:+#x}]"
    elif op == 0x15:
        width = "i32"
        text = f"v{f['r16']} = ({width})v{f['r21']} + {f['simm16']:+#x}"
    elif op in (0x0E, 0x36):
        width = {0x0E: "u8", 0x36: "u32"}[op]
        text = f"store_{width} [v{f['r21']} + {f['simm16']:+#x}], v{f['r16']}"
    elif op in (0x0A, 0x0B, 0x24):
        width = "u64" if op in (0x0A, 0x0B) else "u32"
        side = "right/high-byte merge" if op == 0x0A else "left/low-byte merge"
        text = f"store_unaligned_{width}({side}) [v{f['r21']} + {f['simm16']:+#x}], v{f['r16']}"
    elif op in (0x20, 0x38):
        sym = {0x20: "&", 0x38: "^"}[op]
        text = f"v{f['r16']} = v{f['r21']} {sym} 0x{f['imm16']:04x}"
    elif op in (0x03, 0x05, 0x2C, 0x3A, 0x3F):
        text = f"branch_cond? target=pc+4{f['br_delta']:+#x} src=v{f['r21']} cmp=v{f['r16']} lo12=0x{f['lo12']:03x}"
    elif op == 0x2A:
        text = f"jump_imm? target=vm_base+0x{((word >> 6) & 0x03ffffff) * 4:x}"
    else:
        text = (
            f"{name.lower()}? "
            f"dst=v{f['r16']} src=v{f['r21']} "
            f"lo12=0x{f['lo12']:03x} imm16=0x{f['imm16']:04x}"
        )

    return name, f"{text} ; {note}"


def parse_log(path: Path) -> list[NativeRow]:
    rows: list[NativeRow] = []
    with path.open("r", encoding="utf-8", errors="replace") as fp:
        for line_no, line in enumerate(fp, 1):
            match = LINE_RE.match(line.strip())
            if not match:
                continue
            rows.append(
                NativeRow(
                    line_no=line_no,
                    runtime=parse_int(match["runtime"]),
                    offset=parse_int(match["offset"]),
                    insn=match["insn"].strip(),
                    tail=match["tail"],
                )
            )
    return rows


def infer_image_base(rows: Sequence[NativeRow]) -> int:
    if not rows:
        raise ValueError("empty trace")
    return rows[0].runtime - rows[0].offset


def infer_vm_pages(rows: Sequence[NativeRow], page_count: int) -> set[int]:
    page_hits: Counter[int] = Counter()
    for row in rows:
        if not VM_WORD_LOAD_RE.match(row.insn):
            continue
        mem_match = MEM_R_RE.search(row.tail)
        word_match = WORD_RESULT_RE.search(row.tail)
        if not (mem_match and word_match):
            continue
        page_hits[parse_int(mem_match.group(1)) & ~(PAGE_SIZE - 1)] += 1

    if not page_hits:
        return set()

    return {page for page, _ in page_hits.most_common(page_count)}


def extract_vm_reads(rows: Sequence[NativeRow], vm_pages: set[int]) -> list[VmRead]:
    reads: list[VmRead] = []
    for row in rows:
        if not VM_WORD_LOAD_RE.match(row.insn):
            continue
        mem_match = MEM_R_RE.search(row.tail)
        word_match = WORD_RESULT_RE.search(row.tail)
        if not (mem_match and word_match):
            continue

        vm_pc = parse_int(mem_match.group(1))
        if (vm_pc & ~(PAGE_SIZE - 1)) not in vm_pages:
            continue

        reads.append(
            VmRead(
                line_no=row.line_no,
                native_offset=row.offset,
                vm_pc=vm_pc,
                word=parse_int(word_match.group(1)) & 0xFFFFFFFF,
                insn=row.insn,
            )
        )
    return reads


def collapse_consecutive_reads(reads: Iterable[VmRead]) -> list[VmRead]:
    out: list[VmRead] = []
    prev: tuple[int, int] | None = None
    for read in reads:
        key = (read.vm_pc, read.word)
        if key == prev:
            continue
        out.append(read)
        prev = key
    return out


def unique_stream_reads(reads: Iterable[VmRead]) -> list[VmRead]:
    out: list[VmRead] = []
    seen: set[tuple[int, int]] = set()
    for read in reads:
        key = (read.vm_pc, read.word)
        if key in seen:
            continue
        seen.add(key)
        out.append(read)
    return out


def extract_dispatches(rows: Sequence[NativeRow], base: int, reads: Sequence[VmRead]) -> list[DispatchEvent]:
    brs: list[tuple[int, int, int]] = []
    for row in rows:
        if row.insn != "br x8":
            continue
        values = X8_RE.findall(row.tail)
        if values:
            brs.append((row.line_no, row.offset, parse_int(values[-1]) - base))

    events: list[DispatchEvent] = []
    for idx, (br_line, br_site, target) in enumerate(brs):
        next_br_line = brs[idx + 1][0] if idx + 1 < len(brs) else sys.maxsize
        first_read = next((r for r in reads if br_line < r.line_no < next_br_line), None)
        events.append(
            DispatchEvent(
                seq=idx,
                br_line=br_line,
                br_site=br_site,
                target=target,
                read=first_read,
            )
        )
    return events


def handler_label(target: int) -> str:
    op, note = HANDLER_INFO.get(target, (None, "secondary/unknown target"))
    if op is None:
        return note
    name, _ = OP_INFO.get(op, (f"OP{op:02X}", ""))
    return f"{name}/op{op:02x} ({note})"


def format_stream(reads: Sequence[VmRead], limit: int | None = None) -> list[str]:
    lines: list[str] = []
    selected = reads[:limit] if limit else reads
    for idx, read in enumerate(selected):
        name, text = decode_word(read.word)
        rel = read.vm_pc - reads[0].vm_pc if reads else 0
        lines.append(
            f"{idx:04d} vm+0x{rel:04x} pc=0x{read.vm_pc:x} "
            f"word=0x{read.word:08x} op=0x{read.op:02x} {name:<15} "
            f"fetch=0x{read.native_offset:x} line={read.line_no:<6} {text}"
        )
    return lines


def format_exec(events: Sequence[DispatchEvent], limit: int | None = None) -> list[str]:
    lines: list[str] = []
    selected = events[:limit] if limit else events
    for event in selected:
        if event.read is None:
            lines.append(
                f"{event.seq:04d} br@0x{event.br_site:x} -> 0x{event.target:x} "
                f"{handler_label(event.target)} ; no VM word read before next BR"
            )
            continue
        read = event.read
        name, text = decode_word(read.word)
        mismatch = ""
        expected_op, _ = HANDLER_INFO.get(event.target, (None, ""))
        if expected_op is not None and expected_op != read.op:
            mismatch = f" ; handler/op mismatch expected=0x{expected_op:02x}"
        lines.append(
            f"{event.seq:04d} br@0x{event.br_site:x} -> 0x{event.target:x} "
            f"{handler_label(event.target):<42} "
            f"vm_pc=0x{read.vm_pc:x} word=0x{read.word:08x} "
            f"op=0x{read.op:02x} {name:<15} "
            f"fetch=0x{read.native_offset:x} line={read.line_no:<6} "
            f"{text}{mismatch}"
        )
    return lines


def summary_lines(
    rows: Sequence[NativeRow],
    base: int,
    vm_pages: set[int],
    reads: Sequence[VmRead],
    stream_reads: Sequence[VmRead],
    events: Sequence[DispatchEvent],
) -> list[str]:
    op_counts = Counter(read.op for read in stream_reads)
    handler_counts = Counter(event.target for event in events)
    fetch_sites: defaultdict[int, Counter[int]] = defaultdict(Counter)
    for read in stream_reads:
        fetch_sites[read.native_offset][read.op] += 1

    out = [
        "# metasec VM trace decoder",
        f"# image_base: 0x{base:x}",
        "# vm_pages: " + ", ".join(f"0x{page:x}" for page in sorted(vm_pages)),
        f"# native_rows: {len(rows)}",
        f"# vm_word_reads_raw: {len(reads)}",
        f"# vm_word_reads_stream: {len(stream_reads)}",
        f"# br_x8_dispatches: {len(events)}",
        "",
        "# opcode histogram from stream view:",
    ]
    for op, count in sorted(op_counts.items()):
        name, note = OP_INFO.get(op, (f"UNK_{op:02X}", "unknown"))
        out.append(f"#   op 0x{op:02x}: {count:4d}  {name:<15} {note}")

    op11_counts = Counter(
        op11_selector(read.word) for read in stream_reads if read.op == 0x11
    )
    if op11_counts:
        out.extend(["", "# op11 secondary-selector histogram from stream view:"])
        for selector, count in sorted(op11_counts.items()):
            name, note = OP11_SUBOP_INFO.get(
                selector, (f"SUBOP_{selector:02X}", "selector is not recovered")
            )
            out.append(f"#   subop 0x{selector:02x}: {count:4d}  {name:<15} {note}")

    out.extend(["", "# top BR X8 targets:"])
    for target, count in handler_counts.most_common(32):
        out.append(f"#   0x{target:x}: {count:4d}  {handler_label(target)}")

    out.extend(["", "# VM word fetch sites:"])
    for site, counter in sorted(fetch_sites.items(), key=lambda item: (-sum(item[1].values()), item[0])):
        ops = ", ".join(f"{op:02x}:{count}" for op, count in sorted(counter.items()))
        out.append(f"#   0x{site:x}: {sum(counter.values()):4d}  {ops}")

    out.append("")
    return out


def build_output(args: argparse.Namespace) -> str:
    rows = parse_log(args.log)
    base = infer_image_base(rows)

    if args.vm_page:
        vm_pages = {int(page, 0) & ~(PAGE_SIZE - 1) for page in args.vm_page}
    else:
        vm_pages = infer_vm_pages(rows, args.vm_page_count)

    reads_raw = extract_vm_reads(rows, vm_pages)
    reads_collapsed = collapse_consecutive_reads(reads_raw)
    stream_reads = reads_collapsed if args.keep_repeats else unique_stream_reads(reads_collapsed)
    events = extract_dispatches(rows, base, reads_raw)

    lines = summary_lines(rows, base, vm_pages, reads_raw, stream_reads, events)
    if args.view in ("stream", "both"):
        lines.append("# stream view: unique/collapsed VM words in first-observed order")
        lines.extend(format_stream(stream_reads, args.limit))
        lines.append("")
    if args.view in ("exec", "both"):
        lines.append("# exec view: every observed BR X8 and first VM word read before next BR")
        lines.extend(format_exec(events, args.limit))
        lines.append("")
    return "\n".join(lines)


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Trace-driven decoder for libmetasec_ml.so VM GumTrace logs."
    )
    parser.add_argument(
        "log",
        nargs="?",
        type=Path,
        default=DEFAULT_LOG,
        help=f"GumTrace log path, default: {DEFAULT_LOG}",
    )
    parser.add_argument(
        "--view",
        choices=("stream", "exec", "both"),
        default="both",
        help="Which listing to emit.",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=0,
        help="Limit rows per listing view. 0 means no limit.",
    )
    parser.add_argument(
        "--vm-page",
        action="append",
        help="VM bytecode page base, e.g. 0x7105660000. Can be repeated. "
        "Default infers the busiest mem_r page.",
    )
    parser.add_argument(
        "--vm-page-count",
        type=int,
        default=1,
        help="How many busiest mem_r pages to treat as VM bytecode when --vm-page is omitted.",
    )
    parser.add_argument(
        "--keep-repeats",
        action="store_true",
        help="Keep repeated VM pc/word observations in stream view.",
    )
    parser.add_argument(
        "-o",
        "--out",
        type=Path,
        help="Write listing to file instead of stdout.",
    )
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    text = build_output(args)
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text + "\n", encoding="utf-8")
    else:
        print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
