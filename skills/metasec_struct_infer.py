#!/usr/bin/env python3
"""
Infer libmetasec_ml.so transient/native structs from entry dumps and
unidbg struct-trace logs.

The script is deliberately evidence-first: it does not try to "solve" the
structure in one pass. It groups observations by register + offset, keeps the
PCs that read/write each field, annotates qword pointers with nested ASCII
evidence, and emits a C skeleton that can be iteratively renamed.

Typical usage:

  python3 dyidre/skills/metasec_struct_infer.py \
    --entry-log dyidre/runs/350101/entrydump/20260830_201913_wrapper/rf_gumtrace_entrydump_350101.wrapper_entrydump.txt \
    --trace-log unidbg/unidbg-android/target/sign6_350101_structtrace_x0_1000_20260830_203159.log \
    --reg x0 --out-dir dyidre/struct_infer_350101
"""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable


ENTRY_ADDR_RE = re.compile(r"\[entry-dump\]\s+(x[0-8])=0x([0-9a-fA-F]+)")
QWORD_RE = re.compile(r"\+0x([0-9a-fA-F]+)=0x([0-9a-fA-F]+)")
NESTED_ASCII_RE = re.compile(
    r"\[entry-dump\]\s+(x[0-8])\.q([0-9]+)\s+->\s+0x([0-9a-fA-F]+).*?ascii=\"([^\"]*)\""
)
NESTED_HEX_RE = re.compile(
    r"\[entry-dump\]\s+(x[0-8])\.q([0-9]+)\s+->\s+0x([0-9a-fA-F]+).*?hex=([0-9a-fA-F ]+)"
)
STRUCT_TRACE_RE = re.compile(
    r"\[struct-trace\]\s+([RW])\s+(x[0-8])\+0x([0-9a-fA-F]+)\s+"
    r"size=(\d+)(?:\s+value=0x([0-9a-fA-F]+))?\s+"
    r"pc=0x([0-9a-fA-F]+)\s+([^+\s]+)\+0x([0-9a-fA-F]+)"
    r"(?:\s+data=(\S+))?"
)


@dataclass
class Access:
    kind: str
    reg: str
    offset: int
    size: int
    module: str
    pc_off: int
    value: str = ""
    data: str = ""
    seq: int = 0

    @property
    def end(self) -> int:
        return self.offset + self.size

    @property
    def pc_label(self) -> str:
        return f"{self.module}+0x{self.pc_off:x}"


@dataclass
class NestedEvidence:
    pointer: int
    ascii: str = ""
    hex: str = ""


@dataclass
class RegEvidence:
    reg: str
    entry_addr: int | None = None
    qwords: dict[int, int] = field(default_factory=dict)
    nested: dict[int, NestedEvidence] = field(default_factory=dict)
    accesses: list[Access] = field(default_factory=list)

    @property
    def max_access_end(self) -> int:
        return max((a.end for a in self.accesses), default=0)


def read_lines(paths: Iterable[Path]) -> Iterable[str]:
    for path in paths:
        if not path.exists():
            continue
        with path.open("r", errors="replace") as fp:
            yield from fp


def parse_logs(entry_logs: list[Path], trace_logs: list[Path]) -> dict[str, RegEvidence]:
    regs: dict[str, RegEvidence] = {f"x{i}": RegEvidence(f"x{i}") for i in range(9)}

    current_qword_reg: str | None = None
    for line in read_lines(entry_logs):
        m = ENTRY_ADDR_RE.search(line)
        if m:
            reg, addr = m.group(1), int(m.group(2), 16)
            regs[reg].entry_addr = addr

        if "[entry-dump]" in line and " qwords " in line:
            reg_m = re.search(r"\[entry-dump\]\s+(x[0-8])\s+qwords", line)
            current_qword_reg = reg_m.group(1) if reg_m else None
            if current_qword_reg:
                for off_s, value_s in QWORD_RE.findall(line):
                    regs[current_qword_reg].qwords[int(off_s, 16)] = int(value_s, 16)

        m = NESTED_ASCII_RE.search(line)
        if m:
            reg, qidx, ptr_s, ascii_s = m.group(1), int(m.group(2)), m.group(3), m.group(4)
            ev = regs[reg].nested.setdefault(qidx, NestedEvidence(int(ptr_s, 16)))
            ev.ascii = ascii_s

        m = NESTED_HEX_RE.search(line)
        if m:
            reg, qidx, ptr_s, hex_s = m.group(1), int(m.group(2)), m.group(3), m.group(4)
            ev = regs[reg].nested.setdefault(qidx, NestedEvidence(int(ptr_s, 16)))
            ev.hex = hex_s

    for seq, line in enumerate(read_lines(trace_logs), 1):
        m = STRUCT_TRACE_RE.search(line)
        if not m:
            continue
        kind, reg, off_s, size_s, value_s, _pc, module, pc_off_s, data_s = m.groups()
        regs[reg].accesses.append(
            Access(
                kind=kind,
                reg=reg,
                offset=int(off_s, 16),
                size=int(size_s),
                module=module,
                pc_off=int(pc_off_s, 16),
                value=f"0x{value_s}" if value_s else "",
                data=data_s or "",
                seq=seq,
            )
        )

    return regs


def printable_from_hex(hex_s: str) -> str:
    out = []
    for part in hex_s.split():
        try:
            b = int(part, 16)
        except ValueError:
            continue
        out.append(chr(b) if 0x20 <= b <= 0x7E else ".")
    return "".join(out)


def guess_name(offset: int, qword: int | None, nested: NestedEvidence | None, accesses: list[Access]) -> str:
    text = ""
    if nested:
        text = nested.ascii or printable_from_hex(nested.hex)
    lower = text.lower()

    if offset == 0:
        return "ops_or_vtable"
    if ".msf" in lower or ".msp" in lower or ".mss" in lower or "msdata" in lower:
        return "msdata_node"
    if "cookie" in lower or "x-tt-dt" in lower or "user-agent" in lower:
        return "header_node"
    if "x-vc-bdturing" in lower:
        return "bdturing_header_node"
    if "apiandparams" in lower:
        return "api_params_node"
    if "httprequestcallback" in lower:
        return "http_callback_node"
    if "1128" in lower or "aid" in lower:
        return "aid_or_app_node"
    if any(a.size == 1 for a in accesses) and offset < 0x380:
        return f"flag_{offset:03x}"
    if offset >= 0x380:
        return f"encode_buf_{offset:03x}"
    if qword is not None and qword > 0x10000:
        return f"ptr_{offset:03x}"
    return f"field_{offset:03x}"


def summarize_reg(ev: RegEvidence) -> dict:
    accesses_by_offset: dict[int, list[Access]] = defaultdict(list)
    for access in ev.accesses:
        accesses_by_offset[access.offset].append(access)

    offsets = sorted(set(ev.qwords) | set(accesses_by_offset))
    rows = []
    for off in offsets:
        qword = ev.qwords.get(off)
        nested = ev.nested.get(off // 8) if off % 8 == 0 else None
        accesses = accesses_by_offset.get(off, [])
        pcs = Counter(a.pc_label for a in accesses)
        kinds = "".join(sorted(set(a.kind for a in accesses)))
        sizes = ",".join(str(s) for s in sorted(set(a.size for a in accesses)))
        values = [a.value or a.data for a in accesses if a.value or a.data]
        rows.append(
            {
                "offset": off,
                "name": guess_name(off, qword, nested, accesses),
                "qword": f"0x{qword:016x}" if qword is not None else "",
                "access": kinds,
                "sizes": sizes,
                "count": len(accesses),
                "pcs": [f"{pc} ({count})" for pc, count in pcs.most_common(6)],
                "sample_values": values[:5],
                "nested_ascii": (nested.ascii if nested else ""),
            }
        )
    return {
        "reg": ev.reg,
        "entry_addr": f"0x{ev.entry_addr:x}" if ev.entry_addr is not None else "",
        "max_access_end": f"0x{ev.max_access_end:x}",
        "rows": rows,
    }


def c_type_for_row(row: dict) -> str:
    sizes = {int(x) for x in row["sizes"].split(",") if x}
    if row["qword"] and int(row["qword"], 16) > 0x10000:
        return "void *"
    if 8 in sizes:
        return "uint64_t"
    if 4 in sizes:
        return "uint32_t"
    if 2 in sizes:
        return "uint16_t"
    if 1 in sizes:
        return "uint8_t"
    return "uint64_t"


def emit_c_skeleton(summary: dict, struct_name: str) -> str:
    rows = summary["rows"]
    # Only emit sparse fields up to the max accessed byte. Contiguous encode_buf
    # fields are compressed into one byte array.
    max_end = int(summary["max_access_end"], 16)
    if max_end == 0:
        max_end = (max([r["offset"] for r in rows], default=0) + 8)

    lines = [
        "#include <stdint.h>",
        "",
        f"typedef struct {struct_name} {{",
    ]
    cur = 0
    i = 0
    while i < len(rows):
        row = rows[i]
        off = row["offset"]
        if off < cur:
            i += 1
            continue
        if off >= 0x380:
            # Compress the observed tail buffer.
            if cur < off:
                lines.append(f"    uint8_t pad_{cur:03x}[0x{off - cur:x}];")
            if off <= 0x3c0 and max_end >= 0x500:
                lines.append(
                    "    uint8_t env_tlv_scratch_3c0[0xa0]; /* +0x3c0..+0x45f: "
                    "zeroed, then TLV/plain env fields; later reused for X-Soter/report text */"
                )
                lines.append(
                    "    uint8_t transform_out_460[0xa0]; /* +0x460..+0x4ff: "
                    "bytewise output written by libmetasec_ml.so+0x138560 in current trace */"
                )
            else:
                lines.append(f"    uint8_t encode_buf_{off:03x}[0x{max_end - off:x}];")
            cur = max_end
            break
        if cur < off:
            lines.append(f"    uint8_t pad_{cur:03x}[0x{off - cur:x}];")
            cur = off
        ctype = c_type_for_row(row)
        size = {"uint8_t": 1, "uint16_t": 2, "uint32_t": 4}.get(ctype, 8)
        comment_bits = []
        if row["access"]:
            comment_bits.append(f"{row['access']} size={row['sizes']} count={row['count']}")
        if row["pcs"]:
            comment_bits.append("; ".join(row["pcs"][:2]))
        if row["nested_ascii"]:
            comment_bits.append(f'ascii="{row["nested_ascii"][:64]}"')
        comment = " // " + " | ".join(comment_bits) if comment_bits else ""
        lines.append(f"    {ctype:<8} {row['name']}; /* +0x{off:03x} */{comment}")
        cur = off + size
        i += 1
    if cur < max_end:
        lines.append(f"    uint8_t pad_{cur:03x}[0x{max_end - cur:x}];")
    lines.append(f"}} {struct_name}; // observed >= 0x{max_end:x}")
    lines.append("")
    return "\n".join(lines)


def bytes_from_value(size: int, value_s: str) -> list[int]:
    if not value_s:
        return []
    value = int(value_s, 16)
    return [(value >> (8 * i)) & 0xFF for i in range(size)]


def ascii_preview(buf: bytes) -> str:
    return "".join(chr(b) if 0x20 <= b < 0x7F else "." for b in buf)


def emit_hexdump(buf: bytes, base_off: int, unknown: int = 0xCC) -> list[str]:
    lines: list[str] = []
    for rel in range(0, len(buf), 16):
        chunk = buf[rel : rel + 16]
        if not any(b != unknown for b in chunk):
            continue
        hx = " ".join(f"{b:02x}" if b != unknown else ".." for b in chunk)
        lines.append(f"`+0x{base_off + rel:03x}`  `{hx:<47}`  `{ascii_preview(chunk)}`")
    return lines


def emit_tail_timeline(ev: RegEvidence, start: int = 0x3C0, end: int | None = None) -> str:
    if end is None:
        end = max(ev.max_access_end, start)
    if end <= start:
        return ""

    writes = [
        a
        for a in ev.accesses
        if a.kind == "W" and start <= a.offset < end and a.value
    ]
    if not writes:
        return ""

    phases: list[list[Access]] = []
    cur: list[Access] = []
    for access in writes:
        # The metasec scratch buffer is reused. A libc qword write at the
        # beginning is a good practical phase boundary in current traces
        # (memset/memcpy-style refill after prior content was consumed).
        if cur and access.offset == start and access.size >= 8 and access.module == "libc.so":
            phases.append(cur)
            cur = []
        cur.append(access)
    if cur:
        phases.append(cur)

    lines = [
        f"# {ev.reg} tail timeline",
        "",
        f"- watched range: `+0x{start:x}..+0x{end:x}`",
        f"- write events: `{len(writes)}`",
        f"- phases: `{len(phases)}`",
        "",
        "This report is intentionally temporal: the same offsets may mean different things in different phases because the native code reuses the buffer.",
        "",
    ]

    total_len = end - start
    for idx, phase in enumerate(phases, 1):
        buf = bytearray([0xCC] * total_len)
        for access in phase:
            rel = access.offset - start
            data = bytes_from_value(access.size, access.value)
            for i, b in enumerate(data):
                if 0 <= rel + i < len(buf):
                    buf[rel + i] = b

        touched = [i for i, b in enumerate(buf) if b != 0xCC]
        nonzero = [i for i, b in enumerate(buf) if b not in (0x00, 0xCC)]
        pcs = Counter(a.pc_label for a in phase)
        if touched:
            touched_range = f"+0x{start + min(touched):x}..+0x{start + max(touched) + 1:x}"
        else:
            touched_range = "(none)"
        if nonzero:
            nonzero_range = f"+0x{start + min(nonzero):x}..+0x{start + max(nonzero) + 1:x}"
        else:
            nonzero_range = "(none)"

        lines.extend(
            [
                f"## phase {idx}",
                "",
                f"- event seq: `{phase[0].seq}..{phase[-1].seq}`",
                f"- events: `{len(phase)}`",
                f"- touched: `{touched_range}`",
                f"- non-zero: `{nonzero_range}`",
                "- top writers: "
                + ", ".join(f"`{pc}`({count})" for pc, count in pcs.most_common(10)),
                "",
            ]
        )
        lines.extend(emit_hexdump(bytes(buf), start))
        lines.append("")

    return "\n".join(lines)


def emit_markdown(summary: dict) -> str:
    lines = [
        f"# {summary['reg']} structure evidence",
        "",
        f"- entry address: `{summary['entry_addr']}`",
        f"- max observed access end: `{summary['max_access_end']}`",
        "",
        "| off | candidate | qword | access | pcs | nested/content hint |",
        "|---:|---|---|---|---|---|",
    ]
    for row in summary["rows"]:
        pcs = "<br>".join(row["pcs"]) if row["pcs"] else ""
        hint = row["nested_ascii"][:96].replace("|", "\\|")
        if row["sample_values"]:
            sample = ", ".join(row["sample_values"][:3])
            hint = (hint + "<br>" if hint else "") + f"sample={sample}"
        lines.append(
            f"| `+0x{row['offset']:03x}` | `{row['name']}` | `{row['qword']}` | "
            f"`{row['access']} {row['sizes']} #{row['count']}` | {pcs} | `{hint}` |"
        )
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--entry-log", action="append", default=[], type=Path)
    ap.add_argument("--trace-log", action="append", default=[], type=Path)
    ap.add_argument("--reg", action="append", default=None, help="Register to summarize; may be repeated.")
    ap.add_argument("--struct-name", default="", help="C struct name. Defaults to MetaSec_<reg>_350.")
    ap.add_argument("--out-dir", type=Path)
    args = ap.parse_args()

    regs = parse_logs(args.entry_log, args.trace_log)
    summaries = {}
    wanted_regs = args.reg or ["x0"]
    for reg in wanted_regs:
        reg = reg.lower()
        if reg not in regs:
            raise SystemExit(f"unknown reg: {reg}")
        summaries[reg] = summarize_reg(regs[reg])

    if args.out_dir:
        args.out_dir.mkdir(parents=True, exist_ok=True)
        for reg, summary in summaries.items():
            struct_name = args.struct_name or f"MetaSec_{reg}_350"
            (args.out_dir / f"{reg}_evidence.md").write_text(emit_markdown(summary), encoding="utf-8")
            (args.out_dir / f"{reg}_struct.h").write_text(emit_c_skeleton(summary, struct_name), encoding="utf-8")
            tail = emit_tail_timeline(regs[reg])
            if tail:
                (args.out_dir / f"{reg}_tail_timeline.md").write_text(tail, encoding="utf-8")
        (args.out_dir / "summary.json").write_text(json.dumps(summaries, indent=2, ensure_ascii=False), encoding="utf-8")
        print(f"wrote {args.out_dir}")
    else:
        for reg, summary in summaries.items():
            print(emit_markdown(summary))
            print(emit_c_skeleton(summary, args.struct_name or f"MetaSec_{reg}_350"))
            tail = emit_tail_timeline(regs[reg])
            if tail:
                print(tail)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
