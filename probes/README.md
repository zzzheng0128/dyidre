# dyidre probes

这里放可复用的真机采集脚本。根目录不再直接堆 `.js/.sh/.py`，避免版本一多就看不清。

目录规则：

```text
probes/<version>/   # 某个 MetaSec 版本的 offset/ABI 相关脚本
probes/common/      # 与版本无关的辅助脚本
```

脚本只负责采集或启动采集；采集结果必须放到：

```text
runs/<version>/<run_kind>/latest/
```

只有显式设置 `KEEP_HISTORY=1` 时才使用带 tag 的历史目录。

当前 350101 脚本在：

```text
probes/350101/
```

日常只需要一个入口完成“检查设备 → 推送 rustfrida → 设置代理 → 清理并 spawn →
安全处理弹窗 → 保存本地 mitm 样本”，直接使用：

```text
probes/350101/run_rf_mitm_auto_350101.sh
```

具体参数、失败条件和产物说明见 `probes/350101/README.md` 的“一键 RF +
mitmproxy 样本采集”章节。

eCapture、stackplz、eDBG 仅在专项定位时使用，不是日常抓包入口；相关脚本仍保留
在版本目录，避免为常规采集再维护多套流程。

Frida/RF JS、eCapture、stackplz、eDBG 的组合用法看：

```text
docs/reusable-probes-stackplz-edbg.md
```

新增版本时优先复制旧版本目录，改 offset 和输出路径；不要把新脚本散放到仓库根目录。

输出保留规则：

- `smoke*`、`dry*`、`regression*` 只用于本地分析/冒烟，自测可以生成，但不会上传；
- 固定功能的正式采集使用稳定的 `latest/`，每次正式运行开始前清理同类旧日期目录；
- 需要做版本差异对比时，显式设置 `KEEP_HISTORY=1`，否则不要自行保留日期副本。
