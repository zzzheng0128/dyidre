#!/usr/bin/env python3
"""Summarize eCapture TLS text output for dyidre.

输入可以是一个 run 目录，也可以是单个 log 文件。脚本会抽取：

- eCapture HTTP/HTTP2 request/response 事件数量；
- HTTP/2 pseudo headers，例如 :method / :path / :authority；
- 常见 X-* 签名头，例如 X-Argus / X-Gorgon / X-Khronos / X-Medusa；
- 可疑启动失败行，例如 BPF / uprobe / permission / version not found。

这个脚本不试图完整替代 Wireshark/tshark，它只负责把“能不能抓到、
抓到了哪些关键字段”做成版本迭代时能快速比对的摘要。
"""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter, defaultdict
from pathlib import Path
from typing import Iterable


ANSI_RE = re.compile(r"\x1b\[[0-9;]*m")
EVENT_RE = re.compile(r"Name:(HTTP2?Request|HTTP2?Response|HTTPRequest|HTTPResponse)")
HEADER_RE = re.compile(r'header field "([^"]+)" = "(.*)"')
RAW_HEADER_RE = re.compile(r"^([A-Za-z0-9_:+.-]+):\s*(.*)$")
REQUEST_LINE_RE = re.compile(r"^(GET|POST|PUT|DELETE|PATCH|HEAD|OPTIONS)\s+(\S+)")
TLS_IO_PATTERNS = [
    # 老格式：
    #   PID:22470 TID:22625 Comm:ChromiumNet0 FD:3073551840 WRITE (17 bytes):
    re.compile(
        r"PID:(?P<pid>\d+).*?TID:(?P<tid>\d+).*?Comm:(?P<comm>\S+)\s+"
        r"FD:(?P<fd>\d+)\s+(?P<direction>READ|WRITE)\s+\((?P<size>\d+)\s+bytes(?:,\s*hex)?\):"
    ),
    # 新格式：
    #   PID:29467, Comm:ChromiumNet0, TID:29709, FD:3073655232 WRITE (134 bytes, hex):
    re.compile(
        r"PID:(?P<pid>\d+),\s*Comm:(?P<comm>[^,]+),\s*TID:(?P<tid>\d+),\s*"
        r"FD:(?P<fd>\d+)\s+(?P<direction>READ|WRITE)\s+\((?P<size>\d+)\s+bytes(?:,\s*hex)?\):"
    ),
]
X_HEADER_NAMES = {
    "x-argus",
    "x-gorgon",
    "x-khronos",
    "x-ladon",
    "x-medusa",
    "x-helios",
    "x-soter",
    "x-ss-stub",
    "x-ss-req-ticket",
    "x-tt-token",
    "x-tt-dt",
}
RISK_WORDS = (
    "permission denied",
    "operation not permitted",
    "bpf",
    "btf",
    "uprobe",
    "uretprobe",
    "version not found",
    "failed",
    "fatal",
    "error",
)


def strip_ansi(s: str) -> str:
    return ANSI_RE.sub("", s)


def read_logs(target: Path) -> list[tuple[str, str]]:
    files: list[Path]
    if target.is_dir():
        names = [
            "ecapture_events.log",
            "ecapture_console.log",
            "ecapture_runtime.log",
            "ecapture_console.head.log",
        ]
        files = [target / name for name in names if (target / name).exists()]
    else:
        files = [target]
    out: list[tuple[str, str]] = []
    for path in files:
        try:
            text = strip_ansi(path.read_text(encoding="utf-8", errors="replace"))
        except OSError:
            continue
        out.append((path.name, text))
    return out


def iter_lines(logs: Iterable[tuple[str, str]]) -> Iterable[tuple[str, int, str]]:
    for name, text in logs:
        for no, line in enumerate(text.splitlines(), 1):
            yield name, no, line.rstrip("\n")


def shorten(value: str, limit: int = 240) -> str:
    value = value.replace("\t", " ").strip()
    if len(value) <= limit:
        return value
    return value[: limit - 3] + "..."


def match_tls_io(line: str) -> re.Match[str] | None:
    for pat in TLS_IO_PATTERNS:
        m = pat.search(line)
        if m:
            return m
    return None


def summarize(target: Path) -> dict:
    logs = read_logs(target)
    counters: Counter[str] = Counter()
    headers: dict[str, list[dict]] = defaultdict(list)
    paths: list[dict] = []
    authorities: list[dict] = []
    x_headers: list[dict] = []
    tls_io: list[dict] = []
    tls_io_bytes: Counter[str] = Counter()
    risk_lines: list[dict] = []

    for source, line_no, line in iter_lines(logs):
        for event_name in EVENT_RE.findall(line):
            counters[event_name] += 1

        req = REQUEST_LINE_RE.search(line)
        if req:
            paths.append(
                {
                    "source": source,
                    "line": line_no,
                    "method": req.group(1),
                    "path": shorten(req.group(2)),
                }
            )

        tls_io_match = match_tls_io(line)
        if tls_io_match:
            direction = tls_io_match.group("direction")
            size = int(tls_io_match.group("size"))
            counters[f"TLS_{direction}"] += 1
            tls_io_bytes[direction] += size
            if len(tls_io) < 120:
                tls_io.append(
                    {
                        "source": source,
                        "line": line_no,
                        "pid": tls_io_match.group("pid"),
                        "tid": tls_io_match.group("tid"),
                        "comm": tls_io_match.group("comm"),
                        "fd": tls_io_match.group("fd"),
                        "direction": direction,
                        "size": size,
                    }
                )

        header_match = HEADER_RE.search(line)
        if header_match:
            key = header_match.group(1).strip()
            value = header_match.group(2)
        else:
            raw = RAW_HEADER_RE.search(line.strip())
            if raw:
                key = raw.group(1).strip()
                value = raw.group(2)
            else:
                key = ""
                value = ""

        if key:
            lower_key = key.lower()
            row = {
                "source": source,
                "line": line_no,
                "key": key,
                "value": shorten(value),
            }
            if lower_key in (":path", "path"):
                paths.append(row)
            if lower_key in (":authority", "host", "authority"):
                authorities.append(row)
            if lower_key in X_HEADER_NAMES or lower_key.startswith("x-"):
                x_headers.append(row)
            headers[lower_key].append(row)

        low = line.lower()
        if any(word in low for word in RISK_WORDS):
            # 正常日志里也会出现 “BTF bytecode mode” 这类行，所以只截前 80 条，
            # 交给人快速判断是否是真失败。
            if len(risk_lines) < 80:
                risk_lines.append({"source": source, "line": line_no, "text": shorten(line, 320)})

    return {
        "target": str(target),
        "events": dict(counters),
        "paths": paths[:80],
        "authorities": authorities[:80],
        "x_headers": x_headers[:120],
        "tls_io": tls_io,
        "tls_io_bytes": dict(tls_io_bytes),
        "interesting_header_keys": sorted(headers.keys()),
        "risk_lines": risk_lines,
    }


def write_markdown(summary: dict, out: Path) -> None:
    lines: list[str] = []
    lines.append("# eCapture TLS summary")
    lines.append("")
    lines.append(f"source: `{summary['target']}`")
    lines.append("")

    lines.append("## 事件数量")
    lines.append("")
    if summary["events"]:
        lines.append("| event | count |")
        lines.append("|---|---:|")
        for key, value in sorted(summary["events"].items()):
            lines.append(f"| `{key}` | {value} |")
    else:
        lines.append("没有识别到 `HTTPRequest/HTTP2Request/HTTPResponse/HTTP2Response` 事件。")
    lines.append("")

    def table(title: str, rows: list[dict], value_name: str = "value") -> None:
        lines.append(f"## {title}")
        lines.append("")
        if not rows:
            lines.append("无。")
            lines.append("")
            return
        lines.append("| source:line | key | value |")
        lines.append("|---|---|---|")
        for row in rows:
            loc = f"{row.get('source')}:{row.get('line')}"
            key = row.get("key") or row.get("method") or ""
            value = row.get(value_name) or row.get("path") or ""
            value = str(value).replace("|", "\\|")
            lines.append(f"| `{loc}` | `{key}` | `{value}` |")
        lines.append("")

    table("请求 path / request line", summary["paths"])
    table("host / :authority", summary["authorities"])
    table("X-* 关键 header", summary["x_headers"])

    lines.append("## TLS READ/WRITE 帧")
    lines.append("")
    if summary["tls_io"]:
        lines.append("| source:line | pid/tid | comm | fd | dir | bytes |")
        lines.append("|---|---|---|---:|---|---:|")
        for row in summary["tls_io"]:
            loc = f"{row.get('source')}:{row.get('line')}"
            pid_tid = f"{row.get('pid')}/{row.get('tid')}"
            lines.append(
                f"| `{loc}` | `{pid_tid}` | `{row.get('comm')}` | "
                f"{row.get('fd')} | `{row.get('direction')}` | {row.get('size')} |"
            )
        lines.append("")
        if summary["tls_io_bytes"]:
            lines.append("| dir | total bytes |")
            lines.append("|---|---:|")
            for key, value in sorted(summary["tls_io_bytes"].items()):
                lines.append(f"| `{key}` | {value} |")
            lines.append("")
    else:
        lines.append("没有识别到 eCapture `READ/WRITE (N bytes)` TLS 明文帧。")
        lines.append("")

    lines.append("## 可能失败/告警行")
    lines.append("")
    if summary["risk_lines"]:
        lines.append("| source:line | text |")
        lines.append("|---|---|")
        for row in summary["risk_lines"]:
            text = str(row["text"]).replace("|", "\\|")
            lines.append(f"| `{row['source']}:{row['line']}` | `{text}` |")
    else:
        lines.append("无明显失败行。")
    lines.append("")

    out.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("target", help="eCapture run directory or log file")
    parser.add_argument("--out-md", help="markdown output path")
    parser.add_argument("--out-json", help="json output path")
    args = parser.parse_args()

    target = Path(args.target)
    summary = summarize(target)

    if target.is_dir():
        out_md = Path(args.out_md) if args.out_md else target / "ecapture_summary.md"
        out_json = Path(args.out_json) if args.out_json else target / "ecapture_summary.json"
    else:
        out_md = Path(args.out_md) if args.out_md else target.with_suffix(target.suffix + ".summary.md")
        out_json = Path(args.out_json) if args.out_json else target.with_suffix(target.suffix + ".summary.json")

    write_markdown(summary, out_md)
    out_json.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"[summarize-ecapture] wrote {out_md}")
    print(f"[summarize-ecapture] wrote {out_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
