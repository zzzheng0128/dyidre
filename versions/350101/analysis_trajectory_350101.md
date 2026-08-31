# 350101 `libmetasec_ml.so` 分析轨迹

这份文件记录 350101 这一版实际已经走通的分析轨迹。全局方法论看：

```text
dyidre/docs/metasec-analysis-trajectory.md
```

这里更关注“350101 这版每一步用什么证据证明过”。后面升级版本时，可以复制本文件作为新版本的 `analysis_trajectory_<version>.md`，逐项替换 offset、日志和结论。

## 0. 当前基准

| 项 | 值 |
|---|---|
| App/version code | `350101` |
| APK | `dyidre/materials/350101/source.apk`，来源 `douyin_35_0_0/dy351_vivo.apk` |
| SO | `dyidre/materials/350101/libmetasec_ml.so`，来源 `douyin_35_0_0/libmetasec_ml.so` |
| IDA i64 | `dyidre/materials/350101/libmetasec_ml.so.i64` |
| 版本入口 | `dyidre/versions/350101/` |
| 真机基准环境 | `dyidre/runs/350101/true_env_xmedusa/latest` |
| unidbg 固定输入 | `unidbg/unidbg-android/src/test/resources/metasec/350101/` |
| unidbg 回归脚本 | `unidbg/scripts/metasec-350101-req01-baseline.sh` |
| 统一真机 probe | `dyidre/probes/350101/run_metasec_probe_350101.sh` |

固定基准的意义：以后所有算法/结构/VM 修改，都先在同一个 `req01 s1/s2 + fixed env` 上验，避免时间、随机、rootfs、权限弹窗等造成假差异。

## 1. SO 身份

产物：

```text
metasec_so_identity.md
```

作用：

- 记录当前 so 的 hash/build-id/size/字符串锚点；
- 避免把 334、350、354、374 的不同 so 混在一起；
- 后续升级版本先生成同名文件，再和 350101 对照。

通过状态：

```text
350101 已确认作为当前工作基准。
```

## 2. HTTP/sign 入口

已确认锚点：

| 名称 | offset | 作用 |
|---|---:|---|
| `buildSignedHttpHeadersCallback_350` | `0x14DBF4` | Java/native callback 外层入口 |
| `buildSignedHttpHeadersInner_350` | `0x149CA8` | 实际 HTTP X-header 生成主函数 |
| `signStage1_makeStubPieces_350` | `0x16D204` | native stage1，生成 stub/key 前置片段 |
| `signStage2_makeKeyPieces_350` | `0x16D454` | native stage2，生成后续 key/material |
| `exeVMInner_350` | `0x4CC10` | native VMP 解释器 |
| `managedBytecodeRun_350` | `0x1555A4` | managed bytecode VM 解释器 |

核心 ABI：

```c
__int64 __fastcall buildSignedHttpHeadersInner_350(
    MetaSecCtx350 *ctx,
    REF_JSON_LIST *json_list,
    REF_MEM_BLOCK *url,
    REF_MEM_BLOCK *x_ss_stub,
    int type,
    REF_TREE_MAP *tree_map);
```

入口形态：

```text
X0 = MetaSecCtx350 *
X1 = json_list window
X2 = url window / MEM_BLOCK **
X3 = x_ss_stub window
W4 = type
X5 = tree_map window
X8 = temp sign_tree / scratch
```

证据：

```text
real_vs_unidbg_entry_shape.md
x_headers_generation_350101.md
managed_vm_boot_350101.md
exeVMInner_x_headers_350101.md
```

## 3. 真机单请求采集

350101 probe 主入口：

```bash
cd /Users/freeman/project/douyin
dyidre/probes/350101/run_metasec_probe_350101.sh counter-one 60 req01_count
dyidre/probes/350101/run_metasec_probe_350101.sh true-env 90 req01_env
dyidre/probes/350101/run_metasec_probe_350101.sh xheader 90 req01_xhdr
```

必要时补 JNI：

```bash
dyidre/probes/350101/run_metasec_probe_350101.sh jnitrace 180 req01_jni
```

当前可复用证据目录：

```text
dyidre/runs/350101/entrydump/
dyidre/runs/350101/true_env_xmedusa/latest
dyidre/runs/350101/jnitrace/
dyidre/runs/350101/gumtrace/
dyidre/runs/350101/maps_artmethod/
dyidre/runs/350101/edbg_stackplz/
```

已验证脚本能力：

```text
counter-one
counter-multi
true-env
jnitrace
xheader
branch（默认安全模式）
native-vmp
gum-exevm
gum-http
artcheck
stackplz-bridge
stackplz-offset
```

## 4. unidbg 固定复现

代码入口：

```text
unidbg/unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6MetaSecBase.java
unidbg/unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6_350101.java
```

固定输入：

```text
unidbg/unidbg-android/src/test/resources/metasec/350101/req01_app_log_s1.txt
unidbg/unidbg-android/src/test/resources/metasec/350101/req01_app_log_s2.txt
unidbg/unidbg-android/src/test/resources/metasec/350101/baseline.properties
```

回归入口：

```bash
cd /Users/freeman/project/douyin/unidbg
scripts/metasec-350101-req01-baseline.sh
```

约束：

- offset 统一放在 `MetaSecProfile.v350101()`；
- 时间、随机、pid/tid、rootfs 走 baseline/profile；
- Java/env 缺项用真机 `jnitrace/true-env` 补；
- 不要在 sign 类里散落 magic offset。

当前状态：

```text
固定 s1/s2/env 后，unidbg deterministic baseline 可作为 C oracle 验收目标。
```

## 5. 路径对齐结论

真机和 unidbg 在 managed VM 语义路径上已经对齐：

```text
managed_native_blr_15454c = 311
prefix_match = 311
first_diff = none
X-Khronos = 1788159560
```

raw PC 层出现过 helper 差异，例如：

```text
0x1C2EDC operator new / malloc wrapper
0x11FC08 object/vtable construction
0x12DD04 shared-ref acquire + mutex
0x12DE7C shared-ref release/unlock
0x490A0  shared/ref assignment
0x10B5F0 small string/object ctor
0x10B764 object destructor/free
```

但它们会重新同步：

```text
no_resync = 0
```

所以后续不要再把主要精力放在 raw helper 差异，应该转向值级还原。

证据：

```text
instr_diff_350101/managed_blr_cf_target_diff_350101_req01_v2.md
instr_diff_350101/true_vs_unidbg_fixedtime_149cbc_firstdiff.md
```

## 6. X-header 生成链路

350101 目前的 header 责任划分：

| header | 主要来源 | 输出锚点 |
|---|---|---:|
| `X-Gorgon` | native stage1/stage2 前置材料 | `0x14A1C0` origin |
| `X-Khronos` | fixed time / stage 输出 | `0x14A210` origin |
| `X-Argus` | managed `F5` + CF41/SIMON + CF43/AES + CF44/base64 | `0x14A3A0` origin |
| `X-Ladon` | managed `F7` + short transform | `0x14A400` origin |
| `X-Medusa` | managed `F8` + F12/source-work/final pack | `0x14A53C` |
| `X-Helios` | managed `F13` side path | `0x14A5A8` origin |
| `X-Soter` | managed/native post emit | `0x14A65C` |

核心文档：

```text
x_headers_generation_350101.md
x_headers_algorithms_350101.md
fixed_s1_s2_signer_350101.md
environment_inputs_350101.md
algorithm_validation_350101.md
```

当前验收口径：

```text
fixed s1/s2 signer failures=0
C oracle suite failures=0
deterministic unidbg baseline 对齐
```

## 7. managed VM 恢复轨迹

模块初始化：

```text
0x1702B8 initManagedSignModuleLarge_350
  -> 0x170F54 build module
  -> 导出 F0..F54 program handle
```

运行：

```text
0x15454C managedProgramInvoke_350
0x154468 managedProgramInvokeCore_350
0x1555A4 managedBytecodeRun_350
0x1547D4 managedFrameSetSlot_350
```

关键 program：

| program | 当前命名 |
|---|---|
| F5 | `managedProg_sign_F5_350`，X-Argus |
| F7 | `managedProg_sign_F7_350`，X-Ladon |
| F8 | `managedProg_sign_F8_350`，X-Medusa |
| F13 | `managedProg_sign_F13_350`，Helios/Soter post |

decode 产物：

```text
managed_vm_recovery_350101.md
managed_vm_program_lift_350101.md
managed_vm_decode/
managed_vm_decode_sourcework_350101/
managed_vm_decode_roundfamilies_350101/
```

已确认：

```text
F5/F7/F8/F13/F15 主要样本 opcode unknown=0
source-work 四族 adapter/block-loop/scheduler family 已收齐向量
```

## 8. native VMP / `exeVMInner` 恢复轨迹

入口：

```text
0x4CC10 exeVMInner_350
```

350101 HTTP 路径命中过：

| vmCode | 类型 |
|---:|---|
| `0x1EC670` | short helper |
| `0x1ECAF0` | short helper |
| `0x1F7860` | heavy native VMP material builder |

heavy path：

```text
0x16F2DC
  -> 0x12564C
  -> 0x124DD4
  -> 0x4CC10 exeVMInner_350(vmCode=0x1F7860)
```

产物：

```text
exeVMInner_x_headers_350101.md
vm_lift_1f7860/native_vmp_1f7860_recovered.c
```

后续升级重点：

- 先验证 `exeVMInner` offset；
- 再看 `vmCode` 分布是否仍是短 helper + heavy material builder；
- 只要 vmCode/LR 主线一致，raw helper 差异先降级处理。

## 9. 结构体恢复轨迹

结构体总入口：

```text
metasec_structs_350_all.h
metasec_ctx350_draft.h
x0_evidence.md
x0_promote_plan.md
x0_tail_timeline.md
```

当前最稳字段：

```text
ctx+0x008  registry/object table
ctx+0x1e0  COOKIE_RISK2 / op2 object
ctx+0x240  shared-ref obj
ctx+0x248  shared-ref refcnt
ctx+0x258  rwlock/busy
ctx+0x3c0..0x500 scratch/output buffer
```

升级时的原则：

- 先保留旧字段名；
- 用 entrydump/watch/xref 重新验证 offset；
- 不一致时优先改结构，不要硬套 334/350；
- 未证实字段保留 `field_0xNNN`。

## 10. IDA 落库轨迹

当前落库记录：

```text
ida_rename_update_350101_20260831.md
dyidre/skills/ida_apply_metasec_struct_evidence.py
```

已经明确的命名方向：

```text
getHttpHeadVerify -> buildSignedHttpHeadersInner_350
sub_1547D4 -> managedFrameSetSlot_350
F5/F7/F8/F13 对应 X-Argus/X-Ladon/X-Medusa/Helios-Soter
g_managedProg_sign_F*_350 写在对应全局旁边，并补中文注释
```

要求：

- 函数头写简洁说明；
- 关键地址旁边写中文注释；
- 不要把一大串路标塞到函数开头；
- 没证据的 Fxx/CFxx 不硬起业务名。

## 11. 350101 可直接复用的升级模板

新版本可以直接从这些东西复制：

```text
dyidre/probes/350101/metasec_probe_350101.js
dyidre/probes/350101/run_metasec_probe_350101.sh
dyidre/probes/350101/README.md
unidbg/unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6_350101.java
unidbg/unidbg-android/src/test/resources/metasec/350101/
unidbg/scripts/metasec-350101-req01-baseline.sh
```

复制后必须替换：

- version code；
- package/APK/SO 来源；
- HTTP wrapper/inner offset；
- managed VM/F program offset；
- `exeVMInner` offset 和 vmCode；
- fixed env/rootfs；
- expected X-header len/hash/value。

## 12. 当前下一步建议

如果继续深挖 350101：

1. 保持 `req01 s1/s2 + fixed env` 不变；
2. 优先补 `X-Medusa` F8/F12/source-work 的值级注释；
3. 用 stackplz/eDBG 追少数 buffer/slot 写入来源；
4. 把确认过的字段继续写回 `metasec_structs_350_all.h` 和 IDA；
5. C oracle 每补一段就跑一次 `run_recovered_c_oracles_350101.sh`。

如果升级新版本：

1. 先跑 SO identity；
2. 找到 `buildSignedHttpHeadersInner`；
3. 抓一条真机请求；
4. 固化 `s1/s2/env`；
5. 跑 unidbg baseline；
6. 只追和 350101 不一致的 gate。
