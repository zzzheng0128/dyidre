#!/usr/bin/env python3
"""Index dyidre true-device run folders.

This script is intentionally boring and deterministic: it does not parse or
transform the heavy trace payload.  Its job is to keep the handoff layer clean:

  runs/<version>/true_env_xmedusa/<run_id>/

For each run it records which files exist, whether a summary is present, and
whether the run is complete enough to serve as a baseline.  The real evidence
stays in the run folder; the generated RUNS.md/runs_manifest.json are just an
index for humans and upgrade scripts.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


def sizeof_tree(path: Path) -> int:
    total = 0
    for item in path.rglob("*"):
        if item.is_file():
            total += item.stat().st_size
    return total


def human_size(size: int) -> str:
    units = ["B", "KB", "MB", "GB"]
    value = float(size)
    for unit in units:
        if value < 1024.0 or unit == units[-1]:
            if unit == "B":
                return f"{int(value)}B"
            return f"{value:.1f}{unit}"
        value /= 1024.0
    return f"{size}B"


def load_json(path: Path) -> dict[str, Any] | None:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return None


def count_xmedusa_events(summary: dict[str, Any] | None) -> int:
    if not summary:
        return 0
    for key in ("xmedusa_events", "xmedusa"):
        value = summary.get(key)
        if isinstance(value, list):
            return len(value)
    return 0


def count_legacy_prefix(summary: dict[str, Any] | None, prefix: str, suffix: str) -> int:
    if not summary:
        return 0
    return sum(1 for key in summary if key.startswith(prefix) and key.endswith(suffix))


def classify_run(path: Path, summary: dict[str, Any] | None, files: list[str]) -> tuple[str, str]:
    has_console = "rustfrida_console.log" in files
    has_log = any(name.startswith("true_env_xmedusa_") and name.endswith(".log") for name in files)
    has_summary = summary is not None
    has_snapshot = "metasec_app_files_snapshot.tar" in files
    has_manifest = "rootfs_app_files_manifest.json" in files
    has_pack = any(name.startswith("f8_pack_raw70_event_") for name in files)
    has_emit = any(name.startswith("xmedusa_emit_event_") for name in files)
    has_last_f8 = any(name.startswith("xmedusa_lastF8_event_") for name in files)

    if has_summary and has_snapshot and has_manifest and has_pack and has_emit and has_last_f8:
        return "baseline-ready", "完整 true-env / F8 / emit / app-files 快照；可作为 unidbg 环境同步基准。"
    if has_summary and count_xmedusa_events(summary) > 0:
        return "usable-history", "有 summary 和 X-Medusa 事件，但采集字段少于当前基准；适合回看演进。"
    if has_log and has_console:
        return "partial", "有 RF console 和原始 true-env log，但没有抽取 summary；不能直接当基准。"
    if has_console:
        return "failed-bootstrap", "只留下 RF console，属于注入/启动早期失败证据。"
    return "unknown", "文件不符合 true-env 批次约定，需要人工检查。"


def summarize_one(path: Path) -> dict[str, Any]:
    files = sorted(item.name for item in path.iterdir() if item.is_file())
    summary_path = path / "true_env_xmedusa_summary.json"
    summary = load_json(summary_path) if summary_path.exists() else None
    status, note = classify_run(path, summary, files)

    rootfs = None
    http_entries = 0
    f8_entries = 0
    extracted_files = 0
    if summary:
        rootfs = summary.get("rootfs_snapshot")
        http_entries_value = summary.get("http_entries")
        f8_entries_value = summary.get("f8_entries")
        extracted_value = summary.get("extracted_files")
        if isinstance(http_entries_value, list):
            http_entries = len(http_entries_value)
        else:
            http_entries = count_legacy_prefix(summary, "http_entry", "_regs")
        if isinstance(f8_entries_value, list):
            f8_entries = len(f8_entries_value)
        else:
            f8_entries = count_legacy_prefix(summary, "f8_enter", "_regs")
        if isinstance(extracted_value, list):
            extracted_files = len(extracted_value)

    return {
        "run_id": path.name,
        "path": str(path),
        "status": status,
        "note": note,
        "file_count": len(files),
        "size_bytes": sizeof_tree(path),
        "size_human": human_size(sizeof_tree(path)),
        "has_console": "rustfrida_console.log" in files,
        "has_raw_log": any(name.startswith("true_env_xmedusa_") and name.endswith(".log") for name in files),
        "has_summary": summary is not None,
        "xmedusa_events": count_xmedusa_events(summary),
        "http_entries": http_entries,
        "f8_entries": f8_entries,
        "extracted_files": extracted_files,
        "rootfs_snapshot": rootfs,
        "files": files,
    }


def build_manifest(run_root: Path) -> dict[str, Any]:
    version = run_root.parent.name if run_root.parent.name else "unknown"
    run_kind = run_root.name
    latest_link = run_root / "latest"
    latest = latest_link.readlink().as_posix() if latest_link.is_symlink() else None

    runs = [
        summarize_one(path)
        for path in sorted(run_root.iterdir())
        if path.is_dir() and path.name != "latest"
    ]

    return {
        "schema": "dyidre.true_env_runs.v1",
        "version": version,
        "run_kind": run_kind,
        "run_root": str(run_root),
        "latest": latest,
        "runs": runs,
    }


def write_markdown(manifest: dict[str, Any], out: Path) -> None:
    lines: list[str] = []
    version = manifest["version"]
    run_kind = manifest["run_kind"]
    latest = manifest.get("latest") or "未设置"
    lines.append(f"# {version} {run_kind} 批次索引")
    lines.append("")
    lines.append("这个文件由 `scripts/index_true_env_runs.py` 生成。")
    lines.append("它只做索引，不替代原始证据；真实日志、bin、b64、tar 仍以各 run 目录为准。")
    lines.append("")
    lines.append(f"- 当前版本：`{version}`")
    lines.append(f"- 采集类型：`{run_kind}`")
    lines.append(f"- latest：`{latest}`")
    lines.append("")
    lines.append("## 批次状态")
    lines.append("")
    lines.append("| run_id | 状态 | 文件数 | 大小 | http | F8 | X-Medusa | 说明 |")
    lines.append("|---|---|---:|---:|---:|---:|---:|---|")
    for run in manifest["runs"]:
        lines.append(
            "| `{run_id}` | `{status}` | {file_count} | {size_human} | {http_entries} | {f8_entries} | {xmedusa_events} | {note} |".format(
                **run
            )
        )
    lines.append("")
    lines.append("## 文件来源约定")
    lines.append("")
    lines.append("| 文件 | 谁生成 | 作用 |")
    lines.append("|---|---|---|")
    lines.append("| `rustfrida_console.log` | `run_metasec_probe_<version>.sh true-env ...` 的 host tee | RF spawn/attach 输出，判断注入是否卡住或崩溃。 |")
    lines.append("| `true_env_xmedusa_<version>.log` | `metasec_probe_<version>.js mode=true-env` 写到 App 私有目录后由 host 拉回 | 原始真机事件流，是所有后处理的源头。 |")
    lines.append("| `true_env_xmedusa_summary.json` | `scripts/extract_true_env_xmedusa.py` 从原始 log 归一化 | 机器可读摘要，喂给 unidbg baseline 和差异分析。 |")
    lines.append("| `metasec_app_files_snapshot.tar` | true-env 后处理 | App 私有文件快照，用于同步 `.msdata`、`.msf3_*` 等环境状态。 |")
    lines.append("| `rootfs_app_files_manifest.json` | true-env 后处理 | 记录哪些 App 文件进入 unidbg rootfs。 |")
    lines.append("| `f8_*` / `xmedusa_*` | `scripts/extract_true_env_xmedusa.py` | F8 入参、token、stub、lastF8、emit bytes/b64，专门追 `X-Medusa` 值级差异。 |")
    lines.append("")
    lines.append("## 判断规则")
    lines.append("")
    lines.append("- `baseline-ready`：能作为后续版本对齐的真机基准。")
    lines.append("- `usable-history`：有价值，但字段不全，只做历史对照。")
    lines.append("- `partial`：只有原始日志，不能直接用于 unidbg。")
    lines.append("- `failed-bootstrap`：注入/启动失败证据，保留用于排查 RF 稳定性。")
    lines.append("")
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--root",
        type=Path,
        default=Path("runs/350101/true_env_xmedusa"),
        help="run root, usually runs/<version>/true_env_xmedusa",
    )
    parser.add_argument("--out-json", type=Path, help="write machine-readable manifest")
    parser.add_argument("--out-md", type=Path, help="write markdown index")
    args = parser.parse_args()

    manifest = build_manifest(args.root)
    if args.out_json:
        args.out_json.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    if args.out_md:
        write_markdown(manifest, args.out_md)
    if not args.out_json and not args.out_md:
        print(json.dumps(manifest, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
