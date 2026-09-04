#!/usr/bin/env python3
"""Summarize an eCapture pcap/pcapng file for TCP/TLS vs UDP/QUIC checks.

用途：
  eCapture pcap 模式产物一般交给 Wireshark/tshark 配合 keylog 解密。
  但版本迭代时，我们经常只需要先回答两个问题：

  1. 这份样本有没有 UDP/443，也就是是否可能包含 QUIC/HTTP3；
  2. 这份样本主要是不是 TCP/443 TLS。

本脚本只依赖系统 tcpdump，不解析 TLS/HTTP payload；它是快速体检工具。
真正解 HTTP/2 header，优先使用：
  - text 模式 + scripts/decode_ecapture_http2.py；
  - 或 Wireshark/tshark + keylog.log + capture.pcapng。
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
from collections import Counter
from pathlib import Path


TCP_LINE_RE = re.compile(r": Flags ")
PORT_RE_TEMPLATE = r"(?:\.{port}\s*>|>\s*[^:]+\.{port}:)"


def run_tcpdump(pcap: Path) -> list[str]:
    tcpdump = shutil.which("tcpdump")
    if not tcpdump:
        raise RuntimeError("tcpdump not found in PATH")
    proc = subprocess.run(
        [tcpdump, "-nn", "-r", str(pcap)],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        errors="replace",
        check=False,
    )
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr.strip() or f"tcpdump failed: {proc.returncode}")
    return proc.stdout.splitlines()


def has_port(line: str, port: int) -> bool:
    return re.search(PORT_RE_TEMPLATE.format(port=port), line) is not None


def summarize_lines(lines: list[str]) -> dict:
    counts: Counter[str] = Counter()
    endpoints: Counter[str] = Counter()
    samples: list[str] = []

    for line in lines:
        if " IP " in line:
            counts["ip4"] += 1
        if " IP6 " in line:
            counts["ip6"] += 1

        is_tcp = TCP_LINE_RE.search(line) is not None
        is_udp = " UDP," in line or re.search(r"\.\d+\s*>\s*[^:]+\.\d+:\s+UDP,", line) is not None
        if is_tcp:
            counts["tcp"] += 1
            if has_port(line, 443):
                counts["tcp443"] += 1
        if is_udp:
            counts["udp"] += 1
            if has_port(line, 443):
                counts["udp443"] += 1

        # 抽 endpoint：形如 "IP a.b.c.d.123 > x.y.z.w.443:"
        m = re.search(r"\bIP6?\s+([^ ]+)\s+>\s+([^:]+):", line)
        if m:
            endpoints[f"{m.group(1)} > {m.group(2)}"] += 1

        if len(samples) < 20:
            samples.append(line)

    quic_candidate = counts["udp443"] > 0
    http3_candidate = quic_candidate

    stable_counts = {key: counts.get(key, 0) for key in ["ip4", "ip6", "tcp", "udp", "tcp443", "udp443"]}

    return {
        "counts": stable_counts,
        "quic_candidate": quic_candidate,
        "http3_candidate": http3_candidate,
        "dominant_transport": "tcp443" if counts["tcp443"] >= counts["udp443"] else "udp443",
        "top_endpoints": [{"endpoint": k, "count": v} for k, v in endpoints.most_common(30)],
        "samples": samples,
    }


def write_md(summary: dict, pcap: Path, out: Path) -> None:
    c = summary["counts"]
    lines: list[str] = []
    lines.append("# eCapture pcap summary")
    lines.append("")
    lines.append(f"source: `{pcap}`")
    lines.append("")
    lines.append("## 结论")
    lines.append("")
    if summary["quic_candidate"]:
        lines.append("- 发现 `UDP/443`，这份样本可能包含 QUIC/HTTP3，需要用 QUIC/TLS3 keylog 路线继续解析。")
    else:
        lines.append("- 未发现 `UDP/443`；这份 pcap 里没有明显 QUIC/HTTP3 流量。")
    lines.append(f"- 主路径：`{summary['dominant_transport']}`")
    lines.append("")
    lines.append("## 协议计数")
    lines.append("")
    lines.append("| item | count |")
    lines.append("|---|---:|")
    for key in ["ip4", "ip6", "tcp", "udp", "tcp443", "udp443"]:
        lines.append(f"| `{key}` | {c.get(key, 0)} |")
    lines.append("")
    lines.append("## Top endpoints")
    lines.append("")
    if summary["top_endpoints"]:
        lines.append("| endpoint | count |")
        lines.append("|---|---:|")
        for row in summary["top_endpoints"]:
            lines.append(f"| `{row['endpoint']}` | {row['count']} |")
    else:
        lines.append("无。")
    lines.append("")
    lines.append("## tcpdump samples")
    lines.append("")
    lines.append("```text")
    lines.extend(summary["samples"])
    lines.append("```")
    lines.append("")
    out.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pcap", help="capture.pcapng / capture.pcap")
    parser.add_argument("--out-md", help="markdown output path")
    parser.add_argument("--out-json", help="json output path")
    args = parser.parse_args()

    pcap = Path(args.pcap)
    lines = run_tcpdump(pcap)
    summary = summarize_lines(lines)

    out_md = Path(args.out_md) if args.out_md else pcap.with_suffix(pcap.suffix + ".summary.md")
    out_json = Path(args.out_json) if args.out_json else pcap.with_suffix(pcap.suffix + ".summary.json")
    write_md(summary, pcap, out_md)
    out_json.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"[summarize-ecapture-pcap] wrote {out_md}")
    print(f"[summarize-ecapture-pcap] wrote {out_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
