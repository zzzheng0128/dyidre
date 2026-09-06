#!/usr/bin/env python3
"""build_rehydrate_unified.py — 生成统一恢复脚本 skills/ida_rehydrate_metasec_9_3.py。

设计：一份脚本 = 全部数据内嵌 + 四段恢复逻辑。
  数据（会随分析增长，全部内嵌为 zlib+base64）：
    enrich     dyidre B 侧快照（命名/注释/槽名）—— 本战役产物，最常更新
    summary    350101 summary.json（结构体字段证据）
    header     350101 metasec_ctx350_draft.h（草稿结构体）
    cfmanifest 350101 cf_bindings_350101.json（CF0..CF101 绑定台账）
  逻辑（稳定代码，引用 skills/ 下原脚本，避免复制 100KB 逻辑）：
    ida_apply_metasec_struct_evidence.py / ida_apply_managed_cf_350101.py
    / ida_apply_proto_json_names_350101.py，运行时用内嵌数据覆盖其数据路径常量。

维护规则（重要）：新增分析成果 → 更新 snapshot/数据文件 → 重跑本 builder →
统一脚本更新。不要手改生成文件里的 base64 块。
"""
import base64, json, os, textwrap, zlib

HERE = os.path.dirname(os.path.abspath(__file__))
V350101 = "/Users/freeman/project/douyin/dyidre/versions/350101"
SKILLS = "/Users/freeman/project/douyin/dyidre/skills"

BLOBS = {
    "enrich": f"{HERE}/dyidre_enrich_snapshot.json",
    "summary": f"{V350101}/summary.json",
    "header": f"{V350101}/metasec_ctx350_draft.h",
    "cfmanifest": f"{V350101}/managed_vm_runtime_350101/cf_bindings_350101.json",
}

def enc(path):
    raw = open(path, "rb").read()
    return base64.b64encode(zlib.compress(raw, 9)).decode(), len(raw)

blob_defs = []
sizes = {}
for key, path in BLOBS.items():
    b64, n = enc(path)
    sizes[key] = n
    lines = "\n".join(f'        "{c}"' for c in textwrap.wrap(b64, 76))
    blob_defs.append(f'    "{key}": (\n{lines}\n    ),')
blob_block = "\n".join(blob_defs)

TEMPLATE = '''"""统一恢复脚本：libmetasec_ml.so 350.101 的全部 IDA 分析成果（IDA 9.3）。

一份脚本恢复五批成果，SHA-256 校验通过且 imagebase=0 才会动手：
  1. 350101 结构体证据/Local Types/原型（数据内嵌，逻辑调
     ida_apply_metasec_struct_evidence.py）；
  2. 350101 managed CF0..CF101 命名（数据内嵌，逻辑调
     ida_apply_managed_cf_350101.py）；
  3. 350101 protobuf/JSON 通用函数命名（ida_apply_proto_json_names_350101.py，
     其自身逻辑与数据均自包含）；
  4. 350101 完整性/反调试链命名与类型（ida_apply_integrity_guard_350101.py，
     自包含，自带 4 个代码锚点校验）；
  5. dyidre B 侧 enrich（数据+逻辑均内嵌于本文件）：136 命名 / 1,210 函数注释 /
     2,325 站点注释 / 2,345 明文缓存槽命名。

用法：
  GUI    IDA 打开原始 so → File -> Script file... → 选本文件；
  无头   idat -A -S本脚本 libmetasec_ml.so
  默认另存 <输入>.i64（不碰现有库）；restore_all(save=False) 可不保存。

维护（新增成果怎么同步）：
  B 侧新增 → 重跑 metasec_350101/ida_dyidre_snapshot.py 更新快照；
  350101 侧数据更新 → 直接改 versions/350101/ 下对应文件；
  然后重跑 metasec_350101/build_rehydrate_unified.py 重新生成【本文件】。
  不要手改下面的 base64 数据块（生成物）。本文件取代旧的
  ida_rehydrate_350101_9_3.py / ida_rehydrate_full_9_3.py /
  ida_apply_dyidre_enrich_9_3.py 三份入口（2026-09-07 已删除，见 HANDOFF §5.1）。

已验证：隔离目录全新建库端到端跑通（metasec_350101/recovery_test*）。
"""

from __future__ import annotations

import base64
import hashlib
import json
import re
import runpy
import tempfile
import zlib
from pathlib import Path

EXPECTED_SHA256 = "2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76"

SKILLS = Path("/Users/freeman/project/douyin/dyidre/skills")
STRUCT_SCRIPT = SKILLS / "ida_apply_metasec_struct_evidence.py"
CF_SCRIPT = SKILLS / "ida_apply_managed_cf_350101.py"
PROTO_SCRIPT = SKILLS / "ida_apply_proto_json_names_350101.py"
GUARD_SCRIPT = SKILLS / "ida_apply_integrity_guard_350101.py"

# ── 内嵌数据块（zlib+base64；由 build_rehydrate_unified.py 生成，勿手改） ──
# 原始大小：enrich {s_enrich}B / summary {s_summary}B / header {s_header}B / cfmanifest {s_cfmanifest}B
_BLOBS = {{
{blobs}
}}


def _dec(key: str) -> bytes:
    return zlib.decompress(base64.b64decode("".join(
        _BLOBS[key] if isinstance(_BLOBS[key], tuple) else [_BLOBS[key]])))


# ══════════════════ 通用校验 ══════════════════

def validate_target() -> None:
    import ida_nalt
    if ida_nalt.get_imagebase() != 0:
        raise RuntimeError("统一恢复要求 imagebase 0（地址即 RVA）")
    data = Path(ida_nalt.get_input_file_path()).read_bytes()
    if hashlib.sha256(data).hexdigest() != EXPECTED_SHA256:
        raise RuntimeError("输入文件 SHA-256 不匹配 350.101 样本，拒绝应用")


# ══════════════════ pass 1-4：350101 遗产 ══════════════════

def _load_module(script: Path, run_name: str) -> dict:
    """用受控全局命名空间加载脚本（不用 runpy：runpy 返回的 dict 与函数的
    __globals__ 不是同一对象，事后补丁不生效——已实测确认）。"""
    g = {{"__name__": run_name, "__file__": str(script)}}
    src = script.read_text(encoding="utf-8")
    exec(compile(src, str(script), "exec"), g)
    return g


def apply_350101(tmpdir: Path, log=print) -> None:
    """用内嵌数据覆盖 350101 各 pass 的数据路径后执行。"""
    for p in (STRUCT_SCRIPT, CF_SCRIPT, PROTO_SCRIPT, GUARD_SCRIPT):
        if not p.is_file():
            raise RuntimeError(f"missing logic script: {{p}}")

    # pass 1：结构体证据（patch SUMMARY_JSON / STRUCT_HEADER 两个模块常量）
    summary = tmpdir / "summary.json"
    header = tmpdir / "metasec_ctx350_draft.h"
    summary.write_bytes(_dec("summary"))
    header.write_bytes(_dec("header"))
    ns = _load_module(STRUCT_SCRIPT, "recov_struct")
    ns["SUMMARY_JSON"] = summary
    ns["STRUCT_HEADER"] = header
    log("[pass1] struct evidence ...")
    ns["main"]()

    # pass 2：managed CF 命名（patch MANIFEST_PATH）
    manifest = tmpdir / "cf_bindings_350101.json"
    manifest.write_bytes(_dec("cfmanifest"))
    ns = _load_module(CF_SCRIPT, "recov_cf")
    ns["MANIFEST_PATH"] = manifest
    log("[pass2] managed CF names ...")
    ns["main"]()

    # pass 3：protobuf/JSON 命名（自包含）
    log("[pass3] proto/json names ...")
    ns = _load_module(PROTO_SCRIPT, "recov_proto")
    ns["validate_target"]()
    ns["restore_names"](save=False)

    # pass 4：完整性/反调试链命名与类型（自包含，自带 4 个代码锚点校验）
    log("[pass4] integrity guard ...")
    # guard 的 TYPE_DECLS 引用了 draft 头里没有完整定义的类型
    # （FUN_MUTEX / REF_COOKIE_RISK_ITEMS 只在 metasec_structs_350_all.h 中，
    # jobject 是 JNI 类型），先逐条补进 Local Types 再跑 guard。
    # 注意：parse_decls 出错【不抛异常】，返回错误条数——必须显式检查返回值。
    # 已存在时单条 parse 报错——容忍并继续下一条（幂等，适配主 IDB 重跑）。
    import ida_typeinf
    for _decl in (
        "typedef void *jobject;",
        "typedef struct COOKIE_RISK_ITEMS COOKIE_RISK_ITEMS;",
        "typedef struct FUN_MUTEX {{ void *vtable; uint8_t pthread_mutex_storage[40]; }} FUN_MUTEX;",
        "typedef struct REF_COOKIE_RISK_ITEMS {{ COOKIE_RISK_ITEMS *risk_items; int32_t *ref_count_ptr; }} REF_COOKIE_RISK_ITEMS;",
        "typedef struct JSON_LIST JSON_LIST;",
        "typedef struct REF_JSON_LIST {{ JSON_LIST *json_list; int32_t *ref_count_ptr; }} REF_JSON_LIST;",
        # guard 原型表（PROTOTYPES）仅以指针形式引用以下类型，前置声明即够；
        # 主 IDB 里的完整定义来自 metasec_structs_350_all.h（恢复流不导入该大头文件）。
        "typedef struct COOKIE_UPDATE_SETTINGS COOKIE_UPDATE_SETTINGS;",
        "typedef struct PROP_T2 PROP_T2;",
        "typedef struct REF_OBJ REF_OBJ;",
        "typedef struct REF_REPORT REF_REPORT;",
        "typedef struct JNIEnv JNIEnv;",
    ):
        _err = ida_typeinf.parse_decls(ida_typeinf.get_idati(), _decl, None, ida_typeinf.PT_SIL)
        if _err:
            log(f"[pass4] preamble decl {{_err}} err (exists? skip): {{_decl[:70]}}")
    ns = _load_module(GUARD_SCRIPT, "recov_guard")
    ns["main"]()


# ══════════════════ pass 5：dyidre B 侧 enrich（逻辑内嵌） ══════════════════

_DEFAULT_NAME = re.compile(r"(?i)^(sub|loc|qword|dword|word|byte|unk|off)_[0-9a-f]+$")


def restore_enrich(dry_run: bool = False) -> dict:
    import idaapi
    import idc

    snap = json.loads(_dec("enrich").decode("utf-8"))
    stats = {{"rename_ok": 0, "rename_skip_named": 0, "rename_fail": 0,
             "func_cmt": 0, "site_cmt": 0, "slot": 0}}

    def put_name(ea, name):
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

    def put_cmt(ea, text, func=False):
        if func:
            f = idaapi.get_func(ea)
            if not f:
                return False
            old = idc.get_func_cmt(f.start_ea, True) or ""
            if text in old:
                return False
            if not dry_run:
                idc.set_func_cmt(f.start_ea, text if not old else (old + "\\n" + text)[:900], True)
            return True
        old = idc.get_cmt(ea, True) or ""
        if text in old:
            return False
        if not dry_run:
            idc.set_cmt(ea, text if not old else (old + " ; " + text)[:700], True)
        return True

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


# ══════════════════ 总入口 ══════════════════

def restore_all(save: bool = True, log=print) -> dict:
    import ida_auto
    validate_target()
    with tempfile.TemporaryDirectory(prefix="metasec_rehydrate_") as td:
        apply_350101(Path(td), log)
    stats = restore_enrich()
    log(f"[pass5] dyidre enrich: {{stats}}")
    ida_auto.auto_wait()
    saved = False
    if save:
        import ida_loader
        import ida_nalt
        out = str(ida_nalt.get_input_file_path()) + ".i64"
        saved = bool(ida_loader.save_database(out, 0))
        log(f"[save] {{out}} -> {{saved}}")
    return {{"enrich": stats, "saved": saved}}


if __name__ == "__main__":
    import ida_kernwin
    def _log(m):
        ida_kernwin.msg(str(m) + "\\n")
        print(m)
    restore_all(save=True, log=_log)
'''

script = TEMPLATE.format(blobs=blob_block, s_enrich=sizes["enrich"],
                         s_summary=sizes["summary"], s_header=sizes["header"],
                         s_cfmanifest=sizes["cfmanifest"])
out = f"{SKILLS}/ida_rehydrate_metasec_9_3.py"
open(out, "w").write(script)
print("written:", out, f"({len(script)} bytes)")

# 自检：无 IDA 环境解码全部数据块
src = open(out).read()
import types
g = {"__name__": "selfcheck"}
# 只执行到 _BLOBS 定义为止（避免 import ida 部分）
head = src[:src.index("def _dec")]
exec(compile(head, out, "exec"), g)
blobs = g["_BLOBS"]
for k in BLOBS:
    raw = zlib.decompress(base64.b64decode("".join(blobs[k])))
    assert len(raw) == sizes[k], k
print("blob self-check OK:", sizes)
