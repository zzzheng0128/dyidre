#!/usr/bin/env bash
# 用 Wireshark/tshark + TLS keylog 解密 eCapture/tcpdump 的 pcapng。
#
# 为什么需要它：
#   - `keylog.log` 本身不是流量，它是 TLS 会话密钥；
#   - `capture.pcapng` 本身还是网络包；
#   - 两者合起来，tshark/Wireshark 才能把 TLS Application Data 还原成 HTTP/2/HTTP/1/QUIC/HTTP3。
#
# 用法：
#   dyidre/scripts/decode_pcap_with_keylog_tshark.sh \
#     dyidre/runs/350101/ecapture/<tag>/capture.pcapng \
#     dyidre/runs/350101/ecapture/<tag>/keylog.log \
#     dyidre/runs/350101/ecapture/<tag>/tshark
#
# 输出：
#   <out_prefix>.protocols.txt       协议层快速确认
#   <out_prefix>.decrypted.json      Wireshark JSON，保留完整 dissector 结果
#   <out_prefix>.http2_headers.tsv   HTTP/2 header 字段表
#   <out_prefix>.http1.tsv           HTTP/1 request/response 字段表
#   <out_prefix>.quic_http3.tsv      QUIC/HTTP3 初筛字段表
set -euo pipefail

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  sed -n '1,30p' "$0" >&2
  exit 2
fi

PCAP="$1"
KEYLOG="$2"
OUT_PREFIX="${3:-${PCAP%.*}.tshark}"

if ! command -v tshark >/dev/null 2>&1; then
  cat >&2 <<'EOF'
[decode-pcap-keylog] tshark not found.

安装方式：
  macOS:
    brew install --cask wireshark
    # 或 brew install wireshark

验证：
  tshark -v

注意：
  pyshark 也是调用 tshark；没有 tshark，pyshark 也不能稳定解 pcap/keylog。
EOF
  exit 127
fi

if [ ! -s "$PCAP" ]; then
  echo "[decode-pcap-keylog] missing pcap: $PCAP" >&2
  exit 1
fi
if [ ! -s "$KEYLOG" ]; then
  echo "[decode-pcap-keylog] missing keylog: $KEYLOG" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT_PREFIX")"

# 协议层确认：先看有没有 http/http2/quic/http3/tls。
tshark -r "$PCAP" \
  -o "tls.keylog_file:$KEYLOG" \
  -o "tcp.desegment_tcp_streams:TRUE" \
  -o "tls.desegment_ssl_records:TRUE" \
  -o "tls.desegment_ssl_application_data:TRUE" \
  -q -z io,phs \
  > "${OUT_PREFIX}.protocols.txt"

# 完整 JSON：字段最多，但体积也最大；给后续脚本二次提取。
tshark -r "$PCAP" \
  -o "tls.keylog_file:$KEYLOG" \
  -o "tcp.desegment_tcp_streams:TRUE" \
  -o "tls.desegment_ssl_records:TRUE" \
  -o "tls.desegment_ssl_application_data:TRUE" \
  -Y "http or http2 or quic or http3" \
  -T json \
  > "${OUT_PREFIX}.decrypted.json"

# HTTP/2 header 字段表：如果字段名在当前 Wireshark 版本不可用，保留空文件并继续。
tshark -r "$PCAP" \
  -o "tls.keylog_file:$KEYLOG" \
  -o "tcp.desegment_tcp_streams:TRUE" \
  -o "tls.desegment_ssl_records:TRUE" \
  -o "tls.desegment_ssl_application_data:TRUE" \
  -Y "http2" \
  -T fields \
  -E header=y -E separator=$'\t' -E quote=d -E occurrence=a \
  -e frame.number \
  -e ip.src -e ip.dst \
  -e tcp.stream \
  -e http2.streamid \
  -e http2.header.name \
  -e http2.header.value \
  > "${OUT_PREFIX}.http2_headers.tsv" || true

# HTTP/1 字段表。
tshark -r "$PCAP" \
  -o "tls.keylog_file:$KEYLOG" \
  -o "tcp.desegment_tcp_streams:TRUE" \
  -o "tls.desegment_ssl_records:TRUE" \
  -o "tls.desegment_ssl_application_data:TRUE" \
  -Y "http" \
  -T fields \
  -E header=y -E separator=$'\t' -E quote=d -E occurrence=a \
  -e frame.number \
  -e ip.src -e ip.dst \
  -e tcp.stream \
  -e http.request.method \
  -e http.host \
  -e http.request.uri \
  -e http.response.code \
  > "${OUT_PREFIX}.http1.tsv" || true

# QUIC/HTTP3 初筛：这次 350101 样本 udp443=0，一般不会有内容。
tshark -r "$PCAP" \
  -o "tls.keylog_file:$KEYLOG" \
  -Y "quic or http3" \
  -T fields \
  -E header=y -E separator=$'\t' -E quote=d -E occurrence=a \
  -e frame.number \
  -e udp.stream \
  -e quic.dcid \
  -e quic.scid \
  -e http3.headers.header.name \
  -e http3.headers.header.value \
  > "${OUT_PREFIX}.quic_http3.tsv" || true

echo "[decode-pcap-keylog] wrote ${OUT_PREFIX}.*"
