# eCapture / Douyin BoringSSL offset 排障记录

这份文档记录 350101 版本用 eCapture 抓 TLS/HTTP2 样本时踩到的坑。后面升级版本时，遇到“pcap 有包但 Wireshark/tshark 解不出 HTTP2”的情况，先按这里排，不要直接重跑一堆无效采集。

## 快速结论

这次 eCapture 包的主问题按 `libttboringssl.so` 结构 offset 不匹配处理。

简单说：

```text
不是没抓到包
不是 QUIC
不是 Wireshark 过滤器问题
不是 keylog 没配上

是 eCapture 当前 boringssl_a_15 profile 读 Douyin 自带 libttboringssl.so 时，
SSL/BoringSSL 内部字段 offset 或 TLS1.3 secret 读取不准，
导致 keylog 能匹配 client_random，但 AEAD 解密失败。
```

所以短线不再在 eCapture 上耗时间，切回注入方案；eCapture 只保留为后续“非侵入抓包”的长线适配方向。

## 当前结论

350101 这次 pcap 采集不是“没抓到包”，而是：

```text
pcap 有 TCP/443 和 TLS 握手
keylog.log 也有 CLIENT_TRAFFIC_SECRET_0 / SERVER_TRAFFIC_SECRET_0
tshark 能匹配到 client_random
但 TLS 解密阶段报 auth tag mismatch
所以 Wireshark/tshark 看不到 http2/http
```

这更像是 eCapture 针对目标进程 `libttboringssl.so` 的 BoringSSL 结构偏移/secret 读取不匹配，而不是网络流量少、HTTP2 过滤器写错、或者 QUIC/HTTP3。

## 这次样本

基准目录：

```text
runs/350101/ecapture/wireshark_pcap_20260901_035503/
```

关键文件：

| 文件 | 用途 |
|---|---|
| `capture.pcapng` | Wireshark/tshark 打开的主包 |
| `keylog.log` | eCapture 导出的 TLS keylog |
| `ecapture_command.txt` | 本次 eCapture 命令、目标 `libttboringssl.so` 路径 |
| `ecapture_console.log` | eCapture 启动、BPF、uprobe、自动选择 ssl profile 的日志 |
| `tshark_tls_keylog.log.debug.log` | tshark TLS 解密 debug 日志 |
| `pcap_summary.md/json` | TCP/UDP/QUIC 初筛 |
| `ecapture_summary.md/json` | text/event 初筛 |

这次 `pcap_summary.md` 里已经确认：

```text
tcp443 = 4518
udp443 = 0
```

所以这份样本主路径是 TLS over TCP，不是 QUIC/HTTP3。

## Wireshark 里怎么看

打开 `capture.pcapng` 后，先不要直接搜 `http2`。按这个顺序看：

1. `tls.handshake.type == 1`
   - 如果能看到 ClientHello，说明包里有 TLS 握手。
   - 这次能看到 `connectivitycheck.gstatic.cn` 的 ClientHello，只代表系统网络检测，不代表抖音业务请求。
2. `tcp.port == 443`
   - 看主 TCP/443 流量是否充足。
3. `udp.port == 443`
   - 如果没有 UDP/443，基本不用往 QUIC/HTTP3 方向想。
4. 配好 keylog 后再看 `http2 || http`
   - 如果还是空，但 TLS debug 有 `auth tag mismatch`，优先查 keylog/offset，不是查 display filter。

## tshark 验证命令

本仓库有脚本：

```bash
dyidre/scripts/decode_pcap_with_keylog_tshark.sh \
  dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/capture.pcapng \
  dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/keylog.log \
  dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/tshark
```

手工命令可以这样跑：

```bash
tshark \
  -o tls.keylog_file:dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/keylog.log \
  -r dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/capture.pcapng \
  -Y 'http2 || http'
```

如果 `http2/http` 为 0，再打开 TLS debug：

```bash
tshark \
  -o tls.keylog_file:dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/keylog.log \
  -o tls.debug_file:dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/tshark_tls_keylog.log.debug.log \
  -r dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/capture.pcapng \
  -Y 'tls'
```

重点搜：

```bash
rg -n 'matched client_appdata|matched server_appdata|auth tag mismatch' \
  dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/tshark_tls_keylog.log.debug.log
```

如果同时出现：

```text
matched client_appdata / matched server_appdata
auth tag mismatch
```

意思是 Wireshark 找到了对应 `client_random` 的 keylog 行，但用这个 secret 解密 AEAD record 失败。这个状态下，问题通常在 secret 内容、secret 长度、读 offset、或方向/epoch，而不是 pcap 没包。

## eCapture 侧已经确认的点

设备和工具：

```text
device = Pixel6 / oriole
Android = 15 / SDK 35
ecapture = ecap_android_arm64 v2.5.2
target = com.ss.android.ugc.aweme
target lib = /data/app/.../com.ss.android.ugc.aweme.../lib/arm64/libttboringssl.so
```

目标 `libttboringssl.so` 关键导出：

| 符号 | 350101 offset |
|---|---:|
| `SSL_do_handshake` | `0x4674c` |
| `SSL_get_wbio` | `0x46618` |
| `SSL_read` | `0x46a34` |
| `SSL_write` | `0x46cf0` |
| `SSL_CTX_set_custom_verify` | `0x47fb0` |
| `SSL_CTX_set_keylog_callback` | `0x48cf4` |

所以“函数找不到”不是当前主问题。`SSL_read/SSL_write/SSL_do_handshake` 都在，问题集中在 BoringSSL 内部结构偏移和 TLS 1.3 secret 的读取。

## 一个容易误判的坑：`--ssl_version`

runner 里可以传：

```text
ECAPTURE_SSL_VERSION=boringssl_a_13
```

但 eCapture Android 配置代码会根据系统版本自动覆盖。350101 这次 console 明确显示实际使用的是：

```text
OpenSSL probe started Android=15 BoringSSL=true SslBpfFile=boringssl_a_15_kern.o sslVersion=boringssl_a_15
```

所以后面看日志时，以 `ecapture_console.log` 的实际值为准，不要只看 runner 里写了什么。

## 另一个关键坑：TLS 1.3 secret 长度

这次 `keylog.log` 里大量：

```text
CLIENT_TRAFFIC_SECRET_0
SERVER_TRAFFIC_SECRET_0
EXPORTER_SECRET
```

这些行的 secret hex 长度经常是 128，也就是 64 字节。

TLS 1.3 下这个长度很可疑：

| 套件 | 正常 hash secret 长度 |
|---|---:|
| AES_128_GCM_SHA256 / CHACHA20_POLY1305_SHA256 | 32 bytes |
| AES_256_GCM_SHA384 | 48 bytes |

eCapture 源码里有一个需要重点确认的点：

```text
kern/boringssl_masterkey.h
  struct mastersecret_bssl_t 里最后字段是 hash_len

kern/include/openssl_masterkey_common.h
  OpenSSL 通用 event 里对应位置是 cipher_id

internal/probe/openssl/event_masterkey.go
  Go 侧按 cipher_id 解码，并据此选择 TLS1.3 secret 长度
```

如果 BoringSSL 事件把 `hash_len` 发上来，而 Go 侧当成 `cipher_id`，就会走不到正确 cipher 分支，最后按 `EvpMaxMdSize=64` 输出 secret。这能解释为什么 keylog 里出现 64 字节 secret，也解释了为什么 Wireshark 能匹配 keylog 行但 AEAD 解密失败。

注意：我试过把 keylog 机械裁成 32/48 字节再喂 tshark，仍然没有完整解出 HTTP2。这说明“长度”很可能只是问题之一，BoringSSL secret offset/epoch/direction 也要继续校准。

## 先排除官方系统 BoringSSL

下一步应该先做一个“系统库 sanity test”，确认 eCapture 对 Android 系统自带 Conscrypt BoringSSL 是否能正常产出可解密 pcap。

目标库：

```text
/apex/com.android.conscrypt/lib64/libssl.so
```

如果系统库能解：

```text
eCapture + pcap + keylog + Wireshark/tshark 链路没问题
Douyin 的 libttboringssl.so 需要单独适配 offset/profile
```

如果系统库也解不了：

```text
先修 eCapture / pcap / keylog / tshark 使用链路
不要急着改 Douyin offset
```

建议做法：

1. 在设备上跑一个最小 Java HTTPS 请求，强制走系统 Conscrypt。
2. eCapture hook `/apex/com.android.conscrypt/lib64/libssl.so`。
3. 生成同一次 `capture.pcapng + keylog.log`。
4. 用 tshark 看是否能解出 `http2` 或 `http`。

本机可用工具已经确认：

```text
javac
Android SDK d8
adb
device app_process / dalvikvm
```

这个 sanity test 只用于排除工具链，不作为 Douyin 样本。

## 针对 Douyin `libttboringssl.so` 的长线适配路线

不要直接改 350101 的抓包脚本硬试。建议新建一个 eCapture profile，例如：

```text
boringssl_dy_350101_kern.c
```

按下面顺序校准：

1. 函数入口
   - `SSL_read`
   - `SSL_write`
   - `SSL_do_handshake`
   - `SSL_CTX_set_keylog_callback`
2. `SSL*` 基础字段
   - `ssl->rbio`
   - `ssl->wbio`
   - fd / BIO num
   - `ssl->s3`
   - `ssl->version`
3. TLS 1.3 secrets
   - client random
   - client traffic secret
   - server traffic secret
   - exporter secret
   - secret length
   - handshake/new_session/early_session 状态
4. 输出格式
   - 修 BoringSSL event ABI：Go 侧不能把 `hash_len` 当 `cipher_id` 用。
   - 或者 BoringSSL 单独走 `hash_len`，直接输出正确长度的 keylog。
5. 对照 oracle
   - 临时用 RF/Frida hook `SSL_CTX_set_keylog_callback @ 0x48cf4` 拿官方回调 keylog。
   - 只用于校准 eCapture offset，不作为长期抓包方案。

最终目标不是“让 Wireshark 显示两条 ClientHello”，而是：

```text
同一次 Douyin 请求：
capture.pcapng + keylog.log 能被 tshark 解出 http2/http
能看到业务 path / :authority / x-argus / x-ladon / x-medusa / x-khronos 等 header
```

## 快速决策树

```text
Wireshark 只有 ClientHello
  -> 先看 pcap_summary.md

udp443 > 0
  -> 可能是 QUIC/HTTP3，eCapture TLS/TCP keylog 不一定覆盖

udp443 = 0 且 tcp443 很多
  -> TLS/TCP 样本成立

tshark -Y 'http2 || http' 为空
  -> 开 tls.debug_file

debug 没有 matched client_appdata/server_appdata
  -> keylog 没匹配握手，采集窗口/配对/secret label 有问题

debug 有 matched，但有 auth tag mismatch
  -> keylog 匹配到了连接，但 secret 内容/长度/offset/epoch 不对

keylog secret 全是 64 bytes
  -> 优先查 BoringSSL hash_len/cipher_id 事件 ABI

系统 Conscrypt sanity test 能解
  -> 专心适配 Douyin libttboringssl.so

系统 Conscrypt sanity test 也不能解
  -> 先修 eCapture/tshark 工具链
```

## 这次不要再重复做的事

- 不要用 `http2` 过滤为空就判断“没有请求”。
- 不要只看 `tls.handshake.type == 1` 的两条 `connectivitycheck.gstatic.cn`，那多半是系统连通性检测。
- 不要把 `keylog.log` 当请求数据；它只是解密材料，必须和同一次 `capture.pcapng` 配对。
- 不要机械裁剪 64 字节 secret 后就认为解决了；裁剪失败说明 offset/epoch/方向仍要查。
- 不要在 pcap/keylog 解密失败时继续纠结 `libmetasec_ml.so`，这里的问题发生在网络 TLS 层。

## 相关文档

```text
dyidre/probes/350101/README.md
dyidre/docs/toolchain.md
dyidre/runs/350101/ecapture/README.md
dyidre/runs/350101/ecapture/wireshark_pcap_20260901_035503/README.md
```
