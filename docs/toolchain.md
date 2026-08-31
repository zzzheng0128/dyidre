# dyidre 工具链配合关系

这套工程里每个工具只解决一段问题。不要让一个工具承担所有事情，否则会变成“能跑但不可解释”的黑盒。

## 总流向

```text
真机采证
  rustFrida / GumTrace / jnitrace / eDBG / stackplz
        |
        v
dyidre 证据归档
  entrydump / raw trace / branch count / env snapshot / maps / tombstone
        |
        v
unidbg 复现
  fixed s1/s2 + fixed env + rootfs + MS.b/.msdata
        |
        v
dyidre 还原
  struct infer / managed VM decode / native VMP lift / C oracle
        |
        v
IDA 落库
  rename / prototype / Local Types / 中文注释
```

## 1. rustFrida：真机主采集

rustFrida 的作用是从真实 App 进程里拿“不可猜”的数据。

主要产物：

| 产物 | 例子 | 用途 |
|---|---|---|
| entrydump | `runs/350101/entrydump/*` | 确认函数 ABI、`x0~x5/x8`、入参结构 |
| GumTrace PC 序列 | `runs/350101/gumtrace/*` | 确认 VM 入口、handler、真实执行路径 |
| jnitrace | `probes/350101/metasec_probe_350101.js mode=jnitrace`、`runs/350101/jnitrace/*` | 补 JNI 环境、`MS.b`、NewString/FindClass 等 |
| true-env dump | `runs/350101/true_env_xmedusa/<timestamp>/` | 把真机环境同步给 unidbg |
| maps/artmethod 检查 | `runs/350101/maps_artmethod/*` | 判断注入/Hook 是否污染 maps 或 ArtMethod |

什么时候用：

- 要找新版本 `buildSignedHttpHeaders*` / `exeVMInner` 入口；
- unidbg 和真机 header 不一致，需要确认真机入参；
- 怀疑 `MS.b` / `.msdata` / 时间随机 / 进程状态参与计算；
- 需要抓第一条真实请求。

Frida/RF 分析 JS 和 stackplz/eDBG 的具体复用方式，统一看：

```text
dyidre/docs/reusable-probes-stackplz-edbg.md
```

以后新增版本时，优先复制 `probes/350101/`，改统一 JS 的 offset 表和 runner 版本号，不要重新写一套 jnitrace/gumtrace/watch 脚本。

## 2. unidbg：可重复复现和回归

unidbg 的作用不是替代真机，而是把真机约束固定下来，让同一条请求每次跑出同一套路径和值。

当前主入口：

```text
unidbg/unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6_350101.java
unidbg/unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6MetaSecBase.java
unidbg/scripts/metasec-350101-req01-baseline.sh
```

它从 `dyidre`/真机侧继承这些东西：

| 输入 | 来源 |
|---|---|
| `s1/s2` | 真机 request01，已复制到 `unidbg-android/src/test/resources/metasec/350101/` |
| rootfs/app files | `dyidre/runs/<version>/true_env_xmedusa/<timestamp>/` 采集后同步 |
| fixed pid/tid/time/random | `baseline.properties` 和 true-env summary |
| `MS.b` 行为 | jnitrace + true-env + unidbg stub |
| 函数 offset/profile | IDA + GumTrace + dyidre 报告 |

unidbg 输出再反哺 `dyidre`：

| 输出 | 用途 |
|---|---|
| one-request count | 判断路径是否和真机一致 |
| `exeVMInner.vmCode` / LR 分布 | 判断 native VM 是否走同一路 |
| managed program dump | decode F5/F7/F8/F13 和 source-work family |
| CF/slot/watch log | 还原 CF helper 和 buffer 写入来源 |
| deterministic header | C oracle 的验收目标 |

## 3. eDBG / stackplz：硬断点和栈辅助

eDBG/stackplz 用在 rustFrida 不够干净、不够准、或开销太大时。

主要作用：

- 对少数地址下硬件断点；
- 对关键 buffer 下 watch/rwatch；
- 采调用栈，确认“谁写了这个字段”；
- 避免 full trace 刷屏。
- 弥补 RF inline hook 对“相邻基本块内部指令”不稳定的问题。

当前不是主链路，因为 350101 的大部分路径已经通过 rustFrida + unidbg 对齐。但它适合后续追：

```text
X-Medusa decoded[0x18] 这类单字节差异来源
某个 ctx field 第一次被谁写
某个 CF helper 的真实调用者
```

和 RF 的推荐配合：

```text
RF JS 找到 module base / offset / buffer 地址
  -> stackplz 按 module+offset 下硬件执行断点，看 regs+stack
  -> eDBG 在命中后读寄存器、读指针内容、对字段下 watch/rwatch
  -> 结果归档到 runs/<version>/edbg_stackplz/<run_id>/
```

不要用 eDBG/stackplz 做 full trace；它们的价值是“少数精确点位 + 调用栈 + 字段写入来源”。

350101 的 `branch` probe 默认只挂稳定阶段点；如果要追 `0x14A250` 这种单条分支指令，优先走这里的 eDBG/stackplz 路线。

相关文档：

```text
dyidre/versions/350101/edbg_assist_plan_350101.md
dyidre/versions/350101/stackplz_rf_rpc_bridge_350101.md
```

## 4. IDA：把证据变成可读工程

IDA 负责沉淀命名、原型、结构体和注释。

推荐只把三类信息写入 IDA：

- runtime trace 证明过的；
- unidbg replay 证明过的；
- 静态 xref/结构访问能解释的。

当前落库入口：

```text
dyidre/skills/ida_apply_metasec_struct_evidence.py
dyidre/versions/350101/metasec_structs_350_all.h
dyidre/versions/350101/ida_rename_update_350101_20260831.md
```

## 5. C oracle：算法验收

C oracle 是最终从“看懂”走向“还原”的验收层。

当前关键入口：

```text
dyidre/versions/350101/run_recovered_c_oracles_350101.sh
dyidre/versions/350101/metasec_350101_fixed_signer.c
dyidre/versions/350101/x_headers_algorithms_350101.c
```

判断标准：

- 单个 CF/helper oracle：`failures=0`；
- fixed signer：固定 `s1/s2/env/random/time` 后，和 unidbg deterministic baseline 完全一致；
- 新版本升级时，先不追求完整 C，还原到能解释当前差异即可。

## 最重要的约束

不要把 fixed baseline 里的环境值误认为算法常量。

例如时间、随机、pid/tid、`.msdata`、`MS.b` 返回、rootfs 文件内容，都是“真机约束”。这些值必须能回指到真机采集目录或 baseline properties。

## 提交前材料同步

每次提交前，除了代码、文档、unidbg baseline，也要同步分析材料本体。推荐安装 pre-commit hook 自动做：

```bash
cd /Users/freeman/project/douyin
git init
dyidre/scripts/install_pre_commit_hook.sh
```

安装后每次 `git commit` 会读取：

```text
dyidre/materials/materials_sources.tsv
```

并自动把 `.apk/.so/.i64/materials_manifest.md` 同步、`git add` 到本次提交。

手动同步命令仍然保留：

```bash
cd /Users/freeman/project/douyin
dyidre/scripts/sync_metasec_materials.sh 350101 \
  douyin_35_0_0/libmetasec_ml.so \
  douyin_35_0_0/libmetasec_ml.so.i64 \
  douyin_35_0_0/dy351_vivo.apk
```

这个命令会复制 `.apk/.so/.i64` 到 `dyidre/materials/<version>/`，然后更新 manifest。尤其是 IDA 里改过函数名、结构体、原型、中文注释后，必须保存 `.i64` 并重新跑一次。

提交前可以用 check 模式防止忘记更新：

```bash
dyidre/scripts/update_materials_manifest.sh --check \
  --apk dyidre/materials/350101/source.apk \
  350101 \
  dyidre/materials/350101/libmetasec_ml.so \
  dyidre/materials/350101/libmetasec_ml.so.i64
```

完整清单看：

```text
dyidre/docs/pre-commit-checklist.md
dyidre/materials/README.md
```
