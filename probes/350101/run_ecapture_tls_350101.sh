#!/usr/bin/env bash
# dyidre 350101 eCapture TLS 明文采集入口。
#
# 这个脚本和 run_metasec_probe_350101.sh 不同：
#   - run_metasec_probe_350101.sh 走 rustFrida/Frida JS，会注入目标进程；
#   - 本脚本走 eCapture/eBPF uprobe，不注入目标进程，只在内核侧挂 SSL_read/SSL_write。
#
# 默认用途：
#   抓一条或几条真实网络请求，作为“真机 HTTP 明文基准”。
#
# 用法：
#   probes/350101/run_ecapture_tls_350101.sh [text|pcap|keylog] [seconds] [tag]
#
# 推荐：
#   probes/350101/run_ecapture_tls_350101.sh text 60 req01_ecap
#
# 可选环境变量：
#   PKG=com.ss.android.ugc.aweme            目标包名
#   ECAPTURE_PID=12345                     手动指定 pid；不指定就自动 pidof
#   START_APP=0                            pid 不存在时是否自动 monkey 启动，默认 0；样本采集建议手动打开 App
#   FOREGROUND_APP=0                       pid 存在时是否 monkey 拉到前台，默认 0
#   CAPTURE_FROM_LAUNCH=0                  pcap/keylog 专用：先停 App，先启动 eCapture，再启动 App
#   PID_FILTER=1                           是否给 eCapture 加 --pid；CAPTURE_FROM_LAUNCH=1 时自动关闭
#   LIBSSL_REMOTE=/path/libttboringssl.so   手动指定目标进程实际 mmap 的 libttboringssl.so
#   ECAPTURE_SSL_VERSION=boringssl_a_13     手动指定 eCapture BoringSSL bytecode 版本
#   ECAPTURE_HEX=1                          text 模式用 --hex 输出，方便离线 HTTP/2/HPACK 解析
#   BTF_MODE=0                             eCapture -b 参数：0 auto，1 core，2 non-core
#   TRUNCATE_SIZE=0                         text 模式截断长度；0 表示不截断
#   IFACE=wlan0                            pcap 模式网卡；不指定会自动猜
#   KEEP_HISTORY=0                          默认只保留 ecapture/latest；设为 1 才按 tag 保留历史
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DYIDRE_ROOT="${DYIDRE_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
VERSION="350101"

if [ -z "${ADB:-}" ]; then
  if command -v adb >/dev/null 2>&1; then
    ADB="$(command -v adb)"
  elif [ -x "$HOME/Library/Android/sdk/platform-tools/adb" ]; then
    ADB="$HOME/Library/Android/sdk/platform-tools/adb"
  else
    ADB="adb"
  fi
fi

PKG="${PKG:-com.ss.android.ugc.aweme}"
ECAPTURE_LOCAL="${ECAPTURE_LOCAL:-$DYIDRE_ROOT/tools/runtime_payloads/ecapture}"
ECAPTURE_REMOTE="${ECAPTURE_REMOTE:-/data/local/tmp/ecapture}"
MODE="${1:-text}"
RUN_SECONDS="${2:-60}"
TAG="${3:-$(date +%Y%m%d_%H%M%S)}"
BTF_MODE="${BTF_MODE:-0}"
TRUNCATE_SIZE="${TRUNCATE_SIZE:-0}"
ECAPTURE_SSL_VERSION="${ECAPTURE_SSL_VERSION:-boringssl_a_13}"
ECAPTURE_HEX="${ECAPTURE_HEX:-1}"
START_APP="${START_APP:-0}"
FOREGROUND_APP="${FOREGROUND_APP:-0}"
CAPTURE_FROM_LAUNCH="${CAPTURE_FROM_LAUNCH:-0}"
PID_FILTER="${PID_FILTER:-1}"
KEEP_HISTORY="${KEEP_HISTORY:-0}"
DRY_RUN="${DRY_RUN:-0}"

if [ "$CAPTURE_FROM_LAUNCH" = "1" ]; then
  PID_FILTER=0
fi

usage() {
  cat <<'EOF'
用法：
  probes/350101/run_ecapture_tls_350101.sh [text|pcap|keylog] [seconds] [tag]

例子：
  # 推荐：旁路抓 TLS 明文，并让 eCapture 尝试解析 HTTP/1.1/HTTP/2。
  probes/350101/run_ecapture_tls_350101.sh text 60 req01_ecap

  # 保存 pcapng + TLS keylog，后续用 Wireshark/tshark 看。
  probes/350101/run_ecapture_tls_350101.sh pcap 60 req01_pcap

  # 单独尝试 keylog。APK 自带 BoringSSL 不一定稳定，失败先回 text。
  probes/350101/run_ecapture_tls_350101.sh keylog 60 req01_key

环境变量：
  PKG                         目标包名，默认 com.ss.android.ugc.aweme
  ECAPTURE_PID                手动指定 pid；不指定则 pidof
  START_APP                   pid 不存在时是否自动 monkey 启动，默认 0；样本采集建议手动打开 App
  FOREGROUND_APP              pid 存在时是否 monkey 拉到前台，默认 0
  CAPTURE_FROM_LAUNCH         pcap/keylog 专用：先 force-stop，再启动 eCapture，最后启动 App，避免 keylog/pcap 错位
  PID_FILTER                  是否给 eCapture 加 --pid，默认 1；CAPTURE_FROM_LAUNCH=1 时自动 0
  LIBSSL_REMOTE               手动指定目标进程实际 mmap 的 libttboringssl.so 路径
  ECAPTURE_SSL_VERSION        eCapture BoringSSL bytecode 版本，默认 boringssl_a_13
  ECAPTURE_HEX                text 模式是否追加 --hex，默认 1，方便离线 HTTP/2/HPACK 解析
  BTF_MODE                    eCapture -b：0 auto / 1 core / 2 non-core
  TRUNCATE_SIZE               text 输出截断，0 为不截断
  IFACE                       pcap 模式网卡，默认自动猜 wlan0/rmnet
  KEEP_HISTORY=0              默认覆盖 ecapture/latest 并清理旧日期目录；设为 1 才按 tag 保留历史
  DRY_RUN=1                   只生成 README/命令说明到 .dry-<tag>/，不碰设备
EOF
}

case "$MODE" in
  -h|--help)
    usage
    exit 0
    ;;
  text|pcap|pcapng|keylog|key)
    ;;
  *)
    echo "[ecapture-runner] unknown mode: $MODE" >&2
    usage >&2
    exit 2
    ;;
esac

case "$RUN_SECONDS" in
  ''|*[!0-9]*)
    echo "[ecapture-runner] seconds must be a positive integer: $RUN_SECONDS" >&2
    exit 2
    ;;
esac
if [ "$RUN_SECONDS" -lt 1 ]; then
  echo "[ecapture-runner] seconds must be >= 1" >&2
  exit 2
fi

case "$KEEP_HISTORY" in
  0|1) ;;
  *) echo "[ecapture-runner] KEEP_HISTORY must be 0 or 1: $KEEP_HISTORY" >&2; exit 2 ;;
esac
case "$DRY_RUN" in
  0|1) ;;
  *) echo "[ecapture-runner] DRY_RUN must be 0 or 1: $DRY_RUN" >&2; exit 2 ;;
esac

TAG_SAFE="$(printf '%s' "$TAG" | tr -c 'A-Za-z0-9_.-' '_')"
ECAPTURE_ROOT="$DYIDRE_ROOT/runs/$VERSION/ecapture"
if [ "$DRY_RUN" = "1" ]; then
  OUT_DIR="$ECAPTURE_ROOT/.dry-$TAG_SAFE"
elif [ "$KEEP_HISTORY" = "1" ]; then
  OUT_DIR="$ECAPTURE_ROOT/$TAG_SAFE"
else
  OUT_DIR="$ECAPTURE_ROOT/latest"
fi
REMOTE_RUN_DIR="/data/local/tmp/dyidre_ecapture_${VERSION}_${TAG_SAFE}"

# 固定功能默认只留最新一份；仅清理 ecapture 目录下的旧子目录。
if [ "$DRY_RUN" != "1" ] && [ "$KEEP_HISTORY" != "1" ]; then
  case "$ECAPTURE_ROOT" in
    ""|"/"|"$DYIDRE_ROOT"|"$DYIDRE_ROOT/runs")
      echo "[ecapture-runner] refusing unsafe cleanup path: $ECAPTURE_ROOT" >&2
      exit 1
      ;;
    *)
      for old_run in "$ECAPTURE_ROOT"/*; do
        [ -d "$old_run" ] || continue
        rm -rf "$old_run"
      done
      ;;
  esac
fi
mkdir -p "$OUT_DIR"

write_readme() {
  {
    printf '# eCapture TLS run %s\n\n' "$TAG_SAFE"
    printf '| key | value |\n'
    printf '|---|---|\n'
    printf '| version | `%s` |\n' "$VERSION"
    printf '| mode | `%s` |\n' "$MODE"
    printf '| seconds | `%s` |\n' "$RUN_SECONDS"
    printf '| package | `%s` |\n' "$PKG"
    printf '| start app | `%s` |\n' "$START_APP"
    printf '| foreground app | `%s` |\n' "$FOREGROUND_APP"
    printf '| capture from launch | `%s` |\n' "$CAPTURE_FROM_LAUNCH"
    printf '| pid filter | `%s` |\n' "$PID_FILTER"
    printf '| local ecapture | `%s` |\n' "$ECAPTURE_LOCAL"
    printf '| remote ecapture | `%s` |\n' "$ECAPTURE_REMOTE"
    printf '| remote run dir | `%s` |\n' "$REMOTE_RUN_DIR"
    printf '| btf mode | `%s` |\n' "$BTF_MODE"
    printf '| ssl version | `%s` |\n' "$ECAPTURE_SSL_VERSION"
    printf '| text hex | `%s` |\n' "$ECAPTURE_HEX"
    printf '\n## 文件说明\n\n'
    printf '| 文件 | 作用 |\n'
    printf '|---|---|\n'
    printf '| `ecapture_console.log` | eCapture stdout/stderr，优先看启动失败、BPF/uprobes 报错。 |\n'
    printf '| `ecapture_runtime.log` | eCapture 自身运行日志，由 `-l` 写出。 |\n'
    printf '| `ecapture_events.log` | text 模式明文事件，HTTP/2 能解析时会有 `HTTP2Request/HTTP2Response`。 |\n'
    printf '| `capture.pcapng` | pcap/pcapng 模式输出；用 `scripts/summarize_ecapture_pcap.py` 判断 TCP/UDP/QUIC 分布。 |\n'
    printf '| `keylog.log` | keylog 模式输出；pcap 模式也会尝试生成，配合 Wireshark 解 TLS。 |\n'
    printf '| `ecapture_summary.md/json` | 本地 summary 脚本从 text 输出提取的 path/authority/x-*。 |\n'
    printf '| `http2_decode.md/json` | text 模式下从 SSL_read/write 明文切 HTTP/2 frame/HPACK header。 |\n'
    printf '| `pcap_summary.md/json` | pcap 模式下统计 TCP/UDP、TCP/443、UDP/443；UDP/443 是 QUIC 的优先判断点。 |\n'
    printf '\n## 复跑\n\n'
    printf '```bash\n'
    printf 'probes/350101/run_ecapture_tls_350101.sh %s %s %s\n' "$MODE" "$RUN_SECONDS" "$TAG_SAFE"
    printf '```\n'
    printf '\n## 注意\n\n'
    printf '%s\n' '- 本脚本不注入目标进程，不替换证书校验，只通过 eBPF uprobe 观察 `SSL_read/SSL_write`。'
    printf '%s\n' '- text 明文样本建议先手动打开 App，确认页面正常后再执行；默认 `START_APP=0`、`FOREGROUND_APP=0`，避免 runner 自动改变目标前台状态。'
    printf '%s\n' '- pcap/keylog 给 Wireshark 看时，建议使用 `CAPTURE_FROM_LAUNCH=1`：先抓 TLS 握手和 keylog，再启动 App，避免 pcap 和 keylog 对不上。'
    printf '%s\n' '- 若 `libttboringssl.so` 在 maps 里是 `base.apk!...` 这种 zip 内路径，uprobe 可能挂不上；优先使用 maps 中真实 `.so` 路径。'
    printf '%s\n' '- Pixel5 4.19/arm64 不满足 eCapture 官方 aarch64 5.5+ 要求，优先 Pixel6 5.10。'
  } > "$OUT_DIR/README.md"
}

write_readme

echo "[ecapture-runner] out=$OUT_DIR"

if [ "$DRY_RUN" = "1" ]; then
  echo "[ecapture-runner] DRY_RUN=1, skip adb/ecapture"
  exit 0
fi

if [ ! -x "$ECAPTURE_LOCAL" ]; then
  echo "[ecapture-runner] missing executable: $ECAPTURE_LOCAL" >&2
  echo "[ecapture-runner] expected Android arm64 binary at tools/runtime_payloads/ecapture" >&2
  exit 1
fi

"$ADB" push "$ECAPTURE_LOCAL" "$ECAPTURE_REMOTE" >/dev/null
"$ADB" shell "su -c 'chmod 755 \"$ECAPTURE_REMOTE\"; mkdir -p \"$REMOTE_RUN_DIR\"'" >/dev/null

get_pid() {
  if [ -n "${ECAPTURE_PID:-}" ]; then
    printf '%s\n' "$ECAPTURE_PID"
    return 0
  fi

  local pid
  pid="$("$ADB" shell "pidof '$PKG' 2>/dev/null" | tr -d '\r' | awk '{print $1}')"
  if [ -n "$pid" ]; then
    printf '%s\n' "$pid"
    return 0
  fi

  if [ "$START_APP" = "1" ] || [ "$FOREGROUND_APP" = "1" ]; then
    echo "[ecapture-runner] $PKG is not running; start it with monkey"
    "$ADB" shell "monkey -p '$PKG' -c android.intent.category.LAUNCHER 1" >/dev/null 2>&1 || true
    sleep 3
    pid="$("$ADB" shell "pidof '$PKG' 2>/dev/null" | tr -d '\r' | awk '{print $1}')"
  fi

  if [ -n "$pid" ]; then
    printf '%s\n' "$pid"
    return 0
  fi
  return 1
}

bring_app_foreground() {
  if [ "$FOREGROUND_APP" = "1" ]; then
    echo "[ecapture-runner] bring $PKG to foreground"
    "$ADB" shell "monkey -p '$PKG' -c android.intent.category.LAUNCHER 1" >/dev/null 2>&1 || true
    sleep 1
  fi
}

find_mapped_libssl() {
  local pid="$1"
  local mapped
  mapped="$("$ADB" exec-out "su -c 'cat /proc/$pid/maps 2>/dev/null'" \
    | tr -d '\r' \
    | awk '/libttboringssl\.so/ {print $NF; exit}')"
  if [ -n "$mapped" ]; then
    printf '%s\n' "$mapped"
    return 0
  fi

  # 部分设备 maps 受限制或 App 暂未加载 Cronet。尝试从安装目录推导。
  local apk_path apk_dir guess
  apk_path="$("$ADB" shell "pm path '$PKG' 2>/dev/null | sed -n 's/^package://p' | head -n 1" | tr -d '\r')"
  if [ -n "$apk_path" ]; then
    apk_dir="$(dirname "$apk_path")"
    guess="$apk_dir/lib/arm64/libttboringssl.so"
    if "$ADB" shell "su -c 'test -f \"$guess\"'" >/dev/null 2>&1; then
      printf '%s\n' "$guess"
      return 0
    fi
  fi

  return 1
}

find_installed_libssl() {
  # CAPTURE_FROM_LAUNCH=1 时 App 还没启动，不能从 /proc/<pid>/maps 找 lib。
  # 这里从 APK 安装目录推断 native lib 的真实落地路径，供 eCapture uprobe 使用。
  local apk_path apk_dir guess
  apk_path="$("$ADB" shell "pm path '$PKG' 2>/dev/null | sed -n 's/^package://p' | head -n 1" | tr -d '\r')"
  if [ -z "$apk_path" ]; then
    return 1
  fi

  apk_dir="$(dirname "$apk_path")"
  for guess in \
    "$apk_dir/lib/arm64/libttboringssl.so" \
    "$apk_dir/lib/arm64-v8a/libttboringssl.so"; do
    if "$ADB" shell "su -c 'test -f \"$guess\"'" >/dev/null 2>&1; then
      printf '%s\n' "$guess"
      return 0
    fi
  done

  return 1
}

detect_iface() {
  if [ -n "${IFACE:-}" ]; then
    printf '%s\n' "$IFACE"
    return 0
  fi
  local iface
  iface="$("$ADB" shell "ip route get 8.8.8.8 2>/dev/null | sed -n 's/.* dev \\([^ ]*\\).*/\\1/p' | head -n 1" | tr -d '\r')"
  if [ -z "$iface" ]; then
    iface="$("$ADB" shell "ip -o link show 2>/dev/null | awk -F': ' '/wlan|rmnet|ccmni/ {print \$2; exit}'" | tr -d '\r')"
  fi
  printf '%s\n' "${iface:-wlan0}"
}

PID=""
if [ "$CAPTURE_FROM_LAUNCH" = "1" ]; then
  echo "[ecapture-runner] CAPTURE_FROM_LAUNCH=1: force-stop $PKG before eCapture starts"
  "$ADB" shell "am force-stop '$PKG'" >/dev/null 2>&1 || true
  sleep 1
else
  PID="$(get_pid || true)"
  if [ -z "$PID" ]; then
    echo "[ecapture-runner] cannot find/start package pid: $PKG" >&2
    exit 1
  fi

  bring_app_foreground
  PID="$("$ADB" shell "pidof '$PKG' 2>/dev/null" | tr -d '\r' | awk '{print $1}')"
  if [ -z "$PID" ]; then
    echo "[ecapture-runner] package disappeared after foreground attempt: $PKG" >&2
    exit 1
  fi
fi

if [ -z "${LIBSSL_REMOTE:-}" ]; then
  if [ -n "$PID" ]; then
    LIBSSL_REMOTE="$(find_mapped_libssl "$PID" || true)"
  else
    LIBSSL_REMOTE="$(find_installed_libssl || true)"
  fi
fi
if [ -z "$LIBSSL_REMOTE" ]; then
  echo "[ecapture-runner] cannot find libttboringssl.so for package=$PKG pid=${PID:-none}" >&2
  echo "[ecapture-runner] open the app until Cronet loads, or pass LIBSSL_REMOTE=/real/path/libttboringssl.so" >&2
  exit 1
fi

if printf '%s' "$LIBSSL_REMOTE" | grep -q '\\.apk!'; then
  echo "[ecapture-runner] warning: mapped lib path is inside APK zip: $LIBSSL_REMOTE" | tee "$OUT_DIR/warnings.log"
  echo "[ecapture-runner] warning: eBPF uprobe may not attach to zip-contained native library on this device" | tee -a "$OUT_DIR/warnings.log"
fi

REMOTE_CONSOLE="$REMOTE_RUN_DIR/ecapture_console.log"
REMOTE_RUNTIME_LOG="$REMOTE_RUN_DIR/ecapture_runtime.log"
REMOTE_EVENTS_LOG="$REMOTE_RUN_DIR/ecapture_events.log"
REMOTE_PCAP="$REMOTE_RUN_DIR/capture.pcapng"
REMOTE_KEYLOG="$REMOTE_RUN_DIR/keylog.log"
REMOTE_DEFAULT_KEYLOG="$REMOTE_RUN_DIR/ecapture_openssl_key.log"
REMOTE_PIDFILE="$REMOTE_RUN_DIR/ecapture.pid"
# 临时 runner 不放进 REMOTE_RUN_DIR：
# REMOTE_RUN_DIR 由 root 创建，普通 adb push 不能写进去；
# runner 放 /data/local/tmp 顶层，push 后再由 root chmod/执行。
REMOTE_RUNNER="/data/local/tmp/dyidre_ecapture_${VERSION}_${TAG_SAFE}_runner.sh"
LOCAL_DEVICE_RUNNER="$OUT_DIR/run_ecapture_device.sh"
ECAPTURE_STARTED=0

stop_ecapture() {
  "$ADB" shell "su -c 'if test -f \"$REMOTE_PIDFILE\"; then kill -INT \"\$(cat \"$REMOTE_PIDFILE\")\" 2>/dev/null || true; fi; pkill -INT ecapture 2>/dev/null || true'" >/dev/null || true
}

cleanup_ecapture() {
  if [ "${ECAPTURE_STARTED:-0}" = "1" ]; then
    stop_ecapture
  fi
}

trap cleanup_ecapture EXIT INT TERM

sh_quote() {
  python3 - "$1" <<'PY'
import shlex
import sys
print(shlex.quote(sys.argv[1]))
PY
}

write_remote_runner() {
  local iface_arg=""
  local hex_arg=""
  local remote_pid_value=""

  if [ "$ECAPTURE_HEX" = "1" ]; then
    hex_arg="--hex"
  fi

  if [ "$PID_FILTER" = "1" ] && [ -n "$PID" ]; then
    remote_pid_value="$PID"
  fi

  case "$MODE" in
    text)
      iface_arg=""
      ;;
    pcap|pcapng)
      IFACE_DETECTED="$(detect_iface)"
      iface_arg="-i $(sh_quote "$IFACE_DETECTED")"
      ;;
    keylog|key)
      iface_arg=""
      ;;
  esac

  {
    printf '#!/system/bin/sh\n'
    printf '# 由 dyidre/probes/350101/run_ecapture_tls_350101.sh 自动生成。\n'
    printf '# 设备侧执行，避免 adb shell su -c 多层引号把 lib 路径/参数截断。\n'
    printf 'set -eu\n'
    printf 'cd %s\n' "$(sh_quote "$REMOTE_RUN_DIR")"
    printf 'ECAPTURE_BIN=%s\n' "$(sh_quote "$ECAPTURE_REMOTE")"
    printf 'PID_VALUE=%s\n' "$(sh_quote "$remote_pid_value")"
    printf 'BTF_MODE=%s\n' "$(sh_quote "$BTF_MODE")"
    printf 'TRUNCATE_SIZE=%s\n' "$(sh_quote "$TRUNCATE_SIZE")"
    printf 'LIBSSL_PATH=%s\n' "$(sh_quote "$LIBSSL_REMOTE")"
    printf 'SSL_VERSION=%s\n' "$(sh_quote "$ECAPTURE_SSL_VERSION")"
    printf 'RUNTIME_LOG=%s\n' "$(sh_quote "$REMOTE_RUNTIME_LOG")"
    printf 'EVENTS_LOG=%s\n' "$(sh_quote "$REMOTE_EVENTS_LOG")"
    printf 'CONSOLE_LOG=%s\n' "$(sh_quote "$REMOTE_CONSOLE")"
    printf 'PCAP_OUT=%s\n' "$(sh_quote "$REMOTE_PCAP")"
    printf 'KEYLOG_OUT=%s\n' "$(sh_quote "$REMOTE_KEYLOG")"
    printf 'PIDFILE=%s\n' "$(sh_quote "$REMOTE_PIDFILE")"
    printf '\n'
    printf 'PID_ARG=""\n'
    printf 'if [ -n "$PID_VALUE" ]; then PID_ARG="--pid $PID_VALUE"; fi\n'
    printf '\n'
    printf 'case %s in\n' "$(sh_quote "$MODE")"
    printf '  text)\n'
    printf '    "$ECAPTURE_BIN" %s --btf "$BTF_MODE" $PID_ARG --tsize "$TRUNCATE_SIZE" tls --libssl "$LIBSSL_PATH" --ssl_version "$SSL_VERSION" -m text -l "$RUNTIME_LOG" --eventaddr "$EVENTS_LOG" > "$CONSOLE_LOG" 2>&1 &\n' "$hex_arg"
    printf '    ;;\n'
    printf '  pcap|pcapng)\n'
    printf '    "$ECAPTURE_BIN" --btf "$BTF_MODE" $PID_ARG --tsize "$TRUNCATE_SIZE" tls --libssl "$LIBSSL_PATH" --ssl_version "$SSL_VERSION" -m pcap %s -w "$PCAP_OUT" -k "$KEYLOG_OUT" -l "$RUNTIME_LOG" tcp port 443 > "$CONSOLE_LOG" 2>&1 &\n' "$iface_arg"
    printf '    ;;\n'
    printf '  keylog|key)\n'
    printf '    "$ECAPTURE_BIN" --btf "$BTF_MODE" $PID_ARG --tsize "$TRUNCATE_SIZE" tls --libssl "$LIBSSL_PATH" --ssl_version "$SSL_VERSION" -m keylog -k "$KEYLOG_OUT" -l "$RUNTIME_LOG" > "$CONSOLE_LOG" 2>&1 &\n'
    printf '    ;;\n'
    printf 'esac\n'
    printf 'echo $! > "$PIDFILE"\n'
  } > "$LOCAL_DEVICE_RUNNER"
}

write_remote_runner

{
  printf 'pid=%s\n' "$PID"
  printf 'pid_filter=%s\n' "$PID_FILTER"
  printf 'capture_from_launch=%s\n' "$CAPTURE_FROM_LAUNCH"
  printf 'libssl=%s\n' "$LIBSSL_REMOTE"
  printf 'mode=%s\n' "$MODE"
  printf 'remote_runner=%s\n' "$REMOTE_RUNNER"
  printf '\n# remote runner body\n'
  sed 's/^/  /' "$LOCAL_DEVICE_RUNNER"
} > "$OUT_DIR/ecapture_command.txt"

echo "[ecapture-runner] pid=$PID"
echo "[ecapture-runner] pid_filter=$PID_FILTER capture_from_launch=$CAPTURE_FROM_LAUNCH"
echo "[ecapture-runner] libssl=$LIBSSL_REMOTE"
echo "[ecapture-runner] mode=$MODE seconds=$RUN_SECONDS"

"$ADB" push "$LOCAL_DEVICE_RUNNER" "$REMOTE_RUNNER" >/dev/null
"$ADB" shell "su -c 'chmod 755 \"$REMOTE_RUNNER\"; \"$REMOTE_RUNNER\"'" >/dev/null
ECAPTURE_STARTED=1
sleep 2
"$ADB" exec-out "su -c 'cat \"$REMOTE_CONSOLE\" 2>/dev/null'" > "$OUT_DIR/ecapture_console.head.log" || true

if [ "$CAPTURE_FROM_LAUNCH" = "1" ]; then
  echo "[ecapture-runner] eCapture is ready; launch $PKG now"
  "$ADB" shell "monkey -p '$PKG' -c android.intent.category.LAUNCHER 1" >/dev/null 2>&1 || true
  sleep 3
  PID_AFTER_LAUNCH="$("$ADB" shell "pidof '$PKG' 2>/dev/null" | tr -d '\r' | awk '{print $1}')"
  {
    printf '\n# after launch\n'
    printf 'pid_after_launch=%s\n' "$PID_AFTER_LAUNCH"
  } >> "$OUT_DIR/ecapture_command.txt"
  echo "[ecapture-runner] pid_after_launch=${PID_AFTER_LAUNCH:-none}"
fi

echo "[ecapture-runner] eCapture is running. Trigger one request now; collecting ${RUN_SECONDS}s..."
sleep "$RUN_SECONDS"

stop_ecapture
ECAPTURE_STARTED=0
sleep 2

pull_remote_file() {
  local remote="$1"
  local local_name="$2"
  local kind="${3:-text}"
  local local_path="$OUT_DIR/$local_name"

  # pcapng/keylog 这类产物必须优先用 adb pull。用 `adb exec-out cat > file`
  # 拉二进制 pcapng 时，在部分环境会发生 CR/LF 转换，导致文件头从
  # 0a0d0d0a 变成 0d0a0d0d0d0a，Wireshark/tcpdump 都无法识别。
  "$ADB" shell "su -c 'if test -f \"$remote\"; then chmod 644 \"$remote\"; fi'" >/dev/null 2>&1 || true
  if "$ADB" pull "$remote" "$local_path" >/dev/null 2>&1; then
    if [ -s "$local_path" ]; then
      echo "[ecapture-runner] pulled $local_name"
      return 0
    fi
  fi

  # 文本日志允许 fallback 到 exec-out；二进制文件不 fallback，避免生成坏文件。
  if [ "$kind" = "text" ]; then
    "$ADB" exec-out "su -c 'cat \"$remote\" 2>/dev/null'" > "$local_path" || true
  fi

  if [ ! -s "$local_path" ]; then
    python3 - "$local_path" <<'PY' || true
import os, sys
path = sys.argv[1]
try:
    os.unlink(path)
except FileNotFoundError:
    pass
PY
  else
    echo "[ecapture-runner] pulled $local_name"
  fi
}

pull_remote_file "$REMOTE_CONSOLE" "ecapture_console.log" text
pull_remote_file "$REMOTE_RUNTIME_LOG" "ecapture_runtime.log" text
pull_remote_file "$REMOTE_EVENTS_LOG" "ecapture_events.log" text
pull_remote_file "$REMOTE_PCAP" "capture.pcapng" binary
pull_remote_file "$REMOTE_KEYLOG" "keylog.log" text
pull_remote_file "$REMOTE_DEFAULT_KEYLOG" "ecapture_openssl_key.log" text

if [ ! -s "$OUT_DIR/keylog.log" ] && [ -s "$OUT_DIR/ecapture_openssl_key.log" ]; then
  cp "$OUT_DIR/ecapture_openssl_key.log" "$OUT_DIR/keylog.log"
fi

if [ -s "$OUT_DIR/ecapture_events.log" ] || [ -s "$OUT_DIR/ecapture_console.log" ]; then
  "$DYIDRE_ROOT/scripts/parse_ecapture_run.sh" "$OUT_DIR" || true
elif [ -s "$OUT_DIR/capture.pcapng" ]; then
  "$DYIDRE_ROOT/scripts/parse_ecapture_run.sh" "$OUT_DIR" || true
fi

echo "[ecapture-runner] done: $OUT_DIR"
