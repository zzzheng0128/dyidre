#!/usr/bin/env python3
"""Diff true-device MS.b trace (gum_msb_trace_350101.js) against unidbg traceMsB.

Usage:
  python3 scripts/diff_msb_trace.py \
      --device runs/350101/msb_trace/msb_long01/frida_console.log \
      --unidbg ../unidbg/unidbg-android/target/sign6_350101_cf71_tls_20260904.log \
      --out-md runs/350101/msb_trace/msb_long01/msb_diff.md

Both sides emit lines like:
  [350101][MS.b] op=0x.. arg1=0x.. arg2=0x.. str=.. obj=.. => ..
Device side appends "; seq=N via=V caller=..." which is ignored for compare.
The report answers: which ops each side saw, and per (op,str,obj) whether the
return matches (null-ness, type, value).
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

LINE_RE = re.compile(
    r"\[350101\]\[MS\.b\] op=(0x[0-9a-fA-F]+) arg1=(0x[0-9a-fA-F]+) "
    r"arg2=(0x[0-9a-fA-F]+) str=(.*?) obj=(.*?) => (.*?)(?: ; seq=.*)?$"
)


def norm_op(op: str) -> str:
    return hex(int(op, 16))


def norm_class(text: str) -> str:
    # device: java/lang/String<"..."> ; unidbg: java.lang.String<"...">
    return text.replace("java/lang/", "java.lang.")


def split_value(field: str) -> tuple[str, str]:
    """Return (kind, value): null / str:<text> / obj:<ptr> / other."""
    field = norm_class(field.strip())
    if field == "null":
        return ("null", "")
    m = re.match(r"java\.lang\.String<\"(.*)\">$", field)
    if m:
        return ("str", m.group(1))
    m = re.match(r"java\.lang\.(Long|Integer)<\"(.*)\">$", field)
    if m:
        return ("num", m.group(2))
    m = re.match(r"<obj (0x[0-9a-f]+)>$", field)
    if m:
        return ("obj", m.group(1))
    m = re.match(r"\[B<byte\[(\d+)\]", field)
    if m:
        return ("bytes", m.group(1))
    return ("other", field)


def parse(path: Path, tag: str) -> list[dict]:
    rows = []
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        m = LINE_RE.search(line)
        if not m:
            continue
        op, arg1, arg2, str_f, obj_f, ret_f = m.groups()
        rows.append(
            {
                "src": tag,
                "op": norm_op(op),
                "arg1": norm_op(arg1),
                "arg2": norm_op(arg2),
                "str": split_value(str_f),
                "obj": split_value(obj_f),
                "ret": split_value(ret_f),
            }
        )
    return rows


def short(v: tuple[str, str], limit: int = 60) -> str:
    kind, val = v
    if kind == "null":
        return "null"
    if kind == "str":
        t = val if len(val) <= limit else val[:limit] + f"...<len={len(val)}>"
        return f'Str<"{t}">'
    if kind == "num":
        return f"Num<{val}>"
    if kind == "bytes":
        return f"byte[{val}]"
    if kind == "obj":
        return f"<obj {val}>"
    return f"<{kind} {val[:limit]}>"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--device", required=True, type=Path)
    ap.add_argument("--unidbg", required=True, type=Path)
    ap.add_argument("--out-md", type=Path, default=None)
    args = ap.parse_args()

    dev = parse(args.device, "device")
    uni = parse(args.unidbg, "unidbg")
    if not dev:
        print(f"[diff] no MS.b rows parsed from {args.device}", file=sys.stderr)
        return 2
    if not uni:
        print(f"[diff] no MS.b rows parsed from {args.unidbg}", file=sys.stderr)
        return 2

    dev_ops = Counter(r["op"] for r in dev)
    uni_ops = Counter(r["op"] for r in uni)

    all_ops = sorted(set(dev_ops) | set(uni_ops), key=lambda o: int(o, 16))

    # key = (op, str value)；obj 多是易变指针/key 名，str 为空时用 obj 字符串补充
    def key_of(r: dict) -> tuple:
        sv = r["str"][1] if r["str"][0] == "str" else ""
        ov = r["obj"][1] if r["obj"][0] == "str" else ""
        return (r["op"], sv, ov)

    dev_by_key: dict[tuple, list[dict]] = defaultdict(list)
    for r in dev:
        dev_by_key[key_of(r)].append(r)
    uni_by_key: dict[tuple, list[dict]] = defaultdict(list)
    for r in uni:
        uni_by_key[key_of(r)].append(r)

    def ret_summary(rows: list[dict]) -> str:
        c = Counter(short(r["ret"]) for r in rows)
        return " | ".join(f"{t} x{n}" if n > 1 else t for t, n in c.most_common(3))

    lines = []
    lines.append("# MS.b true-device vs unidbg diff")
    lines.append("")
    lines.append(f"- device: `{args.device}` ({len(dev)} calls, {len(dev_ops)} ops)")
    lines.append(f"- unidbg: `{args.unidbg}` ({len(uni)} calls, {len(uni_ops)} ops)")
    lines.append("")

    lines.append("## op 覆盖")
    lines.append("")
    lines.append("| op | device 次数 | unidbg 次数 | 覆盖 |")
    lines.append("|---|---:|---:|---|")
    for op in all_ops:
        d, u = dev_ops.get(op, 0), uni_ops.get(op, 0)
        cov = "both" if d and u else ("device-only" if d else "unidbg-only")
        mark = "" if cov == "both" else " ⚠️"
        lines.append(f"| `{op}` | {d} | {u} | {cov}{mark} |")
    lines.append("")

    lines.append("## 返回值对照（双方都有问的 op+key）")
    lines.append("")
    lines.append("| op | key(str/obj) | device 返回 | unidbg 返回 | 判定 |")
    lines.append("|---|---|---|---|---|")
    n_match = n_gap = 0
    for k in sorted(set(dev_by_key) & set(uni_by_key)):
        d_ret = ret_summary(dev_by_key[k])
        u_ret = ret_summary(uni_by_key[k])
        same = d_ret == u_ret
        # 只看 null 性与值；obj 指针不可能相同
        d_kinds = Counter(r["ret"][0] for r in dev_by_key[k])
        u_kinds = Counter(r["ret"][0] for r in uni_by_key[k])
        if not same:
            if set(d_kinds) == {"obj"} or set(u_kinds) == {"obj"}:
                verdict = "type-check"  # 一侧只拿到指针，需人工看类型
            elif set(d_kinds) != set(u_kinds):
                verdict = "KIND-DIFF ⚠️"
            else:
                verdict = "VALUE-DIFF ⚠️"
        else:
            verdict = "match"
        if verdict == "match":
            n_match += 1
        else:
            n_gap += 1
        key_desc = (k[1] or k[2])[:48] or "-"
        lines.append(f"| `{k[0]}` | `{key_desc}` | {d_ret} | {u_ret} | {verdict} |")
    lines.append("")
    lines.append(f"match={n_match} gap={n_gap}")

    only_dev = sorted(set(dev_by_key) - set(uni_by_key))
    only_uni = sorted(set(uni_by_key) - set(dev_by_key))
    if only_dev:
        lines.append("")
        lines.append("## unidbg 从未被问的 op+key（device-only）")
        lines.append("")
        for k in only_dev:
            lines.append(f"- `{k[0]}` key=`{(k[1] or k[2])[:64] or '-'}` "
                         f"device 返回 {ret_summary(dev_by_key[k])} x{len(dev_by_key[k])}")
    if only_uni:
        lines.append("")
        lines.append("## 真机没问、unidbg 被问的 op+key（unidbg-only，可能是补环境引出的差异路径）")
        lines.append("")
        for k in only_uni:
            lines.append(f"- `{k[0]}` key=`{(k[1] or k[2])[:64] or '-'}` "
                         f"unidbg 返回 {ret_summary(uni_by_key[k])} x{len(uni_by_key[k])}")

    out = "\n".join(lines) + "\n"
    if args.out_md:
        args.out_md.parent.mkdir(parents=True, exist_ok=True)
        args.out_md.write_text(out, encoding="utf-8")
        print(f"[diff] wrote {args.out_md}")
    else:
        print(out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
