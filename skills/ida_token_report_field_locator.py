"""Locate token/report field producers in a MetaSec IDB.

Run inside IDA's Python console.  The script is deliberately read-only by
default: it reports string xrefs, containing functions, and existing named
types.  Set APPLY_NAMES = True only after reviewing the printed candidates.
It does not patch bytes and does not import the legacy z/ws ABI.
"""

import re

import ida_funcs
import ida_kernwin
import ida_name
import ida_typeinf
import idautils


APPLY_NAMES = False

FIELD_KEYS = {
    "ro_brand": "token_field_ro_brand",
    "ro_model": "token_field_ro_model",
    "ro_display_id": "token_field_ro_display_id",
    "ro_release": "token_field_ro_release",
    "ro_build_date_utc": "token_field_ro_date_utc",
    "TracerPid": "risk_field_tracer_pid",
    "link_verify": "risk_field_link_verify",
    "ro_debuggable": "risk_field_ro_debuggable",
    "verifiedbootstate": "risk_field_verified_boot",
}

TYPE_HINTS = (
    "MetaSecCtx350",
    "MetaSecHttpInnerArgPack350",
    "JSON_LIST",
    "TREE_MAP",
    "MEM_BLOCK",
    "REF_MEM_BLOCK",
    "COOKIE_RISK_HEAD",
    "COOKIE_RISK2",
    "MetaSecMssdkMaterial350",
    "ManagedFrame350",
    "ManagedProgram350",
)


def _func_name(ea):
    f = ida_funcs.get_func(ea)
    return ida_funcs.get_func_name(f.start_ea) if f else "<no-function>"


def _is_default_name(name):
    return not name or name.startswith(("sub_", "loc_", "nullsub_"))


def scan_field_xrefs():
    hits = []
    for s in idautils.Strings():
        text = str(s)
        matched = [k for k in FIELD_KEYS if k.lower() in text.lower()]
        if not matched:
            continue
        for xr in idautils.XrefsTo(s.ea, 0):
            fn = ida_funcs.get_func(xr.frm)
            if not fn:
                continue
            name = ida_funcs.get_func_name(fn.start_ea)
            hits.append((s.ea, text, fn.start_ea, name, matched))
    for ea, text, fn_ea, name, matched in sorted(set(hits)):
        ida_kernwin.msg(
            "[token-report] string=%#x %-28s fn=%#x %-36s fields=%s\n"
            % (ea, text[:28], fn_ea, name, ",".join(matched))
        )
        if APPLY_NAMES and _is_default_name(name) and len(matched) == 1:
            ida_name.set_name(fn_ea, FIELD_KEYS[matched[0]], ida_name.SN_NOCHECK)
    return hits


def scan_named_functions():
    patterns = (
        re.compile(r"get.?token", re.I),
        re.compile(r"report|risk", re.I),
        re.compile(r"post.?report", re.I),
    )
    for ea in idautils.Functions():
        name = ida_funcs.get_func_name(ea)
        if any(p.search(name) for p in patterns):
            ida_kernwin.msg("[token-report] function=%#x %s\n" % (ea, name))


def scan_existing_types():
    tif = ida_typeinf.get_idati()
    for name in TYPE_HINTS:
        ty = ida_typeinf.tinfo_t()
        exists = bool(ida_typeinf.get_named_type(tif, name, ty))
        if exists:
            ida_kernwin.msg("[token-report] type=%s size=%d\n" % (name, ty.get_size()))
        else:
            ida_kernwin.msg("[token-report] type=%s MISSING\n" % name)


def main():
    ida_kernwin.msg("[token-report] read-only locator start; APPLY_NAMES=%s\n" % APPLY_NAMES)
    scan_named_functions()
    scan_existing_types()
    hits = scan_field_xrefs()
    ida_kernwin.msg("[token-report] field xref hits=%d\n" % len(hits))


if __name__ == "__main__":
    main()
