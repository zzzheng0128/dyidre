#!/usr/bin/env python3
"""
Compare real-device and unidbg metasec entry dumps structurally.

Raw pointer values are expected to differ, so this script normalizes nested
qword bytes into a coarse shape:

  Z = zero
  P = pointer-like value
  S = small scalar
  A = printable ASCII chunk

This is meant for answering "are these two runs structurally the same?" before
spending time on exact values.
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass, field
from pathlib import Path


ENTRY_RE = re.compile(r"\[entry-dump\]\s+(x[0-8])=0x([0-9a-fA-F]+)")
QWORD_RE = re.compile(r"\+0x([0-9a-fA-F]+)=0x([0-9a-fA-F]+)")
QWORDS_LINE_RE = re.compile(r"\[entry-dump\]\s+(x[0-8])\s+qwords\s+(.+)")
NESTED_RE = re.compile(
    r"\[entry-dump\]\s+(x[0-8])\.q([0-9]+)\s+->\s+0x([0-9a-fA-F]+).*?"
    r"hex=([0-9a-fA-F ]+).*?ascii=\"([^\"]*)\""
)


@dataclass
class Nested:
    ptr: int
    data: bytes
    ascii: str


@dataclass
class RegDump:
    addr: int | None = None
    qwords: dict[int, int] = field(default_factory=dict)
    nested: dict[int, Nested] = field(default_factory=dict)


def parse_entrydump(path: Path) -> dict[str, RegDump]:
    regs = {f"x{i}": RegDump() for i in range(9)}
    for line in path.read_text(errors="replace").splitlines():
        m = ENTRY_RE.search(line)
        if m:
            regs[m.group(1)].addr = int(m.group(2), 16)
            continue

        m = QWORDS_LINE_RE.search(line)
        if m:
            reg, rest = m.group(1), m.group(2)
            for off_s, value_s in QWORD_RE.findall(rest):
                regs[reg].qwords[int(off_s, 16)] = int(value_s, 16)
            continue

        m = NESTED_RE.search(line)
        if m:
            reg, qidx_s, ptr_s, hex_s, ascii_s = m.groups()
            data = bytes(int(x, 16) for x in hex_s.split())
            regs[reg].nested[int(qidx_s)] = Nested(int(ptr_s, 16), data, ascii_s)
    return regs


def printable_ratio(chunk: bytes) -> float:
    if not chunk:
        return 0.0
    return sum(1 for b in chunk if 0x20 <= b < 0x7F) / len(chunk)


def classify_qword(chunk: bytes) -> str:
    if len(chunk) < 8:
        return "?"
    value = int.from_bytes(chunk, "little")
    if value == 0:
        return "Z"
    if printable_ratio(chunk) >= 0.75:
        preview = "".join(chr(b) if 0x20 <= b < 0x7F else "." for b in chunk)
        return f"A:{preview}"
    if value < 0x100000:
        return f"S:{value:x}"
    return "P"


def shape(data: bytes) -> str:
    return " ".join(classify_qword(data[i : i + 8]) for i in range(0, min(len(data), 0x40), 8))


def short_ascii(s: str, limit: int = 48) -> str:
    s = s.replace("|", "\\|")
    return s if len(s) <= limit else s[: limit - 3] + "..."


def emit_compare(left: dict[str, RegDump], right: dict[str, RegDump], reg: str, left_name: str, right_name: str) -> str:
    l = left[reg]
    r = right[reg]
    lines = [
        f"# entrydump structural compare: {reg}",
        "",
        f"- {left_name} {reg}: `{hex(l.addr) if l.addr else ''}`",
        f"- {right_name} {reg}: `{hex(r.addr) if r.addr else ''}`",
        "",
        "| off/q | top class | nested shape same | "
        f"{left_name} nested shape | {right_name} nested shape | ascii hint |",
        "|---:|---|---|---|---|---|",
    ]

    offsets = sorted(set(l.qwords) | set(r.qwords))
    for off in offsets:
        qidx = off // 8
        lv = l.qwords.get(off)
        rv = r.qwords.get(off)
        ln = l.nested.get(qidx)
        rn = r.nested.get(qidx)
        lshape = shape(ln.data) if ln else ""
        rshape = shape(rn.data) if rn else ""
        same = "yes" if lshape and lshape == rshape else ("partial" if ln and rn else "no")
        top_class = (
            ("P" if lv and lv > 0x10000 else "Z/S")
            + "/"
            + ("P" if rv and rv > 0x10000 else "Z/S")
        )
        hint = ""
        if ln or rn:
            hint = f"{left_name}: `{short_ascii(ln.ascii) if ln else ''}`<br>{right_name}: `{short_ascii(rn.ascii) if rn else ''}`"
        lines.append(
            f"| `+0x{off:02x}/q{qidx}` | `{top_class}` | `{same}` | "
            f"`{lshape}` | `{rshape}` | {hint} |"
        )
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--left", type=Path, required=True)
    ap.add_argument("--right", type=Path, required=True)
    ap.add_argument("--reg", action="append", default=None)
    ap.add_argument("--left-name", default="real")
    ap.add_argument("--right-name", default="unidbg")
    ap.add_argument("--out", type=Path)
    args = ap.parse_args()

    left = parse_entrydump(args.left)
    right = parse_entrydump(args.right)
    regs = args.reg or ["x0"]
    text = "\n".join(emit_compare(left, right, reg, args.left_name, args.right_name) for reg in regs)
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text, encoding="utf-8")
        print(f"wrote {args.out}")
    else:
        print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
