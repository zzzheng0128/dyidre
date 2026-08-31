# 350.101 F8 / X-Medusa work-area mutation watch

这份报告接在 `x_medusa_pack_350101.md` 后面：前者已经证明
`base64(CF44 input) == X-Medusa`，这里继续追问两个 work area 在最终
`CF44` 前到底是谁改掉的。

## 结论

`F8/X-Medusa` 不是“CF07 memcpy 一路拼完就 base64”。它的形状更像：

```c
// 1. F8 main 先用 CF07 拼两个 work area。
memcpy(mini + 0x00, dyn4,  0x04);
memcpy(mini + 0x04, dyn16, 0x10);

memcpy(sub + 0x000, flag1,        0x01);
memcpy(sub + 0x001, time_or_seed8, 0x08);
memcpy(sub + 0x009, blob,         0x2a4);
memcpy(sub + 0x2ad, trailer2,     0x02);

// 2. work area 原地变换。
mutate_mini_in_F8_main(mini);      // 20 次 ST8
mutate_sub_in_F12_nested(sub);     // 31 次 ST64，每次改一个 qword，覆盖前 0xf8 bytes

// 3. F8 main 再把变换后的 work area 拼成最终二进制包。
memcpy(final + 0x000, mini,    0x14);
memcpy(final + 0x014, const2,  0x02);
memcpy(final + 0x016, zero1,   0x01);
memcpy(final + 0x017, one1,    0x01);
memcpy(final + 0x018, marker1, 0x01);
memcpy(final + 0x019, sub,     0x2af);

X_Medusa = base64(final);          // CF44 -> CF98
```

换句话说，`CF07` 只负责“搬运/拼包”，真正有价值的变换藏在 managed bytecode
的 `ST8/ST64` 写回里。这里要继续还原算法，就要跟着 `ST8/ST64` 的来源走，
不要再只盯 `CF07`。

## 证据文件

```text
unidbg/unidbg-android/target/sign6_350101_f8_watch_interp_20260831_035639.log
unidbg/unidbg-android/target/sign6_350101_f21_source_watch_20260831_042743.log
unidbg/unidbg-android/target/sign6_350101_program_f12_20260831_035801.log
unidbg/unidbg-android/target/sign6_350101_program_f20_f40_43_46_20260831_042856.log
dyidre/versions/350101/managed_vm_decode_f12/
dyidre/versions/350101/managed_vm_decode_f32_family/
dyidre/versions/350101/managed_vm_decode_f20_f40_f43_46/
dyidre/versions/350101/source_work_family_compare_350101.md
dyidre/versions/350101/f19_f32_source_work_timeline_350101.md
dyidre/versions/350101/f20_f40_source_work_timeline_350101.md
dyidre/versions/350101/x_medusa_pack_350101.md
dyidre/versions/350101/x_medusa_pack_350101_cf44_input.bin
```

## watch 结果

这次 write watch 只保留 `F8/X-Medusa` phase，并跳过 `CF07 memcpy`
本身的写入，所以剩下的是 work area 的真实原地变换。

| work area | address range | writer | hits | interp0 | status/record | 含义 |
|---|---:|---:|---:|---:|---:|---|
| mini-work | `0x1271c6a0..0x1271c6b4` | `libmetasec_ml.so+0x157ee4` | 20 | `0x310000010d7` | `0xcbc/0xcc2/0xcc7/0xccd` | F8 主程序用 `ST8` 按 4-byte 轮写 20 字节 |
| sub-work | `0x12607700..0x126079af` | `libmetasec_ml.so+0x157eb0` | 31 | `0x800001245f` | `0x82` | 嵌套 F12 用 `ST64` 覆盖前 `0xf8` 字节 |
| final-pack | `0x12607a00..0x12607cc8` | 无额外非 memcpy 写 | 0 | - | - | final 只接收变换后的片段，再给 CF44 |

两个 writer 都是 `0x1555A4 managedBytecodeRun_350` 内部的 bytecode handler：

```text
0x157EE4  managed op ST8   *(dst + off) = (uint8_t)value
0x157EB0  managed op ST64  *(dst + off) = value64
```

## mini-work：F8 主程序的 20 字节变换

mini 的预组装来自 F8 主程序两个 `CF07`：

| record | role | len |
|---:|---|---:|
| `0x0c57` | `mini+0x00 <- dyn4` | `0x04` |
| `0x0c94` | `mini+0x04 <- dyn16` | `0x10` |

随后 F8 主程序在四个 record 上循环写回：

| record | byte offset within 4-byte lane | writer |
|---:|---:|---:|
| `0x0cbc` | `+0` | `ST8 @ 0x157EE4` |
| `0x0cc2` | `+1` | `ST8 @ 0x157EE4` |
| `0x0cc7` | `+2` | `ST8 @ 0x157EE4` |
| `0x0ccd` | `+3` | `ST8 @ 0x157EE4` |

这四个 record 跑 5 轮，合计写满 `0x14` 字节。当前能稳定写成：

```c
void medusa_mutate_mini_350(uint8_t mini[0x14], uint32_t key32) {
    for (size_t off = 0; off < 0x14; off += 4) {
        mini[off + 0] ^= (uint8_t)(key32 >> 0);
        mini[off + 1] ^= (uint8_t)(key32 >> 8);
        mini[off + 2] ^= (uint8_t)(key32 >> 16);
        mini[off + 3] ^= (uint8_t)(key32 >> 24);
    }
}
```

对应 decoded asm：

```text
0xca6  s22 = *(uint64_t *)(state + 0x60)
0xcaf  s10 = s22 >> 16
0xcb0  s12 = s22 >> 24
0xcb1  s21 = (uint32_t)s22
0xcb3  s10 = s22 >> 8
0xcb8..0xccd  取 mini[off+0..3] 分别 xor key32 byte0..3 并 ST8 写回
```

注意：`key32 = (uint32_t)s22` 是动态值，不同 run 不一样；但同一轮 20 字节
里固定，且五个 4-byte lane 全部 XOR 同一个 little-endian key32。

两个已验证向量：

```text
watch/ST8 run:
  pre    05 00 00 00 2d 4b 4f ca 49 75 0d 43 3f b5 ae 2c 22 6d cc 56
  key32  0x6a948afb
  final  fe 8a 94 6a d6 c1 db a0 b2 ff 99 29 c4 3f 3a 46 d9 e7 58 3c

rawCF/final-pack run:
  pre    05 00 00 00 2d 4b 4f ca 49 75 0d 43 3f b5 ae 2c 22 6d cc 56
  key32  0x6a9484a4
  final  a1 84 94 6a 89 cf db a0 ed f1 99 29 9b 31 3a 46 86 e9 58 3c
```

Standalone oracle:

```text
dyidre/versions/350101/f8_medusa_mini_xor_recovered_350101.c
```

当前输出 `failures=0`。

## sub-work：嵌套 F12 的 bit-pack / bit-permute 变换

sub 的预组装来自 F8 主程序四个 `CF07`：

| record | role | len |
|---:|---|---:|
| `0x0d31` | `sub+0x000 <- flag1` | `0x01` |
| `0x0d6d` | `sub+0x001 <- time/seed-like bytes` | `0x08` |
| `0x0daa` | `sub+0x009 <- blob` | `0x2a4` |
| `0x0de8` | `sub+0x2ad <- trailer2` | `0x02` |

后续变换不是 F8 主 body 直接完成，而是进入嵌套 managed program：

```text
F12 global descriptor: 0x2c5930
F12 interp0/body id:   0x800001245f
F12 code:              0x125d0000..0x125d0f48
record count:          163
decode:                known 163 / unknown 0
```

F12 的核心循环在 record `0x1a..0x93`，每轮从独立 source stream 读取
1 byte，展开成一个 64-bit mask/bit-pack，然后用 `ST64` 写回 sub-work：

```text
0x00270  LD8U   s14 = *(uint8_t *)(src + 0)
...
0x00ae0  LD64   s1 = *(uint64_t *)(sp + 0x28)     ; 当前 dst qword
0x00af8  AND64
0x00b10  OR64
0x00b28  SHL64_VAR
...
0x00c30  ST64   *(s1 + 0x0) = s2                  ; writer 0x157EB0
...
0x00d98  len--
0x00db0  src++
0x00dc8  if (len != 0) goto record 0x1a
```

更正一个很容易踩坑的点：这里的 `s5` 不是 startBit/mode，而是 sub-work
长度/limit；`s7` 才是循环次数。当前 trace 里 `s5=0x2af`，所以一直走
“空间足够，`dst += 8`” 的大长度路径，bit phase 保持 `0`。

可以先把它叫成：

```c
void medusa_f12_bitpack_sub_prefix_350(uint8_t *dst, uint32_t limit,
                                       const uint8_t *src, uint32_t count) {
    if (limit < 8) {
        return;
    }

    uint32_t off = 0;
    uint32_t phase = 0;
    for (uint32_t i = 0; i != count; i++, src++) {
        uint8_t b = src[i];
        uint64_t old = *(uint64_t *)(dst + off);
        uint64_t v = spread_or_permute_bits_350(b, old, phase);
        *(uint64_t *)(dst + off) = v;

        if (limit >= off + 0x10) {
            off += 8;       // 当前 0x2af 大长度路径：31 次都是这里
        } else if (++phase >= 8) {
            break;          // 尾部小窗口路径，后续还要单独抓一轮确认
        }
    }
}
```

watch 中观测到 31 次 `ST64`，覆盖 `sub+0x000..sub+0x0f7`。这里的伪 C
表达已经验证的控制流/写入形状；尾部小窗口路径还没有单独触发过，暂时不硬命名。

当前大长度路径里 phase 恒为 `0`，F12 每轮等价于把一个 source byte 的 bit
散布到当前 qword 的固定 8 个位置：

| source bit | qword bit position when phase=0 |
|---:|---:|
| `bit1` | `6` |
| `bit7` | `13` |
| `bit3` | `19` |
| `bit6` | `28` |
| `bit2` | `34` |
| `bit0` | `47` |
| `bit4` | `49` |
| `bit5` | `56` |

用第一笔 watch 可以反推出唯一 source byte：

```text
old qword = 35 df 8d 3d 28 01 db 07  -> 0x07db01283d8ddf35
new qword = 35 ff 85 2d 28 81 db 07  -> 0x07db81282d85ff35
diff bits = [13, 19, 28, 47]
source    = 0xb1
```

这说明 `old[0] == 0x35` 只是 sub-work 原地旧值，不是 F12 的 source byte。
按同样规则，31 次写入可唯一反推 source stream：

```text
b1 58 6e 0f f7 2c f9 36 18 b1 c3 4c 92 b5 e1 24
c5 ea 12 ca 3d 0e f6 1c bb e6 e7 ff 9e fc df
```

### source stream 的上游：不是 CF97 单独生成

第一次只看 F12 邻近 CF trace 时，这个 source stream 能在 `CF97 @ 0x170110`
post-return 的 `slot4` 开头看到：

```text
CF97 @ 0x170110 post-return
  phase=F8/X-Medusa
  frame status=0x2d8 附近
  slot4 raw begins:
    b1 58 6e 0f f7 2c f9 36 18 b1 c3 4c 92 b5 e1 24
    c5 ea 12 ca 3d 0e f6 1c bb e6 e7 ff 9e fc df ...
```

但后续给 `slot4/source-work` 加写监控后，producer 已经能往前推一层。
多轮 source-work sweep 说明它不是固定只走 `F20/F40`，而是四套同构 family
都会被选择：

```text
F19/F32-family
  F19 outer source-work producer
  F32 block loop
  F34 scheduler
  F35/F36/F37/F38 primitives
  F30 GF(2^8) multiply

F20/F40-family
  F20 outer source-work producer
  interp0 = 0x1a0000132b5
  code    = 0x879000..0x87d200
  role    = 31-byte input + 0x01 padding -> 0x20 work buffer

  -> nested F40 block loop
     interp0 = 0x5000016333
     role    = 16-byte block loop, pre/post XOR key area, calls index 0x93

     -> index 0x93 -> F42 block-round scheduler
        -> nested F43/F44/F45/F46 16-byte transforms
        -> index 0x8b -> F30 GF(2^8) multiply
        F43 = round-key XOR, 4-byte endian-reversed key application
        F44 = S-box lookup + column byte rotation
        F45 = fixed 16-byte permutation
        F46 = MixColumns-like transform using F30

CF97 @ 0x170110
  role = boundary/commit/release-style helper; at its entry/post-return the
         transformed 32-byte source-work is already visible.

CF96 @ 0x1700d4
  role = locked shared-ref assignment / argument handoff before nested F12.

nested F12
  reads source-work first 31 bytes and ST64 bit-patches sub-work prefix.
```

本次 source-work 的输入/输出边界：

```text
pre-transform 31 bytes:
38 64 29 d4 8c c8 ad cd d1 44 d8 23 be 29 32 5e
b2 e5 0c c6 63 65 7d 5a 4c 85 fe eb fd ac a2

post-transform 32 bytes:
e6 40 ad 61 51 42 bb 3d 39 f4 fd 74 64 85 cc 03
14 54 d5 57 a8 0f 56 59 fe 8e 14 d3 68 55 0e 3b
```

所以现在不要再说“CF97 产出 source stream”。更精确的说法是：
`F19/F32-family` 或 `F20/F40-family` 负责 source-work 生产和块变换，
`CF97` 是 F12 前能观察到结果的边界点。

两套 family 的对照见：

```text
dyidre/versions/350101/source_work_family_compare_350101.md
```

`CALL_CF_INDEX` 的关键映射已经确认：

```text
op5e handler 0x1570DC -> 0x15AB1C:
  program = (*(record.q1))[imm32]

q1 = 0x125fd3c0
*q1 = 0x12608000

index 0x8b -> program 0x127beec0 -> F30, code 0x125e2000..0x125e21f8
index 0x93 -> program 0x128b70c0 -> F42, code 0x1260cb00..0x1260cf08
```

`F30` 的唯一未知 opcode 已补洞：`op23 = SEXT8_SLOT`，语义是
`S[c] = (int64_t)(int8_t)(uint8_t)S[b]`。因此 `F30` 可以恢复成
`GF(2^8)` 乘法，`xtime` 的 reduction constant 是 `0x1b`。`F42` 是
`F40` 里的 16-byte round scheduler，顺序是：

```text
F43(round=0)
F44
F45
F46
F43(round=1)
F44
F45
F43(round=2)
```

这整体非常像一段短轮数 AES-style block transform，但在确认 S-box/key
schedule 来源前，不直接命名成标准 AES。

## decoder 补洞

F12 初次 decode 时只剩一个 unknown opcode：

```text
record 0x41: op=0x13 08 04 04 0f
```

静态 handler 位于：

```text
op 0x13 handler entry: 0x157A90
0x157ABC cmp x9, x10
0x157AC0 cset w9, lo
0x157608 str x9, [slot_base, dst, lsl #3]
```

所以 `op13` 已补成：

```text
CMP_LO64  dst = ((uint64_t)src_a < (uint64_t)src_b) ? 1 : 0
```

另外这次顺手纠正了两个移位 opcode，避免把常见的 32-bit zext/trunc 看成
异常大移位：

```text
op67 = LSR64_IMM32PLUS  dst = src >> (imm + 32)
op68 = LSR64_IMM        dst = src >> imm
```

重新 decode 后：

```text
F12 records 163, known 163, unknown 0
```

## 复现命令

```bash
cd /Users/freeman/project/douyin/unidbg

./mvnw -pl unidbg-android -Dmaven.test.skip=false -Dtest=Sign6_350101 test \
  -Dmetasec.dumpManagedCfArgs=true \
  -Dmetasec.dumpManagedInterp=true \
  -Dmetasec.dumpManagedCfPost=true \
  -Dmetasec.watchF8WorkAreas=true \
  -Dmetasec.f8WorkAreaWatchMaxEvents=600 \
  -Dmetasec.managedCfMaxEvents=180 \
  -Dmetasec.managedCfPostMaxEvents=180 \
  -Dmetasec.managedCfMaxBytes=0x80 \
  -Dmetasec.managedCfCallsites=0x16ec90,0x16f14c,0x16f96c,0x1700d4,0x170110,0x170188,0x170258,0x16f544,0x170128
```

重新 decode F12：

```bash
python3 /Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py \
  --dump-dir /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_f12_350101_20260831_035801 \
  --vmctx-log /Users/freeman/project/douyin/unidbg/unidbg-android/target/sign6_350101_f8_watch_interp_20260831_035639.log \
  --out-dir /Users/freeman/project/douyin/dyidre/versions/350101/managed_vm_decode_f12
```

## 后续升级版本时怎么用

1. 先找 `F8/X-Medusa` 的 `CF44` input，验证 `base64(input) == X-Medusa`。
2. 再按最终 pack 的 `0x14 + 2 + 1 + 1 + 1 + 0x2af` 形状对齐。
3. 盯 `ST8/ST64` 写点，而不是只看 `CF07`：
   - `mini`: F8 主 `ST8` 四个 record、5 轮；
   - `sub`: 嵌套 F12 `ST64` record `0x82`、31 轮。
     当前大长度路径是 `limit=0x2af,count=31,phase=0,dst+=8,src++`。
4. 动态字节可能变，稳定锚点是 program descriptor、record/status、writer handler
   和最终 CF44/base64 边界。
