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
    0x00: ("LD16S", "dst = *(int16_t *)(src + simm16), from z/ws/vm64.cpp"),
    0x01: ("OP01", "unknown/no-op-ish in current reconstruction"),
    0x02: ("LD64", "dst = *(uint64_t *)(src + simm16), from z/ws/vm64.cpp"),
    0x08: ("LD8S", "dst = *(int8_t *)(src + simm16), from z/ws/vm64.cpp"),
    0x0A: ("ST64_UNALIGNED_R", "unaligned 64-bit store/merge variant, from z/ws/vm64.cpp"),
    0x0B: ("ST64_UNALIGNED_L", "unaligned 64-bit store/merge variant, from z/ws/vm64.cpp"),
    0x0D: ("ADD64_IMM", "dst = src + simm16, from z/ws/vm64.cpp"),
    0x0E: ("ST8", "*(src + simm16) = dst.u8, from z/ws/vm64.cpp"),
    0x0F: ("BR_COND", "conditional VM-PC control family, from z/ws/vm64.cpp"),
    0x10: ("BITFIELD", "bitfield extract/insert/sign-extend/rev family, from z/ws/vm64.cpp"),
    0x11: ("CALL_IMM_LINK31", "VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp"),
    0x13: ("OP13", "unknown/no-op-ish in current reconstruction"),
    0x14: ("ST16", "*(src + simm16) = dst.u16, from z/ws/vm64.cpp"),
    0x15: ("ADD32S_IMM", "dst = (int32_t)src + simm16, from z/ws/vm64.cpp"),
    0x16: ("ST32_UNALIGNED_R", "unaligned 32-bit store/merge variant, from z/ws/vm64.cpp"),
    0x18: ("OP18", "350 trace hits this handler; exact semantics still version-verify"),
    0x1A: ("BR_COND", "conditional VM-PC control family, from z/ws/vm64.cpp"),
    0x21: ("LD8U", "dst = *(uint8_t *)(src + simm16), from z/ws/vm64.cpp"),
    0x24: ("ST32_UNALIGNED_L", "unaligned 32-bit store/merge variant, from z/ws/vm64.cpp"),
    0x28: ("ADD64_IMM", "dst = src + simm16, from z/ws/vm64.cpp"),
    0x2B: ("LD32S", "dst = *(int32_t *)(src + simm16), from z/ws/vm64.cpp"),
    0x2C: ("BR_COND", "conditional VM-PC control family, from z/ws/vm64.cpp"),
    0x2D: ("BR_COND", "conditional VM-PC control family, from z/ws/vm64.cpp"),
    0x2E: ("LD32_UNALIGNED", "unaligned 32-bit load/merge style"),
    0x30: ("LD16U", "dst = *(uint16_t *)(src + simm16), from z/ws/vm64.cpp"),
    0x33: ("LD32U", "dst = *(uint32_t *)(src + simm16), from z/ws/vm64.cpp"),
    0x34: ("OP34", "unknown/no-op-ish in current reconstruction"),
    0x36: ("ST32", "*(src + simm16) = dst.u32, from z/ws/vm64.cpp"),
    0x38: ("XOR_IMM", "dst = src ^ imm16, from z/ws/vm64.cpp"),
    0x3A: ("BR_COND", "conditional VM-PC control family, from z/ws/vm64.cpp"),
    0x3B: ("ST64", "*(src + simm16) = dst.u64, from z/ws/vm64.cpp"),
    0x3E: ("OR_IMM", "dst = src | imm16, from z/ws/vm64.cpp"),
    0x3F: ("BR_COND", "conditional VM-PC control family, from z/ws/vm64.cpp"),
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


def decode_word(word: int) -> tuple[str, str]:
    op = word & 0x3F
    name, note = OP_INFO.get(op, (f"UNK_{op:02X}", "unknown opcode"))
    f = fields(word)

    if op in (0x00, 0x02, 0x08, 0x21, 0x2B, 0x30, 0x33):
        width = {
            0x00: "i16",
            0x02: "u64",
            0x08: "i8",
            0x21: "u8",
            0x2B: "i32",
            0x30: "u16",
            0x33: "u32",
        }[op]
        text = f"v{f['r16']} = load_{width} [v{f['r21']} + {f['simm16']:+#x}]"
    elif op in (0x0D, 0x15, 0x28):
        width = "i32" if op == 0x15 else "u64"
        text = f"v{f['r16']} = ({width})v{f['r21']} + {f['simm16']:+#x}"
    elif op in (0x0E, 0x14, 0x36, 0x3B):
        width = {0x0E: "u8", 0x14: "u16", 0x36: "u32", 0x3B: "u64"}[op]
        text = f"store_{width} [v{f['r21']} + {f['simm16']:+#x}], v{f['r16']}"
    elif op in (0x0A, 0x0B, 0x16, 0x24):
        width = "u64" if op in (0x0A, 0x0B) else "u32"
        side = "right/high-byte merge" if op in (0x0A, 0x16) else "left/low-byte merge"
        text = f"store_unaligned_{width}({side}) [v{f['r21']} + {f['simm16']:+#x}], v{f['r16']}"
    elif op in (0x20, 0x38, 0x3E):
        sym = {0x20: "&", 0x38: "^", 0x3E: "|"}[op]
        text = f"v{f['r16']} = v{f['r21']} {sym} 0x{f['imm16']:04x}"
    elif op in (0x03, 0x05, 0x0F, 0x1A, 0x2C, 0x2D, 0x3A, 0x3F):
        text = f"branch_cond? target=pc+4{f['br_delta']:+#x} src=v{f['r21']} cmp=v{f['r16']} lo12=0x{f['lo12']:03x}"
    elif op == 0x11:
        text = f"call_imm? target=vm_base+0x{((word >> 6) & 0x03ffffff) * 4:x}, link=v31=pc+8"
    elif op == 0x2A:
        text = f"jump_imm? target=vm_base+0x{((word >> 6) & 0x03ffffff) * 4:x}"
    elif op == 0x10:
        text = f"bitfield/rev/extract? dst=v{f['r16']} src=v{f['r21']} lo12=0x{f['lo12']:03x}"
    elif op == 0x18:
        text = f"op18/version-specific? dst=v{f['r16']} src=v{f['r21']} lo12=0x{f['lo12']:03x} imm16=0x{f['imm16']:04x}"
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
