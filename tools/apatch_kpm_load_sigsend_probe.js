'use strict';

// Attach to me.bmax.apatch and ask APatch's JNI wrapper to load only the
// lightweight SIGSEGV sender observer KPM.  This intentionally does not touch
// wxshadow.kpm, hide-so.kpm, or sigsegv-probe.kpm.

const KPM_PATH = '/data/local/tmp/sigsend-probe.kpm';
const KPM_NAME = 'sigsend-probe';

function log(msg) {
  console.log('[apatch-kpm-load-sigsend] ' + msg);
}

function main() {
  try {
    const APApplication = Java.use('me.bmax.apatch.APApplication');
    const Natives = Java.use('me.bmax.apatch.Natives');

    function staticField(classWrapper, fieldName) {
      const field = classWrapper.class.getDeclaredField.overload('java.lang.String').call(classWrapper.class, fieldName);
      field.setAccessible.overload('boolean').call(field, true);
      return field.get.overload('java.lang.Object').call(field, null);
    }

    let nativeObj = null;
    try {
      nativeObj = staticField(Natives, 'a');
    } catch (e) {
      log('static Natives.a failed: ' + e);
    }
    const nativeApi = nativeObj && Java.cast ? Java.cast(nativeObj, Natives) : nativeObj;

    let keyObj = null;
    try {
      keyObj = staticField(APApplication, 'l');
    } catch (e) {
      log('static APApplication.l failed: ' + e);
      try {
        keyObj = APApplication.l.value;
      } catch (ee) {
        log('direct APApplication.l.value failed: ' + ee);
      }
    }
    const key = keyObj ? String(keyObj) : '';

    log('superkey_loaded=' + (key.length > 0) + ' key_len=' + key.length);
    log('native_ready=' + nativeApi.nativeReady.overload('java.lang.String').call(nativeApi, key));

    try {
      log('before_num=' + nativeApi.h.call(nativeApi));
      log('before_list=' + JSON.stringify(String(nativeApi.g.call(nativeApi))));
    } catch (e) {
      log('before list failed: ' + e);
    }

    try {
      const rc = nativeApi.r.overload('java.lang.String').call(nativeApi, KPM_NAME);
      log('unload name=' + KPM_NAME + ' rc=' + rc);
    } catch (e) {
      log('unload name=' + KPM_NAME + ' failed: ' + e);
    }

    try {
      const rc = nativeApi.j.overload('java.lang.String', 'java.lang.String').call(nativeApi, KPM_PATH, '');
      log('load path=' + KPM_PATH + ' rc=' + rc);
    } catch (e) {
      log('load path=' + KPM_PATH + ' failed: ' + e);
    }

    try {
      log('after_num=' + nativeApi.h.call(nativeApi));
      log('after_list=' + JSON.stringify(String(nativeApi.g.call(nativeApi))));
    } catch (e) {
      log('after list failed: ' + e);
    }
  } catch (e) {
    log('fatal: ' + e + '\n' + e.stack);
  }
  log('done');
}

if (typeof Java !== 'undefined' && Java) {
  if (Java.performNow) Java.performNow(main);
  else if (Java.perform) Java.perform(main);
  else main();
} else {
  log('fatal: Java API unavailable');
}
