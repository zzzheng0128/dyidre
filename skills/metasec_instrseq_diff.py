#!/usr/bin/env python3
import argparse
import re
from collections import deque
from pathlib import Path


GUM_RE = re.compile(r"!0x([0-9a-fA-F]+)\s+([A-Za-z0-9_.]+)\s*([^;]*)")
SEQ_RE = re.compile(r"^\s*(\d+)\s+0x([0-9a-fA-F]+)\s+(\d+)\s*$")


def parse_hex(s: str) -> int:
    s = s.strip()
    return int(s[2:] if s.lower().startswith("0x") else s, 16)


def iter_gum(path: Path):
    with path.open("r", errors="replace") as f:
        for line_no, line in enumerate(f, 1):
            m = GUM_RE.search(line)
            if not m:
                continue
            off = int(m.group(1), 16)
            mnemonic = m.group(2)
            operands = m.group(3).strip()
            yield {
                "pos": line_no,
                "off": off,
                "text": f"{mnemonic} {operands}".strip(),
                "raw": line.rstrip("\n"),
            }


def iter_seq(path: Path):
    with path.open("r", errors="replace") as f:
        for line_no, line in enumerate(f, 1):
            if line.startswith("#"):
                continue
            m = SEQ_RE.match(line)
            if not m:
                continue
            yield {
                "pos": int(m.group(1)),
                "line": line_no,
                "off": int(m.group(2), 16),
                "text": f"size={m.group(3)}",
                "raw": line.rstrip("\n"),
            }


def advance_to(it, sync_off: int, name: str):
    skipped = 0
    for ev in it:
        if ev["off"] == sync_off:
            return ev, skipped
        skipped += 1
    raise SystemExit(f"{name}: sync offset 0x{sync_off:x} not found")


def fill_window(it, first_ev, size):
    out = []
    if first_ev is not None:
        out.append(first_ev)
    while len(out) < size:
        try:
            out.append(next(it))
        except StopIteration:
            break
    return out


def find_resync(true_win, uni_win):
    uni_pos = {}
    for j, ev in enumerate(uni_win):
        uni_pos.setdefault(ev["off"], j)
    best = None
    for i, tev in enumerate(true_win):
        j = uni_pos.get(tev["off"])
        if j is None:
            continue
        score = i + j
        if best is None or score < best[0]:
            best = (score, i, j, tev["off"])
            if score == 0:
                break
    return best


def ensure_window(buf, it, size):
    while len(buf) < size:
        try:
            buf.append(next(it))
        except StopIteration:
            break


def format_ev(ev, side):
    if ev is None:
        return f"{side}: EOF"
    if side == "true":
        return f"{side}: pos={ev['pos']} off=0x{ev['off']:x} {ev['text']}"
    return f"{side}: seq={ev['pos']} off=0x{ev['off']:x} {ev['text']}"


def summarize_skipped(events, side, limit=12):
    lines = []
    for ev in events[:limit]:
        lines.append("- " + format_ev(ev, side))
    if len(events) > limit:
        lines.append(f"- ... {len(events) - limit} more")
    if not lines:
        lines.append("- none")
    return lines


def main():
    ap = argparse.ArgumentParser(description="Diff true-device GumTrace offsets against Unidbg instruction seq offsets.")
    ap.add_argument("--gum", required=True, type=Path)
    ap.add_argument("--seq", required=True, type=Path)
    ap.add_argument("--sync-offset", default="0x149cbc")
    ap.add_argument("--max-compare", type=int, default=20_000_000)
    ap.add_argument("--window", type=int, default=256)
    ap.add_argument("--context", type=int, default=16)
    ap.add_argument("--max-diffs", type=int, default=24)
    ap.add_argument("--no-resync", action="store_true")
    ap.add_argument("--out", type=Path)
    args = ap.parse_args()

    sync_off = parse_hex(args.sync_offset)
    gum_it = iter(iter_gum(args.gum))
    seq_it = iter(iter_seq(args.seq))
    gum_ev, gum_skipped = advance_to(gum_it, sync_off, "gum")
    seq_ev, seq_skipped = advance_to(seq_it, sync_off, "seq")

    recent = deque(maxlen=args.context)
    matched = 0
    diffs = []
    stopped = None

    gum_buf = deque([gum_ev])
    seq_buf = deque([seq_ev])
    while matched < args.max_compare:
        ensure_window(gum_buf, gum_it, 1)
        ensure_window(seq_buf, seq_it, 1)
        if not gum_buf or not seq_buf:
            stopped = ("eof", gum_buf[0] if gum_buf else None, seq_buf[0] if seq_buf else None)
            break

        g = gum_buf[0]
        s = seq_buf[0]
        if g["off"] == s["off"]:
            recent.append((g, s))
            matched += 1
            gum_buf.popleft()
            seq_buf.popleft()
            continue

        ensure_window(gum_buf, gum_it, args.window)
        ensure_window(seq_buf, seq_it, args.window)
        true_win = list(gum_buf)
        uni_win = list(seq_buf)
        best = find_resync(true_win, uni_win)
        diff = {
            "matched_before": matched,
            "true_current": g,
            "unidbg_current": s,
            "best": best,
            "true_window": true_win,
            "unidbg_window": uni_win,
        }
        diffs.append(diff)
        if args.no_resync or best is None or len(diffs) >= args.max_diffs:
            stopped = ("diff_limit" if len(diffs) >= args.max_diffs else "no_resync", g, s)
            break
        _, i, j, _ = best
        for _ in range(i):
            gum_buf.popleft()
        for _ in range(j):
            seq_buf.popleft()

    lines = []
    lines.append("# MetaSec instruction sequence diff")
    lines.append("")
    lines.append(f"gum={args.gum}")
    lines.append(f"seq={args.seq}")
    lines.append(f"sync_offset=0x{sync_off:x}")
    lines.append(f"gum_skipped_before_sync={gum_skipped}")
    lines.append(f"seq_skipped_before_sync={seq_skipped}")
    lines.append(f"matched_after_sync={matched}")
    lines.append(f"diffs_reported={len(diffs)}")
    if stopped:
        lines.append(f"stopped={stopped[0]}")
    lines.append("")

    lines.append("## Matched context before divergence")
    if recent:
        for idx, (g, s) in enumerate(recent, 1):
            lines.append(f"- -{len(recent)-idx+1:02d} off=0x{g['off']:x} true_pos={g['pos']} seq_pos={s['pos']} true={g['text']}")
    else:
        lines.append("- none")
    lines.append("")

    if not diffs:
        lines.append("## Result")
        lines.append(f"No mismatch in max_compare={args.max_compare}.")
    else:
        for n, diff in enumerate(diffs, 1):
            g = diff["true_current"]
            s = diff["unidbg_current"]
            best = diff["best"]
            lines.append(f"## Divergence #{n}")
            lines.append(f"matched_before={diff['matched_before']}")
            lines.append(f"- {format_ev(g, 'true')}")
            lines.append(f"- {format_ev(s, 'unidbg')}")
            if best is None:
                lines.append(f"- resync: none in window={args.window}")
                true_skip = diff["true_window"]
                uni_skip = diff["unidbg_window"]
            else:
                _, i, j, off = best
                lines.append(f"- resync: offset=0x{off:x} true_ahead={i} unidbg_ahead={j}")
                true_skip = diff["true_window"][:i]
                uni_skip = diff["unidbg_window"][:j]
            if g is not None:
                lines.append(f"- true_raw: `{g['raw'][:220]}`")
            if s is not None:
                lines.append(f"- unidbg_raw: `{s['raw'][:220]}`")
            lines.append("")
            lines.append("True-device skipped before resync:")
            lines.extend(summarize_skipped(true_skip, "true", args.context))
            lines.append("")
            lines.append("Unidbg skipped before resync:")
            lines.extend(summarize_skipped(uni_skip, "unidbg", args.context))
            lines.append("")

    text = "\n".join(lines) + "\n"
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text)
    print(text)


if __name__ == "__main__":
    main()
