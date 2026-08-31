#!/system/bin/sh
# 设备侧：启动一个常驻 rustFrida RPC session。
#
# 使用场景：
#   - host 先用 run_metasec_probe_350101.sh rpc 启动；
#   - 后面通过 /rpc/0/metaprobeinstall 动态安装 counter/branch/stackplz bridge；
#   - 不想每换一个小 probe 都重启 App。
#
# 设备上也可手工执行：
#   /data/local/tmp/run_rf_rpc_persistent.sh \
#     com.ss.android.ugc.aweme req01 19191 /data/local/tmp/metasec_probe_350101_rpc.js
#
# host 需要：
#   adb forward tcp:19191 tcp:19191
#
# 设备输出：
#   /data/local/tmp/rf_rpc_persistent_<tag>.console
#   /data/local/tmp/rf_rpc_persistent_<tag>.log
#
# 关键点：
#   - stdin 必须保持打开，否则 rustFrida session/RPC 会退出；
#   - 所以这里用 tail -f /dev/null，不要改成 echo exit。
set -eu

pkg="${1:-com.ss.android.ugc.aweme}"
tag="${2:-manual}"
port="${3:-19191}"
script="${4:-/data/local/tmp/metasec_probe_350101.js}"

base="/data/local/tmp/rf_rpc_persistent_${tag}"

# 如果上一轮同 tag 还活着，先温和中断，避免两个 RF 抢同一个包。
if [ -f "${base}.pid" ]; then
    old_pid="$(cat "${base}.pid" 2>/dev/null || true)"
    if [ -n "${old_pid}" ]; then
        kill -INT "${old_pid}" >/dev/null 2>&1 || true
    fi
fi

pkill -x rustfrida >/dev/null 2>&1 || true
am force-stop "${pkg}" >/dev/null 2>&1 || true

rm -f "${base}.console" "${base}.log" "${base}.pid"

# RF 需要 stdin 常驻，RPC 才一直可用。
nohup sh -c 'tail -f /dev/null | /data/local/tmp/rustfrida --spawn "$1" -l "$2" --rpc-port "127.0.0.1:$3" -o "$4"' \
    rf_rpc_persistent_worker "${pkg}" "${script}" "${port}" "${base}.log" \
    > "${base}.console" 2>&1 &

echo "$!" > "${base}.pid"
echo "tag=${tag} pkg=${pkg} port=${port} pid=$(cat "${base}.pid") console=${base}.console log=${base}.log"
