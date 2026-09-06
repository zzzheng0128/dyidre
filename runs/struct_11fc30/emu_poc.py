#!/usr/bin/env python3
"""POC: emulate one string-decrypt function from libmetasec_ml.so with Unicorn.
Target: 0x12C9A4(buf, len) — call site 0x57DEC writes bytes 0x95 0x62 0x78 (len 3).
"""
import struct, sys
from unicorn import *
from unicorn.arm64_const import *

SO = "libmetasec_ml.so"
BASE = 0x100000000  # relocate image here

data = open(SO, "rb").read()

# --- parse ELF program headers, collect PT_LOAD segments ---
e_phoff = struct.unpack("<Q", data[0x20:0x28])[0]
e_phentsize = struct.unpack("<H", data[0x36:0x38])[0]
e_phnum = struct.unpack("<H", data[0x38:0x3a])[0]
segs = []
for i in range(e_phnum):
    off = e_phoff + i * e_phentsize
    p_type, p_flags, p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_align = struct.unpack(
        "<IIQQQQQQ", data[off:off + 56])
    if p_type == 1:  # PT_LOAD
        segs.append((p_vaddr, p_offset, p_filesz, p_memsz, p_flags))
print("PT_LOAD:", [(hex(s[0]), hex(s[3])) for s in segs])

mu = Uc(UC_ARCH_ARM64, UC_MODE_LITTLE_ENDIAN)

lo = min(s[0] for s in segs) & ~0xFFF
hi = max(s[0] + s[3] for s in segs)
hi = (hi + 0xFFF) & ~0xFFF
mu.mem_map(BASE + lo, hi - lo, UC_PROT_ALL)
for vaddr, off, filesz, memsz, flags in segs:
    mu.mem_write(BASE + vaddr, data[off:off + filesz])

# --- parse .dynamic to find .rela.dyn and apply R_AARCH64_RELATIVE ---
e_shoff = struct.unpack("<Q", data[0x28:0x30])[0]
e_shentsize = struct.unpack("<H", data[0x3a:0x3c])[0]
e_shnum = struct.unpack("<H", data[0x3c:0x3e])[0]
rela = []
for i in range(e_shnum):
    off = e_shoff + i * e_shentsize
    s_name, s_type, s_flags, s_addr, s_off, s_size = struct.unpack("<IIQQQQ", data[off:off + 40])
    if s_type == 4:  # SHT_RELA
        rela.append((s_off, s_size))
assert rela, "no SHT_RELA"
applied = 0
other_types = {}
for r_off_sec, r_size in rela:
    for i in range(r_size // 24):
        r_off, r_info, r_addend = struct.unpack("<QQq", data[r_off_sec + i * 24:r_off_sec + i * 24 + 24])
        r_type = r_info & 0xFFFFFFFF
        if r_type == 0x403:  # R_AARCH64_RELATIVE
            mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + r_addend))
            applied += 1
        else:
            other_types[r_type] = other_types.get(r_type, 0) + 1
print(f"relocs applied: {applied} RELATIVE; other: {other_types}")

# --- TLS with stack canary at +0x28 ---
TLS = 0x200000000
mu.mem_map(TLS, 0x10000, UC_PROT_ALL)
CANARY = 0xDEADBEEFCAFEBABE
mu.mem_write(TLS + 0x28, struct.pack("<Q", CANARY))
mu.reg_write(UC_ARM64_REG_TPIDR_EL0, TLS)

# --- stack ---
STACK = 0x300000000
mu.mem_map(STACK, 0x100000, UC_PROT_ALL)
mu.reg_write(UC_ARM64_REG_SP, STACK + 0x80000)

# --- heap for hooked malloc & friends ---
HEAP = 0x400000000
mu.mem_map(HEAP, 0x100000, UC_PROT_ALL)
heap_ptr = [HEAP]

PLT_LO, PLT_HI = 0x32e30, 0x33c20  # plt vaddrs

def do_malloc(mu, size):
    p = heap_ptr[0]
    heap_ptr[0] += (size + 15) & ~15
    return p

def hook_code(mu, addr, size, user):
    va = addr - BASE
    # intercept PLT calls
    if PLT_LO <= va < PLT_HI:
        # read which plt stub: just return a heap buffer / 0 generically
        x0 = mu.reg_read(UC_ARM64_REG_X0)
        ret = do_malloc(mu, max(x0, 0x100)) if x0 < 0x10000 else 0
        mu.reg_write(UC_ARM64_REG_X0, ret)
        lr = mu.reg_read(UC_ARM64_REG_X30)
        mu.reg_write(UC_ARM64_REG_PC, lr)
        return

def hook_intr(mu, intno, user):
    # svc #0 -> return 0
    mu.reg_write(UC_ARM64_REG_X0, 0)
    pc = mu.reg_read(UC_ARM64_REG_PC)
    mu.reg_write(UC_ARM64_REG_PC, pc + 4)

def hook_invalid(mu, user):
    pc = mu.reg_read(UC_ARM64_REG_PC)
    print(f"  [skip undecodable insn @ {pc - BASE:#x}]")
    mu.reg_write(UC_ARM64_REG_PC, pc + 4)
    return True

mu.hook_add(UC_HOOK_CODE, hook_code)
mu.hook_add(UC_HOOK_INTR, hook_intr)
mu.hook_add(UC_HOOK_INSN_INVALID, hook_invalid)

# --- prepare args: ciphertext buffer ---
CT = bytes([0x95, 0x62, 0x78])  # strh 0x6295 LE + strb 0x78, len=3
buf = do_malloc(mu, 0x100)
mu.mem_write(buf, CT)

ENTRY = BASE + 0x12C9A4
RET_MARK = BASE + hi + 0x1000  # unmapped-ish marker; use mapped end
# safer: set LR to a mapped address we stop at
STOP = BASE + hi - 4
mu.reg_write(UC_ARM64_REG_X0, buf)
mu.reg_write(UC_ARM64_REG_X1, len(CT))
mu.reg_write(UC_ARM64_REG_X30, STOP)

try:
    mu.emu_start(ENTRY, STOP, count=200000)
except UcError as e:
    pc = mu.reg_read(UC_ARM64_REG_PC)
    print(f"emu stopped: {e} @ pc={pc - BASE:#x}")

res = mu.reg_read(UC_ARM64_REG_X0)
print(f"return x0 = {res:#x} (buf={buf:#x})")
for p, name in [(res, "x0"), (buf, "arg-buf")]:
    try:
        raw = mu.mem_read(p, 32)
        print(f"  {name}: {bytes(raw)!r}")
    except UcError:
        print(f"  {name}: unreadable")
