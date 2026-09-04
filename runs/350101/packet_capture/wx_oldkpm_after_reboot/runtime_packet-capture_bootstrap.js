// dyidre packet lazy bootstrap.
// rustFrida 会预扫描 Java.setStealth(...)；放在 dead branch 里只用于提前配置 stealth。
if (false) Java.setStealth(Hook.WXSHADOW);
console.log('[packet350-bootstrap] declared java stealth=wxshadow; capture runtime waits for host loadjs after resume');
