# ida_enrich_apply.py — 在 IDA 进程内执行（py_exec_file），应用 ida_enrich_plan.json
# 安全规则：
#   1. 重命名只动默认名 sub_<addr>（大小写不敏感）；已有语义名一律跳过
#   2. set_name 用 SN_CHECK，冲突时追加 _2/_3 后缀
#   3. 站点已有注释时追加而非覆盖
#   4. 结果统计写回 ida_enrich_result.json
import idc, idaapi, json, re, os

HERE = "/Users/freeman/project/douyin/dyidre/metasec_350101"
plan = json.load(open(os.path.join(HERE, "ida_enrich_plan.json")))

stats = {"rename_ok": 0, "rename_skip_named": 0, "rename_notfunc": 0,
         "rename_fail": 0, "func_cmt_ok": 0, "func_cmt_nofunc": 0,
         "site_cmt_ok": 0, "site_cmt_appended": 0}
fails = []

for r in plan["renames"]:
    ea, name = r["addr"], r["name"]
    cur = idc.get_name(ea) or ""
    # 只覆盖默认名 sub_xxxx（地址必须吻合），保护 *_350 等已有命名
    if cur and not re.fullmatch(r"(?i)sub_%X" % ea, cur):
        if re.fullmatch(r"(?i)sub_[0-9a-f]+", cur):
            stats["rename_notfunc"] += 1  # 默认名但地址不对应，保守跳过
        else:
            stats["rename_skip_named"] += 1
        continue
    ok = idc.set_name(ea, name, idc.SN_CHECK)
    if not ok:
        for i in range(2, 10):
            if idc.set_name(ea, f"{name}_{i}", idc.SN_CHECK):
                ok = True
                break
    if ok:
        stats["rename_ok"] += 1
    else:
        stats["rename_fail"] += 1
        fails.append({"addr": ea, "name": name, "cur": cur})

for fc in plan["func_comments"]:
    ea = fc["addr"]
    f = idaapi.get_func(ea)
    if not f:
        stats["func_cmt_nofunc"] += 1
        continue
    if idc.set_func_cmt(f.start_ea, fc["text"], True):
        stats["func_cmt_ok"] += 1

for sc in plan["site_comments"]:
    ea = sc["addr"]
    old = idc.get_cmt(ea, True) or ""
    if old:
        if sc["text"] in old:
            continue
        new = (old + " ; " + sc["text"])[:700]
        idc.set_cmt(ea, new, True)
        stats["site_cmt_appended"] += 1
    else:
        idc.set_cmt(ea, sc["text"], True)
        stats["site_cmt_ok"] += 1

json.dump({"stats": stats, "fails": fails[:50]},
          open(os.path.join(HERE, "ida_enrich_result.json"), "w"),
          ensure_ascii=False, indent=1)
print("ENRICH_DONE", json.dumps(stats, ensure_ascii=False))
