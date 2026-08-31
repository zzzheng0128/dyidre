# 350.101 libmetasec_ml.so managed VM 启动与运行链路

状态：本轮先挂起 `CFxx` 业务语义重命名，只梳理 VM 如何启动、如何绑定 `G/CF/F`、如何从请求路径进入解释器。

## 结论

350.101 里这套不是单个 VM，而是多套 managed module 共用同一组 runtime：

- module builder：`0x154328 managedModuleBuild_350`
- module decoder/binder：`0x158F48 managedModuleDecodeBuild_350`
- program lookup：`0x154364 managedModuleFindProgram_350`
- program invoke：`0x154454 managedProgramInvoke_350` -> `0x154468 managedProgramInvokeCore_350`
- bytecode interpreter：`0x1555A4 managedBytecodeRun_350`
- frame/slot：`0x1545A8/0x154648/0x1547C0/0x1547D4`

启动发生在 `.init_array`，不是等 HTTP 请求进来才启动。请求侧只是在已经初始化好的 module 上取全局 `Fxx` 句柄并执行。

## `.init_array` 入口

ELF `.init_array`：

```text
.init_array va=0x260190 off=0x25f190 size=0x3a0
[00] 0x59294
[01] 0x14cebc managed-vm-module-init
[02] 0x152b58 managed-vm-module-init
[03] 0x1702b8 managed-vm-module-init
[04] 0x171ddc managed-vm-module-init
```

四个 managed module 的构建点：

| init func | build call | encoded blob | size | decode key | CF table | G table | build 后保存 |
|---|---:|---:|---:|---:|---:|---:|---|
| `0x14CEBC` | `0x14D0D4` | `0x27EFF0` | `0x58F` | `0x270D30` | `CF0..CF15`, count `16` | `G0`, count `1` | module `0x2C4D40`; `F0/F1` -> `0x2C4D48/0x2C4D50` |
| `0x152B58` | `0x1534E4` | `0x27F9B0` | `0x1FA2C` | `0x270EB0` | `CF0..CF19`, count `20` | `G0..G64`, count `65` | module `0x2C5258`; lookup `F0..F85` |
| `0x1702B8` | `0x170F54` | `0x29FF20` | `0x1A322` | `0x271920` | `CF0..CF101`, count `102` | `G0..G10`, count `11` | module `0x2C58C8`; lookup `F0..F54` |
| `0x171DDC` | `0x172048` | `0x2BA250` | `0x1857` | `0x271940` | `CF0..CF16`, count `17` | `G0..G2`, count `3` | module `0x2C5AC8`; lookup `F0..F7` |

注意：`managedModuleBuild` 的第 7/8 个参数更准确应该叫 `g_table/g_count`，不是 `program_table/program_count`。`Gxx/CFxx` 是 build 输入，`Fxx` 是 decoded module 里的导出程序，后续通过 `managedModuleFindProgram(module, "Fxx")` 取出来。

## builder 参数形态

从四个 caller 的寄存器准备方式看，builder 大致是：

```c
ManagedModule350 *managedModuleBuild_350(
    uint8_t *encoded_blob,      // X0
    uint32_t encoded_size,      // W1
    void *scratch,              // X2
    uint32_t flags,             // W3, 当前都是 0
    ManagedBinding350 *cf_tbl,  // X4
    uint32_t cf_count,          // W5
    ManagedBinding350 *g_tbl,   // X6
    uint32_t g_count,           // W7
    uint8_t *decode_key         // stack[0]
);
```

栈上现场构造的 binding 条目形态是：

```c
typedef struct ManagedBinding350 {
    const char *name;   // "CF48" / "G0" ...
    void *target;       // native callback 或全局/host 目标
    uint8_t flags;      // 当前多数为 0
    uint8_t pad[7];
} ManagedBinding350;    // sizeof = 0x18
```

## decode/build 过程

`0x154328 managedModuleBuild_350` 只是薄 wrapper：

```text
0x154328: 从 caller stack 取 decode_key
0x154348: X8 = &local_out_module
0x154350: BL 0x158F48 managedModuleDecodeBuild_350
0x154354: return local_out_module
```

`0x158F48 managedModuleDecodeBuild_350` 做核心工作：

1. 检查 `encoded_blob != NULL`。
2. 从 `decode_key[2]` 取一个 byte。
3. 如果这个 byte 非 0，就对整段 `encoded_blob[0..size)` 做 XOR 原地解码。
   - `0x158FE4..0x159014` 是 32-byte vector XOR。
   - `0x159018..0x159030` 是尾部 byte XOR。
4. 初始化/解析模块容器。
5. 调 `0x1642E8` 解析 decoded blob。
6. 调 `0x158460` 把 `CF/G` binding 表绑定进 module。
7. 通过 `X8` hidden out pointer 写回 `ManagedModule350 *`。

所以升级版本时，不要只找解释器入口；还要先找这四个 `managedModuleBuild` caller，因为 encoded blob、decode key、CF/G 表都在这里定根。

## F 程序 lookup

`0x154364 managedModuleFindProgram_350(module, name)`：

1. 把 `"Fxx"` 转成内部 small-string key。
2. 在 `module + 0x20` 的 map/dict 中查 key。
3. 取 index 后从 `module->programs[index]` 返回 `ManagedProgram350 *`。

签名大模块的全局区从 `0x2C58C8` 开始：

```text
0x2C58C8 = sign module
0x2C58D0 = sign F0
0x2C58D8 = sign F1
...
0x2C58F0 = sign F4
0x2C58F8 = sign F5
0x2C5908 = sign F7
0x2C5910 = sign F8
0x2C5938 = sign F13
...
0x2C5A80 = sign F54
```

HTTP 请求主线里目前能直接看到：

```text
0x14A38C -> 0x1715F8 -> invoke sign F5
0x14A3EC -> 0x171648 -> invoke sign F7
0x14A4E0 -> 0x171698 -> invoke sign F8
0x14A588 -> 0x1716F4 -> invoke sign F13
```

还有两个 native stage：

```text
0x14A1AC -> 0x16D204
0x14A1FC -> 0x16D454
```

这两个不是通过 `managedProgramInvoke_350` 进入，但在 HTTP header 生成主线里位于 managed F5/F7/F8 之前。

## frame/slot 运行模型

`0x1545A8 managedFrameAcquire_350`：

```text
frame.status = 0
frame.interp_saved = 0
frame.buf = malloc/reuse(0x8380)
memset(buf + 0x8100, 0, 0x280)
*(buf + 0x81E8) = buf + 0x8000
```

初步结构：

```c
typedef struct ManagedFrame350 {
    uint32_t status;       // +0x00
    uint32_t pad04;        // +0x04
    void *interp_saved;    // +0x08
    void *buf;             // +0x10
} ManagedFrame350;         // stack object, size 0x18 左右

typedef struct ManagedFrameBuf350 {
    uint8_t value_stack[0x8000];  // +0x0000
    uint8_t unk8000[0x100];       // +0x8000
    uint64_t slots[0x50];         // +0x8100, 0x280 bytes
    uint8_t unk8380_tail[0x100];  // contains double slots/extra area
} ManagedFrameBuf350;             // allocated 0x8380
```

slot 访问函数：

```c
uint64_t managedFrameGetSlot_350(frame, slot) {
    return *(uint64_t *)(frame->buf + 0x8100 + slot * 8);
}

void managedFrameSetSlot_350(frame, slot, value) {
    *(uint64_t *)(frame->buf + 0x8100 + slot * 8) = value;
}
```

特殊点：

- `slot29` 对应 `buf + 0x81E8`，保存 VM value stack top。
- `managedFrameGetSlotDouble_350` 对 `slot <= 7` 走 `buf + 0x82E0 + slot * 8`，大 slot 则从 value stack top 回退取 double。

## invoke core

`0x154454 managedProgramInvoke_350` 只是：

```text
BL 0x154468 managedProgramInvokeCore_350
```

`0x154468 managedProgramInvokeCore_350` 前面有一个 flattened/junk branch，真实分支在 `0x154530` 附近：

```c
kind = *(uint64_t *)program;

if (kind == 3) {
    // native program：直接回调，参数是 frame
    fn = *(void (**)(ManagedFrame350 *))(program + 8);
    fn(frame);
    frame->status = *(uint32_t *)(frame->buf + 0x81F8);
    return;
}

if (kind == 2) {
    body = *(void **)(program + 0x28);
    if (body != NULL)
        return managedBytecodeRun_350(body, frame);

    // body 为空时退到 native callback
    fn = *(void (**)(ManagedFrame350 *))(program + 8);
    fn(frame);
    frame->status = *(uint32_t *)(frame->buf + 0x81F8);
    return;
}

if (kind == 1)
    body = program + 8;
else
    body = *(void **)program;

managedBytecodeRun_350(body, frame);
```

这解释了为什么 `Fxx` 不一定都是 bytecode：program 可以是 native callback，也可以是 bytecode body，也可以是混合壳。

## bytecode interpreter

`0x1555A4 managedBytecodeRun_350` 开头：

```text
0x1555C4: LDP W9, W8, [X0]        ; body header 两个 u32
0x1555D8: LDR X9, [frame, #0x10]  ; frame->buf
0x1555E0: LDR X10, [buf + 0x81E8] ; value stack top
0x1555E4: SUB X8, X10, W8         ; 预留 stack_need
0x1555E8: CMP X8, buf             ; 防止 value stack underflow
0x155604: LDP X9, X11, [body,#8]  ; instruction begin/end
```

指令形态从入口 dispatcher 可见：

```c
typedef struct ManagedInsn350 {
    uint64_t opcode;      // 0x81..0xBA 附近
    uint8_t op0;          // slot id / imm selector
    uint8_t op1;
    uint8_t op2;
    uint8_t pad0B[0x0D];
} ManagedInsn350;         // sizeof = 0x18
```

dispatcher 证据：

```text
0x155700: insn = *(begin + pc * 0x18)
0x155708: tmp = opcode - 0x81
0x15570C: if tmp > 0x39 goto slow/error path
0x155714: jump_table[tmp]
```

所以这个 VM 的运行不是“函数里写死一堆 if”，而是：

```text
外部 wrapper 塞 slot
    -> managedProgramInvoke(Fxx, frame)
        -> program kind 分派
            -> managedBytecodeRun(body, frame)
                -> 0x18-byte 指令循环
                    -> opcode jump table
                    -> 读写 frame slot / value_stack
                    -> 必要时 call CFxx native helper
```

## HTTP header 生成中 VM 怎么被用上

`0x149CA8 buildSignedHttpHeadersInner_350` 的主线：

1. 检查入参窗口：`json_list/url/x_ss_stub/tree_map`。
2. 构造临时 map/string/MEM_BLOCK。
3. 读取 `x-metasec-mode`，以及 registry type。
4. 先走两个 native stage：
   - `0x14A1AC -> 0x16D204`
   - `0x14A1FC -> 0x16D454`
5. 构造一个参数 pack 放在栈上，交给 managed VM：
   - `0x14A38C -> sign F5`
   - `0x14A3EC -> sign F7`
   - `0x14A4E0 -> sign F8`
   - `0x14A588 -> sign F13`
6. managed VM 把结果通过 frame slot / 临时 output 指针写回。
7. `0x14A53C`、`0x14A65C` 把生成结果插入最终 header map。
8. `0x14A730` 成功返回输出。

这条线里，C/C++ 层更多是在搬运对象、建临时容器、做入参/错误处理；真正大量签名材料组合在 managed F 程序和 CF helper 里。

## 和 `exeVMInner` / `0x4CC10` 的关系

`0x1555A4 managedBytecodeRun_350` 和 `0x4CC10 exeVMInner` 是两套不同的 VM，不要混在一起看。

### 是否走到 `exeVMInner`

走到了。

证据：

```text
dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350.log
  !0x4cc10  raw hits: 4
  !0x1555a4 raw hits: 177

unidbg/unidbg-android/target/mcp_trace_350101_full/unidbg_mcp_libmetasec_full.unique.seq
  line 6939: 0x4cc10 0x1204cc10 stp x28, x27, [sp, #-0x60]!

unidbg/unidbg-android/target/mcp_trace_350101_full/gumtrace_getHttpHeadVerify_350.full.unique.seq
  line 12944: 0x4cc10 0x7102c50c10 stp x28, x27, [sp, #-0x60]!
```

当前 `sign6_350101_cfpost_*.log` 不是全指令 trace，所以里面没有 `0x4cc10` 字符串不能说明没走到。要确认是否命中 `exeVMInner`，看 full sequence trace 或直接对 `0x4CC10` 加 hook/trace。

### `exeVMInner` 是什么

`exeVMInner` 是外层 native VMP 的解释器入口，对应真实 so 里的 `0x4CC10`。

项目里的还原代码在：

```text
z/ws/mm64.cpp:1205 inline void exeVMInner(...)
```

它的运行模型大概是：

```c
exeVMInner(
    PhoneInfo *phone,
    uint32_t *vmCode_ptr,   // 虚拟指令流
    uint64_t pParamList,    // 参数窗口 / 输入输出区
    uint32_t *vmData1,      // VM 常量/数据区 1
    uint32_t *vmData2,      // VM 常量/数据区 2
    VmParam64 *vmParam      // VM 栈、bridge、返回哨兵
);
```

真实 350 so 的 wrapper 会把这些参数拼好再 `BL 0x4CC10`。例如当前 trace 命中的 caller：

```text
0xD9574 wrapper
  0xD95A8: X0 = 0x1EC670     // vmCode / encoded native VM code
  0xD95B4: X1 = SP + 0x8     // 参数/返回窗口
  0xD95AC: X2 = 0x262980     // vmData1
  0xD95B0: X3 = 0x2629C0     // vmData2
  0xD95B8: X4 = SP + 0x10    // VmParam-like 参数块
  0xD95C0: [SP+0x10] = 0xD9980, [SP+0x18] = SP+0x4A0
  0xD95C8: BL 0x4CC10
```

这和 `mm64.cpp` 里大量 wrapper 很像：

```c
vmParam.funBridge = callFunForVM;
vmParam.stack_end = &vmParam.stack_start[0] + (... / 8);
vmParam.save_LR = 0x997300EC;
exeVMInner(phone, VMCodePtr(...), pParamList, VMCodePtr(...), VMCodePtr(...), &vmParam);
```

### 两套 VM 的分工

```text
0x1555A4 managedBytecodeRun_350
  管 Fxx managed program。
  指令固定 0x18 字节，opcode 0x81 起，slot/value-stack 模型。
  主要负责 X-Argus/X-Ladon/X-Medusa 等 header 组合逻辑。

0x4CC10 exeVMInner
  管 native VMP 代码块。
  每个 wrapper 传 vmCode/vmData/pParamList/VmParam。
  常用于把某些 native helper、算法片段、环境/字符串处理再套一层保护。
```

所以请求路径里看到两者同时出现是正常的：

```text
HTTP entry 0x149CA8
  -> managed F5/F7/F8/F13
      -> managedBytecodeRun_350 @ 0x1555A4
          -> 某些 CF/native helper
              -> native VMP wrapper
                  -> exeVMInner @ 0x4CC10
```

不是每次 `managedBytecodeRun` 都会进 `exeVMInner`；只有执行到某些被 native VMP 保护的 helper/子函数时才会进。

更细的 `exeVMInner` / `0x4CC10` wrapper、参数窗口、输出对象流见：

```text
dyidre/versions/350101/exeVMInner_x_headers_350101.md
```

## 后续升级版本识别 checklist

1. 扫 `.init_array`，找连续的 managed module init。
2. 扫所有 `BL managedModuleBuild`，恢复每个 caller 的：
   - `encoded_blob`
   - `encoded_size`
   - `decode_key`
   - `CF count`
   - `G count`
   - 保存 module/F 句柄的全局地址。
3. 找 `managedModuleFindProgram(module, "Fxx")` 序列，恢复 F 导出数量和 global layout。
4. 找 `managedFrameAcquire` 特征：
   - 分配 `0x8380`
   - 清 `buf + 0x8100, size 0x280`
   - 写 `buf + 0x81E8 = buf + 0x8000`
5. 找 `managedBytecodeRun` 特征：
   - `LDP W?, W?, [body]`
   - `LDP X?, X?, [body,#8]`
   - `pc * 0x18`
   - `opcode - 0x81`
   - jump table。
6. 请求路径中只需要定位 wrapper：
   - `acquire frame`
   - `set slot`
   - `load g_module_Fxx`
   - `invoke`
   - `release frame`

按这个流程，升级新版本时先迁移 VM runtime anchors，再迁移业务层 `Fxx/CFxx` 语义。
