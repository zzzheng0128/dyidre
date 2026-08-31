# 350101 gumtrace runs

这里放真机 GumTrace / PC trace 证据。

| 批次 | 说明 |
|---|---|
| `20260829_1165b8` | 早期 `0x1165b8` trace。 |
| `20260829_4cc10` | `exeVMInner @ 0x4CC10` trace，包含 `.vmtrace.asm`，用于和 `vm64.cpp/mm64.cpp` 对齐。 |

脚本入口：

```text
dyidre/probes/350101/metasec_probe_350101.js
dyidre/probes/350101/run_metasec_probe_350101.sh gum-exevm 90 <run_id>
dyidre/probes/350101/run_metasec_probe_350101.sh gum-http 90 <run_id>
```
