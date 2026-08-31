# MetaSec 版本升级流程

这份流程用于后续从 350101 升到新版本。目标是快速定位入口、确认路径差异、补环境、再还原算法。

如果是第一次接手，先读主轨迹：

```text
docs/metasec-analysis-trajectory.md
```

这里的 upgrade-runbook 更偏执行清单；主轨迹解释每一步为什么要做、怎么判断过关、350101 的证据链在哪里。

## 0. 建版本目录

新版本建议用：

```text
versions/<version>/
runs/<version>/
```

不要把 `struct_infer_xxx` 这类临时恢复目录放在仓库根目录；版本结论统一放进 `versions/<version>/`。

建好 `versions/<version>/` 后，尽早生成版本文件清单：

```bash
python3 scripts/generate_version_file_catalog.py <version>
```

这份 `FILE_CATALOG.md` 要回答：每个文件怎么来、哪个脚本生成、分析下一版时怎么复用。后续提交前 hook 会自动刷新它。

## 1. 先确认 SO 身份

不要靠 APK 名字、IDB 名字判断是不是同一个 SO。

要记录：

- raw `.so` 路径；
- size；
- sha256；
- build-id；
- `file/readelf` 信息；
- 关键字符串锚点；
- APK 来源和 ABI。

建议跑：

```bash
python3 /Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_so_probe.py \
  /absolute/path/to/libmetasec_ml.so \
  --out versions/<version>/metasec_so_identity.md
```

提交前还要同步 `.apk/.so/.i64` 本体和材料 manifest：

```bash
scripts/sync_metasec_materials.sh <version> <so_path> <ida_i64_path> <apk_path>
```

如果只是检查有没有忘更新：

```bash
scripts/update_materials_manifest.sh --check \
  --apk materials/<version>/source.apk \
  <version> \
  materials/<version>/libmetasec_ml.so \
  materials/<version>/libmetasec_ml.so.i64
```

## 2. 找 HTTP 签名入口

从旧版本锚点开始：

| 版本 | 已知锚点 |
|---|---|
| 334 | `getHttpHeadVerify @ 0x15AB90` |
| 350101 | `buildSignedHttpHeadersInner_350 @ 0x149CA8` |
| 350101 | wrapper/callback `0x14DBF4` |
| 350101 | `exeVMInner @ 0x4CC10` |

新版本找入口时按这个顺序：

1. 字符串/xref：`X-Argus`、`X-Medusa`、`X-Soter`、`x-ss-stub`、`MS.b`；
2. call graph：是否有 parse header、registry type lookup、managed F 调用、TreeMap 写出；
3. ABI：入口是否仍然能解释 `url / x-ss-stub / json_list / tree_map / ctx`；
4. 真机 entrydump：用 rustFrida 在候选入口 dump `x0~x5/x8`；
5. unidbg entrydump：同一组 `s1/s2` 下 dump 一遍，对比结构形态。

## 3. 抓一条真机基准请求

只需要一条稳定请求，不要一上来跑 10 分钟。

必须保存：

```text
req01_<scene>_s1.txt
req01_<scene>_s2.txt
baseline.properties
```

`baseline.properties` 里至少要有：

```text
fixedCurrentTimeMillis
fixedElapsedRealtime
fixedElapsedRealtimeNanos
fixedMonotonicNanos
fixedBoottimeNanos
fixedPid
fixedTid
fixedRandomSeed
rootfs.default
x_ss_req_ticket
x_ss_stub
expected.counts
expected.exe_vmcode
expected.exe_lr
expected.X-*.len/hash
```

350101 当前样板在：

```text
unidbg/unidbg-android/src/test/resources/metasec/350101/
```

## 4. 同步真机环境到 unidbg

真机采集：

```bash
cd /Users/freeman/project/douyin/dyidre
probes/<version>/run_metasec_probe_<version>.sh true-env 90 req01_env
```

输出目录形如：

```text
runs/<version>/true_env_xmedusa/<timestamp>/
```

采完以后立刻做两件事：

```bash
python3 scripts/extract_true_env_xmedusa.py \
  runs/<version>/true_env_xmedusa/<timestamp> \
  --version <version>

python3 scripts/index_true_env_runs.py \
  --root runs/<version>/true_env_xmedusa \
  --out-md runs/<version>/true_env_xmedusa/RUNS.md \
  --out-json runs/<version>/true_env_xmedusa/runs_manifest.json
```

如果只是检查解析结果，不想覆盖文件，给 `extract_true_env_xmedusa.py` 加 `--dry-run`。

要同步到 unidbg 的通常是：

- app files / `.msdata`；
- `.msf3_<sha1>`；
- `MS.b` 相关返回；
- 时间/随机/pid/tid；
- `x-ss-req-ticket`、`x-ss-stub`；
- 参与 F8/X-Medusa 的 JSON/env 字段。

当前 350101 的说明在：

```text
versions/350101/unidbg_env_fill_350101.md
versions/350101/environment_inputs_350101.md
```

## 5. 给 unidbg 加版本 profile

在：

```text
unidbg/unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6MetaSecBase.java
```

新增：

```java
MetaSecProfile.v<version>()
```

再新增：

```text
Sign6_<version>.java
scripts/metasec-<version>-smoke.sh
scripts/metasec-<version>-req01-baseline.sh
```

注意：offset 全放进 `MetaSecProfile`，不要散落在 dump/watch 方法里。

## 6. 先对齐路径，再对齐值

第一层看调用次数：

```text
http_entry
nativeStage1
nativeStage2
managedF5/F7/F8/F13
exeVMInner
nativeVmpBuildMaterial
nativeVmpSelectMaterial
```

第二层看 `exeVMInner`：

```text
vmCode 分布
LR 分布
pParamList / vmData1 / vmData2 / vmParam
```

第三层看 header 输出：

```text
X-Argus
X-Gorgon
X-Khronos
X-Ladon
X-Medusa
X-Helios
X-Soter
```

## 7. 差异定位规则

| 现象 | 优先查 |
|---|---|
| entrydump 入参不一致 | `s1/s2`、header parse、`MS.b`、rootfs、`.msdata` |
| one-request count 不一致 | runtime gate、branch flag、managed F offset、CF table |
| `exeVMInner.vmCode` 不一致 | native VMP wrapper、material selector、ctx 字段 |
| 路径一致但 header 不一致 | 时间、随机、未初始化内存、env JSON、source-work buffer |
| 只有 `X-Medusa` 不一致 | F8 slot、decoded offset、CF79/env fields、F12/source-work |
| C oracle 对不上 unidbg | 先 dump 中间 pack，不要直接猜最终 base64 |

## 8. 更新 dyidre 和 IDA

每确认一层，都要沉淀：

- `versions/<version>/README.md`：这一版总入口；
- `metasec_so_identity.md`：身份；
- `*_entrydump_compare.md`：真机/unidbg ABI；
- `x_headers_generation_<version>.md`：header 流程；
- `managed_vm_recovery_<version>.md`：managed VM；
- `exeVMInner_x_headers_<version>.md`：native VM；
- `metasec_structs_<version>_all.h`：结构体；
- `ida_rename_update_<version>.md`：IDA 命名/注释记录；
- C oracle 和验证日志。

最后把稳定锚点同步到：

```text
/Users/freeman/.codex/skills/metasec-so-recognizer/references/known-<version>.md
```

这样下一次升级可以直接继承。
