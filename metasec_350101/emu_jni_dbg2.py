#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ═══════════════════════════════════════════════════════════════════════
# 【已废弃 · 仅留档】本文件是 emu_jni.py 开发期的第 2 个调试迭代（dbg2）。
# 正式版本是 emu_jni.py（同目录），请直接使用它；本文件不要复用、不要维护。
# 保留原因：定位 BLR 间接调用解析与软陷阱处理时的中间现场。
# ═══════════════════════════════════════════════════════════════════════
"""
emu_jni.py — 受控模拟 MS.a 的 native 主体 0x12FCE0，记录全部 BLR 运行时解析目标。

目的：闭合 Round 5 报告里"最后一跳"——JNI 扁平化主体 133 个 BLR
间接调用点中，哪一个解析进签名族注册表。

方法（基于 emu.py 骨架改造）：
  1. 同样加载 ELF + 重定位 + PLT 导入 hook；
  2. 伪造 JNIEnv：VWIN 窗口（不映射），vtable 每项指向 VWIN+idx*16，
     取指落入窗口 = 一次 JNIEnv 调用，按槽号记录；
  3. 每个 BLR 指令站点：记录 (site, target)，然后「跳过调用」——
     X0 填入 FAKEOBJ（首 qword 指向 vtable 的假对象），使链式
     vtable 调用可以无限下钻而不需要真实对象；
  4. GetStringUTFChars（槽 168）特判返回真实字符串缓冲区，
     让 URL/header 字符串语义进入状态机；
  5. 多轮运行不同操作码（w0=op1），取 BLR 目标并集。

注意：跳过调用会让依赖返回值的状态机走错分支——这是"覆盖率优先"
策略，目标是解析 BLR 目标集合而非还原完整执行语义。
"""
import re, struct, sys, json
from unicorn import *
from unicorn.arm64_const import *

SO = "libmetasec_ml.so"
BASE = 0x100000000
JNI_BODY = 0x597D4           # 真正的扁平化调度器（0x12FCE0 只是完整性校验前缀，
                             # 校验失败仅上报不拦截，故直接从这里起步）
SCAN_END = 0x60858           # 到下一个已识别函数 sub_60858 为止（约 28KB 巨型调度器）

data = open(SO, "rb").read()

# ---------- PLT 名称表（同 emu.py） ----------
plt_name = {}
for line in open("full_disasm.txt", "r", errors="replace"):
    if "@plt>" in line:
        m = re.search(r"\bb(?:l)?\s+0x([0-9a-f]+)\s+<([-\w]+)@plt>", line)
        if m:
            a = int(m.group(1), 16)
            if 0x32E30 <= a < 0x33C20:
                plt_name[a] = m.group(2)
PLT_LO, PLT_HI = min(plt_name), max(plt_name) + 16

# ---------- ELF 装载 ----------
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

# ---------- 重定位 ----------
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

HOOKWIN = 0x500000000        # libc/pthread 导入窗口（不映射）
VWIN = 0x600000000           # JNIEnv vtable 窗口（不映射）
hook_idx2name, hook_count = {}, [0]
for r_sec_off, r_size in rela_secs:
    for i in range(r_size // 24):
        r_off, r_info, r_addend = struct.unpack("<QQq", data[r_sec_off + i * 24:r_sec_off + i * 24 + 24])
        r_type = r_info & 0xFFFFFFFF
        if r_type == 0x403:
            mu.mem_write(BASE + r_off, struct.pack("<Q", BASE + r_addend))
        elif r_type in (0x401, 0x402):
            name = sym_name(r_info >> 32) or "?"
            idx = hook_count[0]; hook_count[0] += 1
            hook_idx2name[idx] = name
            mu.mem_write(BASE + r_off, struct.pack("<Q", HOOKWIN + idx * 16))

# ---------- 内存区 ----------
TLS = 0x200000000
mu.mem_map(TLS, 0x10000, UC_PROT_ALL)
mu.mem_write(TLS + 0x28, struct.pack("<Q", 0xDEADBEEFCAFEBABE))
mu.reg_write(UC_ARM64_REG_TPIDR_EL0, TLS)
STACK = 0x300000000
mu.mem_map(STACK, 0x200000, UC_PROT_ALL)
mu.reg_write(UC_ARM64_REG_SP, STACK + 0x100000)
HEAP = 0x400000000
mu.mem_map(HEAP, 0x800000, UC_PROT_ALL)
heap_ptr = [HEAP]

def do_malloc(size):
    p = heap_ptr[0]
    heap_ptr[0] += (max(size, 1) + 15) & ~15
    return p

# JNIEnv 假 vtable：1024 槽，每槽指向 VWIN+idx*16（不映射，取指即捕获）
VTAB = do_malloc(1024 * 8)
for i in range(1024):
    mu.mem_write(VTAB + i * 8, struct.pack("<Q", VWIN + i * 16))
# FAKEOBJ：首 qword = VTAB 的通用假对象；env 也是它
FAKEOBJ = do_malloc(0x100)
mu.mem_write(FAKEOBJ, struct.pack("<Q", VTAB))
# GetStringUTFChars 返回的真实字符串
CANNED = do_malloc(0x200)
CANNED_STR = b"http://example.com/ri/report?device_id=1234567890&aid=1234\x00"
mu.mem_write(CANNED, CANNED_STR)

tls_keys, once_done = {}, set()

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

def ret_to_lr(val):
    mu.reg_write(UC_ARM64_REG_X0, val)
    mu.reg_write(UC_ARM64_REG_PC, mu.reg_read(UC_ARM64_REG_X30))

def handle_import(name, va):
    x0 = mu.reg_read(UC_ARM64_REG_X0)
    x1 = mu.reg_read(UC_ARM64_REG_X1)
    x2 = mu.reg_read(UC_ARM64_REG_X2)
    ret = 0
    if name == "malloc": ret = do_malloc(x0)
    elif name == "calloc": ret = do_malloc(x0 * max(x1, 1))
    elif name == "realloc": ret = do_malloc(x1)
    elif name == "free": ret = 0
    elif name in ("memcpy", "__memcpy_chk", "memmove", "__memmove_chk"):
        try: mu.mem_write(x0, bytes(mu.mem_read(x1, x2)))
        except UcError: pass
        ret = x0
    elif name == "memset":
        mu.mem_write(x0, bytes([x1 & 0xFF]) * x2); ret = x0
    elif name in ("strlen", "__strlen_chk"): ret = len(rd_str(x0))
    elif name in ("strcmp", "strcoll"):
        a, b = rd_str(x0), rd_str(x1); ret = (a > b) - (a < b)
    elif name == "strncmp":
        a, b = rd_str(x0, x2), rd_str(x1, x2); ret = (a > b) - (a < b)
    elif name == "strcpy":
        s = rd_str(x1); mu.mem_write(x0, s + b"\x00"); ret = x0
    elif name == "strdup":
        s = rd_str(x0); ret = do_malloc(len(s) + 1); mu.mem_write(ret, s + b"\x00")
    elif name in ("pthread_mutex_lock", "pthread_mutex_unlock",
                  "pthread_mutex_trylock", "pthread_rwlock_rdlock",
                  "pthread_rwlock_wrlock", "pthread_rwlock_unlock"): ret = 0
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
        # 模拟环境下金丝雀失配/abort 多为假对象语义副作用；
        # 覆盖优先策略：记录并返回 0 继续，不再中断模拟
        soft_traps.append((name, va))
        ret_to_lr(0)
        return
    ret_to_lr(ret)

# ---------- 跟踪状态 ----------
blr_hits = {}       # site_va -> set(target_va)
jni_calls = {}      # vtable slot -> count
bl_edges = {}       # site_va -> bl 目标（窗口内直接调用边）
pc_trace = []       # 最近 200 个 PC（调试早退）
state_trace = []    # 状态机转移序列（每次过分发点 0x59820 时的状态值）
zone_cov = {}       # 业务区覆盖计数: zone -> set(pc)
ZONES = {"sign_149": (0x149000, 0x151000), "orch_8d": (0x8C000, 0x91000),
         "registry_126": (0x126000, 0x127000), "header_419": (0x41900, 0x42000),
         "jni_onload_12f": (0x12F000, 0x130000)}
exec_count = [0]

def classify(t):
    """目标地址分类：镜像内偏移 / JNIEnv 槽 / 导入窗口 / 其他。"""
    if HOOKWIN <= t < HOOKWIN + hook_count[0] * 16:
        return ("import", hook_idx2name.get((t - HOOKWIN) // 16, "?"))
    if VWIN <= t < VWIN + 1024 * 16:
        return ("jni", (t - VWIN) // 16)
    if BASE + 0x33C20 <= t < BASE + hi:
        return ("image", t - BASE)
    return ("other", t)

def hook_code(mu_, addr, size, user):
    va = addr - BASE
    exec_count[0] += 1
    for zn, (zl, zh) in ZONES.items():
        if zl <= va < zh:
            zone_cov.setdefault(zn, set()).add(va)
            break
    if va == 0x59820:  # 调度器状态分发点：记录当前状态值
        sp = mu_.reg_read(UC_ARM64_REG_SP)
        try:
            st = struct.unpack("<I", mu_.mem_read(sp + 0x1C, 4))[0]
            state_trace.append(st)
        except UcError:
            pass
    if PLT_LO <= va < PLT_HI and va in plt_name:
        handle_import(plt_name[va], va)
        return
    if va == 0x131704:  # 调试：vtable slot 167 调用现场
        x20 = mu_.reg_read(UC_ARM64_REG_X20)
        try:
            vt = struct.unpack("<Q", mu_.mem_read(x20, 8))[0]
            slot = struct.unpack("<Q", mu_.mem_read(vt + 0x538, 8))[0]
        except UcError:
            vt = slot = -1
        print(f"  [0x131704 site] X20={x20:#x} vtab={vt:#x} slot167={slot:#x}",
              file=sys.stderr)
    # BLR 识别：AArch64 BLR = 0xD63F0000 | (Rn<<5)
    # 全局记录+跳过所有镜像内 BLR（不只调度器窗口）——覆盖率优先
    if BASE + 0x33C20 <= addr < BASE + hi:
        try:
            w = struct.unpack("<I", mu_.mem_read(addr, 4))[0]
        except UcError:
            return
        if JNI_BODY <= va < SCAN_END:
            pc_trace.append(va)
            if len(pc_trace) > 200:
                pc_trace.pop(0)
            if (w & 0xFFFFFC00) == 0x94000000:  # BL direct
                imm = w & 0x3FFFFFF
                if imm & 0x2000000:
                    imm -= 0x4000000
                bl_edges.setdefault(va, set()).add(va + imm * 4)
        if (w & 0xFFFFFC1F) == 0xD63F0000:
            rn = (w >> 5) & 0x1F
            t = mu_.reg_read(UC_ARM64_REG_X0 + rn)
            kind, detail = classify(t)
            blr_hits.setdefault(va, set()).add((kind, detail))
            if kind == "jni":
                jni_calls[detail] = jni_calls.get(detail, 0) + 1
            # 不跳过：镜像内目标真实执行（RET 自然返回），
            # VWIN/HOOKWIN 目标由 fetch-invalid 钩子接管

def hook_intr(mu_, intno, user):
    mu_.reg_write(UC_ARM64_REG_X0, 0)
    mu_.reg_write(UC_ARM64_REG_PC, mu_.reg_read(UC_ARM64_REG_PC) + 4)

def hook_invalid(mu_, user):
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    mu_.reg_write(UC_ARM64_REG_PC, pc + 4)
    return True

def hook_mem_invalid(mu_, access, address, size, value, user):
    print(f"  [mem_invalid access={access} addr={address:#x} pc={mu_.reg_read(UC_ARM64_REG_PC)-BASE:#x}]", file=sys.stderr)
    if access in (UC_MEM_READ_UNMAPPED, UC_MEM_WRITE_UNMAPPED):
        try:
            mu_.mem_map(address & ~0xFFF, 0x1000, UC_PROT_ALL)
            return True
        except UcError:
            return False
    return False

mu.hook_add(UC_HOOK_MEM_READ_UNMAPPED | UC_HOOK_MEM_WRITE_UNMAPPED, hook_mem_invalid)

nullcalls = []
soft_traps = []

def hook_fetch_invalid(mu_, access, address, size, value, user):
    if HOOKWIN <= address < HOOKWIN + hook_count[0] * 16:
        idx = (address - HOOKWIN) // 16
        handle_import(hook_idx2name.get(idx, "?"), address)
        return True
    if VWIN <= address < VWIN + 1024 * 16:
        slot = (address - VWIN) // 16
        jni_calls[slot] = jni_calls.get(slot, 0) + 1
        # GetStringUTFChars(168) 给真实字符串；其余给 FAKEOBJ
        ret_to_lr(CANNED if slot == 168 else FAKEOBJ)
        return True
    # 空调用兜底：取指到零页/垃圾地址 = 上游返回了空对象；
    # 记录并按"返回 0"处理（语义上等于该对象方法不可用）
    print(f"  [fetch_invalid addr={address:#x} lr={mu_.reg_read(UC_ARM64_REG_X30):#x}]", file=sys.stderr)
    nullcalls.append((hex(mu_.reg_read(UC_ARM64_REG_PC) - BASE), hex(address)))
    ret_to_lr(0)
    return True

mu.hook_add(UC_HOOK_CODE, hook_code)
mu.hook_add(UC_HOOK_INTR, hook_intr)
mu.hook_add(UC_HOOK_INSN_INVALID, hook_invalid)
mu.hook_add(UC_HOOK_MEM_FETCH_INVALID, hook_fetch_invalid)

# ---------- 运行 ----------
STOP = STACK + 0x1FF000

# 阶段 1：顺序执行全部 .init_array ctor（加载期初始化：解密明文库 +
# 注册表/全局状态填充——调度器的状态机依赖这些全局值）
INIT_ARRAY = 0x260190
INIT_COUNT = 116
ctor_ok, ctor_fail = 0, []
for i in range(INIT_COUNT):
    ctor = struct.unpack("<Q", mu.mem_read(BASE + INIT_ARRAY + i * 8, 8))[0]
    if ctor == 0:
        continue
    mu.reg_write(UC_ARM64_REG_X30, STOP)
    mu.reg_write(UC_ARM64_REG_SP, STACK + 0x100000)
    try:
        mu.emu_start(ctor, STOP, count=2000000)
        ctor_ok += 1
    except (UcError, RuntimeError) as e:
        pc = mu.reg_read(UC_ARM64_REG_PC)
        ctor_fail.append((i, hex(pc - BASE if pc >= BASE else pc), str(e)[:60]))
print(f"ctors ok={ctor_ok} fail={len(ctor_fail)}")
for c in ctor_fail[:12]:
    print("  ctor fail:", c)

# 阶段 2：保存初始化后的完整上下文，每个操作码组合恢复快照重跑
C0 = mu.context_save()
combos = [(int(a, 0), int(b, 0)) for a, b in
          (x.split(",") for x in sys.argv[1:])] if len(sys.argv) > 1 else \
         [(0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (0, 1), (1, 1)]

all_blr = {}
for op1, op2 in combos:
    mu.context_restore(C0)
    blr_hits.clear(); jni_calls.clear(); bl_edges.clear(); pc_trace.clear()
    state_trace.clear(); zone_cov.clear(); nullcalls.clear(); soft_traps.clear()
    exec_count[0] = 0
    mu.reg_write(UC_ARM64_REG_SP, STACK + 0x100000)
    mu.reg_write(UC_ARM64_REG_X0, op1)      # MS.a 第一个 int（操作码候选）
    mu.reg_write(UC_ARM64_REG_X1, FAKEOBJ)  # env
    mu.reg_write(UC_ARM64_REG_X2, op2)      # 第二个 int
    mu.reg_write(UC_ARM64_REG_X3, 0x123456789)  # long
    mu.reg_write(UC_ARM64_REG_X4, FAKEOBJ)  # jstring
    mu.reg_write(UC_ARM64_REG_X5, FAKEOBJ)  # jobject
    mu.reg_write(UC_ARM64_REG_X30, STOP)
    try:
        mu.emu_start(BASE + JNI_BODY, STOP, count=3000000)
        status = "returned"
    except UcError as e:
        pc = mu.reg_read(UC_ARM64_REG_PC)
        status = f"stop {e} @ {pc - BASE:#x}"
    except RuntimeError as e:
        status = f"trap {e}"
    print(f"\n== op1={op1} op2={op2}: {status}, insns={exec_count[0]}, "
          f"BLR sites={len(blr_hits)}, jni slots={dict(sorted(jni_calls.items()))}")
    print("   states:", [hex(s) for s in state_trace[:40]])
    print("   zones:", {z: len(pcs) for z, pcs in zone_cov.items()})
    if nullcalls:
        print(f"   nullcalls: {len(nullcalls)} first={nullcalls[:3]}")
    if soft_traps:
        print(f"   soft_traps: {len(soft_traps)} first={soft_traps[:3]}")
    ret = mu.reg_read(UC_ARM64_REG_X0)
    print(f"   ret x0={ret:#x}")
    for site, tgts in blr_hits.items():
        for kind, detail in tgts:
            all_blr.setdefault(site, set()).add((kind, detail))
            if kind == "image":
                print(f"   BLR @{site:#x} -> image {detail:#x}")
            elif kind == "jni":
                print(f"   BLR @{site:#x} -> JNIEnv slot {detail}")
            else:
                print(f"   BLR @{site:#x} -> {kind} {detail if isinstance(detail,int) else hex(detail)}")
    print("   last PCs:", [hex(p) for p in pc_trace[-8:]])

print(f"\n== TOTAL distinct BLR sites across runs: {len(all_blr)}")
json.dump({
    "combos": combos,
    "blr": {hex(s): sorted([[k, hex(v) if isinstance(v, int) else v] for k, v in ts])
            for s, ts in all_blr.items()},
}, open("emu_jni_blr_all.json", "w"), ensure_ascii=False, indent=1)
