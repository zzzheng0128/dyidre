// Douyin 350101 MetaSec probe — branch.
// Pure Frida 17 standalone script.
// Load: frida -U -f com.ss.android.ugc.aweme -l branch_350101.js

// ===== mode: branch / CF 分支值探针 =====
// 历史来源：metasec_branch_probe_350.js
// 什么时候用：raw PC 可以重新同步，但 header 值还不一致时，追 CF/x2/blr_target 等值级分叉。
function __dyidre_mode_branch() {
// Focused one-request branch probe for Douyin 350.101 libmetasec_ml.so.
//
// Purpose:
//   Compare true-device and unidbg around buildSignedHttpHeadersInner_350:
//   - why F5/F7 are skipped or executed;
//   - whether the pre-stage native VMP wrapper at 0x12AC9C runs;
//   - what exeVMInner programs are called inside the same HTTP window.

(function () {
    var TARGET_MODULE = "libmetasec_ml.so";

    try {
        if (globalThis.__metasecBranchProbe350State) {
            globalThis.__metasecBranchProbe350State.active = false;
        }
    } catch (_) {}

    function emptyState(tag) {
        return {
            tag: tag || "",
            active: false,
            done: false,
            started_ms: 0,
            stopped_ms: 0,
            module: null,
            outer_only: true,
            inside_outer: false,
            inside_http_only: true,
            inside_http: false,
            stop_after_first_request: true,
            counts: {},
            exe_vmcode: {},
            exe_lr: {},
            samples: []
        };
    }

    var state = emptyState("");
    globalThis.__metasecBranchProbe350State = state;

    var OFFSETS = {
        http_callback_14dbf4: 0x14dbf4,
        http_entry_149ca8: 0x149ca8,

        // 0x149180 helper returns a MEM_BLOCK-like object through X8=sp+0x68.
        // buildSignedHttpHeadersInner checks this result before stage1/stage2.
        branch_pre_stage_result_ptr_14a16c: 0x14a16c,
        branch_pre_stage_ptr_gate_14a170: 0x14a170,
        branch_pre_stage_len_gate_14a178: 0x14a178,

        // 0x149F5C helper result is stored to [sp+0x10], then bit0 decides
        // whether F5/F7 Argus/Ladon generation block runs.
        branch_helper_ret_149f60: 0x149f60,
        branch_f5f7_gate_14a250: 0x14a250,
        // bit0=1 goes through 0x14A254..0x14A334, then jumps to 0x14A438,
        // so this path skips F5/F7.
        branch_precompute_then_skip_f5f7_14a254: 0x14a254,
        // bit0=0 jumps here and falls through F5/F7.
        branch_run_f5f7_14a348: 0x14a348,

        // Fixed native wrapper around exeVMInner(vmCode=0x201800).
        vmwrap_201800_call_12acf4: 0x12acf4,
        vmwrap_201800_ret_12acf8: 0x12acf8,

        nativeStage1_14a1ac: 0x14a1ac,
        nativeStage2_14a1fc: 0x14a1fc,
        managedF5_14a38c: 0x14a38c,
        managedF7_14a3ec: 0x14a3ec,
        branch_after_f5f7_join_14a438: 0x14a438,
        managedF8_14a4e0: 0x14a4e0,
        managedF13_14a588: 0x14a588,
        exeVMInner_4cc10: 0x4cc10
    };

    // RF inline hook 对基本块内部、相邻几条指令连续 patch 不够稳。
    // 默认 branch 只启用 counter-one 已验证稳定的阶段点；如果必须追
    // 0x14A250 这类单条分支指令，用 stackplz/eDBG 硬件断点，或手动
    // 在 runtime JS 里设置 METASEC_PROBE_CONFIG.branchDeep=true。
    var DEEP_BRANCH_POINTS = {
        branch_pre_stage_result_ptr_14a16c: true,
        branch_pre_stage_ptr_gate_14a170: true,
        branch_pre_stage_len_gate_14a178: true,
        branch_helper_ret_149f60: true,
        branch_f5f7_gate_14a250: true,
        branch_precompute_then_skip_f5f7_14a254: true,
        branch_run_f5f7_14a348: true,
        branch_after_f5f7_join_14a438: true,
        vmwrap_201800_call_12acf4: true,
        vmwrap_201800_ret_12acf8: true
    };

    function isDeepBranchEnabled() {
        try {
            return !!(globalThis.METASEC_PROBE_CONFIG && globalThis.METASEC_PROBE_CONFIG.branchDeep);
        } catch (_) {
            return false;
        }
    }

    function log(s) {
        try {
            console.log("[metabranch] " + String(s));
        } catch (_) {}
    }

    function inc(map, key) {
        key = String(key);
        map[key] = (map[key] || 0) + 1;
    }

    function hex(v) {
        try {
            return ptr(v).toString();
        } catch (e) {
            return String(v);
        }
    }

    function toNum(v) {
        try {
            return parseInt(ptr(v).toString(), 16);
        } catch (_) {
            return 0;
        }
    }

    function isNullPtr(v) {
        try {
            var s = ptr(v).toString().toLowerCase();
            return s === "0x0" || s === "0";
        } catch (_) {
            return true;
        }
    }

    function rel(base, p) {
        var n = toNum(p);
        var b = toNum(base);
        if (n >= b && n < b + 0x8000000) {
            return "0x" + (n - b).toString(16);
        }
        return hex(p);
    }

    function readU32Safe(p) {
        try {
            var q = ptr(p);
            if (isNullPtr(q)) return null;
            return q.readU32() >>> 0;
        } catch (_) {
            return null;
        }
    }

    function readPtrSafe(p) {
        try {
            var q = ptr(p);
            if (isNullPtr(q)) return null;
            return q.readPointer();
        } catch (_) {
            return null;
        }
    }

    function addSample(sample) {
        if (state.samples.length < 128) {
            state.samples.push(sample);
        }
    }

    function reset(tag, stopAfterFirstRequest, insideHttpOnly, outerOnly) {
        var m = Process.findModuleByName(TARGET_MODULE);
        state.tag = tag || "";
        state.active = true;
        state.done = false;
        state.started_ms = Date.now();
        state.stopped_ms = 0;
        state.module = m ? { name: m.name, base: m.base.toString(), size: m.size, path: m.path } : null;
        state.outer_only = outerOnly === undefined ? true : !!outerOnly;
        state.inside_outer = false;
        state.inside_http_only = insideHttpOnly === undefined ? true : !!insideHttpOnly;
        state.inside_http = false;
        state.stop_after_first_request = stopAfterFirstRequest === undefined ? true : !!stopAfterFirstRequest;
        state.counts = {};
        state.exe_vmcode = {};
        state.exe_lr = {};
        state.samples = [];
        // pre-resume 阶段 libmetasec_ml.so 可能还没加载；runner 通过 RPC reset
        // 时模块通常已经出现，这里补一次安装，避免 branch mode 空跑 0 hit。
        if (m !== null) {
            installAtModule(m);
        }
        log("reset " + JSON.stringify({
            tag: state.tag,
            module: state.module,
            outer_only: state.outer_only,
            inside_http_only: state.inside_http_only,
            stop_after_first_request: state.stop_after_first_request
        }));
        return summary();
    }

    function stop() {
        state.active = false;
        state.stopped_ms = Date.now();
        return summary();
    }

    function summary() {
        var out = JSON.parse(JSON.stringify(state));
        out.elapsed_ms = (state.stopped_ms || Date.now()) - state.started_ms;
        return out;
    }

    function shouldRecord(label) {
        if (!state.active || state.done) return false;
        if (state.outer_only && label !== "http_callback_14dbf4" && !state.inside_outer) return false;
        if (state.inside_http_only && label !== "http_entry_149ca8" && !state.inside_http) return false;
        return true;
    }

    function record(label, base, ctx, args) {
        if (label === "http_callback_14dbf4" && state.active && state.outer_only && !state.inside_outer) {
            state.inside_outer = true;
        }
        if (label === "http_entry_149ca8" && state.active && state.inside_http_only && !state.inside_http) {
            state.inside_http = true;
        }
        if (!shouldRecord(label)) return;

        inc(state.counts, label);

        var sp = null;
        try {
            sp = ctx.sp;
        } catch (_) {
            sp = ptr(0);
        }

        var sample = {
            label: label,
            hit: state.counts[label],
            pc: rel(base, ctx.pc),
            lr: rel(base, ctx.lr),
            x0: hex(ctx.x0),
            x1: hex(ctx.x1),
            x2: hex(ctx.x2),
            x3: hex(ctx.x3),
            x4: hex(ctx.x4),
            x8: hex(ctx.x8),
            sp: hex(sp)
        };

        try {
            if (label === "exeVMInner_4cc10") {
                var vmCode = rel(base, args[0]);
                var lrOff = rel(base, ctx.lr);
                inc(state.exe_vmcode, vmCode);
                inc(state.exe_lr, lrOff);
                sample.vmCode = vmCode;
                sample.pParamList = hex(args[1]);
                sample.vmData1 = rel(base, args[2]);
                sample.vmData2 = rel(base, args[3]);
                sample.vmParam = hex(args[4]);
            }

            if (label === "branch_pre_stage_result_ptr_14a16c"
                    || label === "branch_pre_stage_ptr_gate_14a170"
                    || label === "branch_pre_stage_len_gate_14a178") {
                var prePtr = readPtrSafe(ptr(sp).add(0x68));
                sample.sp68_ptr = prePtr === null ? "<read-failed>" : hex(prePtr);
                if (prePtr !== null && !isNullPtr(prePtr)) {
                    sample.sp68_len_c = readU32Safe(prePtr.add(0x0c));
                    sample.sp68_body = hex(readPtrSafe(prePtr.add(0x10)) || ptr(0));
                }
            }

            if (label === "branch_helper_ret_149f60") {
                sample.w0_ret = toNum(ctx.x0) & 0xffffffff;
                sample.sp10_u32_before_store = readU32Safe(ptr(sp).add(0x10));
            }

            if (label === "branch_f5f7_gate_14a250") {
                sample.w8_gate = toNum(ctx.x8) & 0xffffffff;
                sample.sp10_u32 = readU32Safe(ptr(sp).add(0x10));
                sample.bit0 = sample.w8_gate & 1;
                sample.decision = sample.bit0
                    ? "precompute 0x14A254..0x14A334, then skip F5/F7 -> 0x14A438"
                    : "jump to 0x14A348 and run F5/F7";
            }

            if (label === "vmwrap_201800_call_12acf4" || label === "vmwrap_201800_ret_12acf8") {
                sample.wrapper_x0_vmcode = rel(base, ctx.x0);
                sample.wrapper_x1_paramlist = hex(ctx.x1);
                sample.wrapper_x2_vmdata1 = rel(base, ctx.x2);
                sample.wrapper_x3_vmdata2 = rel(base, ctx.x3);
                sample.wrapper_x4_vmparam = hex(ctx.x4);
            }
        } catch (e) {
            sample.error = String(e);
        }

        addSample(sample);
    }

    function maybeAutoStop(label) {
        if (!state.active || state.done) return;
        if (state.stop_after_first_request
                && label === "managedF13_14a588"
                && (state.counts.http_entry_149ca8 || 0) >= 1) {
            state.active = false;
            state.stopped_ms = Date.now();
            state.done = true;
            log("auto-stopped " + JSON.stringify(state.counts));
        }
    }

    function installAtModule(m) {
        if (globalThis.__metasecBranchProbe350Installed) {
            return "already-installed";
        }
        var moduleBase = null;
        var modulePath = TARGET_MODULE;
        try {
            moduleBase = ptr(m.base);
        } catch (e0) {
            var currentModule = Process.findModuleByName(TARGET_MODULE);
            moduleBase = currentModule === null ? null : currentModule.base;
        }
        if (moduleBase === null || moduleBase === undefined || moduleBase.toString() === "0x0") {
            return "module-base-not-found";
        }
        try {
            if (m.path !== undefined && m.path !== null) modulePath = String(m.path);
        } catch (_) {
            modulePath = TARGET_MODULE;
        }

        var branchDeep = isDeepBranchEnabled();
        var moduleBaseText = "0x0";
        try {
            moduleBaseText = moduleBase.toString();
        } catch (_) {
            moduleBaseText = TARGET_MODULE;
        }
        log("install module base=" + moduleBaseText + " path=" + modulePath);
        if (!branchDeep) {
            log("safe mode: skip dense basic-block probes; use stackplz/eDBG or branchDeep=true for exact branch instruction points");
        }
        globalThis.__metasecBranchProbe350Installed = true;
        Object.keys(OFFSETS).forEach(function (label) {
            if (!branchDeep && DEEP_BRANCH_POINTS[label]) {
                return;
            }
            var target = moduleBase.add(OFFSETS[label]);
            try {
                var callbacks = {
                    onEnter: function (args) {
                        record(label, moduleBase, this, args);
                        if (label === "managedF13_14a588") {
                            maybeAutoStop(label);
                        }
                    },
                };
                if (label === "http_callback_14dbf4") {
                    callbacks.onLeave = function () {
                        if (label === "http_callback_14dbf4") {
                            state.inside_outer = false;
                        }
                        maybeAutoStop(label);
                    };
                } else if (label === "http_entry_149ca8") {
                    callbacks.onLeave = function () {
                        if (!state.outer_only) {
                            state.inside_http = false;
                        }
                        maybeAutoStop(label);
                    };
                }
                Interceptor.attach(target, callbacks);
                log("hook " + label + " @" + target);
            } catch (e) {
                log("hook failed " + label + " @" + target + ": " + e);
            }
        });
        return "ok";
    }

    function install() {
        var m = Process.findModuleByName(TARGET_MODULE);
        if (m) return installAtModule(m);

        // pre-resume 加载脚本时，目标 so 往往还没 dlopen。
        // branch 原版只返回 module-not-found，导致后续 reset 虽然成功但没有任何 hook。
        // 这里补 dlopen 监听，和 counter-one/counter-multi 保持同一启动语义。
        if (globalThis.__metasecBranchProbe350Waiting) {
            return "waiting";
        }
        globalThis.__metasecBranchProbe350Waiting = true;

        function findGlobalExport(name) {
            try {
                if (typeof Module.findExportByName === "function") {
                    return Module.findExportByName(null, name);
                }
            } catch (_) {
            }
            try {
                if (typeof Module.findGlobalExportByName === "function") {
                    return Module.findGlobalExportByName(name);
                }
            } catch (_) {
            }
            return null;
        }

        function watchLoader(symbol) {
            var dlopen = findGlobalExport(symbol);
            if (!dlopen) return false;

            try {
                Interceptor.attach(dlopen, {
                    onEnter: function (args) {
                        this.path = "";
                        try {
                            this.path = args[0].readCString();
                        } catch (_) {
                            this.path = "";
                        }
                    },
                    onLeave: function () {
                        if (this.path.indexOf(TARGET_MODULE) < 0) return;
                        var retry = function () {
                            install();
                        };
                        if (typeof setImmediate === "function") setImmediate(retry);
                        else retry();
                    }
                });
                log("watch " + symbol + " @" + dlopen);
                return true;
            } catch (e) {
                log("watch " + symbol + " failed: " + e);
                return false;
            }
        }

        var hooked = false;
        hooked = watchLoader("android_dlopen_ext") || hooked;
        hooked = watchLoader("dlopen") || hooked;
        if (!hooked) {
            globalThis.__metasecBranchProbe350Waiting = false;
            return "no-dlopen";
        }
        return "waiting";
    }

    var old = rpc.exports || {};
    old.metabranchinstall = install;
    old.metabranchreset = reset;
    old.metabranchstop = stop;
    old.metabranchsummary = summary;
    rpc.exports = old;

    return install();
})();

}

(function () {
    console.log("[metasec-branch] standalone loaded (Frida 17)");
    __dyidre_mode_branch();
})();
