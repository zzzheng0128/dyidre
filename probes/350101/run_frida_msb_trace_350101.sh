#!/usr/bin/env bash
set -euo pipefail

# Douyin 350101 MS.b 真机采集 runner（stock frida / rusda-server 路线）。
#
# 用法：
#   probes/350101/run_frida_msb_trace_350101.sh <tag> [package]
#   DRY_RUN=1 probes/350101/run_frida_msb_trace_350101.sh <tag>
#
# 流程：
#   1. 只读检查：adb 连接、root、目标包、.venv frida 版本；
#   2. 推送 rusda-server（hash 不一致才推）并确保在跑；
#   3. spawn 抖音并加载 gum_msb_trace_350101.js；
#   4. 输出归档到 runs/350101/msb_trace/<tag>/。
#
# 采集结束后用 Ctrl-C 退出 frida；日志已在 frida_console.log。

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
DYIDRE_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/../.." && pwd -P)"

TAG="${1:-}"
PKG="${2:-com.ss.android.ugc.aweme}"
DRY_RUN="${DRY_RUN:-0}"

if [[ -z "$TAG" ]]; then
  echo "usage: run_frida_msb_trace_350101.sh <tag> [package]" >&2
  exit 2
fi

PROBE_JS="${SCRIPT_DIR}/frida/gum_msb_trace_350101.js"
FRIDA_BIN="${FRIDA_BIN:-${DYIDRE_ROOT}/.venv/bin/frida}"
FRIDA_PS_BIN="${FRIDA_PS_BIN:-${DYIDRE_ROOT}/.venv/bin/frida-ps}"
RUSDA_LOCAL="${RUSDA_LOCAL:-${DYIDRE_ROOT}/rusda-server-17.15.0-android-arm64}"
RUSDA_REMOTE="${RUSDA_REMOTE:-/data/local/tmp/rusda-server}"
OUT_DIR="${DYIDRE_ROOT}/runs/350101/msb_trace/${TAG}"

die() { echo "[msb-trace] $*" >&2; exit 1; }

# adb 默认从 PATH 找；不在 PATH 时用 Android SDK 常见路径兜底。
# 注意必须解析成绝对路径，否则下面的 adb() 函数会无限递归。
ADB=""
if command -v adb >/dev/null 2>&1; then
  ADB="$(command -v adb)"
else
  for cand in "$HOME/Library/Android/sdk/platform-tools/adb" "$HOME/Android/platform-tools/adb"; do
    if [[ -x "$cand" ]]; then ADB="$cand"; break; fi
  done
fi
[[ -n "$ADB" && -x "$ADB" ]] || die "adb not found"
adb() { "$ADB" "$@"; }

[[ -f "$PROBE_JS" ]] || die "missing probe js: $PROBE_JS"
[[ -x "$FRIDA_BIN" ]] || die "missing frida cli: $FRIDA_BIN (expect .venv/bin/frida)"

echo "[msb-trace] readonly checks..."
adb get-state >/dev/null 2>&1 || die "no adb device"
abi="$(adb shell getprop ro.product.cpu.abi | tr -d '\r')"
[[ "$abi" == "arm64-v8a" ]] || die "device abi not arm64-v8a: $abi"
adb shell "su -c id" 2>/dev/null | grep -q "uid=0" || die "su root not available"
adb shell "pm list packages $PKG" 2>/dev/null | grep -q "$PKG" || die "package not installed: $PKG"
frida_ver="$("$FRIDA_BIN" --version)"
echo "[msb-trace] host frida=$frida_ver"

remote_sha="$(adb shell "su -c 'shasum -a 256 $RUSDA_REMOTE 2>/dev/null || sha256sum $RUSDA_REMOTE 2>/dev/null'" | awk '{print $1}' || true)"
local_sha="$(shasum -a 256 "$RUSDA_LOCAL" | awk '{print $1}')"
if [[ "$remote_sha" != "$local_sha" ]]; then
  echo "[msb-trace] push rusda-server -> $RUSDA_REMOTE"
  adb push "$RUSDA_LOCAL" "$RUSDA_REMOTE" >/dev/null
  adb shell "su -c 'chmod 755 $RUSDA_REMOTE'"
fi

if ! adb shell "su -c 'pgrep -f $RUSDA_REMOTE'" >/dev/null 2>&1; then
  echo "[msb-trace] start rusda-server on device"
  adb shell "su -c 'setsid $RUSDA_REMOTE >/data/local/tmp/rusda-server.log 2>&1 </dev/null &'"
  sleep 3
  adb shell "su -c 'pgrep -f $RUSDA_REMOTE'" >/dev/null 2>&1 || die "rusda-server failed to start"
fi

mkdir -p "$OUT_DIR"

{
  echo "# msb_trace run metadata"
  echo "tag=$TAG"
  echo "package=$PKG"
  echo "date=$(date '+%Y-%m-%d %H:%M:%S %z')"
  echo "host_frida=$frida_ver"
  echo "rusda_remote=$RUSDA_REMOTE"
  echo "rusda_sha256=$local_sha"
  echo "probe_js=$PROBE_JS"
  echo "probe_js_sha256=$(shasum -a 256 "$PROBE_JS" | awk '{print $1}')"
  echo "device_model=$(adb shell getprop ro.product.model | tr -d '\r')"
  echo "device_build=$(adb shell getprop ro.build.display.id | tr -d '\r')"
  echo "dyidre_git=$(git -C "$DYIDRE_ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"
} > "$OUT_DIR/run_metadata.txt"

if [[ "$DRY_RUN" == "1" ]]; then
  echo "[msb-trace] DRY_RUN=1, metadata written to $OUT_DIR, skip spawn"
  exit 0
fi

echo "[msb-trace] spawn $PKG with gum_msb_trace_350101.js"
echo "[msb-trace] output: $OUT_DIR/frida_console.log  (Ctrl-C to stop)"
# frida -q 会在 script 评估完就退出；非交互场景用 (sleep N; echo exit) 管道撑住
# REPL，DURATION 秒后自动退出。交互终端直接进 REPL，Ctrl-C 结束。
DURATION="${DURATION:-0}"
if [[ "$DURATION" -gt 0 ]]; then
  (sleep "$DURATION"; echo exit) | "$FRIDA_BIN" -U -f "$PKG" -l "$PROBE_JS" 2>&1 | tee "$OUT_DIR/frida_console.log"
else
  "$FRIDA_BIN" -U -f "$PKG" -l "$PROBE_JS" 2>&1 | tee "$OUT_DIR/frida_console.log"
fi

echo "[msb-trace] done: $OUT_DIR"
