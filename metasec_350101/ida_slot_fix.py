# ida_slot_fix.py — 补刀：仍为默认名的缓存槽改用 g_str_<slug>_<hex> 唯一命名
import idc, idautils, json, re, os

HERE = "/Users/freeman/project/douyin/dyidre/metasec_350101"
strings = json.load(open(os.path.join(HERE, "decrypted_strings.json")))
SLOT_LO, SLOT_HI = 0x2A0000, 0x2E0000

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
        slots.setdefault(slot, e.get("pt", ""))

DEFAULT = re.compile(r"(?i)^(qword|dword|word|byte|unk|off)_[0-9a-f]+$")
fixed = 0
for s, pt in sorted(slots.items()):
    if not DEFAULT.fullmatch(idc.get_name(s) or ""):
        continue
    slug = re.sub(r"_+", "_", re.sub(r"[^0-9A-Za-z]+", "_", pt).strip("_").lower())[:36].strip("_") or "x"
    if idc.set_name(s, f"g_str_{slug}_{s:x}", idc.SN_CHECK):
        fixed += 1
print("SLOT_FIX", fixed, "of", sum(1 for s in slots if DEFAULT.fullmatch(idc.get_name(s) or '')) + fixed)
