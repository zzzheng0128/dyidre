# 350.101 CF48 short-header transform lift

Scope:

- CF wrapper: `0x16F660 CF48`
- lower helper: `0x16CCD8 shortHeaderTransform32_flattened_CF48_350`
- shared table: `0x29F420 flat_dispatch_jumptable_16b8_16e4_350`
- managed block program: `F17`, global `0x2C5958`, code body `0x8721C0`
- callers: managed `F7` / `F13`

Recovered C shape:

```text
dyidre/versions/350101/cf48_f17_recovered_350101.c
```

Current oracle coverage:

```text
CF48: text + key32 -> transform32
CF49: prefix4 || transform32 -> pack36
CF44: standard base64(pack36) -> 48-char short header
```

The standalone C selfcheck reproduces both observed runtime chains:

```text
F7/X-Ladon   out32 match + base64 match
F13/X-Helios out32 match + base64 match
failures=0
```

## Position in the header chain

```text
F7/F13 bytecode
  -> CF100("%u-%s-%s")       // text, e.g. "1788108717-1588093228-1128"
  -> CF38*2                  // two 4-byte MEM_BLOCK seeds
  -> CF48                    // text + key32 -> transform32
  -> CF49                    // prefix4 || transform32 -> 0x24 bytes
  -> CF44                    // base64 -> 0x30 chars
  -> CF98*2                  // key/value output
```

`CF48` 本身不是最终 header 输出；它只负责短头里面的 32-byte 二进制
`transform32`。最终 `X-Ladon/X-Helios` 是 `prefix4 + transform32` 再 base64。

## Wrapper ABI

`0x16F660 CF48` 从 managed frame 取 slot：

```text
slot4 = formatted_text MEM_BLOCK
slot5 = out_transform32 MEM_BLOCK / scratch
slot6 = key_material32 MEM_BLOCK
slot2 = return / status
```

下层 `0x16CCD8` 的 C 形状是：

```c
uint64_t shortHeaderTransform32_flattened_CF48_350(
    MEM_BLOCK *formatted_text,
    MEM_BLOCK *out_transform32,
    MEM_BLOCK *key_material32);
```

## `0x16CCD8` normal path

入口先走 shared flatten table，但 CF48 正常非空 `formatted_text` 的 index
固定为 `0x58`：

```text
0x16CCF4  W9 = 0x58
0x16CCFC  cmp X0, #0
0x16CD0C  W8 = 0x54
0x16CD10  W8 = (X0 == 0) ? 0x54 : 0x58
0x16CD20  X8 = table[W8]
0x16CD28  BR X8
```

正常 index `0x58` 指向 `0x16CD2C`：

```text
0x16CD2C  X19 = out_transform32
0x16CD30  X20 = formatted_text
0x16CD34  local_key = clone(key_material32)
0x16CD4C  W8 = key_material32.src_len
0x16CD58  if W8 < 0x20 goto pad_key_to_32
0x16CD90  call 0x16E794(text.mem, text.src_len, &out_ptr, &out_len, local_key.mem)
0x16CDE4  make/fill out_transform32 with out_len, max 0x20
0x16CE04  free(out_ptr)
```

这里关键是 `key_material32` 会被补到 32 字节。输入如果不足 `0x20`，
`0x16CD68..0x16CD88` 会创建一个零填充尾巴并 concat 到 local key。

## `0x16E794` lower transform

`0x16E794` 的实参来自 `0x16CD90`：

```c
uint64_t cf48_lower_transform_16E794(
    const uint8_t *text,
    uint32_t text_len,
    uint8_t **out_ptr,
    uint32_t *out_len,
    const uint8_t *key32);
```

当前可读流程：

```c
uint64_t cf48_lower_transform_16E794(
    const uint8_t *text,
    uint32_t text_len,
    uint8_t **out_ptr,
    uint32_t *out_len,
    const uint8_t *key32)
{
    uint8_t schedule[0x1f8] = {0};
    MEM_BLOCK key_block  = initMemBlockBySrc(key32, 0x20);
    MEM_BLOCK text_block = initMemBlockBySrc(text, text_len);

    /*
     * 0x16E8FC(key_block.mem, schedule)
     * 从 key32 生成一段 8-byte 对齐 schedule。
     */
    cf48_seed_schedule_16E8FC(key_block.body.mem, schedule);

    /*
     * text_len 会被按 0x10 对齐；0x1719B0:
     *   rounded = ((text_len + 0x10) / 0x10) << 4
     *   pad_len = rounded - text_len
     *
     * 0x16E81C..0x16E828 用 pad_len&0xff 作为填充值，
     * 所以是 PKCS#7-like padding，不是 zero padding。
     */
    MEM_BLOCK pad = make_fill_memblock(pad_len & 0xff, pad_len);
    append(&text_block, &pad);

    /*
     * 后面按 0x10 分组处理 text_block，内部调用 managed F17：
     *   slot4=schedule, slot5=input16, slot6=output16。
     * 最终 out_ptr/out_len 被写回。
     */
    transform_blocks_with_schedule(&text_block, schedule, out_ptr, out_len);

    free local MEM_BLOCKs;
    return 0;
}
```

## `0x16E8FC` key schedule / mixer

`0x16E8FC` 比较关键，已经能从汇编直接写成形状稳定的伪代码。

实参：

```text
X0 = key32 bytes
X1 = output schedule buffer
```

行为：

1. 先把 `key32` 的 4 个 qword 拷到本地 `state[4]`；
2. 先输出 `state[0]` 到 schedule；
3. 循环 `i = 0..0x21`，每轮输出 8 bytes；
4. 每轮更新：

```c
uint64_t a = state[0];
uint64_t b = state[1];

uint64_t nb = ror64(b, 8) + a;
nb ^= i;

uint64_t na = nb ^ ror64(a, 61);

state[0] = na;
state[1] = state[2];
state[2] = state[3];
state[3] = nb;

emit64(schedule, state[0]);
```

汇编锚点：

```text
0x16E960..0x16E984  copy 4 qwords from key32 into local state
0x16E988..0x16E994  emit initial 8 bytes
0x16E9B4            load state[0], state[1]
0x16E9C8            ror state[1], #8
0x16E9D0            add rotated state[1] + state[0]
0x16E9D4            xor loop counter
0x16E9D8            xor ror(state[0], #61)
0x16E9E4            emit next 8 bytes
0x16E9F0            loop until counter == 0x22
```

这个 mixer 很像一个轻量 64-bit ARX schedule；目前先叫
`cf48_seed_schedule_16E8FC`，不强行命名具体算法。

## Managed F17 block transform

`0x17184C` 把 `0x2C5958` 的 F17 程序取出来执行：

```text
slot4 = schedule
slot5 = input16
slot6 = output16
```

F17 body `0x8721C0` 共 17 条 VM record，已经完整解码。核心就是 34 轮
ARX/Speck-like block transform：

```c
uint64_t y = load64_le(input16 + 0);
uint64_t x = load64_le(input16 + 8);

for (int round = 0; round < 34; round++) {
    x = (ror64(x, 8) + y) ^ schedule[round];
    y = rol64(y, 3) ^ x;
}

store64_le(output16 + 8, x);
store64_le(output16 + 0, y);
```

opcode 证据：

```text
op73 @ handler 0x156AE4 -> ROR64_IMM
op72 @ handler 0x157370 -> ROL64(32 - imm)
F17 record 0x0005: op73 imm=8  -> ror64(x,8)
F17 record 0x000B: op72 imm=29 -> rol64(y,3)
```

`managedFrameAcquire_350` 会清空 `frame->buf+0x8100` slot 表，所以 `s0`
按 0 处理；F17 loop 因此消费 schedule offset `0..0x108`，共 34 个 qword。
`0x16E8FC` 额外生成的最后一个 qword 当前按冗余/相邻变体备用记录。

验证结果：

```bash
python3 /Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_cf48_f17_probe.py \
  --text 1788108717-1588093228-1128 \
  --key-ascii b5b49dcffaa587dccaa36fec8005a08c \
  --expect 7abd4bdb12ba2b2282a8effd65ea43270d9cf5e5debec2510c62ca7017a431fe

python3 /Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_cf48_f17_probe.py \
  --text 1788108717-1588093228-1128 \
  --key-ascii c4aebafaa687f565cdec6d5eb75c95de \
  --expect 74f55f3e23d3c8570d15dfe5d4a2fdc065c7e3cec26867545a7924ef16a36af9
```

两组均 `match=True`。

## Runtime examples

```text
F7 / X-Ladon:
  text    = "1788108717-1588093228-1128"
  key32   = "b5b49dcffaa587dccaa36fec8005a08c"
  out32   = 7a bd 4b db 12 ba 2b 22 82 a8 ef fd 65 ea 43 27 ...
  pack36  = 7c c8 a0 10 || out32
  base64  = "fMigEHq9S9sSuisigqjv/WXqQycNnPXl3r7CUQxiynAXpDH+"

F13 / X-Helios:
  text    = "1788108717-1588093228-1128"
  key32   = "c4aebafaa687f565cdec6d5eb75c95de"
  out32   = 74 f5 5f 3e 23 d3 c8 57 0d 15 df e5 d4 a2 fd c0 ...
  pack36  = 30 e4 7f 2c || out32
  base64  = "MOR/LHT1Xz4j08hXDRXf5dSi/cBlx+POwmhnVFp5JO8Wo2r5"
```

`0x16E8FC` 的 schedule 不是最终 `out32` 本身。用上述 mixer 复算：

```text
F7 key32 schedule[:32]:
  62 35 62 34 39 64 63 66 d0 3d 86 cf b9 e9 dd ff
  b7 71 88 79 ee 02 ae 9d 59 2c fe 16 6d 2c 61 3b

F13 key32 schedule[:32]:
  63 34 61 65 62 61 66 61 82 cf 91 e0 84 9c a8 c9
  f1 48 7b 12 ce 35 49 60 a1 39 04 d8 73 34 e7 c0
```

它们和 observed `CF48 out32` 不相等，也找不到完整 out32 子串。结论：
`0x16E8FC` 是 key schedule / seed stream；最终 32-byte `out32` 还要经过
`0x16E794` 后半段对 formatted text 的 F17 block transform。

复算脚本：

```bash
python3 /Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_cf48_schedule_probe.py \
  b5b49dcffaa587dccaa36fec8005a08c \
  --target-out32 7abd4bdb12ba2b2282a8effd65ea43270d9cf5e5debec2510c62ca7017a431fe
```

## Remaining edge work

`0x16E794` 后半段已经确认到 F17 block transform，padding 也已确认是
PKCS#7-like。核心数据变换、CF49 拼接、CF44 base64 都已用 runtime vector
复现。后续剩下的是更细的运行时复现问题：CF48 写回
`MEM_BLOCK out_transform32` 的 malloc/free、错误码和超长输入边界条件。现在已经能确定：`CF48`
的“随机性/差异”主要来自三类输入：

- `CF100` 的 formatted text；
- F7/F13 各自选择的 32-byte key material；
- F7/F13 各自的 4-byte prefix，后续由 `CF49` 拼到 out32 前面。
