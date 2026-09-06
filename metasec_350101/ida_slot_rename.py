# ida_slot_rename.py — 在 IDA 进程内执行（py_exec_file）
# 把字符串解密站点回链到全局明文缓存槽（qword_2Bxxxx/2Cxxxx），并给槽语义化重命名。
#
# 配对规则（对函数内多站点鲁棒）：
#   站点 = 解密调用/密文构建地址；取站点之后 [0, 0x40] 区间内第一条
#   STR 到槽页 [0x2A0000, 0x2E0000) 的指令，其目标即该站点的缓存槽；
#   找不到则放宽到 [0, 0x100]，再找不到记入 unpaired。
#
# 安全规则：
#   - 只覆盖默认名 qword_XXXXX/dword_XXXXX/unk_XXXXX；已有语义名跳过
#   - 一槽多站点且明文不一致时保留先者并记录 conflict
#   - 命名冲突自动加 _<hex> 后缀；IDB 仍未保存，可整体回滚
import idc, idautils, idaapi, json, re, os

HERE = "/Users/freeman/project/douyin/dyidre/metasec_350101"
strings = json.load(open(os.path.join(HERE, "decrypted_strings.json")))

SLOT_LO, SLOT_HI = 0x2A0000, 0x2E0000

def slots_in_window(start, end):
    """返回 [(insn_ea, slot_ea)]，仅 STR 类（写）优先由调用方筛。"""
    out = []
    ea = start
    while ea < end and ea != idc.BADADDR:
        for d in idautils.DataRefsFrom(ea):
            if SLOT_LO <= d < SLOT_HI:
                out.append((ea, d))
        ea = idc.next_head(ea, end)
    return out

def is_str(ea):
    m = idc.print_insn_mnem(ea)
    return m.startswith("STR") or m.startswith("STUR")

# 1. 站点 -> 槽配对
pairs = {}       # site -> slot
unpaired = []
for e in strings:
    if not e.get("ok"):
        continue
    site = e["site"]
    slot = None
    for w in (0x40, 0x100):
        for iea, d in slots_in_window(site, site + w):
            if is_str(iea):
                slot = d
                break
        if slot:
            break
    if slot:
        pairs[site] = slot
    else:
        unpaired.append(site)

# 2. 槽 -> 明文（冲突检测）
slot_pt, conflicts = {}, []
for e in strings:
    if not e.get("ok"):
        continue
    site = e["site"]
    if site not in pairs:
        continue
    slot, pt = pairs[site], e.get("pt", "")
    if slot in slot_pt and slot_pt[slot] != pt:
        conflicts.append({"slot": slot, "keep": slot_pt[slot], "drop": pt})
        continue
    slot_pt.setdefault(slot, pt)

# 3. 命名
def slugify(pt, maxlen=40):
    s = re.sub(r"[^0-9A-Za-z]+", "_", pt).strip("_").lower()
    s = re.sub(r"_+", "_", s)[:maxlen].strip("_")
    return s or "x"

stats = {"paired": len(pairs), "unpaired": len(unpaired),
         "slots": len(slot_pt), "rename_ok": 0, "skip_named": 0,
         "conflict": len(conflicts)}
DEFAULT = re.compile(r"(?i)^(qword|dword|word|byte|unk|off)_[0-9a-f]+$")

for slot, pt in sorted(slot_pt.items()):
    cur = idc.get_name(slot) or ""
    if cur and not DEFAULT.fullmatch(cur):
        stats["skip_named"] += 1
        continue
    base = f"g_str_{slugify(pt)}"
    name, i = base, 1
    while idc.get_name_ea_simple(name) not in (idc.BADADDR, slot) and i < 100:
        i += 1
        name = f"{base}_{i}"
    if idc.set_name(slot, name, idc.SN_CHECK):
        stats["rename_ok"] += 1
    cmt = f'ms_str: "{pt[:180]}"'
    old = idc.get_cmt(slot, True) or ""
    if cmt not in old:
        idc.set_cmt(slot, (old + " ; " + cmt)[:700] if old else cmt, True)

json.dump({"stats": stats, "conflicts": conflicts[:100],
           "unpaired_sample": unpaired[:50], "unpaired_total": len(unpaired)},
          open(os.path.join(HERE, "ida_slot_rename_result.json"), "w"),
          ensure_ascii=False, indent=1)
print("SLOT_DONE", json.dumps(stats, ensure_ascii=False))
