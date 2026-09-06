#!/usr/bin/env python3
"""Unicorn-based emulation harness for libmetasec_ml.so string decryptors.

Usage: emu.py <func_vaddr_hex> <cipher_bytes_hex> <len>
Example: emu.py 12c9a4 956278 3
"""
import re, struct, sys
from unicorn import *
from unicorn.arm64_const import *

SO = "libmetasec_ml.so"
BASE = 0x100000000

data = open(SO, "rb").read()

# ---------- build PLT vaddr -> name map from objdump annotations ----------
plt_name = {}
for m in re.finditer(rb"^\s+([0-9a-f]+):\s+.*<([^>]+)@plt>", open("full_disasm.txt","rb").read(), re.M):
    pass  # too slow on 400k lines in one regex; do line scan instead
for line in open("full_disasm.txt", "r", errors="replace"):
    if "@plt>" in line:
        m = re.search(r"\bb(?:l)?\s+0x([0-9a-f]+)\s+<([-\w]+)@plt>", line)
        if m:
            a = int(m.group(1), 16)
            if 0x32E30 <= a < 0x33C20:  # real .plt section only
                plt_name[a] = m.group(2)
plt_addrs = sorted(plt_name)
PLT_LO, PLT_HI = min(plt_addrs), max(plt_addrs) + 16
print(f"plt stubs named: {len(plt_name)}, range {PLT_LO:#x}-{PLT_HI:#x}", file=sys.stderr)

# ---------- ELF load ----------
e_phoff = struct.unpack("<Q", data[0x20:0x28])[0]
e_phentsize = struct.unpack("<H", data[0x36:0x38])[0]
e_phnum = struct.unpack("<H", data[0x38:0x3a])[0]
segs = []
for i in range(e_phnum):
    off = e_phoff + i * e_phentsize
    p_type, p_flags, p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_align = struct.unpack(
        "<IIQQQQQQ", data[off:off + 56])
    if p_type == 1:
        segs.append((p_vaddr, p_offset, p_filesz, p_memsz, p_flags))

mu = Uc(UC_ARCH_ARM64, UC_MODE_LITTLE_ENDIAN)
lo = min(s[0] for s in segs) & ~0xFFF
hi = (max(s[0] + s[3] for s in segs) + 0xFFF) & ~0xFFF
mu.mem_map(BASE + lo, hi - lo, UC_PROT_ALL)
for vaddr, off, filesz, memsz, flags in segs:
    mu.mem_write(BASE + vaddr, data[off:off + filesz])
# bss beyond filesz is already zero (mem_map zero-fills) — but .bss may exceed last PT_LOAD
BSS_END = (0x2BBD70 + 0xC490 + 0xFFF) & ~0xFFF
if BSS_END > hi:
    mu.mem_map(BASE + hi, BSS_END - hi, UC_PROT_ALL)

# ---------- relocations ----------
e_shoff = struct.unpack("<Q", data[0x28:0x30])[0]
e_shentsize = struct.unpack("<H", data[0x3a:0x3c])[0]
e_shnum = struct.unpack("<H", data[0x3c:0x3e])[0]
rela_secs = []
dynsym = dynstr = None
shdrs = []
for i in range(e_shnum):
    off = e_shoff + i * e_shentsize
    sh = struct.unpack("<IIQQQQIIQQ", data[off:off + 64])
    shdrs.append(sh)
    s_name, s_type, s_flags, s_addr, s_off, s_size = sh[0], sh[1], sh[3], sh[4], sh[4], sh[5]
    if s_type == 4:
        rela_secs.append((s_off, s_size))
    elif s_type == 11:  # SHT_DYNSYM
        dynsym = (s_off, s_size, sh[6])  # link -> strtab index
if dynsym:
    strsh = shdrs[dynsym[2]]
    dynstr = (strsh[4], strsh[5])

def sym_name(idx):
    if not dynsym or not dynstr:
        return None
    so = dynsym[0] + idx * 24
    if so + 24 > dynsym[0] + dynsym[1]:
        return None
    st_name = struct.unpack("<I", data[so:so + 4])[0]
    end = data.find(b"\x00", dynstr[0] + st_name)
    return data[dynstr[0] + st_name:end].decode("ascii", "replace")

HOOKWIN = 0x500000000
hook_idx2name = {}
hook_count = [0]
applied = 0
for r_sec_off, r_size in rela_secs:
    for i in range(r_size // 24):
        r_off, r_info, r_addend = struct.unpack("<QQq", data[r_sec_off + i * 24:r_sec_off + i * 24 + 24])
        r_type = r_info & 0xFFFFFFFF
        if r_type == 0x403:  # RELATIVE
            mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + r_addend))
            applied += 1
        elif r_type in (0x401, 0x402):  # GLOB_DAT / JUMP_SLOT -> hook window
            name = sym_name(r_info >> 32) or "?"
            idx = hook_count[0]; hook_count[0] += 1
            hook_idx2name[idx] = name
            mu.mem_write(BASE + r_off, struct.pack("<Q", HOOKWIN + idx * 16))
print(f"RELATIVE relocs applied: {applied}; imports hooked: {hook_count[0]}", file=sys.stderr)

# ---------- memory regions ----------
TLS = 0x200000000
mu.mem_map(TLS, 0x10000, UC_PROT_ALL)
mu.mem_write(TLS + 0x28, struct.pack("<Q", 0xDEADBEEFCAFEBABE))
mu.reg_write(UC_ARM64_REG_TPIDR_EL0, TLS)

STACK = 0x300000000
mu.mem_map(STACK, 0x200000, UC_PROT_ALL)
mu.reg_write(UC_ARM64_REG_SP, STACK + 0x100000)

HEAP = 0x400000000
mu.mem_map(HEAP, 0x400000, UC_PROT_ALL)
heap_ptr = [HEAP]

HOOKWIN = 0x500000000   # unmapped on purpose: hooks redirect here? keep unmapped->we never jump here
def do_malloc(size):
    p = heap_ptr[0]
    heap_ptr[0] += (max(size, 1) + 15) & ~15
    return p

tls_keys = {}
once_done = set()

def rd_str(addr, n=256):
    out = b""
    try:
        while len(out) < n:
            c = mu.mem_read(addr + len(out), 1)
            if c == b"\x00":
                break
            out += c
    except UcError:
        pass
    return bytes(out)

def handle_import(name, va):
    x0 = mu.reg_read(UC_ARM64_REG_X0)
    x1 = mu.reg_read(UC_ARM64_REG_X1)
    x2 = mu.reg_read(UC_ARM64_REG_X2)
    ret = 0
    if name == "malloc":
        ret = do_malloc(x0)
    elif name == "calloc":
        ret = do_malloc(x0 * max(x1,1)); mu.mem_write(ret, b"\x00" * min(x0*max(x1,1), 0x10000))
    elif name == "realloc":
        ret = do_malloc(x1)
    elif name == "free":
        ret = 0
    elif name == "memcpy" or name == "__memcpy_chk" or name == "memmove" or name == "__memmove_chk":
        n = x2 if name in ("memcpy", "memmove") else x2
        try: mu.mem_write(x0, bytes(mu.mem_read(x1, n)))
        except UcError: pass
        ret = x0
    elif name == "memset":
        mu.mem_write(x0, bytes([x1 & 0xFF]) * x2); ret = x0
    elif name == "strlen" or name == "__strlen_chk":
        ret = len(rd_str(x0))
    elif name == "strcmp" or name == "strcoll":
        a, b = rd_str(x0), rd_str(x1)
        ret = (a > b) - (a < b)
    elif name == "strncmp":
        a, b = rd_str(x0, x2), rd_str(x1, x2)
        ret = (a > b) - (a < b)
    elif name == "strcpy":
        s = rd_str(x1); mu.mem_write(x0, s + b"\x00"); ret = x0
    elif name == "strdup":
        s = rd_str(x0); ret = do_malloc(len(s) + 1); mu.mem_write(ret, s + b"\x00")
    elif name == "pthread_mutex_lock" or name == "pthread_mutex_unlock" or name == "pthread_mutex_trylock":
        ret = 0
    elif name == "pthread_key_create":
        idx = len(tls_keys) + 8
        tls_keys[idx] = 0
        try: mu.mem_write(x0, struct.pack("<I", idx))
        except UcError: pass
        ret = 0
    elif name == "pthread_setspecific":
        tls_keys[x0] = x1; ret = 0
    elif name == "pthread_getspecific":
        ret = tls_keys.get(x0, 0)
    elif name == "pthread_self":
        ret = 1
    elif name == "pthread_once":
        # execute init routine x1 inline by jumping to it; it will ret to our caller
        if x0 not in once_done:
            once_done.add(x0)
            mu.reg_write(UC_ARM64_REG_PC, BASE + x1 if x1 < BASE else x1)
            return
        ret = 0
    elif name == "gettid" or name == "getpid" or name == "getppid":
        ret = 1234
    elif name == "time":
        ret = 1757000000
    elif name == "clock_gettime":
        try: mu.mem_write(x1, struct.pack("<QQ", 1757000000, 0))
        except UcError: pass
        ret = 0
    elif name == "__stack_chk_fail" or name == "abort" or name == "android_set_abort_message":
        raise RuntimeError(f"{name} called from {va:#x}")
    else:
        ret = 0
    mu.reg_write(UC_ARM64_REG_X0, ret)
    lr = mu.reg_read(UC_ARM64_REG_X30)
    mu.reg_write(UC_ARM64_REG_PC, lr)

trace_log = []
def hook_code(mu_, addr, size, user):
    va = addr - BASE
    if PLT_LO <= va < PLT_HI and va in plt_name:
        handle_import(plt_name[va], va)

def hook_intr(mu_, intno, user):
    mu_.reg_write(UC_ARM64_REG_X0, 0)
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    mu_.reg_write(UC_ARM64_REG_PC, pc + 4)

def hook_invalid(mu_, user):
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    print(f"  [skip undecodable @ {pc - BASE:#x}]", file=sys.stderr)
    mu_.reg_write(UC_ARM64_REG_PC, pc + 4)
    return True

mu.hook_add(UC_HOOK_CODE, hook_code)
mu.hook_add(UC_HOOK_INTR, hook_intr)
mu.hook_add(UC_HOOK_INSN_INVALID, hook_invalid)

def hook_fetch_invalid(mu_, access, address, size, value, user):
    if HOOKWIN <= address < HOOKWIN + hook_count[0] * 16:
        idx = (address - HOOKWIN) // 16
        handle_import(hook_idx2name.get(idx, "?"), address)
        return True
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    print(f"  [bad fetch @ {address:#x} pc={pc - BASE:#x}]", file=sys.stderr)
    return False

mu.hook_add(UC_HOOK_MEM_FETCH_INVALID, hook_fetch_invalid)

# ---------- run ----------
if __name__ == "__main__":
    fn = int(sys.argv[1], 16) if len(sys.argv) > 1 else 0x12C9A4
    ct = bytes.fromhex(sys.argv[2]) if len(sys.argv) > 2 else bytes([0x95, 0x62, 0x78])
    ln = int(sys.argv[3]) if len(sys.argv) > 3 else len(ct)

    buf = do_malloc(0x1000)
    mu.mem_write(buf, ct)
    STOP = BASE + hi + 0x100000  # outside image -> we stop via emu_end marker instead
    # use a mapped-but-sentinel: put STOP at end of stack top page
    STOP = STACK + 0x1FF000
    mu.reg_write(UC_ARM64_REG_X0, buf)
    mu.reg_write(UC_ARM64_REG_X1, ln)
    mu.reg_write(UC_ARM64_REG_X30, STOP)
    try:
        mu.emu_start(BASE + fn, STOP, count=2000000)
        print("emu completed (returned)")
    except UcError as e:
        pc = mu.reg_read(UC_ARM64_REG_PC)
        print(f"emu stopped: {e} @ pc={pc - BASE:#x}", file=sys.stderr)
    except RuntimeError as e:
        pc = mu.reg_read(UC_ARM64_REG_PC)
        print(f"trap: {e} @ pc={pc - BASE:#x}", file=sys.stderr)

    res = mu.reg_read(UC_ARM64_REG_X0)
    print(f"x0 = {res:#x}  buf = {buf:#x}")
    for p, name in [(res, "x0"), (buf, "buf")]:
        if p and HEAP <= p < HEAP + 0x400000:
            raw = bytes(mu.mem_read(p, 64))
            print(f"  {name}: {raw!r}  as-cstr: {rd_str(p)!r}")
