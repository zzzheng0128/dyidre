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
dyidre/versions/350101/
dyidre/docs/350101-file-catalog.md
unidbg/unidbg-android/src/test/resources/metasec/350101/
unidbg/scripts/metasec-350101-req01-baseline.sh
```

后面如果新增同版本其它采集，放同级：

```text
runs/350101/jnitrace/<timestamp>/
runs/350101/entrydump/<timestamp>/
runs/350101/gumtrace/<timestamp>/
```
