#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${TMPDIR:-/tmp}/metasec_350101_c_recovery"
CC_BIN="${CC:-cc}"
CFLAGS_BASE=(-std=c11 -O2 -Wall -Wextra)
CFLAGS_LIB=(-std=c11 -O2 -Wall -Wextra -Wno-unused-function -Wno-unused-const-variable)

mkdir -p "$BUILD_DIR"

compile_and_run() {
    local src="$1"
    local out="$2"
    echo "[build] $src"
    "$CC_BIN" "${CFLAGS_BASE[@]}" "$SCRIPT_DIR/$src" -o "$BUILD_DIR/$out"
    echo "[run]   $out"
    "$BUILD_DIR/$out"
}

compile_and_run cf61_sm3_recovered_350101.c cf61_sm3
compile_and_run cf48_f17_recovered_350101.c cf48_f17
compile_and_run cf41_simon128_256_recovered_350101.c cf41_simon128_256
compile_and_run cf43_aes128_cbc_recovered_350101.c cf43_aes128_cbc
compile_and_run f8_medusa_mini_xor_recovered_350101.c f8_medusa_mini_xor
compile_and_run f12_medusa_subpack_recovered_350101.c f12_medusa_subpack
compile_and_run source_work_vector_selfcheck_350101.c source_work_vector_selfcheck

echo "[build] linked recovered-C suite"
"$CC_BIN" "${CFLAGS_LIB[@]}" -DMETASEC_350101_NO_MAIN \
    -c "$SCRIPT_DIR/cf61_sm3_recovered_350101.c" \
    -o "$BUILD_DIR/cf61_sm3.o"
"$CC_BIN" "${CFLAGS_LIB[@]}" -DMETASEC_350101_NO_MAIN \
    -c "$SCRIPT_DIR/cf48_f17_recovered_350101.c" \
    -o "$BUILD_DIR/cf48_f17.o"
"$CC_BIN" "${CFLAGS_LIB[@]}" -DMETASEC_350101_NO_MAIN \
    -c "$SCRIPT_DIR/cf41_simon128_256_recovered_350101.c" \
    -o "$BUILD_DIR/cf41_simon128_256.o"
"$CC_BIN" "${CFLAGS_LIB[@]}" -DMETASEC_350101_NO_MAIN \
    -c "$SCRIPT_DIR/cf43_aes128_cbc_recovered_350101.c" \
    -o "$BUILD_DIR/cf43_aes128_cbc.o"
"$CC_BIN" "${CFLAGS_LIB[@]}" -DMETASEC_350101_NO_MAIN \
    -c "$SCRIPT_DIR/f8_medusa_mini_xor_recovered_350101.c" \
    -o "$BUILD_DIR/f8_medusa_mini_xor.o"
"$CC_BIN" "${CFLAGS_LIB[@]}" -DMETASEC_350101_NO_MAIN \
    -c "$SCRIPT_DIR/f12_medusa_subpack_recovered_350101.c" \
    -o "$BUILD_DIR/f12_medusa_subpack.o"
"$CC_BIN" "${CFLAGS_LIB[@]}" -DMETASEC_350101_NO_MAIN \
    -c "$SCRIPT_DIR/source_work_vector_selfcheck_350101.c" \
    -o "$BUILD_DIR/source_work_vector_selfcheck.o"
"$CC_BIN" "${CFLAGS_BASE[@]}" \
    "$SCRIPT_DIR/metasec_350101_recovered_c_suite.c" \
    "$BUILD_DIR/cf61_sm3.o" \
    "$BUILD_DIR/cf48_f17.o" \
    "$BUILD_DIR/cf41_simon128_256.o" \
    "$BUILD_DIR/cf43_aes128_cbc.o" \
    "$BUILD_DIR/f8_medusa_mini_xor.o" \
    "$BUILD_DIR/f12_medusa_subpack.o" \
    "$BUILD_DIR/source_work_vector_selfcheck.o" \
    -o "$BUILD_DIR/metasec_350101_recovered_c_suite"

echo "[run]   metasec_350101_recovered_c_suite"
"$BUILD_DIR/metasec_350101_recovered_c_suite"

echo "[build] x-header algorithm suite"
"$CC_BIN" "${CFLAGS_BASE[@]}" \
    "$SCRIPT_DIR/x_headers_algorithms_350101.c" \
    "$BUILD_DIR/cf61_sm3.o" \
    "$BUILD_DIR/cf48_f17.o" \
    "$BUILD_DIR/cf41_simon128_256.o" \
    "$BUILD_DIR/cf43_aes128_cbc.o" \
    "$BUILD_DIR/f8_medusa_mini_xor.o" \
    "$BUILD_DIR/f12_medusa_subpack.o" \
    "$BUILD_DIR/source_work_vector_selfcheck.o" \
    -o "$BUILD_DIR/x_headers_algorithms_350101"

echo "[run]   x_headers_algorithms_350101"
"$BUILD_DIR/x_headers_algorithms_350101"

echo "[build] x-header algorithm object"
"$CC_BIN" "${CFLAGS_LIB[@]}" -DMETASEC_350101_NO_MAIN \
    -c "$SCRIPT_DIR/x_headers_algorithms_350101.c" \
    -o "$BUILD_DIR/x_headers_algorithms.o"

echo "[build] deterministic fixed s1/s2 signer"
"$CC_BIN" "${CFLAGS_BASE[@]}" \
    "$SCRIPT_DIR/metasec_350101_fixed_signer.c" \
    "$BUILD_DIR/x_headers_algorithms.o" \
    "$BUILD_DIR/cf61_sm3.o" \
    "$BUILD_DIR/cf48_f17.o" \
    "$BUILD_DIR/cf41_simon128_256.o" \
    "$BUILD_DIR/cf43_aes128_cbc.o" \
    "$BUILD_DIR/f8_medusa_mini_xor.o" \
    "$BUILD_DIR/f12_medusa_subpack.o" \
    "$BUILD_DIR/source_work_vector_selfcheck.o" \
    -o "$BUILD_DIR/metasec_350101_fixed_signer"

echo "[run]   metasec_350101_fixed_signer"
"$BUILD_DIR/metasec_350101_fixed_signer"

echo "[ok] all recovered C oracles passed; build dir: $BUILD_DIR"
