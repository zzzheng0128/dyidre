# 350.101 true-device vs Unidbg 指令差异验证

更新时间：2026-08-31

## 输入与日志

- 真机 GumTrace：`dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350101_full_once.log`
- 真机 managed helper 序列：`dyidre/versions/350101/instr_diff_350101/true350101_req01_managed_blr_seq_with_index.tsv`
- Unidbg 固定时间分支日志：`unidbg/unidbg-android/target/sign6_350101_true_req01_branch_fixedtime_20260831.log`
- Unidbg 旧等价分支日志：`unidbg/unidbg-android/target/sign6_350101_true_req01_branch450_20260831.log`
- Unidbg 未固定时间 instrseq 日志：`unidbg/unidbg-android/target/sign6_350101_true_req01_instrseq_current_200k_20260831.log`
- Unidbg 固定时间 instrseq 日志：`unidbg/unidbg-android/target/sign6_350101_true_req01_instrseq_fixedtime_200k_20260831.log`
- Unidbg 固定时间 instrseq：`unidbg/unidbg-android/target/sign6_350101_true_req01_instrseq_fixedtime_200k_20260831.seq`
- Unidbg raw instrseq：`unidbg/unidbg-android/target/sign6_350101_true_req01_instrseq_unicorn2_full_20260831.seq`
- 请求输入：
  - `dyidre/versions/350101/multi_request_compare_350101/true_req_01_s1.txt`
  - `dyidre/versions/350101/multi_request_compare_350101/true_req_01_s2.txt`

## 当前结论

`exeVMInner_0x4CC10` 当前不是第一跑偏点。按同一请求、同一时间/随机源对齐后，真机和 Unidbg 在 managed VM 调 native helper 的语义序列完全一致：

```text
true-device managed_native_blr_15454c = 311
unidbg fixed-time managed_native_blr_15454c = 311
prefix_match = 311
first_diff = none
X-Khronos = 1788159560
```

也就是说，350.101 当前至少在 `0x149CA8 buildSignedHttpHeadersInner_350` 这一条 HTTP 签名请求上，managed VM 的 CF 分支选择和 native helper 路径已经对齐。

## 三组验证结果

| 运行 | Unidbg hits | 真机 hits | 结果 |
|---|---:|---:|---|
| `branch450` | 311 | 311 | 完全一致 |
| `branch_fixedtime` | 311 | 311 | 完全一致，作为当前基准 |
| `instrseq_fixedtime_200k` | 311 | 311 | managed helper 完全一致，raw 指令仍有 helper 级差异 |
| `instrseq_current_200k` | 316 | 311 | 第 15 次开始分叉，原因是时间未固定 |
| `slotset` | 69 | 311 | 只采到前 69 次，前缀一致 |

旧的 `sign6_350101_true_req01_blrwin_20260831.log` 不是当前等价基准；它当时没有稳定固定时间/运行条件，里面“第 16 次 first diff”的结论已经废弃。

## 未固定时间时的真实分叉点

未固定时间的 `instrseq_current_200k` 跑法里，`X-Khronos/currentTime` 变了：

```text
true / fixed-time X-Khronos = 1788159560
unfixed currentTime-derived X-Khronos = 1788159772
```

对应 managed helper 第 15 次开始跑偏：

```text
true/fixed #15: CF=0x0b -> target=0x162b38
unfixed    #15: CF=0x0d -> target=0x152a9c
```

所以这个差异不是 decoder、VM dispatch 或 `exeVMInner` 还原错误，而是环境输入不同。后续比算法必须先固定：

```text
-Dmetasec.fixedCurrentTimeMillis=1788159560000
-Dmetasec.fixedElapsedRealtime=123456789
-Dmetasec.fixedElapsedRealtimeNanos=123456789000000
-Dmetasec.fixedRandomSeed=0x350101
```

## raw 指令序列的第一处差异

固定时间的完整 offset 级别 diff 从 `0x149cbc` 同步后，第一次 mismatch 很早：

```text
matched_before = 45
true   pos=46    off=0x1c2edc  str x19, [sp, #-0x20]!
unidbg seq=24425 off=0x12001c
```

结合反汇编看：

- `0x120000` 附近会 `bl 0x1c2edc`；
- 真机 GumTrace 会进入 `0x1c2edc`；
- Unidbg instrseq 记录继续落在 `0x12001c`；
- `0x1c2edc` 是内部 `operator new` / `malloc` 包装；
- 后续 raw diff 也集中在 `0x11fc08`、`0x490a0`、`0x12dd04`、`0x12de7c` 这类对象构造、shared-ref、mutex/refcount helper。

因此 raw 指令级 diff 不能直接当算法跑偏点。它更多反映真机和 Unidbg 在运行时 helper、内存分配、锁路径上的记录粒度/路径差异。算法对齐要看更高层的稳定观测点：

- `managed_native_blr_15454c` 的 `(managed_hit, CF/x2, blr_target)`；
- managed frame slot 写入；
- pack/buffer 内容；
- 最终 `X-Gorgon / X-Argus / X-Ladon / X-Medusa / X-Helios / X-Soter`。

固定时间 raw diff 报告：

```text
dyidre/versions/350101/instr_diff_350101/true_vs_unidbg_fixedtime_149cbc_firstdiff.md
```

本轮 raw mismatch 涉及的主要 helper：

```text
0x1C2EDC  internal operator new / malloc wrapper
0x11FC08  object/vtable construction wrapper
0x12DD04  mutex/ref guarded shared-ref acquire path
0x12DE7C  matching shared-ref release/unlock path
0x490A0   shared/ref assignment-like wrapper
0x10B5F0  small string/object constructor path
0x10B764  object destructor/free wrapper
```

这些 helper 的进入/跳过不会改变 managed helper 的 `(CF, target)` 序列。它们更像“实现路径差异”，不是当前要修的 VM 算法差异。

200k 指令窗口聚合结果：

```text
matched_after_resync = 167881
diff_events = 857
true_side_skipped_instr = 47812
no_resync = 0

top true-side skipped groups:
  plt_pthread_mutex_lock        events=172
  shared_ref_release_unlock     events=168
  shared_ref_acquire_mutex      events=165
  operator_new_malloc_wrapper   events=56
  object_destructor/free        events=31
  small_string_ctor             events=18
```

`no_resync=0` 是关键：raw PC 虽然反复出现 helper 级跳过/插入，但都能回到同一主线；没有出现“某个 VM 分支永久跑飞”的证据。

## 值级差异提示

本轮固定时间 + instrseq 又暴露了一个独立问题：`managed_native_blr_15454c` 的 311 次分支完全一致，但最终 header 并非全部稳定。

```text
branch_fixedtime:
  X-Argus   sha1=2b8728915b5f len=8
  X-Gorgon  sha1=d1bc0d053614 len=52
  X-Helios  sha1=45b9af470fe1 len=48
  X-Khronos sha1=dacda8194efd len=10
  X-Ladon   sha1=b9f8683e7ce0 len=8
  X-Medusa  sha1=89d8dbf732f1 len=980
  X-Soter   sha1=c8cb4a7e8f18 len=120

instrseq_fixedtime_200k:
  X-Argus   sha1=2b8728915b5f len=8
  X-Gorgon  sha1=d1bc0d053614 len=52
  X-Helios  sha1=45b9af470fe1 len=48
  X-Khronos sha1=dacda8194efd len=10
  X-Ladon   sha1=b9f8683e7ce0 len=8
  X-Medusa  sha1=402edd391ead len=980
  X-Soter   sha1=c8cb4a7e8f18 len=120
```

所以当前“指令路径”已经对齐，但 `X-Medusa` 仍存在值级非确定性。后面要继续验证算法，重点不是再追 raw PC，而是追 F8/F13 的 slot/buffer 内容，找出 `X-Medusa` 哪段输入还来自未固定环境、未初始化内存或 trace instrumentation side effect。

## 当前 HTTP 签名路径确认

固定时间基准中，一次请求命中：

```text
http_entry_149ca8 = 1
nativeStage1_14a1ac = 1
nativeStage2_14a1fc = 1
managedF8_14a4e0 = 1
managed_native_blr_15454c = 311
exeVMInner_4cc10 = 4
managedF13_14a588 = 1
```

`exeVMInner_4cc10` 的 VM code 分布仍是：

```text
0x1ec670 = 2
0x1ecaf0 = 1
0x1f7860 = 1
```

这说明 `0x4CC10` 这层 native VMP 确实跑了，但它不是唯一 VM。350.101 的签名链至少有两层：

1. 外层 native VMP：入口 `0x4CC10`，跑几个 native stub/hash/key 片段；
2. managed VM：`0x1555A4 managedBytecodeRun_350`，通过 `0x15454C blr x8` 调 native CF helper。

## 稳定复验命令

固定时间、只看 managed helper 序列：

```bash
/usr/bin/java -cp "target/test-classes:../unidbg-api/target/classes:target/classes:$(cat target/test.cp)" \
  -Dmetasec.backend=unicorn2 \
  -Dmetasec.rootfs=/Users/freeman/project/douyin/unidbg/unidbg-android/target/rootfs_pixel6_350101_20260831_132930 \
  -Dmetasec.s1File=/Users/freeman/project/douyin/dyidre/versions/350101/multi_request_compare_350101/true_req_01_s1.txt \
  -Dmetasec.s2File=/Users/freeman/project/douyin/dyidre/versions/350101/multi_request_compare_350101/true_req_01_s2.txt \
  -Dmetasec.alignTrueDeviceHttpRuntime=true \
  -Dmetasec.fixedCurrentTimeMillis=1788159560000 \
  -Dmetasec.fixedElapsedRealtime=123456789 \
  -Dmetasec.fixedElapsedRealtimeNanos=123456789000000 \
  -Dmetasec.fixedRandomSeed=0x350101 \
  -Dmetasec.countOneRequest=true \
  -Dmetasec.probeHttpBranches=true \
  -Dmetasec.probeHttpBranches.maxSamples=450 \
  -Dmetasec.probeHttpBranches.verbose=false \
  com.ss.android.ugc.aweme.Sign6_350101 | tee target/sign6_350101_true_req01_branch_fixedtime_20260831.log
```

如果要继续做 raw instrseq，比对前也必须固定同一组时间/随机源，否则会把环境差异误判成指令差异：

```bash
  -Dmetasec.recordInstrSeq=true \
  -Dmetasec.recordInstrSeq.max=200000 \
  -Dmetasec.recordInstrSeq.file=target/sign6_350101_true_req01_instrseq_fixedtime_200k_20260831.seq
```

## 下一步

现在不应该继续追 “CF 分支为什么不同”，因为固定时间后已经没有 CF 分支差异。下一步要验证算法是否完全还原，应转成值级对比：

1. 在 `managedFrameSetSlot_350 @ 0x1547D4` 记录 F8/F13 的 slot 写入；
2. 对比 F5/F7/F8/F13 入口 pack；
3. 对比关键 helper 输出 buffer；
4. 最后对比几个 `X-*` header 的最终字节。

只有这些值也一致，才能说明“只输入 s1/s2 + 固定随机/时间/env”已经足够复现完整算法。
