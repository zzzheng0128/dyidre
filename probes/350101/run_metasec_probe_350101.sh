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
#   artcheck         ArtMethod/maps 检测面检查。
#
# 输出：
#   runs/350101/<kind>/<tag>/
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
RF_REMOTE="${RF_REMOTE:-/data/local/tmp/rustfrida}"
RPC_PORT="${RPC_PORT:-19191}"
VERSION="350101"

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
  artcheck         ArtMethod/maps 检测面检查
  stackplz-bridge  RF 内 stackplz RPC bridge

说明：
  DRY_RUN=1 只生成本地 runtime JS/README，不 adb push，不启动 rustFrida。
EOF
}

normalize_mode() {
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

MODE_SAFE="$(printf '%s' "$MODE" | tr -c 'A-Za-z0-9_.-' '_')"

# 统一 JS 是源码；SCRIPT_REMOTE 是本次运行推到手机的 runtime JS。
SCRIPT_LOCAL="$DYIDRE_ROOT/probes/$VERSION/metasec_probe_${VERSION}.js"
DEVICE_RPC_RUNNER="$DYIDRE_ROOT/probes/$VERSION/run_rf_rpc_persistent.sh"
SCRIPT_REMOTE="/data/local/tmp/metasec_probe_${VERSION}_${MODE_SAFE}_${TAG}.js"
RUNTIME_LOCAL="$(mktemp "${TMPDIR:-/tmp}/metasec_probe_${VERSION}_${MODE_SAFE}.XXXXXX.js")"
RF_STDIN=""
RF_STDIN_FD_OPEN=0

cleanup() {
  if [ "$RF_STDIN_FD_OPEN" = "1" ]; then
    exec 9>&- || true
  fi
  rm -f "$RUNTIME_LOCAL"
  if [ -n "$RF_STDIN" ]; then
    rm -f "$RF_STDIN"
  fi
}
trap cleanup EXIT

run_kind_for_mode() {
# 不同 mode 输出到不同 run_kind，方便后续按证据类型找。
  case "$1" in
    true-env|trueenv|env)
      printf '%s\n' "true_env_xmedusa"
      ;;
    jnitrace|jni)
      printf '%s\n' "jnitrace"
      ;;
    gum-exevm|gum-4cc10|exevm|gum-http|gum-http-full|http)
      printf '%s\n' "gumtrace"
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
RUN_ROOT="$DYIDRE_ROOT/runs/$VERSION/$RUN_KIND"
OUT_DIR="$RUN_ROOT/$TAG"
mkdir -p "$OUT_DIR"

# 生成 runtime JS：只在文件头注入 mode 配置，不复制/修改源码。
python3 - "$SCRIPT_LOCAL" "$RUNTIME_LOCAL" "$MODE" <<'PY'
import json
import pathlib
import sys

source = pathlib.Path(sys.argv[1])
target = pathlib.Path(sys.argv[2])
mode = sys.argv[3]
config = {"mode": mode}
prefix = "globalThis.METASEC_PROBE_CONFIG = " + json.dumps(config, ensure_ascii=False) + ";\n"
target.write_text(prefix + source.read_text(encoding="utf-8"), encoding="utf-8")
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
  printf '| script | `probes/%s/metasec_probe_%s.js` |\n' "$VERSION" "$VERSION"
  printf '| runtime js | `runtime_%s.js` |\n' "$MODE_SAFE"
  printf '| output kind | `%s` |\n' "$RUN_KIND"
  printf '\n## 说明\n\n'
  printf '由 `run_metasec_probe_%s.sh` 生成。原始 console/log 保留在本目录，用于回放和同步 unidbg。\n' "$VERSION"
} > "$OUT_DIR/README.md"

echo "[metasec-probe-runner] mode=$MODE seconds=$RUN_SECONDS tag=$TAG"
echo "[metasec-probe-runner] out=$OUT_DIR"

if [ "${DRY_RUN:-0}" = "1" ]; then
  # 本地空转：用于测试 runner、mode 白名单和 runtime 生成是否正常，不碰手机。
  echo "[metasec-probe-runner] DRY_RUN=1, skip adb/rustFrida"
  exit 0
fi

"$ADB" push "$RUNTIME_LOCAL" "$SCRIPT_REMOTE" >/dev/null

# RF 读进程 maps/zygote 有时受 SELinux/proc hidepid 影响；这里做最小化准备。
"$ADB" shell "su -c \"chmod 755 '$RF_REMOTE'; setenforce 0; mount -o remount,hidepid=0,gid=3009 /proc 2>/dev/null || true\"" >/dev/null || true

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
  "$ADB" shell "su -c 'chmod +x /data/local/tmp/run_rf_rpc_persistent.sh'" >/dev/null
  "$ADB" forward "tcp:${RPC_PORT}" "tcp:${RPC_PORT}" >/dev/null
  "$ADB" shell "su -c '/data/local/tmp/run_rf_rpc_persistent.sh ${PKG} ${TAG} ${RPC_PORT} ${SCRIPT_REMOTE}'" \
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

"$ADB" shell am force-stop "$PKG" >/dev/null || true

# 清掉本次会拉回的已知输出，避免误读上一轮残留。
"$ADB" shell "su -c \"rm -f /data/user/0/${PKG}/files/true_env_xmedusa_${VERSION}.log /data/data/${PKG}/gumtrace_4cc10.log /data/data/${PKG}/gumtrace_getHttpHeadVerify_${VERSION}_full_once.log\"" >/dev/null || true

case "$MODE" in
  counter-one|counter|one|counter-multi|multi|branch)
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
    cat "$RF_STDIN" | "$ADB" shell "su -c \"cd /data/local/tmp && '${RF_REMOTE}' --spawn '${PKG}' -l '${SCRIPT_REMOTE}' --rpc-port '127.0.0.1:${RPC_PORT}'\"" \
      2>&1 | tee "$OUT_DIR/rustfrida_console.log" &
    rf_log_pid="$!"
    exec 9>"$RF_STDIN"
    RF_STDIN_FD_OPEN=1

    if wait_rpc_ready 30; then
      case "$MODE" in
        counter-one|counter|one)
          post_rpc metacountreset "[\"${TAG}\"]" | tee "$OUT_DIR/metacountreset.json"
          ;;
        counter-multi|multi)
          post_rpc metamultistart "[8,\"${TAG}\"]" | tee "$OUT_DIR/metamultistart.json"
          ;;
        branch)
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
          ;;
      esac
    else
      echo "[metasec-probe-runner] warning: RF RPC not ready; summary may be missing"
    fi

    echo "[metasec-probe-runner] trigger request now; collecting for ${RUN_SECONDS}s"
    sleep "$RUN_SECONDS"

    case "$MODE" in
      counter-one|counter|one)
        post_rpc metacountsummary '[]' | tee "$OUT_DIR/metacountsummary.json" || true
        ;;
      counter-multi|multi)
        post_rpc metamultisummary '[]' | tee "$OUT_DIR/metamultisummary.json" || true
        ;;
      branch)
        post_rpc metabranchsummary '[]' | tee "$OUT_DIR/metabranchsummary.json" || true
        ;;
    esac

    printf 'exit\n' >&9 || true
    exec 9>&- || true
    RF_STDIN_FD_OPEN=0
    wait "$rf_log_pid" || true
    echo "[metasec-probe-runner] done: $OUT_DIR"
    exit 0
    ;;
esac

# 普通限时模式：适合 true-env/jnitrace/xheader/native-vmp/gumtrace/artcheck。
# 这些 mode 主要看 console 或脚本写出的文件，不依赖 RPC summary。
"$ADB" shell "su -c \"cd /data/local/tmp && (sleep '${RUN_SECONDS}'; echo exit) | '${RF_REMOTE}' --spawn '${PKG}' -l '${SCRIPT_REMOTE}'\"" \
  2>&1 | tee "$OUT_DIR/rustfrida_console.log"

pull_if_exists() {
# 某些 mode 会在 App 私有目录或 /data/data 下写原始文件；存在就拉回。
  remote_path="$1"
  local_name="$2"
  "$ADB" exec-out "su -c \"cat '$remote_path' 2>/dev/null\"" > "$OUT_DIR/$local_name" || true
  if [ ! -s "$OUT_DIR/$local_name" ]; then
    rm -f "$OUT_DIR/$local_name"
  else
    echo "[metasec-probe-runner] pulled $local_name"
  fi
}

pull_if_exists "/data/user/0/${PKG}/files/true_env_xmedusa_${VERSION}.log" "true_env_xmedusa_${VERSION}.log"
pull_if_exists "/data/data/${PKG}/gumtrace_4cc10.log" "gumtrace_4cc10.log"
pull_if_exists "/data/data/${PKG}/gumtrace_getHttpHeadVerify_${VERSION}_full_once.log" "gumtrace_getHttpHeadVerify_${VERSION}_full_once.log"

if [ "$MODE" = "true-env" ] || [ "$MODE" = "trueenv" ] || [ "$MODE" = "env" ]; then
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
