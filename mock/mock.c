/*
 * libmock.so — libmetasec_ml.so 防护机制的教学级重现（加固版 v10）。
 *
 * 重现的六大机制（均按真 .so 的实际结构）：
 *
 *  1. 字符串加密（真实方案，非近似）
 *     真 .so 的 5 个解密函数（0x12B904/0x12BFA8/0x12C648/0x12C9A4/0x12CF90）
 *     经黑盒提炼确认为"周期-8 XOR 密钥流 × 5 组独立密钥"。本文件照搬：
 *     同一组密钥、同一调用约定 dec(buf,len) 原地解密、密文两种装载形态
 *     （.rodata 拷贝 + 立即数展开，由 gen_ciphers.py 按字符串长度选择）。
 *     每个变体带一个 O-MVLL 风格 opaque predicate：(i*(i+1))&1 恒为 0，
 *     对应真 .so 里大量 x*(x+1)&1 / MBA(and+eor+madd) 混淆块。
 *
 *  2. JNI_OnLoad 动态注册（结构复刻真 .so 函数 0x12F5D0）
 *     类名/方法名/签名全部运行时解密；fnPtr 走 adrp+add PC 相对寻址；
 *     RegisterNatives 经 JNIEnv vtable slot 215（真 .so 调用点 0x12F92C）。
 *
 *  3. CRC 自校验（加固层，对应真 .so 的 0x20190512→0x77DF8B85 校验）
 *     JNI_OnLoad 入口对自身 .text 前 0x180 字节求 CRC32，与构建期由
 *     so_linker.py 回填的期望值 CRC_EXPECT 比较；失配即拒绝注册
 *     （真 .so 在失配时调用自毁函数 0x125D34）。
 *     作用：任何对代码段的 patch（hook、inline hook、断点改写）都会
 *     改变 CRC，使库拒绝工作。
 *
 *  4. 反模拟检查（加固层，对应真 .so 的 svc/NZCV 反模拟块）
 *     svc #0 系统调用探测 + NZCV 标志寄存器回读校验，识别
 *     Unicorn/QEMU 用户态等"无内核、指令语义不忠实"的运行环境；
 *     命中即拒绝注册。见 emu_check() 注释。
 *
 *  5. 运行时代码解密（加固层，对应真 .so 的完整形态：
 *     错位密文 + 明文写回跳入 + 用后重加密）
 *     payload() 的机器码在构建期由 so_linker.py 加密后搬到 2 对齐
 *     密文槽位，原位填 udf 陷阱；n_b() 每次调用时经 mprotect(RWX)
 *     + XOR 解密写回 + I-cache 刷新恢复明文，返回前 seal_payload()
 *     立即恢复密文 —— 明文只存在于一次调用之内。
 *     见 unlock_payload()/seal_payload() 注释。
 *
 *  6. 控制流平坦化 + MBA 混淆（加固层，对应真 .so 的 O-MVLL 形态：
 *     ctor[0] 0x59294 实测为状态机分发 + 0x59440 的计算式间接跳转，
 *     算术全部走 and/eor/madd 混合布尔表达式）
 *     n_b() 的 unlock→payload→seal 三段时序被打散成穿线式状态机：
 *     每个基本块尾部读 int32 偏移表（GNU C 计算 goto 标签差值，
 *     汇编期解出、零重定位）+ add + br xN 计算下一块地址，无 switch
 *     无跳表；状态推进与解密 XOR 全部改用 MBA 恒等式表达
 *     （见 MBA 一节），配合 volatile opaque 值阻断编译器折叠。
 *
 *  7. 反调试（加固层，对应真 .so 的 ptrace 自检 + TracerPid 轮询）
 *     探针 C：ptrace(PTRACE_TRACEME) 加载期一次性占坑（成功后调试器
 *     再 attach 即被内核 EPERM 拒绝；已被调试则 TRACEME 直接失败）；
 *     探针 D：/proc/self/status 的 TracerPid 轮询，判定与真内核语义
 *     对齐（TracerPid==0 或 ==getppid() 为干净——TRACEME 占坑后
 *     父进程即 tracer，朴素"非 0 即判定"会永久误伤自己）。
 *     轮询点双轨：每次 native 调用入口同步轮询 + 裸 clone(220)
 *     起的后台 watcher 线程 50ms 周期轮询（命中即 exit_group 自毁）。
 *     /proc 路径与字段名同样走字符串加密。
 *     见 ptrace_selfcheck()/tracerpid_poll()/spawn_watcher() 注释。
 *
 * 无 libc 依赖（-nostdlib -ffreestanding）；所有 JNI 调用都经过
 * 运行时传入的 JavaVM/JNIEnv vtable。
 *
 * 构建: ./build.sh  (Apple clang 交叉编译 .o + so_linker.py 链接/回填 CRC)
 */

#include <stdint.h>
#include "cipher_data.h"

/* ================= 最小 JNI 声明（无需 NDK 头文件） ================= */

typedef int32_t  jint;
typedef int64_t  jlong;
typedef void*    jobject;
typedef void*    jclass;
typedef void*    jstring;
typedef void*    JNIEnv;                 /* 实为 JNINativeInterface* 的地址 */
typedef void*    JavaVM;                 /* 实为 JNIInvokeInterface* 的地址 */

/* JNINativeMethod —— RegisterNatives 的方法表项（与 JNI 规范一致） */
typedef struct {
    const char* name;                    /* 方法名（本库中为运行时解密结果） */
    const char* sig;                     /* JNI 签名（同上） */
    void*       fnPtr;                   /* native 实现地址（adrp+add 取） */
} JNINativeMethod;

#define JNI_VERSION_1_6 0x00010006

/* vtable 槽位（下标已计入规范开头的保留项）：
 *   JNIEnv:  6=FindClass  167=NewStringUTF  215=RegisterNatives
 *   JavaVM:  6=GetEnv                                          */
#define SLOT_FindClass        6
#define SLOT_NewStringUTF   167
#define SLOT_RegisterNatives 215
#define SLOT_VM_GetEnv        6

typedef jint    (*GetEnv_t)(JavaVM, void**, jint);
typedef jclass  (*FindClass_t)(JNIEnv, const char*);
typedef jstring (*NewStringUTF_t)(JNIEnv, const char*);
typedef jint    (*RegisterNatives_t)(JNIEnv, jclass, const JNINativeMethod*, jint);

/* 取对象 vtable：JNIEnv/JavaVM 首字段即函数表指针 */
#define VTBL(obj) (*(void***)(obj))

/* ================= 5 个解密函数变体（真实密钥流） =================
 *
 * 真实配方（每个变体相同结构，仅 K 不同）：
 *     for i in [0,len): buf[i] ^= K[i & 7];  buf[len] = 0;  return buf;
 *
 * noinline 必不可少：保证解密函数以独立实体存在、调用点保留 bl，
 * 与真 .so 的"一个变体被数百个调用点复用"形态一致。
 *
 * while 条件里的 (i*(i+1))&1 是 O-MVLL 风格 opaque predicate：
 * 对任意整数 i，i*(i+1) 必为偶数，故该位恒 0、条件恒真；
 * 静态分析者需要证明这一点才能确认循环必然执行。
 */

#define DEC_VARIANT(N)                                                     \
__attribute__((noinline)) static char* dec_v##N(uint8_t* b, int n) {       \
    int i = 0;                                                             \
    /* opaque predicate: (i*(i+1))&1 == 0 恒成立 */                        \
    while (((i * (i + 1)) & 1) == 0 && i < n) {                            \
        b[i] ^= K##N[i & 7];                                               \
        i++;                                                               \
    }                                                                      \
    b[n] = 0;                                                              \
    return (char*)b;                                                       \
}

DEC_VARIANT(1)
DEC_VARIANT(2)
DEC_VARIANT(3)
DEC_VARIANT(4)
DEC_VARIANT(5)

/* RODATA 形态：把密文从 .rodata 拷贝进可写栈缓冲（对应真 .so 的
 * "new[] + ldr q0/d0 整块搬运"模式；编译后表现为 ldrb/strb 循环） */
static inline void load_ct(uint8_t* dst, const uint8_t* src, int n) {
    for (int i = 0; i < n; i++)
        dst[i] = src[i];
}

/* ================= CRC 自校验 =================
 *
 * 对应真 .so：多处出现"对代码/数据求 CRC-32（种子 0x20190512）后与
 * 硬编码常量 0x77DF8B85 比较，失配则 bl 0x125D34（自毁）"。
 *
 * 本实现：对 .text 起始 0x180 字节（覆盖 JNI_OnLoad 本体）做标准 CRC32，
 * 期望值 CRC_EXPECT 是占位魔数，构建时由 so_linker.py 在重定位完成后
 * 计算真实 CRC 并回填到 .rodata —— 因此源码里永远看不到正确期望值。
 */

#define CRC_SELF_CHECK_LEN 0x180

/* 占位魔数：构建期被 so_linker.py 定位并改写为真实 CRC32 */
static volatile const uint32_t CRC_EXPECT = 0xDEADBEEF;

/* 标准 CRC32（多项式 0xEDB88320，位运算版，无查表避免额外数据段） */
__attribute__((noinline))
static uint32_t crc32_self(const uint8_t* p, int n) {
    uint32_t c = 0xFFFFFFFF;
    for (int i = 0; i < n; i++) {
        c ^= p[i];
        for (int k = 0; k < 8; k++)
            /* -(c&1): c 奇 -> 全 1 掩码，偶 -> 0；等价于分支但无跳转 */
            c = (c >> 1) ^ (0xEDB88320u & (uint32_t)(-(int32_t)(c & 1)));
    }
    return ~c;
}

/* ================= MBA 混淆原语 =================
 *
 * 对应真 .so：O-MVLL 把所有关键算术改写成 Mixed Boolean-Arithmetic
 * 恒等式——二进制里看不到一条"干净"的 eor/add，全是 and/or/eor/sub/
 * madd 的混合网（0x59294 反模拟块、各解密函数周边均实测到）。
 *
 * 本实现采用两条**经实测能在 clang -O2 下存活**的恒等式
 * （常见的 (a|b)-(a&b) 会被 InstCombine 折叠回 eor，白混淆——
 * 这就是为什么真 .so 的 O-MVLL 要在编译器后端注入而不是写源码）：
 *     a ^ b  ==  a + b - 2*(a & b)          → 编译为 add/and/sub 网
 *     a + b  ==  2*(a | b) - (a ^ b)        → 编译为 orr/eor/mul/sub 网
 * 再叠加非线性 opaque 项 (c*(c+1))&1（任意整数乘其后继必为偶数，
 * 恒 0，但编译器无法证明 c 是整数域上的局部性质之外的任何东西）。
 *
 * 关键问题：clang -O2 会折叠一切它能证明的恒等式。opaque 值用
 * volatile 局部变量承载（恒存 0）：volatile 语义强制每次使用都必须
 * 真实产生一次内存 load，编译器不得用常量替代其结果，恒等式因此
 * 无法在编译期被折叠。
 *
 * 用法：每个使用方函数内声明 `volatile uint32_t OP = 0;` 并把 &OP
 * 传给原语。OP 的地址不出函数、值恒 0，语义完全等价于原生运算。
 */

static inline uint32_t mba_xor(uint32_t a, uint32_t b, volatile uint32_t* op) {
    /* a^b == a + b - 2*(a&b) + 0（二进制：add/and/sub/mul 网，无 eor） */
    uint32_t c = *op;
    return a + b - 2u * (a & b) + ((c * (c + 1)) & 1);
}

static inline uint32_t mba_add(uint32_t a, uint32_t b, volatile uint32_t* op) {
    /* a+b == 2*(a|b) - (a^b) + 0（二进制：orr/eor/mul/sub 网，无干净 add） */
    uint32_t c = *op;
    return 2u * (a | b) - (a ^ b) + ((c * (c + 1)) & 1);
}

/* ================= 反模拟检查 =================
 *
 * 对应真 .so：init_array ctor[0] (0x59294) 里实测到的原版对抗块，
 * 目标是识别 Unicorn/QEMU 用户态模拟这类"无内核接管、指令语义
 * 不完全忠实"的分析环境。本实现用两种互补探针：
 *
 * 探针 A —— NZCV 忠实性检查 + brk 反调试陷阱（逐指令复刻 0x59394）：
 *   mrs 保存 NZCV → cmp xzr,xzr 置 Z=1 → msr NZCV 清零（Z→0）→
 *   b.ne 正常跳过。忠实实现 NZCV 写入的环境（真机、Unicorn）：跳过陷阱；
 *   不实现 msr NZCV 的弱模拟器/插桩框架：Z 保持 1，b.ne 不跳转，
 *   直接踩 clrex + brk #3（SIGTRAP）——裸运行时崩、被调试时暴露。
 *
 * 探针 B —— svc #0 系统调用探测（真 .so 0x59380 同款）：
 *   以 __NR_getpid(172) 发起一次真实系统调用。
 *   真机：内核接管 svc，x0 返回 pid（恒 > 0），检查通过。
 *   Unicorn：没有内核，svc 触发未处理的异常 → 抛出 UC_ERR_EXCEPTION，
 *   模拟直接中止，根本执行不到返回值比较 —— 防护在指令级生效，
 *   而不是依赖"返回值看起来不对"。
 *
 * 攻击方的标准跟进手法：给模拟器加 UC_HOOK_INTR，伪造 syscall 返回
 * 并把 PC 手动跳过 svc 指令。也就是说本层把攻击成本从"直接模拟"
 * 抬高到"必须先识别并接管每一条对抗指令"。
 *
 * noinline：保证探针以独立实体存在（与真 .so 的对抗块形态一致），
 * 也防止编译器把 NZCV 序列优化合并。
 */
__attribute__((noinline))
static int emu_check(void) {
    /* 探针 A：NZCV 忠实性 + brk 陷阱（0x59394 原版形态） */
    uint64_t ok;
    __asm__ volatile(
        "mrs  x1, nzcv\n"        /* 保存标志                   */
        "mov  x0, xzr\n"
        "cmp  x0, xzr\n"         /* Z=1                        */
        "msr  nzcv, x0\n"        /* 忠实实现：NZCV=0 → Z=0      */
        "b.ne 1f\n"              /* Z=0 → 跳过陷阱              */
        "clrex\n"                /* ← 弱模拟器落入这里          */
        "brk  #0x3\n"            /* SIGTRAP：崩溃/暴露          */
        "1:\n"
        "msr  nzcv, x1\n"        /* 恢复标志                    */
        "mov  %0, #1\n"
        : "=r"(ok) :: "x0", "x1", "cc");

    /* 探针 B：svc #0 getpid；真机 x0=pid>0，Unicorn 在此抛异常中止 */
    register int64_t x8 __asm__("x8") = 172;   /* __NR_getpid (aarch64) */
    register int64_t x0 __asm__("x0") = -1;
    __asm__ volatile("svc #0" : "+r"(x0) : "r"(x8) : "memory");
    return x0 > 0;
}

/* ================= 运行时代码解密 =================
 *
 * 对应真 .so（init_array ctor[93] 0x129430 实测）：关键函数的机器码在
 * 文件中以密文存放，且**密文槽位故意放在 2 对齐地址**——分析者按跳转
 * 目标开始反汇编时，指令相位与真实 4 对齐网格错开 2 字节，线性/递归
 * 反汇编全部错乱；运行时解密后明文写回 4 对齐的原函数地址再跳入。
 *
 * 本实现：
 *   - 构建期（so_linker.py）：payload() 的机器码加密后搬到 RX blob 尾部
 *     一个 VA≡2 (mod 4) 的密文槽位；payload 原位填 0（udf #0——未解密
 *     时被调用立即 SIGILL）；VA/长度/密钥/槽位地址回填进 4 个占位常量；
 *   - 运行时：按需解密、用完立即重加密（真 .so 的完整形态）——
 *     n_b() 每次被调用时 unlock_payload() 解密，返回前 seal_payload()
 *     恢复密文。明文只存在于调用的瞬间，攻击者的 dump 窗口被压缩到
 *     一次调用之内；
 *   - unlock_payload()：
 *     1. mprotect 把代码页改成 RWX（无 libc，直接 svc 系统调用，
 *        aarch64 __NR_mprotect = 226）；
 *     2. 从 2 对齐槽位读出密文，XOR 解密，明文写回 payload 的
 *        4 对齐原地址（"明文写回后跳入"）；
 *     3. dc cvau / ic ivau 刷新 D/I-cache 一致性（EL0 可用），
 *        dsb + isb 收尾 —— 自修改代码在真机上不可省略的一步；
 *   - seal_payload()：XOR 对称，原地再 XOR 一遍即恢复成与槽位一致
 *     的密文，同样需要 cache 同步。
 *
 * 注意回填值都是文件相对 VA；真机 ASLR 下必须叠加运行时模块基址
 * （由调用方以页对齐的自身地址算出）——与真 .so 一致。
 */
static volatile const uint64_t PAYLOAD_ADDR = 0xDEAD0001ULL;  /* 回填：明文写回 VA（4 对齐） */
static volatile const uint64_t PAYLOAD_LEN  = 0xDEAD0002ULL;  /* 回填：字节长度 */
static volatile const uint64_t PAYLOAD_KEY  = 0xDEAD00A7ULL;  /* 回填：XOR 密钥 */
static volatile const uint64_t PAYLOAD_CT   = 0xDEAD0004ULL;  /* 回填：密文槽位 VA（2 对齐） */

/* 三参数原始系统调用（无 libc 封装） */
static long raw_svc3(long nr, long a0, long a1, long a2) {
    register long x8 __asm__("x8") = nr;
    register long x0 __asm__("x0") = a0;
    register long x1 __asm__("x1") = a1;
    register long x2 __asm__("x2") = a2;
    __asm__ volatile("svc #0" : "+r"(x0) : "r"(x8), "r"(x1), "r"(x2) : "memory");
    return x0;
}

/* 四参数原始系统调用（ptrace 用） */
static long raw_svc4(long nr, long a0, long a1, long a2, long a3) {
    register long x8 __asm__("x8") = nr;
    register long x0 __asm__("x0") = a0;
    register long x1 __asm__("x1") = a1;
    register long x2 __asm__("x2") = a2;
    register long x3 __asm__("x3") = a3;
    __asm__ volatile("svc #0" : "+r"(x0) : "r"(x8), "r"(x1), "r"(x2), "r"(x3) : "memory");
    return x0;
}

/* ================= 反调试检查（加载期自检 + 运行期轮询） =================
 *
 * 对应真 .so：ptrace 自检 + /proc/self/status 的 TracerPid 轮询
 * （真 .so 在后台线程里周期性轮询；本库无可行线程原语，轮询点改为
 * 散布在每次 native 调用入口——语义等价：任何挂调试器的时刻都会
 * 在下一次业务调用时被捕获）。
 *
 * 探针 C —— ptrace(PTRACE_TRACEME) 自检（加载期一次性）：
 *   未被调试：TRACEME 成功（返回 0），进程从此被打上"已被 tracer
 *   占据"的标记，后续调试器再 attach 会被内核拒绝（EPERM）——
 *   这是"先发占坑"式反调试。
 *   已被调试：TRACEME 直接返回 -EPERM → 判定受调试。
 *   注意必须只调一次：TRACEME 成功后进程已置 PT_PTRACED，第二次
 *   调用会返回 EPERM 造成误伤——所以本探针只在 JNI_OnLoad 跑，
 *   运行期轮询只读 TracerPid（无副作用）。
 *
 * 探针 D —— TracerPid 轮询（每次 native 调用）：
 *   openat("/proc/self/status") → read → 找 "TracerPid:" 字段，
 *   值非 0 即有 tracer。/proc 路径与字段名同样走字符串加密
 *   （否则 strings 一条命令就暴露检测点）。
 *   策略选择（fail-open）：openat 失败视为无 tracer 放行——真 .so
 *   同类检测也不对 /proc 不可用的受限环境误伤；攻击方若伪造
 *   /proc（模拟器），则这层的对抗转移到"虚拟文件内容与 ptrace
 *   子系统是否自洽"——见 UNIDBG_NOTES.md P1-2。
 *
 * 系统调用号（aarch64）：openat=56 read=63 close=57 ptrace=117
 */

#define SYS_openat 56
#define SYS_read   63
#define SYS_close  57
#define SYS_ptrace 117
#define AT_FDCWD   (-100L)
#define PTRACE_TRACEME 0

/* 探针 C：加载期一次性 ptrace 自检。返回 1=干净，0=被调试 */
__attribute__((noinline))
static int ptrace_selfcheck(void) {
    return raw_svc4(SYS_ptrace, PTRACE_TRACEME, 0, 0, 0) == 0;
}

/* 探针 D：TracerPid 轮询点。返回 1=干净，0=被调试
 *
 * 数值语义（与真内核一致，必不可少）：探针 C 的 TRACEME 成功后，
 * 父进程（Android 上即 zygote）就成为本进程的 tracer，
 * TracerPid 从此恒等于 getppid()——所以"非 0 即被调试"会
 * 永久误伤自己。正确判定：TracerPid == 0（尚未 TRACEME/无 tracer）
 * 或 == getppid()（TRACEME 占坑的正常形态）视为干净；其它值
 * （调试器的 pid）判定受调试。 */
__attribute__((noinline))
static int tracerpid_poll(void) {
    uint8_t path[L_procstatus + 1];
    load_ct(path, C_procstatus, L_procstatus);
    dec_v2(path, L_procstatus);                       /* "/proc/self/status" */
    long fd = raw_svc3(SYS_openat, AT_FDCWD, (long)path, 0 /* O_RDONLY */);
    if (fd < 0)
        return 1;                                     /* fail-open：/proc 不可用不误伤 */
    uint8_t buf[512];
    long n = raw_svc3(SYS_read, fd, (long)buf, sizeof(buf) - 1);
    raw_svc3(SYS_close, fd, 0, 0);
    if (n <= 0)
        return 1;
    buf[n] = 0;
    /* 解密字段名标记（IMM 形态装载：.rodata 无痕迹） */
    uint8_t mark[L_tracerpid + 1];
    LOAD_C_tracerpid(mark);
    mark[L_tracerpid] = 0;
    dec_v3(mark, L_tracerpid);                        /* "TracerPid:" */
    /* 线性扫描标记，命中后解析完整数值 */
    for (long i = 0; i + L_tracerpid <= n; i++) {
        long j = 0;
        while (j < L_tracerpid && buf[i + j] == mark[j])
            j++;
        if (j == L_tracerpid) {
            long k = i + L_tracerpid;
            while (k < n && (buf[k] == ' ' || buf[k] == '\t'))
                k++;
            long val = 0;
            while (k < n && buf[k] >= '0' && buf[k] <= '9') {
                val = val * 10 + (buf[k] - '0');
                k++;
            }
            if (val == 0)
                return 1;                             /* 无 tracer */
            /* TRACEME 占坑后 TracerPid == getppid() 属正常形态 */
            long ppid = raw_svc3(173 /* __NR_getppid */, 0, 0, 0);
            return val == ppid ? 1 : 0;               /* 其它 pid = 调试器 */
        }
    }
    return 1;                                         /* 无字段：视为干净 */
}

/* ================= 反调试线程化：后台 TracerPid 周期轮询 =================
 *
 * 对应真 .so：TracerPid 轮询跑在独立后台线程里，业务调用的间隙
 * 不再有检测空窗。本实现用裸 clone(220) 起线程（无 libc/pthread）：
 *
 *   1. mmap(222) 匿名页作为子线程栈（MAP_PRIVATE|MAP_ANONYMOUS）；
 *   2. clone(CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD,
 *      child_sp) —— 与 pthread_create 的内核路径完全同款，共享地址
 *      空间、共享 fd 表、同线程组；
 *   3. 子线程从新栈顶继续执行（clone 返回 0），进入 watcher 死循环：
 *      每 50ms（nanosleep=101）跑一次 tracerpid_poll()；命中即
 *      exit_group(94, 9) 整组自毁——真 .so 的"检测即杀进程"形态；
 *   4. 父路径（clone 返回子 pid > 0）直接返回，业务继续。
 *
 * 反模拟价值（设计要点）：Unicorn/unidbg 这类**顺序模拟器无法忠实
 * 执行 clone 的并发语义**——攻击方只能伪造 clone 返回非 0（父路径），
 * watcher 线程在模拟器里整体不可见、永不执行。也就是说本层在模拟
 * 分析下"凭空消失"，攻击者甚至不会感知到后台检测逻辑的存在
 * （除非静态读代码）——检测面与模拟观测面被结构性错开。
 *
 * 子线程零参数传递：watcher 不需要任何输入（自含轮询 + 自毁），
 * 因此 clone 前无需在新栈上布置参数，规避了寄存器/栈传递的
 * ABI 脆弱点。
 */

#define SYS_mmap       222
#define SYS_clone      220
#define SYS_nanosleep  101
#define SYS_exit_group 94
#define PROT_RW        3                 /* PROT_READ|PROT_WRITE */
#define MAP_PRIV_ANON  0x22              /* MAP_PRIVATE|MAP_ANONYMOUS */
#define THREAD_FLAGS   0x10F00           /* VM|FS|FILES|SIGHAND|THREAD */

static long raw_svc1(long nr, long a0) {
    register long x8 __asm__("x8") = nr;
    register long x0 __asm__("x0") = a0;
    __asm__ volatile("svc #0" : "+r"(x0) : "r"(x8) : "memory");
    return x0;
}

static long raw_svc2(long nr, long a0, long a1) {
    register long x8 __asm__("x8") = nr;
    register long x0 __asm__("x0") = a0;
    register long x1 __asm__("x1") = a1;
    __asm__ volatile("svc #0" : "+r"(x0) : "r"(x8), "r"(x1) : "memory");
    return x0;
}

static long raw_svc5(long nr, long a0, long a1, long a2, long a3, long a4) {
    register long x8 __asm__("x8") = nr;
    register long x0 __asm__("x0") = a0;
    register long x1 __asm__("x1") = a1;
    register long x2 __asm__("x2") = a2;
    register long x3 __asm__("x3") = a3;
    register long x4 __asm__("x4") = a4;
    __asm__ volatile("svc #0" : "+r"(x0) : "r"(x8), "r"(x1), "r"(x2), "r"(x3), "r"(x4) : "memory");
    return x0;
}

static long raw_svc6(long nr, long a0, long a1, long a2, long a3, long a4, long a5) {
    register long x8 __asm__("x8") = nr;
    register long x0 __asm__("x0") = a0;
    register long x1 __asm__("x1") = a1;
    register long x2 __asm__("x2") = a2;
    register long x3 __asm__("x3") = a3;
    register long x4 __asm__("x4") = a4;
    register long x5 __asm__("x5") = a5;
    __asm__ volatile("svc #0" : "+r"(x0) : "r"(x8), "r"(x1), "r"(x2), "r"(x3), "r"(x4), "r"(x5) : "memory");
    return x0;
}

__attribute__((noinline))
static void spawn_watcher(void) {
    /* 子线程栈：64KB 匿名页 */
    long stk = raw_svc6(SYS_mmap, 0, 65536, PROT_RW, MAP_PRIV_ANON, -1, 0);
    if (stk < 0)
        return;                                   /* 无内存：放弃线程化，调用点轮询仍在 */
    long pid = raw_svc5(SYS_clone, THREAD_FLAGS, stk + 65536, 0, 0, 0);
    if (pid != 0)
        return;                                   /* 父路径：业务继续 */
    /* ---- 子线程（watcher）：新栈上运行，周期轮询、命中即自毁 ---- */
    for (;;) {
        if (!tracerpid_poll()) {
            raw_svc1(SYS_exit_group, 9);          /* 整组自毁（真 .so 同款） */
            __builtin_unreachable();
        }
        long ts[2] = { 0, 50 * 1000 * 1000 };     /* 50ms */
        raw_svc2(SYS_nanosleep, (long)ts, 0);
    }
}

__attribute__((noinline))
static void unlock_payload(uintptr_t text_base) {
    /* 文件 VA(0x1000 起) → 运行时地址：基址 + 偏移 */
    uint8_t* dst  = (uint8_t*)(text_base + (PAYLOAD_ADDR - 0x1000));  /* 4 对齐明文位 */
    const uint8_t* src = (const uint8_t*)(text_base + (PAYLOAD_CT - 0x1000)); /* 2 对齐密文槽 */
    uint64_t len  = PAYLOAD_LEN;
    uint8_t  key  = (uint8_t)PAYLOAD_KEY;
    /* 页对齐算出 mprotect 范围（覆盖明文写回页） */
    uintptr_t pg   = (uintptr_t)dst & ~0xFFFULL;
    uint64_t  span = ((uint64_t)(uintptr_t)(dst + len) - pg + 0xFFF) & ~0xFFFULL;
    raw_svc3(226, (long)pg, (long)span, 7 /* PROT_READ|PROT_WRITE|PROT_EXEC */);
    volatile uint32_t OP = 0;                     /* opaque 零值（见 MBA 一节） */
    /* 解密 + 明文写回（密钥与构建期 so_linker 一致）。
     * XOR 走 MBA 恒等式：二进制里是 orr/and/sub/add 网而非一条 eor，
     * 静态分析无法靠"找 XOR 循环"定位解密点。 */
    for (uint64_t i = 0; i < len; i++)
        dst[i] = (uint8_t)mba_xor(src[i], key, &OP);
    /* cache 一致性：按 cache line(64B) 清 D-cache 到统一点、作废 I-cache */
    for (uint8_t* p = (uint8_t*)pg; p < dst + len; p += 64) {
        __asm__ volatile("dc cvau, %0" :: "r"(p));
        __asm__ volatile("ic ivau, %0" :: "r"(p));
    }
    __asm__ volatile("dsb ish" ::: "memory");
    __asm__ volatile("isb" ::: "memory");
}

/* seal_payload：用后重新加密。XOR 对称——对明文区原地再 XOR 一次即恢复
 * 成密文（与槽位内容逐字节一致）。真 .so 的"用完即恢复密文"同款。 */
__attribute__((noinline))
static void seal_payload(uintptr_t text_base) {
    uint8_t* dst = (uint8_t*)(text_base + (PAYLOAD_ADDR - 0x1000));
    uint64_t len = PAYLOAD_LEN;
    uint8_t  key = (uint8_t)PAYLOAD_KEY;
    uintptr_t pg   = (uintptr_t)dst & ~0xFFFULL;
    uint64_t  span = ((uint64_t)(uintptr_t)(dst + len) - pg + 0xFFF) & ~0xFFFULL;
    raw_svc3(226, (long)pg, (long)span, 7);
    volatile uint32_t OP = 0;
    for (uint64_t i = 0; i < len; i++)
        dst[i] = (uint8_t)mba_xor(dst[i], key, &OP);   /* 明文 → 密文（MBA 形态） */
    for (uint8_t* p = (uint8_t*)pg; p < dst + len; p += 64) {
        __asm__ volatile("dc cvau, %0" :: "r"(p));
        __asm__ volatile("ic ivau, %0" :: "r"(p));
    }
    __asm__ volatile("dsb ish" ::: "memory");
    __asm__ volatile("isb" ::: "memory");
}

/* payload：n_b 的真正实现。构建期密文化——objdump/IDA 静态看是垃圾字节。
 * 若攻击者绕过 JNI_OnLoad 直接调 n_b，跳入的是密文，立即崩溃。 */
__attribute__((noinline))
static jstring payload(JNIEnv env) {
    uint8_t buf[L_ver + 1];
    load_ct(buf, C_ver, L_ver);
    return ((NewStringUTF_t)VTBL(env)[SLOT_NewStringUTF])(env, dec_v3(buf, L_ver));
}

/* ================= native 方法实现 ================= */

/* 注册为 a(int, int, long, String, Object) -> Object
 * （与真 .so 的 MS.a 同一签名） */
static jobject n_a(JNIEnv env, jclass thiz, jint p0, jint p1, jlong p2,
                   jstring p3, jobject p4) {
    (void)thiz; (void)p0; (void)p1; (void)p2; (void)p3; (void)p4;
    if (!tracerpid_poll())                /* 轮询点：被调试则拒绝服务 */
        return 0;
    uint8_t buf[L_hello + 1];
    load_ct(buf, C_hello, L_hello);            /* RODATA 形态装载 */
    return ((NewStringUTF_t)VTBL(env)[SLOT_NewStringUTF])(env, dec_v4(buf, L_hello));
}

/* ================= 控制流平坦化（数据驱动分发版） =================
 *
 * 对应真 .so：ctor[0]（0x59294）实测为 O-MVLL 风格的 dispatcher
 * 平坦化——基本块不再按 fall-through 顺序排列，由状态变量驱动跳转；
 * 其升级版（0x59440 形态）连 switch 跳表都没有：每个基本块尾部
 * 用"读偏移表 + 算术 + br xN"直接计算下一块地址（数据驱动分发）。
 *
 * 本实现把 n_b 的 unlock→payload→seal 三段时序打散成**穿线式
 * 状态机**（threaded dispatch）：
 *   - 块地址表 DISP[] 存的是**标签差值**（&&Lx - &&L_BASE，GNU C
 *     计算 goto 扩展）：汇编期解出 int32 偏移，全程零动态重定位，
 *     PIC/ASLR 天然安全——这是源码层表达"计算式间接跳转"且不依赖
 *     链接器支持 ABS64 数据重定位的唯一写法；
 *   - 每个基本块尾部走 DISPATCH()：ldr 偏移 + add + br xN，
 *     二进制里没有跳表基址、没有 cmp 树，只有一张 int32 偏移数组；
 *   - 状态推进不用立即数赋值，全部走 mba_add（二进制里没有
 *     "mov w8, #1" 这种暴露状态链的指令）；
 *   - DISPATCH() 里埋 opaque predicate 死分支（OP 恒 0，(OP&1)!=0
 *     永假），把状态伪装成"直通出口"——反编译器必须证明 OP≡0
 *     才能剪掉这条出边；
 *   - 两个诱饵块（ST_DECOY_A/B）仅被偏移表引用而永远不会进入，
 *     但地址被取使得编译器无法删除——CFG 上多出两个假基本块。
 *
 * 教学提示：真正的基本块物理乱序由 O-MVLL 在编译器后端完成；
 * 源码层面能表达的是同一语义——执行顺序由偏移表数据决定，
 * 而非书写顺序，且每个块尾部都是独立的间接跳转点。
 */
enum { ST_UNLOCK = 0, ST_CALL = 1, ST_SEAL = 2,
       ST_DECOY_A = 3, ST_DECOY_B = 4, ST_DONE = 5 };

/* 注册为 b() -> String */
static jstring n_b(JNIEnv env, jclass thiz) {
    (void)thiz;
    volatile uint32_t OP = 0;
    uintptr_t text_base = (uintptr_t)&n_b & ~0xFFFULL;   /* 与 .text 同页 */
    jstring r = 0;
    uint32_t st = (uint32_t)ST_UNLOCK;

    /* 偏移表：下标即状态，内容是对应基本块相对 L_BASE 的字节偏移 */
    static const int32_t DISP[6] = {
        &&L_UNLOCK  - &&L_BASE,
        &&L_CALL    - &&L_BASE,
        &&L_SEAL    - &&L_BASE,
        &&L_DECOY_A - &&L_BASE,
        &&L_DECOY_B - &&L_BASE,
        &&L_DONE    - &&L_BASE,
    };

    /* 数据驱动分发：真实形态 = ldrsw 偏移 + add + br xN；
     * 死分支把状态伪装成"直通 ST_DONE 出口"（永不到达） */
#define DISPATCH()                                                  \
    do {                                                            \
        if ((OP & 1) != 0)          /* opaque predicate：永假 */    \
            st = (uint32_t)ST_DONE; /* 死分支：伪装成正常出口 */    \
        goto *(&&L_BASE + DISP[st]);                                \
    } while (0)

    DISPATCH();
L_BASE:                               /* 基址锚点 == L_UNLOCK（DISP[0]=0） */
L_UNLOCK:                             /* 按需解密（真 .so 完整形态） */
    unlock_payload(text_base);
    st = mba_add(st, 1, &OP);         /* MBA 推进，无立即数状态链 */
    DISPATCH();
L_CALL:
    if (tracerpid_poll())                 /* 轮询点：干净才放行 payload */
        r = payload(env);                 /* 明文只存在于本块执行期间 */
    st = mba_add(st, 1, &OP);
    DISPATCH();
L_SEAL:                               /* 用后重加密 */
    seal_payload(text_base);
    st = mba_add(st, 3, &OP);         /* 跨过两个 decoy 态 → ST_DONE */
    DISPATCH();
L_DECOY_A:                            /* 诱饵块：看似收尾实则空转 */
    text_base = (uintptr_t)&n_b & ~0xFFFULL;
    st = mba_add(st, 1, &OP);         /* 3 → 4，制造假转移 */
    DISPATCH();
L_DECOY_B:                            /* 诱饵块：伪装成返回路径 */
    st = mba_add(st, 1, &OP);         /* 4 → 5 */
    DISPATCH();
L_DONE:
    return r;
#undef DISPATCH
}

/* ================= JNI_OnLoad：自校验 + 动态注册 ================= */

__attribute__((visibility("default")))
jint JNI_OnLoad(JavaVM vm, void* reserved) {
    (void)reserved;

    /* ---- 第零层：反模拟检查 ----
     * 在 Unicorn 等环境中，svc #0 会使模拟中止（或 NZCV 校验失配），
     * 此分支即返回，后续解密/注册一概不发生。 */
    if (!emu_check())
        return (jint)-1;        /* 真 .so 此处同样走自毁路径 */

    /* ---- 第零点五层：反调试（加载期自检） ----
     * ptrace TRACEME 占坑（一次性）+ TracerPid 首查。
     * 命中即拒绝注册——与真 .so 同策略。 */
    if (!ptrace_selfcheck() || !tracerpid_poll())
        return (jint)-1;
    /* 干净则起后台 watcher 线程：此后 TracerPid 每 50ms 轮询一次，
     * 业务调用间隙无检测空窗；命中即 exit_group 整组自毁。 */
    spawn_watcher();

    /* ---- 第一层：CRC 自校验 ----
     * 取自身地址做 PC 相对定位（真机 ASLR 下同样正确）；
     * .text 由 so_linker.py 放在页首，故页对齐回退即代码段基址。
     * 比较走 MBA XOR（mba_xor(crc,expect)==0 ⟺ 相等）：二进制里没有
     * "cmp crc, 期望常量" 这种直白的校验点形态。 */
    volatile uint32_t OP = 0;
    uintptr_t self = (uintptr_t)&JNI_OnLoad;
    const uint8_t* text_base = (const uint8_t*)(self & ~0xFFFULL);
    if (mba_xor(crc32_self(text_base, CRC_SELF_CHECK_LEN), CRC_EXPECT, &OP) != 0)
        return (jint)-1;        /* 真 .so 此处 bl 0x125D34（自毁） */

    /* 注：payload() 不在此处解密——采用真 .so 的"按需解密、用完重加密"
     * 完整形态，由 n_b() 在每次调用时自行 unlock/seal（见 n_b）。 */

    /* ---- 第三层：取 JNIEnv ---- */
    JNIEnv env = 0;
    if (((GetEnv_t)VTBL(vm)[SLOT_VM_GetEnv])(vm, (void**)&env, JNI_VERSION_1_6) != 0)
        return (jint)-1;

    /* ---- 第四层：解密类名并 FindClass ---- */
    uint8_t cbuf[L_class + 1];
    load_ct(cbuf, C_class, L_class);
    jclass clazz = ((FindClass_t)VTBL(env)[SLOT_FindClass])(env, dec_v4(cbuf, L_class));
    if (!clazz)
        return (jint)-1;

    /* ---- 第五层：构造方法表 ----
     * 短方法名走 IMM 立即数展开（.rodata 无密文），长签名走 RODATA 拷贝；
     * fnPtr 用 &n_a/&n_b，编译为 adrp+add（与真 .so 0x12F90C 一致）。 */
    uint8_t b0n[L_m0name + 1], b0s[L_m0sig + 1];
    uint8_t b1n[L_m1name + 1], b1s[L_m1sig + 1];
    LOAD_C_m0name(b0n);                        /* IMM: 立即数写栈 */
    load_ct(b0s, C_m0sig, L_m0sig);            /* RODATA: 拷贝循环 */
    LOAD_C_m1name(b1n);
    load_ct(b1s, C_m1sig, L_m1sig);

    JNINativeMethod methods[2];
    methods[0].name  = dec_v1(b0n, L_m0name);
    methods[0].sig   = dec_v2(b0s, L_m0sig);
    methods[0].fnPtr = (void*)&n_a;
    methods[1].name  = dec_v3(b1n, L_m1name);
    methods[1].sig   = dec_v5(b1s, L_m1sig);
    methods[1].fnPtr = (void*)&n_b;

    /* ---- 第六层：注册 ---- */
    if (((RegisterNatives_t)VTBL(env)[SLOT_RegisterNatives])(env, clazz, methods, 2) != 0)
        return (jint)-1;
    return JNI_VERSION_1_6;
}
