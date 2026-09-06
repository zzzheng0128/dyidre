# recovery_test2/verify_full.py — 二次开库验证统一恢复的四批成果
# 用法: idat -A -S本文件 libmetasec_ml.so.i64
import json, idc, idaapi, ida_nalt, ida_auto

OUT = "/Users/freeman/project/douyin/dyidre/metasec_350101/recovery_test2/verify_full_result.json"
SNAP = "/Users/freeman/project/douyin/dyidre/metasec_350101/dyidre_enrich_snapshot.json"

ida_auto.auto_wait()
snap = json.load(open(SNAP, encoding="utf-8"))
res = {}

# pass4 enrich：全量逐条回读
# 已知良性冲突：0x39778 同时被 pass5(enrich) 和 pass4(integrity guard) 命名，
# pass4 先跑、pass5 跳过已命名地址 → 最终名字是 guard 的
# initRootArtifactPathTable_350，enrich 回读记 1 条 miss，属预期。
KNOWN_COLLISIONS = {0x39778: "initRootArtifactPathTable_350"}
hit = {"renames": 0, "func_comments": 0, "site_comments": 0, "slots": 0}
miss = []
for r in snap["renames"]:
    got = idc.get_name(r["addr"])
    if got == r["name"] or got == KNOWN_COLLISIONS.get(r["addr"]):
        hit["renames"] += 1
    else:
        miss.append(("rename", hex(r["addr"])))
for fc in snap["func_comments"]:
    f = idaapi.get_func(fc["addr"])
    c = idc.get_func_cmt(f.start_ea, True) if f else ""
    if c and fc["text"][:60] in c:
        hit["func_comments"] += 1
    else:
        miss.append(("func_cmt", hex(fc["addr"])))
for sc in snap["site_comments"]:
    if sc["text"] in (idc.get_cmt(sc["addr"], True) or ""):
        hit["site_comments"] += 1
    else:
        miss.append(("site_cmt", hex(sc["addr"])))
for s in snap["slots"]:
    if (idc.get_name(s["addr"]) or "") == s["name"]:
        hit["slots"] += 1
    else:
        miss.append(("slot", hex(s["addr"])))
res["enrich"] = hit
res["enrich_totals"] = {k: len(snap[k]) for k in
                        ("renames", "func_comments", "site_comments", "slots")}
res["enrich_miss"] = miss[:20]

# pass1 结构体：枚举 numbered types 里的 MetaSec/COOKIE/TREE_MAP 家族
# （主 IDB 对照结论：get_named_type 对这批类型恒 False，必须用序号枚举）
import ida_typeinf
tnames = []
qty = ida_typeinf.get_ordinal_count(None)
for i in range(1, min(qty, 4000) + 1):
    n = idc.get_numbered_type_name(i)
    if n and ("MetaSec" in n or "COOKIE" in n or "TREE_MAP" in n
              or "MEM_BLOCK" in n or "JSON_LIST" in n):
        tnames.append(n)
res["struct"] = {
    "metasec_family_type_count": len(tnames),
    "type_sample": tnames[:10],
    "inner_name": idc.get_name(0x149CA8),
    "copyRef_name": idc.get_name(0x149C20),
}

# pass2 managed CF：抽查 manifest 里的代表项
cf = json.load(open("/Users/freeman/project/douyin/dyidre/versions/350101/"
                    "managed_vm_runtime_350101/cf_bindings_350101.json",
                    encoding="utf-8"))
spots = [r for r in cf if r.get("name") in
         ("fill_memblock_len5_byte6", "memcpy")][:2]
spots += [r for r in cf if r.get("index") == 61][:1]  # CF61 = SM3
res["managed_cf"] = [{"addr": hex(r["entry"]), "want": r["name"],
                      "got": idc.get_name(r["entry"])} for r in spots]

# pass3 proto/json：抽查
res["proto_json"] = [{"addr": hex(a), "want": w, "got": idc.get_name(a)} for a, w in
                     [(0x116C10, "pb_message_unpack_by_descriptor"),
                      (0x10C59C, "json_parse_value"),
                      (0x117EB8, "metasec350_varint_write_u32")]]

# pass4 integrity guard：抽查全局命名
res["guard"] = [{"addr": hex(a), "want": w, "got": idc.get_name(a)} for a, w in
                [(0x2BBE80, "g_early_runtime_time_350"),
                 (0x27DC98, "g_sig64_guard_state_350"),
                 (0x27DDF4, "g_meta_expected_xor_350")]]

json.dump(res, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("VERIFY_FULL", json.dumps({k: v for k, v in res.items() if k != "enrich_miss"},
                                ensure_ascii=False)[:600])
idc.qexit(0)
