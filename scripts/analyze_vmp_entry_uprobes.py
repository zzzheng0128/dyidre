#!/usr/bin/env python3
"""Normalize stackplz exeVMInner entry events into version-relative evidence.

This parser intentionally stops at entry-level facts.  Its opt-in 350.101
check can close an already-recovered wrapper ABI from PC/LR/SP/X0..X4, but it
does not infer VM instruction semantics, handler identities, control flow, or
opcode coverage.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import re
import sys
from collections import Counter
from pathlib import Path
from typing import Any


REG_RE = re.compile(r"\b(x(?:[12]?\d|30)|lr|sp|pc)=(0x[0-9a-fA-F]+)")
PROJECT_DIR = Path(__file__).resolve().parents[1]
NATIVE_VMP_RUNTIME_350 = (
    PROJECT_DIR / "versions" / "350101" / "vm_generic_350101" / "native_vmp_runtime.py"
)


def auto_int(value: str) -> int:
    return int(value, 0)


def hex0(value: int) -> str:
    return f"0x{value:x}"


def parse_address(value: Any) -> int | None:
    if isinstance(value, int):
        return value
    if isinstance(value, str):
        try:
            return int(value, 0)
        except ValueError:
            return None
    return None


def parse_registers(stack: str) -> dict[str, int]:
    return {name: int(value, 16) for name, value in REG_RE.findall(stack)}


def load_native_vmp_runtime_350() -> Any:
    """Load the local, version-isolated manifest only for opt-in validation."""
    module_name = "dyidre_native_vmp_runtime_350"
    existing = sys.modules.get(module_name)
    if existing is not None:
        return existing
    spec = importlib.util.spec_from_file_location(module_name, NATIVE_VMP_RUNTIME_350)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load native VMP runtime: {NATIVE_VMP_RUNTIME_350}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[module_name] = module
    spec.loader.exec_module(module)
    return module


def collect(
    log_path: Path,
    entry_offset: int,
    *,
    validate_known_wrapper_abi_350: bool = False,
) -> dict[str, Any]:
    parseable_json = 0
    rejected: Counter[str] = Counter()
    records: list[dict[str, Any]] = []
    runtime = load_native_vmp_runtime_350() if validate_known_wrapper_abi_350 else None
    closed_wrapper_counts: Counter[str] = Counter()
    unclosed_entry_pairs: Counter[tuple[int, int]] = Counter()
    invalid_register_records: Counter[str] = Counter()

    for line_number, line in enumerate(log_path.read_text(errors="replace").splitlines(), 1):
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        parseable_json += 1
        if event.get("event") != "uprobe":
            rejected["not_uprobe"] += 1
            continue

        probe_offset = parse_address(event.get("arg_name"))
        if probe_offset is not None and probe_offset != entry_offset:
            rejected["different_probe_offset"] += 1
            continue

        registers = parse_registers(str(event.get("stack_str", "")))
        top_pc = parse_address(event.get("pc"))
        top_lr = parse_address(event.get("lr"))
        top_sp = parse_address(event.get("sp"))
        pc = top_pc if top_pc is not None else registers.get("pc")
        lr = top_lr if top_lr is not None else registers.get("lr")
        vm_code = registers.get("x0")
        if pc is None or lr is None or vm_code is None:
            rejected["missing_pc_lr_or_x0"] += 1
            if runtime is not None:
                invalid_register_records["missing_pc_lr_or_x0"] += 1
            continue
        if top_pc is not None and registers.get("pc") not in (None, top_pc):
            rejected["pc_field_register_mismatch"] += 1
            if runtime is not None:
                invalid_register_records["pc_field_register_mismatch"] += 1
            continue
        if top_lr is not None and registers.get("lr") not in (None, top_lr):
            rejected["lr_field_register_mismatch"] += 1
            if runtime is not None:
                invalid_register_records["lr_field_register_mismatch"] += 1
            continue

        module_base = pc - entry_offset
        if runtime is not None:
            stack_sp = registers.get("sp")
            if top_sp is not None and stack_sp not in (None, top_sp):
                invalid_register_records["sp_field_register_mismatch"] += 1
            else:
                try:
                    runtime.resolve_native_vmp_wrapper_abi_350(
                        entry_offset, vm_code - module_base, lr - module_base
                    )
                except runtime.UnknownNativeVmpWrapperAbi:
                    # An entry-only pair remains a valid raw entry observation,
                    # not a malformed ABI record.  Keep it outside the closed
                    # count until its complete wrapper contract is recovered.
                    unclosed_entry_pairs[(vm_code - module_base, lr - module_base)] += 1
                else:
                    required_registers = ("pc", "lr", "sp", "x0", "x1", "x2", "x3", "x4")
                    missing = [name for name in required_registers if name not in registers]
                    if missing:
                        invalid_register_records[
                            "missing_stack_registers:" + ",".join(missing)
                        ] += 1
                    else:
                        snapshot = runtime.NativeVmpEntryRegisters350(
                            pc=pc,
                            lr=lr,
                            sp=stack_sp,
                            x0=registers["x0"],
                            x1=registers["x1"],
                            x2=registers["x2"],
                            x3=registers["x3"],
                            x4=registers["x4"],
                        )
                        try:
                            observation = runtime.resolve_native_vmp_entry_observation_350(snapshot)
                        except runtime.UnknownNativeVmpEntryObservation:
                            invalid_register_records["closed_wrapper_register_shape_mismatch"] += 1
                        else:
                            closed_wrapper_counts[observation.abi.name] += 1
        records.append(
            {
                "line": line_number,
                "pid": event.get("pid"),
                "tid": event.get("tid"),
                "comm": event.get("comm"),
                "ts": event.get("ts"),
                "pc": pc,
                "lr": lr,
                "vm_code": vm_code,
                "module_base": module_base,
                "entry_offset_observed": pc - module_base,
                "vm_code_offset": vm_code - module_base,
                "caller_offset": lr - module_base,
            }
        )

    if not records:
        raise ValueError("no usable uprobe events with PC, LR, and X0")

    bases = Counter(record["module_base"] for record in records)
    pairs = Counter(
        (record["vm_code_offset"], record["caller_offset"])
        for record in records
    )
    vm_codes = Counter(record["vm_code_offset"] for record in records)
    callers = Counter(record["caller_offset"] for record in records)
    threads = Counter(str(record["comm"] or "") for record in records)

    summary: dict[str, Any] = {
        "schema": "dyidre.metasec.vmp-entry-uprobe-summary.v1",
        "source_log": str(log_path),
        "entry_offset": hex0(entry_offset),
        "parseable_json_lines": parseable_json,
        "accepted_events": len(records),
        "rejected_events": dict(sorted(rejected.items())),
        "module_base_consistent": len(bases) == 1,
        "module_bases": [
            {"base": hex0(base), "count": count}
            for base, count in bases.most_common()
        ],
        "vm_code_offsets": [
            {"offset": hex0(offset), "count": count}
            for offset, count in vm_codes.most_common()
        ],
        "caller_offsets": [
            {"offset": hex0(offset), "count": count}
            for offset, count in callers.most_common()
        ],
        "vm_code_caller_pairs": [
            {
                "vm_code_offset": hex0(vm_code),
                "caller_offset": hex0(caller),
                "count": count,
            }
            for (vm_code, caller), count in pairs.most_common()
        ],
        "thread_names": [
            {"comm": comm, "count": count} for comm, count in threads.most_common()
        ],
        "first_event": {
            key: hex0(value) if key in {"pc", "lr", "vm_code", "module_base", "entry_offset_observed", "vm_code_offset", "caller_offset"} else value
            for key, value in records[0].items()
        },
        "evidence_boundary": {
            "proves": [
                "the probed native entry was reached",
                "the entry-time X0 vmCode value and LR caller can be normalized to module offsets",
                "observed vmCode/caller frequency and pairing in this capture",
            ],
            "does_not_prove": [
                "VM program length or reachability",
                "opcode or handler semantics",
                "complete opcode coverage",
                "equivalence in another MetaSec build",
            ],
        },
    }
    if runtime is not None:
        summary["known_wrapper_abi_validation_350"] = {
            "enabled": True,
            "closed_wrapper_events": sum(closed_wrapper_counts.values()),
            "closed_wrapper_counts": [
                {"name": name, "count": count}
                for name, count in sorted(closed_wrapper_counts.items())
            ],
            "unclosed_entry_events": sum(unclosed_entry_pairs.values()),
            "unclosed_entry_pairs": [
                {
                    "vm_code_offset": hex0(vm_code),
                    "caller_offset": hex0(caller),
                    "count": count,
                }
                for (vm_code, caller), count in unclosed_entry_pairs.most_common()
            ],
            "invalid_register_events": sum(invalid_register_records.values()),
            "invalid_register_records": dict(sorted(invalid_register_records.items())),
            "proves": [
                "each counted closed event satisfies all PC/LR/X0/X2/X3 module-relative and X1/X4 stack-relative relations of one canonical wrapper ABI",
            ],
            "does_not_prove": [
                "pParam memory contents or lifecycle",
                "funBridge callback targets or behavior",
                "VMP output values or program semantics",
            ],
        }
    return summary


def markdown(summary: dict[str, Any]) -> str:
    lines = [
        "# stackplz native VMP entry summary",
        "",
        f"- source: `{summary['source_log']}`",
        f"- entry offset: `{summary['entry_offset']}`",
        f"- accepted events: {summary['accepted_events']}",
        f"- one consistent module base: `{str(summary['module_base_consistent']).lower()}`",
        "",
        "| vmCode offset | caller LR offset | count |",
        "|---:|---:|---:|",
    ]
    for row in summary["vm_code_caller_pairs"]:
        lines.append(
            f"| `{row['vm_code_offset']}` | `{row['caller_offset']}` | {row['count']} |"
        )
    validation = summary.get("known_wrapper_abi_validation_350")
    if isinstance(validation, dict):
        lines.extend(
            [
                "",
                "## Opt-in closed-wrapper ABI validation",
                "",
                f"- closed wrapper events: {validation['closed_wrapper_events']}",
                f"- unclosed entry events: {validation['unclosed_entry_events']}",
                f"- invalid register events: {validation['invalid_register_events']}",
                "",
            ]
        )
        if validation["closed_wrapper_counts"]:
            lines.extend(["| closed wrapper | count |", "|---|---:|"])
            for row in validation["closed_wrapper_counts"]:
                lines.append(f"| `{row['name']}` | {row['count']} |")
    lines.extend(
        [
            "",
            "This table is entry-level evidence only. It is not opcode coverage and does not assign handler semantics.",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("log", type=Path, help="stackplz JSON-lines log")
    parser.add_argument(
        "--entry-offset",
        type=auto_int,
        default=0x4CC10,
        help="module-relative exeVMInner entry offset (default: 0x4cc10)",
    )
    parser.add_argument("--json-out", type=Path)
    parser.add_argument("--markdown-out", type=Path)
    parser.add_argument(
        "--validate-known-wrapper-abi-350",
        action="store_true",
        help=(
            "opt in to the local 350.101 manifest check over full PC/LR/SP/X0..X4 "
            "entry snapshots; requires --entry-offset 0x4cc10"
        ),
    )
    parser.add_argument(
        "--print-format", choices=("json", "markdown", "none"), default="json"
    )
    args = parser.parse_args()

    if args.validate_known_wrapper_abi_350 and args.entry_offset != 0x4CC10:
        parser.error("--validate-known-wrapper-abi-350 requires --entry-offset 0x4cc10")
    try:
        summary = collect(
            args.log,
            args.entry_offset,
            validate_known_wrapper_abi_350=args.validate_known_wrapper_abi_350,
        )
    except (OSError, RuntimeError, ValueError) as exc:
        parser.error(str(exc))

    json_text = json.dumps(summary, ensure_ascii=False, indent=2) + "\n"
    markdown_text = markdown(summary)
    if args.json_out:
        args.json_out.write_text(json_text)
    if args.markdown_out:
        args.markdown_out.write_text(markdown_text)
    if args.print_format == "json":
        sys.stdout.write(json_text)
    elif args.print_format == "markdown":
        sys.stdout.write(markdown_text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
