# unidbg 侧 MetaSec 350101 分析整理

> 整理自 `../unidbg` 仓库（2026-09-05 时点）：两个已落地提交 + 一批未提交的
> managed/CF64 探针增强。本文只复述那边已有的证据和结论，详细 anchor 以
> `../unidbg/docs/metasec-350101-handoff.md` 为准。

## 一、分析过程

### 1. 目标定位

unidbg 仓库负责回答"我们能不能稳定复现真机这条签名请求"。它不是跑一个
打印 header 的 demo，而是把真机请求、unidbg 环境、managed VM/CF 路径、
C 还原算法串成一条可验证链路，作为 334/350/37x 版本升级的"尺子"。

### 2. 落地步骤（按提交顺序）

**第一步：`6f3190f9` Prepare MetaSec 350101 signer handoff（2026-08-31 23:05）**

- 新增 `Sign6MetaSecBase.java`（5,624 行）：33/35 共用 harness，负责 unidbg
  初始化、JNI/`MS.b` 环境补齐、SDK init、callback 注册、deterministic 时间/
  随机、trace/watch 探针；
- 新增三个用例：`Sign6_350101`（主基线）、`Sign6_330001`（33.0.0 对照）、
  `Sign6_370401`（37.4.0 探路，未收敛进 Base）；
- 对 unidbg core 做了一小组 deterministic 增强：
  - `UnixSyscallHandler`：固定 `currentTimeMillis` / `clock_gettime` / `getrandom`；
  - `ARM64SyscallHandler`：`gettid` 固定返回、`sysinfo`、boottime/monotonic clock；
  - `RandomFileIO`：deterministic `/dev/urandom`；
  - `FutexNanoSleepWaiter` / `NanoSleepWaiter`：允许 0/sub-ms timeout；
  - `UniThreadDispatcher` / `SignalTask`：修 worker/signal context 切换逃逸/卡死；
- 新增 `docs/metasec-350101-handoff.md` 交接文档。

**第二步：`50ec77b7` Refactor MetaSec 350101 profile for upgrades（2026-08-31 23:32）**

- 把 350101 的 native 路径锚点集中到 `Sign6MetaSecBase.MetaSecProfile.v350101()`，
  升级新版本时新增 profile 而不是在 Base 里散改 magic number；
- 新增 `scripts/metasec-350101-smoke.sh` 最小回归脚本。

**第三步（未提交，当前工作区状态）：managed/CF64 深潜探针**

已 stage：req01 强基线脚本 `metasec-350101-req01-baseline.sh`、基准资源包
`resources/metasec/350101/`（真机 `s1/s2` + `baseline.properties`）、
`docs/metasec-upgrade-template.md` 升级模板。

未 stage：`Sign6MetaSecBase.java` 再增约 2,000 行，新增探针家族：

| 探针家族 | 开关前缀 | 用途 |
|---|---|---|
| CF index dump | `metasec.callCf*` / `metasec.dumpCallCfIndex` | 按 CF index  dump 调用现场，支撑 `managed_sign_cf_table` 验证 |
| CF64 alias probe | `metasec.cf64Alias*` | F1 直调 F2/F19/F13 的 kind-1 pre/post 采集（对应 dyidre `cf64_alias_probe_350101.md`） |
| child native ABI probe | `metasec.childNativeAbi*` | CF64 `0x0d..0x16` child-native ABI 的 pre/post trace（对应 `cf64_child_native_abi_350101.md`） |
| managed program dump | `metasec.managedProgramTableOffset` 等 | 把 managed bytecode 程序 dump 到 `target/managed_program_dumps_*`，供 dyidre 的 `metasec_vm_trace_decoder.py` 离线 decode |
| 其它 | `metasec.dumpCf33Wire` / `dumpCf91Wire` / `traceCf71Tls` / `managedCfCallsites` | CF33/CF91 wire dump、CF71 TLS 追踪 |

`target/` 下的 dump 批次时间线正好对应 dyidre 这几天的 decode 推进：

```text
09-04 07:17  f0_f1_f2            -> 主模块 F0/F1/F2
09-04 15:01  child_f6 / second_f1_f22 -> CF63 F22、CF75 F6 child 边界
09-04 19:40  child_f0 / bindings / reachable -> child module 可达性
09-04 19:54  cf64_f1_bindings / reachable   -> CF64 F1 2,345 records
09-04 20:01  cf64_f1_secondhop / secondhop_bodies
09-05 02:58  cf64_thirdhop_descriptors / bodies -> 84 个 F body 全部机械解码
```

### 3. 复现方法（分析手段）

一条请求对齐真机的完整约束：

```text
backend=unicorn2
rootfs=rootfs_pixel6_350101_20260831_132930（真机 true-env 采集）
fixedPid=13556 fixedTid=13710
fixedCurrentTimeMillis=1788148652047
fixedElapsedRealtime(Nanos)=183397757(386512)
fixedMonotonicNanos=183397708672197
fixedBoottimeNanos=183397757386512
fixedRandomSeed=0x350101
alignTrueDeviceHttpRuntime=true
s1=req01_app_log_s1.txt（len=160, fnv1a=0xee81bf8e）
s2=req01_app_log_s2.txt（len=1277, fnv1a=0x758aefd4）
```

验证顺序是"先路径、再值"：

1. one-request count：8 个锚点各被调几次；
2. `exeVMInner` 的 vmCode/LR 分布；
3. 7 个 `X-*` header 的 len + sha1；
4. `X-Medusa` 额外校验 decoded len/sha1/b18。

## 二、分析结果

### 1. 已闭合结论

**路径级（与真机一致）**：

```text
http_entry_149ca8=1  nativeStage1_14a1ac=1  nativeStage2_14a1fc=1
managedF8_14a4e0=1   exeVMInner_4cc10=4     nativeVmpSelectMaterial_12564c=1
nativeVmpBuildMaterial_124dd4=1  managedF13_14a588=1
exeVMInner.vmCode={0x1ec670=2, 0x1ecaf0=1, 0x1f7860=1}
exeVMInner.lr={0xd95cc=2, 0xd964c=1, 0x124e34=1}
```

**值级（deterministic unidbg 基准，`baseline.properties`）**：

| Header | len | sha1 / value |
|---|---:|---|
| X-Argus | 8 | `d397ef0bebcd16a35fc32eb319041bac56807695` |
| X-Gorgon | 52 | `9092fe5eafa102a6b390022ce11b2de2a7b909f8` |
| X-Khronos | — | value=`1788148652` |
| X-Ladon | 8 | `d2cb4c05547d2fef883e264a952331b448a2bae3` |
| X-Medusa | 984 | `19fca4739bbe2d013545839141ec67466c8c3031` |
| X-Medusa decoded | 737 | `7a450688cbb6702500ff4d553f1518493fed789d`，b18=`0x3c` |
| X-Helios | 48 | `38e18aebdaaa35c896622f419e284812e8fed090` |
| X-Soter | 120 | `c8cb4a7e8f18e34468af3c4e72d76fbb34f52115`（空/default 场景） |

**最近一次实跑**：`target/sign6_350101_req01_baseline.log`
（2026-09-01 00:32）`Tests run: 1, Failures: 0`，`BUILD SUCCESS`，
基线脚本断言的 5 条 expected line 全部命中。

**算法还原边界（handoff 文档口径）**：

- 已稳定：`X-Gorgon`、`X-Khronos`、`X-Ladon`、`X-Helios`、`X-Argus` 主链路、
  `X-Soter` 空/default 场景、`X-Medusa` final pack/base64、F8 mini、
  F12 bit-pack、source-work transform；
- C 还原 suite 能复现 deterministic unidbg 的完整 `X-*` 输出。

**managed/CF64 推进（未提交探针产出的结果，已落在 dyidre 侧）**：

- CF64 的 84 个可达 F body（28,076 records）全部机械解码，unknown 0；
- `0x0d..0x16` child-native ABI 静态闭合，拿到一条严格 CF64-origin 的
  `0x0e` pre/post trace（4-byte forward copy、`s2=dst`）；
- CF64 alias probe 一次 local baseline 只验证 CF64→F1 scope，未命中
  F2/F19/F13 三个目标。

### 2. 未闭环事项

| 项 | 现状 | 下一步方向 |
|---|---|---|
| `X-Medusa` raw pack 真机环境字段 | 依赖固定 pack | 补环境字段采集/序列化 |
| `X-Soter` 非空场景 | 只有空/default 基准 | 采非空场景样本 |
| `alignTrueDeviceHttpRuntime` 的 runtime gate | 强制归一 | 从 `.msdata/MS.b` 真实建模 |
| CF64 跨 F2/F19/F13 对象别名 | 一次 probe 未命中 | 继续 pre/post 采集 |

### 3. unidbg 仓库自身卫生

- 已提交 2 个 metasec 提交（`6f3190f9`、`50ec77b7`）；
- **当前还有一批未提交改动**：基线脚本、基准资源包、升级模板（已 stage）
  + `Sign6MetaSecBase.java` 约 2,000 行新探针（未 stage）+ handoff 文档更新。
  这批是 CF64/managed 深探的全部工具链，建议尽快提交，否则下次
  升级 37x 时探针只在工作区里；
- deterministic 补丁若要回 upstream unidbg，需要拆成独立 PR。

## 附：关键入口

```text
../unidbg/docs/metasec-350101-handoff.md        # unidbg 侧主入口
../unidbg/docs/metasec-upgrade-template.md      # 新版本升级模板
../unidbg/scripts/metasec-350101-req01-baseline.sh  # 强基线（PASS 标准）
../unidbg/scripts/metasec-350101-smoke.sh       # 最小回归
../unidbg/unidbg-android/src/test/resources/metasec/350101/  # 基准资源包
```
