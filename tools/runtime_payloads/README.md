# runtime payloads

这些文件来自历史真机调试批次，已经提升为 dyidre 正式工具材料。它们用 Git LFS 提交，clone 后如果看到的是 LFS pointer，先执行：

```bash
git lfs pull
```

## 文件清单

| 文件 | 大小 | SHA-256 | 用途 |
|---|---:|---|---|
| `rustfrida` | 13,850,248 | `6e8f15d59c77c4db793cc85caab0e390c743e00dadf753f5881d4a28229ed91a` | 设备侧 RF 主程序，`probes/*/run_metasec_probe_*.sh` 默认调用 `/data/local/tmp/rustfrida`。 |
| `wxshadow.kpm` | 157,200 | `05999fa2d37a91dce30e9accb1e5c72f4d8d106b165ec1b5915244775d2d97a1` | wxshadow 内核侧辅助模块，配合低痕 Java hook / ArtMethod 相关采集。 |
| `hide-so.kpm` | 114,848 | `60e1fc39f32d0d6d8b4dcf2e9a8cf04f7fd3bdee899914d53e115c08134b9d3d` | maps 隐藏/收敛辅助模块，排查注入检测面时使用。 |
| `embed1.so` | 10,392 | `2d54faae3e8aba7683cb09a332a27ac05e5273d8182d4b17ebec13671967ae84` | rustFrida embed payload，调 RF 启动链路时保留。 |
| `embed2.so` | 4,022,584 | `e6ec011c9b6abbcb5789a57cc48af77bab3694e6d31b11ab35846bd8f472004d` | rustFrida embed payload，调 RF 启动链路时保留。 |
| `embed3.so` | 6,133,648 | `c624fcab767782445af34c958b0caa48f5a52c189d0e17c20785cc090aa47d63` | rustFrida embed payload，调 RF 启动链路时保留。 |

## 最小检查

```bash
shasum -a 256 tools/runtime_payloads/*
file tools/runtime_payloads/rustfrida
```

`rustfrida` 应该有可执行权限：

```bash
chmod 755 tools/runtime_payloads/rustfrida
```

## 推送到设备

```bash
adb push tools/runtime_payloads/rustfrida /data/local/tmp/rustfrida
adb shell "su -c 'chmod 755 /data/local/tmp/rustfrida'"
```

KPM 按需推送：

```bash
adb push tools/runtime_payloads/wxshadow.kpm /data/local/tmp/wxshadow.kpm
adb push tools/runtime_payloads/hide-so.kpm /data/local/tmp/hide-so.kpm
```

## 什么时候更新这些文件

只在下面几种情况替换：

- rustFrida 自身修复了 spawn/attach/RPC/inline hook 稳定性；
- KPM 适配了新内核或修复加载失败；
- embed payload 和 RF 主程序版本不匹配；
- 真机采集报告明确证明旧 payload 会影响 maps、ArtMethod、线程或 header 值。

替换后必须同步更新：

- 本 README 的大小和 SHA-256；
- `docs/toolchain.md` 中工具说明；
- 相关 run 目录 README，写明使用了哪个 payload hash。
