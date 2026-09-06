"""一键补回 350.101 已核实的 protobuf / JSON 通用函数名称（IDA 9.3）。

在 IDA 主线程中使用 File -> Script file... 运行本文件即可应用并保存当前
数据库。也可通过 runpy 加载后调用 restore_names(dry_run=True) 只预览，
或 restore_names(save=False) 交给外层恢复器统一保存。

只处理 10 个新名称和已有的 u32 varint 名称。不恢复结构体/原型/注释，
不建立函数、不改字节、不移动函数目录、不执行其他恢复脚本。
0x10CAAC 是共享主体，特意不列入函数清单。

记录来自 2026-09-07 的 so_static_followup.md / json_static_followup.md
及 ida_proto_json_rename_hEQwHX/rename_result.json；运行时无需读取这些报告。
下列 RVA 仅用于精确哈希匹配样本的注释恢复，不是跨版本识别特征。
"""

from __future__ import annotations

from collections import Counter
import hashlib
import json
from pathlib import Path
import tempfile
from types import SimpleNamespace


EXPECTED_SHA256 = "2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76"

# RVA、已验证行为名、入口 12 字节；最后一项沿用原有名称，不统一覆盖前缀。
FUNCTIONS = (
    (0x116C10, "pb_message_unpack_by_descriptor", "fc6fbaa9fa6701a9f85f02a9"),
    (0x117E60, "pb_encode_int32_varint", "4000f8371500001408001932"),
    (0x117F3C, "pb_encode_sint64_zigzag", "08f87fd300fd80ca01000014"),
    (0x117FF8, "pb_decode_field_value", "f85fbca9f65701a9f44f02a9"),
    (0x10C570, "json_node_allocate_zeroed", "fd7bbfa9fd030091080040f9"),
    (0x10C59C, "json_parse_value", "ff8302d1fa6705a9f85f06a9"),
    (0x10DAA4, "json_parse_string", "fc6fbaa9fa6701a9f85f02a9"),
    (0x10CA44, "json_skip_space", "800200b4090040f9890100b4"),
    (0x10C2B8, "json_delete_chain", "f50f1df8f44f01a9fd7b02a9"),
    (0x10CCC8, "json_print_value", "ff8302d1e81b00fdfc6f04a9"),
    (0x117EB8, "metasec350_varint_write_u32", "1f0002718302005408001932"),
)


def _ida():
    """延迟导入；普通 Python 可加载清单/执行离线测试，但不能操作 IDB。"""
    try:
        import ida_auto
        import ida_bytes
        import ida_funcs
        import ida_ida
        import ida_idaapi
        import ida_kernwin
        import ida_loader
        import ida_name
        import ida_nalt
    except ImportError as exc:
        raise RuntimeError("请在 IDA 9.3 的 File -> Script file... 中运行本脚本") from exc
    return SimpleNamespace(
        auto=ida_auto, bytes=ida_bytes, funcs=ida_funcs, info=ida_ida,
        const=ida_idaapi, ui=ida_kernwin, loader=ida_loader,
        name=ida_name, nalt=ida_nalt,
    )


def _digest_text(value) -> str:
    """兼容原始 32 字节摘要及工具桥接返回的十六进制文本。"""
    if isinstance(value, (bytes, bytearray)):
        return bytes(value).hex() if len(value) == 32 else bytes(value).decode("ascii").strip().lower()
    return str(value or "").strip().lower()


def validate_target(api=None) -> dict:
    """只读预检；总恢复器在任何旧脚本修改 IDB 前也应调用此函数。"""
    api = api or _ida()
    if not api.auto.auto_wait():
        raise RuntimeError("IDA 自动分析尚未完成或已取消；未应用名称")
    if (not api.info.inf_is_64bit() or api.info.inf_is_be()
            or api.info.inf_get_procname().lower() not in ("arm", "aarch64")):
        raise RuntimeError("仅支持该 AArch64 / little-endian 样本；未应用名称")
    recorded = _digest_text(api.nalt.retrieve_input_file_sha256())
    if recorded != EXPECTED_SHA256:
        raise RuntimeError(f"IDB 输入 SHA-256 不匹配：{recorded!r}；未应用名称")

    input_path = api.nalt.get_input_file_path() or ""
    source = Path(input_path) if input_path else None
    disk_verified = bool(source and source.is_file())
    if disk_verified and hashlib.sha256(source.read_bytes()).hexdigest() != EXPECTED_SHA256:
        raise RuntimeError("磁盘 SO 与 IDB 记录的 SHA-256 不一致；未应用名称")
    # 源文件搬走时仍可用 IDB 记录哈希 + 下方入口字节预检，不凭文件名识别。
    return {
        "sha256": recorded,
        "input_path": input_path,
        "source_on_disk_verified": disk_verified,
        "imagebase": api.nalt.get_imagebase(),
        "idb_path": api.loader.get_path(api.loader.PATH_TYPE_IDB) or "",
    }


def _plan(api, identity: dict) -> list[dict]:
    """一次性预检全部候选，任何入口字节不符均在改名之前停止。"""
    rows = []
    for rva, desired, signature in FUNCTIONS:
        ea = identity["imagebase"] + rva
        old = api.name.get_name(ea) or ""
        row = {"rva": hex(rva), "ea": hex(ea), "old": old, "new": desired}
        func = api.funcs.get_func(ea)
        if func is None or func.start_ea != ea:
            row["status"] = "skip_not_function_entry"
        else:
            expected = bytes.fromhex(signature)
            if api.bytes.get_bytes(ea, len(expected)) != expected:
                raise RuntimeError(f"{ea:#x} 入口字节不匹配；整批未应用名称")
            if old == desired:
                row["status"] = "already_present"
            elif api.bytes.has_user_name(api.bytes.get_flags(ea)) or (
                    old and old.lower() != f"sub_{ea:x}"):
                row["status"] = "skip_existing_name"
            elif api.name.get_name_ea(api.const.BADADDR, desired) not in (api.const.BADADDR, ea):
                row["status"] = "skip_name_collision"
            else:
                row["status"] = "pending"
        rows.append(row)
    return rows


def _write_new_json(path: Path, value: dict) -> None:
    """使用独占创建保存本次记录，不覆盖历史恢复记录。"""
    with path.open("x", encoding="utf-8") as stream:
        json.dump(value, stream, ensure_ascii=False, indent=2)
        stream.write("\n")


def _refresh(api, changed: list[int]) -> list[str]:
    """刷新名称显示；Hex-Rays 不可用不影响名称本身的恢复。"""
    warnings = []
    try:
        import ida_hexrays
        for ea in changed:
            ida_hexrays.mark_cfunc_dirty(ea, False)
    except Exception as exc:
        warnings.append(f"反编译缓存未刷新：{exc}")
    try:
        api.ui.refresh_idaview_anyway()
    except Exception as exc:
        warnings.append(f"界面未刷新：{exc}")
    return warnings


def restore_names(*, dry_run: bool = False, save: bool = True, audit_dir=None) -> dict:
    """幂等补名：保留人工名称/重名冲突，实际修改前保存原名，成功后可保存 IDB。

    dry_run 不写名称、审计文件或数据库。无待补项时也不产生文件或保存动作。
    部分 set_name/保存失败会抛错并留下 result.json，不伪报整批成功，也不
    自动撤销可能与用户新修改冲突的名称。审计记录是名称备份，不是完整 IDB。
    """
    api = _ida()
    identity = validate_target(api)
    rows = _plan(api, identity)
    result = {
        "status": "dry_run" if dry_run else "no_changes",
        "identity": identity, "rows": rows, "saved": False,
        "counts": dict(Counter(row["status"] for row in rows)),
    }
    pending = [row for row in rows if row["status"] == "pending"]
    if dry_run or not pending:
        api.ui.msg(f"[proto-json-350101] {result['status']}: {result['counts']}\n")
        return result

    if not identity["idb_path"]:
        raise RuntimeError("无法确定当前 IDB 路径；未应用名称")
    root = Path(audit_dir) if audit_dir is not None else Path(identity["idb_path"]).parent / "proto_json_name_restore"
    root.mkdir(parents=True, exist_ok=True)
    run_dir = Path(tempfile.mkdtemp(prefix="run_", dir=str(root)))
    result["audit_dir"] = str(run_dir)
    result["status"] = "prepared"
    _write_new_json(run_dir / "before.json", result)
    api.ui.msg(f"[proto-json-350101] 原名称记录：{run_dir / 'before.json'}\n")

    changed = []
    try:
        for row in pending:
            ea = int(row["ea"], 16)
            # 不用 SN_FORCE/SN_MULTI：不自动加后缀、不把旧名字写成注释。
            if ((api.name.get_name(ea) or "") != row["old"]
                    or api.bytes.has_user_name(api.bytes.get_flags(ea))):
                raise RuntimeError(f"{ea:#x} 名称在预检后发生变化；停止余下项目")
            flags = api.name.SN_CHECK | api.name.SN_NOWARN | api.name.SN_NON_AUTO
            if not api.name.set_name(ea, row["new"], flags):
                row["status"] = "rename_failed"
                raise RuntimeError(f"{ea:#x} set_name 失败；停止余下项目")
            row["status"] = "renamed"
            changed.append(ea)
            if api.name.get_name(ea) != row["new"]:
                row["status"] = "verification_failed"
                raise RuntimeError(f"{ea:#x} 改名回读不一致；停止余下项目")

        result["warnings"] = _refresh(api, changed)
        if save:
            # flags=0，不使用会删除活动工作文件的 DBFL_KILL。
            if not api.loader.save_database(identity["idb_path"], 0):
                raise RuntimeError("名称已在内存中更新，但保存当前 IDB 失败")
            result["saved"] = True
        result["status"] = "applied_saved" if save else "applied_not_saved"
    except Exception as exc:
        result["status"] = "failed"
        result["error"] = str(exc)
        raise
    finally:
        result["counts"] = dict(Counter(row["status"] for row in rows))
        _write_new_json(run_dir / "result.json", result)
        api.ui.msg(f"[proto-json-350101] {result['status']}: {result['counts']}; {run_dir}\n")
    return result


if __name__ == "__main__":
    restore_names()
