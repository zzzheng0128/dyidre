"""Apply evidence-backed names/comments for 350.101 managed CF0..CF101.

Run this *inside IDA* after loading the matching 350.101 libmetasec_ml.so.
The script uses module-relative entries from the versioned runtime manifest,
then adds IDA's image base at run time.  It never overwrites a non-default
analyst name and deliberately does not invent function prototypes or structs.

The resulting names distinguish three facts:
  * every CF index has an exact native wrapper entry from the registration
    table in initManagedSignModuleLarge_350 (+0x1702b8);
  * only selected wrappers have a recovered semantic name; and
  * ``runtime=yes`` means an evidence-backed standalone replacement exists in
    managed_vm_runtime_350101.  It is not a claim that all native lifecycle or
    error behaviour has been reproduced.
"""

from __future__ import annotations

import json
from pathlib import Path

import ida_auto
import ida_bytes
import ida_kernwin
import ida_nalt
import ida_name


COMMENT_PREFIX = "[managed-cf-350101]"
COMMENT_END = "[managed-cf-350101:end]"
SCRIPT_PATH = Path(globals().get("__file__", "ida_apply_managed_cf_350101.py")).resolve()
DYIDRE_ROOT = SCRIPT_PATH.parent.parent
MANIFEST_PATH = (
    DYIDRE_ROOT
    / "versions"
    / "350101"
    / "managed_vm_runtime_350101"
    / "cf_bindings_350101.json"
)

# Keep a semantic word in a symbol only where static recovery supports it.  All
# other wrappers still receive stable names, but say ``nativeBindingUnknown``
# rather than encouraging downstream analysts to treat an address as solved.
SEMANTIC_LABELS: dict[int, str] = {
    0: "fillMemBlock",
    4: "allocRaw",
    5: "initMemBlock8",
    6: "setRefAddRef",
    7: "memCopy",
    8: "releaseRef",
    9: "initMemBlockFromCstrReturnDest",
    10: "copyMemBlockData",
    11: "freeMemBlock",
    12: "copyStringMemBlock",
    13: "copyContextRefConditional",
    14: "isEmptyMemBlock",
    15: "cloneRef",
    16: "randU31",
    17: "copyContextRef38",
    18: "copyContextRef70",
    19: "copyContextRefD8",
    20: "copyContextRef18",
    22: "appVersionRef",
    23: "sdkVersionWord",
    24: "sdkIdentityCString",
    25: "getEnvironmentObject",
    26: "registryLookup",
    27: "xor8InPlaceKeyF8",
    28: "emptyStringCompareLowBit",
    30: "concatMemBlocks",
    31: "protoWireSize",
    32: "fillMemBlockFromByte",
    33: "protoWireWrite",
    34: "base64Decode",
    37: "copyMemBlock",
    38: "initMemBlockBySource",
    39: "httpClientJsonListPointer",
    40: "sharedRefAssignReturnDest",
    41: "argusSimon128_256",
    42: "packU16LE",
    43: "argusAes128CbcPkcs7",
    44: "base64Encode",
    45: "xor8InPlaceKeyE0",
    46: "xor8InPlaceKeyE8",
    47: "xor8InPlaceKeyF0",
    48: "shortHeaderTransform32",
    49: "buildShortHeaderPack36",
    50: "initMemBlockTriplet",
    51: "nativeGlobalSingletonPointer",
    52: "destroyMemBlockTriplet",
    53: "sharedRefAssignReturnDest",
    54: "substringMemBlock",
    55: "reserveMemBlock",
    56: "appendMemBlockByteReturnDest",
    57: "strtoull",
    59: "crc8Poly31Init0",
    60: "allocPrepareRaw",
    61: "sm3Digest",
    62: "sharedRefCloneNoReturn",
    65: "contextFlagE8",
    66: "clockRealtimeSeconds",
    67: "copyContextRefB0",
    68: "getpid",
    69: "copyContextRef28",
    70: "getppid",
    71: "getTpidrEl0",
    72: "readNativeGlobalU32Acquire",
    77: "crc32Ieee",
    79: "cjsonAddNumber",
    80: "readNativeGlobalU32A",
    81: "readNativeGlobalU32B",
    83: "readNativeGlobalU32C",
    85: "cjsonAddStringToObjectField",
    86: "urlsafeBase64DecodeCheck",
    87: "cjsonAddBoolToObjectField",
    88: "cjsonPrintUnformattedToRef",
    89: "clockRealtimeMillis",
    90: "protoWireSize",
    91: "protoWireWrite",
    92: "releaseLockGuard",
    93: "sharedRefReleaseNoReturn",
    94: "getThreadLocalObjectOut",
    95: "pthreadMutexLock",
    96: "lockedSharedRefAssign",
    97: "freeSlot4",
    98: "formatAllocString",
    99: "formatDefaultString",
    100: "formatStringToMemBlock",
    101: "asprintfOneArg",
}

# These notes are intentionally limited to observations established by a
# wrapper's static ABI and (where stated) a focused Unicorn2 trace.  They are
# emitted at the wrapper entry; no guessed function prototypes are applied.
SEMANTIC_NOTES: dict[int, str] = {
    9: "slot4 MEM_BLOCK receives C string slot5; wrapper returns destination in slot2.",
    16: "calls the once-seeded native rand() helper and writes its 31-bit result to slot2; it is not a runtime-singleton getter.",
    13: "slot4 hidden REF destination; slot5 context selects +0x08 or +0x80 by the proven positive count predicate; slot2 is preserved.",
    17: "copy locked shared REF from slot5 context +0x38 to hidden slot4; slot2 preserved.",
    18: "copy locked shared REF from slot5 context +0x70 to hidden slot4; slot2 preserved.",
    19: "copy locked shared REF from slot5 context +0xD8 to hidden slot4; slot2 preserved.",
    20: "copy locked shared REF from slot5 context +0x18 to hidden slot4; slot2 preserved.",
    22: "hidden X8/slot4 REF_MEM_BLOCK output only: calls Java MS.b(0x1000011), UTF-8 app-version MEM_BLOCK replaces slot4 REF; slot2 preserved. Host replacement requires explicit HostSdkIdentity350 input, never a default sample version.",
    23: "no managed input; guarded helper 0x5897C caches uint32 version word then zero-extends it to slot2. Observed 350.101 fixture v04.09.05/ml/android -> 0x04090500; host replacement is strict explicit identity input.",
    24: "no managed input; guarded helper 0x62260 returns cached raw C-string pointer in slot2. Helper 0x64338 formats observed v04.09.05-ml-android into native 64-byte cache; host replacement uses a stable bounded C-string allocation, not a native address claim.",
    28: "returns the native low-bit result of its empty-string comparison in slot2.",
    27: "raw in-place XOR-8: buf=slot4, len=(int32_t)slot5, buf[i]^=key[i&7] with key @0x2025F8; no terminator handling; returns slot4 in slot2.",
    31: "descriptor-backed protobuf-wire-compatible size pass: message slot4 -> exact byte count slot2; aliases CF90 through shared helper 0x11615C. Host replacement=yes is strictly the observed F5 schema +0x271AD8 semantic model, byte-checked only against its deterministic local fixture.",
    33: "descriptor-backed protobuf-wire-compatible write pass: message slot4, raw writable byte* slot5 -> final cursor/bytes written slot2; aliases CF91 through 0x1165B8; no capacity argument. Host replacement=yes is strictly the observed F5 schema +0x271AD8 semantic model; its mapped-output preflight is a host safety boundary, not native behavior.",
    39: "returns observed HTTP-client list interior pointer slot4+0x68 in slot2.",
    50: "initializes only proven MEM_BLOCK fields at slot4 +0x20/+0x38/+0x50; slot2 preserved.",
    51: "returns cached pointer of a once-initialized native 0x2D0 singleton in slot2; body remains opaque.",
    52: "destroys the proven MEM_BLOCK fields in reverse order +0x50/+0x38/+0x20; slot2 preserved.",
    53: "generic shared-REF assignment slot4=dst, slot5=src; returns destination in slot2.",
    55: "reserves slot4 MEM_BLOCK capacity using slot5 request; slot2 preserved.",
    56: "appends low byte of slot5 to slot4 MEM_BLOCK; returns destination in slot2.",
    45: "raw in-place XOR-8: buf=slot4, len=(int32_t)slot5, buf[i]^=key[i&7] with key @0x2025E0; no terminator handling; returns slot4 in slot2.",
    46: "raw in-place XOR-8: buf=slot4, len=(int32_t)slot5, buf[i]^=key[i&7] with key @0x2025E8; no terminator handling; returns slot4 in slot2.",
    47: "raw in-place XOR-8: buf=slot4, len=(int32_t)slot5, buf[i]^=key[i&7] with key @0x2025F0; no terminator handling; returns slot4 in slot2.",
    67: "copy locked shared REF from slot5 context +0xB0 to hidden slot4; slot2 preserved.",
    69: "copy locked shared REF from slot5 context +0x28 to hidden slot4; slot2 preserved.",
    71: "calls getTpidrEl0_350 (not pthread_self); focused trace proved X0 equals TPIDR_EL0; writes slot2.",
    72: "acquire-loads a 32-bit mutable SO global and zero-extends it to slot2.",
    77: "CRC-32/ISO-HDLC of slot4 MEM_BLOCK; result in slot2.",
    79: "cJSON_AddNumberToObject: cJSON object slot4, C-string key slot5, managed double-slot2; success bool to slot2.",
    83: "reads a 32-bit mutable SO global and zero-extends it to slot2.",
    85: "cJSON string item: object is *(void **)(slot4+8), key=slot5 C string, value=slot6 C string; success bool to slot2.",
    87: "cJSON bool item: object is *(void **)(slot4+8), key=slot5 C string, value=slot6&1; success bool to slot2.",
    88: "unformatted cJSON print of *(void **)(slot5+8), then assigns resulting shared string at slot4; slot2 preserved.",
    90: "same descriptor-backed protobuf-wire-compatible size wrapper/helper as CF31: message slot4 -> exact byte count slot2 through 0x11615C. Host replacement=yes is strictly the observed F8 schema +0x272080 semantic model, byte-checked only against its deterministic local fixture; it is not generic native message support.",
    91: "same descriptor-backed protobuf-wire-compatible write wrapper/helper as CF33: message slot4, raw writable byte* slot5 -> final cursor/bytes written slot2 through 0x1165B8; no capacity argument. Host replacement=yes is strictly the observed F8 schema +0x272080 semantic model; its mapped-output preflight is a host safety boundary, not native behavior.",
    92: "conditional lock-guard destructor; unlocks only when proven state dword +0x10 is zero; slot2 preserved.",
    94: "writes TLS-derived object pointer through *(void **)slot4; requires matching runtime state; slot2 preserved.",
    95: "direct pthread_mutex_lock(slot4); native W0 is written to slot2.",
    97: "direct free(slot4) through 0x1C2F48 -> free@plt; no slot2 write. It is not the F8 source-stream producer.",
    101: "direct asprintf((char **)slot4, (char *)slot5, slot6); returned signed W0 byte count is written to slot2.",
}

# These have an independent executable oracle, rather than merely a host-side
# model or static ABI recovery.  Do not promote this tier to other wrappers.
VECTOR_VERIFIED: dict[int, str] = {
    41: "SIMON128/256 + PKCS#7 oracle verified",
    43: "mode-1 AES-128-CBC + PKCS#7 oracle verified",
    48: "F17/Ladon and F13/Helios transform oracle verified",
}


def _load_manifest() -> list[dict[str, object]]:
    if not MANIFEST_PATH.is_file():
        raise RuntimeError(f"CF manifest not found: {MANIFEST_PATH}")
    rows = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    if not isinstance(rows, list) or len(rows) != 102:
        raise RuntimeError("expected exactly 102 CF records in the 350.101 manifest")
    for expected_index, row in enumerate(rows):
        if not isinstance(row, dict) or row.get("index") != expected_index:
            raise RuntimeError(f"manifest CF index mismatch at row {expected_index}")
        entry = row.get("entry")
        if not isinstance(entry, int) or entry <= 0:
            raise RuntimeError(f"manifest CF{expected_index:02d} has invalid entry: {entry!r}")
    return rows


def _symbol(index: int) -> str:
    label = SEMANTIC_LABELS.get(index, "nativeBindingUnknown")
    return f"managedCf{index:02d}_{label}_350"


def _try_name(ea: int, symbol: str) -> bool:
    old = ida_name.get_name(ea) or ""
    # Preserve names the analyst, an imported symbol file, or an earlier
    # evidence pass has already established.  IDA's default sub_* is safe to
    # replace.  A name we set ourselves is idempotent.
    if old and old != symbol and not old.startswith(("sub_", "loc_", "nullsub_")):
        ida_kernwin.msg(
            f"[managed-cf-350101] preserve existing name at 0x{ea:x}: {old}\n"
        )
        return False
    return bool(
        ida_name.set_name(
            ea,
            symbol,
            ida_name.SN_NOCHECK | ida_name.SN_NOWARN,
        )
    )


def _set_comment(ea: int, index: int, implemented: bool) -> None:
    runtime_state = "yes" if implemented else "no (entry only)"
    semantic = SEMANTIC_LABELS.get(index, "not recovered")
    lines = [
        (
            f"{COMMENT_PREFIX} CF{index:02d} native managed binding wrapper; "
            "registered by initManagedSignModuleLarge_350 (+0x1702b8)."
        ),
        f"ABI evidence: X0 is ManagedFrame350; runtime replacement={runtime_state}; semantic={semantic}.",
        "【中文】CF 原生 binding wrapper；入口来自 102 项静态注册表。未恢复项不可按名字推断语义。",
    ]
    note = SEMANTIC_NOTES.get(index)
    if note is not None:
        lines.append(f"Recovered ABI: {note}")
    if index in VECTOR_VERIFIED:
        lines.append(f"Validation: {VECTOR_VERIFIED[index]}.")
    lines.append(COMMENT_END)
    new_block = "\n".join(lines)
    old = ida_bytes.get_cmt(ea, True) or ""
    retained: list[str] = []
    replacing = False
    for line in old.splitlines():
        if line.startswith(COMMENT_PREFIX):
            replacing = True
        if not replacing:
            retained.append(line)
        if replacing and line == COMMENT_END:
            replacing = False
    ida_bytes.set_cmt(ea, "\n".join([*retained, new_block]), True)


def main() -> None:
    ida_auto.auto_wait()
    try:
        rows = _load_manifest()
    except Exception as exc:
        ida_kernwin.msg(f"[managed-cf-350101] aborted: {exc}\n")
        return

    image_base = int(ida_nalt.get_imagebase())
    renamed = 0
    commented = 0
    implemented = 0
    for row in rows:
        index = int(row["index"])
        entry = int(row["entry"])
        has_runtime = bool(row["implemented"])
        ea = image_base + entry
        if _try_name(ea, _symbol(index)):
            renamed += 1
        _set_comment(ea, index, has_runtime)
        commented += 1
        implemented += int(has_runtime)

    ida_kernwin.msg(
        f"[managed-cf-350101] applied {commented}/102 wrapper comments, "
        f"named {renamed}, runtime replacements {implemented}/102; "
        f"imagebase=0x{image_base:x}\n"
    )


if __name__ == "__main__":
    main()
