# dyidre

`dyidre` 是 Douyin `libmetasec_ml.so` 的动态逆向/版本迭代工作区。

```text
dyidre = DouYin ID Reverse Engineering
```

这里不直接替代 `unidbg`、`IDA`、`rustFrida`、`eDBG`。它的角色是把这些工具产生的证据、脚本、结构体、VM decode、C 还原代码串在一起，形成可复跑的版本升级流程。

路径说明：GitHub 仓库根目录就是 `dyidre`，本文档默认所有路径都从仓库根目录开始写。若在包含 `dyidre/`、`unidbg/` 等同级目录的总工作区执行命令，给路径加上 `dyidre/` 前缀即可。

## 先看什么

如果只是接手当前 350101：

1. 先跑 unidbg 强基准：

   ```bash
   cd ../unidbg
   scripts/metasec-350101-req01-baseline.sh
   ```

2. 再看 350101 主分析目录：

   ```text
   versions/350101/
   ```

   这是 350101 的主分析目录。

3. 再看版本目录规范：

   ```text
   docs/version-layout.md
   ```

4. 再看 `libmetasec_ml.so` 分析主轨迹：

   ```text
   docs/metasec-analysis-trajectory.md
   ```

   这份文档记录从 SO 身份、真机采证、unidbg 复现、VM/CF 还原到 IDA 落库的完整路线。后面升级版本先按它走。

5. 再看工具链关系：

   ```text
   docs/toolchain.md
   ```

   Frida/RF JS、stackplz、eDBG 的复用手册：

   ```text
   docs/reusable-probes-stackplz-edbg.md
   ```

6. 设备侧工具/payload：

   ```text
   tools/README.md
   tools/runtime_payloads/README.md
   ```

   这里放已经验证过、后续版本可复用的 `rustfrida`、`wxshadow.kpm`、`hide-so.kpm`、`embed*.so`。新版本升级时先复用这些工具，不要重新从聊天记录里找散落文件。

7. 提交前检查：

   ```text
   docs/pre-commit-checklist.md
   materials/README.md
   ```

   推荐安装 `githooks/pre-commit`，这样每次 `git commit` 自动同步 `.apk/.so/.i64` 本体和 manifest，确保 APK 来源、SO、IDA 数据库改动都有提交记录。

8. 新版本升级照着：

   ```text
   docs/upgrade-runbook.md
   unidbg/docs/metasec-upgrade-template.md
   ```

## 当前 350101 状态

350101 已经做到：

- 真机 request01 的 `s1/s2` 已固化到 unidbg test resources；
- unidbg 固定 pid/tid/time/random/rootfs 后，可以稳定复现一条请求；
- `exeVMInner_4cc10` 调用次数和 vmCode/LR 分布与真机路径对齐；
- `X-Argus / X-Gorgon / X-Khronos / X-Ladon / X-Medusa / X-Helios / X-Soter` 在 deterministic unidbg baseline 下可验；
- C oracle 已沉淀到 `versions/350101`，用于算法级自测。

真正的验收入口不是某个聊天结论，而是：

```text
unidbg/scripts/metasec-350101-req01-baseline.sh
versions/350101/algorithm_validation_350101.md
versions/350101/c_recovery_suite_350101.md
```

## 目录地图

| 路径 | 作用 | 保留策略 |
|---|---|---|
| `versions/350101` | 当前 350101 主证据目录：结构体、VM、CF、X-header、C oracle、报告 | 后续新版本也放 `versions/<version>` |
| `runs/350101/` | 350101 真机采集批次，按采集类型和时间戳分层 | 新版本放 `runs/<version>/...` |
| `probes/350101/` | 350101 真机采集脚本：rustFrida/GumTrace/jnitrace/stackplz runner | 新版本复制到 `probes/<version>/` 后改 offset |
| `probes/common/` | 与版本无关的辅助脚本，例如弹窗处理 | 可跨版本复用 |
| `materials/` | 每个版本的 `.apk/.so/.i64` 本体和材料 manifest | 提交前必须同步本体并更新 manifest |
| `tools/` | 设备侧可复用工具和 payload：rustFrida、KPM、embed so | 用 Git LFS 提交；升级版本直接复用 |
| `scripts/` | 本地后处理/索引脚本 | 保留，可复跑 |
| `skills/` | 本目录内使用过的分析脚本；部分已沉淀到个人 skill | 保留脚本源码 |
| `runs/350101/true_env_xmedusa/` | 真机环境采集快照，`latest -> 20260831_214509` 是当前对齐来源 | 只保留当前基准批次 |
| `runs/350101/jnitrace/` | jnitrace/NewString/崩溃定位成品批次 | 半成品 RF 日志已删除 |
| `runs/350101/gumtrace/` | PC trace / VM trace 成品批次 | 大 raw 已在 `_archive/large_raw_traces` |
| `runs/350101/entrydump/` | HTTP/sign 入口 ABI 证据 | 保留 |
| `runs/350101/maps_artmethod/` | maps/ArtMethod 注入检测证据 | 保留 |
| `runs/350101/edbg_stackplz/` | eDBG/stackplz 硬断点和栈采样证据 | 保留 |
| `_archive/` | 大 raw trace、boot 镜像、runtime payload、可再生缓存 | 不作为日常入口 |

## 和 unidbg 的配合

`dyidre` 负责回答“真机到底发生了什么”；`unidbg` 负责回答“我们能不能稳定复现它”。

典型流向：

```text
rustFrida/eDBG/stackplz 真机采证
  -> dyidre 保存 entrydump / trace / jnitrace / 环境快照
  -> unidbg 固定 s1/s2 + rootfs + 时间/随机/pid/tid
  -> unidbg 输出 one-request count / X-header / managed dump
  -> dyidre 产出结构体、VM decode、C oracle
  -> IDA 落函数名、结构体、中文注释
```

也就是说，`unidbg` 不应该凭空补环境；每个关键 `MS.b`、`.msdata`、时间随机、VM 路径差异，都要能回指到 `dyidre` 里的真机证据。

## 和 rustFrida 的配合

rustFrida 是真机采集主力，主要负责：

- spawn 早期注入；
- entrydump：进入 `buildSignedHttpHeadersInner_350` 前 dump `x0~x5/x8` 和指针内容；
- jnitrace：打印 `libmetasec_ml.so` 相关 JNI 调用；
- GumTrace：记录 PC 序列、VM handler、`exeVMInner` 走到的 vmCode；
- true-env：把 `.msdata`、app files、时间/随机相关值抓成 rootfs/unidbg 可用输入。

常用脚本统一到一个入口：

```text
probes/350101/metasec_probe_350101.js
probes/350101/run_metasec_probe_350101.sh
```

设备侧工具本体在：

```text
tools/runtime_payloads/
```

用法见：

```text
tools/README.md
```

按 mode 选择用途：

```bash
probes/350101/run_metasec_probe_350101.sh counter-one 60 req01_count
probes/350101/run_metasec_probe_350101.sh true-env 90 req01_env
probes/350101/run_metasec_probe_350101.sh jnitrace 180 jni01
probes/350101/run_metasec_probe_350101.sh gum-exevm 90 gum4cc10
```

## 和 eDBG / stackplz 的配合

eDBG/stackplz 不是日常主线，而是“真机难点辅助工具”：

- rustFrida inline/trace 太吵、太慢、或被目标干扰时，用 eDBG/stackplz 做硬件断点/栈采样；
- 需要确认某个写入来源时，用 watch/rwatch/hbreak 盯少量地址；
- 需要“谁调用了这里”的时候，用栈回溯补证据。

当前相关证据和设计：

```text
versions/350101/edbg_assist_plan_350101.md
versions/350101/stackplz_rf_rpc_bridge_350101.md
runs/350101/edbg_stackplz/20260831_stackplz/
runs/350101/edbg_stackplz/20260831_stackplz_rf_rpc/
runs/350101/edbg_stackplz/20260831_edbg_test/
```

## 和 IDA 的配合

IDA 是最终静态落点，但不能反过来当唯一真相。

推荐顺序：

1. `dyidre` 用真机/unidbg 证据确认函数意义；
2. `versions/350101/metasec_structs_350_all.h` 和 `metasec_ctx350_draft.h` 生成结构体；
3. `skills/ida_apply_metasec_struct_evidence.py` 或 ida-pro-mcp 把名称、原型、中文注释写回 IDA；
4. 不确定的字段保持 `field_xxx`，不要为了好看硬命名。

## 清理原则

已经做过的清理：

- 顶层目录统一成 `dyidre`，公开文档使用仓库内相对路径；
- 两个 1GB 级 GumTrace raw log 移到 `_archive/large_raw_traces/`；
- 设备启动/APatch 镜像移到 `_archive/device_boot_images/`；
- rustFrida/kpm/embed payload 已从历史归档提升到 `tools/runtime_payloads/`，正式随仓库保存；
- `__pycache__`、`.last_*`、`current_*_ts.txt` 等可再生瞬态文件移到 `_archive/deleted_reproducible_20260831/`。

没直接物理删除大证据，因为这些 trace 以后定位“为什么当时判断成这样”还可能救命。确认不需要后，再删 `_archive/large_raw_traces/` 即可释放约 2.1G。
