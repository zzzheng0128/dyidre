# StackPlz + rustFrida RPC 联动记录（350.101）

日期：2026-08-31

## 结论

StackPlz 的 Frida RPC 联动模式可以接到 rustFrida 上跑通。

这里的“RPC”不是 StackPlz 直接接 RF 的 HTTP RPC，而是两段链路：

1. rustFrida 负责 spawn/注入目标，并暴露 `rpc.exports` 到本机 HTTP：`POST /rpc/0/<method>`。
2. 目标进程里的 RF JS 通过 libc `socket/connect/write/read` 连接 StackPlz RPC server：`127.0.0.1:41718`。
3. StackPlz 收到 JSON 后注册硬件断点，命中时输出寄存器和堆栈。

本地旧版 `stackplz/` 没有 `--rpc/--rpc-path`；这个功能在 `origin/dev`。

## 使用到的组件

- StackPlz dev worktree：`stackplz_dev/`
- 设备二进制：`/data/local/tmp/stackplz_dev`
- StackPlz RPC runner：`dyidre/probes/350101/run_stackplz_hwbrk_rpc.sh`
- rustFrida 统一 probe：`dyidre/probes/350101/metasec_probe_350101.js`
- RF 兼容 StackPlz 桥：`mode=stackplz-bridge`

## 启动方式

先启动 RF：

```bash
dyidre/probes/350101/run_metasec_probe_350101.sh rpc
```

注意：`su -c` 必须整体放在 adb shell 的同一层引号里，否则分号后的命令可能不是 root 跑，RF 读 zygote `/proc/<pid>/maps` 会失败。

RF 注入成功后可以切回 Enforcing，RPC 仍可用：

```bash
adb shell "su -c 'setenforce 1'"
```

启动 StackPlz RPC server：

```bash
adb shell "su -c '/data/local/tmp/run_stackplz_hwbrk_rpc.sh <timestamp> 41718'"
```

把桥脚本装进当前 RF session：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobeinstall \
  -H 'Content-Type: application/json' \
  -d '["stackplz-bridge"]'
```

下硬件执行断点：

```bash
curl -X POST http://127.0.0.1:19191/rpc/0/stackplzbreakmodule \
  -H 'Content-Type: application/json' \
  -d '["libmetasec_ml.so","0x4cc10","x",29967,4,41718]'
```

## 本次验证样本

当前安装包：

- `versionCode=350101`
- `versionName=35.1.0`
- `primaryCpuAbi=arm64-v8a`

RF session：

- pid：`29967`
- `libmetasec_ml.so` base：`0x7102a16000`
- path：`/data/app/~~GJKKQPtkpHqhegsADfD9mQ==/com.ss.android.ugc.aweme-vsHSySl5UaKL1lfqkWR0ag==/lib/arm64/libmetasec_ml.so`

通过 RF RPC 下发断点：

```json
{
  "brk_pid": 29967,
  "brk_len": 4,
  "brk_type": "x",
  "brk_addr": "0x7102a62c10"
}
```

也就是：

```text
libmetasec_ml.so + 0x4cc10
```

StackPlz 返回：

```json
{"status":"ok","msg":"register breakpoint success"}
```

命中 4 次，稳定线程：

```text
pid=29967 tid=30109
event_addr = base + 0x4cc10
lr         = base + 0x124e34
```

关键回溯：

```text
libmetasec_ml.so + 0x4cc10
libmetasec_ml.so + 0x124e34
libmetasec_ml.so + 0x1256ac
libmetasec_ml.so + 0x16f2e0
libmetasec_ml.so + 0x15ab44
libmetasec_ml.so + 0x1570f0
libmetasec_ml.so + 0x154598
libmetasec_ml.so + 0x154460
libmetasec_ml.so + 0x171770
libmetasec_ml.so + 0x151a4c
libmetasec_ml.so + 0x151030
libmetasec_ml.so + 0x14e764
libmetasec_ml.so + 0x14ea6c
libsscronet.so    + 0x4a5ad4
libsscronet.so    + 0x20c09c
libsscronet.so    + 0x2110c8
libsscronet.so    + 0x2e6e58
libsscronet.so    + 0x2f4eb0
libsscronet.so    + 0x323d24
```

这条链能说明：当前网络请求路径从 `libsscronet.so` 进入 `libmetasec_ml.so`，再进入 `0x124e34` 一带，最终调用 `0x4cc10` 这个 VM/native 内层入口。

## 现象：0x149ca8 没命中

同一 RF/StackPlz 链路下，`libmetasec_ml.so + 0x149ca8` 注册成功，但本次滑动触发期间没有命中。

这不是桥接失败，因为 `0x4cc10` 已命中。更像是：

- 当前安装的 350.101 HTTP 路径实际没有走到这个精确地址；
- 或 `0x149ca8` 是另一个分支/另一个触发条件；
- 或当前要对标的入口应重新以真机栈上的 `0x15ab44/0x15abxx` 为锚再回溯。

## 对后续分析的用途

StackPlz RPC 模式适合用来回答：

- 谁调用了 `exeVMInner/0x4cc10`；
- 某个候选函数到底是否在真机请求链中；
- LR/调用栈是否和 unidbg trace 对得上；
- 不想让 eDBG/BRK 暂停目标时，用它做低干扰采样。

它不适合直接替代 eDBG 的停点读内存，因为 StackPlz 是采样输出，不会把目标停住给我们读 X0 指向的大块结构。结构体内容仍然要配合 RF `Interceptor`/unidbg/eDBG watch 来补。
