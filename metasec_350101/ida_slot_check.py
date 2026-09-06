# ida_slot_check.py — 复查：哪些槽仍叫 qword_*，并对一例诊断 set_name 失败原因
import idc, idautils, idaapi, json, re, os

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
still = [(s, pt) for s, pt in slots.items() if DEFAULT.fullmatch(idc.get_name(s) or "")]
print("still_default:", len(still))
for s, pt in still[:8]:
    name = "g_str_" + re.sub(r"_+", "_", re.sub(r"[^0-9A-Za-z]+", "_", pt).strip("_").lower())[:40].strip("_")
    r = idc.set_name(s, name, idc.SN_CHECK)
    print(hex(s), repr(pt[:40]), "->", name, "set_name=", r, "now=", idc.get_name(s))
