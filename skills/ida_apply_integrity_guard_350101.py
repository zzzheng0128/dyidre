"""Apply evidence-backed integrity/anti-analysis names and types for 350.101.

Run inside IDA with the matching 350.101 libmetasec_ml.so database open.
All addresses are RVAs.  The script checks four code anchors before changing
the IDB, preserves unrelated analyst names/comments, and never patches the SO.
"""

from __future__ import annotations

import ida_auto
import ida_bytes
import ida_funcs
import ida_kernwin
import ida_name
import ida_nalt
import ida_typeinf


TAG = "[integrity-guard-350101]"
TAG_END = "[integrity-guard-350101:end]"

# Exact entry bytes from SHA-256
# 2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76.
ANCHORS = {
    0x59294: bytes.fromhex("ff8302d1fc6f04a9fa6705a9f85f06a9"),
    0xD7D84: bytes.fromhex("ff4301d1f51300f9f44f03a9fd7b04a9"),
    0xD875C: bytes.fromhex("e20300aae00301aa40001fd6"),
    0xD86D0: bytes.fromhex("fd7bbfa9fd0300915ab8fd97000040f9"),
}

TYPE_DECLS = r"""
typedef enum METASEC_MACHINE_ID_350 {
  METASEC_MACHINE_ARM_350 = 1,
  METASEC_MACHINE_AARCH64_350 = 2,
  METASEC_MACHINE_X86_350 = 3,
  METASEC_MACHINE_X86_64_350 = 4,
  METASEC_MACHINE_UNKNOWN_350 = 255
} METASEC_MACHINE_ID_350;

typedef enum METASEC_INTEGRITY_BITS_350 {
  METASEC_INTEGRITY_CHECK_EXECUTED_350 = 1
} METASEC_INTEGRITY_BITS_350;

typedef struct METASEC_JNI_GLOBAL_REF_SLOT_350 {
  void *vtable;
  unsigned char state;
  unsigned char reserved_09[7];
  jobject global_ref;
  FUN_MUTEX *mutex;
} METASEC_JNI_GLOBAL_REF_SLOT_350;

typedef struct METASEC_INTEGRITY_GUARD_350 {
  void *vtable;
  int expected_machine_id;
  int observed_machine_id;
  void *image_base;
  void *image_end;
  unsigned __int64 expected_image_xor;
  unsigned __int64 image_check_length;
  int signal_loop_failed;
  int unknown_34;
  void *linker_callback_state;
  unsigned __int64 first_check_time;
  int link_verify_code;
  int link_verify_aux;
  unsigned int integrity_risk_bits;
  unsigned int unknown_54;
  FUN_MUTEX *signal_loop_mutex;
  FUN_MUTEX *integrity_mutex;
  unsigned __int64 setting_value_45;
  unsigned __int64 setting_value_f8;
  unsigned __int64 package_guard_flags;
  METASEC_JNI_GLOBAL_REF_SLOT_350 *jni_ref_slot;
} METASEC_INTEGRITY_GUARD_350;

typedef struct METASEC_REPORT_ITEM6_GUARD_VIEW_350 {
  unsigned char unknown_00[0x28];
  int has_su;
  unsigned char unknown_2c[0x68];
  int err_module;
  int jni_is_debug;
  unsigned char unknown_9c[0x14];
  __int64 tracer_pid_value;
  unsigned char unknown_b8[0x60];
  unsigned __int64 link_verify_len;
  int *link_verify_values;
} METASEC_REPORT_ITEM6_GUARD_VIEW_350;

typedef struct METASEC_HOOK_RISK_CONTEXT_350 {
  void *vtable;
  REF_COOKIE_RISK_ITEMS risk_objects;
  unsigned char unknown_18[0x10];
  REF_JSON_LIST json_list;
  unsigned char unknown_38[0xA0];
  FUN_MUTEX *native_api_scan_mutex;
  FUN_MUTEX *jni_table_scan_mutex;
  FUN_MUTEX *java_method_scan_mutex;
  unsigned char unknown_f0[0x1CC];
  unsigned char hook_mask_bytes[4];
} METASEC_HOOK_RISK_CONTEXT_350;
"""

FUNCTION_NAMES = {
    0x59294: "initEarlyRuntimeGuard_350",
    0x4A0E4: "initIntegrityGuardState_350",
    0x4A320: "initJniGlobalRefSlot_350",
    0x4A368: "destroyIntegrityGuardState_350",
    0x4A3FC: "destroyJniGlobalRefSlot_350",
    0x4A48C: "deleteJniGlobalRefSlot_350",
    0xD7F10: "detectRuntimeElfMachine_350",
    0xD8218: "deriveImageBoundsAndScheduleIntegrityCheck_350",
    0xD84FC: "checkSignalLoopIntegrity_350",
    0xD8664: "signal64GuardHandler_350",
    0x59760: "resolveObfuscatedLinkerCallbackAddr_350",
    0xB5B28: "captureProbeLrInX7_350",
    0xB5B34: "flushCodeCacheRange_350",
    0xB5B88: "flushCopiedProbeCodeCache_350",
    0x119688: "setUpdateSettingItemValue_i64_350",
    0xB5B90: "runRelocatedSignalLoopProbe_350",
    0xD86D0: "initializeIntegrityMonitor_350",
    0xD8744: "threadCheckMetaIntegrity_350",
    0xD7D84: "checkMetaIntegrityAndPublish_350",
    0xD7E18: "runMetaIntegrityXorVM_350",
    0xD7E94: "runMetaPackageCheckVM_350",
    0xD875C: "tailBranchTargetX0ForwardX1ToX0_350",
    0xC1770: "scanNativeApiHooks_350",
    0xC0E14: "scanJniFunctionTableHooks_350",
    0xBFF38: "checkArtMethodHooked_350",
    0xA1134: "scanJavaDebugAndMethodHooks_350",
    0xBE9EC: "collectHookAndDebugRisks_350",
    0xBE88C: "collectTracerPidRisk_350",
    0xAFE18: "readTracerPidForSelf_350",
    0xC813C: "detectFridaThreadNames_350",
    0xC56A4: "findFirstRootArtifact_350",
    0x143D8C: "loadProcessMapsSnapshot_350",
    0x15AFFC: "deleteCompositeVectorState_350",
    0x39778: "initRootArtifactPathTable_350",
    0x39290: "initSuspiciousAppPathStrings_350",
}

GLOBAL_NAMES = {
    0x1EA850: "g_packageCheckVmProgram_350",
    0x262800: "g_packageCheckVmAuxTableA_350",
    0x262890: "g_packageCheckVmAuxTableB_350",
    0x2BBE80: "g_early_runtime_time_350",
    0x27DC98: "g_sig64_guard_state_350",
    0x27DDF4: "g_meta_expected_xor_350",
    0x27DDF0: "g_meta_check_len_350",
    0x2C0FB8: "g_cachedElfMachinePathPrimary_350",
    0x2C0FC0: "g_cachedElfMachinePathFallback_350",
    0x2C0E58: "g_signalProbeContextActive_350",
    0x27EDF8: "g_httpSignSamplingCounter_350",
}

# Known misleading label from an older pass is explicitly replaceable.
REPLACEABLE_NAMES = {"ptrace_disable", "ptrace_disable_350", "mono_gc_free_fixed_4"}

PROTOTYPES = {
    0x4A0E4: "void __fastcall initIntegrityGuardState_350(METASEC_INTEGRITY_GUARD_350 *guard);",
    0x4A320: "void __fastcall initJniGlobalRefSlot_350(METASEC_JNI_GLOBAL_REF_SLOT_350 *slot);",
    0x4A368: "void __fastcall destroyIntegrityGuardState_350(METASEC_INTEGRITY_GUARD_350 *guard);",
    0x4A3FC: "void __fastcall destroyJniGlobalRefSlot_350(METASEC_JNI_GLOBAL_REF_SLOT_350 *slot);",
    0x4A48C: "void __fastcall deleteJniGlobalRefSlot_350(METASEC_JNI_GLOBAL_REF_SLOT_350 *slot);",
    0xD7F10: "void __fastcall detectRuntimeElfMachine_350(METASEC_INTEGRITY_GUARD_350 *guard);",
    0xD8218: "void __fastcall deriveImageBoundsAndScheduleIntegrityCheck_350(METASEC_INTEGRITY_GUARD_350 *guard);",
    0xD84FC: "void __fastcall checkSignalLoopIntegrity_350(METASEC_INTEGRITY_GUARD_350 *guard);",
    0xD8664: "void __fastcall signal64GuardHandler_350(void);",
    0x59760: "void *__fastcall resolveObfuscatedLinkerCallbackAddr_350(void);",
    0xB5B28: "void __fastcall captureProbeLrInX7_350(void);",
    0xB5B34: "void __fastcall flushCodeCacheRange_350(void *start, void *end);",
    0xB5B88: "void __fastcall flushCopiedProbeCodeCache_350(void *start, unsigned __int64 length);",
    0xB5B90: "unsigned int __fastcall runRelocatedSignalLoopProbe_350(void);",
    0x119688: "__int64 __fastcall setUpdateSettingItemValue_i64_350(COOKIE_UPDATE_SETTINGS *set, MEM_BLOCK *key, __int64 value);",
    0xD86D0: "void __fastcall initializeIntegrityMonitor_350(void);",
    0xD8744: "__int64 __fastcall threadCheckMetaIntegrity_350(void);",
    0xD7D84: "void __fastcall checkMetaIntegrityAndPublish_350(METASEC_INTEGRITY_GUARD_350 *guard);",
    0xD7E18: "unsigned __int64 __fastcall runMetaIntegrityXorVM_350(METASEC_INTEGRITY_GUARD_350 *guard);",
    0xD7E94: "void __fastcall runMetaPackageCheckVM_350(METASEC_INTEGRITY_GUARD_350 *guard);",
    0xC1770: "int __fastcall scanNativeApiHooks_350(void *scan_context);",
    0xC0E14: "int __fastcall scanJniFunctionTableHooks_350(JNIEnv *env, PROP_T2 *details);",
    0xBFF38: "int __fastcall checkArtMethodHooked_350(JNIEnv *env, void *art_method, char is_static);",
    0xA1134: "unsigned int __fastcall scanJavaDebugAndMethodHooks_350(JNIEnv *env, __int64 app_context, unsigned char *hook_mask, PROP_T2 *details, int enabled);",
    0xBE9EC: "__int64 __fastcall collectHookAndDebugRisks_350(METASEC_HOOK_RISK_CONTEXT_350 *data, REF_REPORT *report, REF_OBJ *tree);",
    0xBE88C: "__int64 __fastcall collectTracerPidRisk_350(REF_OBJ *out_ref, REF_REPORT *report, REF_OBJ *tree);",
    0xC813C: "int __fastcall detectFridaThreadNames_350(void);",
    0x15AFFC: "void __fastcall deleteCompositeVectorState_350(void *object);",
    0x39778: "void __fastcall initRootArtifactPathTable_350(void);",
    0x39290: "void __fastcall initSuspiciousAppPathStrings_350(void);",
}

COMMENTS = {
    0x59294: "早期运行时防护入口：初始化时间/路径表，并进入完整性与环境风险初始化链。",
    0x4A0E4: "构造完整性 guard、两个mutex和JNI global-ref槽；字段名来自本版本真实读写偏移，不外推到其他版本。",
    0x4A320: "初始化可复用JNI global-ref槽：state=0、global_ref=NULL，并创建mutex。该类型也被token等其他上下文复用。",
    0x4A368: "销毁integrity guard持有的两个mutex和+0x80 JNI引用槽。",
    0x4A3FC: "销毁JNI引用槽：释放mutex；若global_ref非空，则取得当前JNIEnv并调用DeleteGlobalRef。",
    0x4A48C: "JNI引用槽deleting destructor：先执行资源析构，再free槽对象。旧mono_gc_free_fixed标签不符合本版行为。",
    0xD7F10: "读取当前 ELF machine，并与 guard.expected_machine_id 比较。",
    0xD8218: "推导映像边界，装入 XOR 期望值/长度，并安排延迟完整性检查。",
    0xD84FC: "验证信号循环；失败结果写入 guard.signal_loop_failed。",
    0xD8664: "SIG64 handler：若状态不是3，则写1213(0x4BD)，并按全局 active 标志恢复上下文。",
    0x59760: "以函数自身地址构造混淆索引，从运行时表中解析 callback 地址；结果保存到 guard+0x38。",
    0xB5B28: "将调用点 LR 保存到 X7，供自修改探针以 LR-8 定位指令槽。",
    0xB5B34: "按 CTR_EL0 缓存行大小刷新一段代码的 D-cache/I-cache。",
    0xB5B88: "将 start+length 转成范围并刷新复制后的探针代码缓存。",
    0xB5B90: "mmap RWX、拷贝/重定位探针代码、等待5000后执行；返回值与10比较。没有发现持久化全局计数器。",
    0x119688: "按值更新设置树中的64位整数；现有项原位覆盖，不存在时复制key并分配8字节value。不是对调用者字段的实时引用。",
    0xD86D0: "完整性监控总初始化入口。当前证据证明初始化链，不把子项统称为 anti-debug。",
    0xD8744: "完整性检查线程入口，调用 checkMetaIntegrityAndPublish_350。",
    0xD7D84: "执行 VMP 完整性检查并把执行位/风险结果发布到 guard.integrity_risk_bits。",
    0xD7E18: "VMP 包装：计算映像区间 XOR/校验结果。具体虚拟 opcode 语义需独立证据。",
    0xD7E94: "VMP 包装：包/环境关联检查。返回值传播方式按调用点解释。",
    0xD875C: "寄存器级尾跳转 bridge：入口 X0=target、X1=primary arg；MOV X2,X0; MOV X0,X1; BR X2。仅证明目标收到原 X1 作为 X0；不写内存/不改 LR，不能据此推断 callback 业务语义、完整 arity 或返回类型。",
    0xC1770: "扫描 native API 地址/归属异常；结果汇入 hook 风险集合。",
    0xC0E14: "检查 JNIEnv 函数表指针的模块归属/异常。",
    0xBFF38: "检查 ART method 入口与预期实现区域是否一致。",
    0xA1134: "汇总 Java debug/method hook 项，并更新 4 字节 hook mask。",
    0xBE9EC: "hook/debug 风险聚合器；三个 mutex 与 hook_mask 位于本版 +D8/+E0/+E8/+2BC。",
    0xBE88C: "读取并编码 TracerPid 风险项。检测结果进入 report/tree，而非简单立即退出。",
    0xAFE18: "从 /proc/self/status 路径读取当前进程 TracerPid。",
    0xC813C: "在线程名称集合中查找 Frida 相关特征。命中值由上层风险聚合器消费。",
    0xC56A4: "遍历 root artifact 路径表并返回首个命中项。",
    0x143D8C: "读取 /proc/self/maps 风格快照，供模块归属和异常映射检查使用。",
    0x15AFFC: "仅析构复合向量状态并 free；不是 ptrace/反调试开关。",
    0x39778: "初始化 root artifact 路径表。",
    0x39290: "初始化可疑应用/环境路径字符串表。",
}

DATA_COMMENTS = {
    0x1EA850: "350.101 package/environment check VMP program start. ELF PT_LOAD maps this RVA directly to file offset 0x1EA850. Dynamic logs observe the next VM entry at 0x1EC4D0; [0x1EA850,0x1EC4D0) has 1824 words, with a zero terminal word at 0x1EC4CC. Static inventory is syntactic only until this entry is traced.",
    0x262800: "Auxiliary table A passed as exeVMInner arg2 for VM program 0x1EA850. Entries are packed VM auxiliary data; do not type as native function pointers without handler/trace evidence.",
    0x262890: "Auxiliary table B passed as exeVMInner arg3 for VM program 0x1EA850. Exact role remains evidence-limited; not a proven native dispatch table.",
    0x2BBDF8: "进程级 REF_OBJ，内部持有0x88字节 integrity guard；由 cxa_guard 单例初始化，完整性与报告链共同读取。",
    0x2BBE80: "先保存早期时间基准；JNI_OnLoad 在0x13A288..0x13A290将其原地改写为 now-start 耗时。不是递增计数器。",
    0x27DC98: "SIG64 状态机：-1=sigaction失败，1=准备，3=raise返回，1213=handler确认；0xDD878将其写入JSON报告。",
    0x27DDF0: "映像完整性检查长度；0xD8394读取后写入guard+0x28，异常哨兵范围令其归零。",
    0x27DDF4: "映像完整性期望XOR值；0xD82E0读取后写入guard+0x20，随后作为VMP输入。",
    0x2C0FB8: "ELF machine首选路径的惰性解密缓存；供openat/read使用，不是检测结果。",
    0x2C0FC0: "ELF machine备用路径的惰性解密缓存；首选探测失败时使用。",
    0x2C0E58: "SIG64 probe上下文首字段/active标志；参与上下文恢复，不是命中次数。",
    0x27EDF8: "HTTP签名调用抽样计数器，初值0；每次buildSignedHttpHeadersInner_350递增一次，以counter%10和位图决定耗时/设备信息采样。当前静态代码未见同步或原子操作。",
}

LINE_COMMENTS = {
    0x4A12C: "guard+0x38保存混淆表解析出的callback地址；后续格式化上报并做linker地址归属分类。",
    0x4A1A8: "把guard+0x68当前32位值复制到设置键45ca7e...；setter保存的是值副本，不是字段地址。初始化时该值为0。",
    0x4A1D8: "把guard+0x70当前32位值复制到设置键f866b1...；这是初始化快照。",
    0x4A208: "把guard+0x78低32位复制到设置键cede08...；具体业务语义尚未由350.101独立证明。",
    0x4A238: "把guard+0x7C高32位复制到设置键30c8cb...；具体业务语义尚未由350.101独立证明。",
    0x4A268: "把guard+0x50 integrity_risk_bits复制到设置键593fa4...；初始化值为0，完整性检查后会再次发布。",
    0x4A338: "JNI引用槽+0x08 state初始化为0。",
    0x4A340: "JNI引用槽+0x10 global_ref初始化为NULL。",
    0x4A358: "JNI引用槽+0x18保存新建mutex。",
    0x4A41C: "读取slot+0x18并调用其析构虚函数，随后清零mutex字段。",
    0x4A440: "slot+0x10非空时获取当前线程JNIEnv，随后调用DeleteGlobalRef。",
    0xD7F30: "LDR [guard+0x0C]与0xFF比较，证明+0x0C是observed_machine_id/unknown哨兵。",
    0xD7EBC: "在native栈上构造VM参数块：[0]=guard指针，[1]=0xD875C tail-branch target；exeVMInner的X1指向该参数块。该 bridge 只确认原X1会转送为目标X0，不能泛化为callback ABI。",
    0xD7EE8: "调用exeVMInner(program=0x1EA850,args={guard,0xD875C},auxA=0x262800,auxB=0x262890)。要证明guard+0x40/+0x68..字段写入，需针对该VM入口记录内存副作用。",
    0xD8014: "e_machine 0x28/0xB7/3/0x3E映射为内部1/2/3/4后写guard+0x0C。",
    0xD82A4: "读取guard+0x10作为映像起点；后续结合PT_LOAD计算终点。",
    0xD82BC: "写guard+0x18；值为页对齐PT_LOAD覆盖终点，因此命名image_end。",
    0xD82E4: "将g_meta_expected_xor_350写入guard+0x20，随后传入完整性VMP。",
    0xD8398: "将g_meta_check_len_350写入guard+0x28，证明image_check_length布局。",
    0xD85F4: "检查handler是否把SIG64全局状态改成1213；这不是循环计数器本体。",
    0xD8614: "mutex获取失败时写guard+0x30；结合0xD862C第二写点，命名signal_loop_failed。",
    0xDD754: "guard+0x0C observed_machine_id决定候选地址是否清除bit0，并影响linker指针读取。",
    0xDD778: "清除候选运行时地址最低位；仅machine-id==1时选用去标记地址。",
    0xDD7A4: "Android 29+用process_vm_readv从machine-id处理后的地址读取4字节。",
    0xDD878: "读取SIG64状态，转double后交给cJSON_AddNumberToObject，证明它会影响报告输出。",
    0xDDE70: "guard+0x38作为格式参数输出；同一字段还参与callback地址归属分类。",
    0xDDFC0: "guard+0x40转有符号double后写JSON；非VMP静态写入源尚未确认。",
    0xDE694: "guard+0x38与page_size/linker区间比较，生成0/1/2分类并写JSON。",
    0xDE6A0: "callback地址低于一页先编码1；ARM64且区间异常时改编码2。",
    0xA4B3C: "读取guard+0x48 link_verify_code，下一调用写入REPORT_ITEM6的link_verify属性。",
    0xA7354: "guard+0x4C等于1时追加风险条目9；它是可上报的link-verify辅助标志。",
    0xA73D8: "guard+0x30 signal_loop_failed等于1时追加风险条目12。",
    0x893BC: "guard+0x10 image_base是敏感入口调用来源校验下界。",
    0x8943C: "guard+0x18 image_end是调用来源校验上界。",
    0x89500: "实际候选返回地址从returnLR返回帧的[frame+8]取得。",
    0x89540: "candidate_lr<=image_base视为非法边界。",
    0x89568: "candidate_lr>=image_end视为非法边界。",
    0x895B0: "调用来源越出(image_base,image_end)时进入exeCheckFailed1。",
    0x12EC88: "getNjssByNet_30001读取guard.image_base执行同一套调用来源范围校验。",
    0x12ED04: "读取guard.image_end，随后检查[return_frame+8]是否严格位于映像区间。",
    0x12ED20: "候选返回地址来自returnLR_frame+8；这个+8是真实帧布局，不是平坦化噪声。",
    0x12ED30: "候选返回地址越界时调用exeCheckFailed1。",
    0xB5A48: "寄存器计数器X5++；不是全局内存计数。",
    0xB5A50: "从[X7-8]读取X5++的4字节机器码。",
    0xB5A54: "首轮执行X4++，随后本指令槽会被X5++机器码覆盖。",
    0xB5A5C: "X2=X7-8，定位刚执行的X4++指令槽。",
    0xB5A64: "向RWX页写指令字，以X5++覆盖X4++；循环内故意不刷新I-cache。",
    0xB5A68: "X4与10比较；真实CPU旧取指应让X4继续递增到10。",
    0xB5A70: "X5也与10比较作退出保护；立即看见自修改代码时X4会不足10。",
    0xB5B08: "退出前恢复被覆盖位置原来的X4++指令字。",
    0xB5B0C: "返回X4；上层与10比较并据此写guard+0x30。",
    0xB5C30: "复制0x270字节探针代码到匿名RWX页。",
    0xB5C3C: "首次执行前显式刷新整段复制代码的D/I cache。",
    0xB5C48: "执行复制入口；返回值来自探针X4寄存器。",
    0x13A288: "读取早期时间基准，下一条计算current_time-start。",
    0x13A290: "把JNI_OnLoad耗时原地写回全局；该槽从起始时间转为耗时。",
    0x149EC0: "g_httpSignSamplingCounter_350%10；余数位命中0x291(bits 0/4/7/9)时记录本次起始时间。",
    0x149F10: "余数位命中0x14B(bits 0/1/3/6/8)时执行一次设备信息刷新/采样。",
    0x149F40: "HTTP签名抽样计数器+1；这是普通64位全局写，当前未见锁或原子指令。",
    0x14A718: "仅在本轮已取起始时间时，把elapsed_ms作为64位值写入fd8d1a...设置项。",
    0x14A468: "对当前中间输出tree的序列化MEM_BLOCK计算CRC32。",
    0x14A490: "把中间tree的CRC32快照写入设置键167774bf518c11948aa0784351ccf5a9。",
    0x14A508: "F8 managed builder返回后，把常量100写入设置键2e8ab1223d07836ad4fc65fc581b4808；精确业务含义待证。",
    0xBEA78: "data+0xD8后接pthread_mutex_trylock，证明native API扫描mutex字段。",
    0xBEAD8: "data+0xE0后接pthread_mutex_trylock，证明JNI table扫描mutex字段。",
    0xBEB3C: "data+0xE8后接pthread_mutex_trylock，证明Java/ART method扫描mutex字段。",
    0xBEBAC: "data+0x2BC作为Java hook scanner的hook_mask参数，证明尾部4字节布局。",
    0xBEC1C: "三路扫描结果不一致时，对data+0x2BC调setHookMask(1)，该字段进入风险结果。",
}


def _verify_version(base: int) -> None:
    mismatches = []
    for rva, expected in ANCHORS.items():
        actual = ida_bytes.get_bytes(base + rva, len(expected))
        if actual != expected:
            mismatches.append(
                f"RVA 0x{rva:x}: expected {expected.hex()}, got "
                f"{actual.hex() if actual else '<unmapped>'}"
            )
    if mismatches:
        raise RuntimeError("350.101 anchor mismatch; refusing to annotate:\n" + "\n".join(mismatches))


def _declare_types() -> None:
    # IDA 9.3 签名: parse_decls(til, input, printer, hti_flags)——printer 传 None，
    # PT_SIL 是第 4 个 hti_flags 参数（旧三参写法在 9.3 直接 TypeError）。
    errors = ida_typeinf.parse_decls(
        ida_typeinf.get_idati(), TYPE_DECLS, None, ida_typeinf.PT_SIL
    )
    if errors:
        raise RuntimeError(f"local type declaration errors: {errors}")


def _set_name(ea: int, wanted: str) -> bool:
    old = ida_name.get_name(ea) or ""
    replaceable = not old or old == wanted or old in REPLACEABLE_NAMES
    replaceable = replaceable or old.startswith(("sub_", "loc_", "unk_", "byte_", "dword_", "qword_", "off_"))
    if not replaceable:
        ida_kernwin.msg(f"{TAG} preserve analyst name at 0x{ea:x}: {old}\n")
        return False
    return bool(ida_name.set_name(ea, wanted, ida_name.SN_NOCHECK | ida_name.SN_NOWARN))


def _apply_prototype(ea: int, declaration: str) -> None:
    tif = ida_typeinf.tinfo_t()
    if not ida_typeinf.parse_decl(tif, None, declaration, ida_typeinf.PT_SIL):
        raise RuntimeError(f"cannot parse prototype at 0x{ea:x}: {declaration}")
    if not ida_typeinf.apply_tinfo(ea, tif, ida_typeinf.TINFO_DEFINITE):
        raise RuntimeError(f"cannot apply prototype at 0x{ea:x}")


def _merge_tagged_comment(old: str, body: str) -> str:
    start = old.find(TAG)
    if start >= 0:
        end = old.find(TAG_END, start)
        if end >= 0:
            old = (old[:start] + old[end + len(TAG_END):]).strip()
    block = f"{TAG}\n{body}\n{TAG_END}"
    return f"{old}\n\n{block}".strip() if old else block


def main() -> None:
    base = ida_nalt.get_imagebase()
    _verify_version(base)
    _declare_types()

    for rva, wanted in FUNCTION_NAMES.items():
        _set_name(base + rva, wanted)
    for rva, wanted in GLOBAL_NAMES.items():
        _set_name(base + rva, wanted)
    for rva, declaration in PROTOTYPES.items():
        _apply_prototype(base + rva, declaration)
    for rva, body in COMMENTS.items():
        ea = base + rva
        fn = ida_funcs.get_func(ea)
        is_function_entry = fn is not None and fn.start_ea == ea
        old = (
            ida_funcs.get_func_cmt(fn, False)
            if is_function_entry
            else ida_bytes.get_cmt(ea, False)
        )
        merged = _merge_tagged_comment(old or "", body)
        if is_function_entry:
            ida_funcs.set_func_cmt(fn, merged, False)
        else:
            ida_bytes.set_cmt(ea, merged, False)
    for rva, body in DATA_COMMENTS.items():
        ea = base + rva
        old = ida_bytes.get_cmt(ea, False) or ""
        ida_bytes.set_cmt(ea, _merge_tagged_comment(old, body), False)
    for rva, body in LINE_COMMENTS.items():
        ea = base + rva
        old = ida_bytes.get_cmt(ea, False) or ""
        ida_bytes.set_cmt(ea, _merge_tagged_comment(old, body), False)

    ida_auto.auto_wait()
    ida_kernwin.msg(
        f"{TAG} applied {len(FUNCTION_NAMES)} functions, "
        f"{len(GLOBAL_NAMES)} globals, {len(PROTOTYPES)} prototypes; save IDB when ready.\n"
    )


if __name__ == "__main__":
    main()
