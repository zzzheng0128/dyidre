# dyidre versions

这里放 MetaSec 不同版本的分析入口。

当前：

```text
dyidre/versions/350101/
```

后续新版本建议：

```text
dyidre/versions/334000/
dyidre/versions/350101/
dyidre/versions/370401/
```

真机采集批次不要放在 `versions/` 里，放到：

```text
dyidre/runs/<version>/<run_kind>/<run_id>/
```

每个版本目录至少包含：

- `README.md`：版本入口；
- `metasec_so_identity.md`：SO 身份；
- `analysis_trajectory_<version>.md` 或链接到 `dyidre/docs/metasec-analysis-trajectory.md`：该版本按主轨迹走到哪一步；
- `entrydump_compare.md`：真机/unidbg 入参对比；
- `x_headers_generation_<version>.md`：X-header 生成链路；
- `managed_vm_recovery_<version>.md`：managed VM；
- `exeVMInner_x_headers_<version>.md`：native VM；
- `metasec_structs_<version>_all.h`：结构体；
- `algorithm_validation_<version>.md`：验收结果。
