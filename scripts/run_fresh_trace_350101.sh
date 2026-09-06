#!/usr/bin/env bash
set -euo pipefail

# Sign6_350101_FreshTrace 一键运行脚本。
# 产物固定覆盖到 dyidre/runs/350101/fresh_trace/（不堆积时间戳目录）。
#
# 用法：
#   ./scripts/run_fresh_trace_350101.sh            # 标准跑
#   MAX_EVENTS=50000 ./scripts/run_fresh_trace_350101.sh
#   CODE_TRACE=1 ./scripts/run_fresh_trace_350101.sh   # 追加指令级 trace（量大）

UNIDBG_ROOT="/Users/freeman/project/douyin/unidbg"
RUN_DIR="/Users/freeman/project/douyin/dyidre/runs/350101/fresh_trace"
MAX_EVENTS="${MAX_EVENTS:-20000}"

mkdir -p "$RUN_DIR"

cd "$UNIDBG_ROOT"
./mvnw -pl unidbg-android -am \
  -DfailIfNoTests=false \
  -Dmaven.test.skip=false \
  '-Dtest=Sign6_350101_FreshTrace#testFreshTrace' \
  -Dmetasec.backend=unicorn2 \
  -Dmetasec.rootfs="$UNIDBG_ROOT/unidbg-android/target/rootfs_pixel6_350101_20260831_132930" \
  -Dmetasec.apk.350101="/Users/freeman/project/douyin/douyin_35_0_0/dy351_vivo.apk" \
  -Dmetasec.deterministic=true \
  -Dmetasec.fixedPid=13556 \
  -Dmetasec.fixedTid=13710 \
  -Dmetasec.fixedCurrentTimeMillis=1788148652047 \
  -Dmetasec.fixedElapsedRealtime=183397757 \
  -Dmetasec.fixedElapsedRealtimeNanos=183397757386512 \
  -Dmetasec.fixedMonotonicNanos=183397708672197 \
  -Dmetasec.fixedBoottimeNanos=183397757386512 \
  -Dmetasec.fixedRandomSeed=0x350101 \
  -Dmetasec.alignTrueDeviceHttpRuntime=true \
  -Dmetasec.s1File="$UNIDBG_ROOT/unidbg-android/src/test/resources/metasec/350101/req01_app_log_s1.txt" \
  -Dmetasec.s2File="$UNIDBG_ROOT/unidbg-android/src/test/resources/metasec/350101/req01_app_log_s2.txt" \
  -Dmetasec.freshTrace.dir="$RUN_DIR" \
  -Dmetasec.freshTrace.maxEvents="$MAX_EVENTS" \
  ${CODE_TRACE:+-Dmetasec.freshTrace.code=true} \
  test > "$RUN_DIR/stdout.log" 2>&1

echo "[run_fresh_trace] exit=$? logs in $RUN_DIR"
ls -la "$RUN_DIR"
