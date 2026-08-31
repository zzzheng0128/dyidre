# eDBG assisted dynamic analysis plan for 350.101 `libmetasec_ml.so`

Date: 2026-08-31

Scope:

- target package: `com.ss.android.ugc.aweme`
- target library: `libmetasec_ml.so`
- IDA/virtual offsets are used throughout this note.

## What eDBG gives us

`/Users/freeman/project/douyin/eDBG` is an eBPF-based Android ARM64 debugger.
For this project it is useful as a low-noise dynamic oracle:

- breakpoint by library + IDA offset, without manually calculating ASLR base;
- register snapshot at a breakpoint: `x0..x30`, `sp`, `pc`, `pstate`;
- process memory read/dump while stopped;
- unwind/fp backtrace while stopped;
- thread listing and thread filters;
- MCP/CLI hardware breakpoint/watchpoint support after local patch.

This is complementary to GumTrace:

- GumTrace is good for full instruction sequence and VM-dispatch archaeology.
- eDBG is better for small, surgical checks: "who called this", "what did this
  pointer contain", "which function wrote this field", "does true-device stack
  match the recovered call graph".

## MCP hardware/watchpoint + stack patch

Local eDBG has been patched so `--mcp` mode now only forces:

```text
-show-vertual
```

It no longer forces `-prefer uprobe`, and MCP now exposes:

```text
status
attach
break / hbreak / watch / rwatch
enable_breakpoint / disable_breakpoint / delete_breakpoint / info_break
info_file
run / continue / wait_stop / cancel_run
info_register
info_thread
examine
list
backtrace
thread
set_symbol
write_memory
dump
quit
```

Breakpoint hit results from `run` / `continue` / `wait_stop` now include a
`stop.stack` object:

```json
{
  "stop": {
    "pc": "0x...",
    "library": "libmetasec_ml.so",
    "virtual_offset": "0x149ca8",
    "stack": {
      "available": true,
      "unwind": {
        "mode": "unwind",
        "lines": [
          "#00 ...",
          "#01 ..."
        ]
      }
    }
  }
}
```

If StackPlz is not present or unwind cannot read the process, eDBG returns a
`warning` and falls back to the FP backtrace instead of crashing.

So use it like this:

- MCP mode: automatic uprobe breakpoints, hardware breakpoints/watchpoints,
  register/memory/backtrace collection.
- CLI mode: still better for interactive step/next/until/finish.

Important: `hbreak` / `watch` / `rwatch` need a live target process, because
hardware perf breakpoints require a runtime absolute address. For spawn-time
entry catches, use MCP `break` + `run`; after the app is alive, use
`hbreak/watch/rwatch` + `continue`.

MCP timeout behavior was also patched after a real "app stuck" observation:

- default: `run` / `continue` / `wait_stop` timeout stops probes and sends
  `SIGCONT` best-effort, so the app is not silently left paused;
- opt-in long wait: pass `keep_running_on_timeout=true` only when a human/agent
  will keep ownership and later call `wait_stop` or `cancel_run`;
- timeout responses include `auto_recovered`, `probe_running`, and `recovery`
  fields, so a later script can tell whether eDBG is still armed.

## Device suitability

The local P6 currently reports:

```text
Linux 6.1.99-android14-11-gd6f926cfde54-ab12786694 aarch64
```

This satisfies eDBG's documented `5.10+` kernel requirement.

Patched binary was built locally as `eDBG/bin/eDBG_arm64` and pushed to:

```text
/data/local/tmp/eDBG
/data/local/tmp/preload_libs/libstackplz.so
```

Pixel 5 on 4.19/4.14 should be treated as unsupported for this eDBG version.

## MCP setup sketch

On device:

```sh
su
chmod +x /data/local/tmp/eDBG
/data/local/tmp/eDBG --mcp
```

On host:

```sh
adb forward tcp:19810 tcp:19810
```

MCP logical flow:

```text
status
attach(package="com.ss.android.ugc.aweme", library="libmetasec_ml.so")
break(address="0x149ca8")
break(address="0x14a38c")
break(address="0x14a3ec")
break(address="0x14a4e0")
break(address="0x124dd4")
break(address="0x4cc10")
run()

on each stop:
  info_register()
  backtrace(mode="unwind")
  examine("x0", "0x80")
  examine("x1", "0x80")
  examine("x2", "0x80")
  examine("x8", "0x80")
  continue()
```

`break` in MCP interprets offsets as virtual offsets, equivalent to eDBG
`vbreak`, which matches the IDA view we are using.

## CLI hardware/watchpoint workflow

Use MCP or CLI when the question is "who writes this exact field".

MCP example after the app is already running:

```text
attach(package="com.ss.android.ugc.aweme", library="libmetasec_ml.so")
hbreak(address="0x149ca8")
continue(timeout_ms=60000)
```

For a field watch, first stop at an entry, inspect `x0/x1/x8`, calculate the
target field address, then:

```text
watch(address="0x<absolute-field-address>")
continue(timeout_ms=60000)
```

The returned `stop.stack.unwind.lines` is the main evidence for "who called /
who wrote this".

Example shape:

```sh
/data/local/tmp/eDBG \
  -p com.ss.android.ugc.aweme \
  -l libmetasec_ml.so \
  -b 0x149ca8 \
  -prefer hardware \
  -show-vertual
```

After a breakpoint hits:

```text
info reg
bt
x X0 0x100
x X1 0x100
x X8 0x80

watch 0x<absolute-field-address>
rwatch 0x<absolute-field-address>
continue
```

Hardware slots are limited. The source enforces roughly four hardware slots,
and reserves some temporary slots for single-step/next, so watch only one or two
high-value fields at a time.

## 2026-08-31 validation notes

The patched MCP behavior was validated on Pixel 6 (`Linux 6.1.99 aarch64`):

- `tools/list` now contains `hbreak`, `watch`, and `rwatch`.
- `attach` to `com.ss.android.ugc.aweme` + `libmetasec_ml.so` resolves the live
  library path and size.
- `hbreak 0x149ca8` resolves to `libmetasec_ml.so` base + `0x149ca8` correctly.
  This required fixing `GetAbsoluteAddressNew`; before the fix it returned only
  the segment base.
- A quick `libc.so!clock_gettime` hardware-breakpoint test successfully returned
  an unwind stack through MCP, proving the stack path works.
- `hbreak 0x149ca8` with a short timeout returned `auto_recovered=true`,
  `probe_running=false`, and the target process remained alive. This confirms
  the MCP safety timeout no longer leaves the app stuck when no one continues
  the session.

## Where eDBG helps our MetaSec analysis

### 1. Verify public HTTP entry and ABI

Breakpoints:

```text
0x14DBF4 buildSignedHttpHeadersCallback_350
0x149CA8 buildSignedHttpHeadersInner_350
```

At `0x14DBF4`, verify wrapper `s1/s2`:

```text
x0 = s1/url-like string
x1 = s2/header-like string
```

At `0x149CA8`, verify internal ABI:

```text
x0 = MetaSecCtx350*
x1 = json_list window
x2 = url window / REF_MEM_BLOCK
x3 = x_ss_stub window
w4 = type
x5 = tree_map window
x8 = output/scratch ref
```

Useful commands:

```text
info reg
bt
x x0 0x400
x x1 0x80
x x2 0x80
x x3 0x80
x x5 0x80
x x8 0x80
```

This replaces a lot of noisy JNITtrace when the only question is "is this the
same request object layout".

### 2. Confirm native VMP participation

Breakpoints:

```text
0x4CC10  exeVMInner_350
0xD9574  native small VMP wrapper, vmCode=0x1EC670
0xD95F4  native small VMP wrapper, vmCode=0x1ECAF0
0x124DD4 nativeVmpBuildMssdkMaterial_350, vmCode=0x1F7860
0x12564C selectValueFromNativeVmpMaterial_350
```

At `0x4CC10`, check:

```text
x0 = vmCode
x1 = pParamList
x2 = vmData1
x3 = vmData2
x4 = VmParam64*
```

Known true-device values from the GumTrace baseline:

```text
0xD9574  -> vmCode 0x1EC670, vmData 0x262980 / 0x2629C0
0xD95F4  -> vmCode 0x1ECAF0, vmData 0x262A00 / 0x262A20
0x124DD4 -> vmCode 0x1F7860, vmData 0x26F2E0 / 0x26F300
```

At `0x124DD4` entry:

```text
x8 = out_ref
x0 = block_a
x1 = block_b
x2 = extra_ref
```

At return from `0x124DD4`, inspect the saved `out_ref` manually in CLI mode, or
break later at `0x12564C` and inspect the returned result consumed by the caller.

Expected result shape:

```c
out_ref+0x00 -> NativeVmpResultObject350*
out_ref+0x08 -> ref_count_ptr

NativeVmpResultObject350+0x00 -> template/vtable
NativeVmpResultObject350+0x08 -> MetaSecMssdkMaterial350*
```

The material object should contain:

```text
+0x18 seed_id       = 0x20200924
+0x20 module_name   = "mssdk"
+0x28 app_id        = "1588093228"
+0x30 enabled       = 1
+0x38 sdk_version   = "1128"
+0x40 salt_id       = 0x5fa25885
+0x48 app_info_count = 1
+0x58 kv_count       = 2
+0x60 kv_items       -> two KeyValue objects

kv[0] key/value = "common_key" / "y9b0xCYrB++Slss+AeCCmqg/7xiNzqCCzZ2pYLjGgVY="
kv[1] key/value = "sign_key"   / "jr36OAbsxc7nlCPmAp7YJUC8Ihi7fq73HLaR96qKovU="
```

This verifies whether our partial `exeVMInner` lift is the same computation seen
on real device.

### 3. Verify X-header stage boundaries

Breakpoints:

```text
0x14A1AC signStage1_makeStubPieces_350 call
0x14A1FC signStage2_makeKeyPieces_350 call
0x14A38C managedSignBuildA_350      -> F5  -> X-Argus
0x14A3EC managedSignBuildB_350      -> F7  -> X-Ladon
0x14A4E0 managedSignBuildFinal_350  -> F8  -> X-Medusa
0x14A588 managedSignPostEmitF13_350 -> F13 -> X-Helios
```

For each hit:

```text
info reg
bt
x x0 0x100
x x8 0x80
```

This confirms whether a given true-device request follows the same stage order
as unidbg.

### 4. Verify final header insertion

Breakpoints:

```text
0x14D29C treeMapPut_X22_X27_X28_350 tail-call
0x14D30C treeMapPut_X22_X23_X24_350 tail-call
0x14A53C direct treeMapPut_350 -> X-Medusa
0x14A65C direct treeMapPut_350 -> X-Soter
0x14A730 success return through X8/out
```

At wrapper tail-calls:

```text
0x14D29C:
  x22 = map
  x27 = key MEM_BLOCK
  x28 = value MEM_BLOCK

0x14D30C:
  x22 = map
  x23 = key MEM_BLOCK
  x24 = value MEM_BLOCK
```

At direct callsites:

```text
x0 = tree map
x1 = key MEM_BLOCK
x2 = value MEM_BLOCK
```

Expected caller-origin mapping:

```text
0x14A1C0 -> X-Gorgon
0x14A210 -> X-Khronos
0x14A3A0 -> X-Argus
0x14A400 -> X-Ladon
0x14A53C -> X-Medusa
0x14A5A8 -> X-Helios
0x14A65C -> X-Soter
```

Use eDBG backtrace here to distinguish wrapper `0x14D29C/0x14D30C` from the real
business caller.

### 5. Recover/confirm structure fields with watchpoints

Good watchpoint targets after a known allocation/object pointer is discovered:

```text
MetaSecMssdkMaterial350+0x58  kv_count
MetaSecMssdkMaterial350+0x60  kv_items
MetaSecMssdkKeyValue350+0x18  key
MetaSecMssdkKeyValue350+0x20  value
MetaSecManagedCallArg350+0x10 x_ss_stub
MetaSecManagedCallArg350+0x18 url_or_path
MetaSecManagedCallArg350+0x28 token/env block
TREE_MAP node/value storage for X-Argus/X-Medusa insertion
```

This is where CLI hardware `watch/rwatch` matters. The flow is:

1. break at the allocator/helper or stage entry;
2. read the object pointer;
3. set `watch` on the suspected field;
4. continue until it stops;
5. capture `bt`, `info reg`, and nearby memory;
6. promote field name/type only if the writer/reader evidence matches.

## Suggested first live experiment

Goal: verify the incomplete native VMP lift without full GumTrace.

Use MCP or CLI:

```text
break 0x124dd4
break 0x4cc10
break 0x12564c
run
```

At the `0x4cc10` stop that has `x0 == base+0x1f7860`, record:

```text
info reg
bt
x x1 0x40
x x4 0x20
```

Then continue to `0x12564c` / later return-site and inspect the material object.
If `common_key/sign_key` match the GumTrace baseline, the recovered
`native_vmp_1f7860_recovered.c` is validated as the true-device computation for
that part, even though the generic `exeVMInner` interpreter is not complete.
