# dyidre probes

这里放可复用的真机采集脚本。根目录不再直接堆 `.js/.sh/.py`，避免版本一多就看不清。

目录规则：

```text
dyidre/probes/<version>/   # 某个 MetaSec 版本的 offset/ABI 相关脚本
dyidre/probes/common/      # 与版本无关的辅助脚本
```

脚本只负责采集或启动采集；采集结果必须放到：

```text
dyidre/runs/<version>/<run_kind>/<timestamp>/
```

当前 350101 脚本在：

```text
dyidre/probes/350101/
```

Frida/RF JS、stackplz、eDBG 的组合用法看：

```text
dyidre/docs/reusable-probes-stackplz-edbg.md
```

新增版本时优先复制旧版本目录，改 offset 和输出路径；不要把新脚本散放到 `dyidre/` 根目录。
