(function () {
  var tag = "[rf-minimal-sanity]";
  function log(s) {
    try { console.log(tag + " " + String(s)); } catch (_) {}
  }
  log("loaded pid=" + Process.id + " tid=" + Process.getCurrentThreadId());
  Java.ready(function () {
    log("Java.ready ok");
  });
  log("script end ok");
})();
