// Douyin 350.101 native VMP ISA collector (rustFrida-compatible).
//
// This is a read-only, standalone probe for libmetasec_ml.so+0x4CC10.
// It records the relationship:
//
//   VM word fetch -> low6 opcode / op11 selector -> native handler target
//
// and, when explicitly enabled, snapshots a small set of control/unknown
// handler points.  It does not patch code, alter arguments, bypass checks, or
// implement a host-call result.
//
// rustFrida config example (set before this script is evaluated):
//
// globalThis.METASEC_NATIVE_VMP_ISA_CONFIG = {
//   // null means record every exeVMInner invocation, which is noisy.
//   vmCodeOffset: "0x1f7860",
//   maxRuns: 1,
//   maxDispatchEventsPerRun: 12000,
//   // Emit a bounded sample of exeVMInner calls rejected by vmCodeOffset.
//   // This distinguishes "VMP was never reached" from "wrong stream filter".
//   diagnoseEntryFilter: true,
//   maxFilteredEntryEvents: 32,
//   emitFetchEvents: false,
//   enableControlSnapshots: true,
//   // These interior hooks are opt-in.  Enable only for one selected opcode.
//   watchHandlerOffsets: ["0x565e0"]
// };
//
// JSONL lines are prefixed with [vmp-isa-350101].  Keep raw output and JSONL
// separate on the host; do not infer an opcode's semantics solely from one
// event.  Pair a watched handler sample with its static handler disassembly.

(function () {
    "use strict";

    var TARGET_MODULE = "libmetasec_ml.so";
    var OFF_EXEVMINNER = 0x4cc10;

    // Build 350.101.  vmFetch reads W8 from [X5]; dispatcherBranch is BR X8.
    // The two control handlers are used only for extra state snapshots.
    var OFF = {
        vmFetch: 0x4cd94,
        dispatcherBranch: 0x4cdf4,
        callReg: 0x4f830,
        jmpReg: 0x4f860
    };

    var cfg = globalThis.METASEC_NATIVE_VMP_ISA_CONFIG || {};
    var moduleBase = null;
    var moduleSize = 0;
    var nextRunId = 1;
    var begunRuns = 0;
    var activeByTid = Object.create(null);
    var listeners = [];
    var loaderListeners = [];

    function parseOptionalOffset(value) {
        if (value === undefined || value === null || String(value).trim() === "") return null;
        var n = typeof value === "number" ? value : parseInt(String(value), 0);
        if (!isFinite(n) || n < 0 || n > 0xffffffff) throw new Error("bad offset: " + value);
        return n >>> 0;
    }

    function positiveInt(value, fallback) {
        var n = value === undefined || value === null ? fallback : parseInt(String(value), 10);
        return isFinite(n) && n > 0 ? n : fallback;
    }

    var TARGET_VM_CODE = parseOptionalOffset(cfg.vmCodeOffset === undefined ? "0x1f7860" : cfg.vmCodeOffset);
    var MAX_RUNS = positiveInt(cfg.maxRuns, 1);
    var MAX_DISPATCH = positiveInt(cfg.maxDispatchEventsPerRun, 12000);
    var DIAGNOSE_ENTRY_FILTER = cfg.diagnoseEntryFilter !== false;
    var MAX_FILTERED_ENTRY_EVENTS = positiveInt(cfg.maxFilteredEntryEvents, 32);
    var EMIT_FETCH = cfg.emitFetchEvents === true;
    var CONTROL_SNAPSHOTS = cfg.enableControlSnapshots !== false;
    var filteredEntryEvents = 0;

    function log(message) {
        console.log("[gum-native-vmp-isa-350101] " + message);
    }

    function tid() {
        try { return Process.getCurrentThreadId(); } catch (_) { return 0; }
    }

    function emit(kind, run, fields) {
        var out = {
            event: kind,
            run: run ? run.id : null,
            tid: run ? run.tid : tid(),
            seq: run ? run.seq : null
        };
        for (var key in fields) {
            if (Object.prototype.hasOwnProperty.call(fields, key)) out[key] = fields[key];
        }
        console.log("[vmp-isa-350101] " + JSON.stringify(out));
    }

    // rustFrida exposes registers directly on `this`; stock Frida uses
    // `this.context`.  Supporting both keeps recorded JSON comparable.
    function ctxOf(invocation) {
        try {
            if (invocation && invocation.context) return invocation.context;
        } catch (_) {}
        return invocation;
    }

    function ctxPtr(ctx, name) {
        try {
            if (ctx && ctx[name] !== undefined && ctx[name] !== null) return ptr(ctx[name]);
        } catch (_) {}
        return null;
    }

    function ptrText(value) {
        try { return value === null || value === undefined ? null : ptr(value).toString(); }
        catch (_) { return null; }
    }

    function samePtr(a, b) {
        // rustFrida's NativePointer intentionally has no Frida `.equals()`;
        // its canonical hexadecimal string is the portable comparison form.
        try { return a !== null && b !== null && ptr(a).toString() === ptr(b).toString(); }
        catch (_) { return false; }
    }

    function readPtr(address) {
        try { return ptr(address).readPointer(); }
        catch (_) { return null; }
    }

    function readU32(address) {
        try { return ptr(address).readU32() >>> 0; }
        catch (_) { return null; }
    }

    function moduleOffsetNumber(value) {
        if (moduleBase === null || value === null || value === undefined) return null;
        try {
            // rustFrida exposes `toNumber()` (BigInt on 64-bit), not Frida's
            // `toUInt32()`.  Reject negative/overflowed differences before
            // converting to a JS Number.
            var n = ptr(value).sub(moduleBase).toNumber();
            if (typeof n === "bigint") {
                if (n < 0n || n > 0xffffffffn) return null;
                n = Number(n);
            }
            return n < moduleSize ? n : null;
        } catch (_) {
            return null;
        }
    }

    function moduleOffset(value) {
        var n = moduleOffsetNumber(value);
        return n === null ? null : "0x" + n.toString(16);
    }

    function stackFor(threadId, create) {
        var key = String(threadId);
        var stack = activeByTid[key];
        if (!stack && create) {
            stack = [];
            activeByTid[key] = stack;
        }
        return stack || null;
    }

    function currentRun() {
        var stack = stackFor(tid(), false);
        return stack && stack.length ? stack[stack.length - 1] : null;
    }

    function pushRun(run) {
        stackFor(run.tid, true).push(run);
    }

    function popRun(run) {
        var stack = stackFor(run.tid, false);
        if (!stack) return;
        for (var i = stack.length - 1; i >= 0; --i) {
            if (stack[i] === run) {
                stack.splice(i, 1);
                break;
            }
        }
        if (!stack.length) delete activeByTid[String(run.tid)];
    }

    function wordFields(word) {
        if (word === null) return { word: null, op: null, selector: null };
        return {
            word: "0x" + word.toString(16),
            op: "0x" + (word & 0x3f).toString(16),
            selector: (word & 0x3f) === 0x11 ? "0x" + ((word >>> 6) & 0x3f).toString(16) : null
        };
    }

    function vregBank(ctx) {
        // Verified at the current 350.101 dispatch/control points.  If an
        // offset moves in a new build, the null/error result is evidence to
        // re-check the handler -- not a reason to reuse an old vm64 layout.
        return ctxPtr(ctx, "x27");
    }

    function readVregs(ctx) {
        var bank = vregBank(ctx);
        if (bank === null) return null;
        var regs = [];
        for (var i = 0; i < 32; ++i) regs.push(ptrText(readPtr(bank.add(i * 8))));
        return regs;
    }

    function controlSlots(word) {
        if (word === null || (word & 0x3f) !== 0x11) return null;
        var selector = (word >>> 6) & 0x3f;
        if (selector === 0x32) {
            return { kind: "CALL_REG", link_slot: (word >>> 12) & 0x1f, target_slot: (word >>> 27) & 0x1f };
        }
        if (selector === 0x1e) {
            return { kind: "JMP_REG", link_slot: null, target_slot: (word >>> 22) & 0x1f };
        }
        return null;
    }

    function classifyControlTarget(run, target) {
        if (target === null) return "NO_TARGET";
        if (samePtr(target, run.funBridge)) return "FUN_BRIDGE_CANDIDATE";
        if (samePtr(target, run.saveLr)) return "SAVE_LR_CANDIDATE";
        if (samePtr(target, run.vmCode)) return "VM_ENTRY";
        if (moduleOffset(target) !== null) return "MODULE_TEXT_OR_DATA";
        return "EXTERNAL_OR_VM_CODE";
    }

    function eventForControl(run, ctx, kind) {
        var word = run.pendingWord;
        var slots = controlSlots(word);
        var regs = readVregs(ctx);
        var target = null;
        var link = null;
        if (slots && regs !== null) {
            target = regs[slots.target_slot];
            link = slots.link_slot === null ? null : regs[slots.link_slot];
        }
        var targetPtr = target === null ? null : ptr(target);
        var fields = wordFields(word);
        fields.kind = kind;
        fields.vm_pc = run.pendingVmPc;
        fields.target_slot = slots ? slots.target_slot : null;
        fields.link_slot = slots ? slots.link_slot : null;
        fields.target = target;
        fields.target_off = moduleOffset(targetPtr);
        fields.link_value = link;
        fields.target_class = classifyControlTarget(run, targetPtr);
        fields.reg_bank = ptrText(vregBank(ctx));
        fields.regs = regs;
        emit("VMP_CONTROL", run, fields);
    }

    function installPoint(offset, callback) {
        listeners.push(Interceptor.attach(moduleBase.add(offset), {
            onEnter: function () {
                var run = currentRun();
                if (!run || run.disabled) return;
                try {
                    callback(run, ctxOf(this));
                } catch (e) {
                    emit("VMP_PROBE_ERROR", run, { offset: "0x" + offset.toString(16), error: String(e) });
                }
            }
        }));
    }

    function installDispatcherHooks() {
        installPoint(OFF.vmFetch, function (run, ctx) {
            var pc = ctxPtr(ctx, "x5");
            var word = pc === null ? null : readU32(pc);
            run.pendingVmPc = ptrText(pc);
            run.pendingWord = word;
            if (EMIT_FETCH) {
                var fields = wordFields(word);
                fields.vm_pc = run.pendingVmPc;
                fields.reg_bank = ptrText(vregBank(ctx));
                emit("VMP_FETCH", run, fields);
            }
        });

        installPoint(OFF.dispatcherBranch, function (run, ctx) {
            if (run.dispatchCount >= MAX_DISPATCH) {
                if (!run.limitReported) {
                    run.limitReported = true;
                    emit("VMP_DISPATCH_LIMIT", run, { max_dispatch_events: MAX_DISPATCH });
                }
                return;
            }
            run.dispatchCount += 1;
            run.seq += 1;
            var fields = wordFields(run.pendingWord);
            var handler = ctxPtr(ctx, "x8");
            fields.vm_pc = run.pendingVmPc;
            fields.handler = ptrText(handler);
            fields.handler_off = moduleOffset(handler);
            fields.reg_bank = ptrText(vregBank(ctx));
            emit("VMP_DISPATCH", run, fields);
        });

        if (CONTROL_SNAPSHOTS) {
            installPoint(OFF.callReg, function (run, ctx) { eventForControl(run, ctx, "CALL_REG"); });
            installPoint(OFF.jmpReg, function (run, ctx) { eventForControl(run, ctx, "JMP_REG"); });
        }
    }

    function configuredHandlerOffsets() {
        var values = cfg.watchHandlerOffsets;
        if (!Array.isArray(values)) return [];
        var seen = Object.create(null);
        var out = [];
        for (var i = 0; i < values.length; ++i) {
            var value = parseOptionalOffset(values[i]);
            if (value === null) continue;
            var key = "0x" + value.toString(16);
            if (!seen[key]) {
                seen[key] = true;
                out.push(value);
            }
        }
        return out;
    }

    function installWatchedHandlers() {
        var offsets = configuredHandlerOffsets();
        for (var i = 0; i < offsets.length; ++i) {
            (function (offset) {
                installPoint(offset, function (run, ctx) {
                    var fields = wordFields(run.pendingWord);
                    fields.handler_off = "0x" + offset.toString(16);
                    fields.vm_pc = run.pendingVmPc;
                    fields.reg_bank = ptrText(vregBank(ctx));
                    fields.regs = readVregs(ctx);
                    emit("VMP_WATCHED_HANDLER_ENTER", run, fields);
                });
            })(offsets[i]);
        }
    }

    function installAt(module) {
        if (moduleBase !== null) return;
        moduleBase = module.base;
        moduleSize = module.size;
        installDispatcherHooks();
        installWatchedHandlers();

        listeners.push(Interceptor.attach(moduleBase.add(OFF_EXEVMINNER), {
            onEnter: function (args) {
                var vmCode = args[0];
                var vmCodeOff = moduleOffsetNumber(vmCode);
                if ((TARGET_VM_CODE !== null && vmCodeOff !== TARGET_VM_CODE) || begunRuns >= MAX_RUNS) {
                    if (DIAGNOSE_ENTRY_FILTER && filteredEntryEvents < MAX_FILTERED_ENTRY_EVENTS) {
                        filteredEntryEvents += 1;
                        emit("VMP_ENTRY_FILTERED", null, {
                            reason: TARGET_VM_CODE !== null && vmCodeOff !== TARGET_VM_CODE ? "VM_CODE_FILTER" : "MAX_RUNS",
                            vm_code: ptrText(vmCode),
                            vm_code_off: vmCodeOff === null ? null : "0x" + vmCodeOff.toString(16),
                            expected_vm_code_off: TARGET_VM_CODE === null ? null : "0x" + TARGET_VM_CODE.toString(16),
                            caller_lr: ptrText(ctxPtr(ctxOf(this), "lr") || ctxPtr(ctxOf(this), "x30")),
                            caller_lr_off: moduleOffset(ctxPtr(ctxOf(this), "lr") || ctxPtr(ctxOf(this), "x30"))
                        });
                    }
                    this.run = null;
                    return;
                }

                var vmParam = args[4];
                var run = {
                    id: nextRunId++,
                    tid: tid(),
                    seq: 0,
                    dispatchCount: 0,
                    limitReported: false,
                    disabled: false,
                    vmCode: ptr(vmCode),
                    funBridge: readPtr(vmParam),
                    stackEnd: readPtr(ptr(vmParam).add(8)),
                    saveLr: readPtr(ptr(vmParam).add(16)),
                    pendingVmPc: null,
                    pendingWord: null
                };
                begunRuns += 1;
                this.run = run;
                pushRun(run);
                emit("VMP_ENTER", run, {
                    module: TARGET_MODULE,
                    module_base: ptrText(moduleBase),
                    vm_code: ptrText(vmCode),
                    vm_code_off: vmCodeOff === null ? null : "0x" + vmCodeOff.toString(16),
                    p_param_list: ptrText(args[1]),
                    vm_data1: ptrText(args[2]),
                    vm_data1_off: moduleOffset(args[2]),
                    vm_data2: ptrText(args[3]),
                    vm_data2_off: moduleOffset(args[3]),
                    vm_param: ptrText(vmParam),
                    fun_bridge: ptrText(run.funBridge),
                    fun_bridge_off: moduleOffset(run.funBridge),
                    stack_end: ptrText(run.stackEnd),
                    save_lr: ptrText(run.saveLr),
                    save_lr_off: moduleOffset(run.saveLr),
                    caller_lr: ptrText(ctxPtr(ctxOf(this), "lr") || ctxPtr(ctxOf(this), "x30")),
                    caller_lr_off: moduleOffset(ctxPtr(ctxOf(this), "lr") || ctxPtr(ctxOf(this), "x30"))
                });
            },
            onLeave: function (retval) {
                var run = this.run;
                if (!run) return;
                emit("VMP_LEAVE", run, {
                    retval: ptrText(retval),
                    dispatch_events: run.dispatchCount
                });
                popRun(run);
            }
        }));

        log("installed base=" + moduleBase + " size=0x" + moduleSize.toString(16) +
            " vmCodeFilter=" + (TARGET_VM_CODE === null ? "<all>" : "0x" + TARGET_VM_CODE.toString(16)) +
            " maxRuns=" + MAX_RUNS + " maxDispatch=" + MAX_DISPATCH +
            " diagnoseEntryFilter=" + DIAGNOSE_ENTRY_FILTER +
            " watchedHandlers=" + configuredHandlerOffsets().map(function (x) { return "0x" + x.toString(16); }).join(","));
    }

    function findModule() {
        try { return Process.findModuleByName(TARGET_MODULE); }
        catch (_) { return null; }
    }

    function tryInstallFromLoader() {
        if (moduleBase !== null) return true;
        var found = findModule();
        if (found === null) return false;
        installAt(found);
        log("target module became available through linker callback");
        return true;
    }

    function installLoaderWakeups() {
        // No timer API is injected by rustFrida.  In spawn mode the reliable
        // notification boundary is the return from bionic's loader: by then
        // the new mapping has appeared in /proc/self/maps and constructors
        // have completed.  The script does not inspect or modify loader args.
        var symbols = [
            "android_dlopen_ext",
            "dlopen",
            "__loader_android_dlopen_ext",
            "__dl___loader_android_dlopen_ext",
            "__loader_dlopen",
            "__dl___loader_dlopen",
            "__dl__Z8__dlopenPKciPKv"
        ];
        var seen = Object.create(null);
        var installed = [];

        for (var i = 0; i < symbols.length; ++i) {
            var address = null;
            try { address = Module.findExportByName(null, symbols[i]); }
            catch (_) { address = null; }
            if (address === null) continue;

            var key = ptrText(address);
            if (key === null || seen[key]) continue;
            seen[key] = true;
            try {
                loaderListeners.push(Interceptor.attach(address, {
                    onLeave: function () { tryInstallFromLoader(); }
                }));
                installed.push(symbols[i] + "@" + key);
            } catch (e) {
                log("could not attach loader wakeup " + symbols[i] + ": " + String(e));
            }
        }

        if (installed.length === 0) {
            log("no usable bionic loader export found; inject after " + TARGET_MODULE + " is loaded");
        } else {
            log("armed linker wakeups: " + installed.join(", "));
        }

        // Close the small race between the first module lookup and attaching
        // the loader callbacks.
        tryInstallFromLoader();
    }

    function installWhenLoaded() {
        if (!tryInstallFromLoader()) installLoaderWakeups();
    }

    log("loaded (read-only); use METASEC_NATIVE_VMP_ISA_CONFIG to change the VM-code filter");
    installWhenLoaded();
})();
