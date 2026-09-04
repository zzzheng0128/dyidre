// Douyin 350101 MetaSec probe — counter-one.
// Pure Frida 17 standalone script.
// Load: frida -U -f com.ss.android.ugc.aweme -l counter_one_350101.js

// ===== mode: counter-one / 单请求计数 =====
// 历史来源：metasec_one_request_counter_350.js
// 什么时候用：只触发一条 HTTP 请求，统计 HTTP/F8/F13/exeVMInner 命中次数，对齐真机 vs unidbg 路径。
function __dyidre_mode_counter_one() {
// Lightweight one-request MetaSec counter for rustFrida RPC.
//
// Install through the unified RF RPC session:
//   curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobeinstall \
//     -H 'Content-Type: application/json' -d '["counter-one"]'
//
// Then:
//   curl -s -X POST http://127.0.0.1:19191/rpc/0/metacountreset -H 'Content-Type: application/json' -d '["one"]'
//   # trigger exactly one HTTP request in Douyin
//   curl -s -X POST http://127.0.0.1:19191/rpc/0/metacountsummary -H 'Content-Type: application/json' -d '[]'

(function () {
    try {
        if (globalThis.__metasecOneRequestCounterState) {
            globalThis.__metasecOneRequestCounterState.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV2) {
            globalThis.__metasecOneRequestCounterStateV2.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV3) {
            globalThis.__metasecOneRequestCounterStateV3.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV4) {
            globalThis.__metasecOneRequestCounterStateV4.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV5) {
            globalThis.__metasecOneRequestCounterStateV5.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV6) {
            globalThis.__metasecOneRequestCounterStateV6.active = false;
        }
    } catch (_) {
    }

    var TARGET_MODULE = "libmetasec_ml.so";

    var OFFSETS = {
        http_callback_14dbf4: 0x14dbf4,
        http_entry_149ca8: 0x149ca8,
        exeVMInner_4cc10: 0x4cc10,
        nativeVmpBuildMaterial_124dd4: 0x124dd4,
        nativeVmpSelectMaterial_12564c: 0x12564c,
        nativeStage1_14a1ac: 0x14a1ac,
        nativeStage2_14a1fc: 0x14a1fc,
        managedF5_14a38c: 0x14a38c,
        managedF7_14a3ec: 0x14a3ec,
        managedF8_14a4e0: 0x14a4e0,
        managedF13_14a588: 0x14a588
    };

    function log(s) {
        console.log("[metacount] " + s);
    }

    function now() {
        return Date.now();
    }

    function hex(n) {
        try {
            if (typeof n === "number") return "0x" + n.toString(16);
            return ptr(n).toString();
        } catch (e) {
            return String(n);
        }
    }

    function rel(base, p) {
        try {
            var q = ptr(p);
            var qn = parseInt(q.toString(), 16);
            var bn = parseInt(ptr(base).toString(), 16);
            if (isFinite(qn) && isFinite(bn) && qn >= bn && qn < bn + 0x8000000) {
                return "0x" + (qn - bn).toString(16);
            }
            return q.toString();
        } catch (e) {
            return "?";
        }
    }

    function inc(map, key) {
        key = String(key);
        map[key] = (map[key] || 0) + 1;
    }

    function emptyState(tag) {
        return {
            tag: tag || "",
            active: false,
            started_ms: 0,
            stopped_ms: 0,
            module: null,
            counts: {},
            exe_vmcode: {},
            exe_lr: {},
            stop_after_first_request: true,
            inside_http_only: true,
            inside_http: false,
            inside_outer: false,
            outer_only: true,
            done: false,
            input: null,
            samples: []
        };
    }

    var state = globalThis.__metasecOneRequestCounterStateV7 || emptyState("");
    globalThis.__metasecOneRequestCounterStateV7 = state;

    function reset(tag, stopAfterFirstRequest, insideHttpOnly, outerOnly) {
        var m = Process.findModuleByName(TARGET_MODULE);
        state.tag = tag || "";
        state.active = true;
        state.started_ms = now();
        state.stopped_ms = 0;
        state.module = m ? { name: m.name, base: m.base.toString(), size: m.size, path: m.path } : null;
        state.counts = {};
        state.exe_vmcode = {};
        state.exe_lr = {};
        state.stop_after_first_request = stopAfterFirstRequest === undefined ? true : !!stopAfterFirstRequest;
        state.inside_http_only = insideHttpOnly === undefined ? true : !!insideHttpOnly;
        state.inside_http = false;
        state.outer_only = outerOnly === undefined ? true : !!outerOnly;
        state.inside_outer = false;
        state.done = false;
        state.input = null;
        state.samples = [];
        log("reset tag=" + state.tag + " stop_after_first_request=" + state.stop_after_first_request +
            " inside_http_only=" + state.inside_http_only +
            " outer_only=" + state.outer_only +
            " module=" + JSON.stringify(state.module));
        return state;
    }

    function stop() {
        state.active = false;
        state.stopped_ms = now();
        return summary();
    }

    function summary() {
        var out = JSON.parse(JSON.stringify(state));
        out.elapsed_ms = (state.stopped_ms || now()) - state.started_ms;
        return out;
    }

    function record(label, base, ctx, args) {
        if (!state.active) return;
        if (state.done) return;
        if (state.outer_only && label !== "http_callback_14dbf4" && !state.inside_outer) return;
        if (state.outer_only && label === "http_callback_14dbf4" && !state.inside_outer) {
            state.inside_outer = true;
            captureInput(args);
        }
        if (state.inside_http_only && label !== "http_entry_149ca8" && !state.inside_http) return;
        if (state.inside_http_only && label === "http_entry_149ca8" && !state.inside_http) {
            state.inside_http = true;
        }
        inc(state.counts, label);

        var sample = null;
        try {
            if (label === "exeVMInner_4cc10") {
                var vmCode = args[0];
                var vmOff = rel(base, vmCode);
                var lrOff = rel(base, ctx.lr);
                inc(state.exe_vmcode, vmOff);
                inc(state.exe_lr, lrOff);
                if (state.samples.length < 48) {
                    sample = {
                        label: label,
                        hit: state.counts[label],
                        pc: rel(base, ctx.pc),
                        lr: lrOff,
                        vmCode: vmOff,
                        pParamList: hex(args[1]),
                        vmData1: rel(base, args[2]),
                        vmData2: rel(base, args[3]),
                        vmParam: hex(args[4])
                    };
                }
            } else if (state.samples.length < 48) {
                sample = {
                    label: label,
                    hit: state.counts[label],
                    pc: rel(base, ctx.pc),
                    lr: rel(base, ctx.lr),
                    x0: hex(ctx.x0),
                    x1: hex(ctx.x1),
                    x2: hex(ctx.x2),
                    x3: hex(ctx.x3),
                    x8: hex(ctx.x8)
                };
            }
        } catch (e) {
            inc(state.counts, label + ".sample_error");
            if (state.samples.length < 48) {
                sample = { label: label, error: String(e) };
            }
        }

        if (sample !== null) {
            state.samples.push(sample);
        }

        if (state.stop_after_first_request
                && label === "managedF13_14a588"
                && (state.counts.http_entry_149ca8 || 0) >= 1) {
            state.active = false;
            state.stopped_ms = now();
            state.done = true;
            log("auto-stopped after first request: " + JSON.stringify(state.counts));
        }
    }

    function leaveHttp() {
        if (!state.active || state.done || !state.inside_http_only || !state.inside_http || state.outer_only) {
            return;
        }
        state.active = false;
        state.stopped_ms = now();
        state.inside_http = false;
        state.done = true;
        log("auto-stopped at http_entry onLeave: " + JSON.stringify(state.counts));
    }

    function readCStringSafe(p, maxLen) {
        try {
            var q = ptr(p);
            if (q.toString() === "0x0") return null;
            return Memory.readCString(q);
        } catch (e) {
            return "<readCString-error:" + e + ">";
        }
    }

    function fnv1a32(s) {
        if (s === null || s === undefined) return "0x00000000";
        var h = 0x811c9dc5;
        for (var i = 0; i < s.length; i++) {
            h ^= s.charCodeAt(i) & 0xff;
            h = Math.imul(h, 0x01000193) >>> 0;
        }
        return "0x" + ("00000000" + h.toString(16)).slice(-8);
    }

    function captureInput(args) {
        var s1 = readCStringSafe(args[0], 32768);
        var s2 = readCStringSafe(args[1], 32768);
        state.input = {
            s1_len: s1 === null ? -1 : s1.length,
            s1_fnv1a: fnv1a32(s1),
            s1: s1,
            s2_len: s2 === null ? -1 : s2.length,
            s2_fnv1a: fnv1a32(s2),
            s2: s2
        };
    }

    function leaveOuter() {
        if (!state.active || state.done || !state.outer_only || !state.inside_outer) {
            return;
        }
        state.active = false;
        state.stopped_ms = now();
        state.inside_outer = false;
        state.done = true;
        log("auto-stopped at http_callback onLeave: " + JSON.stringify(state.counts));
    }

    function installAtModule(m) {
        if (globalThis.__metasecOneRequestCounterInstalledV7) {
            return "already-installed";
        }
        globalThis.__metasecOneRequestCounterInstalledV7 = true;
        log("install module base=" + m.base + " path=" + m.path);

        Object.keys(OFFSETS).forEach(function (label) {
            var off = OFFSETS[label];
            var target = m.base.add(off);
            try {
                var callbacks = {
                    onEnter: function (args) {
                        record(label, m.base, this, args);
                    }
                };
                if (label === "http_entry_149ca8") {
                    callbacks.onLeave = function () {
                        leaveHttp();
                    };
                } else if (label === "http_callback_14dbf4") {
                    callbacks.onLeave = function () {
                        leaveOuter();
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
        if (m) {
            return installAtModule(m);
        }

        if (globalThis.__metasecOneRequestCounterWaitingV7) {
            return "waiting";
        }
        globalThis.__metasecOneRequestCounterWaitingV7 = true;

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
            globalThis.__metasecOneRequestCounterWaitingV7 = false;
            return "no-dlopen";
        }
        return "waiting";
    }

    var old = rpc.exports || {};
    old.metacountinstall = install;
    old.metacountreset = reset;
    old.metacountstop = stop;
    old.metacountsummary = summary;
    rpc.exports = old;

    return install();
})();

}

(function () {
    console.log("[metasec-counter-one] standalone loaded (Frida 17)");
    __dyidre_mode_counter_one();
})();
