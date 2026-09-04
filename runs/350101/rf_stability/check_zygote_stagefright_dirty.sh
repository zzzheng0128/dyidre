#!/system/bin/sh
set -u

LEN="${1:-4048}"
OUT_DIR="${2:-/data/local/tmp/rf_dirty_check}"
mkdir -p "$OUT_DIR" || exit 2

PID=""
for p in /proc/[0-9]*; do
  [ -r "$p/cmdline" ] || continue
  name="$(tr '\000' '\n' < "$p/cmdline" 2>/dev/null | head -n 1)"
  if [ "$name" = "zygote64" ]; then
    PID="${p#/proc/}"
    break
  fi
done

if [ -z "$PID" ]; then
  echo "error=no_zygote64"
  exit 2
fi

MAP_LINE="$(grep '/system/lib64/libstagefright.so' "/proc/$PID/maps" 2>/dev/null | grep 'r-xp' | head -n 1)"
if [ -z "$MAP_LINE" ]; then
  echo "error=no_stagefright_rx_map"
  echo "pid=$PID"
  exit 2
fi

RANGE="$(echo "$MAP_LINE" | awk '{print $1}')"
MAP_OFF_HEX="$(echo "$MAP_LINE" | awk '{print $3}')"
PATHNAME="$(echo "$MAP_LINE" | awk '{print $6}')"
START_HEX="${RANGE%-*}"
END_HEX="${RANGE#*-}"

START_DEC=$((0x$START_HEX))
END_DEC=$((0x$END_HEX))
MAP_OFF_DEC=$((0x$MAP_OFF_HEX))
BASE_DEC=$((END_DEC - 4096))
FILE_OFF_DEC=$((MAP_OFF_DEC + BASE_DEC - START_DEC))
BASE_HEX="$(printf '%x' "$BASE_DEC")"
FILE_OFF_HEX="$(printf '%x' "$FILE_OFF_DEC")"

MEM_BIN="$OUT_DIR/mem.bin"
FILE_BIN="$OUT_DIR/file.bin"

dd if="/proc/$PID/mem" of="$MEM_BIN" bs=4096 skip="$BASE_DEC" count="$LEN" iflag=count_bytes,skip_bytes status=none 2>/dev/null || {
  echo "error=read_proc_mem_failed"
  echo "pid=$PID"
  exit 3
}

dd if="$PATHNAME" of="$FILE_BIN" bs=4096 skip="$FILE_OFF_DEC" count="$LEN" iflag=count_bytes,skip_bytes status=none 2>/dev/null || {
  echo "error=read_backing_failed"
  echo "pid=$PID"
  echo "path=$PATHNAME"
  exit 3
}

cmp "$MEM_BIN" "$FILE_BIN" >/dev/null 2>&1
DIRTY="$?"

echo "pid=$PID"
echo "map=$MAP_LINE"
echo "base=0x$BASE_HEX"
echo "fileoff=0x$FILE_OFF_HEX"
echo "len=$LEN"
echo "mem_sha=$(sha256sum "$MEM_BIN" 2>/dev/null | awk '{print $1}')"
echo "file_sha=$(sha256sum "$FILE_BIN" 2>/dev/null | awk '{print $1}')"
echo "dirty=$DIRTY"
echo "mem_head=$(od -An -tx1 -N32 "$MEM_BIN" 2>/dev/null | tr -d ' \n')"
echo "file_head=$(od -An -tx1 -N32 "$FILE_BIN" 2>/dev/null | tr -d ' \n')"

exit "$DIRTY"
