// Douyin 350101 MetaSec probe — native-vmp.
// Pure Frida 17 standalone script.
// Load: frida -U -f com.ss.android.ugc.aweme -l native_vmp_350101.js

// ===== mode: native-vmp / native VMP 局部验证 =====
// 历史来源：native_vmp_1f7860_probe_350.js
// 什么时候用：只盯 vmCode=0x1f7860 这一段 native VMP，验证它是不是参与当前 X-header 材料生成。
function __dyidre_mode_native_vmp() {
// Minimal true-device probe for Douyin 35.0/35.1 libmetasec_ml.so native VMP.
//
// Purpose:
//   Verify whether real device execution of:
//     0x12564C -> 0x124DD4 -> 0x4CC10(exeVMInner, vmCode=0x1F7860)
//   produces the mssdk material object recovered in:
//     metasec_350101_01/vm_lift_1f7860/native_vmp_1f7860_recovered.c
//
// Run example:
//   probes/350101/run_metasec_probe_350101.sh native-vmp 90 vmp01

var TARGET_MODULE = "libmetasec_ml.so";

var OFF_EXEVMINNER = 0x4cc10;
var OFF_SELECT_MATERIAL = 0x12564c;
var OFF_BUILD_MATERIAL_WRAPPER = 0x124dd4;

var installed = false;
var hit124 = 0;
var hit4cc10 = 0;
var hit125 = 0;

function log(s) {
    console.log("[native-vmp-1f7860-probe] " + s);
}

function pstr(p) {
    try {
        return ptr(p).toString();
    } catch (e) {
        return String(p);
    }
}

function offOf(base, p) {
    try {
        var diff = ptr(p).sub(base).toString();
        if (diff.indexOf("0x") === 0 || diff.indexOf("-0x") === 0) return diff;
        return "0x" + diff;
    } catch (e) {
        return "?";
    }
}

function isNull(p) {
    try {
        var s = ptr(p).toString().toLowerCase();
        return s === "0x0" || s === "0";
    } catch (e) {
        return true;
    }
}

function ctxReg(invocation, name) {
    try {
        // rustFrida 的 Interceptor helper：userFn.call(ctx, args)，所以 x0-x30/lr/pc 在 this 上。
        if (invocation && invocation[name] !== undefined && invocation[name] !== null) return invocation[name];
    } catch (_) {
    }
    try {
        // 兼容官方 Frida：寄存器在 this.context 上。
        if (invocation && invocation.context && invocation.context[name] !== undefined && invocation.context[name] !== null) {
            return invocation.context[name];
        }
    } catch (_) {
    }
    if (name === "lr") {
        try {
            if (invocation && invocation.returnAddress !== undefined && invocation.returnAddress !== null) return invocation.returnAddress;
        } catch (_) {
        }
        return ctxReg(invocation, "x30");
    }
    return "?";
}

function ctxPtr(invocation, name) {
    try {
        var value = ctxReg(invocation, name);
        if (value === "?") return ptr(0);
        return ptr(value);
    } catch (_) {
        return ptr(0);
    }
}

function ctxRegPtrText(invocation, name) {
    try {
        var value = ctxReg(invocation, name);
        if (value === "?") return "?";
        return ptr(value).toString();
    } catch (_) {
        try {
            return String(ctxReg(invocation, name));
        } catch (_) {
            return "?";
        }
    }
}

function readPtr(p, off) {
    try {
        return ptr(p).add(off).readPointer();
    } catch (e) {
        return ptr(0);
    }
}

function readU32(p, off) {
    try {
        return ptr(p).add(off).readU32();
    } catch (e) {
        return 0xffffffff;
    }
}

function readU64(p, off) {
    try {
        return ptr(p).add(off).readU64();
    } catch (e) {
        return null;
    }
}

function readCstr(p, maxLen) {
    try {
        if (isNull(p)) {
            return "<null>";
        }
        return ptr(p).readCString(maxLen || 512);
    } catch (e) {
        return "<err:" + e + ">";
    }
}

function dumpRefObj(label, refp) {
    try {
        if (isNull(refp)) {
            log(label + " ref=<null>");
            return;
        }
        var obj = readPtr(refp, 0);
        var rc = readPtr(refp, 8);
        log(label + " ref=" + refp + " obj=" + obj + " refcnt_ptr=" + rc);
        dumpNativeVmpResult(label + ".obj", obj);
    } catch (e) {
        log(label + " dumpRefObj failed: " + e);
    }
}

function dumpNativeVmpResult(label, obj) {
    try {
        if (isNull(obj)) {
            log(label + "=<null>");
            return;
        }
        var vt = readPtr(obj, 0);
        var material = readPtr(obj, 8);
        log(label + " result=" + obj + " vt=" + vt + " material=" + material);
        dumpMaterial(label + ".material", material);
    } catch (e) {
        log(label + " dumpNativeVmpResult failed: " + e);
    }
}

function dumpMaterial(label, m) {
    try {
        if (isNull(m)) {
            log(label + "=<null>");
            return;
        }
        var seed = readU32(m, 0x18);
        var moduleName = readCstr(readPtr(m, 0x20), 128);
        var appId = readCstr(readPtr(m, 0x28), 128);
        var enabled = readU32(m, 0x30);
        var sdkVer = readCstr(readPtr(m, 0x38), 128);
        var salt = readU32(m, 0x40);
        var appInfoCount = readU64(m, 0x48);
        var appInfos = readPtr(m, 0x50);
        var kvCount = readU64(m, 0x58);
        var kvItems = readPtr(m, 0x60);

        log(label + " material=" + m +
            " seed=0x" + seed.toString(16) +
            " module=" + JSON.stringify(moduleName) +
            " app_id=" + JSON.stringify(appId) +
            " enabled=" + enabled +
            " sdk_version=" + JSON.stringify(sdkVer) +
            " salt=0x" + salt.toString(16) +
            " appInfoCount=" + appInfoCount +
            " appInfos=" + appInfos +
            " kvCount=" + kvCount +
            " kvItems=" + kvItems);

        if (!isNull(appInfos)) {
            var app0 = readPtr(appInfos, 0);
            var pkg = readCstr(readPtr(app0, 0x18), 256);
            var materialCount = readU64(app0, 0x20);
            var materialValues = readPtr(app0, 0x28);
            var mat0 = isNull(materialValues) ? "<null>" : readCstr(readPtr(materialValues, 0), 256);
            log(label + ".app[0]=" + app0 +
                " package=" + JSON.stringify(pkg) +
                " materialCount=" + materialCount +
                " material0=" + JSON.stringify(mat0));
        }

        if (!isNull(kvItems)) {
            var n = 0;
            try {
                n = Number(kvCount);
            } catch (e) {
                n = 0;
            }
            if (n > 8) {
                n = 8;
            }
            for (var i = 0; i < n; i++) {
                var item = readPtr(kvItems, i * 8);
                var key = readCstr(readPtr(item, 0x18), 256);
                var val = readCstr(readPtr(item, 0x20), 512);
                log(label + ".kv[" + i + "] item=" + item +
                    " key=" + JSON.stringify(key) +
                    " value=" + JSON.stringify(val));
            }
        }
    } catch (e) {
        log(label + " dumpMaterial failed: " + e);
    }
}

function dumpMemBlockish(label, p) {
    try {
        if (isNull(p)) {
            log(label + "=<null>");
            return;
        }
        var q = [];
        for (var i = 0; i < 4; i++) {
            q.push("+0x" + (i * 8).toString(16) + "=" + readPtr(p, i * 8));
        }
        log(label + " " + p + " " + q.join(" "));
    } catch (e) {
        log(label + " dumpMemBlockish failed: " + e);
    }
}

function installAtBase(base) {
    if (installed) {
        return;
    }
    installed = true;

    log("module base=" + base);

	    Interceptor.attach(base.add(OFF_EXEVMINNER), {
	        onEnter: function (args) {
	            try {
	                hit4cc10++;
	                var vmoff = offOf(base, args[0]);
	                if (vmoff === "0x1f7860" || hit4cc10 <= 8) {
	                    log("hit exeVMInner#" + hit4cc10 +
	                        " pc=" + ctxRegPtrText(this, "pc") +
	                        " lr=" + ctxRegPtrText(this, "lr") +
	                        " vmCode=" + args[0] + "(" + vmoff + ")" +
	                        " pParamList=" + args[1] +
	                        " vmData1=" + args[2] + "(" + offOf(base, args[2]) + ")" +
	                        " vmData2=" + args[3] + "(" + offOf(base, args[3]) + ")" +
	                        " vmParam=" + args[4]);
	                    if (vmoff === "0x1f7860") {
	                        dumpMemBlockish("exeVMInner.pParamList", args[1]);
	                        log("exeVMInner.vmParam funBridge=" + readPtr(args[4], 0) +
	                            "(" + offOf(base, readPtr(args[4], 0)) + ")" +
	                            " stack_end=" + readPtr(args[4], 8) +
	                            " saveLR=" + readPtr(args[4], 0x10) +
	                            "(" + offOf(base, readPtr(args[4], 0x10)) + ")");
	                    }
	                }
	            } catch (e) {
	                log("exeVMInner onEnter failed: " + e);
	            }
	        }
	    });

	    Interceptor.attach(base.add(OFF_SELECT_MATERIAL), {
	        onEnter: function (args) {
	            try {
	                hit125++;
	                this.dst = ctxPtr(this, "x8");
	                this.selector = args[1];
	                log("hit selectValueFromNativeVmpMaterial#" + hit125 +
	                    " x8/dst=" + this.dst +
	                    " x0/source=" + args[0] +
	                    " x1/selector=" + args[1] +
	                    " x2/extra=" + args[2] +
	                    " lr=" + ctxRegPtrText(this, "lr"));
	                dumpMemBlockish("select.source", args[0]);
	                dumpMemBlockish("select.selector", args[1]);
	            } catch (e) {
	                log("select onEnter failed: " + e);
	            }
	        },
	        onLeave: function (retval) {
	            log("leave selectValueFromNativeVmpMaterial ret=" + retval +
                " dst=" + this.dst);
            dumpMemBlockish("select.dst_after", this.dst);
        }
    });

	    Interceptor.attach(base.add(OFF_BUILD_MATERIAL_WRAPPER), {
	        onEnter: function (args) {
	            try {
	                hit124++;
	                this.outRef = ctxPtr(this, "x8");
	                log("hit nativeVmpBuildMssdkMaterial#" + hit124 +
	                    " x8/out_ref=" + this.outRef +
	                    " x0/block_a=" + args[0] +
	                    " x1/block_b=" + args[1] +
	                    " x2/extra=" + args[2] +
	                    " lr=" + ctxRegPtrText(this, "lr"));
	                dumpMemBlockish("build.block_a", args[0]);
	                dumpMemBlockish("build.block_b", args[1]);
	            } catch (e) {
	                log("build onEnter failed: " + e);
	            }
	        },
        onLeave: function (retval) {
            log("leave nativeVmpBuildMssdkMaterial ret=" + retval +
                " out_ref=" + this.outRef);
            dumpRefObj("build.out_after", this.outRef);
        }
    });

    log("installed hooks: exeVMInner=0x" + OFF_EXEVMINNER.toString(16) +
        " select=0x" + OFF_SELECT_MATERIAL.toString(16) +
        " build=0x" + OFF_BUILD_MATERIAL_WRAPPER.toString(16));
}

function waitForTargetModule() {
	    function findTargetBase() {
	        try {
	            var m = Process.findModuleByName(TARGET_MODULE);
	            return m === null ? null : m.base;
	        } catch (e) {
	            return null;
	        }
	    }

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

	    var base = findTargetBase();
	    if (base !== null) {
	        installAtBase(base);
	        return;
	    }

	    var hookedLoader = false;

	    function watchLoader(symbol) {
	        var dlopen = findGlobalExport(symbol);
	        if (dlopen === null) {
	            return;
	        }

	        try {
	            Interceptor.attach(dlopen, {
	                onEnter: function (args) {
	                    this.path = "";
	                    try {
	                        this.path = args[0].readCString();
	                    } catch (e) {
	                        this.path = "";
	                    }
	                },
	                onLeave: function () {
	                    if (installed || this.path.indexOf(TARGET_MODULE) < 0) {
	                        return;
	                    }
	                    var loadedBase = findTargetBase();
	                    log(symbol + " loaded: " + this.path + " base=" + loadedBase);
	                    if (loadedBase !== null) {
	                        installAtBase(loadedBase);
	                    }
	                }
	            });
	            hookedLoader = true;
	            log("watch " + symbol + " @" + dlopen);
	        } catch (e) {
	            log("watch " + symbol + " failed: " + e);
	        }
	    }

	    watchLoader("android_dlopen_ext");
	    watchLoader("dlopen");

	    if (hookedLoader) {
	        log("waiting for " + TARGET_MODULE);
	    } else {
	        log("cannot find dlopen/android_dlopen_ext");
	    }
	}

waitForTargetModule();

}

(function () {
    console.log("[metasec-native-vmp] standalone loaded (Frida 17)");
    __dyidre_mode_native_vmp();
})();
