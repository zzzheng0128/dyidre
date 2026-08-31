#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

S1_FILE="${1:-${METASEC_S1_FILE:-}}"
S2_FILE="${2:-${METASEC_S2_FILE:-}}"

EXTRA_PROPS=""
if [[ -n "$S1_FILE" || -n "$S2_FILE" ]]; then
  if [[ -z "$S1_FILE" || -z "$S2_FILE" ]]; then
    echo "usage: $0 [s1_file s2_file]" >&2
    echo "or set METASEC_S1_FILE and METASEC_S2_FILE" >&2
    exit 2
  fi
  EXTRA_PROPS="1"
fi

cd "$ROOT/unidbg"
COMMON_ARGS=(
  -pl unidbg-android -am
  -DfailIfNoTests=false
  -Dmaven.test.skip=false
  '-Dtest=Sign6_350101#testMetasec'
  -Dmetasec.deterministic=true
  -Dmetasec.fixedPid=12345
  -Dmetasec.fixedCurrentTimeMillis=1788136882000
  -Dmetasec.fixedElapsedRealtime=123456789
  -Dmetasec.fixedElapsedRealtimeNanos=123456789000000
  -Dmetasec.fixedMonotonicNanos=123456789000000
  -Dmetasec.fixedRandomSeed=0x350101
  -Dmetasec.traceDeterministicRandom=true
)

if [[ -n "$EXTRA_PROPS" ]]; then
  ./mvnw "${COMMON_ARGS[@]}" "-Dmetasec.s1File=$S1_FILE" "-Dmetasec.s2File=$S2_FILE" test
else
  ./mvnw "${COMMON_ARGS[@]}" test
fi
