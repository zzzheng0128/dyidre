#!/usr/bin/env python3
"""build_rehydrate_dyidre.py — 由 dyidre_enrich_snapshot.json 生成自包含恢复脚本。

产物：dyidre/skills/ida_apply_dyidre_enrich_9_3.py
  - 内嵌 zlib+base64 快照（136 命名 / 1,210 函数注释 / 2,325 站点注释 / 2,345 槽）
  - SHA-256 校验样本身份，imagebase=0 检查
  - 与 350101 恢复脚本同款安全规则：只覆盖默认名、注释不覆盖已有
"""
import base64, json, os, textwrap, zlib

HERE = os.path.dirname(os.path.abspath(__file__))
SKILLS = "/Users/freeman/project/douyin/dyidre/skills"

raw = open(f"{HERE}/dyidre_enrich_snapshot.json", "rb").read()
snap = json.loads(raw)
b64 = base64.b64encode(zlib.compress(raw, 9)).decode()
payload_lines = "\n".join(
    f'    "{c}"' for c in textwrap.wrap(b64, 76))

counts = (len(snap["renames"]), len(snap["func_comments"]),
          len(snap["site_comments"]), len(snap["slots"]))

TEMPLATE = '''"""一键恢复 dyidre B 侧分析成果（IDA 9.3，自包含）。

对应样本：libmetasec_ml.so 350.101（SHA-256 见 EXPECTED_SHA256，精确匹配才会动手）。

包含成果（2026-09-07 六轮 IDA MCP 战役 + 回填）：
  - {n_ren} 个函数/代码标签命名：字符串解密族 ms_strdec_f1..f6、shared_ref 协议族、
    MSString/hash/VM frame、JNI 调度链（ms_jni_a_thunk/ms_jni_integrity_prefix/
    ms_jni_a_flat_dispatcher）、签名链（ms_sign_orchestrator 等）、MS.a 操作码
    handler（ms_op_2000002_sign 等）、检测矩阵坐实件（ms_detroot_su_path_table、
    ms_detcloudvm_prop_maintable、ms_antidbg_tracerpid_parser 等）及按域命名
    ms_<域>_<地址>；
  - {n_fc} 条函数注释：[域|置信度] decrypted seeds: ...（字符串种子证据）；
  - {n_sc} 条解密站点行注释：ms_str: "<明文>"；
  - {n_slot} 个全局明文缓存槽命名+注释：g_str_<slug>（qword_2Bxxxx/2Cxxxx 页）。

用法（IDA 主线程 File -> Script file...）：
  直接运行 = 应用并打印统计；末尾 save_database 默认注释掉，确认后自行取消注释。
  也可 runpy 加载后调 restore(dry_run=True) 只预览。

安全规则（与 350101 恢复脚本一致）：
  * 先 SHA-256 校验输入文件，不符即拒绝；
  * 重命名只覆盖 IDA 默认名（sub_/loc_/qword_/dword_/unk_/off_），
    已有语义名（含 350101 的 *_350 / managedFrame*_350）一律跳过；
  * 注释：已存在且不含新内容时追加，含则跳过；
  * 不建/删函数、不改字节、不动 Local Types（结构体由 350101 侧脚本负责）。
"""

from __future__ import annotations

import base64
import hashlib
import json
import re
import zlib
from pathlib import Path

EXPECTED_SHA256 = "2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76"

_PAYLOAD_B64 = (
{payload}
)


def load_snapshot() -> dict:
    """不解 IDA 依赖，任何 Python 都可解码自检。"""
    return json.loads(zlib.decompress(base64.b64decode(_PAYLOAD_B64)))


def validate_target() -> None:
    import ida_nalt
    if ida_nalt.get_imagebase() != 0:
        raise RuntimeError("dyidre enrich 恢复要求 imagebase 0（地址即 RVA）")
    data = Path(ida_nalt.get_input_file_path()).read_bytes()
    if hashlib.sha256(data).hexdigest() != EXPECTED_SHA256:
        raise RuntimeError("输入文件 SHA-256 不匹配 350.101 样本，拒绝应用")


_DEFAULT_NAME = re.compile(r"(?i)^(sub|loc|qword|dword|word|byte|unk|off)_[0-9a-f]+$")


def restore(dry_run: bool = False) -> dict:
    import idaapi
    import idc

    snap = load_snapshot()
    stats = {{"rename_ok": 0, "rename_skip_named": 0, "rename_fail": 0,
             "func_cmt": 0, "site_cmt": 0, "slot": 0}}

    def put_name(ea: int, name: str) -> None:
        cur = idc.get_name(ea) or ""
        if cur == name:
            return
        if cur and not _DEFAULT_NAME.fullmatch(cur):
            stats["rename_skip_named"] += 1
            return
        if dry_run or idc.set_name(ea, name, idc.SN_CHECK):
            stats["rename_ok"] += 1
        else:
            stats["rename_fail"] += 1

    def put_cmt(ea: int, text: str, func: bool = False) -> str:
        if func:
            f = idaapi.get_func(ea)
            if not f:
                return ""
            old = idc.get_func_cmt(f.start_ea, True) or ""
            if text in old:
                return ""
            if not dry_run:
                idc.set_func_cmt(f.start_ea, text if not old else (old + "\\n" + text)[:900], True)
            return "ok"
        old = idc.get_cmt(ea, True) or ""
        if text in old:
            return ""
        if not dry_run:
            idc.set_cmt(ea, text if not old else (old + " ; " + text)[:700], True)
        return "ok"

    for r in snap["renames"]:
        put_name(r["addr"], r["name"])
    for fc in snap["func_comments"]:
        if put_cmt(fc["addr"], fc["text"], func=True):
            stats["func_cmt"] += 1
    for sc in snap["site_comments"]:
        if put_cmt(sc["addr"], sc["text"]):
            stats["site_cmt"] += 1
    for s in snap["slots"]:
        before = stats["rename_ok"]
        put_name(s["addr"], s["name"])
        if s.get("text"):
            put_cmt(s["addr"], s["text"])
        if stats["rename_ok"] > before:
            stats["slot"] += 1
    return stats


if __name__ == "__main__":
    validate_target()
    print("[dyidre-enrich]", json.dumps(restore(), ensure_ascii=False))
    # 确认无误后取消下行注释，或直接在 IDA 里 Ctrl+W：
    # import ida_loader, ida_nalt; ida_loader.save_database(ida_nalt.get_input_file_path() + ".i64", 0)
'''

script = TEMPLATE.format(payload=payload_lines, n_ren=counts[0], n_fc=counts[1],
                         n_sc=counts[2], n_slot=counts[3])
out = f"{SKILLS}/ida_apply_dyidre_enrich_9_3.py"
open(out, "w").write(script)
print("written:", out, f"({len(script)} bytes)")
# 自检：无 IDA 环境下解码 payload
import importlib.util
spec = importlib.util.spec_from_file_location("chk", out)
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
s2 = mod.load_snapshot()
assert len(s2["renames"]) == counts[0] and len(s2["slots"]) == counts[3]
print("payload self-check OK:", counts)
