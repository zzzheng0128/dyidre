# 350.101 managed VM 恢复记录

这份记录只描述 `0x1555A4 managedBytecodeRun_350` 这一层 managed bytecode VM。
它和外层 native VMP `0x4CC10 exeVMInner_350` 是两套东西：`0x4CC10`
负责 native VMP 片段，例如 `vmCode=0x1F7860` 生成 mssdk/sign_key/common_key
材料；`0x1555A4` 负责执行解出来的 F5/F7/F8/F13/F15 managed 程序，
最后参与 X-Argus / X-Ladon / X-Medusa / X-Helios 生成。

## 当前结论

这层 VM 不是简单“去花指令”就结束。它更像一个小型解释器：

1. `.init_array` 里先调用 module builder，把加密 blob 解码成 managed module。
2. `managedModuleFindProgram_350` 用 `"F5"`、`"F7"`、`"F8"` 等名字找到程序对象。
3. `managedProgramInvokeCore_350` 按 `program->kind` 选择 native call 或 bytecode run。
4. `kind == 1` 时，`program+0x08` 就是内联 `ManagedProgramBody350`。
5. `0x1555A4 managedBytecodeRun_350` 解释 0x18 字节一条的 bytecode record。
6. VM 通过 slot 传参，通过 `op5e CALL_CF_INDEX` 回调 native binding 表。
7. native CF helper 完成 memcpy、MEM_BLOCK 构造、digest、短包 transform、base64、格式化字符串等动作。

也就是说，恢复路线是“代码重现/语义 lifting”，不是只把混淆 nop 掉。

## 从请求到签名的调用骨架

```text
0x14DBF4 buildSignedHttpHeadersCallback_350
  -> 0x149CA8 buildSignedHttpHeadersInner_350
       -> 0x16D204 signStage1_makeStubPieces_350      -> X-Gorgon 前置材料
       -> 0x16D454 signStage2_makeKeyPieces_350       -> X-Khronos / key pieces
       -> 0x1715F8 managedSignBuildA_350      -> F5  -> X-Argus
       -> 0x171648 managedSignBuildB_350      -> F7  -> X-Ladon
       -> 0x171698 managedSignBuildFinal_350  -> F8  -> X-Medusa/final material
       -> 0x1716F4 managedSignPostEmitF13_350 -> F13 -> X-Helios/Soter side path
```

外层 `0x149CA8` 负责打包 `MetaSecManagedCallArg350` /
`MetaSecManagedShortCallArg350`，managed VM 程序只看到 frame slot：

```text
slot4+  wrapper/native 参数
slot2   常见返回值
slot29  value stack top
slot31  exec status / return control
```

## managed program 结构体修正

这次用 unidbg dump 直接看 runtime descriptor，修正了从 334 导入的旧结构。

关键证据：

```text
F5 program  @ 0x127be740
  +0x00 kind              = 1
  +0x08 body.entry/meta   = 0x219
  +0x0c body.stack_need   = 0x440
  +0x10 body.code_begin   = 0x1267b000
  +0x18 body.code_end     = 0x1267f728
  +0x20 body.code_end_dup = 0x1267f728
  +0x28 name_sso_qword    = "\x04F5\0nown"
  +0x30 zero
  +0x38 zero
  +0x40 next program
```

所以 350 里 `kind == 1` 不是 `program+0x28` 指向 bytecode body；
`program+0x28` 实际是内联 body 里的 SSO 名字字段。新的结构已经写入：

```text
dyidre/versions/350101/metasec_structs_350_all.h
```

## bytecode record 格式

```text
record size = 0x18
op          = record[0]
p0          = record[8]
p1          = record[9]
p2          = record[10]
p3          = record[11]
imm16       = *(u16 *)(record+0x0a)
q1          = *(u64 *)(record+0x10)
```

slot 基址：

```text
qword slots = frame->buf + 0x8100 + slot*8
f32 slots   = frame->buf + 0x8200 + slot*4
f64 slots   = frame->buf + 0x8280 + slot*8
```

解释器三张表：

```text
0x81..0xBA table @ 0x203592, base target 0x155734
0x41..0x80 table @ 0x203606, base target 0x15689C
0x01..0x40 table @ 0x203686, base target 0x157640
```

一个容易踩坑的点：`op=0x00` 会落到 default handler `0x157724`，
但它不是 invalid/halt，而是一个真实的 `REV16_32` 位操作。

## 已恢复 opcode

下面是当前 F5/F7/F8/F13/F15 实际用到的 opcode。语义里 `sN` 表示
`frame->buf+0x8100+N*8` 的 qword slot。

| op | mnemonic | 语义 |
|---:|---|---|
| `0x00` | `REV16_32` | `s[p2] = sign_extend_32(rev16((uint32_t)s[p1]))` |
| `0x01` | `XOR_IMM16` | `s[p1] = s[p0] ^ imm16` |
| `0x02` | `XOR64` | `s[p2] = s[p1] ^ s[p0]` |
| `0x08` | `ST32` | `*(uint32_t *)(s[p0] + imm16s) = s[p1]` |
| `0x09` | `SUB32` | `s[p2] = sign_extend_32((uint32_t)s[p0] - (uint32_t)s[p1])` |
| `0x0e` | `LSR32_IMM` | `s[p2] = sign_extend_32((uint32_t)s[p1] >> p3)` |
| `0x15` | `CMP_LT_IMM64S` | `s[p1] = ((int64_t)s[p0] < imm16s) ? 1 : 0` |
| `0x16` | `CMP_LT64S` | `s[p2] = ((int64_t)s[p0] < (int64_t)s[p1]) ? 1 : 0` |
| `0x18` | `SHL32_IMM` | `s[p2] = sign_extend_32((uint32_t)s[p1] << p3)` |
| `0x19` | `ST16` | `*(uint16_t *)(s[p0] + imm16s) = s[p1]` |
| `0x1e` | `CMOVNZ64` | `s[p2] = (s[p1] != 0) ? s[p0] : 0` |
| `0x1f` | `CMOVZ64` | `s[p2] = (s[p1] == 0) ? s[p0] : 0` |
| `0x25` | `ST64` | `*(uint64_t *)(s[p0] + imm16s) = s[p1]` |
| `0x26` | `ST8` | `*(uint8_t *)(s[p0] + imm16s) = s[p1]` |
| `0x2e` | `ROR32_IMM` | `s[p2] = ror32((uint32_t)s[p1], p3)` |
| `0x33` | `OR_IMM16` | `s[p1] = s[p0] \| imm16` |
| `0x34` | `OR64` | `s[p2] = s[p0] \| s[p1]`，常被当作 move 使用 |
| `0x35` | `AND64` | `s[p2] = s[p0] & s[p1]` |
| `0x36` | `NOR64` | `s[p2] = ~(s[p0] \| s[p1])` |
| `0x38` | `NEG_F64` | `f64[p3] = -f64[p2]` |
| `0x39` | `NEG_F32` | `f32[p3] = -f32[p2]` |
| `0x3a` | `UMULHI64` | `s[p2] = high64(uint64(s[p0]) * uint64(s[p1]))` |
| `0x3c` | `SMULHI64` | `s[p2] = high64(int64(s[p0]) * int64(s[p1]))` |
| `0x3e` | `MUL32` | `s[p2] = sign_extend_32((uint32_t)s[p0] * (uint32_t)s[p1])` |
| `0x3f` | `SMULHI32` | `s[p2] = high32(int32(s[p0]) * int32(s[p1]))` |
| `0x52` | `LD32S` | `s[p1] = *(int32_t *)(s[p0] + imm16s)` |
| `0x53` | `LD_POOL_PTR` | `s[p1] = *(uint64_t *)q1 + imm16` |
| `0x54` | `CONST_HI16` | `s[p1] = sign_extend_32(imm16 << 16)` |
| `0x55` | `LD16U` | `s[p1] = *(uint16_t *)(s[p0] + imm16s)` |
| `0x56` | `LD16S` | `s[p1] = *(int16_t *)(s[p0] + imm16s)` |
| `0x57` | `LD64_IND` | `s[p1] = *(uint64_t *)(*(uint64_t *)s[p0] + imm16s)` |
| `0x58` | `LD64` | `s[p1] = *(uint64_t *)(s[p0] + imm16s)` |
| `0x59` | `LD8U` | `s[p1] = *(uint8_t *)(s[p0] + imm16s)` |
| `0x5a` | `LD8S` | `s[p1] = *(int8_t *)(s[p0] + imm16s)` |
| `0x5b` | `RET` | 返回/离开当前 managed 程序 |
| `0x5d` | `CALL_CF_EX` | 扩展 native binding 调用，当前签名样本未作为主路径使用 |
| `0x5e` | `CALL_CF_INDEX` | 用 `imm32` 作为 native binding 表索引调用，真实 CF 名称看 runtime mark |
| `0x5f` | `ADD_PC_IMM32` | `vm_pc += imm32` |
| `0x67` | `LSR64_IMM` | `s[p2] = (uint64_t)s[p1] >> p3` |
| `0x68` | `ASR64` | `s[p2] = (int64_t)s[p1] >> (s[p0] & 63)` |
| `0x6d` | `SHL64_IMM32PLUS` | `s[p2] = s[p1] << (p3 + 32)` |
| `0x6e` | `SHL64_IMM` | `s[p2] = s[p1] << p3` |
| `0x84` | `ADD64` | `s[p2] = s[p0] + s[p1]` |
| `0x85` | `ADD64_IMM16` | `s[p1] = s[p0] + imm16s` |
| `0x87` | `LD32U` | `s[p1] = *(uint32_t *)(s[p0] + imm16s)` |
| `0x8d` | `AND_IMM16` | `s[p1] = s[p0] & imm16` |
| `0x90` | `F32_TO_F64` | `f64[p3] = (double)f32[p2]` |
| `0xa1` | `CLZ64` | `s[p2] = clz64(s[p0])` |
| `0xa2` | `CLZ32_NOT` | `s[p2] = clz32(~s[p0])` |
| `0xa7` | `BR_NE64` | `if (s[p0] != s[p1]) pc += imm16s` |
| `0xae` | `BR_EQ64` | `if (s[p0] == s[p1]) pc += imm16s` |
| `0xb2` | `AND64_IMM16` | `s[p1] = s[p0] & imm16` |
| `0xb3` | `AND64` | `s[p2] = s[p0] & s[p1]` |
| `0xb4` | `ADD32` | `s[p2] = sign_extend_32((uint32_t)s[p0] + (uint32_t)s[p1])` |
| `0xb5` | `ADD32_IMM16` | `s[p1] = sign_extend_32((uint32_t)s[p0] + imm16s)` |

## 解码产物

decoder 脚本：

```text
/Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py
```

当前输出目录：

```text
dyidre/versions/350101/managed_vm_decode/
```

结构化 lift 记录：

```text
dyidre/versions/350101/managed_vm_program_lift_350101.md
```

全量统计：

```text
F5  records 759   known 759   unknown 0
F7  records 156   known 156   unknown 0
F8  records 5722  known 5722  unknown 0
F13 records 154   known 154   unknown 0
F15 records 28    known 28    unknown 0
```

注意：`op5e` 的 `imm32` 是 native binding 表索引，不是直接业务编号。
比如某条 `op5e index=0x31` 静态上只能叫 index，runtime 里可能标成
`CF100 format/crypto glue`。所以 listing 里同时保留：

```text
CALL_CF_INDEX call native_binding[index=0x31] via q1 table
; runtime: CF100 format/crypto glue
```

这样升级版本时不会被旧版本的 `CFxx` 名字带偏。

## 当前 clean runtime marks

新版 decoder 不再只看外层 phase，而是用 `interp+0x00` 里的 body meta
匹配具体 F 程序。因此这里的 mark 才能和 bytecode record 对齐：

```text
F5/X-Argus:
  CF10 copyMemBlockData: 003e, 0047, 0064, 00a2, 0207
  CF38 initMemBlockBySrc: 0197, 01a9, 01bc, 024f, 0254
  CF44 base64Encode: 0290
  CF98 formatAllocString: 02b6, 02bd

F7/X-Ladon:
  CF100 format/crypto glue: 002b
  CF38 initMemBlockBySrc: 0032, 004b
  CF48 short flattened transform: 0052
  CF49 concat transformed short block: 0055
  CF44 base64Encode: 0059
  CF98 formatAllocString: 007b, 0082

F8/X-Medusa:
  CF38 initMemBlockBySrc: 0360, 0481, 05a2, 0f99
  CF10 copyMemBlockData: 0a5b
  CF44 base64Encode: 119a
  CF98 formatAllocString: 12c9, 133e

F13/X-Helios:
  CF100 format/crypto glue: 002b
  CF38 initMemBlockBySrc: 0032, 004b
  CF48 short flattened transform: 0052
  CF49 concat transformed short block: 0055
  CF44 base64Encode: 0059
  CF98 formatAllocString: 0079, 0080
```

之前 phase-level trace 里看到的 `CF61/CF79` 仍然有价值，但它们可能来自
nested/helper managed program 或下层 native helper，不应该直接标成 F5/F8
bytecode 主体指令。

## 对 X-* 的当前理解

F5 / F8 是大程序：

```text
F5: 759 records，主要输出 X-Argus
F8: 5722 records，主要输出 X-Medusa/final material
```

F7 / F13 是短包同族：

```text
F7:  X-Ladon
F13: X-Helios / X-Soter side path
```

F7/F13 的共同骨架：

1. 从 short call arg pack 读取 seed、derived_block、json_list、stack_memblock、out_key/out_value。
2. 通过 native binding 组装 `"%u-%s-%s"` 文本，例如：
   `1788108717-1588093228-1128`。
3. 调用短包 transform，输出 32 字节。
4. 调用 pack helper，拼上 4 字节 prefix，得到 0x24 字节。
5. base64 后通过 CF98 格式化成 header key/value。

已观察 F13：

```text
CF48 text     = 1788114908-1588093228-1128
CF48 key      = 28ebc4935363c47f6c039d846f297188
CF48 output32 = a1 8c 03 fd d1 04 7c 77 b8 96 8c 44 c8 fc cb df ...
CF49 prefix4  = b1 88 c5 2c
CF44 output   = sYjFLKGMA/3RBHx3uJaMRMj8y9+Nep3IRGijVpVor+3c+kKD
```

## 后续升级版本怎么用

1. 先确认 SO identity，不靠文件名。
2. 找到 module build matrix 和 F-program globals。
3. 用 unidbg dump `ManagedProgram350` descriptor，优先判断 `kind`：
   - `kind==1`：先尝试 `program+0x08` 内联 body；
   - `kind==2`：再看 `program+0x28` 外部 body 指针；
   - `kind==3`：native entry。
4. dump `code_begin..code_end`，确认长度是否 0x18 对齐。
5. 跑 `metasec_managed_vm_decoder.py`。
6. 如果出现未知 opcode：
   - 根据 opcode 范围定位三张 jump table；
   - 读 handler 反汇编；
   - 补 decoder；
   - 再跑统计到 `unknown=0` 或标明“不在当前路径”。
7. 对 `op5e` 只记录 binding index；真实业务名必须从 runtime CF mark 或 q1 表解析得出。
