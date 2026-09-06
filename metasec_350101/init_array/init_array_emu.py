#!/usr/bin/env python3
"""init_array_emu.py — 全量模拟 libmetasec_ml.so 的 116 个 .init_array 构造函数，
逐项记录防护行为：

  * 5 个字符串解密函数（0x12B904/0x12BFA8/0x12C648/0x12C9A4/0x12CF90）的
    进/出口 hook：进入时取 (x0,w1) 密文，返回时读明文 —— 揭示该 ctor
    在运行期访问了哪些明文字符串（路径、特征名、检测关键字）；
  * svc #0 系统调用日志：x8=调用号 + x0-x3 参数（openat 路径、ptrace、
    prctl、mprotect 等），并返回良性值让执行继续；
  * brk 指令命中日志（反调试陷阱）；
  * 代码段写监控：.text 被写入 = 运行时代码解密/自修改；
  * 动态代码执行监控：PC 进入堆/栈 = 解密后的代码被跳入；
  * PLT 导入调用日志（dlopen/dlsym/pthread_create 等带参数）。

用法: python3 init_array_emu.py [start_idx] [end_idx]
输出: init_array_trace.json + 终端逐项日志
"""
import json, re, struct, sys
from unicorn import *
from unicorn.arm64_const import *

SO = "libmetasec_ml.so"
BASE = 0x100000000
DECRYPTORS = {0x12CF90, 0x12B904, 0x12BFA8, 0x12C648, 0x12C9A4}
TEXT_END = 0x25EA20

START = int(sys.argv[1]) if len(sys.argv) > 1 else 0
END   = int(sys.argv[2]) if len(sys.argv) > 2 else 999

data = open(SO, "rb").read()
lines = open("full_disasm.txt", "r", errors="replace").read().splitlines()

# ---------- ELF 加载 ----------
e_phoff = struct.unpack("<Q", data[0x20:0x28])[0]
e_phnum = struct.unpack_from("<H", data, 0x38)[0]
segs = []
for i in range(e_phnum):
    off = e_phoff + i * 56
    t, f, poff, va, _, fsz, msz, _ = struct.unpack("<IIQQQQQQ", data[off:off + 56])
    if t == 1:
        segs.append((va, poff, fsz, msz, f))

mu = Uc(UC_ARCH_ARM64, UC_MODE_LITTLE_ENDIAN)
lo = min(s[0] for s in segs) & ~0xFFF
hi = (max(s[0] + s[3] for s in segs) + 0xFFF) & ~0xFFF
mu.mem_map(BASE + lo, hi - lo, UC_PROT_ALL)
for va, off, fsz, msz, f in segs:
    mu.mem_write(BASE + va, data[off:off + fsz])
BSS_END = (0x2BBD70 + 0xC490 + 0xFFF) & ~0xFFF
if BSS_END > hi:
    mu.mem_map(BASE + hi, BSS_END - hi, UC_PROT_ALL)

# ---------- PLT 名字表 ----------
plt_name = {}
for line in lines:
    if "@plt>" in line:
        m = re.search(r"\bb(?:l)?\s+0x([0-9a-f]+)\s+<([-\w]+)@plt>", line)
        if m:
            a = int(m.group(1), 16)
            if 0x32E30 <= a < 0x33C20:
                plt_name[a] = m.group(2)
PLT_LO, PLT_HI = min(plt_name), max(plt_name) + 16

# ---------- 重定位 + 导入 hook 窗口 ----------
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

def sym_info(idx):
    if not dynsym or not dynstr:
        return (None, 0, 0)
    so = dynsym[0] + idx * 24
    st_name, _, _, st_shndx, st_value, _ = struct.unpack("<IBBHQQ", data[so:so + 24])
    end = data.find(b"\x00", dynstr[0] + st_name)
    return (data[dynstr[0] + st_name:end].decode("ascii", "replace"), st_shndx, st_value)

HOOKWIN = 0x500000000
hook_idx2name = {}
hook_count = [0]
def new_hook(tag):
    idx = hook_count[0]; hook_count[0] += 1
    hook_idx2name[idx] = tag
    return HOOKWIN + idx * 16

for r_sec_off, r_size in rela_secs:
    for i in range(r_size // 24):
        r_off, r_info, r_addend = struct.unpack("<QQq", data[r_sec_off + i * 24:r_sec_off + i * 24 + 24])
        r_type = r_info & 0xFFFFFFFF
        if r_type == 0x403:
            mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + r_addend))
        elif r_type in (0x101, 0x401, 0x402):
            nm, shndx, sval = sym_info(r_info >> 32)
            if shndx != 0 and sval != 0:
                mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + sval + r_addend))
            else:
                mu.mem_write(BASE + r_off, struct.pack("<Q", new_hook(("libc", nm or "?"))))

# ---------- 区域 ----------
TLS = 0x200000000
mu.mem_map(TLS, 0x10000, UC_PROT_ALL)
mu.mem_write(TLS + 0x28, struct.pack("<Q", 0xDEADBEEFCAFEBABE))
mu.reg_write(UC_ARM64_REG_TPIDR_EL0, TLS)
STACK = 0x300000000
mu.mem_map(STACK, 0x200000, UC_PROT_ALL)
HEAP = 0x400000000
mu.mem_map(HEAP, 0x4000000, UC_PROT_ALL)
mu.mem_map(HOOKWIN, 0x100000, UC_PROT_ALL)
mu.mem_write(HOOKWIN, struct.pack("<I", 0xD503201F) * (0x100000 // 4))
heap_ptr = [HEAP]
def do_malloc(size):
    p = heap_ptr[0]; heap_ptr[0] += (max(size, 1) + 15) & ~15
    return p

tls_keys = {}
once_done = set()

def rd_str(addr, n=512):
    out = b""
    if not addr:
        return b""
    try:
        while len(out) < n:
            c = mu.mem_read(addr + len(out), 1)
            if c == b"\x00":
                break
            out += c
    except UcError:
        pass
    return bytes(out)

# ---------- 每个 ctor 的日志 ----------
cur = None          # 当前 ctor 的日志 dict
trace = []
LOG_CAP = 100       # 每类事件每 ctor 最多落盘条数

def log(kind, **kw):
    if cur is None:
        return
    lst = cur.setdefault(kind, [])
    if len(lst) < LOG_CAP:
        lst.append(kw)
    else:
        cur[kind + "_overflow"] = cur.get(kind + "_overflow", 0) + 1

svc_seen = {}       # (pc, nr) -> count；同一 svc 点只打印前两次

# ---------- svc 系统调用 ----------
SVC_NAMES = {29:"ioctl",56:"openat",57:"close",63:"read",66:"write",78:"readlinkat",
             79:"fstat",80:"fstat",96:"set_tid_address",98:"futex",99:"set_robust_list",
             113:"clock_gettime",131:"tgkill",134:"rt_sigaction",135:"rt_sigprocmask",
             160:"uname",167:"prctl",172:"getpid",173:"getppid",174:"getuid",
             177:"getegid",215:"munmap",216:"mremap",222:"mmap",226:"mprotect",
             233:"madvise",261:"prlimit64",278:"getrandom",117:"ptrace",
             35:"unlinkat",46:"ftruncate",48:"faccessat",64:"writev",65:"pread64",
             260:"wait4",94:"exit_group",93:"exit",202:"futex",25:"mremap"}

def svc_ret(nr, x0):
    """给系统调用返回一个"一切正常"的良性值，让防护逻辑走正常路径。"""
    if nr in (172, 173, 174, 177, 96): return 1234
    if nr == 117: return 0          # ptrace 成功
    if nr in (56, 48): return -1    # openat/faccessat: 文件不存在（观察探测目标）
    if nr == 222:                   # mmap
        p = do_malloc(max(x0, 0x1000) * 4)
        return p
    if nr == 278:                   # getrandom: 由调用方缓冲，假装写满
        return x0
    return 0

def hook_intr(mu_, intno, user):
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    nr = mu_.reg_read(UC_ARM64_REG_X8)
    a0 = mu_.reg_read(UC_ARM64_REG_X0)
    a1 = mu_.reg_read(UC_ARM64_REG_X1)
    a2 = mu_.reg_read(UC_ARM64_REG_X2)
    a3 = mu_.reg_read(UC_ARM64_REG_X3)
    item = {"nr": nr, "name": SVC_NAMES.get(nr, "?"),
            "pc": hex(pc - BASE), "args": [hex(a0), hex(a1), hex(a2), hex(a3)]}
    # 对文件类调用记录路径字符串
    if nr in (56, 48, 78):
        item["path"] = rd_str(a1 if nr != 56 else a1).decode("utf-8", "replace")
    mu_.reg_write(UC_ARM64_REG_X0, svc_ret(nr, a0) & 0xFFFFFFFFFFFFFFFF)
    insn = struct.unpack("<I", mu_.mem_read(pc, 4))[0]
    if insn & 0xFFE0001F == 0xD4000001:
        mu_.reg_write(UC_ARM64_REG_PC, pc + 4)
    key = (pc, nr)
    n = svc_seen.get(key, 0)
    svc_seen[key] = n + 1
    if n == 0:
        log("svc", **item)
        print(f"    svc #{nr}({item['name']}) @ {pc - BASE:#x} "
              + (f"path={item['path']!r}" if "path" in item else
                 f"args=({a0:#x},{a1:#x},{a2:#x})"))
    elif n == 1:
        print(f"    svc #{nr}({item['name']}) @ {pc - BASE:#x} (重复，后续静默计数)")

# ---------- 解密函数进/出口 ----------
pending_dec = {}

def dec_entry(va):
    x0 = mu.reg_read(UC_ARM64_REG_X0)
    w1 = mu.reg_read(UC_ARM64_REG_X1) & 0xFFFFFFFF
    ln = w1 if 0 < w1 <= 0x1000 else 128
    try:
        ct = bytes(mu.mem_read(x0, ln))
    except UcError:
        ct = b""
    pending_dec[mu.reg_read(UC_ARM64_REG_X30)] = (va, ct, x0)

def dec_exit(addr):
    fn, ct, buf = pending_dec.pop(addr)
    try:
        raw = bytes(mu.mem_read(buf, 512))
    except UcError:
        raw = b""
    pt = raw.split(b"\0")[0]
    ct = ct[:len(pt)] if pt else ct
    if pt and all(0x20 <= b < 0x7F for b in pt):
        s = pt.decode()
        log("strings", fn=hex(fn), ct=ct.hex(), pt=s)
        print(f"    str: {s!r}")

# ---------- 导入调用 ----------
def handle_import(name, va):
    x0 = mu.reg_read(UC_ARM64_REG_X0)
    x1 = mu.reg_read(UC_ARM64_REG_X1)
    x2 = mu.reg_read(UC_ARM64_REG_X2)
    ret = 0
    detail = ""
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
        detail = f"({a!r} vs {b!r})"
    elif name == "memcmp":
        n = min(x2, 64)
        try:
            a = bytes(mu.mem_read(x0, n)); b = bytes(mu.mem_read(x1, n))
        except UcError:
            a = b = b""
        ret = 0 if a == b else 1
        detail = f"n={x2} a={a.hex()} b={b.hex()}"
    elif name == "syscall":
        detail = f"nr={x0} args=({x1:#x},{x2:#x},{mu.reg_read(UC_ARM64_REG_X3):#x})"
        ret = 0
    elif name == "strncmp":
        a, b = rd_str(x0, x2), rd_str(x1, x2); ret = (a > b) - (a < b)
        detail = f"({a!r} vs {b!r})"
    elif name in ("strstr", "strcasecmp"):
        a, b = rd_str(x0), rd_str(x1)
        ret = x0 if b in a else 0
        detail = f"({a!r} ~ {b!r})"
    elif name == "strcpy":
        s = rd_str(x1); mu.mem_write(x0, s + b"\x00"); ret = x0
    elif name == "strcat":
        a, s = rd_str(x0), rd_str(x1)
        mu.mem_write(x0 + len(a), s + b"\x00"); ret = x0
    elif name == "strdup":
        s = rd_str(x0); ret = do_malloc(len(s) + 1); mu.mem_write(ret, s + b"\x00")
    elif name == "snprintf" or name == "sprintf":
        ret = 0
    elif name.startswith("pthread_mutex") or name.startswith("pthread_rwlock") or name.startswith("pthread_cond"):
        ret = 0
    elif name == "pthread_key_create":
        idx = len(tls_keys) + 8; tls_keys[idx] = 0
        try: mu.mem_write(x0, struct.pack("<I", idx))
        except UcError: pass
        ret = 0
    elif name == "pthread_setspecific": tls_keys[x0] = x1; ret = 0
    elif name == "pthread_getspecific": ret = tls_keys.get(x0, 0)
    elif name == "pthread_self": ret = 1
    elif name == "pthread_create":
        detail = f"start_routine={x2 - BASE:#x}" if BASE <= x2 < BASE + 0x3000000 else f"start_routine={x2:#x}"
        log("imports", name=name, detail=detail)
        print(f"    import pthread_create({detail})")
        ret = 0
        mu.reg_write(UC_ARM64_REG_X0, ret)
        mu.reg_write(UC_ARM64_REG_PC, mu.reg_read(UC_ARM64_REG_X30))
        return
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
    elif name == "dlopen":
        detail = f"path={rd_str(x0)!r}"
        ret = 0x700000000
    elif name == "dladdr": ret = 0
    elif name == "dlsym":
        detail = f"sym={rd_str(x1)!r}"
        ret = new_hook(("libc", "dlsym_target"))
    elif name in ("__stack_chk_fail", "abort", "android_set_abort_message"):
        log("abort", name=name)
        print(f"    !!! {name} called —— 防护触发自毁")
        raise RuntimeError(name)
    elif name == "__android_log_print":
        detail = f"tag={rd_str(x1)!r} msg={rd_str(mu.reg_read(UC_ARM64_REG_X3))!r}"
        ret = 0
    QUIET = ("memcpy", "memset", "strlen", "__memcpy_chk", "memmove",
             "malloc", "free", "calloc", "realloc")
    if name in ("malloc", "calloc", "realloc", "free"):
        cur and cur.__setitem__("memops", cur.get("memops", 0) + 1)
    elif name not in QUIET:
        log("imports", name=name, detail=detail)
        print(f"    import {name}{detail}")
    mu.reg_write(UC_ARM64_REG_X0, ret & 0xFFFFFFFFFFFFFFFF)
    mu.reg_write(UC_ARM64_REG_PC, mu.reg_read(UC_ARM64_REG_X30))

# ---------- 主 code hook ----------
def hook_code(mu_, addr, size, user):
    if HOOKWIN <= addr < HOOKWIN + hook_count[0] * 16:
        tag = hook_idx2name.get((addr - HOOKWIN) // 16)
        if tag is not None and tag[0] == "libc":
            handle_import(tag[1], addr)
        return
    va = addr - BASE
    # 动态代码执行：PC 在堆/栈里 = 解密后的代码被跳入
    if HEAP <= addr < HEAP + 0x4000000 or STACK <= addr < STACK + 0x200000:
        if cur is not None and not cur.get("_dyn_exec"):
            cur["_dyn_exec"] = True
            log("dyn_exec", at=hex(addr))
            print(f"    !!! 执行堆/栈中的动态代码 @ {addr:#x}")
        return
    if va in DECRYPTORS:
        dec_entry(va)
        return
    if addr in pending_dec:
        dec_exit(addr)
        return
    # brk 陷阱（反调试）
    if size == 4 and va < TEXT_END:
        insn = struct.unpack("<I", mu.mem_read(addr, 4))[0]
        if insn & 0xFFE0001F == 0xD4200000:
            log("brk", at=hex(va))
            print(f"    !!! brk #{insn >> 5 & 0xFFFF} @ {va:#x} —— 反调试陷阱被踩到")
    if PLT_LO <= va < PLT_HI and va in plt_name:
        handle_import(plt_name[va], va)

# 代码段写监控：.text 被写 = 运行时代码解密/自修改
def hook_mem_write(mu_, access, address, size, value, user):
    if BASE <= address < BASE + TEXT_END:
        log("code_write", at=hex(address - BASE), size=size)
        if cur is not None and cur.get("_cw_first") is None:
            cur["_cw_first"] = address - BASE
            print(f"    !!! 写入代码段 @ {address - BASE:#x} ({size}B) —— 运行时代码解密/自修改")

mu.hook_add(UC_HOOK_CODE, hook_code)
mu.hook_add(UC_HOOK_INTR, hook_intr)
mu.hook_add(UC_HOOK_MEM_WRITE, hook_mem_write)
mu.hook_add(UC_HOOK_INSN_INVALID, lambda mu_, u: (mu_.reg_write(UC_ARM64_REG_PC, mu_.reg_read(UC_ARM64_REG_PC) + 4), True)[1])

# ---------- 解析 init_array ----------
dyn = None
for i in range(e_phnum):
    off = e_phoff + i * 56
    if struct.unpack("<I", data[off:off + 4])[0] == 2:
        dyn = struct.unpack("<Q", data[off + 8:off + 16])[0], struct.unpack("<Q", data[off + 32:off + 40])[0]
DT = {}
o = dyn[0]
while True:
    t, v = struct.unpack("<qQ", data[o:o + 16]); o += 16
    if t == 0: break
    DT.setdefault(t, []).append(v)
ia, iasz = DT[25][0], DT[27][0]
ctors = [struct.unpack("<Q", mu.mem_read(BASE + ia + k * 8, 8))[0] - BASE for k in range(iasz // 8)]
print(f"[init_array] {len(ctors)} ctors, range [{START}:{min(END, len(ctors))}]", file=sys.stderr)

STOP = STACK + 0x1FF000
for idx, c in enumerate(ctors):
    if not (START <= idx < min(END, len(ctors))):
        continue
    cur = {"idx": idx, "addr": hex(c)}
    trace.append(cur)
    print(f"[{idx:3d}] ctor @ {c:#x}")
    mu.reg_write(UC_ARM64_REG_SP, STACK + 0x100000)
    mu.reg_write(UC_ARM64_REG_X30, STOP)
    try:
        mu.emu_start(BASE + c, STOP, count=3000000)
        cur["ok"] = True
    except (UcError, RuntimeError) as e:
        pc = mu.reg_read(UC_ARM64_REG_PC)
        cur["ok"] = False
        cur["error"] = f"{e} @ {pc - BASE:#x}"
        print(f"    stopped: {e} @ {pc - BASE:#x}")
    cur.pop("_dyn_exec", None)
    cur.pop("_cw_first", None)
    json.dump(trace, open("init_array_trace.json", "w"), indent=1)  # 增量落盘

json.dump(trace, open("init_array_trace.json", "w"), indent=1)
print(f"\n[done] -> init_array_trace.json")
