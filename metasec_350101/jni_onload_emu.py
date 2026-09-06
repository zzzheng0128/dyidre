#!/usr/bin/env python3
"""Emulate JNI_OnLoad of libmetasec_ml.so with a fake JavaVM/JNIEnv.

Records RegisterNatives calls (name, signature, fnPtr) and other JNI activity.
The library imports no JNI symbols: all JNI access goes through the JavaVM/JNIEnv
vtables we hand it, so every JNI interaction is observable.

JNI_OnLoad 全量模拟器（目标：还原动态注册的 native 方法表）：
  关键观察 —— 本 .so 不导入任何 JNI 符号（dynsym 里没有 FindClass/RegisterNatives），
  所有 JNI 调用都经过我们伪造的 JavaVM/JNIEnv vtable，因此每次 JNI 交互都可观测。
  vtable 每个槽位填 HOOKWIN 窗口地址，取指落进去时按槽位下标分发到 Python 实现。

  已知局限：完整跑通 JNI_OnLoad 会在 0x13B496 被「运行时代码解密 stub」
  （svc/NZCV 反模拟 + 明文写回后跳入 2 对齐地址）阻断。
  最终注册表是用「静态定位 + 局部模拟」混合方案拿到的，
  见报告附录 B 与 jni_onload_trace.json；本文件保留为可复用的 JNI 模拟骨架。
"""
import re, struct, sys, json
from unicorn import *
from unicorn.arm64_const import *

SO = "libmetasec_ml.so"
BASE = 0x100000000

data = open(SO, "rb").read()
lines = open("full_disasm.txt", "r", errors="replace").read().splitlines()

# ---------- ELF load ----------
# 映射全部 PT_LOAD 段 + 补 .bss（与 emu.py 相同）
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
BSS_END = (0x2BBD70 + 0xC490 + 0xFFF) & ~0xFFF
if BSS_END > hi:
    mu.mem_map(BASE + hi, BSS_END - hi, UC_PROT_ALL)

# ---------- plt name map ----------
# 从全量反汇编建立 PLT 存根地址 -> 导入函数名映射
plt_name = {}
for line in lines:
    if "@plt>" in line:
        m = re.search(r"\bb(?:l)?\s+0x([0-9a-f]+)\s+<([-\w]+)@plt>", line)
        if m:
            a = int(m.group(1), 16)
            if 0x32E30 <= a < 0x33C20:
                plt_name[a] = m.group(2)
PLT_LO, PLT_HI = min(plt_name), max(plt_name) + 16

# ---------- relocations + import hook window ----------
# 完整重定位（本版修复了 emu.py 的两个缺陷，是全量模拟能走到 GetEnv 的关键）：
#   1. 除 RELATIVE 外还处理 ABS64（0x101）——例如 GLOB_DAT @0x27CD68 指向 JNI_OnLoad 自身；
#   2. 符号在本库内有定义（st_shndx!=0 且 st_value!=0）时按 S + A 直接落地址，
#      只有未定义的外部导入才填 HOOKWIN。
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

# ── 结构速查 ─────────────────────────────────────────────────────────────
#   sym_info()/sym_name()  dynsym 查表（含 st_shndx，区分本库定义/外部导入）
#   new_hook()       生成 HOOKWIN 窗口桩地址（导入槽填这里，取指即拦截）
#   do_malloc()      堆模拟（bump 分配）
#   rd_str()         模拟器内存读 C 字符串
#   handle_jni()     JNIEnv vtable 槽号 → 语义模拟（JNI_NAMES 已知槽名，
#                    FindClass/GetMethodID/RegisterNatives 等；注册记录进 trace）
#   handle_javavm()  JavaVM vtable 槽号 → 语义模拟（AttachCurrentThread 等）
#   handle_import()  PLT 存根 → libc/pthread 模拟
#   hook_code()      取指回调：HOOKWIN/VWIN 命中分发
#   dump_trace()     把观测到的 JNI 活动写成 jni_onload_trace.json
#   run_func()       单函数模拟入口（设参 X0..X2，LR=STOP 哨兵）
# 已知边界：跑到 0x13B496 运行时代码解密 stub 会阻断（需先自解密），
#   注册表最终由静态+局部模拟混合方案取得，见 R0 报告附录 B。
# ────────────────────────────────────────────────────────────────────────
def sym_info(idx):
    """Return (name, st_shndx, st_value) for dynsym[idx]."""
    if not dynsym or not dynstr:
        return (None, 0, 0)
    so = dynsym[0] + idx * 24
    st_name, st_info_, st_other, st_shndx, st_value, st_size = struct.unpack(
        "<IBBHQQ", data[so:so + 24])
    end = data.find(b"\x00", dynstr[0] + st_name)
    name = data[dynstr[0] + st_name:end].decode("ascii", "replace")
    return (name, st_shndx, st_value)

def sym_name(idx):
    return sym_info(idx)[0]

HOOKWIN = 0x500000000
hook_idx2name = {}   # idx -> ("libc", name) or ("jni", idx) or ("javavm", idx)（三类可 hook 目标）
hook_count = [0]
def new_hook(tag):
    idx = hook_count[0]; hook_count[0] += 1
    hook_idx2name[idx] = tag
    return HOOKWIN + idx * 16

for r_sec_off, r_size in rela_secs:
    for i in range(r_size // 24):
        r_off, r_info, r_addend = struct.unpack("<QQq", data[r_sec_off + i * 24:r_sec_off + i * 24 + 24])
        r_type = r_info & 0xFFFFFFFF
        if r_type == 0x403:  # RELATIVE
            mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + r_addend))
        elif r_type in (0x101, 0x401, 0x402):  # ABS64 / GLOB_DAT / JUMP_SLOT
            nm, shndx, sval = sym_info(r_info >> 32)
            if shndx != 0 and sval != 0:
                # defined symbol (e.g. JNI_OnLoad itself): S + A
                mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + sval + r_addend))
            else:
                mu.mem_write(BASE + r_off, struct.pack("<Q", new_hook(("libc", nm or "?"))))

# ---------- regions ----------
TLS = 0x200000000
mu.mem_map(TLS, 0x10000, UC_PROT_ALL)
mu.mem_write(TLS + 0x28, struct.pack("<Q", 0xDEADBEEFCAFEBABE))   # 伪造栈金丝雀
mu.reg_write(UC_ARM64_REG_TPIDR_EL0, TLS)
STACK = 0x300000000
mu.mem_map(STACK, 0x200000, UC_PROT_ALL)
HEAP = 0x400000000
mu.mem_map(HEAP, 0x4000000, UC_PROT_ALL)
# hook window: mapped + NOP-filled so fetches into it never fault;
# dispatch happens in hook_code when PC lands inside the window.
# HOOKWIN 窗口：映射成 NOP 雪橇，取指落进来不 fault，由 hook_code 按槽位分发
mu.mem_map(HOOKWIN, 0x10000, UC_PROT_ALL)
mu.mem_write(HOOKWIN, struct.pack("<I", 0xD503201F) * (0x10000 // 4))
heap_ptr = [HEAP]
def do_malloc(size):
    p = heap_ptr[0]
    heap_ptr[0] += (max(size, 1) + 15) & ~15
    return p

tls_keys = {}
once_done = set()
jni_log = []   # 观测到的全部 JNI/JavaVM 活动，最终写入 jni_onload_trace.json

def rd_str(addr, n=512):
    """从模拟器内存读 C 字符串。"""
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

# ---------- fake JavaVM / JNIEnv ----------
# JNINativeInterface: 4 reserved + functions; JNIEnv index of interest:
#   6 FindClass, 215 RegisterNatives, 33 GetMethodID, 113 GetStaticMethodID,
#   167 NewStringUTF, 34 GetFieldID, 114 GetStaticFieldID, 26 NewObject ...
# 伪造 JNIEnv：240 槽 vtable，每槽一个 HOOKWIN 地址；JNIEnv* 指向该 vtable
NI = 240  # vtable slots we provide
jni_vtbl = do_malloc(NI * 8)
jni_env = do_malloc(8)
mu.mem_write(jni_env, struct.pack("<Q", jni_vtbl))
for idx in range(NI):
    mu.mem_write(jni_vtbl + idx * 8, struct.pack("<Q", new_hook(("jni", idx))))

# 伪造 JavaVM：8 槽 vtable（JNIInvokeInterface），同样全填 HOOKWIN
javavm_vtbl = do_malloc(8 * 8)
javavm = do_malloc(8)
mu.mem_write(javavm, struct.pack("<Q", javavm_vtbl))
for idx in range(8):
    mu.mem_write(javavm_vtbl + idx * 8, struct.pack("<Q", new_hook(("javavm", idx))))

next_handle = [0x700000000]
def fake_handle():
    """生成一个假的 jobject/jclass/jmethodID 句柄（只是一眼可辨的递增标记值）。"""
    next_handle[0] += 0x10
    return next_handle[0]

JNI_NAMES = {6: "FindClass", 33: "GetMethodID", 34: "GetFieldID", 113: "GetStaticMethodID",
             114: "GetStaticFieldID", 167: "NewStringUTF", 215: "RegisterNatives",
             35: "GetSuperclass", 94: "GetObjectClass", 96: "IsInstanceOf",
             107: "CallStaticObjectMethod", 29: "CallObjectMethod", 168: "GetStringUTFChars",
             169: "GetStringLength", 172: "ReleaseStringUTFChars", 176: "GetArrayLength",
             179: "NewObjectArray", 183: "GetObjectArrayElement", 195: "NewByteArray",
             200: "GetByteArrayElements", 202: "ReleaseByteArrayElements",
             216: "UnregisterNatives", 229: "GetJavaVM", 0: "reserved0"}
JAVAVM_NAMES = {3: "DestroyJavaVM", 4: "AttachCurrentThread", 5: "DetachCurrentThread",
                6: "GetEnv", 7: "AttachCurrentThreadAsDaemon"}

def handle_jni(idx, pc):
    """JNIEnv vtable 槽位被调用时的 Python 侧实现；把每次调用记进 jni_log。"""
    name = JNI_NAMES.get(idx, f"jni#{idx}")
    x1 = mu.reg_read(UC_ARM64_REG_X1)
    x2 = mu.reg_read(UC_ARM64_REG_X2)
    x3 = mu.reg_read(UC_ARM64_REG_X3)
    ret = 0
    if idx == 6:  # FindClass(env, name)
        cn = rd_str(x1).decode("utf-8", "replace")
        ret = fake_handle()
        jni_log.append({"fn": "FindClass", "name": cn, "handle": hex(ret)})
        print(f"  FindClass({cn!r}) -> {ret:#x}")
    elif idx == 215:  # RegisterNatives(env, clazz, methods, n)
        # 核心观测点：逐个读出 JNINativeMethod{name, signature, fnPtr} 三元组
        n = x3 & 0xFFFFFFFF
        methods = []
        for k in range(min(n, 64)):
            nm, sg, fn = struct.unpack("<QQQ", mu.mem_read(x2 + k * 24, 24))
            name_s = rd_str(nm).decode("utf-8", "replace")
            sig_s = rd_str(sg).decode("utf-8", "replace")
            fn_va = fn - BASE if fn >= BASE else fn
            methods.append({"name": name_s, "sig": sig_s, "fn": hex(fn_va)})
            print(f"  RegisterNatives: {name_s}{sig_s} -> {fn_va:#x}")
        jni_log.append({"fn": "RegisterNatives", "count": n, "methods": methods})
        ret = 0
    elif idx in (33, 113):  # GetMethodID / GetStaticMethodID (env, clazz, name, sig)
        nm = rd_str(x2).decode("utf-8", "replace")
        sg = rd_str(x3).decode("utf-8", "replace")
        ret = fake_handle()
        jni_log.append({"fn": name, "method": nm, "sig": sg, "mid": hex(ret)})
    elif idx in (34, 114):
        nm = rd_str(x2).decode("utf-8", "replace")
        ret = fake_handle()
        jni_log.append({"fn": name, "field": nm, "mid": hex(ret)})
    elif idx == 167:  # NewStringUTF
        s = rd_str(x1)
        ret = fake_handle()
        jni_log.append({"fn": "NewStringUTF", "str": s.decode("utf-8", "replace")[:80]})
    elif idx == 229:  # GetJavaVM(env, vm**)
        mu.mem_write(x1, struct.pack("<Q", javavm))
        ret = 0
    elif idx == 168:  # GetStringUTFChars -> empty string buf
        p = do_malloc(8); mu.mem_write(p, b"\x00")
        ret = p
    else:
        ret = 0
    mu.reg_write(UC_ARM64_REG_X0, ret)
    mu.reg_write(UC_ARM64_REG_PC, mu.reg_read(UC_ARM64_REG_X30))

def handle_javavm(idx):
    """JavaVM vtable 槽位的 Python 侧实现。"""
    name = JAVAVM_NAMES.get(idx, f"javavm#{idx}")
    x1 = mu.reg_read(UC_ARM64_REG_X1)
    x2 = mu.reg_read(UC_ARM64_REG_X2)
    ret = 0
    if idx == 6:  # GetEnv(vm, &env, version)——JNI_OnLoad 的第一个动作
        mu.mem_write(x1, struct.pack("<Q", jni_env))
        jni_log.append({"fn": "GetEnv", "version": hex(x2)})
        print(f"  GetEnv(version={x2:#x}) -> env")
        ret = 0
    elif idx in (4, 7):  # Attach -> give env
        mu.mem_write(x1, struct.pack("<Q", jni_env))
        ret = 0
    mu.reg_write(UC_ARM64_REG_X0, ret)
    mu.reg_write(UC_ARM64_REG_PC, mu.reg_read(UC_ARM64_REG_X30))

def handle_import(name, va):
    """libc/pthread 导入的 Python 侧实现（emu.py 同款，另加 dlopen/dlsym/pthread_create）。"""
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
        # do not actually run thread fn; pretend success（不真的跑线程函数，只记录入口地址）
        ret = 0
        jni_log.append({"fn": "pthread_create", "start_routine": hex(x2 - BASE if x2 >= BASE else x2)})
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
        print(f"  dlopen({rd_str(x0)!r})")
        ret = fake_handle()
    elif name == "dlsym":
        print(f"  dlsym({rd_str(x1)!r})")
        ret = new_hook(("libc", "dlsym_target"))
    elif name in ("__stack_chk_fail", "abort", "android_set_abort_message"):
        raise RuntimeError(f"{name} called from {va:#x}")
    mu.reg_write(UC_ARM64_REG_X0, ret)
    mu.reg_write(UC_ARM64_REG_PC, mu.reg_read(UC_ARM64_REG_X30))

from collections import deque
pc_trace = deque(maxlen=40)   # 最近 40 条 PC，崩溃时打印调用轨迹定位问题
def hook_code(mu_, addr, size, user):
    # 先判 HOOKWIN（libc / jni / javavm 三类分发），再记录 PC 轨迹，最后判 .plt
    if HOOKWIN <= addr < HOOKWIN + hook_count[0] * 16:
        tag = hook_idx2name.get((addr - HOOKWIN) // 16)
        if tag is not None:
            if tag[0] == "libc":
                handle_import(tag[1], addr)
            elif tag[0] == "jni":
                handle_jni(tag[1], addr)
            elif tag[0] == "javavm":
                handle_javavm(tag[1])
        return
    va = addr - BASE
    pc_trace.append(va)
    if PLT_LO <= va < PLT_HI and va in plt_name:
        handle_import(plt_name[va], va)

def dump_trace():
    print("  last PCs:", " -> ".join(hex(p) for p in list(pc_trace)[-40:]), file=sys.stderr)

def hook_intr(mu_, intno, user):
    # svc #0：返回 0 并跳过
    mu_.reg_write(UC_ARM64_REG_X0, 0)
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    mu_.reg_write(UC_ARM64_REG_PC, pc + 4)

def hook_invalid(mu_, user):
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    mu_.reg_write(UC_ARM64_REG_PC, pc + 4)
    return True

def hook_fetch_invalid(mu_, access, address, size, value, user):
    # 取指落进 HOOKWIN 的兜底分发（正常路径在 hook_code 已拦截，这里防御性保留）
    if HOOKWIN <= address < HOOKWIN + hook_count[0] * 16:
        tag = hook_idx2name.get((address - HOOKWIN) // 16)
        if tag is None:
            return False
        if tag[0] == "libc":
            handle_import(tag[1], address)
        elif tag[0] == "jni":
            handle_jni(tag[1], address)
        elif tag[0] == "javavm":
            handle_javavm(tag[1])
        return True
    return False

mu.hook_add(UC_HOOK_CODE, hook_code)
mu.hook_add(UC_HOOK_INTR, hook_intr)
mu.hook_add(UC_HOOK_INSN_INVALID, hook_invalid)
mu.hook_add(UC_HOOK_MEM_FETCH_INVALID, hook_fetch_invalid)

# ---------- run .init_array constructors first (like the dynamic linker) ----------
# 像动态链接器一样先跑 DT_INIT / DT_INIT_ARRAY 里的全部构造函数：
# 全局对象（注册表、字符串等）的初始化都在这里完成，跳过会导致后面读到空指针
def run_func(va, x0=0, x1=0, x2=0):
    STOP = STACK + 0x1FF000
    mu.reg_write(UC_ARM64_REG_SP, STACK + 0x100000)
    mu.reg_write(UC_ARM64_REG_X0, x0)
    mu.reg_write(UC_ARM64_REG_X1, x1)
    mu.reg_write(UC_ARM64_REG_X2, x2)
    mu.reg_write(UC_ARM64_REG_X30, STOP)
    mu.emu_start(BASE + va, STOP, count=5000000)

# parse PT_DYNAMIC for DT_INIT / DT_INIT_ARRAY
dyn = []
for i in range(e_phnum):
    off = e_phoff + i * e_phentsize
    p_type = struct.unpack("<I", data[off:off + 4])[0]
    if p_type == 2:
        p_offset, p_filesz = struct.unpack("<QQ", data[off + 8:off + 24])[0], struct.unpack("<Q", data[off + 32:off + 40])[0]
        for j in range(p_filesz // 16):
            tag, val = struct.unpack("<QQ", data[p_offset + j * 16:p_offset + j * 16 + 16])
            dyn.append((tag, val))
init_arr = init_sz = init_fn = None
for tag, val in dyn:
    if tag == 25: init_arr = val        # DT_INIT_ARRAY
    elif tag == 27: init_sz = val       # DT_INIT_ARRAYSZ
    elif tag == 12: init_fn = val       # DT_INIT
ctors = []
if init_fn:
    ctors.append(init_fn)
if init_arr and init_sz:
    for k in range(init_sz // 8):
        ctor = struct.unpack("<Q", mu.mem_read(BASE + init_arr + k * 8, 8))[0] - BASE
        ctors.append(ctor)
print(f"init_array: {len(ctors)} constructors", file=sys.stderr)
for c in ctors:
    try:
        run_func(c)
    except (UcError, RuntimeError) as e:
        pc = mu.reg_read(UC_ARM64_REG_PC)
        print(f"  ctor {c:#x} stopped: {e} @ {pc - BASE:#x}", file=sys.stderr)
        dump_trace()
        pc_trace.clear()

# ---------- run JNI_OnLoad(javavm, NULL) ----------
# 入口 JNI_OnLoad = 0x139BB0（唯一导出符号），x0 = 假 JavaVM*
STOP = STACK + 0x1FF000
mu.reg_write(UC_ARM64_REG_SP, STACK + 0x100000)
mu.reg_write(UC_ARM64_REG_X0, javavm)
mu.reg_write(UC_ARM64_REG_X1, 0)
mu.reg_write(UC_ARM64_REG_X30, STOP)
try:
    mu.emu_start(BASE + 0x139BB0, STOP, count=20000000)
    print("JNI_OnLoad returned")
except UcError as e:
    pc = mu.reg_read(UC_ARM64_REG_PC)
    print(f"emu stopped: {e} @ pc={pc - BASE:#x}", file=sys.stderr)
    print(f"  x0={mu.reg_read(UC_ARM64_REG_X0):#x} x1={mu.reg_read(UC_ARM64_REG_X1):#x} "
          f"x8={mu.reg_read(UC_ARM64_REG_X8):#x} x21={mu.reg_read(UC_ARM64_REG_X21):#x} "
          f"x24={mu.reg_read(UC_ARM64_REG_X24):#x} sp={mu.reg_read(UC_ARM64_REG_SP):#x} "
          f"x30={mu.reg_read(UC_ARM64_REG_X30):#x}", file=sys.stderr)
    dump_trace()
except RuntimeError as e:
    pc = mu.reg_read(UC_ARM64_REG_PC)
    print(f"trap: {e} @ pc={pc - BASE:#x}", file=sys.stderr)
    dump_trace()

print(f"\nreturn x0 = {mu.reg_read(UC_ARM64_REG_X0):#x}")
json.dump(jni_log, open("jni_onload_trace.json", "w"), indent=1)
print(f"jni_log entries: {len(jni_log)} -> jni_onload_trace.json")
