#!/usr/bin/env python3
"""Black-box algorithm extraction for libmetasec_ml.so's 5 string decryptors.

Feeds chosen inputs through each real function under Unicorn and infers the
exact per-byte transform (type + keystream), without deobfuscating the MBA.

Method per function f(buf,len):
  1. in = 0x00*N   -> out = K            (keystream if XOR-type)
  2. in = 0x01*N   -> check out^out_prev == 0x01 everywhere (XOR linearity)
  3. in = 0x02*N   -> confirms affine vs nonlinear
  4. prefix test len=32 vs len=64 -> does K depend on len?
Then prints the inferred recipe and K[0:64].

黑盒算法提取（不去手工还原 MBA 混淆，直接向真实函数"提问"）：
  结论：5 个解密桩全部是「单字节 XOR + 周期 8 固定密钥流」，与长度无关。
  详细结果见报告附录 C（libmetasec_ml_struct_report.md）与 extract_algo_output.txt。
"""
import struct, sys
from unicorn import *
from unicorn.arm64_const import *

SO = "libmetasec_ml.so"
BASE = 0x100000000
FUNCS = [0x12B904, 0x12BFA8, 0x12C648, 0x12C9A4, 0x12CF90]  # 5 个待提取的解密桩

data = open(SO, "rb").read()

# ---- ELF load ----
# 映射全部 PT_LOAD 段（与 emu.py 相同的加载流程）
e_phoff = struct.unpack("<Q", data[0x20:0x28])[0]
e_phnum = struct.unpack("<H", data[0x38:0x3a])[0]
segs = []
for i in range(e_phnum):
    off = e_phoff + i * 56
    p_type, p_flags, p_offset, p_vaddr, _, p_filesz, p_memsz, _ = struct.unpack("<IIQQQQQQ", data[off:off + 56])
    if p_type == 1:
        segs.append((p_vaddr, p_offset, p_filesz, p_memsz))
mu = Uc(UC_ARCH_ARM64, UC_MODE_LITTLE_ENDIAN)
lo = min(s[0] for s in segs) & ~0xFFF
hi = (max(s[0] + s[3] for s in segs) + 0xFFF) & ~0xFFF
mu.mem_map(BASE + lo, hi - lo, UC_PROT_ALL)
for vaddr, off, filesz, memsz in segs:
    mu.mem_write(BASE + vaddr, data[off:off + filesz])
BSS_END = (0x2BBD70 + 0xC490 + 0xFFF) & ~0xFFF
if BSS_END > hi:
    mu.mem_map(BASE + hi, BSS_END - hi, UC_PROT_ALL)

# ---- PLT name map ----
# 从全量反汇编建立 PLT 存根地址 -> 符号名映射
import re
plt_name = {}
for line in open("full_disasm.txt", "r", errors="replace"):
    if "@plt>" in line:
        m = re.search(r"\bb(?:l)?\s+0x([0-9a-f]+)\s+<([-\w]+)@plt>", line)
        if m:
            a = int(m.group(1), 16)
            if 0x32E30 <= a < 0x33C20:
                plt_name[a] = m.group(2)
PLT_LO, PLT_HI = min(plt_name), max(plt_name) + 16

# ---- relocations (full: RELATIVE + ABS64/GLOB_DAT/JUMP_SLOT) ----
# 完整重定位：除 RELATIVE 外还处理 ABS64（指向已定义符号的，如 JNI_OnLoad 自引用），
# 未定义导入填入 HOOKWIN 窗口地址
e_shoff = struct.unpack("<Q", data[0x28:0x30])[0]
e_shnum = struct.unpack("<H", data[0x3c:0x3e])[0]
e_shentsize = struct.unpack("<H", data[0x3a:0x3c])[0]
shdrs = [struct.unpack("<IIQQQQIIQQ", data[e_shoff + i * e_shentsize: e_shoff + (i + 1) * e_shentsize]) for i in range(e_shnum)]
rela_secs = [(s[4], s[5]) for s in shdrs if s[1] == 4]
dynsym = next(((s[4], s[5], s[6]) for s in shdrs if s[1] == 11), None)
dynstr = (shdrs[dynsym[2]][4], shdrs[dynsym[2]][5]) if dynsym else None

# ── 结构速查 ─────────────────────────────────────────────────────────────
#   sym_info()       dynsym 查表（名字/shndx/value）
#   new_hook()       HOOKWIN 窗口桩生成
#   do_malloc()      堆模拟；rd_str() 读串；handle_import() PLT 模拟
#   hook_code()      取指回调（HOOKWIN 命中 → 导入模拟）
#   hook_intr()      svc #0 → 0；hook_invalid() 未映射访问兜底
#   run_dec()        对单个解密桩喂一组 (密文, 长度) 并取回输出
# 提取协议（主流程，对 FUNCS 里 5 个桩逐个做）：
#   in=0x00*N → out=K（XOR 型直接得密钥流）
#   in=0x01*N → 验证线性（out^prev==0x01）
#   in=0x02*N → 区分仿射/非线性
#   len=32 vs 64 前缀对比 → 判密钥流是否与长度相关
# 结论：5 桩全为「XOR + 周期 8 密钥流」，key 与长度无关 →
#   离线复算无需模拟器（key 表见 R0 报告附录 C）。
# ────────────────────────────────────────────────────────────────────────
def sym_info(idx):
    """返回 dynsym[idx] 的 (名字, st_shndx, st_value)；shndx!=0 表示符号在本库内有定义。"""
    so = dynsym[0] + idx * 24
    st_name, st_info, st_other, st_shndx, st_value, st_size = struct.unpack("<IBBHQQ", data[so:so + 24])
    end = data.find(b"\x00", dynstr[0] + st_name)
    return data[dynstr[0] + st_name:end].decode("ascii", "replace"), st_shndx, st_value

HOOKWIN = 0x500000000
hook_idx2name = {}
hook_count = [0]
def new_hook(name):
    idx = hook_count[0]; hook_count[0] += 1
    hook_idx2name[idx] = name
    return HOOKWIN + idx * 16

for r_off_sec, r_size in rela_secs:
    for i in range(r_size // 24):
        r_off, r_info, r_add = struct.unpack("<QQq", data[r_off_sec + i * 24: r_off_sec + i * 24 + 24])
        rt = r_info & 0xFFFFFFFF
        if rt == 0x403:                              # RELATIVE
            mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + r_add))
        elif rt in (0x101, 0x401, 0x402):            # ABS64 / GLOB_DAT / JUMP_SLOT
            nm, shndx, sval = sym_info(r_info >> 32)
            if shndx != 0 and sval != 0:
                mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + sval + r_add))   # 本库内定义的符号：S + A
            else:
                mu.mem_write(BASE + r_off, struct.pack("<Q", new_hook(nm)))          # 外部导入：进 HOOKWIN

# ---- regions ----
# TLS（+0x28 金丝雀）/ 栈 / 堆 / HOOKWIN（NOP 雪橇填充，取指进来由 hook_code 分发）
TLS = 0x200000000
mu.mem_map(TLS, 0x10000, UC_PROT_ALL)
mu.mem_write(TLS + 0x28, struct.pack("<Q", 0xDEADBEEFCAFEBABE))
mu.reg_write(UC_ARM64_REG_TPIDR_EL0, TLS)
STACK = 0x300000000
mu.mem_map(STACK, 0x200000, UC_PROT_ALL)
HEAP = 0x400000000
mu.mem_map(HEAP, 0x400000, UC_PROT_ALL)
heap_ptr = [HEAP]
def do_malloc(n):
    p = heap_ptr[0]; heap_ptr[0] += (max(n, 1) + 15) & ~15; return p
mu.mem_map(HOOKWIN, 0x10000, UC_PROT_ALL)
mu.mem_write(HOOKWIN, struct.pack("<I", 0xD503201F) * (0x10000 // 4))  # NOP sled

tls_keys = {}; once_done = set()

def rd_str(addr, n=256):
    """从模拟器内存读 C 字符串。"""
    out = b""
    try:
        while len(out) < n:
            c = mu.mem_read(addr + len(out), 1)
            if c == b"\x00": break
            out += c
    except UcError:
        pass
    return bytes(out)

def handle_import(name, va):
    """按符号名模拟 libc/pthread 语义（与 emu.py 相同），然后返回到 LR。"""
    x0 = mu.reg_read(UC_ARM64_REG_X0); x1 = mu.reg_read(UC_ARM64_REG_X1); x2 = mu.reg_read(UC_ARM64_REG_X2)
    ret = 0
    if name == "malloc": ret = do_malloc(x0)
    elif name == "calloc": ret = do_malloc(x0 * max(x1, 1)); mu.mem_write(ret, b"\0" * min(x0 * max(x1, 1), 0x10000))
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
        s = rd_str(x1); mu.mem_write(x0, s + b"\0"); ret = x0
    elif name == "strdup":
        s = rd_str(x0); ret = do_malloc(len(s) + 1); mu.mem_write(ret, s + b"\0")
    elif name.startswith("pthread_mutex") or name.startswith("pthread_rwlock"): ret = 0
    elif name == "pthread_key_create":
        idx = len(tls_keys) + 8; tls_keys[idx] = 0
        try: mu.mem_write(x0, struct.pack("<I", idx))
        except UcError: pass
    elif name == "pthread_setspecific": tls_keys[x0] = x1
    elif name == "pthread_getspecific": ret = tls_keys.get(x0, 0)
    elif name == "pthread_self": ret = 1
    elif name == "pthread_once":
        if x0 not in once_done:
            once_done.add(x0)
            mu.reg_write(UC_ARM64_REG_PC, BASE + x1 if x1 < BASE else x1)
            return
    elif name in ("gettid", "getpid", "getppid"): ret = 1234
    elif name == "getpagesize": ret = 4096
    elif name == "time": ret = 1757000000
    elif name in ("__stack_chk_fail", "abort", "android_set_abort_message"):
        raise RuntimeError(f"{name} from {va:#x}")
    mu.reg_write(UC_ARM64_REG_X0, ret)
    mu.reg_write(UC_ARM64_REG_PC, mu.reg_read(UC_ARM64_REG_X30))

def hook_code(mu_, addr, size, user):
    # HOOKWIN 内按槽位分发；.plt 区间按名字分发
    if HOOKWIN <= addr < HOOKWIN + hook_count[0] * 16:
        handle_import(hook_idx2name.get((addr - HOOKWIN) // 16, "?"), addr)
        return
    va = addr - BASE
    if PLT_LO <= va < PLT_HI and va in plt_name:
        handle_import(plt_name[va], va)

def hook_intr(mu_, intno, user):
    # svc #0：返回 0 并跳过
    mu_.reg_write(UC_ARM64_REG_X0, 0)
    mu_.reg_write(UC_ARM64_REG_PC, mu_.reg_read(UC_ARM64_REG_PC) + 4)

def hook_invalid(mu_, user):
    mu_.reg_write(UC_ARM64_REG_PC, mu_.reg_read(UC_ARM64_REG_PC) + 4)
    return True

mu.hook_add(UC_HOOK_CODE, hook_code)
mu.hook_add(UC_HOOK_INTR, hook_intr)
mu.hook_add(UC_HOOK_INSN_INVALID, hook_invalid)

def run_dec(fn, ct, ln):
    """模拟执行一次解密函数 fn(buf, ln)，返回原地写回后的 buf 内容。"""
    buf = do_malloc(0x1000)
    mu.mem_write(buf, ct)
    STOP = STACK + 0x1FF000
    mu.reg_write(UC_ARM64_REG_SP, STACK + 0x100000)
    mu.reg_write(UC_ARM64_REG_X0, buf)
    mu.reg_write(UC_ARM64_REG_X1, ln)
    mu.reg_write(UC_ARM64_REG_X30, STOP)
    try:
        mu.emu_start(BASE + fn, STOP, count=2000000)
    except (UcError, RuntimeError) as e:
        print(f"  run err {fn:#x}: {e}", file=sys.stderr)
    return bytes(mu.mem_read(buf, ln))

# ---- extraction ----
# 对每个解密桩依次做 4 个探针实验
for fn in FUNCS:
    print(f"\n=== {fn:#x} ===")
    N = 64
    o0 = run_dec(fn, bytes(N), N)            # 探针 1：全 0x00 -> 输出即密钥流 K（若 XOR 型）
    o1 = run_dec(fn, bytes([1]) * N, N)      # 探针 2：全 0x01 -> 验证 XOR 线性
    o2 = run_dec(fn, bytes([2]) * N, N)      # 探针 3：全 0x02 -> 区分仿射/非线性
    diff01 = bytes(a ^ b for a, b in zip(o0, o1))
    diff02 = bytes(a ^ b for a, b in zip(o0, o2))
    xor_type = all(v == 1 for v in diff01) and all(v == 2 for v in diff02)
    print(f"  XOR-type: {xor_type}")
    if xor_type:
        K = o0
        # len-dependence: run len=32 with zeros
        # 探针 4：len=32 的输出应等于 len=64 的前 32 字节 -> 密钥流与长度无关
        o32 = run_dec(fn, bytes(32), 32)
        print(f"  K len-independent (first 32): {o32 == K[:32]}")
        print(f"  K[0:64] = {K.hex()}")
        # pattern analysis（密钥流模式识别：常量 / 等差 / 周期）
        if len(set(K)) == 1:
            print(f"  recipe: out[i] = in[i] ^ 0x{K[0]:02X}  (constant key)")
        else:
            diffs = [(K[i + 1] - K[i]) & 0xFF for i in range(N - 1)]
            if len(set(diffs)) == 1:
                print(f"  recipe: out[i] = in[i] ^ ((0x{K[0]:02X} + i*0x{diffs[0]:02X}) & 0xFF)  (arithmetic keystream)")
            else:
                for p in (2, 4, 8, 16, 32):
                    if K[:N - p] == K[p:N]:
                        print(f"  recipe: periodic keystream, period={p}: {K[:p].hex()}")
                        break
                else:
                    print(f"  recipe: non-trivial keystream (dump above)")
    else:
        print(f"  nonlinear; out(0x00*) = {o0.hex()}")
        print(f"           out(0x01*) = {o1.hex()}")
