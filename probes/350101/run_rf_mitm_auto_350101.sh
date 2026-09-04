#!/usr/bin/env bash
#
# 350101 一键真机样本采集流程（独立 SSL JS + host mitmproxy）。
#
# 这不是新的 hook 实现，而是把已经验证过的几个动作编排成一个可复跑入口：
#   1. 检查 ADB、单台设备、arm64、root、目标包和 host mitmdump；
#   2. 缺少 rustfrida 或版本不一致时，自动推送 tools/runtime_payloads/rustfrida；
#   3. 保存原代理，清理目标 App；
#   4. 启动 mitmdump，设置 Android 全局代理；
#   5. 直接推送独立 SSL JS，并以 RF spawn 模式启动；
#      也可设置 RF_ENGINE=frida，用 stock Frida client/server 做对照测试。
#   6. 进程出现后运行 auto_skip_popups.py：只点“同意/跳过”，不点敏感权限“允许”；
#   7. 采集结束后恢复原代理；默认只留下 mitm/latest/flows.mitm 和 README 摘要。
#      过程日志默认写入系统临时目录，只有 KEEP_LOGS=1 才复制到本次目录。
#
# 用法：
#   probes/350101/run_rf_mitm_auto_350101.sh [秒数] [标签]
#   probes/350101/run_rf_mitm_auto_350101.sh 180 req01
#   DRY_RUN=1 probes/350101/run_rf_mitm_auto_350101.sh 30 dry_check
#
# 常用环境变量（升级版本时通常只改 VERSION/PKG/JS）：
#   SERIAL=...              指定设备；不指定时必须恰好连接一台 device
#   PKG=com.ss.android.ugc.aweme
#   MITM_HOST=192.168.x.x  手机可访问的本机局域网地址；不指定时优先复用旧代理地址
#   MITM_PORT=8080          host mitmdump 监听端口
#   MITM_HTTP2=false         默认用 HTTP/1.1，避免 SDK POST body 在 HTTP/2 flow 中只落 header
#   APK_PATH=/path/app.apk  目标包不存在时，提供 APK 才会自动安装；不会猜 APK
#   AUTO_INSTALL=1          mitmdump 缺失时，macOS 有 brew 才自动 brew install mitmproxy
#   CLEAR_APP_DATA=1        默认 pm clear；设为 0 可跳过
#   FORCE_STOP_APP=1        默认采集前先停止目标进程；CLEAR_APP_DATA=1 时 pm clear 已包含停止
#   AUTO_SKIP=1             默认运行安全弹窗处理；设为 0 可跳过
#   POPUP_DURATION=45       弹窗扫描秒数，默认只覆盖启动阶段，避免全程 UI dump
#   KEEP_LOGS=0             默认不保留过程日志；设为 1 才保存排错日志和设备状态
#   KEEP_HISTORY=0          默认只保留 mitm 目录最新一次；设为 1 才保留历史 flow
#   VERIFY_TARGET_FLOWS=1   默认校验 /sdi/get_token、/ri/report 各至少有一条完整请求
#   SWIPE_AFTER=0           同意后多少秒开始滑动；0 表示不自动滑动
#   SWIPE_INTERVAL=30       自动滑动间隔
#   RESTORE_PROXY=1         退出时恢复采集前的全局代理
#   RF_LOCAL=...            本地 rustfrida 路径（默认 dyidre/tools/runtime_payloads/rustfrida）
#   RF_REMOTE=/data/local/tmp/rustfrida
#   RF_ENGINE=rustfrida     rustfrida 或 frida；frida 默认 attach，避免 stock Frida spawn 崩溃
#   FRIDA_BIN=...           host frida client（默认 dyidre/.venv-frida350/bin/frida 或 PATH）
#   FRIDA_SERVER_REMOTE=... 手机端 frida-server（默认 /data/local/tmp/frida-server-17.17.0）
#   FRIDA_MODE=attach       frida 模式下 attach 或 spawn；默认 attach
#   FRIDA_ATTACH_DELAY=10   正常启动 App 后延迟多少秒 attach
#   FRIDA_RUNTIME=qjs       stock Frida runtime
#   SSL_JS_LOCAL=...        独立 SSL JS（默认 probes/350101/runtime_ssl.js）
#   SSL_JS_REMOTE=...       手机端独立 SSL JS 路径（默认按本次 tag 命名）
#   SSL_JS_LOG_REMOTE=...   手机端 rustFrida/JS 实时输出路径（默认按本次 tag 命名）
#   RF_CONNECT_TIMEOUT=60   RF 等待 agent 连接的秒数
#   RF_SPAWN_SETCONTEXT_ONLY=1  默认跳过误命中的 setArgV0 slot，走 setcontext spawn
#   RF_POST_RESUME_JAVA_WORKER_MODE=skip  独立 SSL runtime 不使用 Java；默认跳过 RF Java worker
#
# 注意：
#   - root 是 RF spawn 方案的硬性条件；脚本只检查 su，不会替用户刷机/root。
#   - 证书不会自动安装到系统证书区。Douyin 的 pinning 由 SSL custom verify hook
#     处理；若只是观察 mitm UI，可手动安装 mitmproxy CA，但这不是本流程前提。
#   - 本脚本不再经过统一 MetaSec runner。为让 RF 能读取 spawn/proc 信息，会沿用
#     既有 runner 的 SELinux/proc 准备；结束后只恢复代理，不擅自恢复设备原 SELinux
#     状态；请在实验机使用。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DYIDRE_ROOT="${DYIDRE_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
VERSION="350101"
PKG="${PKG:-com.ss.android.ugc.aweme}"
RF_ENGINE="${RF_ENGINE:-rustfrida}"
RF_REMOTE="${RF_REMOTE:-/data/local/tmp/rustfrida}"
RF_LOCAL="${RF_LOCAL:-$DYIDRE_ROOT/tools/runtime_payloads/rustfrida}"
FRIDA_BIN="${FRIDA_BIN:-}"
FRIDA_SERVER_REMOTE="${FRIDA_SERVER_REMOTE:-/data/local/tmp/frida-server-17.17.0}"
FRIDA_MODE="${FRIDA_MODE:-attach}"
FRIDA_ATTACH_DELAY="${FRIDA_ATTACH_DELAY:-10}"
FRIDA_RUNTIME="${FRIDA_RUNTIME:-qjs}"
FRIDA_RESTART_SERVER="${FRIDA_RESTART_SERVER:-0}"
SSL_JS_LOCAL="${SSL_JS_LOCAL:-$DYIDRE_ROOT/probes/$VERSION/runtime_ssl.js}"
RF_CONNECT_TIMEOUT="${RF_CONNECT_TIMEOUT:-60}"
RF_SPAWN_SETCONTEXT_ONLY="${RF_SPAWN_SETCONTEXT_ONLY:-1}"
# 350101 standalone SSL runtime 是纯 native hook。当前设备上 RF post-resume Java
# worker 会让刚 fork 的 app SIGSEGV；和统一 runner 的 native-only 路径保持一致。
RF_POST_RESUME_JAVA_WORKER_MODE="${RF_POST_RESUME_JAVA_WORKER_MODE:-skip}"
POPUP_HELPER="$DYIDRE_ROOT/probes/common/auto_skip_popups.py"
MITM_PORT="${MITM_PORT:-8080}"
MITM_HOST="${MITM_HOST:-}"
MITM_HTTP2="${MITM_HTTP2:-false}"
AUTO_INSTALL="${AUTO_INSTALL:-1}"
CLEAR_APP_DATA="${CLEAR_APP_DATA:-1}"
FORCE_STOP_APP="${FORCE_STOP_APP:-1}"
AUTO_SKIP="${AUTO_SKIP:-1}"
POPUP_DURATION="${POPUP_DURATION:-45}"
KEEP_LOGS="${KEEP_LOGS:-0}"
KEEP_HISTORY="${KEEP_HISTORY:-0}"
VERIFY_TARGET_FLOWS="${VERIFY_TARGET_FLOWS:-1}"
SWIPE_AFTER="${SWIPE_AFTER:-0}"
SWIPE_INTERVAL="${SWIPE_INTERVAL:-30}"
RESTORE_PROXY="${RESTORE_PROXY:-1}"
DRY_RUN="${DRY_RUN:-0}"
SERIAL="${SERIAL:-}"

RUN_SECONDS="${1:-180}"
TAG="${2:-$(date +%Y%m%d_%H%M%S)}"
TAG_SAFE="$(printf '%s' "$TAG" | tr -c 'A-Za-z0-9_.-' '_')"
SSL_JS_REMOTE="${SSL_JS_REMOTE:-/data/local/tmp/metasec_ssl_single_${VERSION}_${TAG_SAFE}.js}"
SSL_JS_LOG_REMOTE="${SSL_JS_LOG_REMOTE:-/data/local/tmp/metasec_ssl_single_${VERSION}_${TAG_SAFE}.console.log}"

usage() {
  sed -n '1,70p' "$0"
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
esac

case "$RUN_SECONDS" in
  ''|*[!0-9]*)
    echo "[auto] 秒数必须是正整数：$RUN_SECONDS" >&2
    exit 2
    ;;
esac
if [ "$RUN_SECONDS" -lt 1 ]; then
  echo "[auto] 秒数必须 >= 1" >&2
  exit 2
fi
case "$POPUP_DURATION" in
  ''|*[!0-9]*)
    echo "[auto] POPUP_DURATION 必须是正整数：$POPUP_DURATION" >&2
    exit 2
    ;;
esac
if [ "$POPUP_DURATION" -lt 1 ]; then
  echo "[auto] POPUP_DURATION 必须 >= 1" >&2
  exit 2
fi
case "$RF_CONNECT_TIMEOUT" in
  ''|*[!0-9]*)
    echo "[auto] RF_CONNECT_TIMEOUT 必须是正整数：$RF_CONNECT_TIMEOUT" >&2
    exit 2
    ;;
esac
if [ "$RF_CONNECT_TIMEOUT" -lt 1 ]; then
  echo "[auto] RF_CONNECT_TIMEOUT 必须 >= 1" >&2
  exit 2
fi
case "$RF_ENGINE" in
  rustfrida|frida) ;;
  *) echo "[auto] RF_ENGINE 必须为 rustfrida 或 frida：$RF_ENGINE" >&2; exit 2 ;;
esac
case "$FRIDA_MODE" in
  attach|spawn) ;;
  *) echo "[auto] FRIDA_MODE 必须为 attach 或 spawn：$FRIDA_MODE" >&2; exit 2 ;;
esac
case "$FRIDA_ATTACH_DELAY" in
  ''|*[!0-9]*)
    echo "[auto] FRIDA_ATTACH_DELAY 必须是非负整数：$FRIDA_ATTACH_DELAY" >&2
    exit 2
    ;;
esac
case "$FRIDA_RUNTIME" in
  qjs|v8) ;;
  *) echo "[auto] FRIDA_RUNTIME 必须为 qjs 或 v8：$FRIDA_RUNTIME" >&2; exit 2 ;;
esac

case "$KEEP_HISTORY" in
  0|1) ;;
  *) echo "[auto] KEEP_HISTORY 必须为 0 或 1：$KEEP_HISTORY" >&2; exit 2 ;;
esac
case "$VERIFY_TARGET_FLOWS" in
  0|1) ;;
  *) echo "[auto] VERIFY_TARGET_FLOWS 必须为 0 或 1：$VERIFY_TARGET_FLOWS" >&2; exit 2 ;;
esac
case "$MITM_HTTP2" in
  true|false) ;;
  *) echo "[auto] MITM_HTTP2 必须为 true 或 false：$MITM_HTTP2" >&2; exit 2 ;;
esac
case "$DRY_RUN" in
  0|1) ;;
  *) echo "[auto] DRY_RUN 必须为 0 或 1：$DRY_RUN" >&2; exit 2 ;;
esac
case "$FORCE_STOP_APP" in
  0|1) ;;
  *) echo "[auto] FORCE_STOP_APP 必须为 0 或 1：$FORCE_STOP_APP" >&2; exit 2 ;;
esac
case "$RF_SPAWN_SETCONTEXT_ONLY" in
  0|1) ;;
  *) echo "[auto] RF_SPAWN_SETCONTEXT_ONLY 必须为 0 或 1：$RF_SPAWN_SETCONTEXT_ONLY" >&2; exit 2 ;;
esac
case "$FRIDA_RESTART_SERVER" in
  0|1) ;;
  *) echo "[auto] FRIDA_RESTART_SERVER 必须为 0 或 1：$FRIDA_RESTART_SERVER" >&2; exit 2 ;;
esac

if [ -z "${ADB:-}" ]; then
  if command -v adb >/dev/null 2>&1; then
    ADB="$(command -v adb)"
  elif [ -x "/Users/freeman/Library/Android/sdk/platform-tools/adb" ]; then
    ADB="/Users/freeman/Library/Android/sdk/platform-tools/adb"
  else
    echo "[auto] 找不到 adb；请设置 ADB=/path/to/adb" >&2
    exit 1
  fi
fi

if [ -n "${MITMDUMP:-}" ]; then
  MITMDUMP="$MITMDUMP"
elif command -v mitmdump >/dev/null 2>&1; then
  MITMDUMP="$(command -v mitmdump)"
elif [ -x "/opt/homebrew/bin/mitmdump" ]; then
  MITMDUMP="/opt/homebrew/bin/mitmdump"
elif [ "$AUTO_INSTALL" = "1" ] && command -v brew >/dev/null 2>&1; then
  echo "[auto] host 未找到 mitmdump，尝试 brew install mitmproxy"
  brew install mitmproxy
  MITMDUMP="$(command -v mitmdump)"
else
  echo "[auto] 找不到 mitmdump；请安装 mitmproxy 或设置 MITMDUMP=/path/to/mitmdump" >&2
  exit 1
fi

if [ "$RF_ENGINE" = "rustfrida" ]; then
  if [ ! -x "$RF_LOCAL" ]; then
    echo "[auto] 本地 rustfrida 不存在或不可执行：$RF_LOCAL" >&2
    exit 1
  fi
else
  if [ -z "$FRIDA_BIN" ]; then
    if [ -x "$DYIDRE_ROOT/.venv-frida350/bin/frida" ]; then
      FRIDA_BIN="$DYIDRE_ROOT/.venv-frida350/bin/frida"
    elif command -v frida >/dev/null 2>&1; then
      FRIDA_BIN="$(command -v frida)"
    else
      echo "[auto] 找不到 host frida；请设置 FRIDA_BIN=/path/to/frida，或先安装 dyidre/.venv-frida350" >&2
      exit 1
    fi
  fi
  if [ ! -x "$FRIDA_BIN" ]; then
    echo "[auto] host frida 不存在或不可执行：$FRIDA_BIN" >&2
    exit 1
  fi
fi
if [ ! -f "$SSL_JS_LOCAL" ]; then
  echo "[auto] 独立 SSL JS 不存在：$SSL_JS_LOCAL" >&2
  exit 1
fi
if [ ! -f "$POPUP_HELPER" ]; then
  echo "[auto] 弹窗脚本不存在：$POPUP_HELPER" >&2
  exit 1
fi
TARGET_FLOW_VALIDATOR="$DYIDRE_ROOT/scripts/validate_mitm_target_flows.py"
if [ "$VERIFY_TARGET_FLOWS" = "1" ] && [ ! -f "$TARGET_FLOW_VALIDATOR" ]; then
  echo "[auto] 目标请求校验脚本不存在：$TARGET_FLOW_VALIDATOR" >&2
  exit 1
fi

adb_call() {
  # 在尚未选定 serial 时直接调用 adb；选定后所有命令都锁定同一设备。
  if [ -n "$SERIAL" ]; then
    "$ADB" -s "$SERIAL" "$@"
  else
    "$ADB" "$@"
  fi
}

adb_shell() {
  adb_call shell "$@"
}

sha256_file() {
  # macOS 默认是 shasum，Linux 常见的是 sha256sum；统一成纯 hash 输出。
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  elif command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    fail "找不到 shasum/sha256sum，无法校验 rustfrida"
  fi
}

fail() {
  echo "[auto] ERROR: $*" >&2
  exit 1
}

frida_client_can_connect() {
  [ "$RF_ENGINE" = "frida" ] || return 1
  [ -n "$FRIDA_BIN" ] || return 1
  [ -n "$SERIAL" ] || return 1
  "$FRIDA_BIN" -D "$SERIAL" ps >/dev/null 2>&1 &
  local client_pid="$!"
  local waited=0
  while kill -0 "$client_pid" >/dev/null 2>&1; do
    if [ "$waited" -ge 6 ]; then
      kill "$client_pid" >/dev/null 2>&1 || true
      wait "$client_pid" >/dev/null 2>&1 || true
      return 1
    fi
    sleep 1
    waited=$((waited + 1))
  done
  wait "$client_pid" >/dev/null 2>&1
}

echo "[auto] ADB=$ADB"
echo "[auto] mitmdump=$MITMDUMP"
echo "[auto] engine=$RF_ENGINE"
if [ "$RF_ENGINE" = "frida" ]; then
  echo "[auto] frida_bin=$FRIDA_BIN"
  echo "[auto] frida_server=$FRIDA_SERVER_REMOTE mode=$FRIDA_MODE attach_delay=${FRIDA_ATTACH_DELAY}s runtime=$FRIDA_RUNTIME"
fi

# 设备选择：避免把 hook 推到错误的手机。
connected_devices="$(adb_call devices 2>/dev/null | awk 'NR > 1 && $2 == "device" {print $1}')" || fail "adb devices 失败"
device_count="$(printf '%s\n' "$connected_devices" | awk 'NF {n++} END {print n + 0}')"
if [ -z "$SERIAL" ]; then
  [ "$device_count" -eq 1 ] || fail "需要恰好一台在线设备，当前 device 数量=${device_count}；请设置 SERIAL=..."
  SERIAL="$(printf '%s\n' "$connected_devices" | awk 'NF {print; exit}')"
else
  printf '%s\n' "$connected_devices" | awk -v s="$SERIAL" '$0 == s {found=1} END {exit(found ? 0 : 1)}' \
    || fail "指定设备不在线或未授权：$SERIAL"
fi
echo "[auto] serial=$SERIAL"

device_abi="$(adb_shell getprop ro.product.cpu.abilist 2>/dev/null | tr -d '\r' || true)"
printf '%s' "$device_abi" | grep -Eq '(^|,)(arm64-v8a|arm64)(,|$)' \
  || fail "设备不是 arm64 ABI：$device_abi"

root_id="$(adb_shell su -M -c id 2>/dev/null | tr -d '\r' || true)"
printf '%s' "$root_id" | grep -q 'uid=0' \
  || fail "su root 不可用（返回：${root_id}）；RF spawn 需要 root"

if ! command -v python3 >/dev/null 2>&1; then
  fail "找不到 python3，弹窗自动处理需要它"
fi

pkg_path="$(adb_shell pm path "$PKG" 2>/dev/null | tr -d '\r' || true)"
if [ -z "$pkg_path" ]; then
  if [ -n "${APK_PATH:-}" ] && [ -f "$APK_PATH" ]; then
    echo "[auto] 目标包未安装，安装 APK=$APK_PATH"
    adb_call install -r -d "$APK_PATH" >/dev/null || fail "APK 安装失败"
    pkg_path="$(adb_shell pm path "$PKG" 2>/dev/null | tr -d '\r' || true)"
  else
    fail "目标包 $PKG 未安装；设置 APK_PATH=/path/to.apk 后再运行"
  fi
fi

local_hash="<not-used>"
remote_hash="<not-used>"
if [ "$RF_ENGINE" = "rustfrida" ]; then
  local_hash="$(sha256_file "$RF_LOCAL")"
  remote_hash="$(adb_shell su -M -c "sha256sum '$RF_REMOTE' 2>/dev/null" | tr -d '\r' | awk '{print $1}' || true)"
  if [ "$local_hash" != "$remote_hash" ]; then
    echo "[auto] rustfrida 不存在或 hash 不同，推送到 $RF_REMOTE"
    adb_call push "$RF_LOCAL" "$RF_REMOTE" >/dev/null || fail "rustfrida 推送失败"
  else
    echo "[auto] rustfrida 已存在且 hash 一致：$local_hash"
  fi
  adb_shell su -M -c "chmod 755 '$RF_REMOTE'" >/dev/null || fail "无法 chmod rustfrida"
else
  frida_server_name="$(basename "$FRIDA_SERVER_REMOTE")"
  frida_server_exists="$(adb_shell "su -c 'test -f \"$FRIDA_SERVER_REMOTE\" && echo yes || true'" | tr -d '\r' | tail -n 1 || true)"
  [ "$frida_server_exists" = "yes" ] || fail "手机端 frida-server 不存在：$FRIDA_SERVER_REMOTE"
  adb_shell "su -c 'chmod 755 \"$FRIDA_SERVER_REMOTE\"'" >/dev/null || fail "无法 chmod frida-server"
  if [ "$FRIDA_RESTART_SERVER" = "1" ]; then
    adb_shell "su -c 'killall \"$frida_server_name\" 2>/dev/null || true; killall frida-server 2>/dev/null || true'" >/dev/null 2>&1 || true
  fi
  frida_server_pids="$(adb_shell "su -c 'pidof \"$frida_server_name\" 2>/dev/null || pidof frida-server 2>/dev/null || true'" | tr -d '\r' | awk '{print $1}' || true)"
  if [ -z "$frida_server_pids" ] && frida_client_can_connect; then
    frida_server_pids="frida-ps-ok"
  fi
  if [ -z "$frida_server_pids" ]; then
    echo "[auto] 启动 frida-server：$FRIDA_SERVER_REMOTE"
    adb_shell "su -c 'cd /data/local/tmp; nohup \"$FRIDA_SERVER_REMOTE\" >\"/data/local/tmp/${frida_server_name}.log\" 2>&1 </dev/null &'" >/dev/null 2>&1 || true
    for _ in $(seq 1 20); do
      frida_server_pids="$(adb_shell "su -c 'pidof \"$frida_server_name\" 2>/dev/null || pidof frida-server 2>/dev/null || true'" | tr -d '\r' | awk '{print $1}' || true)"
      if [ -z "$frida_server_pids" ] && frida_client_can_connect; then
        frida_server_pids="frida-ps-ok"
      fi
      [ -n "$frida_server_pids" ] && break
      sleep 0.5
    done
  fi
  [ -n "$frida_server_pids" ] || fail "frida-server 未启动，查看 /data/local/tmp/${frida_server_name}.log"
  echo "[auto] frida-server pid=$frida_server_pids"
fi

# flow 是唯一默认产物；RF/弹窗/mitmdump 过程日志放临时目录，避免 runs/ 继续膨胀。
# 正式运行固定写入 mitm/latest；只有 KEEP_HISTORY=1 才使用传入的 TAG。
MITM_ROOT="$DYIDRE_ROOT/runs/$VERSION/mitm"
if [ "$DRY_RUN" = "1" ]; then
  RUN_DIR="$MITM_ROOT/.dry-$TAG"
elif [ "$KEEP_HISTORY" = "1" ]; then
  RUN_DIR="$MITM_ROOT/$TAG"
else
  RUN_DIR="$MITM_ROOT/latest"
fi
RF_TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dyidre_rf_${VERSION}_${TAG}.XXXXXX")"
MITM_FLOW="$RUN_DIR/flows.mitm"
TARGET_FLOW_REPORT="$RUN_DIR/target_request_validation.json"
MITM_LOG="$RF_TMP_ROOT/mitmdump.log"
RF_LOG="$RF_TMP_ROOT/rf_runner.console.log"
POPUP_LOG="$RF_TMP_ROOT/auto_skip_popups.log"

capture_state() {
  out="$1"
  {
    echo "# captured_at=$(date '+%Y-%m-%d %H:%M:%S %z')"
    echo "## adb devices"
    adb_call devices -l 2>&1 || true
    echo "## id"
    adb_shell id 2>&1 || true
    echo "## su id"
    adb_shell su -M -c id 2>&1 || true
    echo "## abi"
    adb_shell getprop ro.product.cpu.abilist 2>&1 || true
    echo "## model"
    adb_shell getprop ro.product.model 2>&1 || true
    echo "## selinux"
    adb_shell getenforce 2>&1 || true
    echo "## proxy"
    adb_shell settings get global http_proxy 2>&1 || true
    echo "## package"
    adb_shell pm path "$PKG" 2>&1 || true
    echo "## app pid"
    adb_shell pidof "$PKG" 2>&1 || true
  } > "$out"
}

OLD_PROXY="$(adb_shell settings get global http_proxy 2>/dev/null | tr -d '\r' | tail -n 1 || true)"
[ "$OLD_PROXY" = "null" ] && OLD_PROXY=""

if [ -z "$MITM_HOST" ]; then
  # 旧代理通常就是这台 Mac 的局域网地址，优先复用可达地址。
  case "$OLD_PROXY" in
    *:*)
      candidate="${OLD_PROXY%:*}"
      case "$candidate" in
        127.*|0.0.0.0|"" ) ;;
        *) MITM_HOST="$candidate" ;;
      esac
      ;;
  esac
fi
if [ -z "$MITM_HOST" ]; then
  for iface in en0 en1; do
    if command -v ipconfig >/dev/null 2>&1; then
      candidate="$(ipconfig getifaddr "$iface" 2>/dev/null || true)"
      if [ -n "$candidate" ]; then MITM_HOST="$candidate"; break; fi
    fi
  done
fi
[ -n "$MITM_HOST" ] || fail "无法确定手机可访问的 MITM_HOST，请设置 MITM_HOST=局域网IP"
case "$MITM_HOST" in
  127.*|0.0.0.0|localhost) fail "MITM_HOST=$MITM_HOST 不可从手机访问" ;;
esac
NEW_PROXY="$MITM_HOST:$MITM_PORT"
# 端口已占用时不要先清理现有 latest 样本，避免失败运行把可用数据删掉。
# 干跑不需要端口空闲检查。
if [ "$DRY_RUN" != "1" ] && command -v lsof >/dev/null 2>&1 && lsof -nP -iTCP:"$MITM_PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  fail "端口 $MITM_PORT 已被占用；设置 MITM_PORT=其它端口或先停止占用者"
fi
# 正式运行默认清空旧的 mitm 批次，再创建唯一的 latest 目录。
# 干跑不触碰已有样本；KEEP_HISTORY=1 时由调用者自行管理 tag。
if [ "$DRY_RUN" != "1" ] && [ "$KEEP_HISTORY" != "1" ]; then
  for old_run in "$MITM_ROOT"/*; do
    [ -d "$old_run" ] || continue
    rm -rf "$old_run"
  done
fi
mkdir -p "$RUN_DIR"
if [ "$KEEP_LOGS" = "1" ]; then
  capture_state "$RUN_DIR/device_state_before.txt"
fi
if [ "$KEEP_LOGS" = "1" ]; then
  {
    echo "version=$VERSION"
    echo "tag=$TAG"
    echo "seconds=$RUN_SECONDS"
    echo "serial=$SERIAL"
    echo "package=$PKG"
    echo "old_proxy=${OLD_PROXY:-<empty>}"
    echo "mitm_host_resolved=$MITM_HOST"
    echo "mitm_proxy=$NEW_PROXY"
    echo "mitm_http2=$MITM_HTTP2"
    echo "clear_app_data=$CLEAR_APP_DATA"
    echo "force_stop_app=$FORCE_STOP_APP"
    echo "auto_skip=$AUTO_SKIP"
    echo "popup_duration=$POPUP_DURATION"
    echo "verify_target_flows=$VERIFY_TARGET_FLOWS"
    echo "swipe_after=$SWIPE_AFTER"
    echo "swipe_interval=$SWIPE_INTERVAL"
    echo "engine=$RF_ENGINE"
    echo "rustfrida_local_sha256=$local_hash"
    echo "rustfrida_remote_sha256_before=${remote_hash:-<missing>}"
    echo "frida_bin=$FRIDA_BIN"
    echo "frida_server_remote=$FRIDA_SERVER_REMOTE"
    echo "frida_mode=$FRIDA_MODE"
    echo "frida_attach_delay=$FRIDA_ATTACH_DELAY"
    echo "frida_runtime=$FRIDA_RUNTIME"
    echo "ssl_js_local=$SSL_JS_LOCAL"
    echo "ssl_js_remote=$SSL_JS_REMOTE"
    echo "ssl_js_log_remote=$SSL_JS_LOG_REMOTE"
    echo "rf_connect_timeout=$RF_CONNECT_TIMEOUT"
    echo "rf_spawn_setcontext_only=$RF_SPAWN_SETCONTEXT_ONLY"
    echo "rf_post_resume_java_worker_mode=$RF_POST_RESUME_JAVA_WORKER_MODE"
  } > "$RUN_DIR/run_parameters.txt"
fi

MITM_PID=""
RF_PID=""
POPUP_PID=""
PROXY_CHANGED=0
RUN_RESULT="not-started"
RF_STATUS=0

restore_proxy() {
  [ "$RESTORE_PROXY" = "1" ] || return 0
  if [ -n "$OLD_PROXY" ]; then
    adb_shell settings put global http_proxy "$OLD_PROXY" >/dev/null 2>&1 || true
  else
    # Android 使用 :0 表示清空全局 HTTP 代理；不删除其它 settings。
    adb_shell settings put global http_proxy :0 >/dev/null 2>&1 || true
  fi
}

stop_mitmdump() {
  [ -n "$MITM_PID" ] || return 0
  # SIGINT is mitmproxy's normal shutdown path: it closes active flows and
  # flushes the flow writer before exiting.  SIGTERM without wait can leave a
  # flow containing HTTP headers but not the already received request body.
  kill -INT "$MITM_PID" >/dev/null 2>&1 || true
  wait "$MITM_PID" >/dev/null 2>&1 || true
  MITM_PID=""
}

cleanup() {
  status="$?"
  set +e
  if [ -n "$POPUP_PID" ]; then kill "$POPUP_PID" >/dev/null 2>&1 || true; fi
  if [ -n "$RF_PID" ]; then kill "$RF_PID" >/dev/null 2>&1 || true; fi
  stop_mitmdump
  restore_proxy
  # 独立 JS 的标准输出写在手机端，采集结束时再合并回 host 过程日志。
  # exec-out 保留原始字节，不受 adb shell 终端格式影响。
  adb_call exec-out su -M -c "cat '$SSL_JS_LOG_REMOTE' 2>/dev/null" >> "$RF_LOG" 2>/dev/null || true
  if [ "$KEEP_LOGS" = "1" ]; then
    capture_state "$RUN_DIR/device_state_after.txt"
    [ -f "$MITM_LOG" ] && cp "$MITM_LOG" "$RUN_DIR/mitmdump.log"
    [ -f "$RF_LOG" ] && cp "$RF_LOG" "$RUN_DIR/rf_runner.console.log"
    [ -f "$POPUP_LOG" ] && cp "$POPUP_LOG" "$RUN_DIR/auto_skip_popups.log"
  fi
  # 干跑只验证环境，不产生 runs 目录；否则自测目录会污染正式样本。
  if [ "$DRY_RUN" = "1" ]; then
    rm -rf "$RUN_DIR"
    rm -rf "$RF_TMP_ROOT"
    return 0
  fi
  {
    echo "# 350101 自动采集摘要"
    echo
    echo "- result: $RUN_RESULT"
    echo "- exit_status: $status"
    echo "- serial: $SERIAL"
    echo "- package: $PKG"
    echo "- seconds: $RUN_SECONDS"
    echo "- tag: $TAG"
    echo "- engine: $RF_ENGINE"
    if [ "$RF_ENGINE" = "frida" ]; then
      echo "- frida_bin: $FRIDA_BIN"
      echo "- frida_server: $FRIDA_SERVER_REMOTE"
      echo "- frida_mode: $FRIDA_MODE"
      echo "- frida_attach_delay: ${FRIDA_ATTACH_DELAY}s"
      echo "- frida_runtime: $FRIDA_RUNTIME"
    fi
    echo "- mitm_proxy: $NEW_PROXY"
    echo "- old_proxy: ${OLD_PROXY:-<empty>}"
    echo "- proxy_restored: $RESTORE_PROXY"
    echo "- clear_app_data: $CLEAR_APP_DATA"
    echo "- force_stop_app: $FORCE_STOP_APP"
    if [ "$RF_ENGINE" = "rustfrida" ]; then
      echo "- rustfrida_local_sha256: $local_hash"
      echo "- rustfrida_remote_sha256_before: ${remote_hash:-<missing>}"
    fi
    echo "- ssl_js_local: $SSL_JS_LOCAL"
    echo "- ssl_js_remote: $SSL_JS_REMOTE"
    echo "- ssl_js_log_remote: ${SSL_JS_LOG_REMOTE}（手机端实时日志）"
    echo
    echo "## 产物"
    echo
    echo "- flows.mitm：唯一默认数据产物，可用 mitmweb -r 查看。"
    if [ "$VERIFY_TARGET_FLOWS" = "1" ]; then
      echo "- target_request_validation.json：/sdi/get_token 与 /ri/report 的 header/body 完整性校验。"
    fi
    if [ "$KEEP_LOGS" = "1" ]; then
      echo "- run_parameters.txt / device_state_*.txt：本次参数和设备前后状态。"
      echo "- mitmdump.log / rf_runner.console.log / auto_skip_popups.log：排错日志。"
    else
      echo "- 过程日志默认不落盘；需要排错时用 KEEP_LOGS=1 重跑。"
    fi
    echo
    echo "## 复核"
    echo
    echo "先确认代理已恢复，再用 mitmweb -r flows.mitm 查看样本。"
  } > "$RUN_DIR/README.md"
  # 无论是自然结束还是 Ctrl-C，都把最终产物明确打印到终端，避免用户以为没有保存。
  if [ -s "$MITM_FLOW" ]; then
    flow_bytes="$(wc -c < "$MITM_FLOW" | tr -d ' ')"
    echo "[auto] 样本已保存：$MITM_FLOW (${flow_bytes} bytes)"
  else
    echo "[auto] 警告：未生成 flows.mitm，目录：$RUN_DIR" >&2
  fi
  echo "[auto] 结果摘要：$RUN_DIR/README.md"
  # 临时目录只包含本次过程日志，结束后安全删除。
  rm -rf "$RF_TMP_ROOT"
}
trap cleanup EXIT

# Ctrl-C/TERM 先转成可记录的中断退出，再由 EXIT trap 统一停止子进程、恢复代理并打印产物。
on_interrupt() {
  RUN_RESULT="interrupted"
  echo "[auto] 收到中断信号，正在保存当前 flow 并恢复代理..." >&2
  exit 130
}
trap on_interrupt INT TERM

if [ "$DRY_RUN" = "1" ]; then
  RUN_RESULT="dry-run-ok"
  echo "[auto] DRY_RUN=1：已完成设备/工具/哈希检查，不会清理 App、改代理或启动采集"
  exit 0
fi

if [ "$CLEAR_APP_DATA" = "1" ]; then
  echo "[auto] pm clear $PKG"
  adb_shell pm clear "$PKG" >/dev/null || fail "pm clear 失败"
elif [ "$FORCE_STOP_APP" = "1" ]; then
  echo "[auto] force-stop $PKG"
  adb_shell am force-stop "$PKG" >/dev/null || fail "force-stop 失败"
fi

echo "[auto] 启动 mitmdump：$NEW_PROXY"
"$MITMDUMP" \
  --listen-host 0.0.0.0 \
  --listen-port "$MITM_PORT" \
  --set block_global=false \
  --set ssl_insecure=true \
  --set "http2=$MITM_HTTP2" \
  -w "$MITM_FLOW" > "$MITM_LOG" 2>&1 &
MITM_PID="$!"
sleep 2
kill -0 "$MITM_PID" >/dev/null 2>&1 || fail "mitmdump 启动失败，查看 $MITM_LOG"

echo "[auto] 设置 Android 全局代理：$NEW_PROXY"
adb_shell settings put global http_proxy "$NEW_PROXY" >/dev/null || fail "设置代理失败"
PROXY_CHANGED=1

if [ "$RF_ENGINE" = "rustfrida" ]; then
  echo "[auto] 推送独立 SSL JS：$SSL_JS_LOCAL -> $SSL_JS_REMOTE"
  adb_call push "$SSL_JS_LOCAL" "$SSL_JS_REMOTE" >/dev/null || fail "独立 SSL JS 推送失败"

  # 与 run_metasec_probe_350101.sh 的 spawn 前准备保持一致。这里不启动统一 runner，
  # 只让 rustFrida 加载上面指定的独立 SSL runtime JS。
  adb_shell "su -M -c 'chmod 644 \"$SSL_JS_REMOTE\"; rm -f \"$SSL_JS_LOG_REMOTE\"; : > \"$SSL_JS_LOG_REMOTE\"; chmod 644 \"$SSL_JS_LOG_REMOTE\"; setenforce 0; mount -o remount,hidepid=0,gid=3009 /proc 2>/dev/null || true'" \
    >/dev/null || true

  echo "[auto] rustfrida spawn 独立 SSL JS，host 过程输出：$RF_LOG"
  echo "[auto] JS 手机端实时日志：$SSL_JS_LOG_REMOTE"
  echo "[auto] 实时查看：$ADB -s $SERIAL shell su -M -c 'tail -f $SSL_JS_LOG_REMOTE'"
  (
    sleep "$RUN_SECONDS"
    printf 'exit\n'
  ) | adb_call shell "su -M -c \"cd /data/local/tmp && RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME='1' RF_DIAG_ZYM_NO_SETARGV0='$RF_SPAWN_SETCONTEXT_ONLY' RF_POST_RESUME_JAVA_WORKER_MODE='$RF_POST_RESUME_JAVA_WORKER_MODE' '$RF_REMOTE' --connect-timeout '$RF_CONNECT_TIMEOUT' --spawn '$PKG' -l '$SSL_JS_REMOTE' > '$SSL_JS_LOG_REMOTE' 2>&1\"" \
    > "$RF_LOG" 2>&1 &
  RF_PID="$!"
else
  echo "[auto] stock Frida 加载独立 SSL JS：$SSL_JS_LOCAL"
  echo "[auto] stock Frida host 过程输出：$RF_LOG"
  adb_shell "su -M -c 'setenforce 0; mount -o remount,hidepid=0,gid=3009 /proc 2>/dev/null || true; rm -f \"$SSL_JS_LOG_REMOTE\"; : > \"$SSL_JS_LOG_REMOTE\"; chmod 644 \"$SSL_JS_LOG_REMOTE\"'" \
    >/dev/null || true
  if [ "$FRIDA_MODE" = "attach" ]; then
    echo "[auto] frida attach：先正常启动 ${PKG}，${FRIDA_ATTACH_DELAY}s 后 attach"
    adb_shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null || fail "启动 App 失败"
    sleep "$FRIDA_ATTACH_DELAY"
    TARGET_PID=""
    for _ in $(seq 1 20); do
      TARGET_PID="$(adb_shell pidof "$PKG" 2>/dev/null | tr -d '\r' | awk '{print $1}' || true)"
      [ -n "$TARGET_PID" ] && break
      sleep 1
    done
    [ -n "$TARGET_PID" ] || fail "frida attach 前未找到目标进程：$PKG"
    echo "[auto] frida attach pid=$TARGET_PID"
    (
      sleep "$RUN_SECONDS"
      printf 'exit\n'
    ) | "$FRIDA_BIN" -D "$SERIAL" -p "$TARGET_PID" -l "$SSL_JS_LOCAL" --runtime "$FRIDA_RUNTIME" \
      > "$RF_LOG" 2>&1 &
    RF_PID="$!"
  else
    echo "[auto] frida spawn 独立 SSL JS；注意：当前样本 stock Frida spawn 曾复现 no-op 崩溃"
    (
      sleep "$RUN_SECONDS"
      printf 'exit\n'
    ) | "$FRIDA_BIN" -D "$SERIAL" -f "$PKG" -l "$SSL_JS_LOCAL" --runtime "$FRIDA_RUNTIME" \
      > "$RF_LOG" 2>&1 &
    RF_PID="$!"
  fi
fi

# 等待 RF spawn 产生目标进程后再启动 UI 弹窗处理，避免对旧进程误点。
app_seen=0
for _ in $(seq 1 45); do
  if adb_shell pidof "$PKG" 2>/dev/null | tr -d '\r' | grep -q '[0-9]'; then
    app_seen=1
    break
  fi
  if ! kill -0 "$RF_PID" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

if [ "$AUTO_SKIP" = "1" ] && [ "$app_seen" = "1" ]; then
  echo "[auto] 启动安全弹窗处理（不授予敏感权限）"
  popup_seconds="$POPUP_DURATION"
  if [ "$popup_seconds" -gt "$RUN_SECONDS" ]; then popup_seconds="$RUN_SECONDS"; fi
  (
    # -u 保证即使采集提前结束，popup 日志也能留下已经点击的按钮。
    ADB="$ADB" SERIAL="$SERIAL" python3 -u "$POPUP_HELPER" \
      --adb "$ADB" \
      --serial "$SERIAL" \
      --duration "$popup_seconds" \
      --swipe-after "$SWIPE_AFTER" \
      --swipe-interval "$SWIPE_INTERVAL"
  ) > "$POPUP_LOG" 2>&1 &
  POPUP_PID="$!"
elif [ "$AUTO_SKIP" = "1" ]; then
  echo "[auto] 未观察到 $PKG PID，跳过弹窗脚本；继续等待 RF" | tee "$POPUP_LOG"
else
  echo "[auto] AUTO_SKIP=0，跳过弹窗处理" | tee "$POPUP_LOG"
fi

if wait "$RF_PID"; then
  RF_STATUS=0
else
  RF_STATUS="$?"
fi
RF_PID=""

if [ -n "$POPUP_PID" ]; then
  kill "$POPUP_PID" >/dev/null 2>&1 || true
  wait "$POPUP_PID" >/dev/null 2>&1 || true
  POPUP_PID=""
fi

# mitmproxy 需要收到中断并退出后才会完整写回最后的 HTTP body。先让它
# 正常结束，再读取 flow 做目标接口校验；不能在仍在写文件时直接回放。
stop_mitmdump

if [ "$RF_STATUS" -eq 0 ] && [ -s "$MITM_FLOW" ]; then
  RUN_RESULT="ok"
elif [ "$RF_STATUS" -eq 0 ]; then
  RUN_RESULT="rf-ok-mitm-flow-empty"
else
  RUN_RESULT="rf-failed"
fi
if [ "$RUN_RESULT" = "ok" ] && [ "$VERIFY_TARGET_FLOWS" = "1" ]; then
  echo "[auto] 校验 get_token / report 请求 header 与 body 完整性"
  if "$MITMDUMP" -q -nr "$MITM_FLOW" -s "$TARGET_FLOW_VALIDATOR" > "$TARGET_FLOW_REPORT" 2> "$RF_TMP_ROOT/target_flow_validation.stderr" \
    && grep -q '"valid":true' "$TARGET_FLOW_REPORT"; then
    echo "[auto] 目标请求校验通过：$TARGET_FLOW_REPORT"
  else
    RUN_RESULT="target-flows-invalid"
    RF_STATUS=1
    echo "[auto] ERROR: get_token / report 未同时捕获到 header/body 完整的请求；详情：$TARGET_FLOW_REPORT" >&2
  fi
fi
echo "[auto] 采集结束：result=$RUN_RESULT"
echo "[auto] 目录：$RUN_DIR"
exit "$RF_STATUS"
