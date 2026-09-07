# dyidre 版本目录规范

后续升级版本时，目录优先按版本号分层。不要把版本号只写在文件名里，否则一多版本并行就很难知道哪个日志属于哪个基准。

## 版本号怎么写

用 manifest/code version 作为主版本目录名，例如：

```text
350101
370401
```

如果只有 App 版本名，先在版本 README 里写清楚映射：

```text
Douyin 35.1.0 -> 350101
Douyin 37.4.0 -> 370401
```

不要混用 `350`、`35.0.0`、`350101` 当目录主键。`350` 可以作为函数名/脚本名里的短别名，但目录层级用完整版本号。

## 标准目录

```text
./
  versions/<version>/                 # 该版本的分析结论入口
  runs/<version>/<run_kind>/<run_id>/  # 该版本的真机采集证据
  probes/<version>/                    # 该版本的真机采集脚本
  probes/common/                       # 跨版本辅助脚本
  tools/                               # 设备侧 RF/KPM/embed payload
  docs/                               # 跨版本说明和升级流程

../unidbg/
  unidbg-android/src/test/resources/metasec/<version>/  # 该版本固定基准输入
  scripts/metasec-<version>-req01-baseline.sh            # 该版本回归脚本
```

当前 350101：

```text
metasec_350101_01/
materials/350101/source.apk
materials/350101/libmetasec_ml.so
materials/350101/libmetasec_ml.so.i64
runs/350101/true_env_xmedusa/latest -> 20260831_214509
probes/350101/
../unidbg/unidbg-android/src/test/resources/metasec/350101/
```

## 新版本最小骨架

新增 `<version>` 时，先建这些：

```text
versions/<version>/README.md
versions/<version>/metasec_so_identity.md
runs/<version>/README.md
runs/<version>/true_env_xmedusa/
probes/<version>/README.md
../unidbg/unidbg-android/src/test/resources/metasec/<version>/README.md
```

然后再补：

```text
entrydump_compare.md
x_headers_generation_<version>.md
managed_vm_recovery_<version>.md
exeVMInner_x_headers_<version>.md
algorithm_validation_<version>.md
```

## 批次命名

`run_id` 用时间戳：

```text
YYYYMMDD_HHMMSS
```

例如：

```text
runs/350101/true_env_xmedusa/20260831_214509/
```

每类采集下可以有一个 `latest` 符号链接，指向当前推荐基准：

```text
runs/350101/true_env_xmedusa/latest -> 20260831_214509
```

## 文件归属规则

| 文件类型 | 放哪里 |
|---|---|
| 真机原始日志、console、dump、bin、b64、tar | `runs/<version>/<run_kind>/<run_id>/` |
| 分析结论、结构体、C oracle、VM decode | `versions/<version>/` |
| 跨版本流程、工具链说明 | `docs/` |
| 设备侧工具/payload | `tools/` |
| unidbg 固定输入和 expected 值 | `unidbg/unidbg-android/src/test/resources/metasec/<version>/` |
| unidbg 一键回归脚本 | `unidbg/scripts/metasec-<version>-*.sh` |

一句话：`runs` 放证据，`versions` 放结论，`unidbg resources` 放可复跑输入。
