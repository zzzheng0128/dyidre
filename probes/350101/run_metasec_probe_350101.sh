#!/usr/bin/env bash
# dyidre 350101 统一真机采集入口。
#
# 用法：
#   probes/350101/run_metasec_probe_350101.sh <mode> [seconds] [tag]
#
# 常用 mode：
#   rpc              启动 RF RPC 常驻 session。要反复注入小探针或配合 stackplz 时先用它。
#   counter-one      单请求计数：看一条请求里 HTTP/F5/F7/F8/F13/exeVMInner 命中次数。
#   counter-multi    多请求计数：单请求对齐后再看多 URL/滑动场景是否分叉。
#   true-env         真机环境采集：F8/X-Medusa、时间、随机、pid/tid、emit 前后值。
#   jnitrace         WXSHADOW-lite JNI 采集：补 MS.b、NewString、FindClass 等 unidbg stub。
#   xheader          最终 TreeMap/header 写出点：看 X-Argus/X-Ladon/X-Medusa/X-Soter。
#   branch           CF/branch 值级探针：raw PC 能同步但值不一致时用。
#   native-vmp       native VMP 0x1f7860 局部验证。
#   gum-exevm        GumTrace exeVMInner +0x4cc10。只在需要 raw PC/handler 时用。
#   gum-http         GumTrace HTTP/sign inner +0x149ca8。日志大，短跑。
#   ssl              sscronet/libttboringssl 抓包辅助：custom verify、SSL_read/write、keylog、BIO。
#   capture          Cronet 请求/响应组包，合并 0x14DBF4 X-* headers，上传 dydcd。
#   artcheck         ArtMethod/maps 检测面检查。
#
# 输出：
#   正式运行默认：runs/350101/<kind>/latest/
#   KEEP_HISTORY=1：runs/350101/<kind>/<tag>/
#   DRY_RUN=1：runs/350101/<kind>/.dry-<tag>/（本地自测，不上传）
#
# 注意：
#   - counter/branch/stackplz-bridge 需要 RPC；本脚本会自动加 --rpc-port。
#   - 本脚本不会直接改统一 JS，而是生成一个临时 runtime JS，在头部写入
#     globalThis.METASEC_PROBE_CONFIG={mode: "..."} 后再加载统一 JS。
#   - 采集结果必须进 runs/，不要把日志堆回 probes/。
set -euo pipefail

# Host/设备基础配置。升级新版本时，优先只改 VERSION 和脚本名。
#
# 路径不要写死到某台机器。脚本位于：
#   <dyidre>/probes/350101/run_metasec_probe_350101.sh
# 所以向上两级就是仓库根目录。确实有特殊布局时，再用 DYIDRE_ROOT 覆盖。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DYIDRE_ROOT="${DYIDRE_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"

# adb 默认从 PATH 找；如果本机没有放 PATH，再保留 Android SDK 常见路径兜底。
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
METASEC_ENGINE="${METASEC_ENGINE:-rustfrida}"
RF_REMOTE="${RF_REMOTE:-/data/local/tmp/rustfrida}"
RPC_PORT="${RPC_PORT:-19191}"
RF_CONNECT_TIMEOUT="${RF_CONNECT_TIMEOUT:-60}"
RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME="${RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME:-1}"
export RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME
FRIDA_BIN="${FRIDA_BIN:-}"
METASEC_FRIDA_ATTACH_DELAY="${METASEC_FRIDA_ATTACH_DELAY:-10}"
METASEC_FRIDA_RUNTIME="${METASEC_FRIDA_RUNTIME:-qjs}"
METASEC_FRIDA_SERVER_REMOTE="${METASEC_FRIDA_SERVER_REMOTE:-/data/local/tmp/frida-server-17.17.0}"
PACKET_PORT="${METASEC_PACKET_PORT:-8891}"
PACKET_UPLOAD_URL="${METASEC_PACKET_UPLOAD_URL:-http://127.0.0.1:${PACKET_PORT}/up/dy/packets}"
export METASEC_PACKET_UPLOAD_URL="$PACKET_UPLOAD_URL"
VERSION="350101"
KEEP_HISTORY="${KEEP_HISTORY:-0}"
DRY_RUN="${DRY_RUN:-0}"
PROCESS_MONITOR_PID=""
LOGCAT_MONITOR_PID=""
DMESG_MONITOR_PID=""
ANR_MONITOR_PID=""
SAFE_SWIPE_PID=""
METASEC_PROCESS_MONITOR="${METASEC_PROCESS_MONITOR:-1}"
METASEC_LOGCAT_MONITOR="${METASEC_LOGCAT_MONITOR:-1}"
METASEC_DMESG_MONITOR="${METASEC_DMESG_MONITOR:-1}"
METASEC_ANR_MONITOR="${METASEC_ANR_MONITOR:-1}"
METASEC_ABORT_ON_ANR="${METASEC_ABORT_ON_ANR:-1}"
METASEC_ABORT_ON_CRASH="${METASEC_ABORT_ON_CRASH:-1}"
METASEC_PROCESS_MONITOR_INTERVAL="${METASEC_PROCESS_MONITOR_INTERVAL:-2}"
METASEC_ANR_MONITOR_INTERVAL="${METASEC_ANR_MONITOR_INTERVAL:-1}"
METASEC_ANR_UI_DUMP_INTERVAL="${METASEC_ANR_UI_DUMP_INTERVAL:-3}"
METASEC_ANR_WINDOW_MONITOR="${METASEC_ANR_WINDOW_MONITOR:-0}"
METASEC_ANR_ACTIVITY_MONITOR="${METASEC_ANR_ACTIVITY_MONITOR:-0}"
METASEC_ANR_UI_MONITOR="${METASEC_ANR_UI_MONITOR:-0}"
METASEC_ANR_INPUT_GUARD_UI_DUMP="${METASEC_ANR_INPUT_GUARD_UI_DUMP:-0}"
METASEC_INPUT_FOCUS_GUARD="${METASEC_INPUT_FOCUS_GUARD:-0}"
METASEC_CLEAR_DEVICE_LOGS="${METASEC_CLEAR_DEVICE_LOGS:-1}"
METASEC_SAFE_SWIPE="${METASEC_SAFE_SWIPE:-0}"
METASEC_SAFE_SWIPE_START_DELAY="${METASEC_SAFE_SWIPE_START_DELAY:-8}"
METASEC_SAFE_SWIPE_INTERVAL="${METASEC_SAFE_SWIPE_INTERVAL:-10}"
METASEC_SAFE_SWIPE_COUNT="${METASEC_SAFE_SWIPE_COUNT:-0}"
METASEC_SAFE_SWIPE_COORDS="${METASEC_SAFE_SWIPE_COORDS:-540 1800 540 700 350}"

print_usage() {
  # 只打印用法，不碰设备。避免不带参数时误启动 RF/抖音。
  cat <<'EOF'
用法：
  probes/350101/run_metasec_probe_350101.sh <mode> [seconds] [tag]
  DRY_RUN=1 probes/350101/run_metasec_probe_350101.sh <mode> [seconds] [tag]

常用 mode：
  rpc              启动 RF RPC 常驻 session
  counter-one      单请求计数
  counter-multi    多请求计数
  true-env         真机环境 + F8/X-Medusa 基准采集
  jnitrace         JNI / MS.b / NewString / FindClass 采集
  xheader          最终 X-* header TreeMap 写出
  branch           CF/branch 值级探针
  native-vmp       native VMP 0x1f7860 局部验证
  gum-exevm        GumTrace exeVMInner +0x4cc10
  gum-http         GumTrace HTTP/sign inner +0x149ca8
  ssl              sscronet/libttboringssl 抓包辅助
  capture          Cronet 组包 + 0x14DBF4 X-* header + dydcd 上传
  artcheck         ArtMethod/maps 检测面检查
  stackplz-bridge  RF 内 stackplz RPC bridge

说明：
  多个 mode 可用逗号组合，例如：gum-exevm,capture 或 ssl,capture。
  KEEP_HISTORY=0 默认覆盖同类 latest/并清理旧日期目录；设为 1 才按 tag 保留历史。
  DRY_RUN=1 只生成本地 runtime JS/README 到 .dry-<tag>/，不 adb push，不启动 rustFrida。
EOF
}

normalize_mode_one() {
  # 和 JS controller 的 alias 保持一致；这里先拦错，避免未知 mode 拉起真机。
  case "$1" in
    rpc)
      printf '%s\n' "rpc"
      ;;
    counter-one|counter|one)
      printf '%s\n' "counter-one"
      ;;
    counter-multi|multi)
      printf '%s\n' "counter-multi"
      ;;
    true-env|trueenv|env)
      printf '%s\n' "true-env"
      ;;
    jnitrace|jni)
      printf '%s\n' "jnitrace"
      ;;
    xheader|headers|treeput)
      printf '%s\n' "xheader"
      ;;
    branch)
      printf '%s\n' "branch"
      ;;
    native-vmp|vmp)
      printf '%s\n' "native-vmp"
      ;;
    gum-exevm|gum-4cc10|exevm)
      printf '%s\n' "gum-exevm"
      ;;
    gum-http|gum-http-full|http)
      printf '%s\n' "gum-http"
      ;;
    ssl|ssl-capture)
      printf '%s\n' "ssl"
      ;;
    packet-capture|capture|packet|packets|cronet|dydcd)
      printf '%s\n' "packet-capture"
      ;;
    artcheck|art|maps)
      printf '%s\n' "artcheck"
      ;;
    stackplz|stackplz-bridge)
      printf '%s\n' "stackplz-bridge"
      ;;
    *)
      return 1
      ;;
  esac
}

normalize_mode() {
  local input part token normalized out
  input="$(printf '%s' "$1" | tr '+;' ',,')"
  out=""
  IFS=',' read -r -a parts <<< "$input"
  for part in "${parts[@]}"; do
    token="$(printf '%s' "$part" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [ -n "$token" ] || continue
    if ! normalized="$(normalize_mode_one "$token")"; then
      return 1
    fi
    case ",$out," in
      *",$normalized,"*) ;;
      *) out="${out:+$out,}$normalized" ;;
    esac
  done
  [ -n "$out" ] || return 1
  printf '%s\n' "$out"
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  print_usage
  exit 0
fi

if [ "$#" -lt 1 ]; then
  print_usage >&2
  exit 2
fi

MODE_INPUT="$1"
RUN_SECONDS="${2:-90}"
TAG="${3:-$(date +%Y%m%d_%H%M%S)}"

if ! MODE="$(normalize_mode "$MODE_INPUT")"; then
  echo "[metasec-probe-runner] unknown mode: $MODE_INPUT" >&2
  print_usage >&2
  exit 2
fi

case "$RUN_SECONDS" in
  ''|*[!0-9]*)
    echo "[metasec-probe-runner] seconds must be a positive integer: $RUN_SECONDS" >&2
    exit 2
    ;;
esac
if [ "$RUN_SECONDS" -lt 1 ]; then
  echo "[metasec-probe-runner] seconds must be >= 1" >&2
  exit 2
fi
case "$RF_CONNECT_TIMEOUT" in
  ''|*[!0-9]*)
    echo "[metasec-probe-runner] RF_CONNECT_TIMEOUT must be a positive integer: $RF_CONNECT_TIMEOUT" >&2
    exit 2
    ;;
esac
if [ "$RF_CONNECT_TIMEOUT" -lt 1 ]; then
  echo "[metasec-probe-runner] RF_CONNECT_TIMEOUT must be >= 1" >&2
  exit 2
fi
case "$METASEC_ENGINE" in
  rustfrida|frida) ;;
  *) echo "[metasec-probe-runner] METASEC_ENGINE must be rustfrida or frida: $METASEC_ENGINE" >&2; exit 2 ;;
esac
case "$METASEC_FRIDA_ATTACH_DELAY" in
  ''|*[!0-9]*)
    echo "[metasec-probe-runner] METASEC_FRIDA_ATTACH_DELAY must be a non-negative integer: $METASEC_FRIDA_ATTACH_DELAY" >&2
    exit 2
    ;;
esac
case "$METASEC_FRIDA_RUNTIME" in
  qjs|v8) ;;
  *) echo "[metasec-probe-runner] METASEC_FRIDA_RUNTIME must be qjs or v8: $METASEC_FRIDA_RUNTIME" >&2; exit 2 ;;
esac

case "$KEEP_HISTORY" in
  0|1) ;;
  *) echo "[metasec-probe-runner] KEEP_HISTORY must be 0 or 1: $KEEP_HISTORY" >&2; exit 2 ;;
esac
case "$DRY_RUN" in
  0|1) ;;
  *) echo "[metasec-probe-runner] DRY_RUN must be 0 or 1: $DRY_RUN" >&2; exit 2 ;;
esac

MODE_SAFE="$(printf '%s' "$MODE" | tr -c 'A-Za-z0-9_.-' '_')"

# 统一 JS 是源码；SCRIPT_REMOTE 是本次运行推到手机的 runtime JS。
SCRIPT_LOCAL="$DYIDRE_ROOT/probes/$VERSION/metasec_probe_${VERSION}.js"
DEVICE_RPC_RUNNER="$DYIDRE_ROOT/probes/$VERSION/run_rf_rpc_persistent.sh"
SCRIPT_REMOTE="/data/local/tmp/metasec_probe_${VERSION}_${MODE_SAFE}_${TAG}.js"
RUNTIME_LOCAL_BASE="$(mktemp "${TMPDIR:-/tmp}/metasec_probe_${VERSION}_${MODE_SAFE}.XXXXXX")"
RUNTIME_LOCAL="${RUNTIME_LOCAL_BASE}.js"
mv "$RUNTIME_LOCAL_BASE" "$RUNTIME_LOCAL"
BOOTSTRAP_LOCAL=""
BOOTSTRAP_REMOTE="/data/local/tmp/metasec_probe_${VERSION}_${MODE_SAFE}_${TAG}_bootstrap.js"
RF_STDIN=""
RF_STDIN_FD_OPEN=0

mode_has() {
  case ",$MODE," in
    *",$1,"*) return 0 ;;
    *) return 1 ;;
  esac
}

packet_force_stop_after() {
  case "${METASEC_PACKET_FORCE_STOP_AFTER:-0}" in
    1|true|True|TRUE|yes|Yes|YES|on|On|ON) return 0 ;;
    *) return 1 ;;
  esac
}

packet_java_stealth_mode() {
  local raw lower
  raw="${METASEC_PACKET_JAVA_STEALTH:-${METASEC_PACKET_STEALTH:-wxshadow}}"
  lower="$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]')"
  case "$lower" in
    0|false|off|no|normal|none|hook.normal)
      printf '%s\n' "normal"
      ;;
    2|recomp|hook.recomp)
      printf '%s\n' "recomp"
      ;;
    1|true|on|yes|wxshadow|hook.wxshadow)
      printf '%s\n' "wxshadow"
      ;;
    *)
      printf '%s\n' "$lower"
      ;;
  esac
}

packet_wants_java_stealth() {
  case "$(packet_java_stealth_mode)" in
    normal) return 1 ;;
    *) return 0 ;;
  esac
}

packet_env_truthy() {
  case "$1" in
    1|true|True|TRUE|yes|Yes|YES|on|On|ON) return 0 ;;
    *) return 1 ;;
  esac
}

packet_uses_vm_bridge() {
  local upload_via
  upload_via="$(printf '%s' "${METASEC_PACKET_UPLOAD_VIA:-native}" | tr '[:upper:]' '[:lower:]')"
  if packet_env_truthy "${METASEC_PACKET_HOOK_JN:-0}"; then return 0; fi
  if packet_env_truthy "${METASEC_PACKET_HOOK_STREAMS:-0}"; then return 0; fi
  if packet_env_truthy "${METASEC_PACKET_HOOK_CONNECTIONS:-0}"; then return 0; fi
  case "$upload_via" in
    java) return 0 ;;
    *) return 1 ;;
  esac
}

packet_spawn_lazy_enabled() {
  case "${METASEC_PACKET_SPAWN_LAZY:-auto}" in
    1|true|True|TRUE|yes|Yes|YES|on|On|ON) return 0 ;;
    0|false|False|FALSE|no|No|NO|off|Off|OFF) return 1 ;;
    *) packet_uses_vm_bridge && packet_wants_java_stealth ;;
  esac
}

bool_env_enabled() {
  case "${1:-0}" in
    1|true|True|TRUE|yes|Yes|YES|on|On|ON) return 0 ;;
    *) return 1 ;;
  esac
}

clear_device_runtime_logs() {
  if ! bool_env_enabled "$METASEC_CLEAR_DEVICE_LOGS"; then
    return 0
  fi

  echo "[metasec-probe-runner] clear logcat/dmesg before monitor"
  "$ADB" logcat -c >/dev/null 2>&1 || true
  "$ADB" shell "su -M -c 'dmesg -C 2>/dev/null || true'" >/dev/null 2>&1 || true
}

target_pkg_ps_lines() {
  # Match the main process and package-prefixed child processes
  # (for example com.ss.android.ugc.aweme:smp).  `pidof $PKG` only covers the
  # exact process name on some Android builds, so use ps as the source of truth.
  # APatch su may print a bare "0" when the remote command exits cleanly, so
  # filter on the host side and only keep real ps rows whose PID column is numeric.
  "$ADB" shell "su -M -c 'ps -A'" 2>/dev/null \
    | tr -d '\r' \
    | awk -v pkg="$PKG" 'index($0, pkg) && $2 ~ /^[0-9]+$/ {print}' \
    || true
}

target_pkg_pids() {
  target_pkg_ps_lines | awk '$2 ~ /^[0-9]+$/ {print $2}' | sort -u || true
}

target_main_pid() {
  "$ADB" shell "pidof '$PKG' 2>/dev/null || true" \
    | tr -d '\r' \
    | awk '{print $1}' \
    || true
}

copy_latest_tombstones() {
  local dir="$OUT_DIR/tombstones"
  local list_file="$OUT_DIR/tombstones.list"
  mkdir -p "$dir"
  "$ADB" shell "su -M -c 'ls -t /data/tombstones/tombstone_* 2>/dev/null | head -6'" \
    | tr -d '\r' >"$list_file" || true
  while IFS= read -r remote_path; do
    [ -n "$remote_path" ] || continue
    local base
    base="$(basename "$remote_path")"
    "$ADB" exec-out "su -M -c 'cat \"$remote_path\" 2>/dev/null'" \
      >"$dir/$base.txt" 2>/dev/null || true
  done <"$list_file"
}

mark_target_crashed() {
  local reason="$1"
  local ts
  ts="$(date '+%Y%m%d_%H%M%S')"
  if [ ! -e "$OUT_DIR/.target_crashed" ]; then
    {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] $reason"
      echo "abort_on_crash=$METASEC_ABORT_ON_CRASH"
    } >"$OUT_DIR/.target_crashed"
    echo "[metasec-probe-runner] target crash/disappear detected: $reason"
    "$ADB" logcat -d -v time -t 1200 >"$OUT_DIR/logcat_crash_${ts}.txt" 2>&1 || true
    dump_anr_dialog_state "$ts"
    copy_latest_tombstones
    if bool_env_enabled "$METASEC_ABORT_ON_CRASH"; then
      {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] force-stop after crash/disappear"
      } >>"$OUT_DIR/.target_crashed"
      stop_target_pkg_clean || true
    fi
  fi
}

start_target_monitor() {
  case "$METASEC_PROCESS_MONITOR" in
    0|false|False|FALSE|no|No|NO|off|Off|OFF) return 0 ;;
  esac

  case "$METASEC_PROCESS_MONITOR_INTERVAL" in
    ''|*[!0-9]*)
      METASEC_PROCESS_MONITOR_INTERVAL=2
      ;;
  esac

  local log_file="$OUT_DIR/process_monitor.log"
  {
    echo "# target process monitor"
    echo "# package=$PKG interval=${METASEC_PROCESS_MONITOR_INTERVAL}s"
    echo "# started_at=$(date '+%Y-%m-%d %H:%M:%S')"
  } >"$log_file"

  (
    last_pids=""
    seen_once=0
    first_main_pid=""
    while :; do
      ts="$(date '+%Y-%m-%d %H:%M:%S')"
      lines="$(target_pkg_ps_lines || true)"
      pids="$(printf '%s\n' "$lines" | awk '$2 ~ /^[0-9]+$/ {print $2}' | sort -u | xargs || true)"
      main_pid="$(target_main_pid)"

      if [ -n "$pids" ]; then
        seen_once=1
      fi
      if [ -z "$first_main_pid" ] && [ -n "$main_pid" ]; then
        first_main_pid="$main_pid"
        echo "[$ts] EVENT main_first_seen pid=$main_pid" >>"$log_file"
      fi

      {
        echo "[$ts] pids=${pids:-<none>}"
        echo "  main_pid=${main_pid:-<none>} first_main_pid=${first_main_pid:-<none>}"
        if [ -n "$lines" ]; then
          printf '%s\n' "$lines" | sed 's/^/  ps: /'
          for pid in $pids; do
            "$ADB" shell "su -M -c 'awk '\''/^(Name|State|Tgid|Pid|PPid|TracerPid|VmRSS|VmHWM|Threads):/ {print}'\'' /proc/$pid/status 2>/dev/null'" \
              | tr -d '\r' \
              | sed "s/^/  status[$pid]: /" || true
            maps_file="$OUT_DIR/maps_${pid}.latest.txt"
            if "$ADB" exec-out "su -M -c 'cat /proc/$pid/maps 2>/dev/null'" >"${maps_file}.tmp" 2>/dev/null; then
              mv "${maps_file}.tmp" "$maps_file"
            else
              rm -f "${maps_file}.tmp"
            fi
          done
        fi
      } >>"$log_file"

      if [ "$pids" != "$last_pids" ]; then
        if [ -z "$last_pids" ] && [ -n "$pids" ]; then
          echo "[metasec-probe-runner] monitor: $PKG pids=$pids"
          echo "[$ts] EVENT first_seen pids=$pids" >>"$log_file"
        elif [ -n "$last_pids" ]; then
          echo "[metasec-probe-runner] monitor: $PKG pid change old=${last_pids:-<none>} new=${pids:-<none>}"
          echo "[$ts] EVENT pid_change old=${last_pids:-<none>} new=${pids:-<none>}" >>"$log_file"
        fi
        last_pids="$pids"
      fi

      if [ "$seen_once" = "1" ] && [ -z "$pids" ]; then
        echo "[metasec-probe-runner] monitor: $PKG disappeared"
        echo "[$ts] EVENT disappeared" >>"$log_file"
        if [ -s "$OUT_DIR/.anr_detected" ]; then
          echo "[$ts] stop: disappeared after ANR handling; not marking crash" >>"$log_file"
          break
        fi
        mark_target_crashed "$PKG disappeared after being seen"
        break
      fi

      if [ -n "$first_main_pid" ] && [ "${main_pid:-}" != "$first_main_pid" ]; then
        echo "[metasec-probe-runner] monitor: $PKG main pid changed old=$first_main_pid new=${main_pid:-<none>}"
        echo "[$ts] EVENT main_pid_changed old=$first_main_pid new=${main_pid:-<none>}" >>"$log_file"
        if [ -s "$OUT_DIR/.anr_detected" ]; then
          echo "[$ts] stop: main pid changed after ANR handling; not marking crash" >>"$log_file"
          break
        fi
        mark_target_crashed "$PKG main pid changed old=$first_main_pid new=${main_pid:-<none>}"
        break
      fi

      sleep "$METASEC_PROCESS_MONITOR_INTERVAL"
    done
  ) &
  PROCESS_MONITOR_PID="$!"
  echo "[metasec-probe-runner] process monitor: $log_file"
}

start_logcat_monitor() {
  case "$METASEC_LOGCAT_MONITOR" in
    0|false|False|FALSE|no|No|NO|off|Off|OFF) return 0 ;;
  esac

  local log_file="$OUT_DIR/logcat_live.txt"
  "$ADB" logcat -v time >"$log_file" 2>&1 &
  LOGCAT_MONITOR_PID="$!"
  echo "[metasec-probe-runner] logcat monitor: $log_file"
}

start_dmesg_monitor() {
  case "$METASEC_DMESG_MONITOR" in
    0|false|False|FALSE|no|No|NO|off|Off|OFF) return 0 ;;
  esac

  local log_file="$OUT_DIR/dmesg_live.txt"
  "$ADB" shell "su -M -c 'dmesg -w 2>&1'" >"$log_file" 2>&1 &
  DMESG_MONITOR_PID="$!"
  echo "[metasec-probe-runner] dmesg monitor: $log_file"
}

copy_latest_anr_files() {
  local list_file="$OUT_DIR/anr_files.list"
  "$ADB" shell "su -M -c 'ls -t /data/anr/anr_* /data/anr/trace_* 2>/dev/null | head -5'" \
    | tr -d '\r' >"$list_file" || true
  while IFS= read -r remote_path; do
    [ -n "$remote_path" ] || continue
    local base
    base="$(basename "$remote_path")"
    "$ADB" exec-out "su -M -c 'cat \"$remote_path\" 2>/dev/null'" \
      >"$OUT_DIR/$base.txt" 2>/dev/null || true
  done <"$list_file"
}

file_has_anr_text() {
  local file="$1"
  local anr_re="Application Not Responding|AppNotRespondingDialog|AppErrorDialog|Application Error|Application at fault|Window at fault|Input dispatching timed out|not responding|isn't responding|is not responding|无响应|未响应|没有响应|停止运行|屡次停止|keeps stopping|has stopped"
  [ -s "$file" ] || return 1
  if LC_ALL=C grep -Eiq "$anr_re" "$file"; then
    return 0
  fi
  # 国内 ROM 的 ANR 弹窗有时只暴露按钮文案，没有稳定 title。
  if LC_ALL=C grep -Eiq "关闭应用|Close app|Close" "$file" \
    && LC_ALL=C grep -Eiq "等待|Wait" "$file"; then
    return 0
  fi
  return 1
}

target_has_activity_anr_state() {
  local file="$1"
  [ -s "$file" ] || return 1
  LC_ALL=C grep -Fq "$PKG" "$file" || return 1
  LC_ALL=C grep -Eiq "notResponding=true|not responding|ANR|Input dispatching timed out" "$file"
}

logcat_has_target_anr() {
  local file="$1"
  local logcat_anr_re="ANR in ${PKG}|am_anr.*${PKG}|Input dispatching timed out.*${PKG}|${PKG}.*not responding|${PKG}.*notResponding|Application is not responding.*${PKG}|Process .*${PKG}.*not responding|Missing app error report, app = ${PKG}.*notResponding = true"
  [ -s "$file" ] || return 1
  LC_ALL=C grep -Eiq "$logcat_anr_re" "$file"
}

target_window_focused_now() {
  local file="$1"
  [ -s "$file" ] || return 1
  LC_ALL=C grep -Eiq "(currentFocus|mCurrentFocus|focusedApp|mFocusedApp)=.*${PKG}" "$file"
}

window_has_target_anr_now() {
  local file="$1"
  [ -s "$file" ] || return 1
  LC_ALL=C grep -Fq "$PKG" "$file" || return 1

  # 真正弹窗一般带 AppErrorDialog/AppNotRespondingDialog；这些即使焦点不在 app
  # 自己窗口上，也要认为是当前 ANR。
  if LC_ALL=C grep -Eiq "AppNotRespondingDialog|AppErrorDialog|Application Not Responding|Application Error:.*${PKG}|${PKG}.*not responding|isn't responding|is not responding|无响应|未响应|没有响应" "$file"; then
    return 0
  fi

  # dumpsys window 顶部的 Application at fault / Input dispatching timed out
  # 可能在 force-stop 后短暂残留。只有当前焦点仍是目标 app 时才当成实时 ANR。
  if target_window_focused_now "$file" \
    && LC_ALL=C grep -Eiq "Application at fault|Window at fault|Input dispatching timed out|not responding" "$file"; then
    return 0
  fi

  return 1
}

dump_anr_dialog_state() {
  local ts="$1"
  "$ADB" shell dumpsys window >"$OUT_DIR/window_${ts}.txt" 2>&1 || true
  "$ADB" shell dumpsys activity processes >"$OUT_DIR/activity_processes_${ts}.txt" 2>&1 || true
  "$ADB" shell uiautomator dump /sdcard/dyidre_window.xml >/dev/null 2>&1 || true
  "$ADB" exec-out cat /sdcard/dyidre_window.xml >"$OUT_DIR/uiautomator_${ts}.xml" 2>/dev/null || true
}

mark_anr_detected() {
  local reason="$1"
  local ts
  ts="$(date '+%Y%m%d_%H%M%S')"
  if [ ! -e "$OUT_DIR/.anr_detected" ]; then
    {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] $reason"
      echo "abort_on_anr=$METASEC_ABORT_ON_ANR"
    } >"$OUT_DIR/.anr_detected"
    echo "[metasec-probe-runner] ANR detected: $reason"
    dump_anr_dialog_state "$ts"
    copy_latest_anr_files
    if bool_env_enabled "$METASEC_ABORT_ON_ANR"; then
      {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] force-stop after ANR"
      } >>"$OUT_DIR/.anr_detected"
      stop_target_pkg_clean || true
    fi
  fi
}

anr_visible_now() {
  if [ -s "$OUT_DIR/.anr_detected" ]; then
    return 0
  fi

  if logcat_has_target_anr "$OUT_DIR/logcat_live.txt"; then
    mark_anr_detected "input guard sees logcat ANR marker for $PKG"
    return 0
  fi

  if [ -z "$(target_pkg_pids | xargs || true)" ]; then
    return 1
  fi

  if bool_env_enabled "$METASEC_ANR_WINDOW_MONITOR" || bool_env_enabled "$METASEC_INPUT_FOCUS_GUARD"; then
    "$ADB" shell dumpsys window >"$OUT_DIR/window_input_guard.txt.tmp" 2>/dev/null || true
    mv "$OUT_DIR/window_input_guard.txt.tmp" "$OUT_DIR/window_input_guard.txt" 2>/dev/null || true
    if bool_env_enabled "$METASEC_ANR_WINDOW_MONITOR" \
      && window_has_target_anr_now "$OUT_DIR/window_input_guard.txt"; then
      mark_anr_detected "input guard sees ANR dialog/window for $PKG"
      return 0
    fi
  fi

  if bool_env_enabled "$METASEC_ANR_ACTIVITY_MONITOR"; then
    "$ADB" shell dumpsys activity processes >"$OUT_DIR/activity_processes_input_guard.txt.tmp" 2>/dev/null || true
    mv "$OUT_DIR/activity_processes_input_guard.txt.tmp" "$OUT_DIR/activity_processes_input_guard.txt" 2>/dev/null || true
    if target_has_activity_anr_state "$OUT_DIR/activity_processes_input_guard.txt"; then
      mark_anr_detected "input guard sees ActivityManager ANR state for $PKG"
      return 0
    fi
  fi

  if bool_env_enabled "$METASEC_ANR_UI_MONITOR" \
    && [ -s "$OUT_DIR/uiautomator_latest.xml" ] \
    && file_has_anr_text "$OUT_DIR/uiautomator_latest.xml"; then
    mark_anr_detected "input guard sees ANR text in latest uiautomator dump for $PKG"
    return 0
  fi

  if bool_env_enabled "$METASEC_ANR_UI_MONITOR" && bool_env_enabled "$METASEC_ANR_INPUT_GUARD_UI_DUMP"; then
    "$ADB" shell "if command -v timeout >/dev/null 2>&1; then timeout 4 uiautomator dump /sdcard/dyidre_window_input_guard.xml >/dev/null 2>&1; else uiautomator dump /sdcard/dyidre_window_input_guard.xml >/dev/null 2>&1; fi" >/dev/null 2>&1 || true
    "$ADB" exec-out cat /sdcard/dyidre_window_input_guard.xml >"$OUT_DIR/uiautomator_input_guard.xml.tmp" 2>/dev/null || true
    mv "$OUT_DIR/uiautomator_input_guard.xml.tmp" "$OUT_DIR/uiautomator_input_guard.xml" 2>/dev/null || true
  fi
  if bool_env_enabled "$METASEC_ANR_UI_MONITOR" && file_has_anr_text "$OUT_DIR/uiautomator_input_guard.xml"; then
    mark_anr_detected "input guard sees ANR text in uiautomator dump for $PKG"
    return 0
  fi

  return 1
}

start_safe_swipe_loop() {
  if ! bool_env_enabled "$METASEC_SAFE_SWIPE"; then
    return 0
  fi

  case "$METASEC_SAFE_SWIPE_START_DELAY" in
    ''|*[!0-9]*)
      METASEC_SAFE_SWIPE_START_DELAY=8
      ;;
  esac
  case "$METASEC_SAFE_SWIPE_INTERVAL" in
    ''|*[!0-9]*)
      METASEC_SAFE_SWIPE_INTERVAL=10
      ;;
  esac
  case "$METASEC_SAFE_SWIPE_COUNT" in
    ''|*[!0-9]*)
      METASEC_SAFE_SWIPE_COUNT=0
      ;;
  esac

  local log_file="$OUT_DIR/safe_swipe.log"
  {
    echo "# ANR-aware safe swipe loop"
    echo "# start_delay=${METASEC_SAFE_SWIPE_START_DELAY}s interval=${METASEC_SAFE_SWIPE_INTERVAL}s count=${METASEC_SAFE_SWIPE_COUNT} coords=${METASEC_SAFE_SWIPE_COORDS}"
    echo "# started_at=$(date '+%Y-%m-%d %H:%M:%S')"
  } >"$log_file"

  (
    sleep "$METASEC_SAFE_SWIPE_START_DELAY"
    sent=0
    while :; do
      ts="$(date '+%Y-%m-%d %H:%M:%S')"
      if anr_visible_now; then
        echo "[$ts] stop: ANR visible before swipe" >>"$log_file"
        break
      fi

      if [ -s "$OUT_DIR/.target_crashed" ]; then
        echo "[$ts] stop: target crash marker exists" >>"$log_file"
        break
      fi

      if [ -z "$(target_pkg_pids | xargs || true)" ]; then
        echo "[$ts] stop: target not running" >>"$log_file"
        break
      fi

      if bool_env_enabled "$METASEC_INPUT_FOCUS_GUARD"; then
        if ! target_window_focused_now "$OUT_DIR/window_input_guard.txt"; then
          echo "[$ts] stop: current focused window is not $PKG; skip input" >>"$log_file"
          break
        fi
      fi

      if anr_visible_now; then
        echo "[$ts] stop: ANR visible immediately before input" >>"$log_file"
        break
      fi

      echo "[$ts] swipe $((sent + 1)): ${METASEC_SAFE_SWIPE_COORDS}" >>"$log_file"
      "$ADB" shell "input swipe ${METASEC_SAFE_SWIPE_COORDS}" >/dev/null 2>&1 || true
      sent=$((sent + 1))

      if anr_visible_now; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] stop: ANR visible immediately after swipe" >>"$log_file"
        break
      fi

      if [ "$METASEC_SAFE_SWIPE_COUNT" -gt 0 ] && [ "$sent" -ge "$METASEC_SAFE_SWIPE_COUNT" ]; then
        echo "[$ts] stop: reached count=$METASEC_SAFE_SWIPE_COUNT" >>"$log_file"
        break
      fi

      sleep "$METASEC_SAFE_SWIPE_INTERVAL"
    done
  ) &
  SAFE_SWIPE_PID="$!"
  echo "[metasec-probe-runner] safe swipe: $log_file"
}

start_anr_monitor() {
  case "$METASEC_ANR_MONITOR" in
    0|false|False|FALSE|no|No|NO|off|Off|OFF) return 0 ;;
  esac

  case "$METASEC_ANR_MONITOR_INTERVAL" in
    ''|*[!0-9]*)
      METASEC_ANR_MONITOR_INTERVAL=1
      ;;
  esac
  case "$METASEC_ANR_UI_DUMP_INTERVAL" in
    ''|*[!0-9]*)
      METASEC_ANR_UI_DUMP_INTERVAL=3
      ;;
  esac

  local log_file="$OUT_DIR/anr_monitor.log"
  {
    echo "# anr/dialog monitor"
    echo "# package=$PKG interval=${METASEC_ANR_MONITOR_INTERVAL}s ui_dump_interval=${METASEC_ANR_UI_DUMP_INTERVAL}s"
    echo "# started_at=$(date '+%Y-%m-%d %H:%M:%S')"
  } >"$log_file"

  (
    ui_tick=0
    while :; do
      ts="$(date '+%Y-%m-%d %H:%M:%S')"
      if [ -z "$(target_pkg_pids | xargs || true)" ]; then
        sleep "$METASEC_ANR_MONITOR_INTERVAL"
        continue
      fi

      if logcat_has_target_anr "$OUT_DIR/logcat_live.txt"; then
        echo "[$ts] EVENT logcat_anr" >>"$log_file"
        mark_anr_detected "logcat ANR/not responding marker for $PKG"
        break
      fi

      if bool_env_enabled "$METASEC_ANR_WINDOW_MONITOR"; then
        "$ADB" shell dumpsys window >"$OUT_DIR/window_latest.txt.tmp" 2>/dev/null || true
        mv "$OUT_DIR/window_latest.txt.tmp" "$OUT_DIR/window_latest.txt" 2>/dev/null || true
        if window_has_target_anr_now "$OUT_DIR/window_latest.txt"; then
          echo "[$ts] EVENT window_anr_dialog" >>"$log_file"
          mark_anr_detected "window ANR dialog visible for $PKG"
          break
        fi
      fi

      if bool_env_enabled "$METASEC_ANR_UI_MONITOR"; then
        ui_tick=$((ui_tick + METASEC_ANR_MONITOR_INTERVAL))
        if [ "$ui_tick" -ge "$METASEC_ANR_UI_DUMP_INTERVAL" ]; then
          ui_tick=0
          "$ADB" shell "if command -v timeout >/dev/null 2>&1; then timeout 4 uiautomator dump /sdcard/dyidre_window_latest.xml >/dev/null 2>&1; else uiautomator dump /sdcard/dyidre_window_latest.xml >/dev/null 2>&1; fi" >/dev/null 2>&1 || true
          "$ADB" exec-out cat /sdcard/dyidre_window_latest.xml >"$OUT_DIR/uiautomator_latest.xml.tmp" 2>/dev/null || true
          mv "$OUT_DIR/uiautomator_latest.xml.tmp" "$OUT_DIR/uiautomator_latest.xml" 2>/dev/null || true
          if file_has_anr_text "$OUT_DIR/uiautomator_latest.xml"; then
            echo "[$ts] EVENT uiautomator_anr_dialog" >>"$log_file"
            mark_anr_detected "uiautomator sees ANR dialog for $PKG"
            break
          fi
        fi
      fi

      if bool_env_enabled "$METASEC_ANR_ACTIVITY_MONITOR"; then
        "$ADB" shell dumpsys activity processes >"$OUT_DIR/activity_processes_latest.txt.tmp" 2>/dev/null || true
        mv "$OUT_DIR/activity_processes_latest.txt.tmp" "$OUT_DIR/activity_processes_latest.txt" 2>/dev/null || true
        if target_has_activity_anr_state "$OUT_DIR/activity_processes_latest.txt"; then
          echo "[$ts] EVENT activity_anr_state" >>"$log_file"
          mark_anr_detected "activity manager marks $PKG as not responding"
          break
        fi
      fi

      sleep "$METASEC_ANR_MONITOR_INTERVAL"
    done
  ) &
  ANR_MONITOR_PID="$!"
  echo "[metasec-probe-runner] anr monitor: $log_file"
}

collect_for_seconds() {
  local seconds="$1"
  local elapsed=0
  while [ "$elapsed" -lt "$seconds" ]; do
    if [ -s "$OUT_DIR/.anr_detected" ]; then
      echo "[metasec-probe-runner] abort collection: ANR detected"
      return 10
    fi
    if [ -s "$OUT_DIR/.target_crashed" ]; then
      echo "[metasec-probe-runner] abort collection: target crash/disappear detected"
      return 11
    fi
    sleep 1
    elapsed=$((elapsed + 1))
  done
  return 0
}

stop_live_monitors() {
  if [ -n "$SAFE_SWIPE_PID" ]; then
    kill "$SAFE_SWIPE_PID" >/dev/null 2>&1 || true
    wait "$SAFE_SWIPE_PID" >/dev/null 2>&1 || true
    SAFE_SWIPE_PID=""
  fi
  if [ -n "$ANR_MONITOR_PID" ]; then
    kill "$ANR_MONITOR_PID" >/dev/null 2>&1 || true
    wait "$ANR_MONITOR_PID" >/dev/null 2>&1 || true
    ANR_MONITOR_PID=""
  fi
  if [ -n "$PROCESS_MONITOR_PID" ]; then
    kill "$PROCESS_MONITOR_PID" >/dev/null 2>&1 || true
    wait "$PROCESS_MONITOR_PID" >/dev/null 2>&1 || true
    PROCESS_MONITOR_PID=""
  fi
  if [ -n "$LOGCAT_MONITOR_PID" ]; then
    kill "$LOGCAT_MONITOR_PID" >/dev/null 2>&1 || true
    wait "$LOGCAT_MONITOR_PID" >/dev/null 2>&1 || true
    LOGCAT_MONITOR_PID=""
  fi
  if [ -n "$DMESG_MONITOR_PID" ]; then
    kill "$DMESG_MONITOR_PID" >/dev/null 2>&1 || true
    wait "$DMESG_MONITOR_PID" >/dev/null 2>&1 || true
    DMESG_MONITOR_PID=""
  fi
}

stop_target_pkg_clean() {
  local pids i

  echo "[metasec-probe-runner] force-stop $PKG"
  "$ADB" shell am force-stop "$PKG" >/dev/null || true

  for i in $(seq 1 20); do
    pids="$(target_pkg_pids | xargs || true)"
    if [ -z "$pids" ]; then
      echo "[metasec-probe-runner] confirmed stopped: $PKG"
      return 0
    fi
    sleep 0.25
  done

  pids="$(target_pkg_pids | xargs || true)"
  if [ -n "$pids" ]; then
    echo "[metasec-probe-runner] warning: force-stop left pids: $pids; killing"
    target_pkg_ps_lines | sed 's/^/[metasec-probe-runner]   /'
    "$ADB" shell "su -M -c 'kill -9 $pids 2>/dev/null || true'" >/dev/null || true
  fi

  for i in $(seq 1 20); do
    pids="$(target_pkg_pids | xargs || true)"
    if [ -z "$pids" ]; then
      echo "[metasec-probe-runner] confirmed stopped after kill: $PKG"
      return 0
    fi
    sleep 0.25
  done

  echo "[metasec-probe-runner] warning: $PKG still running after cleanup:"
  target_pkg_ps_lines | sed 's/^/[metasec-probe-runner]   /'
  return 1
}

cleanup() {
  stop_live_monitors
  if [ "$RF_STDIN_FD_OPEN" = "1" ]; then
    exec 9>&- || true
  fi
  rm -f "$RUNTIME_LOCAL"
  if [ -n "$BOOTSTRAP_LOCAL" ]; then
    rm -f "$BOOTSTRAP_LOCAL"
  fi
  if [ -n "$RF_STDIN" ]; then
    rm -f "$RF_STDIN"
  fi
}
trap cleanup EXIT

run_kind_for_mode() {
# 不同 mode 输出到不同 run_kind，方便后续按证据类型找。
  case "$1" in
    *,*)
      printf '%s\n' "combo"
      ;;
    true-env|trueenv|env)
      printf '%s\n' "true_env_xmedusa"
      ;;
    jnitrace|jni)
      printf '%s\n' "jnitrace"
      ;;
    gum-exevm|gum-4cc10|exevm|gum-http|gum-http-full|http)
      printf '%s\n' "gumtrace"
      ;;
    ssl|ssl-capture)
      printf '%s\n' "ssl"
      ;;
    packet-capture|capture|packet|packets|cronet|dydcd)
      printf '%s\n' "packet_capture"
      ;;
    artcheck|art|maps)
      printf '%s\n' "maps_artmethod"
      ;;
    stackplz|stackplz-bridge)
      printf '%s\n' "edbg_stackplz"
      ;;
    *)
      printf '%s\n' "entrydump"
      ;;
  esac
}

RUN_KIND="$(run_kind_for_mode "$MODE")"
# 一键 RF+mitm 编排器可把 RF 中间日志放到临时目录；普通调用仍默认落仓库 runs/。
RUNS_ROOT="${DYIDRE_RUNS_ROOT:-$DYIDRE_ROOT/runs}"
RUN_ROOT="$RUNS_ROOT/$VERSION/$RUN_KIND"

# 正式固定功能只保留一份 latest；历史对比必须显式 KEEP_HISTORY=1。
# dry run 使用隐藏目录，配合 .gitignore，允许分析时生成但不会上传。
TAG_SAFE="$(printf '%s' "$TAG" | tr -c 'A-Za-z0-9_.-' '_')"
if [ "$DRY_RUN" = "1" ]; then
  OUT_DIR="$RUN_ROOT/.dry-$TAG_SAFE"
elif [ "$KEEP_HISTORY" = "1" ]; then
  OUT_DIR="$RUN_ROOT/$TAG_SAFE"
else
  OUT_DIR="$RUN_ROOT/latest"
fi

# 只清理当前 run_kind 下的旧目录，不触碰其它证据类型；路径由 VERSION/RUN_KIND
# 固定拼出，避免误删仓库其它位置。
if [ "$DRY_RUN" != "1" ] && [ "$KEEP_HISTORY" != "1" ]; then
  case "$RUN_ROOT" in
    ""|"/"|"$DYIDRE_ROOT"|"$DYIDRE_ROOT/runs")
      echo "[metasec-probe-runner] refusing unsafe cleanup path: $RUN_ROOT" >&2
      exit 1
      ;;
    *)
      for old_run in "$RUN_ROOT"/*; do
        [ -d "$old_run" ] || continue
        rm -rf "$old_run"
      done
      ;;
  esac
fi
mkdir -p "$OUT_DIR"

# 生成 runtime JS：只在文件头注入 mode 配置，不复制/修改源码。
#
# SSL / packet-capture 的特殊约束：统一 JS 同时包含 JNI/Art 探针代码，而
# rustFrida 会在脚本加载前扫描整个文本里的 Java.setStealth(...)。如果不
# 处理，未选中的模式也会触发全局 Java stealth 预配置。
#
# - ssl：默认关闭 Java stealth 预扫描；METASEC_SSL_STEALTH=1 只控制
#   SSL native replace 的 Hook.WXSHADOW 第三参数。
# - packet-capture：默认走 wxshadow，并在单独 capture/spawn 下启用 lazy-load：
#   bootstrap 只负责让 RF 在 ART hook 前预配置 Java.setStealth(Hook.WXSHADOW)，
#   App resume 后再加载 slim capture runtime，尽量还原“单独 JS”触发面。
#   临时排障可设 METASEC_PACKET_STEALTH=0 或 METASEC_PACKET_SPAWN_LAZY=0。
python3 - "$SCRIPT_LOCAL" "$RUNTIME_LOCAL" "$MODE" <<'PY'
import json
import os
import pathlib
import sys

def truthy(value, default=False):
    if value is None:
        return default
    return str(value).strip().lower() in {"1", "true", "yes", "on"}

def normalize_java_stealth(value, default="wxshadow"):
    if value is None or str(value).strip() == "":
        return default
    s = str(value).strip().lower()
    if s in {"0", "false", "off", "no", "normal", "none", "hook.normal"}:
        return "normal"
    if s in {"2", "recomp", "hook.recomp"}:
        return "recomp"
    if s in {"1", "true", "on", "yes", "wxshadow", "hook.wxshadow"}:
        return "wxshadow"
    return s

source = pathlib.Path(sys.argv[1])
target = pathlib.Path(sys.argv[2])
modes = [m for m in sys.argv[3].split(",") if m]
mode = modes[0] if modes else "rpc"
config = {"mode": mode} if len(modes) <= 1 else {"modes": modes}
ssl_stealth_enabled = False
if "ssl" in modes:
    ssl_stealth_enabled = truthy(os.environ.get("METASEC_SSL_STEALTH"), False)
    ssl_require_stealth = truthy(os.environ.get("METASEC_SSL_REQUIRE_STEALTH"), ssl_stealth_enabled)
    config["ssl"] = {"stealth": ssl_stealth_enabled, "requireStealth": ssl_require_stealth}
if "packet-capture" in modes:
    packet_java_stealth = normalize_java_stealth(
        os.environ.get("METASEC_PACKET_JAVA_STEALTH", os.environ.get("METASEC_PACKET_STEALTH")),
        "wxshadow",
    )
    packet_hook_jn = truthy(os.environ.get("METASEC_PACKET_HOOK_JN"), False)
    packet_hook_streams = truthy(os.environ.get("METASEC_PACKET_HOOK_STREAMS"), False)
    packet_hook_connections = truthy(os.environ.get("METASEC_PACKET_HOOK_CONNECTIONS"), False)
    packet_upload_via = os.environ.get("METASEC_PACKET_UPLOAD_VIA", "native").strip().lower() or "native"
    packet_native_stealth = normalize_java_stealth(
        os.environ.get("METASEC_PACKET_NATIVE_STEALTH", os.environ.get("METASEC_PACKET_STEALTH")),
        "wxshadow",
    )
    packet = {
        "uploadUrl": os.environ.get("METASEC_PACKET_UPLOAD_URL", os.environ.get("PACKET_UPLOAD_URL", "http://127.0.0.1:8891/up/dy/packets")),
        "version": os.environ.get("METASEC_PACKET_VERSION", "35.1.0"),
        "taskName": os.environ.get("METASEC_PACKET_TASK", "collect_frida"),
        "profile": os.environ.get("METASEC_PACKET_PROFILE", "token"),
        "nativeStealth": packet_native_stealth,
        "javaStealth": packet_java_stealth,
        "requireJavaStealth": truthy(os.environ.get("METASEC_PACKET_REQUIRE_JAVA_STEALTH"), False),
        "hookJN": packet_hook_jn,
        "maxPending": int(os.environ.get("METASEC_PACKET_MAX_PENDING", "96")),
        "maxQueue": int(os.environ.get("METASEC_PACKET_MAX_QUEUE", "16")),
        "maxBodyBytes": int(os.environ.get("METASEC_PACKET_MAX_BODY_BYTES", str(256 * 1024))),
        "hookStreams": packet_hook_streams,
        "hookConnections": packet_hook_connections,
        "uploadVia": packet_upload_via,
        "uploadOnXm": truthy(os.environ.get("METASEC_PACKET_UPLOAD_ON_XM"), True),
        "watchLoader": truthy(os.environ.get("METASEC_PACKET_WATCH_LOADER"), True),
        "captureBodies": truthy(os.environ.get("METASEC_PACKET_CAPTURE_BODIES"), False),
        "captureResponseBody": truthy(os.environ.get("METASEC_PACKET_CAPTURE_RESPONSE_BODY"), True),
        "copyResponseHeaders": truthy(os.environ.get("METASEC_PACKET_COPY_RESPONSE_HEADERS"), True),
        "skipMainThread": truthy(os.environ.get("METASEC_PACKET_SKIP_MAIN_THREAD"), True),
        "useThreadNames": truthy(os.environ.get("METASEC_PACKET_USE_THREAD_NAMES"), False),
        "logUrlMax": int(os.environ.get("METASEC_PACKET_LOG_URL_MAX", "180")),
        "connectTimeoutMs": int(os.environ.get("METASEC_PACKET_CONNECT_TIMEOUT_MS", "1500")),
        "readTimeoutMs": int(os.environ.get("METASEC_PACKET_READ_TIMEOUT_MS", "1500")),
    }
    if truthy(os.environ.get("METASEC_PACKET_ALL"), False):
        packet["filterAll"] = True
    filters = os.environ.get("METASEC_PACKET_FILTERS", "").strip()
    if filters:
        packet["filters"] = [x.strip() for x in filters.split(",") if x.strip()]
    packet_uses_vm_bridge = packet_hook_jn or packet_hook_streams or packet_hook_connections or packet_upload_via == "java"
    packet["nativeOnly"] = not packet_uses_vm_bridge
    if not packet_uses_vm_bridge:
        # 纯 native runtime 要避免出现会触发 rustFrida VM worker 预判的键名。
        packet.pop("javaStealth", None)
        packet.pop("requireJavaStealth", None)
    config["packet"] = packet
source_text = source.read_text(encoding="utf-8")
slim_capture = modes == ["packet-capture"] and truthy(os.environ.get("METASEC_PACKET_SLIM"), True)
def extract_js_function(text, name):
    start = text.find("function " + name)
    if start < 0:
        raise SystemExit("cannot find JS function " + name)
    brace = text.find("{", start)
    if brace < 0:
        raise SystemExit("cannot find JS function body " + name)
    i = brace + 1
    depth = 1
    n = len(text)
    while i < n:
        ch = text[i]
        if ch in "'\"`":
            quote = ch
            i += 1
            while i < n:
                if text[i] == "\\":
                    i += 2
                elif text[i] == quote:
                    i += 1
                    break
                else:
                    i += 1
            continue
        if text.startswith("//", i):
            end = text.find("\n", i)
            i = n if end < 0 else end + 1
            continue
        if text.startswith("/*", i):
            end = text.find("*/", i + 2)
            i = n if end < 0 else end + 2
            continue
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return text[start:i + 1]
        i += 1
    raise SystemExit("unterminated JS function " + name)

packet_cfg_for_source = config.get("packet") or {}
packet_native_only = bool(packet_cfg_for_source.get("nativeOnly"))
if slim_capture:
    slim_func = "__dyidre_mode_packet_capture_native" if packet_native_only else "__dyidre_mode_packet_capture"
    source_text = extract_js_function(source_text, slim_func) + "\n" + slim_func + "();\n"
needs_stealth_prescan_guard = ("ssl" in modes) or ("packet-capture" in modes and not packet_native_only)
if needs_stealth_prescan_guard:
    # 只改代码区里的成员访问，字符串和注释必须原样保留，否则会生成
    # Java["set" + "Stealth"](WXSHADOW) 这样的非法字符串字面量。
    def hide_java_stealth_member_access(text):
        needle = "Java.setStealth"
        out = []
        i = 0
        n = len(text)
        while i < n:
            if text.startswith("//", i):
                end = text.find("\n", i)
                if end < 0:
                    out.append(text[i:])
                    break
                out.append(text[i:end])
                i = end
                continue
            if text.startswith("/*", i):
                end = text.find("*/", i + 2)
                if end < 0:
                    out.append(text[i:])
                    break
                end += 2
                out.append(text[i:end])
                i = end
                continue
            if text[i] in "'\"`":
                quote = text[i]
                j = i + 1
                while j < n:
                    if text[j] == "\\":
                        j += 2
                    elif text[j] == quote:
                        j += 1
                        break
                    else:
                        j += 1
                out.append(text[i:j])
                i = j
                continue
            if text.startswith(needle, i):
                out.append('Java["set" + "Stealth"]')
                i += len(needle)
                continue
            out.append(text[i])
            i += 1
        return "".join(out)

    # rustFrida 的预扫描只识别点号成员访问；计算属性仍等价于同一个 API。
    source_text = hide_java_stealth_member_access(source_text)
prefix_lines = ["globalThis.METASEC_PROBE_CONFIG = " + json.dumps(config, ensure_ascii=False) + ";"]
packet_cfg = config.get("packet") or {}
packet_java_stealth = packet_cfg.get("javaStealth", "normal")
packet_uses_vm_bridge = not bool(packet_cfg.get("nativeOnly"))
if "packet-capture" in modes and packet_uses_vm_bridge and packet_java_stealth == "wxshadow":
    prefix_lines.append("Java.setStealth(Hook.WXSHADOW);")
elif "packet-capture" in modes and packet_uses_vm_bridge and packet_java_stealth == "recomp":
    prefix_lines.append("Java.setStealth(Hook.RECOMP);")
prefix = "\n".join(prefix_lines) + "\n"
target.write_text(prefix + source_text, encoding="utf-8")
PY

cp "$RUNTIME_LOCAL" "$OUT_DIR/runtime_${MODE_SAFE}.js"

# 每次采集自动生成 README，后续看 run 目录能知道它怎么来的。
{
  printf '# %s %s\n\n' "$VERSION" "$MODE"
  printf '| key | value |\n'
  printf '|---|---|\n'
  printf '| version | `%s` |\n' "$VERSION"
  printf '| mode | `%s` |\n' "$MODE"
  printf '| seconds | `%s` |\n' "$RUN_SECONDS"
  printf '| tag | `%s` |\n' "$TAG"
  printf '| package | `%s` |\n' "$PKG"
  printf '| engine | `%s` |\n' "$METASEC_ENGINE"
  printf '| script | `probes/%s/metasec_probe_%s.js` |\n' "$VERSION" "$VERSION"
  printf '| runtime js | `runtime_%s.js` |\n' "$MODE_SAFE"
  printf '| output kind | `%s` |\n' "$RUN_KIND"
  printf '\n## 说明\n\n'
  printf '由 `run_metasec_probe_%s.sh` 生成。原始 console/log 保留在本目录，用于回放和同步 unidbg。\n' "$VERSION"
} > "$OUT_DIR/README.md"

echo "[metasec-probe-runner] mode=$MODE seconds=$RUN_SECONDS tag=$TAG"
echo "[metasec-probe-runner] out=$OUT_DIR"

if [ "$DRY_RUN" = "1" ]; then
  # 本地空转：用于测试 runner、mode 白名单和 runtime 生成是否正常，不碰手机。
  echo "[metasec-probe-runner] DRY_RUN=1, skip adb/rustFrida"
  exit 0
fi

if [ "$METASEC_ENGINE" = "frida" ]; then
  if [ "$MODE" != "packet-capture" ]; then
    echo "[metasec-probe-runner] METASEC_ENGINE=frida currently supports capture/packet-capture only." >&2
    echo "[metasec-probe-runner] For .mitm export, use: RF_ENGINE=frida probes/${VERSION}/run_rf_mitm_auto_${VERSION}.sh ${RUN_SECONDS} ${TAG_SAFE}" >&2
    exit 2
  fi
  HOSTBRIDGE="$DYIDRE_ROOT/scripts/run_rfpkt350_fullbody_hostbridge.py"
  [ -f "$HOSTBRIDGE" ] || { echo "[metasec-probe-runner] hostbridge missing: $HOSTBRIDGE" >&2; exit 1; }
  bridge_args=(
    python3 -u "$HOSTBRIDGE"
    --dyidre-root "$DYIDRE_ROOT"
    --engine frida
    --attach
    --attach-delay "$METASEC_FRIDA_ATTACH_DELAY"
    --frida-runtime "$METASEC_FRIDA_RUNTIME"
    --frida-server-remote "$METASEC_FRIDA_SERVER_REMOTE"
    --run-dir "$OUT_DIR"
    --tag "$TAG_SAFE"
    --seconds "$RUN_SECONDS"
    --pkg "$PKG"
    --upload-url "$PACKET_UPLOAD_URL"
  )
  if [ -n "$FRIDA_BIN" ]; then
    bridge_args+=(--frida-bin "$FRIDA_BIN")
  fi
  if bool_env_enabled "${METASEC_PACKET_ALL:-0}"; then
    bridge_args+=(--capture-all-http)
  fi
  if bool_env_enabled "${METASEC_PACKET_INCLUDE_STATIC:-0}"; then
    bridge_args+=(--include-static-traffic)
  fi
  if bool_env_enabled "${METASEC_PACKET_HOOK_READ:-0}"; then
    bridge_args+=(--hook-read)
  fi
  if bool_env_enabled "$METASEC_SAFE_SWIPE"; then
    bridge_args+=(--swipe-after "$METASEC_SAFE_SWIPE_START_DELAY" --swipe-interval "$METASEC_SAFE_SWIPE_INTERVAL")
  else
    bridge_args+=(--no-swipe)
  fi
  echo "[metasec-probe-runner] delegate capture to stock Frida hostbridge"
  echo "[metasec-probe-runner] out=$OUT_DIR"
  echo "[metasec-probe-runner] upload=$PACKET_UPLOAD_URL"
  "${bridge_args[@]}"
  exit $?
fi

"$ADB" push "$RUNTIME_LOCAL" "$SCRIPT_REMOTE" >/dev/null

# RF 读进程 maps/zygote 有时受 SELinux/proc hidepid 影响；这里做最小化准备。
# APatch 上裸 `su -c` 可能只给 uid=0 但不给完整 capability；`su -M -c`
# 会进入全局 mount namespace 并保留 RF/目录访问需要的能力。
"$ADB" shell "su -M -c \"chmod 755 '$RF_REMOTE'; setenforce 0; mount -o remount,hidepid=0,gid=3009 /proc 2>/dev/null || true\"" >/dev/null || true

if mode_has "packet-capture"; then
  "$ADB" reverse "tcp:${PACKET_PORT}" "tcp:${PACKET_PORT}" >/dev/null
  echo "[metasec-probe-runner] adb reverse tcp:${PACKET_PORT} -> tcp:${PACKET_PORT}"
  echo "[metasec-probe-runner] packet upload url=$PACKET_UPLOAD_URL"
fi

post_rpc() {
# 调 RF HTTP RPC 的小封装。只用于本机 127.0.0.1 forward 后的 RPC。
  method="$1"
  payload="$2"
  curl -sS --max-time 5 \
    -X POST "http://127.0.0.1:${RPC_PORT}/rpc/0/${method}" \
    -H 'Content-Type: application/json' \
    -d "$payload"
}

wait_rpc_ready() {
# 等 RF RPC 可用。counter/branch 需要等 ready 后才能 reset/start/summary。
  tries="${1:-30}"
  i=0
  while [ "$i" -lt "$tries" ]; do
    if post_rpc metaprobeinfo '[]' >"$OUT_DIR/rpc_ready.json" 2>/dev/null; then
      return 0
    fi
    i=$((i + 1))
    sleep 1
  done
  return 1
}

if [ "$MODE" = "rpc" ] || [ "$MODE" = "stackplz" ] || [ "$MODE" = "stackplz-bridge" ]; then
# 常驻 RPC 模式：不会限时退出，用于手工反复注入小 probe 或配合 stackplz。
  "$ADB" push "$DEVICE_RPC_RUNNER" /data/local/tmp/run_rf_rpc_persistent.sh >/dev/null
  "$ADB" shell "su -M -c 'chmod +x /data/local/tmp/run_rf_rpc_persistent.sh'" >/dev/null
  "$ADB" forward "tcp:${RPC_PORT}" "tcp:${RPC_PORT}" >/dev/null
  "$ADB" shell "su -M -c '/data/local/tmp/run_rf_rpc_persistent.sh ${PKG} ${TAG} ${RPC_PORT} ${SCRIPT_REMOTE}'" \
    2>&1 | tee "$OUT_DIR/rustfrida_rpc_start.console"
  if [ "$MODE" = "stackplz" ] || [ "$MODE" = "stackplz-bridge" ]; then
# stackplz bridge 本身只是 RF 里的桥；真正断点由后续 stackplzbreakmodule 下发。
    if wait_rpc_ready 30; then
      post_rpc metaprobeinstall '["stackplz-bridge"]' | tee "$OUT_DIR/stackplz_bridge_install.json"
    else
      echo "[metasec-probe-runner] warning: RF RPC not ready; bridge not installed"
    fi
  fi
  echo "[metasec-probe-runner] RF RPC: http://127.0.0.1:${RPC_PORT}/rpc/0/"
  echo "[metasec-probe-runner] Try:"
  echo "  curl -s -X POST http://127.0.0.1:${RPC_PORT}/rpc/0/metaprobeinfo -H 'Content-Type: application/json' -d '[]'"
  exit 0
fi

stop_target_pkg_clean || true
clear_device_runtime_logs
start_logcat_monitor
start_dmesg_monitor
start_target_monitor
start_anr_monitor

# 清掉本次会拉回的已知输出，避免误读上一轮残留。
"$ADB" shell "su -M -c \"rm -f /data/user/0/${PKG}/files/true_env_xmedusa_${VERSION}.log /data/data/${PKG}/gumtrace_4cc10.log /data/data/${PKG}/gumtrace_getHttpHeadVerify_${VERSION}_full_once.log\"" >/dev/null || true

if [ "$MODE" = "packet-capture" ]; then
  case "${METASEC_PACKET_ATTACH:-0}" in
    1|true|True|TRUE|yes|Yes|YES|on|On|ON)
      echo "[metasec-probe-runner] packet attach mode: start app, then --pid inject"
      "$ADB" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null
      sleep "${METASEC_PACKET_ATTACH_DELAY:-5}"
      TARGET_PID="$("$ADB" shell pidof "$PKG" 2>/dev/null | tr -d '\r' | awk '{print $1}')"
      if [ -z "$TARGET_PID" ]; then
        echo "[metasec-probe-runner] ERROR: package not running for attach: $PKG" >&2
        exit 1
      fi
      echo "[metasec-probe-runner] attach pid=$TARGET_PID"
      "$ADB" shell "su -M -c \"cd /data/local/tmp && (sleep '${RUN_SECONDS}'; echo exit) | '${RF_REMOTE}' --pid '${TARGET_PID}' -l '${SCRIPT_REMOTE}'\"" \
        2>&1 | tee "$OUT_DIR/rustfrida_console.log"
      if packet_force_stop_after; then
        stop_target_pkg_clean || true
        echo "[metasec-probe-runner] force-stopped $PKG after packet-capture"
      fi
      echo "[metasec-probe-runner] done: $OUT_DIR"
      exit 0
      ;;
  esac

  if packet_spawn_lazy_enabled; then
    PACKET_BOOTSTRAP_STEALTH="$(packet_java_stealth_mode)"
    PACKET_LAZY_DELAY="${METASEC_PACKET_SPAWN_LAZY_DELAY:-8}"
    case "$PACKET_LAZY_DELAY" in
      ''|*[!0-9]*)
        echo "[metasec-probe-runner] METASEC_PACKET_SPAWN_LAZY_DELAY must be an integer: $PACKET_LAZY_DELAY" >&2
        exit 2
        ;;
    esac

    BOOTSTRAP_LOCAL_BASE="$(mktemp "${TMPDIR:-/tmp}/metasec_probe_${VERSION}_${MODE_SAFE}_bootstrap.XXXXXX")"
    BOOTSTRAP_LOCAL="${BOOTSTRAP_LOCAL_BASE}.js"
    mv "$BOOTSTRAP_LOCAL_BASE" "$BOOTSTRAP_LOCAL"
    if packet_uses_vm_bridge; then
      BOOTSTRAP_KIND="java-stealth"
    else
      BOOTSTRAP_KIND="native-noop"
    fi
    python3 - "$BOOTSTRAP_LOCAL" "$PACKET_BOOTSTRAP_STEALTH" "$BOOTSTRAP_KIND" <<'PY'
import pathlib
import sys

target = pathlib.Path(sys.argv[1])
mode = sys.argv[2]
kind = sys.argv[3]
if kind == "java-stealth":
    if mode == "recomp":
        decl = "Java.setStealth(Hook.RECOMP)"
    else:
        decl = "Java.setStealth(Hook.WXSHADOW)"
    text = (
        "// dyidre packet lazy bootstrap.\n"
        "// rustFrida 会预扫描 Java.setStealth(...)；放在 dead branch 里只用于提前配置 stealth。\n"
        "if (false) " + decl + ";\n"
        "console.log('[packet350-bootstrap] declared java stealth=" + mode + "; capture runtime waits for host loadjs after resume');\n"
    )
else:
    text = (
        "// dyidre packet lazy bootstrap (native-only).\n"
        "console.log('[packet350-bootstrap] native-only noop; capture runtime waits for host reload after resume');\n"
    )
target.write_text(text, encoding="utf-8")
PY
    cp "$BOOTSTRAP_LOCAL" "$OUT_DIR/runtime_${MODE_SAFE}_bootstrap.js"
    "$ADB" push "$BOOTSTRAP_LOCAL" "$BOOTSTRAP_REMOTE" >/dev/null

    echo "[metasec-probe-runner] packet lazy spawn: stealth=$PACKET_BOOTSTRAP_STEALTH kind=$BOOTSTRAP_KIND delay=${PACKET_LAZY_DELAY}s"
    echo "[metasec-probe-runner] bootstrap=$BOOTSTRAP_REMOTE"
    RF_STDIN="$(mktemp -u "${TMPDIR:-/tmp}/metasec_rf_stdin_${VERSION}_${MODE_SAFE}.XXXXXX")"
    mkfifo "$RF_STDIN"
    cat "$RF_STDIN" | "$ADB" shell "su -M -c \"cd /data/local/tmp && RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME='${RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME}' RF_POST_RESUME_JAVA_WORKER_MODE=skip '${RF_REMOTE}' --connect-timeout '${RF_CONNECT_TIMEOUT}' --spawn '${PKG}' -l '${BOOTSTRAP_REMOTE}'\"" \
      2>&1 | tee "$OUT_DIR/rustfrida_console.log" &
    rf_log_pid="$!"
    exec 9>"$RF_STDIN"
    RF_STDIN_FD_OPEN=1

    echo "[metasec-probe-runner] waiting ${PACKET_LAZY_DELAY}s after spawn/resume before loading capture runtime"
    sleep "$PACKET_LAZY_DELAY"
    echo "[metasec-probe-runner] reload single capture runtime from device file"
    printf '%%reload %s\n' "$SCRIPT_REMOTE" >&9 || true
    start_safe_swipe_loop

    echo "[metasec-probe-runner] collecting for ${RUN_SECONDS}s"
    COLLECTION_ABORTED=0
    collect_for_seconds "$RUN_SECONDS" || COLLECTION_ABORTED=$?

    printf 'exit\n' >&9 || true
    exec 9>&- || true
    RF_STDIN_FD_OPEN=0
    wait "$rf_log_pid" || true
    if [ "${COLLECTION_ABORTED:-0}" != "0" ] && bool_env_enabled "$METASEC_ABORT_ON_ANR"; then
      stop_target_pkg_clean || true
      echo "[metasec-probe-runner] force-stopped $PKG after ANR"
    fi
    if packet_force_stop_after; then
      stop_live_monitors
      stop_target_pkg_clean || true
      echo "[metasec-probe-runner] force-stopped $PKG after packet-capture"
    fi
    echo "[metasec-probe-runner] done: $OUT_DIR"
    exit 0
  fi
fi

if mode_has "counter-one" || mode_has "counter-multi" || mode_has "branch"; then
# 这几类 mode 的结果通过 RPC summary 取回：
#   counter-one   -> metacountsummary.json
#   counter-multi -> metamultisummary.json
#   branch        -> metabranchsummary.json
# 这里不能再用 `(sleep N; echo exit) | rustfrida`：
#   旧写法会让 RF 在 host 调 summary 前后刚好退出，导致 curl Empty reply、summary 文件缺失。
#   现在用 FIFO 持有 RF stdin：先采集、先取 summary，最后再主动写 `exit`。
    "$ADB" forward "tcp:${RPC_PORT}" "tcp:${RPC_PORT}" >/dev/null
    RF_STDIN="$(mktemp -u "${TMPDIR:-/tmp}/metasec_rf_stdin_${VERSION}_${MODE_SAFE}.XXXXXX")"
    mkfifo "$RF_STDIN"
    cat "$RF_STDIN" | "$ADB" shell "su -M -c \"cd /data/local/tmp && RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME='${RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME}' '${RF_REMOTE}' --connect-timeout '${RF_CONNECT_TIMEOUT}' --spawn '${PKG}' -l '${SCRIPT_REMOTE}' --rpc-port '127.0.0.1:${RPC_PORT}'\"" \
      2>&1 | tee "$OUT_DIR/rustfrida_console.log" &
    rf_log_pid="$!"
    exec 9>"$RF_STDIN"
    RF_STDIN_FD_OPEN=1

    if wait_rpc_ready 30; then
      if mode_has "counter-one"; then
        post_rpc metacountreset "[\"${TAG}\"]" | tee "$OUT_DIR/metacountreset.json"
      fi
      if mode_has "counter-multi"; then
        post_rpc metamultistart "[8,\"${TAG}\"]" | tee "$OUT_DIR/metamultistart.json"
      fi
      if mode_has "branch"; then
        post_rpc metabranchreset "[\"${TAG}\"]" | tee "$OUT_DIR/metabranchreset.json"
        # branch mode 不在 dlopen 回调里直接 patch；这里等 libmetasec_ml.so
        # 加载后再通过 RPC 安装，避免 loader 回调内密集 inline hook 不稳定。
        for i in $(seq 1 10); do
          branch_install_resp="$(post_rpc metabranchinstall '[]' || true)"
          printf '%s\n' "$branch_install_resp" | tee "$OUT_DIR/metabranchinstall.json"
          if [[ "$branch_install_resp" == *'"result":"ok"'* || "$branch_install_resp" == *already-installed* ]]; then
            break
          fi
          sleep 1
        done
      fi
    else
      echo "[metasec-probe-runner] warning: RF RPC not ready; summary may be missing"
    fi

    echo "[metasec-probe-runner] trigger request now; collecting for ${RUN_SECONDS}s"
    start_safe_swipe_loop
    COLLECTION_ABORTED=0
    collect_for_seconds "$RUN_SECONDS" || COLLECTION_ABORTED=$?

    if mode_has "counter-one"; then
      post_rpc metacountsummary '[]' | tee "$OUT_DIR/metacountsummary.json" || true
    fi
    if mode_has "counter-multi"; then
      post_rpc metamultisummary '[]' | tee "$OUT_DIR/metamultisummary.json" || true
    fi
    if mode_has "branch"; then
      post_rpc metabranchsummary '[]' | tee "$OUT_DIR/metabranchsummary.json" || true
    fi
    if mode_has "packet-capture"; then
      post_rpc metapacketsummary '[]' | tee "$OUT_DIR/metapacketsummary.json" || true
    fi

    printf 'exit\n' >&9 || true
    exec 9>&- || true
    RF_STDIN_FD_OPEN=0
    wait "$rf_log_pid" || true
    if [ "${COLLECTION_ABORTED:-0}" != "0" ] && bool_env_enabled "$METASEC_ABORT_ON_ANR"; then
      stop_target_pkg_clean || true
      echo "[metasec-probe-runner] force-stopped $PKG after ANR"
    fi
    echo "[metasec-probe-runner] done: $OUT_DIR"
    exit 0
fi

# 普通限时模式：适合 true-env/jnitrace/xheader/native-vmp/gumtrace/ssl/capture/artcheck。
# 这些 mode 主要看 console 或脚本写出的文件，不依赖 RPC summary。这里也用 FIFO
# 持有 RF stdin，这样 ANR 监控命中时可以提前写 exit/force-stop，不再等 sleep 结束。
RF_STDIN="$(mktemp -u "${TMPDIR:-/tmp}/metasec_rf_stdin_${VERSION}_${MODE_SAFE}.XXXXXX")"
mkfifo "$RF_STDIN"
cat "$RF_STDIN" | "$ADB" shell "su -M -c \"cd /data/local/tmp && RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME='${RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME}' '${RF_REMOTE}' --connect-timeout '${RF_CONNECT_TIMEOUT}' --spawn '${PKG}' -l '${SCRIPT_REMOTE}'\"" \
  2>&1 | tee "$OUT_DIR/rustfrida_console.log" &
rf_log_pid="$!"
exec 9>"$RF_STDIN"
RF_STDIN_FD_OPEN=1

echo "[metasec-probe-runner] collecting for ${RUN_SECONDS}s"
start_safe_swipe_loop
COLLECTION_ABORTED=0
collect_for_seconds "$RUN_SECONDS" || COLLECTION_ABORTED=$?

printf 'exit\n' >&9 || true
exec 9>&- || true
RF_STDIN_FD_OPEN=0
wait "$rf_log_pid" || true

if [ "${COLLECTION_ABORTED:-0}" != "0" ] && bool_env_enabled "$METASEC_ABORT_ON_ANR"; then
  stop_target_pkg_clean || true
  echo "[metasec-probe-runner] force-stopped $PKG after ANR"
fi

if mode_has "packet-capture"; then
  if packet_force_stop_after; then
    stop_live_monitors
    stop_target_pkg_clean || true
    echo "[metasec-probe-runner] force-stopped $PKG after packet-capture"
  fi
fi

pull_if_exists() {
# 某些 mode 会在 App 私有目录或 /data/data 下写原始文件；存在就拉回。
  remote_path="$1"
  local_name="$2"
  "$ADB" exec-out "su -M -c \"cat '$remote_path' 2>/dev/null\"" > "$OUT_DIR/$local_name" || true
  if [ ! -s "$OUT_DIR/$local_name" ]; then
    rm -f "$OUT_DIR/$local_name"
  else
    echo "[metasec-probe-runner] pulled $local_name"
  fi
}

pull_if_exists "/data/user/0/${PKG}/files/true_env_xmedusa_${VERSION}.log" "true_env_xmedusa_${VERSION}.log"
pull_if_exists "/data/data/${PKG}/gumtrace_4cc10.log" "gumtrace_4cc10.log"
pull_if_exists "/data/data/${PKG}/gumtrace_getHttpHeadVerify_${VERSION}_full_once.log" "gumtrace_getHttpHeadVerify_${VERSION}_full_once.log"

if mode_has "true-env"; then
# true-env 是后续 unidbg 同步环境的基准，需要立刻抽取 summary/bin/b64 并刷新 RUNS 索引。
  if [ -s "$OUT_DIR/true_env_xmedusa_${VERSION}.log" ]; then
    python3 "$DYIDRE_ROOT/scripts/extract_true_env_xmedusa.py" "$OUT_DIR" --version "$VERSION" --force
    python3 "$DYIDRE_ROOT/scripts/index_true_env_runs.py" \
      --root "$RUN_ROOT" \
      --out-md "$RUN_ROOT/RUNS.md" \
      --out-json "$RUN_ROOT/runs_manifest.json"
  else
    echo "[metasec-probe-runner] warning: true-env raw log not found"
  fi
fi

echo "[metasec-probe-runner] done: $OUT_DIR"
