# dyidre runs

这里放真机采集批次。目录按版本号优先组织，后面加新版本时不要再把批次散在 `dyidre/` 顶层。

标准结构：

```text
dyidre/runs/<version>/<run_kind>/<run_id>/
```

当前版本：

```text
dyidre/runs/350101/
```

`run_kind` 建议固定成少数几类：

| run_kind | 用途 |
|---|---|
| `true_env_xmedusa` | 真机环境、F8/X-Medusa、`.msdata`/App files 对齐 |
| `jnitrace` | JNI 调用、`MS.b`、FindClass/NewString 等环境补齐 |
| `entrydump` | HTTP/sign 入口 ABI、`x0~x5/x8` 指针内容 |
| `gumtrace` | PC 序列、VM 入口、handler 路径 |
| `edbg_stackplz` | 硬件断点、watch/rwatch、调用栈辅助 |

版本目录和 unidbg 的对应关系：

```text
dyidre/runs/<version>/...
unidbg/unidbg-android/src/test/resources/metasec/<version>/...
unidbg/scripts/metasec-<version>-req01-baseline.sh
dyidre/versions/<version>/...
```

原则很简单：真机证据放 `runs/<version>`，分析结论放 `versions/<version>`，可复跑基准放 `unidbg/.../resources/metasec/<version>`。
