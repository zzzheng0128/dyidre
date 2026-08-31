#!/usr/bin/env python3
"""
Run the 350.101 MetaSec unidbg demo twice with fixed runtime state and verify
that all emitted X-* headers are byte-stable.

This is the reproducibility gate before comparing recovered C code against the
native unidbg oracle.  The important fix is `metasec.fixedPid`: without it,
X-Medusa observes the host JVM pid through pid/tid-like environment state and
changes between Maven processes even when time/random are fixed.
"""

from __future__ import annotations

import hashlib
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
UNIDBG = ROOT / "unidbg"
TARGET = UNIDBG / "unidbg-android" / "target"
OUT_DIR = ROOT / "dyidre" / "versions/350101"

HEADER_KEYS = [
    "X-Argus",
    "X-Gorgon",
    "X-Helios",
    "X-Khronos",
    "X-Ladon",
    "X-Medusa",
    "X-Soter",
]

COMMON_MAVEN_ARGS = [
    "./mvnw",
    "-pl",
    "unidbg-android",
    "-am",
    "-DfailIfNoTests=false",
    "-Dmaven.test.skip=false",
    "-Dtest=Sign6_350101#testMetasec",
    "-Dmetasec.deterministic=true",
    "-Dmetasec.fixedPid=12345",
    "-Dmetasec.fixedCurrentTimeMillis=1788136882000",
    "-Dmetasec.fixedElapsedRealtime=123456789",
    "-Dmetasec.fixedElapsedRealtimeNanos=123456789000000",
    "-Dmetasec.fixedMonotonicNanos=123456789000000",
    "-Dmetasec.fixedRandomSeed=0x350101",
    "-Dmetasec.traceDeterministicRandom=true",
    "test",
]


def run_once(index: int) -> Path:
    TARGET.mkdir(parents=True, exist_ok=True)
    log_path = TARGET / f"sign6_350101_deterministic_verify_run{index}.log"
    with log_path.open("wb") as fp:
        result = subprocess.run(
            COMMON_MAVEN_ARGS,
            cwd=UNIDBG,
            stdout=fp,
            stderr=subprocess.STDOUT,
            check=False,
        )
    if result.returncode != 0:
        raise SystemExit(f"run{index} failed: {log_path}")
    return log_path


def parse_headers(path: Path) -> dict[str, str]:
    lines = path.read_text(errors="replace").splitlines()
    headers: dict[str, str] = {}
    for i, line in enumerate(lines[:-1]):
        key = line.strip()
        if key in HEADER_KEYS:
            headers[key] = lines[i + 1].strip()
    missing = [key for key in HEADER_KEYS if key not in headers]
    if missing:
        raise SystemExit(f"{path}: missing headers: {missing}")
    return headers


def interesting_trace_lines(path: Path) -> list[str]:
    out: list[str] = []
    for line in path.read_text(errors="replace").splitlines():
        if (
            "deterministic=true" in line
            or "deterministic libc PRNG" in line
            or "[metasec-random]" in line
            or "[metasec-libc-prng]" in line
        ):
            out.append(line)
    return out


def write_report(logs: list[Path], headers: list[dict[str, str]]) -> Path:
    report = OUT_DIR / "deterministic_verify_350101.latest.md"
    raw_medusa_b64 = headers[0]["X-Medusa"]
    same_all = all(headers[0][key] == headers[1][key] for key in HEADER_KEYS)

    lines: list[str] = []
    lines.append("# 350.101 deterministic unidbg verification")
    lines.append("")
    lines.append(f"- run1: `{logs[0]}`")
    lines.append(f"- run2: `{logs[1]}`")
    lines.append(f"- all headers stable: `{same_all}`")
    lines.append("")
    lines.append("## Header stability")
    lines.append("")
    lines.append("| header | len | sha1 | same |")
    lines.append("|---|---:|---|---|")
    for key in HEADER_KEYS:
        v1 = headers[0][key]
        v2 = headers[1][key]
        lines.append(
            f"| `{key}` | `{len(v1)}` | `{hashlib.sha1(v1.encode()).hexdigest()}` | `{v1 == v2}` |"
        )
    lines.append("")
    lines.append("## Random/PRNG trace")
    for log in logs:
        lines.append("")
        lines.append(f"### {log.name}")
        lines.append("")
        lines.append("```text")
        lines.extend(interesting_trace_lines(log))
        lines.append("```")
    lines.append("")
    lines.append("## Stable X-Medusa")
    lines.append("")
    lines.append(f"- length: `{len(raw_medusa_b64)}`")
    lines.append(f"- sha1: `{hashlib.sha1(raw_medusa_b64.encode()).hexdigest()}`")
    lines.append("")
    report.write_text("\n".join(lines), encoding="utf-8")
    return report


def main() -> int:
    logs = [run_once(1), run_once(2)]
    headers = [parse_headers(path) for path in logs]
    same_all = all(headers[0][key] == headers[1][key] for key in HEADER_KEYS)
    report = write_report(logs, headers)
    for key in HEADER_KEYS:
        value = headers[0][key]
        print(f"{key:10s} same={headers[0][key] == headers[1][key]} len={len(value)} sha1={hashlib.sha1(value.encode()).hexdigest()}")
    print(f"report={report}")
    return 0 if same_all else 1


if __name__ == "__main__":
    sys.exit(main())
