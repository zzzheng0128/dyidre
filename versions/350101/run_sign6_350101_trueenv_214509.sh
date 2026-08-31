#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

S1_FILE="${1:-${METASEC_S1_FILE:-}}"
S2_FILE="${2:-${METASEC_S2_FILE:-}}"

HAS_EXTRA_PROPS=0
if [[ -n "$S1_FILE" || -n "$S2_FILE" ]]; then
  if [[ -z "$S1_FILE" || -z "$S2_FILE" ]]; then
    echo "usage: $0 [s1_file s2_file]" >&2
    echo "or set METASEC_S1_FILE and METASEC_S2_FILE" >&2
    exit 2
  fi
  HAS_EXTRA_PROPS=1
fi

cd "$ROOT/unidbg"

METASEC_ROOTFS="${METASEC_ROOTFS:-$ROOT/unidbg/unidbg-android/target/rootfs_pixel6_350101_trueenv_20260831_214509}"
METASEC_FIXED_PID="${METASEC_FIXED_PID:-13556}"
METASEC_FIXED_TID="${METASEC_FIXED_TID:-13710}"
METASEC_FIXED_CURRENT_TIME_MILLIS="${METASEC_FIXED_CURRENT_TIME_MILLIS:-1788183915398}"
METASEC_FIXED_ELAPSED_REALTIME="${METASEC_FIXED_ELAPSED_REALTIME:-218661108}"
METASEC_FIXED_ELAPSED_REALTIME_NANOS="${METASEC_FIXED_ELAPSED_REALTIME_NANOS:-218661108386512}"
METASEC_FIXED_MONOTONIC_NANOS="${METASEC_FIXED_MONOTONIC_NANOS:-218661059672197}"
METASEC_FIXED_BOOTTIME_NANOS="${METASEC_FIXED_BOOTTIME_NANOS:-218661108386512}"
METASEC_FIXED_RANDOM_SEED="${METASEC_FIXED_RANDOM_SEED:-0x350101}"

COMMON_ARGS=(
  -pl unidbg-android -am \
  -DfailIfNoTests=false \
  -Dmaven.test.skip=false \
  '-Dtest=Sign6_350101#testMetasec' \
  -Dmetasec.rootfs="$METASEC_ROOTFS" \
  -Dmetasec.deterministic=true \
  -Dmetasec.fixedPid="$METASEC_FIXED_PID" \
  -Dmetasec.fixedTid="$METASEC_FIXED_TID" \
  -Dmetasec.fixedCurrentTimeMillis="$METASEC_FIXED_CURRENT_TIME_MILLIS" \
  -Dmetasec.fixedElapsedRealtime="$METASEC_FIXED_ELAPSED_REALTIME" \
  -Dmetasec.fixedElapsedRealtimeNanos="$METASEC_FIXED_ELAPSED_REALTIME_NANOS" \
  -Dmetasec.fixedMonotonicNanos="$METASEC_FIXED_MONOTONIC_NANOS" \
  -Dmetasec.fixedBoottimeNanos="$METASEC_FIXED_BOOTTIME_NANOS" \
  -Dmetasec.fixedRandomSeed="$METASEC_FIXED_RANDOM_SEED" \
  -Dmetasec.traceDeterministicRandom=true
)

if [[ "$HAS_EXTRA_PROPS" == "1" ]]; then
  ./mvnw "${COMMON_ARGS[@]}" "-Dmetasec.s1File=$S1_FILE" "-Dmetasec.s2File=$S2_FILE" test
else
  ./mvnw "${COMMON_ARGS[@]}" test
fi
