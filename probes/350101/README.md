# 350101 probe 使用手册

这里只保留 Douyin `350101` 已跑通、后续还能复用的入口。旧的单功能 JS 已经合并进 `metasec_probe_350101.js`，避免接手的人在一堆相似脚本里选错。

通用工具链说明：

```text
dyidre/docs/metasec-analysis-trajectory.md
dyidre/docs/reusable-probes-stackplz-edbg.md
```

如果不知道该先跑哪个 mode，先看 `metasec-analysis-trajectory.md` 的“第 3 步：抓一条真机基准请求”和“第 7 步：再追值级差异”。

## 当前保留文件

| 文件 | 作用 | 谁来执行 |
|---|---|---|
| `metasec_probe_350101.js` | 统一 Frida/rustFrida JS。通过 `mode` 选择 counter、true-env、jnitrace、gumtrace、stackplz bridge 等功能 | rustFrida |
| `run_metasec_probe_350101.sh` | 统一 host runner。自动生成带 mode 的 runtime JS、推送、spawn、归档输出 | macOS host |
| `run_rf_rpc_persistent.sh` | 设备侧 RF RPC 常驻 runner。被 `mode=rpc` 使用，也可手工用 | Android device |
| `run_stackplz_hwbrk_rpc.sh` | 设备侧 stackplz dev RPC runner | Android device |
| `run_stackplz_offset_test.sh` | 设备侧 stackplz standalone offset 栈采样 | Android device |

## 先用哪个 mode

| 目标 | mode | 命令 |
|---|---|---|
| 反复注入小探针 / 配合 stackplz | `rpc` | `run_metasec_probe_350101.sh rpc` |
| 一条请求调用次数、VM 次数 | `counter-one` | `run_metasec_probe_350101.sh counter-one 60 req01_count` |
| 多条请求稳定性 | `counter-multi` | `run_metasec_probe_350101.sh counter-multi 180 multi01` |
| 真机环境 + F8/X-Medusa 基准 | `true-env` | `run_metasec_probe_350101.sh true-env 90 req01_env` |
| JNI / `MS.b` / NewString / FindClass | `jnitrace` | `run_metasec_probe_350101.sh jnitrace 180 jni01` |
| 最终 X-header TreeMap 写入 | `xheader` | `run_metasec_probe_350101.sh xheader 90 xhdr01` |
| CF/F5/F7/F8 分支值 | `branch` | `run_metasec_probe_350101.sh branch 90 branch01` |
| native VMP `vmCode=0x1f7860` | `native-vmp` | `run_metasec_probe_350101.sh native-vmp 90 vmp01` |
| GumTrace `exeVMInner + 0x4cc10` | `gum-exevm` | `run_metasec_probe_350101.sh gum-exevm 90 gum4cc10` |
| GumTrace HTTP/sign inner `0x149ca8` | `gum-http` | `run_metasec_probe_350101.sh gum-http 90 gumhttp01` |
| ArtMethod/maps 检测面 | `artcheck` | `run_metasec_probe_350101.sh artcheck 90 art01` |

经验顺序：

```text
counter-one
  -> true-env
  -> xheader / branch
  -> stackplz/eDBG 精确 watch
  -> gum-exevm / gum-http
```

## 统一 runner

在 host 上运行：

```bash
cd /Users/freeman/project/douyin
dyidre/probes/350101/run_metasec_probe_350101.sh <mode> [seconds] [tag]
```

只想测试脚本参数、mode 白名单、runtime 生成，不想碰手机时：

```bash
DRY_RUN=1 dyidre/probes/350101/run_metasec_probe_350101.sh counter-one 1 dryrun
```

`DRY_RUN=1` 只在 `dyidre/runs/350101/.../<tag>/` 生成 `runtime_*.js` 和 `README.md`，不会 `adb push`，也不会启动 rustFrida。

输出目录自动选择：

| mode | 输出目录 |
|---|---|
| `true-env` | `dyidre/runs/350101/true_env_xmedusa/<tag>/` |
| `jnitrace` | `dyidre/runs/350101/jnitrace/<tag>/` |
| `gum-exevm` / `gum-http` | `dyidre/runs/350101/gumtrace/<tag>/` |
| `artcheck` | `dyidre/runs/350101/maps_artmethod/<tag>/` |
| `stackplz-bridge` | `dyidre/runs/350101/edbg_stackplz/<tag>/` |
| 其他 | `dyidre/runs/350101/entrydump/<tag>/` |

每个 run 目录会自动放：

```text
README.md
runtime_<mode>.js
rustfrida_console.log
```

`counter-one` / `counter-multi` / `branch` 会临时打开 RF RPC，并在结束前自动保存：

```text
metacountsummary.json
metamultisummary.json
metabranchsummary.json
```

`branch` 默认是安全模式：只挂 `counter-one` 已验证稳定的阶段点。像 `0x14A250` 这种基本块内部、相邻很近的精确分支指令，不默认用 RF inline hook 挂；需要精确分支时改用 `stackplz/eDBG` 硬件断点，或者手工在 runtime JS 里打开 `METASEC_PROBE_CONFIG.branchDeep=true`。

`true-env` 模式还会自动拉回并解析：

```text
true_env_xmedusa_350101.log
true_env_xmedusa_summary.json
f8_*.bin / xmedusa_*.raw.bin / *.b64
```

## RPC 用法

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

查看可选 mode：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobemodes \
  -H 'Content-Type: application/json' \
  -d '[]'
```

动态安装一个 probe：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobeinstall \
  -H 'Content-Type: application/json' \
  -d '["counter-one"]'
```

常用 RPC 子命令：

| mode | 安装后可用 RPC |
|---|---|
| `counter-one` | `metacountreset` / `metacountsummary` / `metacountstop` |
| `counter-multi` | `metamultistart` / `metamultisummary` / `metamultistop` |
| `branch` | `metabranchreset` / `metabranchsummary` / `metabranchstop` |
| `stackplz-bridge` | `stackplzmodule` / `stackplzset` / `stackplzbreakmodule` |

## stackplz 配合

先启动 RF RPC：

```bash
dyidre/probes/350101/run_metasec_probe_350101.sh rpc
```

再启动 stackplz RPC：

```bash
adb push dyidre/probes/350101/run_stackplz_hwbrk_rpc.sh /data/local/tmp/
adb shell "su -c 'chmod +x /data/local/tmp/run_stackplz_hwbrk_rpc.sh'"
adb shell "su -c '/data/local/tmp/run_stackplz_hwbrk_rpc.sh req01 41718'"
```

在 RF session 里安装 bridge：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobeinstall \
  -H 'Content-Type: application/json' \
  -d '["stackplz-bridge"]'
```

按 `module + offset` 下硬件执行断点：

```bash
curl -s -X POST http://127.0.0.1:19191/rpc/0/stackplzbreakmodule \
  -H 'Content-Type: application/json' \
  -d '["libmetasec_ml.so","0x4cc10","x",-1,4,41718]'
```

命中日志在设备：

```text
/data/local/tmp/stackplz_hwbrk_rf_req01.log
/data/local/tmp/stackplz_hwbrk_rf_req01.console
```

拉回后放：

```text
dyidre/runs/350101/edbg_stackplz/<run_id>/
```

已验证例子：

```bash
RPC_PORT=19212 dyidre/probes/350101/run_metasec_probe_350101.sh stackplz-bridge 1 smoke_stackplz_bridge_20260901
adb shell "su -c '/data/local/tmp/run_stackplz_hwbrk_rpc.sh smoke_stackplz_bridge_20260901 41718'"
curl -s -X POST http://127.0.0.1:19212/rpc/0/stackplzbreakmodule \
  -H 'Content-Type: application/json' \
  -d '["libmetasec_ml.so",314384,"x",-1,4,41718]'
```

期望结果：

```text
response.status = ok
msg = register breakpoint success
stackplz log 出现 libmetasec_ml.so + 0x4cc10 的 regs/backtrace
```

## standalone stackplz

如果已经知道 App uid 和 so 绝对路径，可以不用 RF bridge：

```bash
adb push dyidre/probes/350101/run_stackplz_offset_test.sh /data/local/tmp/
adb shell "su -c 'chmod +x /data/local/tmp/run_stackplz_offset_test.sh'"
adb shell "su -c '/data/local/tmp/run_stackplz_offset_test.sh <uid> <absolute-lib-path> 0x4cc10 req01_4cc10'"
```

适合快速确认某个 offset 是否命中。缺点是要自己提供 uid 和 so 路径。

已验证例子：

```bash
adb shell "su -c '/data/local/tmp/run_stackplz_offset_test.sh 10280 /data/app/.../lib/arm64/libmetasec_ml.so 0x4cc10 smoke_offset_4cc10_20260901'"
```

期望结果：

```text
stackplz_offset_<tag>.log 先出现：
StackMod hook info:libmetasec_ml.so + 0x4cc10
```

如果没有后续 backtrace，通常不是脚本坏，而是采集窗口内没有新的签名请求命中。

## 2026-09-01 smoke test 状态

| 项 | 结果 | 关键产物/判断 |
|---|---|---|
| JS 语法 | 通过 | `node --check metasec_probe_350101.js` |
| shell 语法 | 通过 | `bash -n run_metasec_probe_350101.sh`；3 个设备侧脚本 `sh -n` |
| 所有 mode DRY_RUN | 通过 | 12 个 mode 都能生成 runtime/README，不碰设备 |
| `rpc` | 通过 | `metaprobeinfo` 返回版本、pid、模块信息 |
| `counter-one` | 通过 | `http_entry=1`、`exeVMInner=4`、vmCode=`0x1ec670/0x1ecaf0/0x1f7860` |
| `counter-multi` | 通过 | 可采 8 条请求，适合看多 URL 稳定性 |
| `true-env` | 通过 | 拉回 `true_env_xmedusa_350101.log` 并生成 summary/bin/b64 |
| `jnitrace` | 通过 | 能打印 `FindClass/RegisterNatives/MS.b/NewStringUTF/REQ#` |
| `xheader` | 通过 | 能 dump `X-Argus/X-Ladon/X-Medusa/X-Soter` key/value |
| `branch` | 通过 | 默认安全模式命中同 counter-one 的阶段/VM 次数 |
| `native-vmp` | 通过 | 能打印 material/common_key/sign_key |
| `gum-exevm` | 通过 | 命中 `+0x4cc10` 并拉回 `gumtrace_4cc10.log` |
| `gum-http` | 通过 | 命中 `+0x14dbf4/+0x149ca8` 并拉回 HTTP GumTrace |
| `artcheck` | 通过 | 能 hook `J.N.MnXVOzVo` 并打印 URL hit |
| `stackplz-bridge` | 通过 | RF 能按 module+offset 下发 stackplz 硬断点，命中后有 regs/backtrace |
| `run_stackplz_offset_test.sh` | 通过启动 | 能注册 offset；是否有 backtrace 取决于窗口内是否有新请求 |

保留的可参考成功目录：

```text
dyidre/runs/350101/entrydump/smoke_counter_one_recheck_20260901/
dyidre/runs/350101/entrydump/smoke_counter_multi_20260901/
dyidre/runs/350101/entrydump/smoke_branch_clean_20260901/
dyidre/runs/350101/entrydump/smoke_xheader_ok_20260901/
dyidre/runs/350101/entrydump/smoke_native_vmp_fixed_20260901/
dyidre/runs/350101/true_env_xmedusa/smoke_true_env_20260901/
dyidre/runs/350101/jnitrace/smoke_jnitrace_20260901/
dyidre/runs/350101/gumtrace/smoke_gum_exevm_20260901/
dyidre/runs/350101/gumtrace/smoke_gum_http_20260901/
dyidre/runs/350101/maps_artmethod/smoke_artcheck_20260901/
dyidre/runs/350101/edbg_stackplz/smoke_stackplz_bridge_20260901/
dyidre/runs/350101/edbg_stackplz/smoke_offset_4cc10_20260901/
```

失败判断：

| 现象 | 判断 |
|---|---|
| summary 里 `counts={}` | 先看是否真的触发请求；若 `counter-one` 同窗口有 hit，再查该 mode gating |
| RF 退出时提示 loader/cleanup 残留 | 只要 zygote patch restored，通常不影响本次产物 |
| `session not connected` | 多半是目标崩/agent 断开；优先减少 inline hook 点，或换 stackplz/eDBG |
| branch 深度点导致卡/断 | 不走默认路径；用 stackplz/eDBG 硬件断点追精确指令 |

## 不要怎么用

| 场景 | 不要 | 应该 |
|---|---|---|
| 只确认一条请求调用次数 | 开 GumTrace | `counter-one` |
| 只差一个字段/byte | 跑 10 分钟 jnitrace | `true-env` + stackplz/eDBG watch |
| raw PC helper 有差但能 resync | 继续追 operator new/malloc helper | `branch` / `xheader` 追值 |
| unidbg header 不一致 | 先改算法 | 先同步真机 `s1/s2/env/MS.b/.msdata` |
| 新版本入口不确定 | 套旧 offset | SO identity + RF entrydump + stackplz 命中确认 |

## 旧 JS 去向

这些旧单功能 JS 已经合进 `metasec_probe_350101.js`，不再保留独立文件：

```text
artmethod_maps_check.js
gumtrace_4cc10.js
gumtrace_getHttpHeadVerify_350101_full_once.js
metasec_branch_probe_350.js
metasec_jnitrace_spawn_early_wxshadow_lite.js
metasec_multi_request_counter_350.js
metasec_one_request_counter_350.js
metasec_xheader_treeput_probe_350.js
native_vmp_1f7860_probe_350.js
rf_rpc_probe.js
rf_stackplz_hwbrk_bridge.js
true_env_xmedusa_350101.js
```

如果要改逻辑，改统一 JS 里的对应 `mode: xxx` 区块，并在本 README 更新用法。
