// check_sscronet_patch.js —— 临时诊断
// attach 到任意进程，检查 libsscronet.so 三处 fix 字节是否已生效。
// 用法：frida -U -p <pid> -l check_sscronet_patch.js
(function () {
    var m = Process.findModuleByName("libsscronet.so");
    if (m === null) {
        console.log("RESULT: libsscronet.so NOT loaded in this process");
        return;
    }
    console.log("module path: " + m.path);
    console.log("module base: " + m.base);
    var offs = [0x3cedf0, 0x3cf17c, 0x3cf1b4];
    var allPatched = true;
    offs.forEach(function (o) {
        try {
            var u = new Uint8Array(m.base.add(o).readByteArray(4));
            var hex = Array.prototype.map.call(u, function (x) {
                return ("0" + x.toString(16)).slice(-2);
            }).join(" ");
            var st = hex === "00 00 80 52" ? "PATCHED" : "clean";
            if (st !== "PATCHED") allPatched = false;
            console.log("  +0x" + o.toString(16) + "  bytes=" + hex + "  -> " + st);
        } catch (e) {
            allPatched = false;
            console.log("  +0x" + o.toString(16) + "  read error: " + e);
        }
    });
    console.log(allPatched ? "RESULT: ALL 3 PATCHED (fix.so)" : "RESULT: NOT PATCHED (clean so)");
})();
