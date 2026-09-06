#!/usr/bin/env python3
"""analyze_mock.py — libmock.so 的独立分析器，使用与分析 libmetasec_ml.so
完全相同的两种方法。

  方法 1（字符串还原）：先在反汇编里用启发式定位解密函数族（被 bl 调用、
  函数体含 eor 且从 x0 缓冲 ldrb），然后在 Unicorn 下模拟宿主函数、
  hook 解密函数的进/出口：进入时从 (x0, w1) 读密文，返回后按 NUL 读明文。
  ——对应真 .so 分析中的 batch_decrypt.py / emu.py。

  方法 2（JNI 注册表还原）：构造假 JavaVM/JNIEnv（vtable 槽指向 NOP hook
  窗口），模拟执行 JNI_OnLoad，在 Python 侧分发 GetEnv/FindClass/
  RegisterNatives/NewStringUTF，参数完全可观测；随后递归模拟每个注册的
  fnPtr，收集 native 方法内部的解密字符串。
  ——对应真 .so 分析中的 jni_onload_emu.py。

  对加固版（v2）新增防护的穿透原理：
  * 立即数展开（IMM 模式，密文不经 .rodata）：本脚本读的是解密函数
    **入口处运行时的缓冲内容**，密文是立即数写栈还是 rodata 拷贝
    对观测毫无影响 —— 无需任何改动。
  * CRC 自校验：模拟器加载的是未被篡改的 .text，校验自然通过；
    这正说明 CRC 对抗的是"代码被 patch"的场景，而不是动态观测。
    （可用 /tmp/libmock_patched.so 演示：改 1 字节后 JNI_OnLoad 返回 -1。）
  * 已知局限：crc32_self 函数体同样含 eor+ldrb，会被启发式误报为
    解密函数（真实分析中启发式误报很常见，人工看函数体即可排除）。
  * 反模拟检查（v3）：svc #0 系统调用探测在 Unicorn 下抛
    UC_ERR_EXCEPTION 使模拟中止（Unicorn 无内核）。攻击方跟进手法：
    UC_HOOK_INTR 接管 svc，伪造 syscall 返回值并按需把 PC 跳过 svc
    指令 —— 见 hook_intr()。NZCV 回读校验对 Unicorn 无效
    （Unicorn 忠实实现了 NZCV 语义），该探针针对的是更弱的模拟器。
  * 运行时代码解密（v5/v6，payload 用后重加密）：明文只存在于
    unlock_payload() 写回之后、seal_payload() 重加密之前的窗口内。
    攻击方跟进手法：seal 必须先 mprotect 把页改成 RW 才能 XOR，
    所以在 hook_intr 里监视 nr==226 —— 每次 mprotect 调用时检查目标
    区域内容，一旦非全零（即明文窗口）立刻整段 dump 落盘。
    "用后即封"只是把明文窗口从"全程"压缩到"一次调用"，并没有消灭它。

用法: python3 analyze_mock.py [libmock.so]     ->  mock_analysis.json
                                                    payload_plaintext.bin
"""
import json, os, re, struct, subprocess, sys
from unicorn import *
from unicorn.arm64_const import *

SO = sys.argv[1] if len(sys.argv) > 1 else "libmock.so"
data = open(SO, "rb").read()

# ---------- ELF parse (program headers + dynamic segment; no shdr needed) --
e_phoff = struct.unpack("<Q", data[0x20:0x28])[0]
e_phnum = struct.unpack("<H", data[0x38:0x3A])[0]
segs, dyn = [], None
for i in range(e_phnum):
    o = e_phoff + i * 56
    p_type, p_flags, p_offset, p_vaddr, _, p_filesz, p_memsz, _ = struct.unpack("<IIQQQQQQ", data[o:o + 56])
    if p_type == 1:
        segs.append((p_vaddr, p_offset, p_filesz, p_memsz))
    elif p_type == 2:
        dyn = (p_offset, p_filesz)

def v2o(v):
    for va, fo, sz, msz in segs:
        if va <= v < va + sz:
            return fo + (v - va)
    return None

DT = {}
o = dyn[0]
while True:
    t, v = struct.unpack("<qQ", data[o:o + 16]); o += 16
    if t == 0: break
    DT.setdefault(t, []).append(v)
symtab_va, strtab_va = DT[6][0], DT[5][0]

exports = {}
i = 1
while True:
    try:
        o = v2o(symtab_va) + i * 24
        st_name, st_info, st_other, st_shndx, st_value, st_size = struct.unpack("<IBBHQQ", data[o:o + 24])
        if st_name == 0:
            break
        so = v2o(strtab_va) + st_name
        e = data.index(b"\0", so)
        exports[data[so:e].decode()] = st_value
        i += 1
    except Exception:
        break
print(f"[elf] {SO}: {len(segs)} PT_LOAD, exports: {exports}")

# ---------- disassemble ----------
raw = subprocess.run(["objdump", "-d", SO], capture_output=True, text=True).stdout
INSN = []
for line in raw.splitlines():
    m = re.match(r"\s+([0-9a-f]+):\s+(?:[0-9a-f]{8}\s+)?\t(.*)", line)
    if m:
        INSN.append((int(m.group(1), 16), m.group(2).strip()))
IDX = {a: k for k, (a, _) in enumerate(INSN)}
print(f"[disasm] {len(INSN)} instructions")

# ---------- locate the decryptor family (static heuristic) ----------
def func_body(start, limit=60):
    k = IDX.get(start)
    if k is None: return []
    out = []
    for a, t in INSN[k:k + limit]:
        out.append((a, t))
        if t.startswith("ret"):
            break
    return out

call_count = {}
for a, t in INSN:
    m = re.match(r"bl\s+0x([0-9a-f]+)", t)
    if m:
        tgt = int(m.group(1), 16)
        call_count[tgt] = call_count.get(tgt, 0) + 1

dec_funcs = {}
for tgt, cnt in sorted(call_count.items()):
    txt = "\n".join(t for _, t in func_body(tgt))
    # a decryptor XORs bytes of the buffer pointed to by x0
    if "eor\t" in txt and re.search(r"ldrb\sw\d+,\s+\[x0[,\]]", txt):
        dec_funcs[tgt] = cnt
print(f"[decryptors] found {len(dec_funcs)}: " +
      ", ".join(f"{a:#x}({c} calls)" for a, c in dec_funcs.items()))

# static RegisterNatives site (for the report)
reg_sites = []
for k, (a, t) in enumerate(INSN):
    if re.match(r"ldr\s+(x\d+),\s+\[\1,\s+#0x6b8\]", t):
        if any(t2.startswith("blr") for _, t2 in INSN[k + 1:k + 4]):
            reg_sites.append(a)
            print(f"[static] RegisterNatives site: {a:#x} (JNIEnv vtable slot 215)")

# ---------- unicorn harness ----------
BASE = 0x100000000
mu = Uc(UC_ARCH_ARM64, UC_MODE_LITTLE_ENDIAN)
lo = min(s[0] for s in segs) & ~0xFFF
hi = (max(s[0] + s[3] for s in segs) + 0xFFF) & ~0xFFF
mu.mem_map(BASE + lo, hi - lo, UC_PROT_ALL)
for vaddr, off, filesz, memsz in segs:
    mu.mem_write(BASE + vaddr, data[off:off + filesz])
STACK = 0x300000000
mu.mem_map(STACK, 0x100000, UC_PROT_ALL)
HEAP = 0x400000000
mu.mem_map(HEAP, 0x100000, UC_PROT_ALL)
heap_ptr = [HEAP]
def halloc(n):
    p = heap_ptr[0]; heap_ptr[0] += (n + 15) & ~15; return p

# hook window: JNI/JavaVM vtable slots point here (NOP sled)
HOOKW = 0x500000000
hooks = {}
def new_hook(tag):
    a = HOOKW + len(hooks) * 16
    hooks[a] = tag
    return a
mu.mem_map(HOOKW, 0x10000, UC_PROT_ALL)
mu.mem_write(HOOKW, struct.pack("<I", 0xD503201F) * (0x10000 // 4))

jni_vtbl = halloc(240 * 8)
jni_env = halloc(8)
mu.mem_write(jni_env, struct.pack("<Q", jni_vtbl))
for i in range(240):
    mu.mem_write(jni_vtbl + i * 8, struct.pack("<Q", new_hook(("jni", i))))
vm_vtbl = halloc(8 * 8)
javavm = halloc(8)
mu.mem_write(javavm, struct.pack("<Q", vm_vtbl))
for i in range(8):
    mu.mem_write(vm_vtbl + i * 8, struct.pack("<Q", new_hook(("javavm", i))))

def cstr(addr, n=256):
    out = b""
    try:
        while len(out) < n:
            c = mu.mem_read(addr + len(out), 1)
            if c == b"\0": break
            out += c
    except UcError:
        pass
    return out.decode("utf-8", "replace")

strings_found = []     # {caller, fn, ct, pt}
pending_dec = {}       # return-addr -> (fn, ct, buf, len)
jni_events = []

def hook_dispatch(addr):
    tag = hooks[addr]
    x1 = mu.reg_read(UC_ARM64_REG_X1)
    x2 = mu.reg_read(UC_ARM64_REG_X2)
    x3 = mu.reg_read(UC_ARM64_REG_X3)
    ret = 0
    if tag == ("javavm", 6):                       # GetEnv(vm, &env, ver)
        mu.mem_write(x1, struct.pack("<Q", jni_env))
        jni_events.append({"fn": "GetEnv", "version": hex(x2 & 0xFFFFFFFF)})
        print(f"  GetEnv(version={x2 & 0xFFFFFFFF:#x}) -> env")
    elif tag == ("jni", 6):                        # FindClass(env, name)
        nm = cstr(x1)
        ret = 0x700000100
        jni_events.append({"fn": "FindClass", "name": nm})
        print(f"  FindClass({nm!r})")
    elif tag == ("jni", 215):                      # RegisterNatives(env, clazz, methods, n)
        n = x3 & 0xFFFFFFFF
        ms = []
        for i in range(min(n, 32)):
            nm_a, sg_a, fn_a = struct.unpack("<QQQ", mu.mem_read(x2 + i * 24, 24))
            ms.append({"name": cstr(nm_a), "sig": cstr(sg_a), "fnPtr": hex(fn_a - BASE)})
            print(f"  RegisterNatives[{i}]: {ms[-1]['name']!r} {ms[-1]['sig']!r} -> {ms[-1]['fnPtr']}")
        jni_events.append({"fn": "RegisterNatives", "count": n, "methods": ms})
    elif tag == ("jni", 167):                      # NewStringUTF(env, str)
        s = cstr(x1)
        jni_events.append({"fn": "NewStringUTF", "str": s})
        print(f"  NewStringUTF({s!r})")
        ret = 0x700000200
    mu.reg_write(UC_ARM64_REG_X0, ret)
    mu.reg_write(UC_ARM64_REG_PC, mu.reg_read(UC_ARM64_REG_X30))

def hook_code(mu_, addr, size, user):
    # JNI/JavaVM vtable dispatch
    if HOOKW <= addr < HOOKW + len(hooks) * 16:
        hook_dispatch(addr)
        return
    va = addr - BASE
    # decryptor entry: capture ciphertext from (x0, w1), key by return addr.
    # Specialized clones ignore w1 (compiler leaves garbage): clamp and fix
    # up the ciphertext length at exit using the NUL-terminated plaintext.
    if va in dec_funcs:
        x0 = mu.reg_read(UC_ARM64_REG_X0)
        w1 = mu.reg_read(UC_ARM64_REG_X1) & 0xFFFFFFFF
        ln = w1 if 0 < w1 <= 0x1000 else 64
        try:
            ct = bytes(mu.mem_read(x0, ln))
        except UcError:
            ct = b""
        pending_dec[mu.reg_read(UC_ARM64_REG_X30)] = (va, ct, x0)
        return
    # decryptor exit: read back the plaintext (NUL-terminated by the dec fn)
    if addr in pending_dec:
        fn, ct, buf = pending_dec.pop(addr)
        try:
            raw = bytes(mu.mem_read(buf, 256))
        except UcError:
            raw = b""
        pt = raw.split(b"\0")[0]
        ct = ct[:len(pt)] if pt else ct
        printable = len(pt) > 0 and all(0x20 <= b < 0x7F for b in pt)
        strings_found.append({"caller": hex(addr - BASE), "fn": hex(fn),
                              "ct": ct.hex(), "pt": pt.decode() if printable else None})
        if printable:
            print(f"  str @caller {addr - BASE:#x} fn {fn:#x}: {pt!r}")

mu.hook_add(UC_HOOK_CODE, hook_code)

# ---------- anti-emu bypass (v3): take over svc #0 ----------
# mock.c 的反模拟探针 B 用 svc #0 发起真实 syscall（getpid）。Unicorn 没有
# 内核，svc 触发未处理异常直接中止模拟 —— 攻击方必须用 UC_HOOK_INTR 接管：
# 按 x8 里的 syscall 号伪造返回值，并把 PC 推进过 svc 指令。
# 注意：Unicorn 抛出异常时 PC 可能仍指向 svc 本体、也可能已指向下一条
# （随版本而变），这里按内存中的指令编码判断是否需要跳过。
# 攻击方抓明文窗口：不能靠"mprotect 区域非全零"判断——mprotect 以页为
# 单位，整页 .text 永远非零。精确做法：UC_HOOK_MEM_WRITE 监视当前
# mprotect 窗口内的写地址，unlock→seal 之间的写集合就是 payload 本体
# （解密循环逐字节写回原址）；seal 的 svc 触发瞬间明文尚在内存，按
# 记录到的 [wr_lo, wr_hi] 精确 dump。
payload_dumps = []
mprot_win = [None, None]          # 当前 mprotect 窗口 (addr, len)
wr_range = [None, None]           # 窗口内被写地址的 [min, max]

def hook_mem_write(mu_, access, address, size, value, user):
    lo, ln = mprot_win
    if lo is not None and lo <= address < lo + ln:
        wr_range[0] = address if wr_range[0] is None else min(wr_range[0], address)
        wr_range[1] = address + size - 1 if wr_range[1] is None else max(wr_range[1], address + size - 1)
mu.hook_add(UC_HOOK_MEM_WRITE, hook_mem_write)

FAKE_PID, FAKE_PPID = 4242, 1234
next_fake_mmap = [0x600000000]

def hook_intr(mu_, intno, user):
    pc = mu_.reg_read(UC_ARM64_REG_PC)
    nr = mu_.reg_read(UC_ARM64_REG_X8)
    if nr == 172:                                     # __NR_getpid（反模拟探针 B）
        ret, note = FAKE_PID, "fake pid 4242"
    elif nr == 173:                                   # __NR_getppid（TracerPid 白名单基准）
        ret, note = FAKE_PPID, "fake ppid 1234"
    elif nr == 117:                                   # __NR_ptrace（反调试探针 C）
        if os.environ.get("MOCK_TRACER"):
            ret, note = -1, "EPERM (模拟已被调试：TRACEME 占坑失败)"
        else:
            ret, note = 0, "TRACEME ok (模拟未被调试)"
    elif nr == 56:                                    # __NR_openat（反调试探针 D）
        path = cstr(mu_.reg_read(UC_ARM64_REG_X1))
        ret, note = 3, f"openat({path!r}) -> fake fd 3"
    elif nr == 63:                                    # __NR_read：伪造 /proc/self/status
        buf, cnt = mu_.reg_read(UC_ARM64_REG_X1), mu_.reg_read(UC_ARM64_REG_X2)
        # 对抗关键：TracerPid 必须与 ptrace/getppid 的回答**自洽**——
        # 干净形态 = TracerPid == getppid()（TRACEME 占坑后父进程即 tracer）。
        # 真 .so 会交叉验证两个接口（见 UNIDBG_NOTES.md P1-2）
        tp = 4242 if os.environ.get("MOCK_TRACER") else FAKE_PPID
        fake = (f"Name:\tmock\nState:\tR (running)\nTracerPid:\t{tp}\n"
                "Uid:\t1000\t1000\t1000\t1000\n").encode()
        n = min(len(fake), cnt)
        mu_.mem_write(buf, fake[:n])
        ret, note = n, f"fake /proc/self/status (TracerPid={tp})"
    elif nr == 57:                                    # __NR_close
        ret, note = 0, "close ok"
    elif nr == 222:                                   # __NR_mmap（watcher 线程栈）
        length = mu_.reg_read(UC_ARM64_REG_X1)
        base = next_fake_mmap[0]
        next_fake_mmap[0] += (length + 0xFFFF) & ~0xFFFF
        mu_.mem_map(base, (length + 0xFFF) & ~0xFFF, UC_PROT_ALL)
        ret, note = base, f"mmap {length}B -> fake page @{base:#x}"
    elif nr == 220:                                   # __NR_clone（反调试线程化）
        # 顺序模拟器无法忠实执行 clone 的并发语义：只能返回非 0 让
        # 被模拟代码走父路径 —— watcher 后台轮询线程整体不可见。
        # 这正是该层的反模拟价值：检测面与模拟观测面结构性错开。
        ret, note = 4243, "clone -> fake child pid (watcher 线程在模拟器里不运行)"
    elif nr == 101:                                   # __NR_nanosleep
        ret, note = 0, "nanosleep ok"
    elif nr == 94:                                    # __NR_exit_group（watcher 自毁）
        print(f"  [anti-debug] exit_group({mu_.reg_read(UC_ARM64_REG_X0)}) @ {pc - BASE:#x} —— watcher 检测命中，进程自毁")
        mu_.emu_stop()
        return
    elif nr == 226:                                   # __NR_mprotect（运行时代码解密）
        ret, note = 0, "mprotect ok (unicorn mem already RWX)"
        m_addr = mu_.reg_read(UC_ARM64_REG_X0)
        m_len = mu_.reg_read(UC_ARM64_REG_X1)
        if wr_range[0] is not None:
            # 上一个窗口内有写 => seal 到来，明文完整在内存：精确 dump
            n = wr_range[1] - wr_range[0] + 1
            blob = bytes(mu_.mem_read(wr_range[0], n))
            open("payload_plaintext.bin", "wb").write(blob)
            payload_dumps.append({"pc": hex(pc - BASE), "addr": hex(wr_range[0] - BASE),
                                  "len": n, "file": "payload_plaintext.bin"})
            note += f" | PLAINTEXT captured: {n}B @{wr_range[0] - BASE:#x} -> payload_plaintext.bin"
        mprot_win[0], mprot_win[1] = m_addr, m_len
        wr_range[0] = wr_range[1] = None
    else:
        print(f"  [anti-emu] unhandled syscall nr={nr} @ {pc - BASE:#x}; stop")
        mu_.emu_stop()
        return
    mu_.reg_write(UC_ARM64_REG_X0, ret)
    insn = struct.unpack("<I", mu_.mem_read(pc, 4))[0]
    if insn & 0xFFE0001F == 0xD4000001:               # PC 仍指向 svc
        mu_.reg_write(UC_ARM64_REG_PC, pc + 4)
    print(f"  [anti-emu] svc #0 nr={nr} @ {pc - BASE:#x} -> {note}")
mu.hook_add(UC_HOOK_INTR, hook_intr)

def run_func(va, x0=0, x1=0, x2=0, x3=0):
    STOP = STACK + 0xFF000
    mu.reg_write(UC_ARM64_REG_SP, STACK + 0x80000)
    mu.reg_write(UC_ARM64_REG_X0, x0)
    mu.reg_write(UC_ARM64_REG_X1, x1)
    mu.reg_write(UC_ARM64_REG_X2, x2)
    mu.reg_write(UC_ARM64_REG_X3, x3)
    mu.reg_write(UC_ARM64_REG_X30, STOP)
    try:
        mu.emu_start(BASE + va, STOP, count=1000000)
        return mu.reg_read(UC_ARM64_REG_X0)
    except UcError as e:
        print(f"  emu {va:#x} stopped: {e} @ {mu.reg_read(UC_ARM64_REG_PC) - BASE:#x}")
        return None

# ---------- run: JNI_OnLoad, then every registered fnPtr ----------
print("\n===== METHOD 1+2: emulated JNI_OnLoad =====")
jni_onload = exports.get("JNI_OnLoad")
if jni_onload is None:
    sys.exit("no JNI_OnLoad export")
ret = run_func(jni_onload, javavm, 0)
print(f"  JNI_OnLoad returned {ret:#x}" if ret is not None else "  JNI_OnLoad crashed")

registration = None
clazz = next((e["name"] for e in jni_events if e["fn"] == "FindClass"), None)
for e in jni_events:
    if e["fn"] == "RegisterNatives":
        registration = {"class": clazz, "count": e["count"], "methods": e["methods"],
                        "static_sites": [hex(s) for s in reg_sites]}

if registration:
    for m_ in registration["methods"]:
        fp = int(m_["fnPtr"], 16)
        print(f"\n===== emulating registered native {m_['name']} @ {fp:#x} =====")
        run_func(fp, jni_env, 0x700000100, 0, 0)

json.dump({"strings": strings_found, "registration": registration,
           "jni_events": jni_events, "payload_dumps": payload_dumps},
          open("mock_analysis.json", "w"), indent=1)
print(f"\n[done] {len(strings_found)} strings recovered -> mock_analysis.json")
if payload_dumps:
    print(f"[done] {len(payload_dumps)} payload plaintext dump(s) -> payload_plaintext.bin")
