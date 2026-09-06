# recovery_test_verify.py — 二次开库验证：从保存的 i64 独立回读恢复成果
# 用法: idat -A -S<本文件> <recovered.i64>
import json, re, idc, idautils, ida_nalt, ida_kernwin, ida_auto

OUT = "/Users/freeman/project/douyin/dyidre/metasec_350101/recovery_test/verify_result.json"
SNAP = "/Users/freeman/project/douyin/dyidre/metasec_350101/dyidre_enrich_snapshot.json"

ida_auto.auto_wait()
snap = json.load(open(SNAP, encoding="utf-8"))

res = {"imagebase": ida_nalt.get_imagebase(),
       "renames_hit": 0, "renames_miss": [],
       "func_cmt_hit": 0, "site_cmt_hit": 0,
       "slot_hit": 0, "slot_miss": []}

for r in snap["renames"]:
    if idc.get_name(r["addr"]) == r["name"]:
        res["renames_hit"] += 1
    else:
        res["renames_miss"].append({"addr": hex(r["addr"]),
                                    "want": r["name"],
                                    "got": idc.get_name(r["addr"])})

import idaapi
for fc in snap["func_comments"]:
    f = idaapi.get_func(fc["addr"])
    c = idc.get_func_cmt(f.start_ea, True) if f else ""
    if c and fc["text"][:60] in c:
        res["func_cmt_hit"] += 1

for sc in snap["site_comments"]:
    c = idc.get_cmt(sc["addr"], True) or ""
    if sc["text"] in c:
        res["site_cmt_hit"] += 1

for s in snap["slots"]:
    if (idc.get_name(s["addr"]) or "") == s["name"]:
        res["slot_hit"] += 1
    else:
        res["slot_miss"].append(hex(s["addr"]))

res["totals"] = {"renames": len(snap["renames"]),
                 "func_comments": len(snap["func_comments"]),
                 "site_comments": len(snap["site_comments"]),
                 "slots": len(snap["slots"])}
json.dump(res, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("VERIFY_DONE", json.dumps({k: v for k, v in res.items()
                                 if not isinstance(v, list)}, ensure_ascii=False),
      "miss:", len(res["renames_miss"]), len(res["slot_miss"]))
idc.qexit(0)
