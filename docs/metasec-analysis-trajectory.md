# `libmetasec_ml.so` 分析轨迹

这份文档是后续升级版本时的主路线图。它记录的不是某一次零散操作，而是从一个新 `libmetasec_ml.so` 到“真机路径可解释、unidbg 可复现、IDA 可读、C oracle 可验”的完整轨迹。

当前基准版本是 `350101`。后面每升一个版本，都按同一套证据链走，不要重新造一套脚本。

## 核心原则

所有结论都要能回到证据：

```text
SO 身份
  -> 静态锚点
  -> 真机单请求 entry/counter/env/header
  -> unidbg 固定复现
  -> 路径差异
  -> 值级差异
  -> 结构体/VM/CF 还原
  -> C oracle
  -> IDA 命名、原型、中文注释
```

不要只信：

- APK 文件名；
- IDA 里旧注释；
- 334 导入过来的结构体；
- 某一次 full trace 里的 raw PC 差异；
- fixed baseline 里的时间、随机、pid/tid 等环境值。

这些都只能作为线索，不能单独当结论。

## 目录职责

后面接手时先按这个规则找文件：

| 目录 | 放什么 | 怎么用 |
|---|---|---|
| `dyidre/docs/` | 跨版本流程、工具链、升级规则 | 新版本先读这里 |
| `dyidre/probes/<version>/` | 真机采集脚本 | 复制上一版，改 offset 和版本号 |
| `dyidre/runs/<version>/` | 真机采集原始证据 | 每次采集一个 run_id，不覆盖 |
| `dyidre/versions/<version>/` | 分析结论、结构体、VM decode、C oracle | 新版本主工作区 |
| `unidbg/unidbg-android/src/test/resources/metasec/<version>/` | 固定基准输入 | 放 `s1/s2/baseline.properties` |
| `unidbg/scripts/metasec-<version>-*.sh` | unidbg 一键回归 | 验证是否复现 |

一句话：`runs` 放证据，`versions` 放结论，`unidbg resources` 放可复跑输入。

## 37xx 升级时怎样使用 350101

350101 目录的价值，是给新版本提供“对照坐标系”。分析 37xx 时，不是把 350101 结论原样搬过去，而是按文件类型逐项复用：

| 350101 里已有的东西 | 37xx 怎么用 |
|---|---|
| `dyidre/materials/350101/` | 照同样格式保存 37xx 的 `source.apk/libmetasec_ml.so/libmetasec_ml.so.i64/materials_manifest.md`，先确认材料身份。 |
| `metasec_so_identity.md` | 对 37xx 跑 SO probe，比较 size/hash/build-id/string anchors，判断是小改、重排还是大换代。 |
| `analysis_trajectory_350101.md` | 复制成 37xx 分析轨迹，每完成一层就替换证据和结论。 |
| `probes/350101/metasec_probe_350101.js` | 复制到 `probes/37xxxx/`，只改 offset 表和输出版本号；采集方式继续复用。 |
| `real_vs_unidbg_entry_shape.md` | 37xx 先做同样的 entrydump 对比，确认 ABI 没偏。 |
| `environment_inputs_350101.md` / `unidbg_env_fill_350101.md` | 对 37xx 补 `MS.b/.msdata/rootfs/time/random/pid/tid`，让 unidbg 约束贴近真机。 |
| `managed_vm_decode*/` | 对 37xx dump managed program 后复跑 decoder，比较 F 程序长度、opcode、CF index、slot 行为。 |
| `managed_cf_*` / `x_argus*` / `x_medusa*` | 按 header 分段比较：先看路径，再看中间 pack，再看最终 base64/header。 |
| `*_recovered_350101.c` | 作为算法 oracle 模板；37xx 若只是常量/表变了，就换向量和常量验证；若逻辑变了，再重 lift。 |
| `ida_rename_update_*.md` / `metasec_structs_350_all.h` | 用作 IDA 命名和结构迁移参考；字段必须有 37xx runtime/static 证据才能落库。 |
| `FILE_CATALOG.md` | 新版本也生成一份，保证“文件从哪来、怎么生成、后面干嘛”一直可追。 |

37xx 的最小落地目标：

```text
dyidre/versions/37xxxx/README.md
dyidre/versions/37xxxx/FILE_CATALOG.md
dyidre/versions/37xxxx/metasec_so_identity.md
dyidre/versions/37xxxx/analysis_trajectory_37xxxx.md
dyidre/materials/37xxxx/source.apk
dyidre/materials/37xxxx/libmetasec_ml.so
dyidre/materials/37xxxx/libmetasec_ml.so.i64
unidbg/unidbg-android/src/test/resources/metasec/37xxxx/
```

做到这些，后面再继续补 VM/CF/C oracle，不会变成一堆散文件。

## 350101 已验证主路径

350101 的路径可以作为后续版本的“模板答案”，但新版本必须重新验证 offset。

```text
Java / HTTP 请求
  -> 0x14DBF4 buildSignedHttpHeadersCallback_350
  -> 0x149CA8 buildSignedHttpHeadersInner_350
       -> 0x16D204 signStage1_makeStubPieces_350
       -> 0x16D454 signStage2_makeKeyPieces_350
       -> 0x1715F8 managedSignBuildA_350      -> F5  -> X-Argus
       -> 0x171648 managedSignBuildB_350      -> F7  -> X-Ladon
       -> 0x171698 managedSignBuildFinal_350  -> F8  -> X-Medusa/final material
       -> 0x1716F4 managedSignPostEmitF13_350 -> F13 -> X-Helios / X-Soter side path
       -> TreeMap 写出 X-* header
```

最终 header 写出锚点：

| header | 350101 锚点 | 说明 |
|---|---:|---|
| `X-Gorgon` | `0x14A1C0` origin | 经 `treeMapPut_X22_X27_X28_350` wrapper |
| `X-Khronos` | `0x14A210` origin | 经 wrapper |
| `X-Argus` | `0x14A3A0` origin | F5 产物，len 约 `0x104` |
| `X-Ladon` | `0x14A400` origin | F7 产物，len 约 `0x30` |
| `X-Medusa` | `0x14A53C` | direct `treeMapPut_350`，重点追 F8 |
| `X-Helios` | `0x14A5A8` origin | 经 `treeMapPut_X22_X23_X24_350` wrapper |
| `X-Soter` | `0x14A65C` | direct `treeMapPut_350` |

配套证据：

```text
dyidre/versions/350101/x_headers_generation_350101.md
dyidre/versions/350101/exeVMInner_x_headers_350101.md
dyidre/versions/350101/managed_vm_recovery_350101.md
dyidre/versions/350101/algorithm_validation_350101.md
```

## 现在实际有几层 VM

350101 至少要分清两层，不要混成一个 `VM`：

| 层 | 入口 | 作用 | 怎么验证 |
|---|---:|---|---|
| native VMP | `0x4CC10 exeVMInner_350` | 执行 native VMP 片段，生成/选择部分签名材料 | `gum-exevm`、`counter-one`、`exeVMInner.vmCode/LR` 分布 |
| managed VM | `0x1555A4 managedBytecodeRun_350` | 执行解码后的 F 程序，驱动 F5/F7/F8/F13 和 CF helper | managed program dump、CF/slot/watch、decoder |

它们不是简单“VM 里面永远套 VM”的关系，更准确是分层协作：

```text
buildSignedHttpHeadersInner
  -> managed F5/F7/F8/F13
       -> CALL_CF_INDEX 调 native helper
            -> 部分 native helper / wrapper 再走 0x4CC10 native VMP
```

所以定位时先问：

- 当前差异在 managed slot/CF 路径里？
- 还是 native VMP `vmCode` / material selector 里？
- 还是最终 TreeMap/base64/拼接阶段？

不要一上来 full trace 整个 so。

## 第 0 步：建立新版本骨架

新版本先建这些目录：

```text
dyidre/versions/<version>/README.md
dyidre/runs/<version>/README.md
dyidre/probes/<version>/README.md
unidbg/unidbg-android/src/test/resources/metasec/<version>/README.md
```

然后复制上一版 probe：

```bash
cp -R dyidre/probes/350101 dyidre/probes/<version>
```

必须修改：

- runner 文件名里的版本；
- `metasec_probe_<version>.js` 里的 offset 表；
- 输出目录里的版本号；
- README 里的已验证状态。

如果还没确认 offset，只写 `candidate`，不要写成 final。

同时把新版本材料加入自动同步表：

```text
dyidre/materials/materials_sources.tsv
```

格式：

```text
<version>	<so_path>	<ida_i64_path>	<apk_path>
```

安装过 `dyidre/githooks/pre-commit` 后，每次提交都会自动复制 `.apk/.so/.i64` 到 `dyidre/materials/<version>/` 并更新 manifest。

## 第 1 步：确认 SO 身份

目标：确认手里的 `.so` 到底是哪一个，避免“APK 名一样但 so 不同”。

命令：

```bash
python3 /Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_so_probe.py \
  /absolute/path/to/libmetasec_ml.so \
  --out dyidre/versions/<version>/metasec_so_identity.md
```

必须记录：

- raw `.so` 路径；
- size；
- sha256；
- build-id；
- `file/readelf` 信息；
- 关键字符串锚点；
- APK 来源、ABI、安装包版本。

通过标准：

- `metasec_so_identity.md` 存在；
- 能说明这个 so 从哪个 APK/设备来；
- 后面所有 offset 都明确是这个 so 的 offset。
- 提交前同步了 `dyidre/materials/<version>/libmetasec_ml.so`、`dyidre/materials/<version>/libmetasec_ml.so.i64` 和 `materials_manifest.md`，让 SO 与 IDA 数据库本体都有提交记录。

## 第 2 步：找 HTTP/sign 入口

350101 可参考：

| 名称 | offset |
|---|---:|
| `buildSignedHttpHeadersCallback_350` | `0x14DBF4` |
| `buildSignedHttpHeadersInner_350` | `0x149CA8` |
| `exeVMInner_350` | `0x4CC10` |

新版本定位顺序：

1. 用字符串/xref 找 `X-Argus`、`X-Medusa`、`X-Soter`、`x-ss-stub`、`MS.b`；
2. 看附近是否有 header parse、registry type lookup、managed F 调用、TreeMap put；
3. 和上一版做函数形状对齐；
4. 用真机 entrydump 确认 ABI；
5. 用 unidbg entrydump 对同一组 `s1/s2` 复查。

通过标准：

- 入口参数能解释成 `ctx/json_list/url/x_ss_stub/type/tree_map`；
- 能看到 F5/F7/F8/F13 或等价 managed 调用；
- 能看到最终 X-header 写出。

## 第 3 步：抓一条真机基准请求

先只抓一条请求。多请求和 10 分钟采集放后面。

命令：

```bash
cd /Users/freeman/project/douyin
dyidre/probes/<version>/run_metasec_probe_<version>.sh counter-one 60 req01_count
dyidre/probes/<version>/run_metasec_probe_<version>.sh true-env 90 req01_env
dyidre/probes/<version>/run_metasec_probe_<version>.sh xheader 90 req01_xhdr
```

如果要补 JNI 环境：

```bash
dyidre/probes/<version>/run_metasec_probe_<version>.sh jnitrace 180 req01_jni
```

必须保存：

```text
req01_app_log_s1.txt
req01_app_log_s2.txt
baseline.properties
```

350101 样板在：

```text
unidbg/unidbg-android/src/test/resources/metasec/350101/
```

通过标准：

- `s1/s2` 能回指到某次真机请求；
- `counter-one` 有关键函数命中次数；
- `true-env` 有时间/随机/rootfs/.msdata/MS.b 相关证据；
- `xheader` 有最终 header key/value 或至少 key/len/hash。

## 第 4 步：同步真机环境

目标：把真机约束变成 unidbg 可复现输入。

真机采完后解析：

```bash
python3 dyidre/scripts/extract_true_env_xmedusa.py \
  dyidre/runs/<version>/true_env_xmedusa/<run_id> \
  --version <version>
```

再索引：

```bash
python3 dyidre/scripts/index_true_env_runs.py \
  --root dyidre/runs/<version>/true_env_xmedusa \
  --out-md dyidre/runs/<version>/true_env_xmedusa/RUNS.md \
  --out-json dyidre/runs/<version>/true_env_xmedusa/runs_manifest.json
```

要同步到 unidbg 的常见项：

| 类别 | 例子 | 说明 |
|---|---|---|
| 时间 | `currentTimeMillis`、`elapsedRealtime`、`elapsedRealtimeNanos` | 只能来自真机或固定 baseline |
| 随机 | random seed / random bytes | 固定后才能验算法 |
| 进程 | pid/tid/uid/package | 某些字段可能进包 |
| 文件 | `.msdata`、`.msf3_*`、app files | 复制进 rootfs |
| Java/env | `MS.b`、system property、settings | 由 jnitrace/true-env 补 |
| 请求 | `x-ss-stub`、`x-ss-req-ticket`、url、query/body | 算法输入 |

通过标准：

- unidbg profile 里的固定值能说明来源；
- 不能解释来源的值先标 `TODO from true device`，不要伪装成算法常量。

## 第 5 步：建立 unidbg 固定复现

代码入口：

```text
unidbg/unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6MetaSecBase.java
unidbg/unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6_<version>.java
unidbg/scripts/metasec-<version>-req01-baseline.sh
```

要求：

- offset 全部收敛到 `MetaSecProfile.v<version>()`；
- `s1/s2` 放到 resources；
- 时间、随机、pid/tid、rootfs 不散落在测试代码里；
- sign 类里的关键业务入口加中文注释，说明和真机哪个证据对上。

通过标准：

```bash
cd /Users/freeman/project/douyin/unidbg
scripts/metasec-<version>-req01-baseline.sh
```

能稳定输出：

- one-request count；
- `exeVMInner.vmCode/LR` 分布；
- X-header 结果；
- deterministic validation。

## 第 6 步：先对路径，不先追值

路径验证看这几组：

```text
buildSignedHttpHeadersCallback
buildSignedHttpHeadersInner
signStage1_makeStubPieces
signStage2_makeKeyPieces
managedSignBuildA/F5
managedSignBuildB/F7
managedSignBuildFinal/F8
managedSignPostEmitF13/F13
exeVMInner vmCode/LR
TreeMap X-header emit
```

350101 已经验证过的关键结论：

```text
managed_native_blr_15454c = 311
prefix_match = 311
first_diff = none
X-Khronos = 1788159560
```

raw PC 层可以有 helper 差异，例如 operator new、shared-ref、ctor/dtor。只要 managed hit、CF/x2、blr target 能重新同步，就不要把它当算法分支差。

通过标准：

- true device 与 unidbg 的 managed/CF/BLR 主线一致；
- `no_resync=0` 或等价结果；
- 差异能解释为内存分配、对象构造、锁/引用计数这类 runtime helper。

## 第 7 步：再追值级差异

值级差异按这个顺序追：

| 现象 | 优先看 |
|---|---|
| 入口 pack 不一致 | `s1/s2`、header parse、`MS.b`、rootfs、`.msdata` |
| count 不一致 | stage gate、managed F offset、CF table、mode/type |
| `exeVMInner.vmCode` 不一致 | native VMP wrapper、material selector、ctx 字段 |
| 只有 `X-Medusa` 不一致 | F8 slot、source-work buffer、CF79/env fields、F12 bitpack |
| header 写出前一致但最终不一致 | base64、TreeMap put、key/value memblock |

350101 当前最有价值的定位模板：

```text
X-Medusa decoded[0x18] 不一致
  -> true-env dump F8 入参 pack
  -> watch managedFrameSetSlot_350 / work-area ST64
  -> dump 0x14A53C 前后的 raw bytes
  -> 对应回 F8/F13/CF helper
```

优先工具：

```text
true-env / xheader / branch
  -> stackplz/eDBG watch 少数地址
  -> unidbg slot/watch 复现
```

不要为了一个 byte 开 full instrseq。

## 第 8 步：结构体同步完善

结构体不是一次写死，必须边分析边修。

信息来源优先级：

1. 真机 entrydump 中的指针内容；
2. unidbg 同 ABI entrydump；
3. IDA 静态 xref；
4. read/write watch；
5. 旧版本结构体。

350101 已确认核心形态：

```text
X0 = MetaSecCtx350 *
X1 = json_list window
X2 = url window / MEM_BLOCK **
X3 = x_ss_stub window
W4 = type
X5 = tree_map window
X8 = temp sign_tree / scratch
```

常用字段：

```text
ctx+0x008  registry/object table
ctx+0x1e0  COOKIE_RISK2 / op2 object
ctx+0x240  shared-ref obj
ctx+0x248  shared-ref refcnt
ctx+0x258  rwlock/busy
ctx+0x3c0..0x500 scratch/output buffer
```

结构文件：

```text
dyidre/versions/350101/metasec_structs_350_all.h
```

命名规则：

- 已证实的字段用业务名；
- 推测字段加 `_maybe` 或中文说明；
- 未知字段保留 `field_0xNNN`；
- 不要为了反编译好看，把 334 的字段硬套到新版本。

## 第 9 步：managed VM / CF 还原

350101 的 managed VM 入口：

```text
0x1555A4 managedBytecodeRun_350
0x1547D4 managedFrameSetSlot_350
0x1547C0 managedFrameGetSlot_350
0x15454C managedProgramInvoke_350
0x154468 managedProgramInvokeCore_350
```

已知 program：

| program | 作用 |
|---|---|
| F5 | `X-Argus` |
| F7 | `X-Ladon` |
| F8 | `X-Medusa` / final material |
| F13 | `X-Helios` / `X-Soter` 后处理路径 |

decoder：

```bash
python3 /Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py ...
```

结果放：

```text
dyidre/versions/<version>/managed_vm_decode*/
dyidre/versions/<version>/managed_vm_recovery_<version>.md
dyidre/versions/<version>/managed_vm_program_lift_<version>.md
```

CF helper 恢复顺序：

1. 先恢复会影响 header 值的 CF；
2. 再恢复 source-work / transform family；
3. 最后补格式化、alloc、引用计数这类 glue。

350101 已沉淀的重点：

```text
CF41 SIMON128/256
CF43 AES-128-CBC
CF48 short transform
CF61 SM3
F12 bitpack/source byte stream
F5 X-Argus pack concat/base64
```

## 第 10 步：native VMP / `exeVMInner` 还原

350101 native VMP 入口：

```text
0x4CC10 exeVMInner_350
```

常见 vmCode：

| vmCode | 当前理解 |
|---:|---|
| `0x1EC670` | short helper VM |
| `0x1ECAF0` | short helper VM |
| `0x1F7860` | HTTP/sign 路径里的 heavy native VMP material builder |

真机追踪：

```bash
dyidre/probes/<version>/run_metasec_probe_<version>.sh gum-exevm 90 req01_gum_exevm
dyidre/probes/<version>/run_metasec_probe_<version>.sh native-vmp 90 req01_native_vmp
```

通过标准：

- 真机和 unidbg 的 `exeVMInner` 调用次数一致或差异可解释；
- `vmCode` 分布一致；
- 重要 wrapper 的 LR 分布一致；
- heavy VM 的输入/输出对象能和 managed F8/F13 对上。

## 第 11 步：C oracle / fixed signer

最终目标不是“unidbg 能跑一下”，而是能写出一个可复现的算法 harness：

```c
generate_headers_350101(s1, s2, fixed_env, out_headers)
```

输入只允许：

- `s1/s2`；
- 固定环境；
- 固定时间/随机；
- 已确认的 rootfs/app files 状态。

不允许：

- 从当前进程偷偷读环境；
- 把某次输出硬编码成算法；
- 没来源的 magic 常量。

验收：

```text
单个 CF/helper oracle failures=0
fixed signer 与 unidbg deterministic baseline 完全一致
关键中间 pack 可 dump 对比
```

350101 入口：

```text
dyidre/versions/350101/c_recovery_suite_350101.md
dyidre/versions/350101/run_recovered_c_oracles_350101.sh
dyidre/versions/350101/metasec_350101_fixed_signer.c
dyidre/versions/350101/x_headers_algorithms_350101.c
```

## 第 12 步：IDA 落库

IDA 只落证据确定的东西。

推荐落这些：

- 函数名；
- 函数原型；
- Local Types；
- 全局变量名；
- 关键行中文注释；
- 未确定字段的 TODO 注释。

350101 脚本和记录：

```text
dyidre/skills/ida_apply_metasec_struct_evidence.py
dyidre/versions/350101/ida_rename_update_350101_20260831.md
dyidre/versions/350101/metasec_structs_350_all.h
```

注释风格：

```text
[evidence] English short evidence.
【中文】这里做什么、证据来自哪个 trace/unidbg dump、还有什么没确定。
```

不要把所有路标挤成函数头一行；关键判断、关键 call、关键写 header 的地方，注释写在对应地址旁边。

IDA 落库后必须同步材料状态：

```bash
dyidre/scripts/sync_metasec_materials.sh <version> <so_path> <ida_i64_path> <apk_path>
```

原因很简单：`.i64` 是分析材料本身。改了函数名、结构体、中文注释却不更新 `.i64`/manifest，后面升级版本会不知道当前报告到底对应哪份 IDA 数据库。

## 升级验收门

每个新版本按下面过 gate。没有过的 gate 不要往后硬推。

| Gate | 名称 | 必须有的证据 |
|---|---|---|
| A | SO 身份 | `metasec_so_identity.md`，hash/build-id/来源 |
| B | 入口 ABI | 真机 entrydump + unidbg entrydump |
| C | 单请求路径 | counter-one，关键函数和 `exeVMInner` count |
| D | 环境同步 | true-env/jnitrace/rootfs/MS.b 记录 |
| E | Header 输出 | xheader，X-* len/hash/value 对比 |
| F | VM 路径 | managed F/CF/BLR + native vmCode/LR 对齐 |
| G | 结构体 | `metasec_structs_<version>_all.h` 有证据注释 |
| H | 算法 | C oracle/fixed signer 与 unidbg baseline 对齐 |
| I | IDA | rename/prototype/comment apply 记录 |

## 常见误区

- 一上来跑 10 分钟 full trace。先抓一条请求，先对路径。
- 把 raw PC helper 差异当成算法分叉。先看是否能 resync。
- 把真机环境固定值当成算法常量。时间/随机/pid/tid 都要可追溯。
- 用 RF inline hook 密集挂相邻基本块。深度点位用 stackplz/eDBG。
- 334 的结构体直接套 350。旧结构只当提示。
- `X-Medusa` 差一个 byte 就改最终 base64。先追 F8/source-work/CF79/F12。
- 只改 IDA 名字不写中文注释。后面升级的人会重新踩坑。

## 新版本最小执行清单

复制这段到新版本 README 里逐项打勾：

```text
[ ] SO identity 已生成，来源明确
[ ] HTTP/sign wrapper 和 inner entry 已定位
[ ] true-device counter-one 已采集
[ ] true-device true-env 已采集并解析
[ ] req01 s1/s2 已固化到 unidbg resources
[ ] unidbg MetaSecProfile.<version> 已新增
[ ] unidbg baseline 一键脚本可跑
[ ] 真机/unidbg entrydump ABI 一致
[ ] managed F/CF/BLR 路径一致
[ ] exeVMInner vmCode/LR 分布一致
[ ] X-* header 输出 len/hash/value 已对齐或差异已记录
[ ] 差异字段有 watch/slot/CF 证据
[ ] 结构体已更新，未知字段未硬猜
[ ] managed VM decode 已生成
[ ] native VMP 重点 vmCode 已记录
[ ] C oracle/fixed signer 已补到当前可验阶段
[ ] IDA rename/prototype/comment 已同步
```
