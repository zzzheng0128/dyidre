globalThis.METASEC_PACKET_CONFIG = {
  "taskName": "stockfrida_noop_20260901_235845",
  "filterAll": false,
  "captureBodies": true,
  "captureResponseBody": false,
  "copyResponseHeaders": true,
  "hookNativeJN": false,
  "hookJN": false,
  "skipBodyOnMainThread": true,
  "hookNative": false,
  "emitOnFirstBody": false,
  "emitOnXmWithBody": false,
  "emitOnDisconnect": true,
  "emitOnOutputCloseAfterBody": true,
  "emitOnReadAfterBody": true,
  "emitOnGetInputStreamAfterBody": true,
  "emitOnBodyIdle": false,
  "useJavaIdleTimer": false,
  "emitEmptyPostDisconnect": false,
  "emitBodylessPostDisconnect": false,
  "skipWeakerDuplicateUrl": false,
  "bodyIdleFlushMs": 1800,
  "maxPending": 512,
  "maxBodyBytes": 0,
  "logCreateEvery": 25,
  "logJNEvery": 50,
  "logConnectionEvery": 50,
  "logWriteEvery": 50,
  "logReadEvery": 0,
  "logNativeEvery": 20,
  "logDisconnectEvery": 20,
  "maxDiagLogs": 300,
  "logBodyEvery": 10,
  "nativeStringDumpLimit": 0,
  "printPackets": false
};
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
