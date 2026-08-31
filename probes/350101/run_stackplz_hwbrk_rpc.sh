#!/system/bin/sh
# 设备侧：启动 stackplz dev RPC server，用于 RF 下发硬件断点/watch。
#
# 使用场景：
#   - RF 已经用 mode=rpc 启动；
#   - RF 里安装了 mode=stackplz-bridge；
#   - host 通过 /rpc/0/stackplzbreakmodule 按 module+offset 下断点。
#
# 设备上执行：
#   /data/local/tmp/run_stackplz_hwbrk_rpc.sh req01 41718
#
# 配合：
#   metasec_probe_350101.js mode=stackplz-bridge
#
# 输出：
#   /data/local/tmp/stackplz_hwbrk_rf_<tag>.console
#   /data/local/tmp/stackplz_hwbrk_rf_<tag>.log
set -eu

tag="${1:-manual}"
port="${2:-41718}"
base="/data/local/tmp/stackplz_hwbrk_rf_${tag}"

# 同 tag 重跑时先中断旧 server，避免端口被占用。
if [ -f "${base}.pid" ]; then
    old_pid="$(cat "${base}.pid" 2>/dev/null || true)"
    if [ -n "${old_pid}" ]; then
        kill -INT "${old_pid}" >/dev/null 2>&1 || true
    fi
fi

rm -f "${base}.console" "${base}.log" "${base}.pid"

cd /data/local/tmp
# --rpc/--rpc-path 来自 stackplz dev；旧版 stackplz 没有这个参数。
# --stack/--regs/--mstack/--getoff 是我们要的证据：命中位置、寄存器、调用栈、模块偏移。
nohup /data/local/tmp/stackplz_dev \
    --rpc \
    --rpc-path "127.0.0.1:${port}" \
    --stack \
    --regs \
    --mstack \
    --getoff \
    -o "stackplz_hwbrk_rf_${tag}.log" \
    > "${base}.console" 2>&1 &

echo "$!" > "${base}.pid"
echo "tag=${tag} port=${port} pid=$(cat "${base}.pid") console=${base}.console log=${base}.log"
