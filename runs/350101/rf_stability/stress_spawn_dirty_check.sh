#!/usr/bin/env bash
set -u

RUN_DIR="${1:-/Users/freeman/project/douyin/dyidre/runs/350101/rf_stability/stress_spawn_dirty_20}"
COUNT="${2:-20}"
HOLD_SECS="${3:-5}"
mkdir -p "$RUN_DIR"
: > "$RUN_DIR/summary.tsv"

ensure_reader() {
  if adb shell 'test -x /data/local/tmp/read_zygote_stagefright_tail' >/dev/null 2>&1; then
    return 0
  fi
  adb push /Users/freeman/project/douyin/dyidre/runs/350101/rf_stability/read_zygote_stagefright_tail /data/local/tmp/read_zygote_stagefright_tail >/dev/null || return 1
  adb shell 'chmod 755 /data/local/tmp/read_zygote_stagefright_tail' >/dev/null 2>&1 || return 1
}

check_payload_clean() {
  local label="$1"
  local out_dir="$2"
  local phone_out rc
  ensure_reader || return 10
  phone_out="/data/local/tmp/rf_dirty_${label}_$$_$RANDOM"
  adb shell "su -c 'rm -rf $phone_out; /data/local/tmp/read_zygote_stagefright_tail 4048 $phone_out'" > "$out_dir/${label}.dirty.txt" 2>&1
  rc=$?
  adb pull "$phone_out/mem.bin" "$out_dir/${label}.mem.bin" >/dev/null 2>&1 || true
  adb pull "$phone_out/file.bin" "$out_dir/${label}.file.bin" >/dev/null 2>&1 || true
  [ -f "$out_dir/${label}.file.bin" ] && cp "$out_dir/${label}.file.bin" "$out_dir/${label}.file.padded.bin" || true
  adb shell "su -c 'rm -rf $phone_out'" >/dev/null 2>&1 || true
  return "$rc"
}

fail=0
for i in $(seq 1 "$COUNT"); do
  tag=$(printf "%02d" "$i")
  phone_log="/data/local/tmp/rf_spawn_dirty_${tag}.log"
  cycle_dir="$RUN_DIR/$tag"
  mkdir -p "$cycle_dir"

  printf "cycle %s start\n" "$tag"
  check_payload_clean "pre" "$cycle_dir"
  pre_rc=$?

  adb shell 'su -c '\''am force-stop com.ss.android.ugc.aweme; sleep 0.5; logcat -c'\''' >/dev/null 2>&1 || true
  adb shell "su -c 'rm -f $phone_log; cd /data/local/tmp; RF_DIAG_SPAWN_ONLY=1 RF_DIAG_HOLD_SECS=$HOLD_SECS RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME=1 ./rustfrida --connect-timeout 60 --spawn com.ss.android.ugc.aweme -o $phone_log'" > "$cycle_dir/console.log" 2>&1
  rf_rc=$?

  adb pull "$phone_log" "$cycle_dir/rustfrida.log" >/dev/null 2>&1 || true
  adb shell 'su -c '\''logcat -d -v threadtime | grep -E "ANR|am_crash|FATAL|Fatal signal|SIGSEGV|tombstone|Input dispatching timed out|Application Not Responding|rustFrida|libstagefright|com.ss.android.ugc.aweme" || true'\''' > "$cycle_dir/logcat.log" 2>/dev/null || true

  check_payload_clean "post" "$cycle_dir"
  post_rc=$?

  if grep -Eq "RF_DIAG_SPAWN_ONLY: 进程 .*存活 ${HOLD_SECS}s" "$cycle_dir/console.log" "$cycle_dir/rustfrida.log" 2>/dev/null; then
    alive=1
  else
    alive=0
  fi
  if grep -Eq "Zygote .*patch 已还原" "$cycle_dir/console.log" "$cycle_dir/rustfrida.log" 2>/dev/null; then
    restored=1
  else
    restored=0
  fi
  if grep -Eq "ANR in com\\.ss\\.android\\.ugc\\.aweme|am_crash.*com\\.ss\\.android\\.ugc\\.aweme|Fatal signal .*com\\.ss\\.android\\.ugc\\.aweme|SIGSEGV.*com\\.ss\\.android\\.ugc\\.aweme|Input dispatching timed out.*com\\.ss\\.android\\.ugc\\.aweme|Application Not Responding.*com\\.ss\\.android\\.ugc\\.aweme|>>> com\\.ss\\.android\\.ugc\\.aweme <<<|name: .*ss\\.android\\.ugc\\.aweme" "$cycle_dir/logcat.log" "$cycle_dir/console.log" "$cycle_dir/rustfrida.log" 2>/dev/null; then
    bad=1
  else
    bad=0
  fi

  printf "%s\trf_rc=%s\tpre_clean=%s\tpost_clean=%s\talive=%s\trestored=%s\tbad=%s\n" \
    "$tag" "$rf_rc" "$pre_rc" "$post_rc" "$alive" "$restored" "$bad" | tee -a "$RUN_DIR/summary.tsv"

  if [ "$rf_rc" -ne 0 ] || [ "$pre_rc" -ne 0 ] || [ "$post_rc" -ne 0 ] || [ "$alive" -ne 1 ] || [ "$restored" -ne 1 ] || [ "$bad" -ne 0 ]; then
    fail=$((fail + 1))
  fi
done

adb shell 'su -c '\''am force-stop com.ss.android.ugc.aweme; ps -A | grep -E "rustfrida|com.ss.android.ugc.aweme" || true'\''' > "$RUN_DIR/final_process_check.txt" 2>&1 || true
printf "stress_fail=%s\n" "$fail"
exit "$fail"
