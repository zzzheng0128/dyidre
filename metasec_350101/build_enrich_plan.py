#!/usr/bin/env python3
"""build_enrich_plan.py — 把 B 侧战役收获转成 IDA 回填计划 JSON。

输入（同目录）：
  campaign_round3_ledger.json   1,210 函数台账（domain/confidence/evidence）
  seed_index.json               1,210 函数的种子明文索引
  decrypted_strings.json        2,685 个解密站点明文
  r6_handlers.json              MS.a 操作码 -> handler 映射

输出：
  ida_enrich_plan.json  {renames:[], func_comments:[], site_comments:[]}

命名规范：
  - 只动 IDA 默认名（sub_XXXXX）；已有语义名（*_350 等）一律跳过（在 apply 端再校验）
  - 手工精选名（curated）优先；其余按域生成 ms_<域短名>_<地址小写hex>
  - 仅 高/高(已反编译坐实)/中 置信度且域有意义 的函数给重命名
  - 其余带种子函数只加函数注释；全部 2,685 站点加行注释
"""
import json, re, os

HERE = os.path.dirname(os.path.abspath(__file__))

ledger = json.load(open(f"{HERE}/campaign_round3_ledger.json"))
seed_idx = json.load(open(f"{HERE}/seed_index.json"))["index"]
strings = json.load(open(f"{HERE}/decrypted_strings.json"))
handlers = json.load(open(f"{HERE}/r6_handlers.json"))

# ---------- 手工精选名（来自各轮报告的坐实结论） ----------
CURATED = {
    # 字符串解密族（R1/R2）
    0x12B904: "ms_strdec_f1_period8",
    0x12BFA8: "ms_strdec_f2_period8",
    0x12C648: "ms_strdec_f3_period8",
    0x12C9A4: "ms_strdec_f4_period8",
    0x12CF90: "ms_strdec_f5_period8",
    0x15AC98: "ms_strdec_f6_varlen_nul",
    # 数据结构（R0）
    0x4788C:  "ms_sharedref_create",
    0x44B6C:  "ms_sharedref_copy",
    0x42CE4:  "ms_sharedref_release",
    0x10B5F0: "ms_msstring_ctor",
    0x172AF4: "ms_hashtable_probe",
    0x12D910: "ms_cfgtree_dotted_query",
    0x1547C0: "ms_vmframe_slot_read",
    0x1547D4: "ms_vmframe_slot_write",
    # JNI 调度链（R5/R6）
    0x12FB84: "ms_jni_a_thunk",
    0x12FCE0: "ms_jni_integrity_prefix",
    0x597D4:  "ms_jni_a_flat_dispatcher",
    # 签名链（R4）
    0x8EFD8:  "ms_sign_reqctx_registry_t4",
    0x14F8C8: "ms_sign_orchestrator",
    0x14F94C: "ms_sign_runtime_cfg_init",
    0x12E2A4: "ms_report_devid_assemble",
    # 检测矩阵坐实（R3）
    0x39778:  "ms_detroot_su_path_table",
    0xC5D00:  "ms_detroot_magisk_features",
    0xC710C:  "ms_detinject_frida_xposed",
    0x3A6DC:  "ms_detinject_lsposed_riru",
    0x3C724:  "ms_detcloudvm_prop_maintable",
    0x7F1A0:  "ms_detcloudvm_vendor_props",
    0xC2A60:  "ms_detbrand_ro_product",
    0xAFE94:  "ms_antidbg_tracerpid_parser",
    0x16B080: "ms_hwfeat_check",
    0x77EC4:  "ms_devid_mediadrm_uuid",
    0x121A0C: "ms_prbcfg_accessor",
    0x98780:  "ms_portscan_rules",
}

# MS.a 操作码 handler（R6 实测语义）
OP_SEM = {
    "0x2000002": "sign", "0x2000005": "sign", "0x200000E": "sign",
    "0x2000003": "sign_aux", "0x2000004": "sign_aux",
    "0x2000007": "registry_query", "0x2000008": "registry_query",
}
for op, info in handlers.items():
    sem = OP_SEM.get(op, "business")
    addr = int(info["handler"], 16)
    CURATED.setdefault(addr, f"ms_op_{op[2:].lower()}_{sem}")

# ---------- 域重命名规则 ----------
DOM_SHORT = {
    "root_magisk": "detroot", "inject_framework": "detinject",
    "cloud_phone_vm": "detcloudvm", "brand_rom": "detbrand",
    "anti_debug_proc": "detantidbg", "hardware_feature": "hwfeat",
    "device_id": "devid", "app_risk": "riskapp", "sys_prop": "sysprop",
    "network_report": "netreport", "crypto": "crypto", "jni_reflect": "jnireflect",
}
RENAME_CONF = {"高", "高(已反编译坐实)", "中"}

renames, seen_addr = [], set()
for addr, name in sorted(CURATED.items()):
    renames.append({"addr": addr, "name": name, "kind": "curated"})
    seen_addr.add(addr)

for addr_s, v in ledger.items():
    addr = int(addr_s, 16)
    if addr in seen_addr:
        continue
    if v["domain"] in DOM_SHORT and v["confidence"] in RENAME_CONF:
        renames.append({
            "addr": addr,
            "name": f"ms_{DOM_SHORT[v['domain']]}_{addr:x}",
            "kind": f"domain:{v['domain']}",
        })
        seen_addr.add(addr)

# ---------- 函数注释（全部 1,210 个带种子函数） ----------
def clean(s, n=120):
    s = "".join(c if 32 <= ord(c) < 127 or ord(c) > 127 else "?" for c in str(s))
    return s[:n]

func_comments = []
for addr_s, info in seed_idx.items():
    addr = int(addr_s, 16)
    seeds = [clean(s["pt"], 60) for s in info.get("seeds", [])][:6]
    if not seeds:
        continue
    led = ledger.get(addr_s)
    head = ""
    if led:
        head = f"[{led['domain']}|{led['confidence']}] "
    text = head + "decrypted seeds: " + " | ".join(seeds)
    func_comments.append({"addr": addr, "text": clean(text, 400)})

# ---------- 站点注释（2,685 条解密明文） ----------
site_comments, seen_site = [], set()
for e in strings:
    if not e.get("ok"):
        continue
    site = e["site"]
    if site in seen_site:
        continue
    seen_site.add(site)
    pt = clean(e.get("pt", ""), 200)
    if not pt:
        continue
    site_comments.append({"addr": site, "text": f'ms_str: "{pt}"'})

plan = {"renames": renames, "func_comments": func_comments,
        "site_comments": site_comments}
out = f"{HERE}/ida_enrich_plan.json"
json.dump(plan, open(out, "w"), ensure_ascii=False, indent=1)
print(f"renames: {len(renames)} (curated {sum(1 for r in renames if r['kind']=='curated')})")
print(f"func_comments: {len(func_comments)}")
print(f"site_comments: {len(site_comments)}")
print("->", out)
