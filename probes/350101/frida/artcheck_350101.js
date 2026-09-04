// Douyin 350101 MetaSec probe — artcheck.
// Pure Frida 17 standalone script.
// Load: frida -U -f com.ss.android.ugc.aweme -l artcheck_350101.js

// ===== mode: artcheck / 检测面检查 =====
// 历史来源：artmethod_maps_check.js
// 什么时候用：确认 Frida/ArtMethod/maps 是否留下异常痕迹；用于判断“注入崩/被识别”是不是检测面问题。
function __dyidre_mode_artcheck() {
function dumpArt(tag) {
  var art = Process.findModuleByName("libart.so");
  console.log("[artcheck][" + tag + "] pid=" + Process.id +
      " arch=" + Process.arch +
      " libart=" + (art === null ? "not-loaded" : art.base));
}

Java.perform(function () {
  console.log("[artcheck] Java ready");

  dumpArt("before-hook");

  try {
    var JN = Java.use("J.N");
    var MnXVOzVo = JN.MnXVOzVo.overload(
      "java.lang.Object",
      "long",
      "java.lang.String",
      "int",
      "int",
      "boolean",
      "boolean",
      "boolean",
      "int",
      "boolean",
      "int",
      "int",
      "long"
    );

    MnXVOzVo.implementation = function (
      a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12
    ) {
      console.log("[artcheck][hit] url=" + url);
      return MnXVOzVo.call(this, a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12);
    };

    console.log("[artcheck] hook installed: J.N.MnXVOzVo");
  } catch (e) {
    console.log("[artcheck] hook install failed: " + e);
  }

  dumpArt("after-hook");
});

}

(function () {
    console.log("[metasec-artcheck] standalone loaded (Frida 17)");
    __dyidre_mode_artcheck();
})();
