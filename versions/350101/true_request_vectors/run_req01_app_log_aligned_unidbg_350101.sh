#!/usr/bin/env bash
set -euo pipefail

TASK_ROOT="/Users/freeman/project/douyin"
S1_FILE="$TASK_ROOT/dyidre/versions/350101/true_request_vectors/req01_app_log_true_s1.txt"
S2_FILE="$TASK_ROOT/dyidre/versions/350101/true_request_vectors/req01_app_log_true_s2.txt"
RUN_LOG="${1:-$TASK_ROOT/unidbg/unidbg-android/target/sign6_350101_true_req01_app_log_aligned_rerun.log}"

cd "$TASK_ROOT/unidbg"

./mvnw -pl unidbg-android -am -DfailIfNoTests=false -Dmaven.test.skip=false '-Dtest=Sign6_350101#testMetasec' \
  -Dmetasec.backend=unicorn2 \
  -Dmetasec.rootfs="$TASK_ROOT/unidbg/unidbg-android/target/rootfs_pixel6_350101_20260831_132930" \
  -Dmetasec.deterministic=true \
  -Dmetasec.fixedPid=13556 \
  -Dmetasec.fixedTid=13710 \
  -Dmetasec.fixedCurrentTimeMillis=1788148652047 \
  -Dmetasec.fixedElapsedRealtime=183397757 \
  -Dmetasec.fixedElapsedRealtimeNanos=183397757386512 \
  -Dmetasec.fixedMonotonicNanos=183397708672197 \
  -Dmetasec.fixedBoottimeNanos=183397757386512 \
  -Dmetasec.fixedRandomSeed=0x350101 \
  -Dmetasec.traceDeterministicRandom=true \
  -Dmetasec.alignTrueDeviceHttpRuntime=true \
  -Dmetasec.s1File="$S1_FILE" \
  -Dmetasec.s2File="$S2_FILE" \
  -Dmetasec.countOneRequest=true \
  -Dmetasec.countOneRequest.maxSamples=80 \
  -Dmetasec.dumpManagedSignPacks=true \
  -Dmetasec.managedSignPackMaxEvents=16 \
  -Dmetasec.managedSignPackMaxBytes=0x180 \
  -Dmetasec.watchXMedusaValue=true \
  -Dmetasec.xMedusaWatchMaxEvents=2 \
  -Dmetasec.xMedusaWatchMaxBytes=0x240 \
  -Dmetasec.xMedusaWatchDumpInputs=true \
  -Dmetasec.dumpXHeaderPuts=true \
  -Dmetasec.xHeaderPutMaxEvents=80 \
  -Dmetasec.xHeaderPutMaxBytes=0x160 \
  test > "$RUN_LOG" 2>&1

echo "$RUN_LOG"
