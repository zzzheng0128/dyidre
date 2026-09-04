// No-op Frida smoke script for Douyin 35.1.0.
// Used to separate stock Frida/runtime presence crashes from packet hook bugs.
(function () {
  try {
    console.log("[rfpkt350-noop] loaded pid=" + Process.id);
    if (typeof Java !== "undefined" && Java && typeof Java.perform === "function") {
      Java.perform(function () {
        console.log("[rfpkt350-noop] java ready");
      });
    }
  } catch (e) {
    console.log("[rfpkt350-noop] error " + e);
  }
})();
