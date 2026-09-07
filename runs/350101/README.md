# 350101 runs

这里是 Douyin 35.1.0 / manifest `350101` 的真机采集批次。

当前主线：

```text
true_env_xmedusa/latest -> 20260831_214509
```

这批 `214509` 是当前 unidbg baseline 的真机来源之一，用来固定：

- F8/X-Medusa 输入输出；
- process/thread/time/random 约束；
- App 私有文件快照和 rootfs manifest；
- `buildSignedHttpHeadersInner_350`、F8、emit 关键点的入参形态。

相关入口：

```text
dyidre/metasec_350101_01/
dyidre/docs/350101-file-catalog.md
unidbg/unidbg-android/src/test/resources/metasec/350101/
unidbg/scripts/metasec-350101-req01-baseline.sh
```

其它类型的历史采集不作为日常入口；需要复核时再按 `metasec_350101_01` 文档中的路径取证。

当前网络样本入口（唯一默认运行产物）：

```text
runs/350101/mitm/latest/
```

由一键脚本生成：

```bash
probes/350101/run_rf_mitm_auto_350101.sh 180 req01
```

脚本默认在新一轮开始前清理旧的 `mitm` 批次并写入 `latest/`，因此日常只会保留最新一份。需要历史对比时设置 `KEEP_HISTORY=1`，才按 tag 另存。

`smoke*`、`dry*`、`regression*` 目录即使在分析过程中生成，也属于本地临时产物，已由仓库忽略规则排除，不作为上传内容。固定功能不要再按日期堆目录；直接复跑脚本覆盖 `latest/`。

只有在做专项逆向时，才按版本文档临时创建其它分析目录：

```text
runs/350101/jnitrace/latest/
runs/350101/entrydump/latest/
runs/350101/gumtrace/latest/
```

统一 runner 默认会覆盖对应类型的 `latest/` 并清理旧日期目录；只有设置
`KEEP_HISTORY=1` 才按 tag 另存。分析中的 `smoke*`、`dry*`、`regression*`
目录仅供本地临时使用，已被 Git 忽略，不作为上传内容。
