// Minimal rustFrida wxshadow bootstrap.
// Keep Java.setStealth in a dead branch so rustFrida can pre-scan and configure
// stealth before app resume; real hook scripts are loaded later with %reload.
if (false) Java.setStealth(Hook.WXSHADOW);
console.log("[wxshadow-bootstrap350] declared Java.setStealth(Hook.WXSHADOW); waiting for host %reload");
