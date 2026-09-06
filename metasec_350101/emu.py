#!/usr/bin/env python3
"""Unicorn-based emulation harness for libmetasec_ml.so string decryptors.

Usage: emu.py <func_vaddr_hex> <cipher_bytes_hex> <len>
Example: emu.py 12c9a4 956278 3

单条解密 CLI（emu_poc.py 的正式版）：
  对指定的解密函数地址 + 密文做一次模拟执行，打印明文。
  相对 POC 的改进：
    1. 从 full_disasm.txt 解析出 PLT 存根地址 -> 符号名的映射，
       按名字精确模拟 libc/pthread 语义（不再是 POC 的通用兜底）；
    2. GLOB_DAT/JUMP_SLOT 导入槽填入 HOOKWIN 窗口地址，
       通过「取指非法」回调分发到对应的 Python 实现；
    3. 覆盖 pthread_once / TLS key / clock_gettime 等更多导入。
"""
import re, struct, sys
from unicorn import *
from unicorn.arm64_const import *

SO = "libmetasec_ml.so"
BASE = 0x100000000   # 镜像加载基址（.so 内所有虚拟地址 + BASE = 模拟器中的实际地址）

data = open(SO, "rb").read()

# ---------- build PLT vaddr -> name map from objdump annotations ----------
# 从全量反汇编里扫描 "bl 0x32e30 <malloc@plt>" 这类注释行，
# 建立 PLT 存根地址 -> 导入函数名的映射；只保留真正落在 .plt 节内的地址
plt_name = {}
for m in re.finditer(rb"^\s+([0-9a-f]+):\s+.*<([^>]+)@plt>", open("full_disasm.txt","rb").read(), re.M):
    pass  # too slow on 400k lines in one regex; do line scan instead（400k 行上单条正则太慢，改为逐行扫描）
for line in open("full_disasm.txt", "r", errors="replace"):
    if "@plt>" in line:
        m = re.search(r"\bb(?:l)?\s+0x([0-9a-f]+)\s+<([-\w]+)@plt>", line)
        if m:
            a = int(m.group(1), 16)
            if 0x32E30 <= a < 0x33C20:  # real .plt section only（过滤同名的 bl 目标注释，只留 .plt 节内地址）
                plt_name[a] = m.group(2)
plt_addrs = sorted(plt_name)
PLT_LO, PLT_HI = min(plt_addrs), max(plt_addrs) + 16
print(f"plt stubs named: {len(plt_name)}, range {PLT_LO:#x}-{PLT_HI:#x}", file=sys.stderr)

# ---------- ELF load ----------
# 解析程序头表，映射全部 PT_LOAD 段
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
# .bss 末尾超出最后一个 PT_LOAD 的部分需要单独补映射（地址 0x2BBD70 / 大小 0xC490 来自节头表）
BSS_END = (0x2BBD70 + 0xC490 + 0xFFF) & ~0xFFF
if BSS_END > hi:
    mu.mem_map(BASE + hi, BSS_END - hi, UC_PROT_ALL)

# ---------- relocations ----------
# 解析节头表：收集 SHT_RELA 重定位节，同时定位 .dynsym / .dynstr 供符号名查询
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
        dynsym = (s_off, s_size, sh[6])  # link -> strtab index（sh_link 指向 .dynstr 节索引）
if dynsym:
    strsh = shdrs[dynsym[2]]
    dynstr = (strsh[4], strsh[5])

def sym_name(idx):
    """按 dynsym 下标取符号名（用于给导入槽命名）。"""
    if not dynsym or not dynstr:
        return None
    so = dynsym[0] + idx * 24                        # Elf64_Sym 24 字节
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
        if r_type == 0x403:  # RELATIVE（内部指针重定位：*slot = BASE + addend）
            mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + r_addend))
            applied += 1
        elif r_type in (0x401, 0x402):  # GLOB_DAT / JUMP_SLOT -> hook window（导入槽指向 HOOKWIN 窗口，由取指回调分发）
            name = sym_name(r_info >> 32) or "?"
            idx = hook_count[0]; hook_count[0] += 1
            hook_idx2name[idx] = name
            mu.mem_write(BASE + r_off, struct.pack("<Q", HOOKWIN + idx * 16))
print(f"RELATIVE relocs applied: {applied}; imports hooked: {hook_count[0]}", file=sys.stderr)

# ---------- memory regions ----------
# 伪造 TLS（+0x28 放栈金丝雀，保证 __stack_chk 校验通过）
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
    """极简 bump allocator：free 不回收，批量场景直接加大堆。"""
    p = heap_ptr[0]
    heap_ptr[0] += (max(size, 1) + 15) & ~15
    return p

tls_keys = {}    # pthread TLS key -> value
once_done = set()  # 已执行过的 pthread_once 控制块地址

def rd_str(addr, n=256):
    """从模拟器内存读 C 字符串（最多 n 字节，越界即停）。"""
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
    """按符号名在 Python 侧实现 libc/pthread 语义，然后手动返回到 LR。"""
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
        # 首次调用时直接跳进初始化函数执行（它 ret 时会回到调用点之后）
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
        # 栈校验失败 / abort 说明模拟状态跑偏了，抛异常暴露问题而不是默默继续
        raise RuntimeError(f"{name} called from {va:#x}")
    else:
        ret = 0
    mu.reg_write(UC_ARM64_REG_X0, ret)
    lr = mu.reg_read(UC_ARM64_REG_X30)
    mu.reg_write(UC_ARM64_REG_PC, lr)

trace_log = []
def hook_code(mu_, addr, size, user):
    """每条指令回调：PC 落进 .plt 地址区间时按名字分发到 handle_import。"""
    va = addr - BASE
    if PLT_LO <= va < PLT_HI and va in plt_name:
        handle_import(plt_name[va], va)

def hook_intr(mu_, intno, user):
    """svc #0（内联系统调用，反 hook 手段）：统一返回 0 并跳过。"""
    mu_.reg_write(UC_ARM64_REG_X0, 0)
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    mu_.reg_write(UC_ARM64_REG_PC, pc + 4)

def hook_invalid(mu_, user):
    """无法译码的指令：打印并跳过（混淆代码里的花指令等）。"""
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    print(f"  [skip undecodable @ {pc - BASE:#x}]", file=sys.stderr)
    mu_.reg_write(UC_ARM64_REG_PC, pc + 4)
    return True

mu.hook_add(UC_HOOK_CODE, hook_code)
mu.hook_add(UC_HOOK_INTR, hook_intr)
mu.hook_add(UC_HOOK_INSN_INVALID, hook_invalid)

def hook_fetch_invalid(mu_, access, address, size, value, user):
    """取指落在 HOOKWIN 窗口 = 调用了某个被 hook 的导入函数，按槽位下标分发。"""
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
    # 参数：解密函数地址（hex）、密文（hex 串）、长度；无参数时跑内置示例
    fn = int(sys.argv[1], 16) if len(sys.argv) > 1 else 0x12C9A4
    ct = bytes.fromhex(sys.argv[2]) if len(sys.argv) > 2 else bytes([0x95, 0x62, 0x78])
    ln = int(sys.argv[3]) if len(sys.argv) > 3 else len(ct)

    buf = do_malloc(0x1000)
    mu.mem_write(buf, ct)
    STOP = BASE + hi + 0x100000  # outside image -> we stop via emu_end marker instead
    # use a mapped-but-sentinel: put STOP at end of stack top page
    # 伪返回地址放在栈区顶部的哨兵位置：函数 ret 到 STOP 时 emu_start 正常结束
    STOP = STACK + 0x1FF000
    mu.reg_write(UC_ARM64_REG_X0, buf)     # 参数 1：密文缓冲区
    mu.reg_write(UC_ARM64_REG_X1, ln)      # 参数 2：长度
    mu.reg_write(UC_ARM64_REG_X30, STOP)   # LR <- 哨兵
    try:
        mu.emu_start(BASE + fn, STOP, count=2000000)
        print("emu completed (returned)")
    except UcError as e:
        pc = mu.reg_read(UC_ARM64_REG_PC)
        print(f"emu stopped: {e} @ pc={pc - BASE:#x}", file=sys.stderr)
    except RuntimeError as e:
        pc = mu.reg_read(UC_ARM64_REG_PC)
        print(f"trap: {e} @ pc={pc - BASE:#x}", file=sys.stderr)

    # 明文可能经 x0 返回新缓冲区，也可能原地写回 buf，两处都打印
    res = mu.reg_read(UC_ARM64_REG_X0)
    print(f"x0 = {res:#x}  buf = {buf:#x}")
    for p, name in [(res, "x0"), (buf, "buf")]:
        if p and HEAP <= p < HEAP + 0x400000:
            raw = bytes(mu.mem_read(p, 64))
            print(f"  {name}: {raw!r}  as-cstr: {rd_str(p)!r}")
