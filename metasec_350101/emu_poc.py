#!/usr/bin/env python3
"""POC: emulate one string-decrypt function from libmetasec_ml.so with Unicorn.
Target: 0x12C9A4(buf, len) — call site 0x57DEC writes bytes 0x95 0x62 0x78 (len 3).

概念验证脚本（整个模拟方案的第一步）：
  只模拟执行一条字符串解密函数 0x12C9A4(buf, len)，验证
  「Unicorn 加载 .so + 手工重定位 + PLT 通用拦截」这条路走得通。
  调用点 0x57DEC 处的密文为 0x95 0x62 0x78（strh 0x6295 小端 + strb 0x78，len=3），
  期望解出 3 字节明文。
后续演进：emu_poc.py（本文件）→ emu.py（单条 CLI）→ batch_decrypt.py（批量）。
"""
import struct, sys
from unicorn import *
from unicorn.arm64_const import *

SO = "libmetasec_ml.so"
BASE = 0x100000000  # relocate image here（把 ELF 镜像整体映射到 4GB 处的固定基址）

data = open(SO, "rb").read()

# --- parse ELF program headers, collect PT_LOAD segments ---
# 解析 ELF 程序头表，收集所有 PT_LOAD 段（本 .so 仅 2 个：RX 代码段 + RW 数据段）
e_phoff = struct.unpack("<Q", data[0x20:0x28])[0]      # e_phoff：程序头表文件偏移
e_phentsize = struct.unpack("<H", data[0x36:0x38])[0]  # 每个程序头的大小（64 位 = 56 字节）
e_phnum = struct.unpack("<H", data[0x38:0x3a])[0]      # 程序头个数
segs = []
for i in range(e_phnum):
    off = e_phoff + i * e_phentsize
    p_type, p_flags, p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_align = struct.unpack(
        "<IIQQQQQQ", data[off:off + 56])
    if p_type == 1:  # PT_LOAD
        segs.append((p_vaddr, p_offset, p_filesz, p_memsz, p_flags))
print("PT_LOAD:", [(hex(s[0]), hex(s[3])) for s in segs])

mu = Uc(UC_ARCH_ARM64, UC_MODE_LITTLE_ENDIAN)

# 按所有 PT_LOAD 段的最低/最高虚拟地址（页对齐）一次性映射整片内存，
# 再把各段的文件内容写进去；filesz 之外的 bss 部分由 mem_map 自动填零
lo = min(s[0] for s in segs) & ~0xFFF
hi = max(s[0] + s[3] for s in segs)
hi = (hi + 0xFFF) & ~0xFFF
mu.mem_map(BASE + lo, hi - lo, UC_PROT_ALL)
for vaddr, off, filesz, memsz, flags in segs:
    mu.mem_write(BASE + vaddr, data[off:off + filesz])

# --- parse .dynamic to find .rela.dyn and apply R_AARCH64_RELATIVE ---
# 遍历节头表找 SHT_RELA 重定位节（.rela.dyn / .rela.plt），手工应用重定位。
# 本 POC 只处理 R_AARCH64_RELATIVE（*addr = BASE + addend）；
# GLOB_DAT/JUMP_SLOT（导入符号）先不精确处理，靠 PLT 通用拦截兜底。
e_shoff = struct.unpack("<Q", data[0x28:0x30])[0]      # e_shoff：节头表文件偏移
e_shentsize = struct.unpack("<H", data[0x3a:0x3c])[0]  # 每个节头的大小（64 位 = 64 字节）
e_shnum = struct.unpack("<H", data[0x3c:0x3e])[0]      # 节头个数
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
    for i in range(r_size // 24):                     # 每条 Elf64_Rela 24 字节
        r_off, r_info, r_addend = struct.unpack("<QQq", data[r_off_sec + i * 24:r_off_sec + i * 24 + 24])
        r_type = r_info & 0xFFFFFFFF                  # 低 32 位 = 重定位类型
        if r_type == 0x403:  # R_AARCH64_RELATIVE
            mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + r_addend))
            applied += 1
        else:
            other_types[r_type] = other_types.get(r_type, 0) + 1
print(f"relocs applied: {applied} RELATIVE; other: {other_types}")

# --- TLS with stack canary at +0x28 ---
# 伪造 TLS：代码里的 mrs TPIDR_EL0 会读线程指针，__stack_chk_guard 位于 TLS+0x28。
# 填入固定金丝雀值，保证函数尾声的栈校验（ldr x?, [TLS+0x28] 对比）不会失败。
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
# 极简 bump allocator：只往前挪指针，free 是空操作
HEAP = 0x400000000
mu.mem_map(HEAP, 0x100000, UC_PROT_ALL)
heap_ptr = [HEAP]

PLT_LO, PLT_HI = 0x32e30, 0x33c20  # plt vaddrs（.plt 节虚拟地址范围，来自节头表）

def do_malloc(mu, size):
    p = heap_ptr[0]
    heap_ptr[0] += (size + 15) & ~15                   # 16 字节对齐
    return p

def hook_code(mu, addr, size, user):
    va = addr - BASE
    # intercept PLT calls
    # POC 阶段的通用 PLT 拦截：不管调的是谁，
    # x0 像长度就回一块堆内存（模拟 malloc），否则返回 0
    if PLT_LO <= va < PLT_HI:
        # read which plt stub: just return a heap buffer / 0 generically
        x0 = mu.reg_read(UC_ARM64_REG_X0)
        ret = do_malloc(mu, max(x0, 0x100)) if x0 < 0x10000 else 0
        mu.reg_write(UC_ARM64_REG_X0, ret)
        lr = mu.reg_read(UC_ARM64_REG_X30)
        mu.reg_write(UC_ARM64_REG_PC, lr)              # 手动"函数返回"：PC <- LR
        return

def hook_intr(mu, intno, user):
    # svc #0 -> return 0
    # 库里内嵌 svc #0 直接系统调用（反 hook 手段）；
    # 模拟器里没有内核，统一返回 0 并跳过这条指令
    mu.reg_write(UC_ARM64_REG_X0, 0)
    pc = mu.reg_read(UC_ARM64_REG_PC)
    mu.reg_write(UC_ARM64_REG_PC, pc + 4)

def hook_invalid(mu, user):
    # 遇到无法译码的指令（混淆/坏字节）时打印并跳过，不让模拟中断
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
# 把 LR 设到镜像末尾的 STOP 哨兵地址：函数 ret 时 PC 落在 STOP，emu_start 即到点停止
STOP = BASE + hi - 4
mu.reg_write(UC_ARM64_REG_X0, buf)       # 参数 1：密文缓冲区
mu.reg_write(UC_ARM64_REG_X1, len(CT))   # 参数 2：长度
mu.reg_write(UC_ARM64_REG_X30, STOP)     # 伪返回地址

try:
    mu.emu_start(ENTRY, STOP, count=200000)
except UcError as e:
    pc = mu.reg_read(UC_ARM64_REG_PC)
    print(f"emu stopped: {e} @ pc={pc - BASE:#x}")

# 解密结果可能在返回值 x0 指向的新缓冲区，也可能原地写回入参 buf，两处都读出来看
res = mu.reg_read(UC_ARM64_REG_X0)
print(f"return x0 = {res:#x} (buf={buf:#x})")
for p, name in [(res, "x0"), (buf, "arg-buf")]:
    try:
        raw = mu.mem_read(p, 32)
        print(f"  {name}: {bytes(raw)!r}")
    except UcError:
        print(f"  {name}: unreadable")
