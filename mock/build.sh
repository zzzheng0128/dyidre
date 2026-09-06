#!/bin/sh
# Build libmock.so without any NDK / cross linker:
#   clang emits an aarch64-linux ELF .o; so_linker.py links it into a .so.
set -e
cd "$(dirname "$0")"
python3 gen_ciphers.py
# -fno-semantic-interposition: 导出符号不可抢占，&JNI_OnLoad 直接
# adrp+add（与商用加固库的 -Bsymbolic 形态一致，也避免引入 GOT）
clang -target aarch64-linux-android24 -nostdlib -ffreestanding -fno-builtin \
      -fno-stack-protector -fno-semantic-interposition -fPIC -O1 -c mock.c -o mock.o
python3 so_linker.py mock.o libmock.so
echo "built libmock.so"
