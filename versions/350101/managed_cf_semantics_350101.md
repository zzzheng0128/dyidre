# 350.101 managed CF semantics / trace summary

口径更正（2026-08-31）：这份文件里的 `F5/F8` compact CF sequence
来自 phase-level hook，可能包含 nested/helper managed program 的 CF 调用。
真正按 F5/F7/F8/F13/F15 bytecode record 对齐时，应以
`managed_vm_decode/*.decoded.stats.md` 为准；新版 decoder 会用
`interp+0x00 == (stack_need << 32) | entry_or_flags` 过滤误标。

证据来源：
- `unidbg_full`: `unidbg/unidbg-android/target/mcp_trace_350101_full/unidbg_mcp_libmetasec_full.seq`
- `unidbg_unique`: `unidbg/unidbg-android/target/mcp_trace_350101_full/unidbg_mcp_libmetasec_full.unique.seq`
- `gumtrace_unique`: `unidbg/unidbg-android/target/mcp_trace_350101_full/gumtrace_getHttpHeadVerify_350.full.unique.seq`
- `cf_args`: `unidbg/unidbg-android/target/sign6_350101_cfargs_20260830_235936.log`
- `cf_post`: `unidbg/unidbg-android/target/sign6_350101_cfpost_20260831_000758.log`
- material-flow report: `dyidre/versions/350101/x_argus_medusa_material_350101.md`
- shared flatten report: `dyidre/versions/350101/flat_dispatch_350101.md`

## 覆盖差异

- CF 表总数：102
- unidbg unique 命中：88
- GumTrace unique 命中：85
- unidbg 有、真机 unique 没看到：CF31, CF33, CF41, CF42, CF43
- 真机有、unidbg unique 没看到：CF54, CF86

## unidbg full 高频 CF

| CF | count | 语义暂定 |
|---|---:|---|
| CF11 | 99 | freeMemBlock(slot4) |
| CF08 | 44 | doFreeInfoByRef_1(slot4) |
| CF12 | 24 | copyStringMemBlock2(dst=slot4, cstr=slot5) |
| CF38 | 19 | initMemBlockBySrc(dst=slot4, src=slot5, len=slot6) |
| CF25 | 18 | get global/env object via sub_4303C() -> slot2 |
| CF07 | 17 | memCopy2(dst=slot4, src=slot5, len=slot6) -> slot2 |
| CF37 | 17 | copyMemBlock(dst=slot4, src=slot5) |
| CF05 | 16 | init MEM_BLOCK(8 bytes) from slot4; returns pointer/body-ish. IDA: slot4 -> initMemBlock8 |
| CF26 | 16 | query map/registry sub_119488(slot4, slot5) -> slot2; default 0xa985f if missing |
| CF30 | 13 | catMemBlock4(dst?=slot5, arg=slot6, src?=slot4) |
| CF10 | 10 | copyMemBlockData(dst=slot4, src=slot5) -> slot2 |
| CF16 | 8 | read/global singleton via sub_12E0C8() -> slot2 |
| CF32 | 8 | construct/format MEM_BLOCK with fill byte + len: sub_10B510(slot4, slot5, slot6) |
| CF79 | 8 | cJSON_AddNumberToObject_double(obj=slot4, key=slot5, value=slot2 double) -> slot2 bool |
| CF98 | 8 | formatAllocString(char**=slot4, fmt/string=slot5) via sub_16EA30 -> slot2 maybe return |
| CF29 | 7 | calls loc_11AF7C(slot5, slot6&1); slot4 appears unused/receiver |
| CF39 | 6 | getJsonList_http_client_type(slot4) -> slot2 |
| CF61 | 5 | SM3 wrapper: `sm3OneShot_F15InitUpdateFinal_350(slot4, slot5, slot6)` -> slot2=0 |
| CF13 | 4 | sub_57FD4(slot5); slot4 appears receiver/unused |
| CF14 | 4 | isEmptyMemBlock(slot4) -> slot2 bool |
| CF15 | 4 | cloneObjectAddRef_9(dst_ref=slot4, src_ref=slot5) |
| CF21 | 4 | sub_625AC(slot4) |
| CF36 | 4 | sub_12B904(slot4,slot5) -> slot2 |
| CF44 | 4 | doBase64Encode(input=slot5, out_ref=slot4) |
| CF62 | 4 | sub_642B0(slot4,slot5) |
| CF27 | 3 | decryptString3(slot4, slot5) -> slot2 |
| CF45 | 3 | decryptString2(slot4, slot5) -> slot2 |
| CF47 | 3 | decryptString1(slot4, slot5) -> slot2 |
| CF00 | 2 | sub_10BFD8(slot4, byte/int slot5, len slot6) |
| CF04 | 2 | newMem(size=slot4) -> slot2 |

## 按 managed program 精确切片

这里的区间按 full trace 行号精确切：从 `buildSignedHttpHeadersInner_350`
调用对应 managed wrapper 开始，到对应 header `treeMapPut` 前结束。
`stage1/stage2` native pre-sign 本身不跑 CF 表。

| Program | Header | Trace interval | CF events | unique CF | 高频/关键原语 |
|---|---|---:|---:|---:|---|
| `F5` | `X-Argus` | `0x14A38C -> 0x14A3A0` | 143 | 42 | `CF11` free、`CF08` release、`CF38` init-by-src、`CF30` concat、`CF61` digest、`CF44` base64 |
| `F7` | `X-Ladon` | `0x14A3EC -> 0x14A400` | 31 | 17 | `CF100` format、`CF48/49` flattened transform+concat、`CF44` base64、`CF98` format |
| `F8` | `X-Medusa` | `0x14A4E0 -> 0x14A53C` | 256 | 79 | `CF07/12/25/26/79` 大量环境/JSON 字段收集，随后 `CF61/44/98` 变换输出 |
| `F13` | `X-Helios`/`X-Soter` side | `0x14A588 -> 0x14A5A8` | 31 | 17 | 形态接近 `F7`，但解密字符串原语顺序略不同 |

## 参数级 CF probe 精简切片

这组数据来自 `sign6_350101_cfargs_20260830_235936.log`，只统计已安装
参数 dump 的高价值 helper，所以数量小于 full trace，但能看到每次 helper
拿到的 slot 值、输入长度和部分内容。

| Stage | Header | Hooked CF events | Counts | 关键输入/输出 |
|---|---|---:|---|---|
| `F5` | `X-Argus` | 19 | `CF61x3 CF38x8 CF10x5 CF44x1 CF98x2` | query len `0x2c0`、`x_ss_stub` len `0x10`、0x44 中间包、`CF44` input `src_len=0xc2`、header len `0x104` |
| `F7` | `X-Ladon` | 5 | `CF38x2 CF44x1 CF98x2` | short pack: `"1128"` + `"1588093228"`，`CF100` format `%u-%s-%s`，`CF48` output32 + 4-byte prefix 经 `CF49` 拼成 `0x24`，header len `0x30` |
| `F8` | `X-Medusa` | 42 | `CF61x2 CF38x7 CF10x5 CF07x17 CF79x8 CF44x1 CF98x2` | full pack `final_flag=1`，JSON 数字字段 `cmr/cmr2/un_h/vpn/kd/fkd/pd/do`，`CF44` input `src_len=0x2c4/0x2c8` 类，最新 raw-CF07 证明为 `0x2c8`，header len `0x3b0/0x3b8` 类 |
| `F13` | `X-Helios` | 5 | `CF38x2 CF44x1 CF98x2` | short-pack 形态同 `F7`，`CF100` format `%u-%s-%s`，`CF48/CF49` 生成 `0x24` binary pack，header len `0x30` |

参数级 compact sequence:

```text
F5/X-Argus:
CF61 -> CF38 -> CF10 -> CF61 -> CF38 -> CF10*3 -> CF38*3 -> CF61 -> CF38 -> CF10 -> CF38*2 -> CF44 -> CF98*2

F7/X-Ladon:
CF38*2 -> CF44 -> CF98*2

F8/X-Medusa:
CF61 -> CF38 -> CF10 -> CF07*3 -> CF10*3 -> CF79*8 -> CF38*3 -> CF61 -> CF38 -> CF10 -> CF07*8 -> CF38*2 -> CF07*6 -> CF44 -> CF98*2

F13/X-Helios:
CF38*2 -> CF44 -> CF98*2
```

核心理解：

- `CF61` 已确认是 SM3 one-shot：managed F15 写入标准 SM3 IV，
  native update 按 64 字节分组吸收输入，final 补 padding/bit-length 并输出
  32 字节大端 digest。`0x16D86C` 压缩体仍被 jump-table flatten，但
  raw vector 5/5 与标准 SM3 完全一致。
- `CF44` 是 base64 出口。Argus 这次输入 `src_len=0xc2`，Medusa 当前观察到
  `src_len=0x2c4/0x2c8` 类。最新 `x_medusa_pack_350101.md` 证明
  `0x2c8` CF44 input 经 base64 后逐字节等于最终 `X-Medusa`，这是新版本对齐时
  最硬的形状锚点。
- `CF98("%s")` 是 managed 程序把生成的 key/value 字符串写回外层
  `char **out_key/out_value` 的出口。
- `CF100("%u-%s-%s")` 在 F7/F13 后置探针中输出明文 MEM_BLOCK；
  这次 focused run 里是 `1788108717-1588093228-1128`。这说明
  Ladon/Helios 的短包先做
  seed/time + 两个字符串字段拼接，再进入后面的紧凑二进制/base64。
- `CF48` 位于 F7/F13 的 `CF100` 明文格式化之后、`CF49/CF44` 之前；
  入参形态是 `slot4=0x1a 明文`、`slot5=4-byte prefix/scratch`、
  `slot6=32-byte ASCII hex-like key/material`。返回后 `slot5` 变成
  32-byte binary transform result。
- `CF49` 把原来的 4-byte prefix 和 `CF48` 产生的 32-byte result 拼成
  `0x24` byte binary pack；`CF44` 对这个 `0x24` pack 做 base64，刚好得到
  48 字符的 `X-Ladon/X-Helios`。
- `CF48` 下层已拆到可复算核心：
  `0x16CCD8` 选择 shared flatten index `0x58` 后 clone/pad key32，
  `0x16E794` 生成 padding 并逐 16-byte block 调 `0x17184C`，
  `0x16E8FC` 是 64-bit ARX schedule，`0x17184C` 调 managed F17 做 34 轮
  Speck-like block transform。`cf48_f17_recovered_350101.c` 已经把
  `CF48 -> CF49 -> CF44` 两组短头向量复算到 `failures=0`。
- `CF01/CF02/CF03/CF48/CF61` 都会进入 `flat_dispatch_jumptable_16b8_16e4_350`
  这张共享跳表。它是 control-flow flatten 设施，不是某一个算法的专属常量表。
  其中 CF61 的语义已由 raw vector 单独验证为 SM3；CF48 的短头核心已用
  runtime 向量验证，剩余未知主要是 MEM_BLOCK 分配/错误码边界。
- `CF79` 读 numeric value 时调用 `0x154784 managedFrameGetSlotDouble_350`；
  slot<=7 的 double 值在 `frame->buf + 0x82e0 + slot*8`，不是普通 qword slot
  的 `+0x8100` 视图。
- `CF98` 后置探针确认了 key/value 出口：
  `F5 -> X-Argus`，`F7 -> X-Ladon`，`F8 -> X-Medusa`，
  `F13 -> X-Helios`。
- `F8` 里的 `CF79x8` 明确说明 Medusa 包含一组环境/检测状态 JSON 数字字段。
- `F8` 的 early `CF07` 先组装 mini/sub 两个 work area；二者在最终拷贝进
  CF44 input 前会被原地变换。因此不能只看 early CF07 字节就认为已经是最终
  X-Medusa pack。
- 最新 write-watch 进一步确认：work area 原地变换不是 `CF07` 做的，而是
  managed bytecode handler 直接写内存。mini 由 F8 主程序 `ST8 @ 0x157EE4`
  写 20 次；large subpack 前 `0xf8` 字节由嵌套 F12
  `ST64 @ 0x157EB0` 写 31 次。详细见
  `f8_x_medusa_mutation_watch_350101.md`。

Compact sequences:

```text
F5/X-Argus:
CF05x2 CF61 CF38 CF10 CF11 CF61 CF38 CF10 CF11 CF12 CF13 CF15 CF14 CF08 CF10 CF16 CF17 CF18 CF19 CF12 CF15 CF14 CF08 CF10 CF62 CF20 CF21 CF22 CF23 CF24 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF27 CF05x2 CF28 CF31 CF32 CF33 CF16 CF62 CF36 CF12 CF35 CF34 CF37 CF08x2 CF11 CF21 CF38 CF29 CF37 CF08 CF11 CF38 CF29 CF37 CF08 CF11 CF38 CF30x2 CF61 CF38 CF11x3 CF05 CF39x2 CF05 CF41 CF30 CF10 CF11x2 CF32 CF39 CF16 CF38x2 CF30x2 CF42 CF30 CF11x5 CF43 CF37 CF08 CF42 CF30 CF44 CF37 CF08 CF11x2 CF45 CF46 CF98 CF47 CF98 CF11x12 CF08x2 CF11 CF08x4 CF11x3

F7/X-Ladon:
CF16 CF13 CF37 CF08 CF05 CF100 CF38 CF30 CF29 CF37 CF08 CF11x2 CF38 CF05 CF48 CF49 CF44 CF37 CF08 CF27 CF36 CF98 CF45 CF98 CF11x6

F8/X-Medusa:
CF50 CF51 CF61 CF38 CF10 CF11 CF32 CF07x3 CF63 CF64 CF10 CF11x2 CF12 CF13 CF15 CF14 CF08 CF10 CF16 CF17 CF18 CF19 CF65 CF12 CF15 CF14 CF08 CF10 CF62 CF20 CF21 CF22 CF23 CF24 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF25 CF12 CF26 CF11 CF66 CF25 CF12 CF26 CF11 CF67 CF08 CF67 CF08 CF68 CF69x2 CF08x2 CF70 CF71 CF72 CF73 CF25 CF12 CF74 CF11 CF05x3 CF28 CF25 CF12 CF26 CF11 CF76 CF04 CF05 CF06 CF99 CF30 CF29 CF77 CF08 CF11 CF78 CF80 CF79 CF81 CF79 CF82 CF79 CF83 CF79x3 CF77 CF79 CF25 CF12 CF84 CF11 CF85 CF11 CF79 CF87 CF88 CF95 CF89 CF90 CF00 CF91 CF92 CF08 CF93 CF08x2 CF11x3 CF08x2 CF11 CF08x4 CF11 CF16 CF62 CF47 CF12 CF35 CF34 CF37 CF08x2 CF11 CF21 CF38 CF29 CF37 CF08 CF11 CF38 CF29 CF37 CF08 CF11 CF38 CF30x2 CF61 CF38 CF11x3 CF05 CF39x2 CF05 CF00 CF02 CF30 CF10 CF11x2 CF32 CF39 CF16 CF32 CF07x2 CF32 CF07x4 CF32 CF37 CF07 CF60 CF07 CF04 CF38 CF97 CF06 CF11 CF40 CF08 CF96 CF08 CF37 CF08 CF38 CF32 CF07x6 CF44 CF37 CF08 CF36 CF45 CF98 CF46 CF98 CF11x13 CF52

F13/X-Helios:
CF16 CF13 CF37 CF08 CF05 CF100 CF38 CF30 CF29 CF37 CF08 CF11x2 CF38 CF05 CF48 CF49 CF44 CF37 CF08 CF47 CF27 CF98 CF36 CF98 CF11x6
```

## 已确认/半确认 CF 语义

| CF | entry | 语义 |
|---|---:|---|
| CF00 | `0x16ea70` | make/fill MEM_BLOCK: sub_10BFD8(slot4, byte/int slot5, len slot6) |
| CF01 | `0x16eac0` | 5-slot flattened transform wrapper -> `flattenedTransform_CF01_350` |
| CF02 | `0x16eb40` | 5-slot flattened transform wrapper -> `flattenedTransform_CF02_350` |
| CF03 | `0x16ebc0` | flattened MEM_BLOCK transform wrapper -> `flattenedMemBlockTransform_CF03_350(slot5, slot6)` |
| CF05 | `0x16ec3c` | init MEM_BLOCK(8 bytes) from slot4; returns pointer/body-ish. IDA: slot4 -> initMemBlock8 |
| CF07 | `0x16ec90` | memCopy2(dst=slot4, src=slot5, len=slot6) -> slot2 |
| CF08 | `0x16ecf0` | doFreeInfoByRef_1(slot4) |
| CF10 | `0x16ed54` | copyMemBlockData(dst=slot4, src=slot5) -> slot2 |
| CF11 | `0x16eda0` | freeMemBlock(slot4) |
| CF12 | `0x16edb8` | copyStringMemBlock2(dst=slot4, cstr=slot5) |
| CF13 | `0x16edf4` | sub_57FD4(slot5); slot4 appears receiver/unused |
| CF14 | `0x16ee2c` | isEmptyMemBlock(slot4) -> slot2 bool |
| CF15 | `0x16ee58` | cloneObjectAddRef_9(dst_ref=slot4, src_ref=slot5) |
| CF16 | `0x16ee94` | read/global singleton via sub_12E0C8() -> slot2 |
| CF17 | `0x16eeb8` | sub_46944(slot5); slot4 appears receiver/unused |
| CF18 | `0x16eef0` | sub_624BC(slot5); slot4 appears receiver/unused |
| CF19 | `0x16ef28` | sub_11A200(slot5); slot4 appears receiver/unused |
| CF20 | `0x16ef60` | sub_1258A0(slot5); slot4 appears receiver/unused |
| CF21 | `0x16ef98` | sub_625AC(slot4) |
| CF22 | `0x16efb0` | sub_AA9B4(slot4) |
| CF23 | `0x16efcc` | sub_5897C(frame) -> slot2 |
| CF24 | `0x16eff0` | sub_62260(frame) -> slot2 |
| CF25 | `0x16f014` | get global/env object via sub_4303C() -> slot2 |
| CF26 | `0x16f038` | query map/registry sub_119488(slot4, slot5) -> slot2; default 0xa985f if missing |
| CF27 | `0x16f084` | decryptString3(slot4, slot5) -> slot2 |
| CF29 | `0x16f0fc` | calls loc_11AF7C(slot5, slot6&1); slot4 appears unused/receiver |
| CF30 | `0x16f14c` | catMemBlock4(dst?=slot5, arg=slot6, src?=slot4) |
| CF32 | `0x16f1c8` | construct/format MEM_BLOCK with fill byte + len: sub_10B510(slot4, slot5, slot6) |
| CF33 | `0x16f218` | j_postDataWriteBuf(slot4, slot5) -> slot2 |
| CF34 | `0x16f264` | base64DecodeMemBlockToRef_350(slot5); slot4 appears receiver/unused |
| CF35 | `0x16f29c` | loc_12564C(slot5, slot6); slot4 appears receiver/unused |
| CF36 | `0x16f2ec` | sub_12B904(slot4, slot5) -> slot2 |
| CF37 | `0x16f338` | copyMemBlock(dst=slot4, src=slot5) |
| CF38 | `0x16f374` | initMemBlockBySrc(dst=slot4, src=slot5, len=slot6) |
| CF41 | `0x16f43c` | Argus tail SIMON128/256 transform: slot4=input `XArgusStruct` wire MEM_BLOCK, slot5=out MEM_BLOCK, slot6=key/material; inner `0x16E538` PKCS#7-pads input, `0x16E678` expands 32-byte key to 72 round keys, `0x1717F4` runs managed F16 per 16-byte block; current vector `0x92 -> 0xa0`, oracle failures=0 |
| CF42 | `0x16f48c` | exact u16 pack helper: hidden out=slot4, low16(slot5) -> 2-byte little-endian MEM_BLOCK via `0x16CC84` |
| CF43 | `0x16f4c4` | Argus tail AES mode/PKCS#7 transform wrapper: hidden out=slot4, body=slot5, 16-byte key/material=slot6, iv/side=slot7, modeDesc=slot8; inner `0x11BF94` pads `0xb3 -> 0xc0` in current F5; current `modeDesc[0].type=1` is AES-128-CBC, `0x11CBB4` in-place output is final `outC0` |
| CF44 | `0x16f544` | doBase64Encode(input MEM_BLOCK slot5 -> output REF slot4) |
| CF45 | `0x16f57c` | decryptString2(slot4, slot5) -> slot2 |
| CF46 | `0x16f5c8` | decryptString4(slot4, slot5) -> slot2 |
| CF47 | `0x16f614` | decryptString1(slot4, slot5) -> slot2 |
| CF48 | `0x16f660` | short-header transform wrapper: `shortHeaderTransform32_flattened_CF48_350(slot4 text, slot5 out32, slot6 key32)` |
| CF49 | `0x16f6b0` | build 0x24 short header binary pack: prefix4(slot4) + transform32(slot5) -> slot2 |
| CF54 | `0x16f79c` | substring MEM_BLOCK: src slot5, start slot6, len slot7, dst slot4 |
| CF60 | `0x16f96c` | alloc/prepare helper: size slot4 -> allocated pointer in slot2 |
| CF61 | `0x16f998` | SM3 wrapper: `sm3OneShot_F15InitUpdateFinal_350(slot4, slot5, slot6)` -> slot2=0 |
| CF62 | `0x16f9f8` | sub_642B0(slot4, slot5) |
| CF79 | `0x16fd64` | cJSON_AddNumberToObject_double(obj=slot4, key=slot5, value=managedFrameGetSlotDouble_350(slot2)) -> slot2 bool |
| CF86 | `0x16ff00` | URL-safe base64 normalize/decode-check: `-` -> `+`, `_` -> `/`, decode success bool -> slot2 |
| CF96 | `0x1700d4` | locked shared-ref assign: clear dst, lock, copy ref pair from src, inc refcnt, unlock |
| CF97 | `0x170110` | source-stream/release helper: has free/release side effects, but F8 post-return `slot4` begins with the 31-byte stream consumed by nested F12 |
| CF98 | `0x170128` | formatAllocString(char**=slot4, fmt/string=slot5) via sub_16EA30 -> slot2 maybe return |
| CF99 | `0x170188` | format/default string helper; observed zero/empty input becomes `"0"` MEM_BLOCK |
| CF100 | `0x1701d8` | formatStringToMemBlock: slot4=dst MEM_BLOCK, slot5=fmt, slot6-slot8=args |

## 说明

- `managedFrameGetSlot_350(frame, N)` 读取 bytecode 调用栈 slotN；`managedFrameSetSlot_350(frame, 2, value)` 基本就是把 native helper 返回值写回 return slot。
- `CF07/10/11/12/37/38/49` 是 MEM_BLOCK/内存生命周期原语，是 X-Argus/X-Medusa 拼接前的材料搬运层。
- `CF79` 证明这条链会在 managed 层构造 JSON 数字字段；后续应继续找 `cJSON_AddStringToObject`/`cJSON_Print` 类 CF，定位 Argus 明文字段。
- `CF61` 已从“算法核心候选”落地为 SM3：外层只是 slot 适配，真实逻辑在
  `sm3OneShot_F15InitUpdateFinal_350 -> sm3Update_64byteBlocks_350 /
  sm3Final_padLenEmit32_350`，压缩函数是
  `sm3Compress_flattenedBlocks_350`。
- `CF97` 不能再只按 free/release 看：在 F8/X-Medusa 路径上，`CF97`
  post-return `slot4` 的开头正好是 F12 bit-pack 消费的 31-byte source
  stream，后续应追它的输入和中间写点。
- 当前差异锚点：unidbg-only `CF31/CF33/CF41/CF42/CF43` 偏 post-data/Argus 尾包变换；GumTrace-only `CF54/CF86` 分别是 MEM_BLOCK substring 和 URL-safe base64 decode-check。后续补 `.msdata`/`MS.b` 环境项时优先看这些分支条件。

## CF54 / CF86 差异分支锚点

`CF54` 是明确的 substring wrapper：

```text
0x16F79C cf54_substringMemBlock_src5_start6_len7_dst4_350
  slot5 -> source MEM_BLOCK
  slot6 -> start
  slot7 -> len
  slot4 -> output MEM_BLOCK
  calls copySubStringMemBlock(src, start, len, dst)
```

`CF86` 不是泛泛 predicate，它的下层已经能命名：

```text
0x16FF00 cf86_urlsafeBase64DecodeCheck_slot4_ret2_350
  slot4 -> MEM_BLOCK text
  -> 0x11B8EC normalizeUrlSafeBase64AndDecodeCheck_350
       '-' -> '+'
       '_' -> '/'
       -> 0x11B82C base64DecodeMemBlockToRef_350
            -> 0x109074 base64DecodeToBuffer_350
  slot2 <- decoded_ref.obj != NULL
```

所以真机命中 `CF54/CF86`、unidbg 没命中的差异，很可能不是 VM 指令缺失，而是
某个真实环境字段/字符串在 unidbg 中为空或格式不同，导致“截取 -> URL-safe
base64 解码校验”这条分支没有走到。

## CF61 / SM3 下层拆解

这段是从 IDA 350.101 静态反编译和 disasm 补出来的，作为后续版本升级时的
算法形状锚点：

| address | name | evidence-backed role |
|---:|---|---|
| `0x16F998` | `cf61_sm3Digest_slot4_input_slot5_len_slot6_out32_350` | managed CF wrapper，读取 slot4/slot5/slot6，调用 one-shot helper，slot2 写 0 |
| `0x16D520` | `sm3OneShot_F15InitUpdateFinal_350` | 本地 state 一次性封装：F15 写 SM3 IV -> update -> final |
| `0x171794` | `managedSignDigestStateInitF15_350` | 调用 managed sign program `F15` 初始化 SM3 state |
| `0x16D5A0` | `sm3Update_64byteBlocks_350` | `state+0/+4` 维护 byte counter，`state+0x28` 缓存尾块，满 64 字节调用 compress |
| `0x16D680` | `sm3Final_padLenEmit32_350` | 追加 `0x80` padding、8 字节 bit length，输出 32 字节大端 digest |
| `0x16D86C` | `sm3Compress_flattenedBlocks_350` | SM3 64 字节块压缩体，实际 CFG 被共享 `0x29F420` flatten 跳表和 `BR Xn` 打平 |
| `0x29F3DC` | padding data | `80 00 00...` final padding 起点 |
| `0x29F420` | shared flatten dispatch table | `0x16B874..0x16E474` 一带 flattened helper 微块的共享跳表；CF61/CF48 都会进入 |
| `0x154784` | `managedFrameGetSlotDouble_350` | CF79 专用 double slot 读取器；slot<=7 走 `buf+0x82e0+slot*8` |

对应的 state 草图已写入：

```c
typedef struct MetaSecDigest32State350 {
    uint32_t byte_count_lo;   // +0x00
    uint32_t byte_count_hi;   // +0x04
    uint32_t state_words[8];  // +0x08, final 输出为 32 字节大端 digest
    uint8_t block_tail[0x40]; // +0x28, update 尾块缓存
} MetaSecDigest32State350;    // observed size 0x68
```

## F8 / X-Medusa CF79 numeric fields

Latest focused run:

```text
unidbg/unidbg-android/target/sign6_350101_cf79_doublebits_20260831_0045.log
```

`CF79` writes eight JSON number keys during `F8/X-Medusa`.
The generic slot2 raw qword is not the numeric value; the real number is read
by `managedFrameGetSlotDouble_350` from the double-slot view.

| order | key | observed double | double bits | note |
|---:|---|---:|---:|---|
| 1 | `cmr` | `16777216` | `0x4170000000000000` | stable in current runs |
| 2 | `cmr2` | `16777216` | `0x4170000000000000` | stable in current runs |
| 3 | `un_h` | `4133029968` | `0x41eecb210a000000` | runtime/hash-like |
| 4 | `vpn` | `0` | `0x0` | environment flag |
| 5 | `kd` | `0` | `0x0` | environment flag |
| 6 | `fkd` | `1704349507` | `0x41d96593d0c00000` | runtime/randomized/hash-like |
| 7 | `pd` | `-1663556466` | `0xc1d8c9f6dc800000` | runtime/randomized/hash-like |
| 8 | `do` | `0` | `0x0` | likely related to `JSON_LIST::xm_do`, still not proven as direct field read |

现在可以命名为 SM3：F15 写入标准 SM3 IV，且
`sign6_350101_cf61_raw_20260831_063733.log` 中 5/5 个 raw input/output
与标准 SM3 一致。standalone oracle 见
`cf61_sm3_recovered_350101.c`，当前 `failures=0`。
