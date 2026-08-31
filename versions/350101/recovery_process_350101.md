# 350.101 MetaSec structure recovery process

这份文件记录这次从真机 trace / unidbg trace / IDA 静态分析推结构的过程。后续升级版本时，不要重新靠感觉猜，按这里复跑。

## 1. 先确定目标不是“同名 SO”，而是“同一逻辑路径”

早期容易踩坑：334 的注释 IDB、APK 里的 raw SO、350/354 的 raw SO hash 都可能不同。对齐时先看：

- raw `.so` 的 SHA-256 / build-id / size；
- 字符串锚点，例如 `fd8d1a41d3c56026d47f1f8ba146eb99`；
- HTTP/sign 相关字符串和 xref；
- 候选函数 ABI 和行为。

350.101 当前 SO 身份：

```text
path     douyin_35_0_0/libmetasec_ml.so
size     0x2bb410
sha256   2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76
build-id 025e51707b4c64f0b578e2dd7f12aa58ca94241a
```

报告位置：

```text
dyidre/versions/350101/metasec_so_identity.md
```

## 2. 先定入口和 ABI

334 注释库给了老版本语义：

```c
// 334:getHttpHeadVerify @ 0x15AB90
// X0=cookie_http, X1=json_list, X2=url, X3=x_ss_stub,
// W4=type, X5=tree_map, X8=sig_tree/out.
```

350 不能直接套地址。通过字符串/xref/trace 确认：

```c
// 350.101 buildSignedHttpHeadersInner_350 @ 0x149CA8
// X0=MetaSecCtx350*, X1=json_list window,
// X2=url window/MEM_BLOCK**, X3=x_ss_stub window,
// W4=type, X5=tree_map window, X8=temp sign_tree/scratch.
```

真机 entry dump 里还有一个关键形态：

```text
X5 = base
X3 = X5 + 0x10
X2 = X5 + 0x20
X1 = X5 + 0x30
```

所以 `X1/X2/X3/X5` 不是四个独立对象，而是同一指针窗口的不同切片。

## 3. `ctx+0x8` 识别成 registry

静态证据：

```asm
0x14a004  ldr x8, [x28,#0x8]
0x14a0c0  ldr x0, [x28,#0x8]
0x14a0d0  bl  registry_find_type_350
```

`registry_find_type_350` 的反编译核心：

```c
v8 = iterator.value();
if (**(int32_t **)v8 == type)
    return *(void **)(v8 + 8);
```

因此 registry 节点 payload 至少是：

```c
typedef struct MetaSecRegistryEntry350 {
    int32_t *type_ptr;
    void    *payload;
} MetaSecRegistryEntry350;
```

IDA 里更完整的类型是：

```c
typedef struct COOKIE_RISK_ITEMS {
    TREE_MAP risk_items;
    FUN_MUTEX *fun_mutex;
} COOKIE_RISK_ITEMS;
```

所以最终：

```c
ctx+0x8 -> COOKIE_RISK_ITEMS *registry
```

## 4. `ctx+0x1e0` 识别成 `COOKIE_RISK2`

最初 runtime 只知道：

```text
registry_find_type_350(ctx->registry, 2) 返回值 == ctx + 0x1e0
```

这说明它不是普通指针字段，而是主 context 内的嵌入对象。

再看 IDA 已有 Local Types，发现 `COOKIE_RISK2` 正好 size `0x88`，字段对上：

```c
typedef struct COOKIE_RISK2 {
    COOKIE_RISK_SUPER head;          // +0x00
    REF_JSON_LIST json_list;         // +0x30
    unsigned char gap40[0x20];       // +0x40
    REF_MEM_BLOCK msp_token;         // +0x60
    FUN_MUTEX *fun_mutext;           // +0x70
    RW_LOCK *rw_lock;                // +0x78
    __int64 has_token;               // +0x80
} COOKIE_RISK2;
```

换算到主 context：

```text
ctx+0x1e0 -> op2 / COOKIE_RISK2
ctx+0x240 -> op2.msp_token.mem
ctx+0x248 -> op2.msp_token.ref_count_ptr
ctx+0x250 -> op2.fun_mutext
ctx+0x258 -> op2.rw_lock
ctx+0x260 -> op2.has_token
```

## 5. ref-count pair 的判断依据

`ctx+0x240/+0x248` 曾经被临时命名为 `MetaSecSharedRef350`。

证据：

```text
0x47c78 写 [x19]
0x47c84 写 [x19,#8]
0x4ac04 清 [x19,#8]
0x47c1c 释放旧 ref，写新 obj，malloc(4)，*refcnt=1
```

这类 16 字节结构统一按：

```c
typedef struct REF_OBJ {
    void *obj;
    int *ref_count_ptr;
} REF_OBJ;
```

如果 payload 是 `MEM_BLOCK *`，则提升成：

```c
typedef struct REF_MEM_BLOCK {
    MEM_BLOCK *mem;
    int *ref_count_ptr;
} REF_MEM_BLOCK;
```

## 6. lock / busy 字段判断

`op2_fill_locked_350` 的关键逻辑：

```c
if (op2->json_list.json_list) {
    if (!LOBYTE(op2->has_token)) {
        LOBYTE(op2->has_token) = 1;
        rw_lock = op2->rw_lock;
        pthread_rwlock_rdlock(&rw_lock->pthread_rwlock);
        ...
        LOBYTE(op2->has_token) = 0;
    }
}
```

所以：

```text
op2+0x78 = RW_LOCK *
op2+0x80 = has_token / busy guard
```

## 7. scratch buffer 不要过早拆字段

`ctx+0x3c0..0x500` 在 trace 里反复被清零、写 TLV/env、再被覆盖成输出文本。

当前只命名为：

```c
uint8_t env_tlv_scratch_3c0[0xa0];
uint8_t transform_out_460[0xa0];
```

不要拆成一堆小字段，除非有稳定 PC/写入语义证明。

## 8. 当前 IDA 落库动作

已经在 350 IDB 应用：

```text
0x149CA8 buildSignedHttpHeadersInner_350(MetaSecCtx350 *ctx, ...)
0x1261B0 registry_find_type_350(COOKIE_RISK_ITEMS *registry, int type)
0x047C1C setObjectAddRef_5(MetaSecSharedRef350 *dst, void *obj)
0x04ABD4 shared_ref_release_350(MetaSecSharedRef350 *ref)
0x073FD8 op2_fill_locked_350(COOKIE_RISK2 *op2, REF_OBJ *out_ref)
```

并且 `MetaSecCtx350::op2` 已经从临时 `MetaSecOp2Object350` 提升为 `COOKIE_RISK2`。

## 9. 334 导入结构只当候选，350 要边看边修

这次已经确认两个“334 结构不能硬套”的点：

- `TREE_ITEM`：334 里的 `item_value` 在 350 HTTP header map 路径上更准确是 `TREE_KV *kv`。证据来自 `0x11FBDC/newTreeKV_350` 分配 `0x10`，并在 `+0/+8` 写 key/value；`0x11FC30/treeMapPut_350` 把这个对象挂到 tree item。
- managed runtime：350 有一套独立 managed module/frame/program 体系，不能用 334 的普通 C++ 对象名去解释。`0x1547D4` 不是业务函数，而是固定 slot setter。

原则：334 的注释和结构名只能当“候选词典”。只有满足下面至少一种证据，才提升字段/函数名：

- 真机 trace 和 unidbg trace 在同一入口上参数/内存形态一致；
- 静态反编译出现稳定 offset 或固定 slot；
- helper ABI 能解释读写关系；
- IDA Local Type 的 size/layout 与静态/动态证据相互吻合。

## 10. managed module/frame/program 体系

这套东西是 350 HTTP/sign 主线里最大的“套壳层”。它不是 `0x4CC10` 那个外层 MetaSec VM，而是另一个 managed bytecode runtime。

核心结构：

```c
typedef struct ManagedNativeBinding350 {
    void *name_or_sso_key;       // +0x00: "CF10" 或小字符串对象
    void *callback;              // +0x08: native helper / program blob
    unsigned char flags;         // +0x10
} ManagedNativeBinding350;       // size 0x18

typedef struct ManagedModule350 {
    ManagedProgram350 **programs; // +0x00
    uint64_t field_08;            // +0x08
    uint64_t field_10;            // +0x10
    uint64_t field_18;            // +0x18
    uint8_t program_index_map[1]; // +0x20 inline map
} ManagedModule350;
```

关键函数：

```text
0x154328  managedModuleBuild_350
          包装 0x158F48，X8 是 hidden out pointer，返回 ManagedModule350*

0x158F48  managedModuleDecodeBuild_350
          用 decode_key+2 对 encoded blob 做 XOR，解析 module，绑定 CF/native 表

0x154364  managedModuleFindProgram_350
          构造 SSO key，查 module+0x20 内联 map，最后返回 module->programs[index]

0x15485C  managedStringIndexMapFind_350
          module 内部字符串索引表查找
```

managed frame/slot：

```text
0x1545A8  managedFrameAcquire_350
          申请/复用 0x8380 TLS frame buffer，清空 +0x8100 slot 表

0x154648  managedFrameRelease_350
          frame buffer 放回 TLS freelist，满了就 free

0x1547C0  managedFrameGetSlot_350
          读 frame->buf + 0x8100 + slot*8

0x1547D4  managedFrameSetSlot_350
          写 frame->buf + 0x8100 + slot*8

0x1555A4  managedBytecodeRun_350
          大 managed bytecode 解释器，使用 value_stack 和 slot 表
```

slot 约定来自 `0x1547C0/0x1547D4` xref 统计：

```text
slot2        主要返回值槽
slot4+       wrapper/native helper 参数槽
slot19/20/27 少量 dispatcher-specific 状态槽
slot29       value_stack_top
slot31       exec_status
```

## 11. 从请求到签名成功的主线

当前 350.101 成功 trace / 静态链路可以按这条看：

```text
0x149CA8 buildSignedHttpHeadersInner_350
  -> 0x120000 newTreeMapObj
  -> COOKIE_CHECK_init / settings / phone/env 预处理
  -> 0x1261B0 registry_find_type_350(ctx->registry, type)
  -> 0x14D130 managedHttpF0Wrapper_350
       slot4 = X8, slot5 = X0, slot6 = W1
       invoke g_managedProg_http_F0_350
  -> 0x14D1D8 managedHttpF1Wrapper_350
       slot4 = X8, slot5 = W0
       invoke g_managedProg_http_F1_350
  -> 0x16D204 signStage1_makeStubPieces_350
  -> 0x16D454 signStage2_makeKeyPieces_350
  -> 0x17157C managedSignBuildF4Flag_350
  -> 0x1715F8 managedSignBuildA_350      // F5
  -> 0x171648 managedSignBuildB_350      // F7
  -> 0x171698 managedSignBuildFinal_350  // F8
  -> 0x11FC30 treeMapPut_350
  -> 0x14D424 success emit / final X-* headers
```

对应全局：

```text
0x2C4D40 g_managedModule_http_350
0x2C4D48 g_managedProg_http_F0_350
0x2C4D50 g_managedProg_http_F1_350

0x2C58C8 g_managedModule_sign_350
0x2C58D0..0x2C5A80 g_managedProg_sign_F0_350..g_managedProg_sign_F54_350
0x2C58F0 g_managedProg_sign_F4_350  -> managedSignBuildF4Flag_350
0x2C58F8 g_managedProg_sign_F5_350  -> managedSignBuildA_350
0x2C5908 g_managedProg_sign_F7_350  -> managedSignBuildB_350
0x2C5910 g_managedProg_sign_F8_350  -> managedSignBuildFinal_350
```

## 12. IDA 重命名/注释规则

这次开始统一规则：重命名函数/全局时，旁边必须带中文注释。

推荐注释格式：

```text
[managed-runtime] English evidence summary.
【中文】中文解释：说明这个函数/字段做什么、证据来自哪里、哪里还不能猜。
```

例子：

```text
0x1547D4 managedFrameSetSlot_350
【中文】托管 slot 写入：写 frame->buf + 0x8100 + slot*8；外层 wrapper 常把入参放 slot4/5/6。

0x14D1D8 managedHttpF1Wrapper_350
【中文】HTTP F1 wrapper：把 X8、W0 塞到 slot4/5，执行 g_managedProg_http_F1_350；常从错误/备用分支调用，但不是单纯 marker。
```

不要把“未证明业务”的 `F0..F54` 强行命名成业务含义；先保留 `g_managedProg_sign_Fxx_350`，中文注释写“暂不猜具体业务语义”。

## 13. CF61 / SM3 的识别流程

`CF61` 是 X-Argus/X-Medusa 里的 digest helper。最开始只按
`digest32` 形状命名；后来通过 F15 IV 和 raw vector，已经提升为标准 SM3。

先看 wrapper：

```text
0x16F998 cf61_sm3Digest_slot4_input_slot5_len_slot6_out32_350
  slot4 = input pointer
  slot5 = input length
  slot6 = output digest/state sink
  -> 0x16D520
  -> slot2 = 0
```

再拆 `0x16D520`：

```text
0x16D520 sm3OneShot_F15InitUpdateFinal_350
  -> 0x171794 managedSignDigestStateInitF15_350
  -> 0x16D5A0 sm3Update_64byteBlocks_350
  -> 0x16D680 sm3Final_padLenEmit32_350
```

证据点：

- `0x171794` 调 `g_managedProg_sign_F15_350`，F15 decode 后写入
  `7380166f 4914b2b9 172442d7 da8a0600 a96f30bc 163138aa e38dee4d b0fb0e4e`，
  这正是标准 SM3 IV。
- `0x16D5A0` 用 `state+0/+4` 做 byte counter，`state+0x28` 做尾块缓存；
  每满 `0x40` 字节调用 `0x16D86C`。
- `0x16D680` 根据当前余数补到 `56/120`，从 `0x29F3DC` 取
  `80 00 00...` padding，再追加 8 字节 bit length。
- `0x16D680` 最后把 `state_words[8]` 拆成 32 字节大端 digest 输出。
- `0x16D86C` 反编译只有 `BR X3`，但 disasm 显示它从 `0x29F420`
  跳表进入 `0x16B874..0x16E474` 的微块区域，是 flattened compression。
  后续检查 `CF48 -> 0x16CCD8` 也会进入同一张表，所以 `0x29F420`
  是共享 flatten dispatch 表，不是 digest 专属常量表。
- `sign6_350101_cf61_raw_20260831_063733.log` 中 5/5 个 CF61 raw pair
  与标准 SM3 一致；standalone oracle：
  `cf61_sm3_recovered_350101.c` 当前 `failures=0`。

因此当前结构草图是：

```c
typedef struct MetaSecDigest32State350 {
    uint32_t byte_count_lo;   // +0x00
    uint32_t byte_count_hi;   // +0x04
    uint32_t state_words[8];  // +0x08
    uint8_t block_tail[0x40]; // +0x28
} MetaSecDigest32State350;    // observed size 0x68
```

升级版复跑时，优先找这组形状：

```text
CF helper reads slot4/slot5/slot6
  -> one-shot function
  -> managed Fxx init
  -> update: counter + 64-byte blocks + tail cache
  -> final: 0x80 padding + bit length + 32-byte output
  -> flattened/jump-table compress
```

因此 IDA/文档里的稳定命名应升级为 `sm3*`；`digest32*` 只作为历史形状名。

同一轮还确认了共享 flatten 簇：

```text
0x29F420 flat_dispatch_jumptable_16b8_16e4_350
  xrefs from:
    0x16B748 flattenedTransform_CF01_350
    0x16BEB0 flattenedTransform_CF02_350
    0x16C65C flattenedMemBlockTransform_CF03_350
    0x16CCD8 shortHeaderTransform32_flattened_CF48_350
    0x16D86C sm3Compress_flattenedBlocks_350
    0x16E794 flattenedMemBlockTransform_tail_350
    0x16E8FC flattenedScratchSeed_350
```

这说明 `0x29F420` 是一组 helper 共用的 control-flow flatten 调度表。
后续如果要还原算法，应该先按入口 index 分拆微块 CFG，再分别归属到
CF01/CF02/CF03/CF48/CF61。

## 13.1 CF79 / Medusa JSON 数字字段识别

`0x16FD64 cf79_jsonAddNumber_slot4_key5_valSlot2_350` 的语义来自 IDA 和
unidbg 双证据：

```text
slot4 -> JSON object
slot5 -> char *key
slot2 -> numeric value, but read as double
call  -> cJSON_AddNumberToObject_double(slot4, slot5, double(slot2))
ret   -> managedFrameSetSlot_350(frame, 2, bool)
```

这里有个容易踩的坑：普通 `managedFrameGetSlot_350` 读 qword slot 时使用
`frame->buf + 0x8100 + slot*8`；但 `0x154784 managedFrameGetSlotDouble_350`
读 double slot 时，slot<=7 走：

```text
frame->buf + 0x82e0 + slot*8
```

slot>7 则走：

```text
*(frame->buf + 0x81e8) + slot*8 - 0x40
```

所以 trace 里如果只打印普通 qword slot，会看到 `0x43300000` 这种误导性 raw
值；要按 double-slot 视图读才是 JSON 数值。

本轮新增 focused run：

```text
unidbg/unidbg-android/target/sign6_350101_cf79_doublebits_20260831_0045.log
```

当前 F8/X-Medusa 的 `CF79*8` 数字字段：

| order | key | observed double | double bits | 判断 |
|---:|---|---:|---:|---|
| 1 | `cmr` | `16777216` | `0x4170000000000000` | 当前稳定 |
| 2 | `cmr2` | `16777216` | `0x4170000000000000` | 当前稳定 |
| 3 | `un_h` | `4133029968` | `0x41eecb210a000000` | hash/runtime-like |
| 4 | `vpn` | `0` | `0x0` | 环境 flag |
| 5 | `kd` | `0` | `0x0` | 环境 flag |
| 6 | `fkd` | `1704349507` | `0x41d96593d0c00000` | runtime/random-like |
| 7 | `pd` | `-1663556466` | `0xc1d8c9f6dc800000` | runtime/random-like |
| 8 | `do` | `0` | `0x0` | 可能关联 `JSON_LIST::xm_do`，但还没证明直接字段读取 |

## 13.2 CF48 / CF49 短 header pack 识别

这一步补的是 `X-Ladon` / `X-Helios` 的短包路径。之前只能说：

```text
CF100("%u-%s-%s") -> CF48(flattened transform) -> CF49 -> CF44(base64)
```

focused run 之后可以更具体：

```text
log: unidbg/unidbg-android/target/sign6_350101_cf48_cf49_20260831_005155.log
```

`CF100` 在 F7/F13 里生成明文：

```text
1788108717-1588093228-1128
```

其中第一段是本次 seed `0x6a945fad` 的十进制形式，所以升级/复跑时不要把
这个数字当常量。

`CF48` 的入参/返回形态：

```text
slot4 = 0x1a bytes formatted text, e.g. "1788108717-1588093228-1128"
slot5 = 4-byte prefix/scratch MEM_BLOCK before call
slot6 = 0x20 bytes ASCII hex-like material
post slot5 = 0x20 bytes binary transform result
```

`CF49` 随后拼接：

```text
slot4 before = 4-byte prefix
slot5        = 32-byte CF48 result
slot2/slot4 after = 0x24-byte pack
```

验证关系：

```text
F7 pack36:
  7c c8 a0 10 7a bd 4b db 12 ba 2b 22 82 a8 ef fd
  65 ea 43 27 0d 9c f5 e5 de be c2 51 0c 62 ca 70
  17 a4 31 fe
base64:
  fMigEHq9S9sSuisigqjv/WXqQycNnPXl3r7CUQxiynAXpDH+

F13 pack36:
  30 e4 7f 2c 74 f5 5f 3e 23 d3 c8 57 0d 15 df e5
  d4 a2 fd c0 65 c7 e3 ce c2 68 67 54 5a 79 24 ef
  16 a3 6a f9
base64:
  MOR/LHT1Xz4j08hXDRXf5dSi/cBlx+POwmhnVFp5JO8Wo2r5
```

所以命名原则更新：

- `CF48` 可以叫 “short flattened transform / 短包 32 字节变换”，但仍然不要
  猜具体算法名。
- `CF49` 可以确定为“把 4-byte prefix 和 32-byte transform result 拼成
  0x24 pack”。
- 新版本对齐时，`0x24 -> base64 0x30` 是非常稳定的短 header 形状锚点。

## 13.3 CF54 / CF86 真机差异分支识别

之前 full trace 对比里有一个现象：

```text
GumTrace-only: CF54 CF86
```

现在静态已经把这两个差异点拆清：

```text
0x16F79C cf54_substringMemBlock_src5_start6_len7_dst4_350
  slot5 = source MEM_BLOCK
  slot6 = start
  slot7 = len
  slot4 = output MEM_BLOCK
  -> copySubStringMemBlock(src, start, len, dst)

0x16FF00 cf86_urlsafeBase64DecodeCheck_slot4_ret2_350
  slot4 = MEM_BLOCK text
  -> normalizeUrlSafeBase64AndDecodeCheck_350
       '-' -> '+'
       '_' -> '/'
       -> base64DecodeMemBlockToRef_350
            -> base64DecodeToBuffer_350
  slot2 = decoded_ref.obj != NULL
```

`0x109074 base64DecodeToBuffer_350` 是标准 base64 decode 形态：查 256 字节
decode table，处理空格/CRLF 和 `=` padding，非法输入返回 `-44`，输出空间
不足/长度查询返回 `-42`。

所以这组差异的分析方向很明确：真机可能存在某个 URL-safe base64/token-like
字段，managed 代码先 `CF54` 截取其中一段，再用 `CF86` 做归一化和解码校验。
unidbg 当前没命中，优先怀疑环境项为空、`.msdata`/`MS.b` 缺失或 token 格式不
一致，而不是 CF 表或 interpreter 本身错了。

## 14. 后续升级版本复跑顺序

1. 用 `metasec_so_probe.py` 生成新 SO identity。
2. 用字符串/xref 找 HTTP/sign 候选入口。
3. 真机在候选入口 dump X0-X5/X8 和指向内存。
4. unidbg 在相同入口 dump 相同寄存器和内存。
5. 跑 `metasec_struct_infer.py` 聚合 offset 读写。
6. 跑 `metasec_struct_promote.py` 分类 stable/ref_pair/embedded/scratch。
7. 和 `metasec_structs_350_all.h` 对齐；能证明的才迁移。
8. 通过 `ida_apply_metasec_struct_evidence.py` 或 IDA MCP 落类型、原型、注释。
9. 对 `managedModuleBuild_*/managedModuleFindProgram_*` 和 `F-key` 全局重新定位；这个比单纯搜旧地址更稳。
10. 对 `CF61/SM3` 这类算法 helper，先按 shape 对齐 wrapper/init/update/final/compress，再用 IV + raw vector 提升具体算法名。
11. 对 `CF79` 一类 numeric helper，先确认 qword slot / double slot 的真实偏移；不要把普通 slot raw 当作业务值。
12. 对短 header 路径，复核 `CF100 -> CF48 -> CF49 -> CF44 -> CF98`：
    `0x1a` text + `0x20` material -> `0x20` transform -> `0x24` binary pack
    -> `0x30` base64 string。
13. 对真机-only 分支，优先查 `CF54 substring` 和 `CF86 URL-safe base64 decode-check`
    的输入字段，确认是不是环境/token 缺失。
14. 每个新重命名旁边补中文注释，后续再看 IDA 不返工。

## 15. Managed CF 语义 lift 落地

本轮把 managed VM 的高价值 native callback 单独落成：

```text
dyidre/versions/350101/managed_cf_recovered_350.c
```

这个文件的定位：

- 不是直接可编译源码；
- 也不是简单“去花指令”；
- 而是把 `managedBytecodeRun_350` 里通过 slot 调用的 `CFxx` 原语，按
  runtime trace + IDA 反编译还原成可读伪 C。

已经 lift 出来的稳定块：

```text
0x1547C0 managedFrameGetSlot_350
0x1547D4 managedFrameSetSlot_350
0x154784 managedFrameGetSlotDouble_350

0x16EC90 CF07 memCopy2(dst=slot4, src=slot5, len=slot6)
0x16ED54 CF10 copyMemBlockData(dst=slot4, src=slot5)
0x16F374 CF38 initMemBlockBySrc(dst=slot4, src=slot5, len=slot6)
0x16F544 CF44 base64Encode(input=slot5, out_ref=slot4)
0x170128 CF98 formatAllocString(char**=slot4, fmt=slot5)
0x1701D8 CF100 formatStringToMemBlock(dst=slot4, fmt=slot5, args=slot6..8)
0x16FD64 CF79 cJSON_AddNumberToObject_double(slot4, slot5, double-slot2)

0x16F998 CF61 SM3 adapter
0x16D520 SM3 one-shot
0x171794 managed F15 state init
0x16D5A0 SM3 update / 64-byte blocks
0x16D680 SM3 final / padding / big-endian output
0x16D86C SM3 compress flattened body

0x16F660 CF48 short-header transform wrapper
0x16CCD8 CF48 flattened lower helper
0x16F6B0 CF49 prefix4 + transform32 -> pack36
```

同时已经把这些函数入口和关键行写回 IDA 中文注释，并保存
`douyin_35_0_0/libmetasec_ml.so.i64`。

当前最重要的结论：

```text
F7/F13 短头：
  CF100("%u-%s-%s")
    -> text "seed-appid-sdkver"
    -> CF48(text, out32, key32)
    -> CF49(prefix4 || out32) = 0x24 binary pack
    -> CF44 base64 = 0x30 header value
    -> CF98 写回 key/value

F5/F8 长头：
  CF61 SM3 多次消化 query/stub/0x44 pack
    -> CF38/CF10/CF07 拼接二进制材料
    -> F8 额外 CF79 写 JSON 数字字段
    -> CF44 base64
    -> CF98 写回 key/value
```

还没完成的地方不要过度命名：

- `0x16D86C sm3Compress_flattenedBlocks_350` 的 round function 虽然还被
  `0x29F420` 共享跳表打散，但语义已由 SM3 raw vector 证明；
- `0x16CCD8 shortHeaderTransform32_flattened_CF48_350` 也进入同一张跳表；
- 因此现在 CF61 叫 `SM3`，CF48 继续叫 `shortHeaderTransform32`，不猜 AES/自定义名。
