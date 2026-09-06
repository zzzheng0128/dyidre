# ida_dyidre_snapshot.py — 在 IDA 进程内执行（py_exec_file）
# 从在线 IDB 导出 B 侧回填的最终状态快照，供生成自包含恢复脚本用。
# 数据源地址清单取 ida_enrich_plan.json + 槽位配对重算；名字/注释以 IDB 当前值为准。
import idc, idautils, idaapi, json, re, os

HERE = "/Users/freeman/project/douyin/dyidre/metasec_350101"
plan = json.load(open(os.path.join(HERE, "ida_enrich_plan.json")))
strings = json.load(open(os.path.join(HERE, "decrypted_strings.json")))
SLOT_LO, SLOT_HI = 0x2A0000, 0x2E0000

snap = {"meta": {"source": "dyidre B-side enrichment", "date": "2026-09-07"},
        "renames": [], "func_comments": [], "site_comments": [], "slots": []}

for r in plan["renames"]:
    ea = r["addr"]
    name = idc.get_name(ea) or ""
    if name and not re.fullmatch(r"(?i)sub_[0-9a-f]+", name):
        snap["renames"].append({"addr": ea, "name": name})

for fc in plan["func_comments"]:
    f = idaapi.get_func(fc["addr"])
    if f:
        c = idc.get_func_cmt(f.start_ea, True) or ""
        if c:
            snap["func_comments"].append({"addr": f.start_ea, "text": c})

for sc in plan["site_comments"]:
    c = idc.get_cmt(sc["addr"], True) or ""
    if c:
        snap["site_comments"].append({"addr": sc["addr"], "text": c})

def is_str(ea):
    m = idc.print_insn_mnem(ea)
    return m.startswith("STR") or m.startswith("STUR")

slots = {}
for e in strings:
    if not e.get("ok"):
        continue
    site = e["site"]
    slot = None
    for w in (0x40, 0x100):
        ea = site
        while ea < site + w and ea != idc.BADADDR:
            hit = [d for d in idautils.DataRefsFrom(ea) if SLOT_LO <= d < SLOT_HI]
            if hit and is_str(ea):
                slot = hit[0]
                break
            ea = idc.next_head(ea, site + w)
        if slot:
            break
    if slot:
        slots.setdefault(slot, None)

for slot in sorted(slots):
    name = idc.get_name(slot) or ""
    if not name.startswith("g_str_"):
        continue
    snap["slots"].append({"addr": slot, "name": name,
                          "text": idc.get_cmt(slot, True) or ""})

out = os.path.join(HERE, "dyidre_enrich_snapshot.json")
json.dump(snap, open(out, "w"), ensure_ascii=False)
print("SNAPSHOT", len(snap["renames"]), len(snap["func_comments"]),
      len(snap["site_comments"]), len(snap["slots"]), "->", out)
