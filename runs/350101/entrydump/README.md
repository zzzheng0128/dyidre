# 350101 entrydump runs

这里放 HTTP/sign 入口 ABI 采集，主要看 `x0~x5/x8` 和指针窗口。

| 批次 | 说明 |
|---|---|
| `20260830_200206_gumtrace` | GumTrace entrydump 早期批次。 |
| `20260830_200700_gumtrace` | GumTrace entrydump 迭代批次。 |
| `20260830_201359_gumtrace` | GumTrace entrydump 迭代批次。 |
| `20260830_201638_entrydump_only` | 只保留入口 dump 的轻量批次。 |
| `20260830_201913_wrapper` | wrapper/callback 入口 dump，用于修正结构推断。 |

被结构推断脚本引用的主证据：

```text
runs/350101/entrydump/20260830_201913_wrapper/rf_gumtrace_entrydump_350101.wrapper_entrydump.txt
```
