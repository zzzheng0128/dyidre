#!/usr/bin/env python3
"""Batch-extract encrypted string call sites and decrypt via one persistent Unicorn instance.

Site pattern (observed):
    mov w0, #len ; bl 0x1C2F40 (operator new[])
    mov w8, #imm / movk w8, #imm, lsl #N
    strb|strh|str w8/x8, [x0|x29|..., #off]
    mov w1, #len
    bl 0x<decryptor>

批量解密流水线（两个阶段）：
  pass 1  扫描 full_disasm.txt 中全部 5 个解密桩的调用点，
          从每个调用点往前做「迷你解释执行」（mov/movk/adrp/add/ldr/str 子集），
          把逐字节写入 new[] 缓冲的立即数重组出完整密文；
          也覆盖 add x0, xR, #off 直接指向 .rodata 密文的第二种模式。
  pass 2  用单个持久 Unicorn 实例（emu.py 同款骨架）顺序模拟解密所有站点，
          结果写入 decrypted_strings.json。
"""
import re, struct, sys, json
from unicorn import *
from unicorn.arm64_const import *

SO = "libmetasec_ml.so"
BASE = 0x100000000
DECRYPTORS = {0x12CF90, 0x12B904, 0x12BFA8, 0x12C648, 0x12C9A4}  # 5 个解密桩（各带独立密钥流）

lines = open("full_disasm.txt", "r", errors="replace").read().splitlines()

# ---------- pass 1: extract call sites ----------
insn_re = re.compile(r"^\s+([0-9a-f]+):\s+(\S+)\s*(.*)$")
imm_build = re.compile(r"^(mov|movk)\s+([wx]\d+),\s*#(-?0x[0-9a-f]+|\d+)(?:,\s*lsl\s*#(\d+))?")
store_re = re.compile(r"^(strb|strh|str|stur|sturb|sturh)\s+([wx]\d+),\s*\[([a-z]\d+|sp)(?:,\s*#(-?0x[0-9a-f]+|\d+))?")

sites = []
# ELF data for rodata reads
_data = open(SO, "rb").read()
# ── 结构速查 ─────────────────────────────────────────────────────────────
# pass 1（静态扫描）：遍历 full_disasm.txt，匹配「mov w0,#len; bl new[];
#   mov/movk 内联密文; strb/strh/str 写入; mov w1,#len; bl <decryptor>」
#   模式，提取站点地址 + 密文字节 → sites[]
# pass 2（模拟解密）：单个持久 Unicorn 实例逐站执行解密桩：
#   rodata_read()    按 VA 直读文件里的 .rodata 密文（首 PT_LOAD p_offset==0）
#   sym_name()       dynsym 下标 → 符号名（区分本库定义与外部导入）
#   do_malloc()      堆模拟：HEAP 窗口内 bump 分配
#   rd_str()         从模拟器内存读 C 字符串（打印/记录用）
#   handle_import()  PLT 存根分发：按符号名模拟 libc/pthread 语义
#   hook_code()      取指回调：命中 HOOKWIN 窗口 = 调用导入，转发 handle_import
#   hook_intr()      svc #0 → 统一返回 0（系统调用兜底）
#   hook_invalid()   未映射读写 → 补零页后继续（全局槽页宽容策略）
#   hook_fetch_invalid()  取指落到未映射页 → 视空调用，直接返 LR
# ────────────────────────────────────────────────────────────────────────
def rodata_read(va, n):
    """按虚拟地址直读 .rodata 密文（该 .so 首个 PT_LOAD 的 p_offset==0，故 vaddr==文件偏移）。"""
    # .rodata: vaddr 0x1DD860, size 0x2D909; file offset == vaddr (segment p_offset 0 for first load)
    if 0x1DD860 <= va < 0x1DD860 + 0x2D909:
        return _data[va:va + n]
    if va < 0x25EA20:  # anywhere in first PT_LOAD (p_offset==0)
        return _data[va:va + n]
    return None

for i, line in enumerate(lines):
    m = insn_re.match(line)
    if not m or m.group(2) != "bl":
        continue
    tm = re.match(r"0x([0-9a-f]+)", m.group(3).strip())
    if not tm:
        continue
    dec = int(tm.group(1), 16)
    if dec not in DECRYPTORS:
        continue
    site_addr = int(m.group(1), 16)
    # ---- find boundary: most recent operator new[] / new call before site ----
    # 向前找边界：密文写入区间的起点 = 最近一次 operator new[](0x1C2F40)/new(0x1C2EDC) 调用
    boundary = None
    for j in range(i - 1, max(i - 80, -1), -1):
        m2 = insn_re.match(lines[j])
        if not m2:
            continue
        if m2.group(2) in ("bl", "b"):
            t = m2.group(3).strip()
            if t.startswith("0x1c2f40") or t.startswith("0x1c2edc"):
                boundary = j
            elif not t.startswith("0x1c2f40"):
                # another call before any new[]: for immediate mode, stop here
                boundary = boundary if boundary is not None else -j  # negative = "other call" marker（负数 = 遇到的是其他调用，无 new[] 边界）
            break
    # ---- forward mini-interpret from boundary to site ----
    # 从边界到调用点做前向迷你解释执行，只跟踪解密相关的指令子集
    regs = {}      # w/x reg -> int（通用寄存器的已知常量值）
    fregs = {}     # d/q reg -> bytes（浮点寄存器：ldr d/q 从 .rodata 拷来的 8/16 字节密文块）
    retreg = "x0"  # register holding new[] result（保存 new[] 返回缓冲地址的寄存器，可能经 mov xR, x0 转移）
    stores = []    # (base, off, size, int|bytes)（所有对缓冲区的写入）
    length = None  # w1 = 解密长度参数
    x0_src = None  # 记录 x0 是否来自 add x0, xR, #off（.rodata 直指针模式）
    start = (boundary if boundary and boundary > 0 else i - 12) + 1
    for j in range(start, i):
        m2 = insn_re.match(lines[j])
        if not m2:
            continue
        op, args = m2.group(2), m2.group(3).strip()
        args = args.split("//")[0].strip()
        if op in ("mov", "movk", "movz"):
            # 立即数构造：mov/movz 整体赋值，movk 只改 16 位切片（lsl 移位）
            im = re.match(r"^([wx]\d+),\s*#(-?0x[0-9a-f]+|-?\d+)(?:,\s*lsl\s*#(\d+))?", args)
            if im:
                reg, vs, lsl = im.group(1), im.group(2), im.group(3)
                v = int(vs, 0)
                v &= 0xFFFF if op == "movk" else 0xFFFFFFFFFFFFFFFF
                shift = int(lsl) if lsl else 0
                if op in ("mov", "movz"):
                    regs[reg] = (v << shift) & (0xFFFFFFFF if reg.startswith("w") else 0xFFFFFFFFFFFFFFFF)
                else:
                    cur = regs.get(reg, 0)
                    mask = 0xFFFF << shift
                    regs[reg] = (cur & ~mask) | ((v << shift) & mask)
                if reg == "w1":
                    length = regs["w1"] & 0xFFFFFFFF
                continue
            mm = re.match(r"^(x\d+),\s*(x0)$", args)  # mov xR, x0 -> track new[] result（跟踪缓冲地址转移到哪个寄存器）
            if mm:
                retreg = mm.group(1)
                continue
            continue
        if op == "adrp":
            am = re.match(r"^(x\d+),\s*0x([0-9a-f]+)", args)
            if am:
                regs[am.group(1)] = int(am.group(2), 16)
                continue
        if op == "add":
            ad = re.match(r"^(x\d+),\s*(x\d+|sp),\s*#(0x[0-9a-f]+|\d+)", args)
            if ad:
                dst, src, off = ad.group(1), ad.group(2), int(ad.group(3), 0)
                if src in regs:
                    regs[dst] = regs[src] + off
                if dst == "x0":
                    x0_src = ("add", src, off, regs.get(src))
                continue
        if op == "ldr":
            # ldr dN/qN, [xR, #off]：从 .rodata 向量加载 8/16 字节密文块（配合 str d/q 写缓冲）
            lm = re.match(r"^([dq]\d+),\s*\[(x\d+)(?:,\s*#(0x[0-9a-f]+|\d+))?\]", args)
            if lm:
                reg, baser, off_s = lm.group(1), lm.group(2), lm.group(3)
                off = int(off_s, 0) if off_s else 0
                n = 8 if reg.startswith("d") else 16
                if baser in regs:
                    b = rodata_read(regs[baser] + off, n)
                    if b:
                        fregs[reg] = b
                continue
        if op in ("strb", "strh", "str", "stur", "sturb", "sturh"):
            # 写入缓冲：记录 (基址寄存器, 偏移, 字节数, 值/字节串)
            sm = re.match(r"^([wxdq]\d+),\s*\[([a-z]\d+|sp)(?:,\s*#(-?0x[0-9a-f]+|-?\d+))?", args)
            if sm:
                reg, base, off_s = sm.group(1), sm.group(2), sm.group(3)
                off = int(off_s, 0) if off_s else 0
                if reg.startswith(("d", "q")):
                    if reg in fregs:
                        stores.append((base, off, len(fregs[reg]), fregs[reg]))
                elif reg in regs:
                    size = {"strb": 1, "sturb": 1, "strh": 2, "sturh": 2,
                            "str": 8 if reg.startswith("x") else 4,
                            "stur": 8 if reg.startswith("x") else 4}[op]
                    stores.append((base, off, size, regs[reg]))
            continue
    # normalize stores: group by base reg, pick dominant
    # case B: x0 = resolvable rodata pointer (add x0, xR, #off)
    # 模式 B：没有任何写入，x0 直接指向 .rodata 密文
    if not stores and x0_src and x0_src[3] is not None and length:
        va = x0_src[3] + x0_src[2]
        b = rodata_read(va, length)
        if b:
            sites.append({"site": site_addr, "dec": dec, "len": length, "ct": b.hex(), "ok": True, "mode": "rodata-ptr"})
            continue
    # keep only writes to the new[] result register
    # 只保留写到 new[] 缓冲（retreg）的 store，按偏移拼出完整密文
    stores = [s for s in stores if s[0] == retreg]
    if not stores:
        sites.append({"site": site_addr, "dec": dec, "len": length, "ok": False, "why": "no-stores"})
        continue
    buf = {}
    for b, off, size, val in stores:
        if isinstance(val, bytes):
            for k, byte in enumerate(val):
                buf[off + k] = byte
        else:
            for k in range(size):
                buf[off + k] = (val >> (8 * k)) & 0xFF   # 小端拆分立即数
    if not buf:
        sites.append({"site": site_addr, "dec": dec, "len": length, "ok": False, "why": "no-bytes"})
        continue
    ct = bytes(buf.get(k, 0) for k in range(min(buf), max(buf) + 1))
    sites.append({"site": site_addr, "dec": dec, "len": length, "ct": ct.hex(), "ok": True})

print(f"call sites: {len(sites)}, extractable: {sum(1 for s in sites if s['ok'])}", file=sys.stderr)

# ---------- pass 2: unicorn setup (same as emu.py) ----------
# 以下为模拟器骨架，与 emu.py 相同：ELF 加载 / PLT 映射 / 重定位 / 导入 hook
data = open(SO, "rb").read()
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
BSS_END = (0x2BBD70 + 0xC490 + 0xFFF) & ~0xFFF   # .bss 超出 PT_LOAD 的部分补映射
if BSS_END > hi:
    mu.mem_map(BASE + hi, BSS_END - hi, UC_PROT_ALL)

plt_name = {}
for line in lines:
    if "@plt>" in line:
        m = re.search(r"\bb(?:l)?\s+0x([0-9a-f]+)\s+<([-\w]+)@plt>", line)
        if m:
            a = int(m.group(1), 16)
            if 0x32E30 <= a < 0x33C20:
                plt_name[a] = m.group(2)
plt_addrs = sorted(plt_name)
PLT_LO, PLT_HI = min(plt_addrs), max(plt_addrs) + 16

e_shoff = struct.unpack("<Q", data[0x28:0x30])[0]
e_shentsize = struct.unpack("<H", data[0x3a:0x3c])[0]
e_shnum = struct.unpack("<H", data[0x3c:0x3e])[0]
rela_secs, dynsym, dynstr = [], None, None
shdrs = []
for i in range(e_shnum):
    off = e_shoff + i * e_shentsize
    sh = struct.unpack("<IIQQQQIIQQ", data[off:off + 64])
    shdrs.append(sh)
    if sh[1] == 4:
        rela_secs.append((sh[4], sh[5]))
    elif sh[1] == 11:
        dynsym = (sh[4], sh[5], sh[6])
if dynsym:
    dynstr = (shdrs[dynsym[2]][4], shdrs[dynsym[2]][5])

def sym_name(idx):
    """按 dynsym 下标取符号名。"""
    if not dynsym or not dynstr:
        return None
    so = dynsym[0] + idx * 24
    st_name = struct.unpack("<I", data[so:so + 4])[0]
    end = data.find(b"\x00", dynstr[0] + st_name)
    return data[dynstr[0] + st_name:end].decode("ascii", "replace")

HOOKWIN = 0x500000000
hook_idx2name = {}
hook_count = [0]
for r_sec_off, r_size in rela_secs:
    for i in range(r_size // 24):
        r_off, r_info, r_addend = struct.unpack("<QQq", data[r_sec_off + i * 24:r_sec_off + i * 24 + 24])
        r_type = r_info & 0xFFFFFFFF
        if r_type == 0x403:                      # RELATIVE：内部指针重定位
            mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + r_addend))
        elif r_type in (0x401, 0x402):           # GLOB_DAT/JUMP_SLOT：导入槽指向 HOOKWIN
            idx = hook_count[0]; hook_count[0] += 1
            hook_idx2name[idx] = sym_name(r_info >> 32) or "?"
            mu.mem_write(BASE + r_off, struct.pack("<Q", HOOKWIN + idx * 16))

TLS = 0x200000000
mu.mem_map(TLS, 0x10000, UC_PROT_ALL)
mu.mem_write(TLS + 0x28, struct.pack("<Q", 0xDEADBEEFCAFEBABE))   # 伪造栈金丝雀
mu.reg_write(UC_ARM64_REG_TPIDR_EL0, TLS)
STACK = 0x300000000
mu.mem_map(STACK, 0x200000, UC_PROT_ALL)
HEAP = 0x400000000
mu.mem_map(HEAP, 0x4000000, UC_PROT_ALL)   # 批量场景堆加大到 64MB（bump allocator 不回收）
heap_ptr = [HEAP]

def do_malloc(size):
    p = heap_ptr[0]
    heap_ptr[0] += (max(size, 1) + 15) & ~15
    return p

tls_keys = {}
once_done = set()

def rd_str(addr, n=512):
    """从模拟器内存读 C 字符串。"""
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
    """按符号名模拟 libc/pthread 语义（与 emu.py 相同）。"""
    x0 = mu.reg_read(UC_ARM64_REG_X0); x1 = mu.reg_read(UC_ARM64_REG_X1); x2 = mu.reg_read(UC_ARM64_REG_X2)
    ret = 0
    if name == "malloc": ret = do_malloc(x0)
    elif name == "calloc":
        ret = do_malloc(x0 * max(x1, 1)); mu.mem_write(ret, b"\x00" * min(x0 * max(x1, 1), 0x10000))
    elif name == "realloc": ret = do_malloc(x1)
    elif name == "free": ret = 0
    elif name in ("memcpy", "__memcpy_chk", "memmove", "__memmove_chk"):
        try: mu.mem_write(x0, bytes(mu.mem_read(x1, x2)))
        except UcError: pass
        ret = x0
    elif name == "memset": mu.mem_write(x0, bytes([x1 & 0xFF]) * x2); ret = x0
    elif name in ("strlen", "__strlen_chk"): ret = len(rd_str(x0))
    elif name in ("strcmp", "strcoll"):
        a, b = rd_str(x0), rd_str(x1); ret = (a > b) - (a < b)
    elif name == "strncmp":
        a, b = rd_str(x0, x2), rd_str(x1, x2); ret = (a > b) - (a < b)
    elif name == "strcpy":
        s = rd_str(x1); mu.mem_write(x0, s + b"\x00"); ret = x0
    elif name == "strdup":
        s = rd_str(x0); ret = do_malloc(len(s) + 1); mu.mem_write(ret, s + b"\x00")
    elif name.startswith("pthread_mutex"): ret = 0
    elif name == "pthread_key_create":
        idx = len(tls_keys) + 8; tls_keys[idx] = 0
        try: mu.mem_write(x0, struct.pack("<I", idx))
        except UcError: pass
        ret = 0
    elif name == "pthread_setspecific": tls_keys[x0] = x1; ret = 0
    elif name == "pthread_getspecific": ret = tls_keys.get(x0, 0)
    elif name == "pthread_self": ret = 1
    elif name == "pthread_once":
        if x0 not in once_done:
            once_done.add(x0)
            mu.reg_write(UC_ARM64_REG_PC, BASE + x1 if x1 < BASE else x1)
            return
        ret = 0
    elif name in ("gettid", "getpid", "getppid"): ret = 1234
    elif name == "time": ret = 1757000000
    elif name == "clock_gettime":
        try: mu.mem_write(x1, struct.pack("<QQ", 1757000000, 0))
        except UcError: pass
        ret = 0
    elif name in ("__stack_chk_fail", "abort", "android_set_abort_message"):
        raise RuntimeError(f"{name} called from {va:#x}")
    mu.reg_write(UC_ARM64_REG_X0, ret)
    lr = mu.reg_read(UC_ARM64_REG_X30)
    mu.reg_write(UC_ARM64_REG_PC, lr)

def hook_code(mu_, addr, size, user):
    va = addr - BASE
    if PLT_LO <= va < PLT_HI and va in plt_name:
        handle_import(plt_name[va], va)

def hook_intr(mu_, intno, user):
    # svc #0 内联系统调用：返回 0 并跳过
    mu_.reg_write(UC_ARM64_REG_X0, 0)
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    mu_.reg_write(UC_ARM64_REG_PC, pc + 4)

def hook_invalid(mu_, user):
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    mu_.reg_write(UC_ARM64_REG_PC, pc + 4)
    return True

def hook_fetch_invalid(mu_, access, address, size, value, user):
    # 取指落进 HOOKWIN = 调用被 hook 的导入
    if HOOKWIN <= address < HOOKWIN + hook_count[0] * 16:
        idx = (address - HOOKWIN) // 16
        handle_import(hook_idx2name.get(idx, "?"), address)
        return True
    return False

mu.hook_add(UC_HOOK_CODE, hook_code)
mu.hook_add(UC_HOOK_INTR, hook_intr)
mu.hook_add(UC_HOOK_INSN_INVALID, hook_invalid)
mu.hook_add(UC_HOOK_MEM_FETCH_INVALID, hook_fetch_invalid)

# ---------- pass 2 主循环：单持久实例顺序解密全部站点 ----------
STOP = STACK + 0x1FF000   # 伪返回地址（LR 哨兵）
results = []
for s in sites:
    if not s["ok"]:
        s["pt"] = None
        results.append(s)
        continue
    ct = bytes.fromhex(s["ct"])
    buf = do_malloc(0x1000)
    mu.mem_write(buf, ct)
    mu.reg_write(UC_ARM64_REG_SP, STACK + 0x100000)
    mu.reg_write(UC_ARM64_REG_X0, buf)
    mu.reg_write(UC_ARM64_REG_X1, s["len"] if s["len"] else len(ct))
    mu.reg_write(UC_ARM64_REG_X30, STOP)
    try:
        mu.emu_start(BASE + s["dec"], STOP, count=500000)
        res = mu.reg_read(UC_ARM64_REG_X0)
        pt = rd_str(res) if res else rd_str(buf)   # 优先取返回值指向的新缓冲，否则读原地写回的入参
        s["pt"] = pt.decode("utf-8", "replace")
    except (UcError, RuntimeError) as e:
        s["pt"] = None
        s["why"] = f"emu: {e}"
    results.append(s)

json.dump(results, open("decrypted_strings.json", "w"), indent=1)
ok = [r for r in results if r.get("pt")]
print(f"decrypted: {len(ok)}/{len(results)}")
for r in ok[:40]:
    print(f"  {r['site']:#x} [{r['dec']:#x}] {r['pt']!r}")
