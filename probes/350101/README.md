# 350101 probe 使用手册

这里只保留 Douyin `350101` 已跑通、后续还能复用的入口。旧的单功能 JS 已经合并进 `metasec_probe_350101.js`，避免接手的人在一堆相似脚本里选错。

通用工具链说明：

```text
docs/metasec-analysis-trajectory.md
docs/reusable-probes-stackplz-edbg.md
```

如果不知道该先跑哪个 mode，先看 `metasec-analysis-trajectory.md` 的“第 3 步：抓一条真机基准请求”和“第 7 步：再追值级差异”。

## 当前保留文件

| 文件 | 作用 | 谁来执行 |
|---|---|---|
| `metasec_probe_350101.js` | 统一 Frida/rustFrida JS。通过 `mode` 选择 counter、true-env、jnitrace、gumtrace、stackplz bridge 等功能 | rustFrida |
| `run_metasec_probe_350101.sh` | 统一 host runner。自动生成带 mode 的 runtime JS、推送、spawn、归档输出 | macOS host |
| `run_ecapture_tls_350101.sh` | eCapture TLS 明文采集 runner。自动推送 eCapture、定位目标进程 `libttboringssl.so`、归档 text/pcap/keylog 输出 | macOS host |
| `run_rf_rpc_persistent.sh` | 设备侧 RF RPC 常驻 runner。被 `mode=rpc` 使用，也可手工用 | Android device |
| `run_stackplz_hwbrk_rpc.sh` | 设备侧 stackplz dev RPC runner | Android device |
| `run_stackplz_offset_test.sh` | 设备侧 stackplz standalone offset 栈采样 | Android device |
| `run_rf_mitm_auto_350101.sh` | 一键检查设备、推送 RF、设置代理、pm clear、spawn SSL hook、处理弹窗并归档 flow | macOS host |

## 先部署工具

runner 默认调用设备上的：

```text
/data/local/tmp/rustfrida
```

仓库里已经保存了一份可复用工具：

```bash
adb push tools/runtime_payloads/rustfrida /data/local/tmp/rustfrida
adb shell "su -c 'chmod 755 /data/local/tmp/rustfrida'"
```

如果要测试 wxshadow/hide-so，再按需推：

```bash
adb push tools/runtime_payloads/wxshadow.kpm /data/local/tmp/wxshadow.kpm
adb push tools/runtime_payloads/hide-so.kpm /data/local/tmp/hide-so.kpm
```

工具说明见：

```text
tools/README.md
tools/runtime_payloads/README.md
```

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
| 网络 TLS 明文基准 | eCapture | `run_ecapture_tls_350101.sh text 60 req01_ecap` |
| sscronet/libttboringssl RF 抓包备用 | `ssl` | `run_metasec_probe_350101.sh ssl 90 ssl01` |
| Cronet 组包 + `0x14DBF4` X-header + dydcd 上传 | `capture` | `run_metasec_probe_350101.sh capture 180 cap01` |
| GumTrace 同时抓 packet | `gum-exevm,capture` | `run_metasec_probe_350101.sh gum-exevm,capture 180 gum_cap01` |
| ArtMethod/maps 检测面 | `artcheck` | `run_metasec_probe_350101.sh artcheck 90 art01` |

经验顺序：

```text
counter-one
  -> eCapture text
  -> true-env
  -> xheader / branch
  -> stackplz/eDBG 精确 watch
  -> gum-exevm / gum-http
```

## 统一 runner

在 host 上运行：

```bash
cd /path/to/dyidre
probes/350101/run_metasec_probe_350101.sh <mode> [seconds] [tag]
```

多个 mode 可以用逗号组合；例如 `gum-exevm,capture` 会同时开 GumTrace
`exeVMInner +0x4cc10` 和 Cronet packet 上传。`capture` 默认上传到
`http://127.0.0.1:8891/up/dy/packets`，runner 会自动执行
`adb reverse tcp:8891 tcp:8891`。

只想测试脚本参数、mode 白名单、runtime 生成，不想碰手机时：

```bash
DRY_RUN=1 probes/350101/run_metasec_probe_350101.sh counter-one 1 dryrun
```

`DRY_RUN=1` 只在 `runs/350101/.../.dry-<tag>/` 生成 `runtime_*.js` 和 `README.md`，不会 `adb push`，也不会启动 rustFrida；该目录已被 Git 忽略。

输出目录自动选择：

| mode | 输出目录 |
|---|---|
| `true-env` | 默认 `runs/350101/true_env_xmedusa/latest/` |
| `jnitrace` | 默认 `runs/350101/jnitrace/latest/` |
| `gum-exevm` / `gum-http` | 默认 `runs/350101/gumtrace/latest/` |
| eCapture runner | 默认 `runs/350101/ecapture/latest/` |
| `ssl` | 默认 `runs/350101/ssl/latest/` |
| `artcheck` | 默认 `runs/350101/maps_artmethod/latest/` |
| `stackplz-bridge` | 默认 `runs/350101/edbg_stackplz/latest/` |
| 其他 | 默认 `runs/350101/entrydump/latest/` |

正式运行默认覆盖同类 `latest/` 并清理该类型旧日期目录。需要保留历史对比时显式设置
`KEEP_HISTORY=1`；`DRY_RUN=1` 则写到 `.dry-<tag>/`，只用于本地分析且不会上传。

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

## 一键 RF + mitmproxy 样本采集（推荐复跑入口）

如果目标是“清理应用 → 设置代理 → spawn 注入 → 自动同意隐私页/跳过弹窗 → 保存网络样本”，使用：

```bash
cd /path/to/dyidre
probes/350101/run_rf_mitm_auto_350101.sh 180 req01
```

脚本会先做只读条件检查：ADB 连接数、设备 `arm64-v8a`、`su` 是否返回 `uid=0`、目标包是否存在、`mitmdump` 是否可执行，以及本地/手机端 rustfrida SHA-256 是否一致。缺少手机端 rustfrida 或 hash 不一致时，会自动推送并 `chmod 755`。目标包未安装时不会猜 APK；显式提供 `APK_PATH=/path/to/douyin.apk` 才会执行 `adb install -r -d`。

正式采集前建议先跑：

```bash
DRY_RUN=1 probes/350101/run_rf_mitm_auto_350101.sh 20 dry_check
```

`DRY_RUN=1` 仍会读取设备状态和校验 hash，但不会 `pm clear`、改代理、启动 mitmdump 或注入 RF。

### 可选参数

```bash
SERIAL=18201FDF6002GR \
MITM_HOST=192.168.31.84 MITM_PORT=8080 \
CLEAR_APP_DATA=1 AUTO_SKIP=1 \
SWIPE_AFTER=0 SWIPE_INTERVAL=30 \
probes/350101/run_rf_mitm_auto_350101.sh 180 req01
```

- `MITM_HOST` 必须是手机能访问的 host 局域网地址；不填写时优先从采集前已有代理推断，再尝试 `en0/en1`。
- `CLEAR_APP_DATA=1` 默认清除目标 App 数据，确保首启流程可观察；不想清数据时设为 `0`。
- `AUTO_SKIP=1` 只点击隐私协议“同意”和安全的“跳过/稍后/关闭”，对 Android 运行时权限只点击“拒绝”，不会调用 `pm grant`。
- `POPUP_DURATION=45` 控制启动后的 UI 扫描窗口，默认 45 秒；需要观察延迟弹窗时再适当增大，避免全程 dump 造成卡顿。
- `SWIPE_AFTER` 大于 0 时，隐私同意后按 `SWIPE_INTERVAL` 秒滑动一次；默认不自动滑动。
- `RESTORE_PROXY=1` 默认在退出（包括中断）时恢复原代理。若采集前没有代理，恢复为 Android 的 `:0`。
- `KEEP_HISTORY=0` 默认每次正式采集前清理 `runs/350101/mitm/` 的旧批次，只保留本次最新 flow；要做历史对比时设为 `1`。
- `AUTO_INSTALL=1` 在 host 没有 `mitmdump` 且存在 Homebrew 时尝试安装 `mitmproxy`；也可以提前设置 `MITMDUMP=/path/to/mitmdump`。
- `RF_POST_RESUME_JAVA_WORKER_MODE=skip` 是默认值。独立 SSL runtime 不使用 Java；跳过 rustFrida 的 post-resume Java worker 可避开当前设备上已复现的启动期 `SIGSEGV`。除非 runtime 新增 Java 操作，否则不要改为其它值。

### 执行边界与校验

- 正式运行会修改 Android 全局 HTTP 代理，并在正常结束或 `Ctrl-C` 时恢复运行前的值；`RESTORE_PROXY=0` 才会保留本次代理。
- `CLEAR_APP_DATA=1` 会执行 `pm clear com.ss.android.ugc.aweme`，这会清除抖音本地数据和登录状态。要保留现有数据，必须显式设为 `CLEAR_APP_DATA=0`。
- 为让 rustFrida 读取 spawn/proc 信息，脚本会执行 `setenforce 0` 并尝试重新挂载 `/proc`；它**不会**恢复 SELinux 状态。因此只应在实验机运行，并在结束后按采集前的状态自行恢复。
- 默认 `VERIFY_TARGET_FLOWS=1`：除生成 `flows.mitm` 外，还要求 `/sdi/get_token` 与 `/ri/report` 都有 header/body 完整的请求；缺任一项会以非零状态退出，并写入 `target_request_validation.json`。只想保留原始 flow 时可设为 `VERIFY_TARGET_FLOWS=0`。

默认引擎为 rustFrida spawn。已有匹配版本的 host `frida` 和手机端 `frida-server` 时，也可改用 attach 模式作对照：

```bash
RF_ENGINE=frida \
FRIDA_SERVER_REMOTE=/data/local/tmp/frida-server-17.17.0 \
probes/350101/run_rf_mitm_auto_350101.sh 180 req01_frida
```

`FRIDA_MODE` 默认是 `attach`；只有明确要排查 spawn 差异时才设置 `FRIDA_MODE=spawn`，因为当前样本的 stock Frida spawn 曾出现 no-op 崩溃。

### 产物位置

默认每次运行只在以下目录留下可交接的样本：

```text
runs/350101/mitm/latest/
```

默认产物只有：

```text
flows.mitm       # mitmproxy flow 样本
README.md        # 本次结果、代理恢复状态和查看命令
```

RF、弹窗、mitmdump 的过程日志写入系统临时目录，结束后自动删除，因此不会再生成 `combined/<tag>/`、`rf/`、`popup/` 等过程子目录。需要定位失败原因时再显式保留日志：

```bash
KEEP_LOGS=1 probes/350101/run_rf_mitm_auto_350101.sh 180 req01_debug
```

此时会额外保存 `run_parameters.txt`、`device_state_*.txt`、`mitmdump.log`、`rf_runner.console.log` 和 `auto_skip_popups.log`。若同时设置 `KEEP_HISTORY=1`，本次目录使用传入的 tag，而不是 `latest`。

查看 flow（mitmweb 会在控制台打印一次性 token URL）：

```bash
mitmweb --listen-host 127.0.0.1 --listen-port 8082 \
  --web-host 127.0.0.1 --web-port 8081 --no-web-open-browser \
  -r runs/350101/mitm/latest/flows.mitm
```

注意：这条流程只保证 RF hook 和 flow 文件可复现，不保证所有上游 TLS 连接都成功；`mitm/mitmdump.log` 中的 `certificate unknown`、`502` 仍需结合 RF SSL console 判断。证书不会自动写入系统证书区，避免把“安装 CA”和“应用 pinning 绕过”混为一谈。

## eCapture TLS 明文抓包主方案

网络明文抓包现在优先走 eCapture，而不是 RF 的 `ssl` mode。

原因：

- eCapture 通过 eBPF uprobe 挂 `SSL_read/SSL_write`，不注入 App 进程；
- 能让 eCapture 自带解析器直接输出 `HTTPRequest/HTTP2Request/HTTP2Response`；
- 抓到的 text/pcap/keylog 和 RF/IDA/unidbg 证据分离，后续升级版本不容易混。

推荐先跑 text：

```bash
# 先手动打开抖音，确认页面可滑/能触发网络请求，再执行。
probes/350101/run_ecapture_tls_350101.sh text 60 req01_ecap

# 如果想让脚本把抖音切到前台，再开始 eCapture。
FOREGROUND_APP=1 probes/350101/run_ecapture_tls_350101.sh text 60 req01_ecap_front
```

输出目录（默认只保留最新一份）：

```text
runs/350101/ecapture/latest/
```

需要保留带 tag 的历史批次时设置 `KEEP_HISTORY=1`；否则正式运行前会清理旧日期目录。

重点看：

| 文件 | 看什么 |
|---|---|
| `ecapture_command.txt` | pid、实际 `libttboringssl.so` 路径、完整 eCapture 命令 |
| `ecapture_console.log` | BPF/BTF/uprobe/permission/ssl_version 是否报错 |
| `ecapture_events.log` | 明文事件原文 |
| `ecapture_summary.md` | HTTP/2 path、host、X-* header、TLS READ/WRITE 数量摘要 |
| `http2_decode.md` | text 模式下，把 SSL 明文切成 HTTP/2 frame；装 `hpack` 后可解 HEADERS |
| `pcap_summary.md` | pcap 模式下统计 TCP/UDP、TCP/443、UDP/443，用来判断有没有 QUIC/HTTP3 |

样本采集约束：

- runner 默认 `START_APP=0`，不会自动拉起 App；这样更接近真实用户态，不额外改变启动路径。
- 如果你希望脚本自动打开/拉前台，用 `FOREGROUND_APP=1`；它只负责 `monkey` 启动界面，不改变 eCapture 的非注入抓包性质。
- 采集窗口里要手动触发请求；如果只停在首页静止状态，常见结果是只抓到 HTTP/2 ping/控制帧，没有业务 header。
- raw log 可能包含账号 token、cookie、设备标识、X-* 签名头；公开仓库不要提交未脱敏的真实样本。

如果没有事件，先按这个顺序排：

1. `ecapture_command.txt` 的 `libssl=` 必须来自目标进程 `/proc/<pid>/maps`，不能随便拿 APK 里的复制件；
2. Pixel6 5.10 可以试，Pixel5 4.19/arm64 不满足 eCapture 官方 arm64 5.5+ 要求；
3. `ECAPTURE_SSL_VERSION` 可尝试 `boringssl_a_13`、`boringssl_a_14`、`boringssl_a_15`；
4. 如果 maps 显示 `base.apk!...libttboringssl.so`，uprobe 可能挂不到 zip 内映射，此时退回 RF `ssl` 备用模式。

pcap/keylog 作为辅助：

```bash
probes/350101/run_ecapture_tls_350101.sh pcap 60 req01_pcap
probes/350101/run_ecapture_tls_350101.sh keylog 60 req01_key
```

判断包类型的口径：

- `text` 模式看到的 `SSL_read/write` 是 TLS 解密后的应用层明文；如果是 HTTP/2，它是二进制 frame，不一定直接出现 `GET/POST` 字符串。
- `scripts/decode_ecapture_http2.py runs/350101/ecapture/latest/` 会把 text 明文切成 HTTP/2 frame；只有出现 `HEADERS/DATA` 才算抓到业务请求，只有 `PING/SETTINGS/WINDOW_UPDATE` 说明采集窗口里主要是连接保活/控制帧。历史目录替换为实际 tag。
- `pcap` 模式先用 `scripts/summarize_ecapture_pcap.py runs/350101/ecapture/latest/capture.pcapng` 看 TCP/UDP 分布；`UDP/443` 是 QUIC/HTTP3 的优先判断点，只有 `TCP/443` 则是普通 TLS/TCP 路径。历史目录替换为实际 tag。
- `capture.pcapng + keylog.log` 可以交给 Wireshark/tshark 深度解析；本仓库脚本只做快速归档和初筛。

如果 Wireshark 只能看到 ClientHello，或者 `tshark -Y 'http2 || http'` 为空，先看：

```text
docs/ecapture-boringssl-offset-troubleshooting.md
```

如果本机装了 `tshark`，直接用 `keylog.log` 解 pcap：

```bash
dyidre/scripts/decode_pcap_with_keylog_tshark.sh \
  runs/350101/ecapture/latest/capture.pcapng \
  runs/350101/ecapture/latest/keylog.log \
  runs/350101/ecapture/latest/tshark
```

没有 `tshark` 时，Python 里推荐 `pyshark`，但它本质还是调用 tshark。纯 Python 的 `hpack/hyperframe` 适合解析 eCapture `text` 明文，不负责 pcap/TLS 解密。

如果不想用 Wireshark/tshark，固定走脚本化 text 路线：

```bash
# 采集：输出 ecapture_console.log
FOREGROUND_APP=1 ECAPTURE_HEX=1 probes/350101/run_ecapture_tls_350101.sh text 120 req03_api_text_hex

# 离线重跑解析：输出 requests_all.md/json
dyidre/scripts/parse_ecapture_run.sh runs/350101/ecapture/latest
```

这条路线不需要 `keylog.log`，因为 eCapture text 里已经是 `SSL_read/SSL_write` 明文。要完整解出 HTTP/2 header，最好从 App/连接刚启动时开始采，否则 HPACK 动态表缺前文，后面的接口只能看到 stream/body 长度，header 会出现 `Invalid table index`。

## RF sscronet / SSL 抓包备用

`ssl` mode 是从旧脚本 `z/ida_dy0628/ww240.js#hookSSL` 移植过来的。350101 这里不能再直接用旧地址：APK 打包的是 `libsscronet.so + libttboringssl.so + libttcrypto.so`，不是系统 `libssl.so/libcrypto.so` 主链路。

350101 已确认的对应关系：

| 旧脚本目标 | 350101 对应 SO/符号 | 350101 offset | 结论 |
|---|---|---|---|
| `libssl.so!SSL_write` | `libttboringssl.so!SSL_write` | `0x46CF0` | 可用 |
| `libssl.so!SSL_read` | `libttboringssl.so!SSL_read` | `0x46A34` | 可用 |
| `libssl.so + 0x2CDD4` | 350101 落在 `SSL_ech_accepted` 附近 | `0x2CDD4` | 不通用，不建议钩 |
| `libcrypto.so!BIO_write` | `libttcrypto.so!BIO_write` | `0xC0004` | 可用 |
| `libcrypto.so!BIO_write_all` | `libttcrypto.so!BIO_write_all` | `0xC0084` | 可用 |
| `libcrypto.so!BIO_flush` | `libttcrypto.so!BIO_flush` | `0xC011C` | 可用 |
| `libcrypto.so!CBB_flush` | `libttcrypto.so!CBB_flush` | `0xC4AD8` | 可用 |
| 证书自定义校验 | `libttboringssl.so!SSL_CTX_set_custom_verify` | `0x47FB0` | 可用 |
| 单连接证书校验 | `libttboringssl.so!SSL_set_custom_verify` | `0x47FBC` | 可用 |
| TLS keylog | `libttboringssl.so!SSL_CTX_set_keylog_callback` | `0x48CF4` | 可用 |

普通抓包先跑：

```bash
probes/350101/run_metasec_probe_350101.sh ssl 90 ssl01
```

默认会：

- 监听 `libttboringssl.so/libttcrypto.so/libsscronet.so` 加载；
- 包裹 `SSL_CTX_set_custom_verify` / `SSL_set_custom_verify` 的校验回调，记录原始返回，并按旧脚本逻辑返回 `0`；
- 打印 `SSL_write/SSL_read` 少量明文预览；
- 打印 `BIO_write/BIO_write_all/BIO_flush/CBB_flush` 命中；
- 如果 keylog 符号存在，安装 `SSL_CTX_set_keylog_callback`，console 里会出现 `KEYLOG ...`。

在 rustFrida 当前 QuickJS pre-resume 环境里，`NativeCallback` 不可用，但 RF 自己的
`Interceptor.replace(addr, function(ctx){ ... })` 可用，所以当前脚本会自动走
`rf-js-replace` 路径复现旧 `dlopentodo()` 语义：

- `SSL_CTX_set_custom_verify(ctx, mode, cb)` / `SSL_set_custom_verify(...)` 会被 replace；
- 进入 setter 后记录 `ctx/mode/callback`，并在调用原 setter 前把 `mode` 改成 `0`；
- 对传进来的 custom verify callback 继续 replace；
- callback 会先调用原函数，再按旧 `hookCallBack()` 逻辑强制返回 `0`；
- 不安装 keylog callback；
- `SSL_write/SSL_read/BIO/CBB` 仍正常记录。

### SSL / packet-capture 与 Java/WXSHADOW 的隔离

`Java.setStealth(WXSHADOW)` 是进程级 ART 策略，不是某一个 native 函数的局部选项。
统一 JS 还包含 `jnitrace/artcheck/packet-capture` 代码；如果 RF 直接扫描整份源码，会把
未选中的代码也当成当前模式的 stealth 声明，进而在错误的时机预配置 Java/ART
WXSHADOW。

`run_metasec_probe_350101.sh` 已做隔离：

1. `ssl` 默认写入 `ssl.stealth=false`，SSL native replace 走普通路径；
2. `METASEC_SSL_STEALTH=1` 只控制 SSL native replace 的 `Hook.WXSHADOW` 第三参数，
   不再让未选中的 Java 代码触发 RF pre-resume Java stealth；
3. `packet-capture` 默认先用 normal Java hook 保证采集链路跑起来；单独 capture 会生成
   slim runtime，只包含 packet-capture 所需代码；
4. runtime 源码区里未选中模式的 `Java.setStealth` 点号成员访问会拆开，字符串和注释不改。

只有要专门复测 SSL 的 WXSHADOW 兼容性时才显式打开：

```bash
METASEC_SSL_STEALTH=1 \
  probes/350101/run_metasec_probe_350101.sh ssl 20 ssl_wxshadow_check
```

这不是普通抓包命令；若看到 `wxshadow PATCH failed (errno=22)`，说明该设备/KPM 组合
不支持这条 native 替换路径，应回到默认的 `ssl.stealth=false` 采集模式。

packet-capture 如需复测 Java WXSHADOW，可用：

```bash
METASEC_PACKET_STEALTH=1 \
  probes/350101/run_metasec_probe_350101.sh capture 60 capture_wxshadow_java
```

如果换官方 Frida/Gum 环境，存在 `NativeCallback` 时，同一份脚本会走
`nativecallback-replace` 路径，并可安装 keylog callback。

已验证的 RF 短测样例：

```text
runs/350101/ssl/ssl_dlopentodo_rf_cb_20260901_025606/
```

关键日志应包含：

```text
replace libttboringssl.so!SSL_CTX_set_custom_verify ... path=rf-js-replace
custom verify callback hooked ... path=rf-js-replace
custom_verify_cb ... original=0 -> force 0
```

如果只想观察、不想修改证书校验返回，用 runtime JS 头部覆盖：

```js
globalThis.METASEC_PROBE_CONFIG = {
  mode: "ssl",
  ssl: { forceVerifyOk: false }
};
```

如果必须复现旧 `hookSSL()` 的系统库硬编码 offset：

```js
globalThis.METASEC_PROBE_CONFIG = {
  mode: "ssl",
  ssl: { legacyOffsets: true }
};
```

一般不建议开 `legacyOffsets`：这些 offset 跟系统 `libssl/libcrypto` 强绑定，在 350101 的 bundled `ttboringssl/ttcrypto` 上已经不对应。

## RPC 用法

启动 RF RPC：

```bash
probes/350101/run_metasec_probe_350101.sh rpc
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
probes/350101/run_metasec_probe_350101.sh rpc
```

再启动 stackplz RPC：

```bash
adb push probes/350101/run_stackplz_hwbrk_rpc.sh /data/local/tmp/
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
runs/350101/edbg_stackplz/<run_id>/
```

已验证例子：

```bash
KEEP_HISTORY=1 RPC_PORT=19212 probes/350101/run_metasec_probe_350101.sh stackplz-bridge 1 smoke_stackplz_bridge_20260901
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
adb push probes/350101/run_stackplz_offset_test.sh /data/local/tmp/
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

## 自测约定

冒烟测试只用于本地验证，不进入仓库。执行 `DRY_RUN=1` 或各脚本的语法检查
不会在 `runs/350101/` 留目录；正式采集才会保存一份可复核基准。这样接手者
看到的目录就是实际证据，不会把 `smoke_*`、`dry_*` 当成真机结果。

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
