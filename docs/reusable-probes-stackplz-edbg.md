# Frida/RF JS、stackplz、eDBG 复用手册

这份文档的目标很简单：后续升级 `libmetasec_ml.so` 时，优先复用统一 probe，不再复制一堆半成品 JS。

350101 当前唯一用户入口：

```text
dyidre/probes/350101/metasec_probe_350101.js
dyidre/probes/350101/run_metasec_probe_350101.sh
```

## 一句话分工

| 工具 | 最适合回答的问题 | 不适合做什么 |
|---|---|---|
| rustFrida / Frida JS | 入参是什么、指针指向什么、哪个 header 被写出、JNI 返回了什么 | 长时间大范围逐指令 trace |
| GumTrace mode | 某个入口真实走过哪些 PC、VM handler/dispatch 路径是否一致 | 结构字段命名和环境补齐 |
| stackplz | 少数地址的硬件断点、寄存器、调用栈采样 | 大块内存 dump、复杂脚本逻辑 |
| eDBG | 硬断点/watch/rwatch、停住后读寄存器/内存/栈 | 日常 full trace |
| unidbg | 固定 `s1/s2/env` 后可重复复现、做回归 | 替代真机猜环境 |

正确姿势：

```text
RF/Frida mode 找地址和值
  -> stackplz/eDBG 盯“谁调用/谁写”
  -> unidbg 固定复现
  -> dyidre 写报告和 C oracle
  -> IDA 落名称/结构/中文注释
```

## 统一 JS mode

统一 JS 里保留的是已验证过的功能区块。使用时选 mode，不再手选多个 JS 文件。

| mode | 用途 | 什么时候先用 |
|---|---|---|
| `rpc` | 开 RF HTTP RPC 常驻，后续可动态安装其他 mode | 要反复注入 counter/branch/stackplz bridge |
| `counter-one` | 单请求计数：关键函数命中次数、`exeVMInner` 次数、LR/vmCode/CF 统计 | 先确认“一条请求”路径 |
| `counter-multi` | 多请求稳定性计数 | 单请求稳定后，看滑动/多 URL 是否分叉 |
| `true-env` | 抓真机环境、F8/X-Medusa 入参、时间/随机、emit 前后值 | unidbg 和真机 header 值不一致 |
| `jnitrace` | WXSHADOW lite JNI 采集：`FindClass/NewString/GetStringUTFChars/MS.b` 等 | unidbg 缺 Java/env/stub |
| `xheader` | 最终 `TreeMap`/header put 的 key/value dump | F8 输出和最终 header 对不上 |
| `branch` | CF/branch 值级探针；默认只挂安全阶段点 | raw PC 有差但 managed/CF 路径疑似一致 |
| `native-vmp` | native VMP `0x12564c -> 0x124dd4 -> 0x4cc10(vmCode=0x1f7860)` 局部验证 | 追 native material/key 派生 |
| `gum-exevm` | GumTrace `exeVMInner + 0x4cc10` | 要确认 native VM handler/dispatch 主线 |
| `gum-http` | GumTrace HTTP/sign inner `+0x149ca8` 和 wrapper `+0x14dbf4` | 要确认 HTTP/sign 入口 raw PC 主线 |
| `artcheck` | ArtMethod/maps 检测面检查 | 怀疑注入污染 maps 或 Java method |
| `stackplz-bridge` | RF -> stackplz RPC bridge | 需要 stackplz 按 `module+offset` 下硬断点/watch |

经验规则：

- 能用 `counter-one` 看清楚的，不开 GumTrace。
- 值不一致优先 `true-env`/`xheader`/`branch`，不要先追 raw helper。
- 只差一个字段或 byte 时，用 stackplz/eDBG watch，不跑大 trace。
- 新版本保留旧版本目录，复制后改 offset。
- RF inline hook 不适合密集挂基本块内部相邻指令；`branch` 默认跳过这类深度点。要追单条分支或字段写入，用 stackplz/eDBG 硬断点/watch。

## 统一 runner

Host 上运行：

```bash
cd /Users/freeman/project/douyin
dyidre/probes/350101/run_metasec_probe_350101.sh <mode> [seconds] [tag]
```

例子：

```bash
dyidre/probes/350101/run_metasec_probe_350101.sh counter-one 60 req01_count
dyidre/probes/350101/run_metasec_probe_350101.sh true-env 90 req01_env
dyidre/probes/350101/run_metasec_probe_350101.sh jnitrace 180 jni01
dyidre/probes/350101/run_metasec_probe_350101.sh gum-exevm 90 gum4cc10
```

输出自动归档：

| mode | 输出目录 |
|---|---|
| `true-env` | `dyidre/runs/350101/true_env_xmedusa/<tag>/` |
| `jnitrace` | `dyidre/runs/350101/jnitrace/<tag>/` |
| `gum-exevm` / `gum-http` | `dyidre/runs/350101/gumtrace/<tag>/` |
| `artcheck` | `dyidre/runs/350101/maps_artmethod/<tag>/` |
| `stackplz-bridge` | `dyidre/runs/350101/edbg_stackplz/<tag>/` |
| 其他 | `dyidre/runs/350101/entrydump/<tag>/` |

每个 run 目录至少有：

```text
README.md
runtime_<mode>.js
rustfrida_console.log
```

`counter-one` / `counter-multi` / `branch` 会临时打开 RF RPC，runner 在结束前自动拉一次 summary：

```text
metacountsummary.json
metamultisummary.json
metabranchsummary.json
```

`true-env` 模式会额外拉回并解析：

```text
true_env_xmedusa_350101.log
true_env_xmedusa_summary.json
f8_*.bin
xmedusa_*.raw.bin / *.b64
```

## RPC 模式

启动 RF RPC：

```bash
dyidre/probes/350101/run_metasec_probe_350101.sh rpc
```

检查：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobeinfo \
  -H 'Content-Type: application/json' \
  -d '[]'
```

查看 mode：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobemodes \
  -H 'Content-Type: application/json' \
  -d '[]'
```

动态安装一个 mode：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobeinstall \
  -H 'Content-Type: application/json' \
  -d '["counter-one"]'
```

安装后常用 RPC：

| mode | RPC |
|---|---|
| `counter-one` | `metacountreset` / `metacountsummary` / `metacountstop` |
| `counter-multi` | `metamultistart` / `metamultisummary` / `metamultistop` |
| `branch` | `metabranchreset` / `metabranchsummary` / `metabranchstop` |
| `stackplz-bridge` | `stackplzmodule` / `stackplzset` / `stackplzbreakmodule` |

## RF + stackplz

这个链路用来做“少数地址硬断点 + 栈采样”。

```text
host curl
  -> rustFrida HTTP RPC :19191
  -> metasec_probe_350101.js mode=stackplz-bridge
  -> stackplz RPC :41718
  -> stackplz 注册硬件断点并输出 regs/stack
```

启动 RF RPC：

```bash
dyidre/probes/350101/run_metasec_probe_350101.sh rpc
```

启动 stackplz RPC：

```bash
adb push dyidre/probes/350101/run_stackplz_hwbrk_rpc.sh /data/local/tmp/
adb shell "su -c 'chmod +x /data/local/tmp/run_stackplz_hwbrk_rpc.sh'"
adb shell "su -c '/data/local/tmp/run_stackplz_hwbrk_rpc.sh req01 41718'"
```

安装 bridge：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobeinstall \
  -H 'Content-Type: application/json' \
  -d '["stackplz-bridge"]'
```

按 `module + offset` 下执行断点：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/stackplzbreakmodule \
  -H 'Content-Type: application/json' \
  -d '["libmetasec_ml.so","0x4cc10","x",-1,4,41718]'
```

参数含义：

| 参数 | 含义 |
|---|---|
| `"libmetasec_ml.so"` | RF 用它找模块 base |
| `"0x4cc10"` | IDA/ELF 相对 offset |
| `"x"` | 执行断点；也可以是 `r`、`w`、`rw` |
| `-1` | 不限制 pid/tid；稳定后可以换成具体 pid |
| `4` | watch 长度或执行断点长度 |
| `41718` | stackplz RPC 端口 |

日志在设备：

```text
/data/local/tmp/stackplz_hwbrk_rf_req01.log
/data/local/tmp/stackplz_hwbrk_rf_req01.console
```

拉回后放：

```text
dyidre/runs/350101/edbg_stackplz/<run_id>/
```

350101 已实测链路：

```text
RF stackplz-bridge -> stackplz_dev --rpc -> stackplzbreakmodule(libmetasec_ml.so, +0x4cc10)
```

成功标志：

```text
register breakpoint success
event_addr = libmetasec_ml.so + 0x4cc10
Backtrace 里能看到 0x1716d0 -> 0x14a4e4 -> 0x14dcf4 一类签名路径
```

## standalone stackplz

如果已经知道 App uid 和 so 绝对路径，可以不用 RF bridge：

```bash
adb push dyidre/probes/350101/run_stackplz_offset_test.sh /data/local/tmp/
adb shell "su -c 'chmod +x /data/local/tmp/run_stackplz_offset_test.sh'"
adb shell "su -c '/data/local/tmp/run_stackplz_offset_test.sh <uid> <absolute-lib-path> 0x4cc10 req01_4cc10'"
```

适合验证“这个 offset 是否会命中”。缺点是要知道 uid 和设备上的真实 so 路径。

## RF + eDBG

eDBG 更像“会停住的外科刀”。推荐流程：

```text
1. mode=rpc 或 counter-one 确认 libmetasec_ml.so base、候选 offset、pid/tid。
2. eDBG attach package/library。
3. eDBG 对 offset 下 break/hbreak。
4. 命中后 info_register + examine x0/x1/x2/x8。
5. 算出字段绝对地址后 watch/rwatch。
6. stack、regs、memory dump 归档到 runs/<version>/edbg_stackplz/<run_id>/。
```

MCP/CLI 参考：

```text
attach(package="com.ss.android.ugc.aweme", library="libmetasec_ml.so")
hbreak(address="0x149ca8")
continue(timeout_ms=60000)
info_register()
backtrace(mode="unwind")
examine("x0", "0x100")
```

追 `X-Medusa decoded[0x18]` 这类问题时，不要 full trace：

```text
mode=true-env 拿 F8 输出 buffer 地址/长度
  -> eDBG/stackplz watch 目标 buffer 或 work-area qword
  -> 命中后看 LR/stack/regs
  -> 回到 IDA/unidbg 对应 CF/F 程序
```

注意：

- 硬件 watch slot 很少，一次只盯一两个高价值字段。
- eDBG 停住进程后，超时要确保 `continue` 或 `cancel_run`，不要把 App 卡死。
- Pixel 6 这类 5.10+/6.x 内核更适合 eDBG；Pixel 5 的 4.14/4.19 先用 stackplz/RF。

## 新版本升级复用模板

以 `370401` 为例：

```bash
cp -R dyidre/probes/350101 dyidre/probes/370401
mkdir -p dyidre/runs/370401/{entrydump,gumtrace,jnitrace,true_env_xmedusa,edbg_stackplz,control}
mkdir -p dyidre/versions/370401
```

然后修改：

| 位置 | 要改什么 |
|---|---|
| `probes/370401/metasec_probe_370401.js` | 版本号、offset 表、GumTrace 输出名 |
| `probes/370401/run_metasec_probe_370401.sh` | `VERSION`、脚本名、输出路径 |
| `probes/370401/README.md` | 新版本 mode、已确认 offset |
| `unidbg` profile | `MetaSecProfile.v<version>()`、SO/APK/rootfs/resource |

每个新 run 目录都要有 README，写清：

```text
设备 / 包版本 / SO hash / mode / 命令 / 触发动作 / 产物 / 结论 / 是否作为基准
```

## 什么时候不用哪个工具

| 情况 | 不建议 | 建议 |
|---|---|---|
| 只想确认一条请求调用次数 | full GumTrace | `mode=counter-one` |
| 只差一个 byte/field | 长时间 jnitrace | `mode=true-env` + eDBG/stackplz watch |
| raw PC helper 有差但能 resync | 继续追 helper | `mode=branch` / `mode=xheader` |
| unidbg header 不一致 | 先改算法 | 先同步真机 `s1/s2/env/MS.b/.msdata` |
| 新版本入口不确定 | 套旧 offset | SO identity + RF entrydump + stackplz 命中确认 |

## 350101 已验证链路

- 统一 RF JS mode 可以覆盖原先成熟的 counter/true-env/jnitrace/xheader/branch/native-vmp/gumtrace/stackplz bridge。
- RF RPC 常驻后，可以用 `metaprobeinstall(mode)` 动态装探针。
- RF bridge 调 stackplz RPC 下硬件断点，已命中过 `libmetasec_ml.so + 0x4cc10` 并输出 `regs + stack`。
- `branch` mode 已修成延迟安装 + 默认安全点；基本块内部精确分支点改用 stackplz/eDBG。
- unidbg 固定基准可以接收 dyidre 的 `s1/s2/env/rootfs`。

历史细节见：

```text
dyidre/versions/350101/stackplz_rf_rpc_bridge_350101.md
dyidre/versions/350101/edbg_assist_plan_350101.md
```
