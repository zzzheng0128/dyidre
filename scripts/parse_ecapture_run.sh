#!/usr/bin/env bash
# 一键解析 eCapture run 目录。
#
# 目标：
#   不依赖 Wireshark GUI，不让人手工翻 100MB+ 的 ecapture_console.log。
#
# 输入：
#   dyidre/runs/<version>/ecapture/<tag>/
#
# 输出：
#   ecapture_summary.md/json       TLS READ/WRITE + eCapture 自带 HTTP 事件摘要
#   http2_decode.md/json           HTTP/2 frame/HPACK header 解析
#   requests_all.md/json           按接口/stream 聚合后的请求清单
#   pcap_summary.md/json           如果有 capture.pcapng，则统计 TCP/UDP/QUIC 初筛
#
# 说明：
#   - text --hex 模式已经是 TLS 明文，不需要 keylog；
#   - keylog.log 只用于 pcapng 解密；纯 Python 直接解 TLS1.3+HTTP2 不稳定，
#     所以这里默认不碰 pcap 解密，只做 pcap TCP/UDP/QUIC 初筛。
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "用法：dyidre/scripts/parse_ecapture_run.sh dyidre/runs/350101/ecapture/<tag>/" >&2
  exit 2
fi

RUN_DIR="$1"
if [ ! -d "$RUN_DIR" ]; then
  echo "[parse-ecapture] run dir not found: $RUN_DIR" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DYIDRE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VENV_DIR="${DYIDRE_HTTP2_VENV:-/tmp/dyidre_h2_venv}"

if [ ! -x "$VENV_DIR/bin/python" ]; then
  echo "[parse-ecapture] create venv: $VENV_DIR"
  python3 -m venv "$VENV_DIR"
fi

if ! "$VENV_DIR/bin/python" - <<'PY' >/dev/null 2>&1
import hpack
PY
then
  echo "[parse-ecapture] install Python HTTP/2 deps into venv"
  "$VENV_DIR/bin/python" -m pip install -q -r "$DYIDRE_ROOT/requirements-http2.txt"
fi

echo "[parse-ecapture] summarize TLS text"
python3 "$DYIDRE_ROOT/scripts/summarize_ecapture_tls.py" "$RUN_DIR" || true

echo "[parse-ecapture] decode HTTP/2 frames"
"$VENV_DIR/bin/python" "$DYIDRE_ROOT/scripts/decode_ecapture_http2.py" "$RUN_DIR" || true

echo "[parse-ecapture] extract request inventory"
"$VENV_DIR/bin/python" "$DYIDRE_ROOT/scripts/extract_ecapture_requests.py" "$RUN_DIR" || true

if [ -s "$RUN_DIR/capture.pcapng" ]; then
  echo "[parse-ecapture] summarize pcap transport"
  python3 "$DYIDRE_ROOT/scripts/summarize_ecapture_pcap.py" "$RUN_DIR/capture.pcapng" \
    --out-md "$RUN_DIR/pcap_summary.md" \
    --out-json "$RUN_DIR/pcap_summary.json" || true
fi

echo "[parse-ecapture] done: $RUN_DIR"
