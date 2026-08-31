#!/usr/bin/env python3
"""Extract X-Medusa true-env artifacts from a raw rustFrida log.

Input directory convention:

  runs/<version>/true_env_xmedusa/<run_id>/
    true_env_xmedusa_<version>.log

Generated artifacts:

  true_env_xmedusa_summary.json
  f8_pack_raw70_event_XX.bin
  f8_x_ss_stub_event_XX.bin
  f8_url_or_path_event_XX.txt
  f8_aux_ref_mem_event_XX.bin
  f8_token_block_event_XX.bin/.txt
  xmedusa_lastF8_event_XX.b64/.raw.bin
  xmedusa_emit_event_XX.b64/.raw.bin

The script only extracts data already present in the raw log.  It does not
create app file snapshots; those still come from the device-side/host-side
environment sync step.
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import json
import re
from pathlib import Path
from typing import Any


PREFIX = "[true-env-xmedusa] "
HEX_RE = re.compile(r"^[0-9a-fA-F ]+$")
REGS_RE = re.compile(r"^(?P<label>HTTP\.entry|F8\.enter|XMedusa\.emit)#(?P<idx>\d+) off=(?P<off>0x[0-9a-fA-F]+) regs (?P<regs>.*)$")
ENV_RE = re.compile(r"^(?P<label>script\.start|install|HTTP\.entry#\d+|F8\.enter#\d+|XMedusa\.emit#\d+) env (?P<body>.*)$")
CLOCK_RE = re.compile(r"^(?P<label>script\.start|install|HTTP\.entry#\d+|F8\.enter#\d+|XMedusa\.emit#\d+) clock\.(?P<clock>[A-Z_]+) (?P<body>.*)$")
MODULE_RE = re.compile(r"^install module=(?P<name>\S+) base=(?P<base>0x[0-9a-fA-F]+) size=(?P<size>0x[0-9a-fA-F]+) path=(?P<path>.*)$")
GETRANDOM_RE = re.compile(r"^getrandom ret=(?P<ret>-?\d+) requested=(?P<requested>0x[0-9a-fA-F]+) first=(?P<first>[0-9a-fA-F ]*) fnv1a=(?P<fnv1a>[0-9a-fA-F]+)$")
F8_PACK_RE = re.compile(
    r"^F8\.pack ptr=(?P<ptr>0x[0-9a-fA-F]+).*? "
    r"seed=(?P<seed>0x[0-9a-fA-F]+) type=(?P<type>-?\d+) "
    r"mode=(?P<mode>-?\d+) final=(?P<final>-?\d+) "
    r"out_key_ptr_ptr=(?P<out_key_ptr_ptr>0x[0-9a-fA-F]+) "
    r"out_value_ptr_ptr=(?P<out_value_ptr_ptr>0x[0-9a-fA-F]+) "
    r"qwords=\[(?P<qwords>.*)\]$"
)
F8_PACK_RAW_RE = re.compile(r"^F8\.pack\.raw70 .*? hex=(?P<hex>[0-9a-fA-F ]+)$")
BODY_HEX_RE = re.compile(r"^(?P<label>F8\.in\.(?:x_ss_stub|aux_ref_mem|token_block)|XMedusa\.emit\.(?:key|value)) body_hex=(?P<hex>[0-9a-fA-F ]+)(?: \.\.\.<hex truncated>)?$")
BODY_ASCII_RE = re.compile(r"^(?P<label>F8\.in\.(?:url_or_path|token_block)|XMedusa\.(?:lastF8\.out_value|emit\.value)) .*? ascii=\"(?P<ascii>.*)\"$")
B64_RE = re.compile(r"^(?P<label>XMedusa\.(?:lastF8\.out_value|emit\.value))\.b64_full=(?P<b64>.+)$")


def parse_kv_words(text: str) -> dict[str, str]:
    out: dict[str, str] = {}
    for part in text.split():
        if "=" not in part:
            continue
        key, value = part.split("=", 1)
        out[key] = value
    return out


def parse_line(line: str) -> tuple[int | None, str] | None:
    if not line.startswith(PREFIX):
        return None
    rest = line[len(PREFIX) :].rstrip("\n\r")
    if " " not in rest:
        return None
    ts, payload = rest.split(" ", 1)
    try:
        return int(ts), payload
    except ValueError:
        return None


def decode_hex(text: str) -> bytes:
    clean = " ".join(text.strip().split())
    if not clean:
        return b""
    if not HEX_RE.match(clean):
        raise ValueError(f"not hex bytes: {text[:80]}")
    return bytes(int(part, 16) for part in clean.split())


def decode_b64(text: str) -> bytes:
    clean = "".join(text.strip().split())
    pad = "=" * ((4 - len(clean) % 4) % 4)
    return base64.b64decode(clean + pad)


def sha1(data: bytes) -> str:
    return hashlib.sha1(data).hexdigest()


def maybe_write(path: Path, data: bytes | str, force: bool, dry_run: bool) -> bool:
    if path.exists() and not force:
        return False
    if dry_run:
        return True
    if isinstance(data, str):
        path.write_text(data, encoding="utf-8")
    else:
        path.write_bytes(data)
    return True


def event_file(run_dir: Path, stem: str, idx: int, suffix: str) -> Path:
    return run_dir / f"{stem}_event_{idx:02d}{suffix}"


def extract(run_dir: Path, version: str, force: bool, dry_run: bool) -> dict[str, Any]:
    raw_log = run_dir / f"true_env_xmedusa_{version}.log"
    if not raw_log.exists():
        raise FileNotFoundError(raw_log)

    summary: dict[str, Any] = {
        "schema": "dyidre.true_env_xmedusa.extract.v1",
        "run_id": run_dir.name,
        "version": version,
        "source_log": str(raw_log),
        "module": None,
        "script_env": None,
        "install_env": None,
        "clocks": {},
        "http_entries": [],
        "f8_entries": [],
        "xmedusa_events": [],
        "getrandom_events": [],
        "extracted_files": [],
    }

    f8_by_idx: dict[int, dict[str, Any]] = {}
    emit_by_idx: dict[int, dict[str, Any]] = {}
    current_f8 = 0
    current_emit = 0

    def record_file(path: Path, kind: str, idx: int, data: bytes | str) -> None:
        wrote = maybe_write(path, data, force=force, dry_run=dry_run)
        summary["extracted_files"].append(
            {
                "kind": kind,
                "event": idx,
                "path": str(path),
                "size": len(data.encode("utf-8") if isinstance(data, str) else data),
                "wrote": wrote,
                "dry_run": dry_run,
            }
        )

    for line in raw_log.read_text(encoding="utf-8", errors="replace").splitlines():
        parsed = parse_line(line)
        if parsed is None:
            continue
        ts_ms, payload = parsed

        if payload == "script start":
            summary["script_start_ms"] = ts_ms
            continue

        m = MODULE_RE.match(payload)
        if m:
            summary["module"] = {
                "name": m.group("name"),
                "base": m.group("base"),
                "size": m.group("size"),
                "path": m.group("path"),
            }
            continue

        m = ENV_RE.match(payload)
        if m:
            label = m.group("label")
            env = parse_kv_words(m.group("body"))
            if label == "script.start":
                summary["script_env"] = env
            elif label == "install":
                summary["install_env"] = env
            else:
                summary.setdefault("event_env", {})[label] = env
            continue

        m = CLOCK_RE.match(payload)
        if m:
            label = m.group("label")
            clock = m.group("clock")
            summary["clocks"].setdefault(label, {})[clock] = parse_kv_words(m.group("body"))
            continue

        m = GETRANDOM_RE.match(payload)
        if m:
            summary["getrandom_events"].append(
                {
                    "ts_ms": ts_ms,
                    "ret": int(m.group("ret")),
                    "requested": m.group("requested"),
                    "first_hex": m.group("first"),
                    "fnv1a": m.group("fnv1a"),
                }
            )
            continue

        m = REGS_RE.match(payload)
        if m:
            label = m.group("label")
            idx = int(m.group("idx"))
            row = {
                "event": idx,
                "ts_ms": ts_ms,
                "off": m.group("off"),
                "regs": parse_kv_words(m.group("regs")),
            }
            if label == "HTTP.entry":
                summary["http_entries"].append(row)
            elif label == "F8.enter":
                current_f8 = idx
                f8_by_idx.setdefault(idx, row).update(row)
                if row not in summary["f8_entries"]:
                    summary["f8_entries"].append(f8_by_idx[idx])
            elif label == "XMedusa.emit":
                current_emit = idx
                emit_by_idx.setdefault(idx, row).update(row)
                if row not in summary["xmedusa_events"]:
                    summary["xmedusa_events"].append(emit_by_idx[idx])
            continue

        m = F8_PACK_RE.match(payload)
        if m and current_f8:
            f8_by_idx.setdefault(current_f8, {"event": current_f8})
            f8_by_idx[current_f8]["pack"] = {
                "ts_ms": ts_ms,
                "ptr": m.group("ptr"),
                "seed": m.group("seed"),
                "type": int(m.group("type")),
                "mode": int(m.group("mode")),
                "final": int(m.group("final")),
                "out_key_ptr_ptr": m.group("out_key_ptr_ptr"),
                "out_value_ptr_ptr": m.group("out_value_ptr_ptr"),
                "qwords": m.group("qwords"),
            }
            continue

        m = F8_PACK_RAW_RE.match(payload)
        if m and current_f8:
            data = decode_hex(m.group("hex"))
            path = event_file(run_dir, "f8_pack_raw70", current_f8, ".bin")
            record_file(path, "f8_pack_raw70", current_f8, data)
            f8_by_idx.setdefault(current_f8, {"event": current_f8})["pack_raw70"] = {
                "path": str(path),
                "size": len(data),
                "sha1": sha1(data),
            }
            continue

        m = BODY_HEX_RE.match(payload)
        if m:
            label = m.group("label")
            data = decode_hex(m.group("hex"))
            if label == "F8.in.x_ss_stub" and current_f8:
                path = event_file(run_dir, "f8_x_ss_stub", current_f8, ".bin")
                record_file(path, "f8_x_ss_stub", current_f8, data)
                f8_by_idx.setdefault(current_f8, {"event": current_f8})["x_ss_stub"] = {
                    "path": str(path),
                    "size": len(data),
                    "sha1": sha1(data),
                }
            elif label == "F8.in.aux_ref_mem" and current_f8:
                path = event_file(run_dir, "f8_aux_ref_mem", current_f8, ".bin")
                record_file(path, "f8_aux_ref_mem", current_f8, data)
                f8_by_idx.setdefault(current_f8, {"event": current_f8})["aux_ref_mem"] = {
                    "path": str(path),
                    "size": len(data),
                    "sha1": sha1(data),
                }
            elif label == "F8.in.token_block" and current_f8:
                path = event_file(run_dir, "f8_token_block", current_f8, ".bin")
                record_file(path, "f8_token_block_bin", current_f8, data)
                f8_by_idx.setdefault(current_f8, {"event": current_f8})["token_block_bin"] = {
                    "path": str(path),
                    "size": len(data),
                    "sha1": sha1(data),
                }
            continue

        m = BODY_ASCII_RE.match(payload)
        if m:
            label = m.group("label")
            text = m.group("ascii")
            if label == "F8.in.url_or_path" and current_f8:
                path = event_file(run_dir, "f8_url_or_path", current_f8, ".txt")
                record_file(path, "f8_url_or_path", current_f8, text)
                f8_by_idx.setdefault(current_f8, {"event": current_f8})["url_or_path"] = {
                    "path": str(path),
                    "chars": len(text),
                    "sha1": sha1(text.encode("utf-8")),
                }
            elif label == "F8.in.token_block" and current_f8:
                path = event_file(run_dir, "f8_token_block", current_f8, ".txt")
                record_file(path, "f8_token_block_text", current_f8, text)
                f8_by_idx.setdefault(current_f8, {"event": current_f8})["token_block_text"] = {
                    "path": str(path),
                    "chars": len(text),
                    "sha1": sha1(text.encode("utf-8")),
                }
            continue

        m = B64_RE.match(payload)
        if m and current_emit:
            label = m.group("label")
            b64 = m.group("b64").strip()
            raw = decode_b64(b64)
            if label == "XMedusa.lastF8.out_value":
                b64_path = event_file(run_dir, "xmedusa_lastF8", current_emit, ".b64")
                raw_path = event_file(run_dir, "xmedusa_lastF8", current_emit, ".raw.bin")
                kind = "xmedusa_lastF8"
                target = "lastF8"
            else:
                b64_path = event_file(run_dir, "xmedusa_emit", current_emit, ".b64")
                raw_path = event_file(run_dir, "xmedusa_emit", current_emit, ".raw.bin")
                kind = "xmedusa_emit"
                target = "emit"
            record_file(b64_path, kind + "_b64", current_emit, b64 + "\n")
            record_file(raw_path, kind + "_raw", current_emit, raw)
            emit_by_idx.setdefault(current_emit, {"event": current_emit})[target] = {
                "b64_path": str(b64_path),
                "raw_path": str(raw_path),
                "b64_len": len(b64),
                "raw_len": len(raw),
                "raw_sha1": sha1(raw),
                "decoded_b18": raw[0x18] if len(raw) > 0x18 else None,
            }
            continue

    summary["counts"] = {
        "http_entries": len(summary["http_entries"]),
        "f8_entries": len(summary["f8_entries"]),
        "xmedusa_events": len(summary["xmedusa_events"]),
        "getrandom_events": len(summary["getrandom_events"]),
        "extracted_files": len(summary["extracted_files"]),
    }

    summary_path = run_dir / "true_env_xmedusa_summary.json"
    if not dry_run:
        if force or not summary_path.exists():
            summary_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        else:
            summary["summary_write_skipped"] = str(summary_path)
    return summary


def infer_version(run_dir: Path, explicit: str | None) -> str:
    if explicit:
        return explicit
    try:
        version = run_dir.parents[1].name
        if version.isdigit():
            return version
    except Exception:
        pass
    for path in run_dir.glob("true_env_xmedusa_*.log"):
        return path.stem.removeprefix("true_env_xmedusa_")
    raise ValueError("cannot infer version; pass --version")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("run_dir", type=Path, help="runs/<version>/true_env_xmedusa/<run_id>")
    parser.add_argument("--version", help="version id, inferred from run path when omitted")
    parser.add_argument("--force", action="store_true", help="overwrite existing extracted files and summary")
    parser.add_argument("--dry-run", action="store_true", help="parse and report, do not write")
    args = parser.parse_args()

    version = infer_version(args.run_dir, args.version)
    summary = extract(args.run_dir, version, force=args.force, dry_run=args.dry_run)
    print(
        json.dumps(
            {
                "run_id": summary["run_id"],
                "version": summary["version"],
                "dry_run": args.dry_run,
                "counts": summary["counts"],
                "summary_write_skipped": summary.get("summary_write_skipped"),
            },
            ensure_ascii=False,
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
