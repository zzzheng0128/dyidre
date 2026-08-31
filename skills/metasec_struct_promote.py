#!/usr/bin/env python3
"""
Promote evidence from metasec_struct_infer.py into a practical next-action report.

This script does not pretend to know the final SDK layout.  It classifies each
observed offset into:

  - stable_field: narrow scalar/pointer access outside reusable buffers
  - ref_pair: adjacent pointer/refcnt-style qword pair
  - embedded_candidate: a pointer/object start that should be explored as a sub-struct
  - scratch_buffer: temporal buffer region; inspect timeline, do not name as scalar fields
  - weak_hint: entry-only content or one-off access that needs more evidence

Typical usage:

  python3 dyidre/skills/metasec_struct_promote.py \
    --summary dyidre/versions/350101/summary.json \
    --reg x0 \
    --out dyidre/versions/350101/x0_promote_plan.md
"""

from __future__ import annotations

import argparse
import json
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path


SCRATCH_START = 0x3C0
SCRATCH_SPLIT = 0x460
SCRATCH_END = 0x500

KNOWN_STATIC_OVERLAY = {
    0x1E0: (
        "embedded_candidate",
        "static+runtime overlay: registry_find_type(type=2) returns ctx+0x1e0; 0x14a0ec reads op2.ops here",
    ),
    0x248: (
        "ref_pair",
        "second half of shared_ref pair at ctx+0x240/+0x248; written by 0x47c84 and cleared by 0x4ac04",
    ),
    0x258: (
        "stable_field",
        "static+runtime overlay: op2+0x78 rwlock_holder read at 0x74028; top-level ctx offset is 0x258",
    ),
}


@dataclass
class Row:
    offset: int
    name: str
    qword: str
    access: str
    sizes: str
    count: int
    pcs: list[str]
    sample_values: list[str]
    nested_ascii: str

    @classmethod
    def from_json(cls, row: dict) -> "Row":
        return cls(
            offset=int(row["offset"]),
            name=row.get("name", ""),
            qword=row.get("qword", ""),
            access=row.get("access", ""),
            sizes=row.get("sizes", ""),
            count=int(row.get("count", 0)),
            pcs=list(row.get("pcs", [])),
            sample_values=list(row.get("sample_values", [])),
            nested_ascii=row.get("nested_ascii", ""),
        )

    @property
    def size_set(self) -> set[int]:
        return {int(x) for x in self.sizes.split(",") if x}

    @property
    def has_pointerish_qword(self) -> bool:
        if not self.qword:
            return False
        try:
            value = int(self.qword, 16)
        except ValueError:
            return False
        return value > 0x10000


def pc_addr(pc_label: str) -> str:
    """Return lib-relative pc from a label like 'libmetasec_ml.so+0x14a0ec (1)'."""
    left = pc_label.split()[0]
    if "+" not in left:
        return left
    return left.rsplit("+", 1)[1]


def classify(row: Row, rows_by_off: dict[int, Row], reg: str) -> tuple[str, str]:
    if reg == "x0" and row.offset in KNOWN_STATIC_OVERLAY:
        return KNOWN_STATIC_OVERLAY[row.offset]

    if SCRATCH_START <= row.offset < SCRATCH_END:
        if row.offset < SCRATCH_SPLIT:
            return "scratch_buffer", "ctx+0x3c0..0x45f: TLV/env/text scratch; inspect timeline by phase"
        return "scratch_buffer", "ctx+0x460..0x4ff: transform/output bytes; copied by 0x138560 in current trace"

    if row.offset % 8 == 0:
        nxt = rows_by_off.get(row.offset + 8)
        if nxt and ("W" in row.access or "R" in row.access) and ("W" in nxt.access or "R" in nxt.access):
            if any("0x47c" in p or "0x4ac" in p or "0x479" in p for p in row.pcs + nxt.pcs):
                return "ref_pair", "adjacent {obj, refcnt} pair; confirm through shared_ref helpers"

    if row.count >= 2 and row.size_set <= {1, 2, 4, 8}:
        return "stable_field", "runtime read/write evidence exists; safe to name if static use matches"

    if row.has_pointerish_qword and row.nested_ascii:
        return "embedded_candidate", "entry content points to nested object/string; needs read/write watch on target object"

    if row.has_pointerish_qword:
        return "embedded_candidate", "pointer-like qword; identify constructor/init writes or registry payload before naming"

    return "weak_hint", "not enough evidence yet; keep as pad/unknown"


def load_summary(path: Path, reg: str) -> dict:
    data = json.loads(path.read_text(encoding="utf-8"))
    if reg not in data:
        raise SystemExit(f"{path} has no register {reg}; available={sorted(data)}")
    return data[reg]


def emit_report(summary: dict) -> str:
    rows = [Row.from_json(r) for r in summary["rows"]]
    rows_by_off = {r.offset: r for r in rows}

    by_class: dict[str, list[tuple[Row, str]]] = defaultdict(list)
    pc_counter: Counter[str] = Counter()
    offset_to_pc: dict[int, list[str]] = {}

    for row in rows:
        cls, reason = classify(row, rows_by_off, summary["reg"])
        by_class[cls].append((row, reason))
        offset_to_pc[row.offset] = row.pcs
        for pc in row.pcs:
            pc_counter[pc.split(" (", 1)[0]] += 1

    lines = [
        f"# {summary['reg']} struct promotion plan",
        "",
        f"- entry address: `{summary.get('entry_addr', '')}`",
        f"- max observed access end: `{summary.get('max_access_end', '')}`",
        "",
        "## 怎么用这份报告",
        "",
        "1. `stable_field/ref_pair` 可以优先写进结构体草稿。",
        "2. `embedded_candidate` 不要直接命名最终字段，先对它指向的对象再跑一轮 entry dump / read-write trace。",
        "3. `scratch_buffer` 只按时间线理解，不按单个 offset 命名。",
        "4. 如果同一 offset 的 writer/reader PC 能在 IDA 里解释为锁、引用计数、copy、varint，再升级成强字段。",
        "",
        "## PC 热点",
        "",
    ]

    for pc, count in pc_counter.most_common(20):
        lines.append(f"- `{pc}`: touches `{count}` observed offsets")

    lines.extend(["", "## 字段候选", ""])

    order = ["ref_pair", "stable_field", "embedded_candidate", "scratch_buffer", "weak_hint"]
    for cls in order:
        items = by_class.get(cls, [])
        if not items:
            continue
        if cls == "scratch_buffer":
            scratch_ranges = [
                (SCRATCH_START, SCRATCH_SPLIT, "env_tlv_scratch_3c0", "TLV/env/text scratch; see x0_tail_timeline.md"),
                (SCRATCH_SPLIT, SCRATCH_END, "transform_out_460", "transform/output bytes; byte-copy hot loop at libmetasec_ml.so+0x138560"),
            ]
            lines.extend([f"### {cls}", "", "| range | proposed field | writes | top pcs | reason |", "|---:|---|---:|---|---|"])
            for start, end, name, reason in scratch_ranges:
                range_rows = [row for row, _reason in items if start <= row.offset < end]
                if not range_rows:
                    continue
                pcs = Counter()
                writes = 0
                for row in range_rows:
                    writes += row.count
                    for pc in row.pcs:
                        pcs[pc.split(" (", 1)[0]] += 1
                top = "<br>".join(f"{pc} ({count})" for pc, count in pcs.most_common(5))
                lines.append(f"| `+0x{start:03x}..+0x{end:03x}` | `{name}[0x{end-start:x}]` | `{writes}` | {top} | {reason} |")
            lines.append("")
            continue
        lines.extend([f"### {cls}", "", "| off | current name | access | pcs | reason / content |", "|---:|---|---|---|---|"])
        for row, reason in items:
            pcs = "<br>".join(row.pcs[:4])
            hint = row.nested_ascii or ", ".join(row.sample_values[:3])
            if len(hint) > 96:
                hint = hint[:93] + "..."
            lines.append(
                f"| `+0x{row.offset:03x}` | `{row.name}` | `{row.access} {row.sizes} #{row.count}` | "
                f"{pcs} | {reason}"
                + (f"<br>`{hint}`" if hint else "")
                + " |"
            )
        lines.append("")

    lines.extend(
        [
            "## 下一轮 trace 建议",
            "",
            "- 对 `ctx->registry` 指向对象做 watch：目标是固定 `fun_mutex` 和 `risk_items/tree head` 的真实 offset。",
            "- 对 `MetaSecRegistryEntry350.payload` 返回的对象逐 type 记录：比如 type=2 已确认是 `ctx+0x1e0`。",
            "- 对 `ctx+0x10/0x18/0x20/...` 指向的 `MetaSecNode350` 单独跑 nested dump，确认 node 里 length/string/ref 的布局。",
            "- 对 `ctx+0x3c0..0x500` 继续看 timeline，不要作为固定字段拆碎。",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--summary", type=Path, required=True)
    ap.add_argument("--reg", default="x0")
    ap.add_argument("--out", type=Path)
    args = ap.parse_args()

    summary = load_summary(args.summary, args.reg.lower())
    text = emit_report(summary)
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text, encoding="utf-8")
        print(f"wrote {args.out}")
    else:
        print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
