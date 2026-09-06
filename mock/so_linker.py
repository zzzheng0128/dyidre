#!/usr/bin/env python3
"""so_linker.py — 把单个 aarch64 freestanding .o 链接成最小共享库（.so），
并在最后回填 CRC 自校验的期望值。

为什么需要它：macOS 的 Apple clang 可以交叉编译 aarch64-linux ELF 目标
文件（纯 LLVM 能力），但系统没有 ELF 链接器（ld64 只出 Mach-O，无 lld）。
本项目无外部符号引用（-nostdlib），因此链接只需：
  1. 布局：把所有 SHF_ALLOC 的 PROGBITS 段（.text/.rodata*）按对齐拼接
     到 RX 区域（VA 0x1000 起），vaddr == 文件偏移；
  2. 重定位：应用 ADRP_PREL_PG_HI21(275) / ADD_ABS_LO12_NC(277)
     （bl 等段内相对跳转由汇编器在 .o 内已解析，无需处理）；
  3. 导出：.dynsym 仅导出 JNI_OnLoad + DT_HASH（与真 .so "stripped、
     仅导出 JNI_OnLoad"的形态一致）；
  4. payload 密文化：把 mock.c 的 payload() 机器码整体单字节 XOR 加密
     （对应真 .so 的运行时代码解密），并把真实 VA/长度/密钥回填进
     .rodata 的三个 uint64 占位常量（PAYLOAD_ADDR/LEN/KEY）；
  5. CRC 回填：payload 加密完成后对 .text 前 CRC_SELF_CHECK_LEN 字节
     计算 CRC32，定位 .rodata 中的占位魔数 0xDEADBEEF 并改写为真实值 ——
     模拟商用加固方案"构建后期 patch 校验和"的做法。

用法: python3 so_linker.py mock.o libmock.so
"""
import struct, sys, zlib

IN, OUT = sys.argv[1], sys.argv[2]
d = open(IN, "rb").read()

# ---- ELF64 LE / aarch64 / ET_REL 检查 ----
assert d[:4] == b"\x7fELF" and d[4] == 2 and d[5] == 1, "need ELF64 LE"
e_type, e_machine = struct.unpack("<HH", d[16:20])
assert e_type == 1 and e_machine == 183, "need ET_REL aarch64 (EM=183)"

# ---- section headers（Apple clang 合并 .strtab，段名可能不可 UTF-8 解码，
#      因此全程不依赖段名，只用 type/flags 识别） ----
e_shoff     = struct.unpack("<Q", d[0x28:0x30])[0]
e_shentsize = struct.unpack("<H", d[0x3A:0x3C])[0]
e_shnum     = struct.unpack("<H", d[0x3C:0x3E])[0]
SH = [struct.unpack("<IIQQQQIIQQ", d[e_shoff + i * e_shentsize: e_shoff + (i + 1) * e_shentsize])
      for i in range(e_shnum)]

SHT_PROGBITS, SHT_SYMTAB, SHT_RELA = 1, 2, 4
SHF_ALLOC = 0x2

symtab = next(s for s in SH if s[1] == SHT_SYMTAB)
strtab = SH[symtab[6]]                       # symtab.sh_link -> 字符串表

def sym_name_at(st_name):
    e = d.index(b"\0", strtab[4] + st_name)
    return d[strtab[4] + st_name:e].decode("utf-8", "replace")

# 符号表: 名字 -> (info, shndx, value, size)
syms = {}
for i in range(symtab[5] // 24):
    o = symtab[4] + i * 24
    st_name, st_info, st_other, st_shndx, st_value, st_size = struct.unpack("<IBBHQQ", d[o:o + 24])
    if st_name:
        syms[sym_name_at(st_name)] = (st_info, st_shndx, st_value, st_size)

# ---- 布局：所有 SHF_ALLOC PROGBITS 段拼进 RX blob（VA 0x1000 起） ----
sec_va = {}                                  # section index -> 最终 VA
blob = bytearray()
for i, s in enumerate(SH):
    if i == 0 or s[1] != SHT_PROGBITS or not (s[2] & SHF_ALLOC):
        continue
    pad = (-len(blob)) % max(s[9], 16)       # sh_addralign（至少 16：
                                             # uint64 常量需 8 对齐，否则
                                             # ldr imm12 按 8 缩放会截断）
    blob += b"\0" * pad
    sec_va[i] = 0x1000 + len(blob)
    blob += d[s[4]:s[4] + s[5]]
# 注意：VA_RX_END 不在此处定稿 —— 后面的 payload 密文槽会追加到 blob
# 尾部，最终 RX 末端在 phdr 拼装前统一用 len(blob) 计算。

# ---- 应用重定位 ----
for i, s in enumerate(SH):
    if s[1] != SHT_RELA or s[7] not in sec_va:
        continue
    base = sec_va[s[7]]                      # sh_info = 目标段
    boff = base - 0x1000
    for j in range(s[5] // 24):
        r_off, r_info, r_add = struct.unpack("<QQq", d[s[4] + j * 24: s[4] + j * 24 + 24])
        r_type = r_info & 0xFFFFFFFF
        so = symtab[4] + (r_info >> 32) * 24
        st_name, st_info, st_other, st_shndx, st_value, st_size = struct.unpack("<IBBHQQ", d[so:so + 24])
        S = sec_va[st_shndx] + st_value + r_add      # 符号最终 VA
        P = base + r_off                             # 重定位位置 VA
        fo = boff + r_off
        insn = struct.unpack("<I", blob[fo:fo + 4])[0]
        if r_type == 275:    # ADR_PREL_PG_HI21 -> adrp immhi:immlo
            imm = ((S - (P & ~0xFFF)) >> 12) & 0x1FFFFF
            insn = (insn & 0x9F00001F) | ((imm & 3) << 29) | (((imm >> 2) & 0x7FFFF) << 5)
        elif r_type == 277:  # ADD_ABS_LO12_NC -> add 的 imm12 字段 (bits[21:10])
            insn = (insn & 0xFFC003FF) | ((S & 0xFFF) << 10)
        elif r_type in (278, 284, 285, 286, 287):
            # LDST8/16/32/64/128_ABS_LO12_NC -> ldr/str imm12 (bits[21:10])
            # 按访问宽度缩放；掩码必须保留 bit22(L)/bit23(V) 等操作位
            shift = {278: 0, 284: 1, 285: 2, 286: 3, 287: 4}[r_type]
            # imm12 编码按宽度缩放，地址低位必须可表示，否则静默截断
            assert (S & 0xFFF) % (1 << shift) == 0, \
                f"reloc {r_type} @ {P:#x}: addr {S:#x} misaligned for scale {shift}"
            insn = (insn & 0xFFC003FF) | (((S & 0xFFF) >> shift) << 10)
        else:
            raise ValueError(f"unhandled reloc type {r_type}")
        blob[fo:fo + 4] = struct.pack("<I", insn)

# ---- 运行时代码解密：构建期密文化 payload() ----
# 与 mock.c 的 unlock_payload() 对应（真 .so ctor[93] 的错位密文形态）：
#   1. 把 payload() 的机器码加密后搬到 RX blob 尾部一个 VA≡2 (mod 4) 的
#      密文槽位 —— 分析者从槽位起点反汇编时指令相位错位 2 字节；
#   2. payload 原位全部填 0（udf #0：未解密时被调用立即 SIGILL）；
#   3. 运行时解密所需的 明文VA/长度/密钥/密文槽位VA 回填进 .rodata 的
#      4 个 uint64 占位常量。
# 注意必须在 CRC 回填之前：CRC 校验的是"含密文"的构建态代码。
PAYLOAD_KEY = 0xA7
p_info = syms["payload"]                       # 静态函数也在 .o 符号表里
p_va  = sec_va[p_info[1]] + p_info[2]
p_len = p_info[3]
p_off = p_va - 0x1000
assert p_len > 0, "payload symbol has no size"
plain = bytes(blob[p_off:p_off + p_len])
# 密文槽位：追加到 blob 尾部，VA 对齐到 2 mod 4
pad = (-(len(blob) - 2)) % 4
blob += b"\0" * pad
ct_va = 0x1000 + len(blob)
assert ct_va % 4 == 2
blob += bytes(b ^ PAYLOAD_KEY for b in plain)
# 原位填 0（udf #0）
blob[p_off:p_off + p_len] = b"\0" * p_len
for magic, val in ((0xDEAD0001, p_va), (0xDEAD0002, p_len),
                   (0xDEAD00A7, PAYLOAD_KEY), (0xDEAD0004, ct_va)):
    m = struct.pack("<Q", magic)
    p = blob.find(m)
    assert p >= 0 and blob.find(m, p + 1) < 0, f"placeholder {magic:#x} not found or not unique"
    blob[p:p + 8] = struct.pack("<Q", val)
print(f"payload sealed: plain@{p_va:#x} (zeroed), ct@{ct_va:#x}+{p_len:#x} (2-aligned), key={PAYLOAD_KEY:#04x}")

# ---- CRC 自校验期望值回填 ----
# mock.c 约定：.text 在页首（VA 0x1000），校验其前 0x180 字节；
# CRC_EXPECT 占位魔数 0xDEADBEEF 位于 .rodata（即 blob 内）。
CRC_LEN = 0x180
crc = zlib.crc32(bytes(blob[0:CRC_LEN])) & 0xFFFFFFFF
magic = struct.pack("<I", 0xDEADBEEF)
pos = blob.find(magic)
assert pos >= 0, "CRC_EXPECT placeholder not found in .rodata"
assert blob.find(magic, pos + 1) < 0, "placeholder not unique"
blob[pos:pos + 4] = struct.pack("<I", crc)
print(f"CRC self-check: text[0x1000:0x1180] crc32={crc:#010x} patched @blob+{pos:#x}")

# ---- 动态符号：仅导出 JNI_OnLoad（模拟真 .so 的 stripped 形态） ----
ji = syms["JNI_OnLoad"]
jni_va = sec_va[ji[1]] + ji[2]
dynstr = b"\0JNI_OnLoad\0libmock.so\0"
SONAME_OFF = len(b"\0JNI_OnLoad\0")
dynsym = struct.pack("<IBBHQQ", 0, 0, 0, 0, 0, 0) + \
         struct.pack("<IBBHQQ", 1, 0x12, 0, 1, jni_va, ji[3])

# 经典 ELF hash（nbucket=1, nchain=2：符号 1 进 bucket，链终止于 0）
hashsec = struct.pack("<II", 1, 2) + struct.pack("<I", 1) + struct.pack("<II", 0, 0)

VA_META   = 0x3000                            # RW 元数据区
VA_HASH   = VA_META
VA_DYNSYM = VA_HASH + len(hashsec)
VA_DYNSTR = VA_DYNSYM + len(dynsym)
VA_DYNAMIC = (VA_DYNSTR + len(dynstr) + 15) & ~15

dyn_entries = [
    (4, VA_HASH),          # DT_HASH
    (5, VA_DYNSTR),        # DT_STRTAB
    (6, VA_DYNSYM),        # DT_SYMTAB
    (10, len(dynstr)),     # DT_STRSZ
    (11, 24),              # DT_SYMENT
    (14, SONAME_OFF),      # DT_SONAME
    (0, 0),                # DT_NULL
]
dynamic = b"".join(struct.pack("<qQ", t, v) for t, v in dyn_entries)

# ---- 拼装文件（vaddr == 文件偏移，阅读/分析都直观） ----
size = VA_DYNAMIC + len(dynamic)
img = bytearray(size)
img[0:64] = struct.pack("<16sHHIQQQIHHHHHH",
    b"\x7fELF" + bytes([2, 1, 1, 0]) + bytes(8),
    3, 183, 1, 0, 64, 0, 0, 64, 56, 3, 64, 0, 0)   # ET_DYN, EM_AARCH64, 3 phdrs

def phdr(ptype, flags, off, filesz, memsz, align):
    return struct.pack("<IIQQQQQQ", ptype, flags, off, off, off, filesz, memsz, align)

VA_RX_END = 0x1000 + len(blob)           # payload 密文槽追加后的最终 RX 末端
ph =  phdr(1, 5, 0, VA_RX_END, VA_RX_END, 0x1000)                  # PT_LOAD R-X
ph += phdr(1, 6, VA_META, size - VA_META, size - VA_META, 0x1000)  # PT_LOAD RW-
ph += phdr(2, 6, VA_DYNAMIC, len(dynamic), len(dynamic), 8)        # PT_DYNAMIC
img[64:64 + len(ph)] = ph

img[0x1000:0x1000 + len(blob)] = blob
img[VA_HASH:VA_HASH + len(hashsec)] = hashsec
img[VA_DYNSYM:VA_DYNSYM + len(dynsym)] = dynsym
img[VA_DYNSTR:VA_DYNSTR + len(dynstr)] = dynstr
img[VA_DYNAMIC:VA_DYNAMIC + len(dynamic)] = dynamic

open(OUT, "wb").write(bytes(img))
print(f"{OUT}: {size} bytes, JNI_OnLoad @ {jni_va:#x}, RX blob {len(blob)} bytes")
