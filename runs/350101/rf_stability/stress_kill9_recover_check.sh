#!/usr/bin/env bash
set -u

RUN_DIR="${1:-/Users/freeman/project/douyin/dyidre/runs/350101/rf_stability/stress_kill9_recover}"
COUNT="${2:-5}"
mkdir -p "$RUN_DIR"
: > "$RUN_DIR/summary.tsv"

ensure_reader() {
  if adb shell 'test -x /data/local/tmp/read_zygote_stagefright_tail' >/dev/null 2>&1; then
    return 0
  fi
  adb push /Users/freeman/project/douyin/dyidre/runs/350101/rf_stability/read_zygote_stagefright_tail /data/local/tmp/read_zygote_stagefright_tail >/dev/null || return 1
  adb shell 'chmod 755 /data/local/tmp/read_zygote_stagefright_tail' >/dev/null 2>&1 || return 1
}

check_payload() {
  local label="$1"
  local out_dir="$2"
  local phone_out rc
  ensure_reader || return 10
  phone_out="/data/local/tmp/rf_dirty_${label}_$$_$RANDOM"
  adb shell "su -c 'rm -rf $phone_out; /data/local/tmp/read_zygote_stagefright_tail 4048 $phone_out'" > "$out_dir/${label}.dirty.txt" 2>&1
  rc=$?
  adb pull "$phone_out/mem.bin" "$out_dir/${label}.mem.bin" >/dev/null 2>&1 || true
  adb pull "$phone_out/file.bin" "$out_dir/${label}.file.bin" >/dev/null 2>&1 || true
  adb shell "su -c 'rm -rf $phone_out'" >/dev/null 2>&1 || true
  return "$rc"
}

wait_for_pattern() {
  local phone_file="$1"
  local pattern="$2"
  local max_wait="$3"
  local waited=0
  while [ "$waited" -lt "$max_wait" ]; do
    if adb shell "su -c 'grep -q \"$pattern\" $phone_file 2>/dev/null'" >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
    waited=$((waited + 1))
  done
  return 1
}

fail=0
for i in $(seq 1 "$COUNT"); do
  tag=$(printf "%02d" "$i")
  cycle_dir="$RUN_DIR/$tag"
  mkdir -p "$cycle_dir"
  phone_log="/data/local/tmp/rf_kill9_${tag}.log"
  phone_console="/data/local/tmp/rf_kill9_${tag}.console"
  phone_pid="/data/local/tmp/rf_kill9_${tag}.pid"
  recover_log="/data/local/tmp/rf_kill9_recover_${tag}.log"

  printf "kill9 cycle %s start\n" "$tag"

  adb shell 'su -c '\''am force-stop com.ss.android.ugc.aweme; sleep 0.5; logcat -c'\''' >/dev/null 2>&1 || true

  check_payload "pre" "$cycle_dir"
  pre_rc=$?
  if [ "$pre_rc" -ne 0 ]; then
    adb shell "su -c 'cd /data/local/tmp; RF_DIAG_SPAWN_ONLY=1 RF_DIAG_HOLD_SECS=3 RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME=1 ./rustfrida --verbose --connect-timeout 60 --spawn com.ss.android.ugc.aweme -o $recover_log'" > "$cycle_dir/pre_recover.console" 2>&1 || true
    adb shell 'su -c '\''am force-stop com.ss.android.ugc.aweme'\''' >/dev/null 2>&1 || true
    check_payload "pre_after_forced_recover" "$cycle_dir"
    pre_recover_rc=$?
  else
    pre_recover_rc=0
  fi

  adb shell "su -c 'rm -f $phone_log $phone_console $phone_pid; cd /data/local/tmp; RF_DIAG_SPAWN_ONLY=1 RF_DIAG_HOLD_SECS=60 ./rustfrida --verbose --connect-timeout 60 --spawn com.ss.android.ugc.aweme -o $phone_log > $phone_console 2>&1 & echo \$! > $phone_pid'" >/dev/null 2>&1
  wait_for_pattern "$phone_console" "子进程 .*已恢复运行" 25
  ready_rc=$?

  rfp=$(adb shell "su -c 'cat $phone_pid 2>/dev/null'" | tr -d '\r')
  if [ -n "$rfp" ]; then
    adb shell "su -c 'kill -9 $rfp 2>/dev/null || true'" >/dev/null 2>&1 || true
  fi
  sleep 2

  adb pull "$phone_log" "$cycle_dir/kill9.rustfrida.log" >/dev/null 2>&1 || true
  adb pull "$phone_console" "$cycle_dir/kill9.console.log" >/dev/null 2>&1 || true

  check_payload "after_kill9" "$cycle_dir"
  after_kill_rc=$?

  adb shell "su -c 'cd /data/local/tmp; RF_DIAG_SPAWN_ONLY=1 RF_DIAG_HOLD_SECS=3 RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME=1 ./rustfrida --verbose --connect-timeout 60 --spawn com.ss.android.ugc.aweme -o $recover_log'" > "$cycle_dir/recover.console" 2>&1
  recover_rc=$?
  adb pull "$recover_log" "$cycle_dir/recover.log" >/dev/null 2>&1 || true
  adb shell 'su -c '\''logcat -d -v threadtime | grep -E "ANR|am_crash|FATAL|Fatal signal|SIGSEGV|tombstone|Input dispatching timed out|Application Not Responding|rustFrida|libstagefright|com.ss.android.ugc.aweme" || true'\''' > "$cycle_dir/logcat.log" 2>/dev/null || true

  check_payload "post_recover" "$cycle_dir"
  post_rc=$?

  if grep -Eq "already patched|using backing file because zygote already patched" "$cycle_dir/recover.log" "$cycle_dir/recover.console" 2>/dev/null; then
    stale_seen=1
  else
    stale_seen=0
  fi
  if grep -Eq "Zygote .*patch 已还原" "$cycle_dir/recover.log" "$cycle_dir/recover.console" 2>/dev/null; then
    restored=1
  else
    restored=0
  fi
  if grep -Eq "ANR in com\\.ss\\.android\\.ugc\\.aweme|am_crash.*com\\.ss\\.android\\.ugc\\.aweme|Fatal signal .*com\\.ss\\.android\\.ugc\\.aweme|SIGSEGV.*com\\.ss\\.android\\.ugc\\.aweme|Input dispatching timed out.*com\\.ss\\.android\\.ugc\\.aweme|Application Not Responding.*com\\.ss\\.android\\.ugc\\.aweme|>>> com\\.ss\\.android\\.ugc\\.aweme <<<|name: .*ss\\.android\\.ugc\\.aweme" "$cycle_dir/logcat.log" "$cycle_dir/kill9.console.log" "$cycle_dir/kill9.rustfrida.log" "$cycle_dir/recover.log" "$cycle_dir/recover.console" 2>/dev/null; then
    bad=1
  else
    bad=0
  fi

  printf "%s\tpre_clean=%s\tpre_recover=%s\tready=%s\tafter_kill_dirty=%s\trecover_rc=%s\tpost_clean=%s\tstale_seen=%s\trestored=%s\tbad=%s\n" \
    "$tag" "$pre_rc" "$pre_recover_rc" "$ready_rc" "$after_kill_rc" "$recover_rc" "$post_rc" "$stale_seen" "$restored" "$bad" | tee -a "$RUN_DIR/summary.tsv"

  if [ "$pre_recover_rc" -ne 0 ] || [ "$ready_rc" -ne 0 ] || [ "$after_kill_rc" -ne 1 ] || [ "$recover_rc" -ne 0 ] || [ "$post_rc" -ne 0 ] || [ "$stale_seen" -ne 1 ] || [ "$restored" -ne 1 ] || [ "$bad" -ne 0 ]; then
    fail=$((fail + 1))
  fi

  adb shell 'su -c '\''am force-stop com.ss.android.ugc.aweme'\''' >/dev/null 2>&1 || true
done

check_payload "final" "$RUN_DIR"
final_rc=$?
printf "final_clean=%s\n" "$final_rc" | tee -a "$RUN_DIR/summary.tsv"
if [ "$final_rc" -ne 0 ]; then
  fail=$((fail + 1))
fi

adb shell 'su -c '\''am force-stop com.ss.android.ugc.aweme; ps -A | grep -E "rustfrida|com.ss.android.ugc.aweme" || true'\''' > "$RUN_DIR/final_process_check.txt" 2>&1 || true
printf "kill9_recover_fail=%s\n" "$fail"
exit "$fail"
