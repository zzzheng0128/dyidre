#!/system/bin/sh
# 设备侧：standalone stackplz offset 栈采样。
#
# 使用场景：
#   - 已经知道 App uid；
#   - 已经知道设备上的 libmetasec_ml.so 绝对路径；
#   - 只想快速验证某个 offset 会不会命中、调用栈是什么。
#
# 设备上执行：
#   /data/local/tmp/run_stackplz_offset_test.sh \
#     <uid> <absolute-lib-path> 0x4cc10 req01_4cc10
#
# 输出：
#   /data/local/tmp/stackplz_offset_<tag>.console
#   /data/local/tmp/stackplz_offset_<tag>.log
#
# 如果不知道 so 路径/base，不要用这个；先用 mode=rpc + mode=stackplz-bridge。
set -eu

uid_value="${1:?uid required}"
library_path="${2:?library path required}"
offset_value="${3:?offset required}"
run_tag="${4:-manual}"
base="/data/local/tmp/stackplz_offset_${run_tag}"

rm -f "${base}.console" "${base}.log" "${base}.pid"

# 这里使用 stackplz 普通 stack 子命令，不依赖 RF RPC。
/data/local/tmp/stackplz \
  stack \
  --uid "${uid_value}" \
  --out "stackplz_offset_${run_tag}.log" \
  --library "${library_path}" \
  --offset "${offset_value}" \
  --stack \
  --regs \
  > "${base}.console" 2>&1 &

echo "$!" > "${base}.pid"
