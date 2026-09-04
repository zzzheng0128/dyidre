# F3/F4/F6/F9/F10/F11/F14 managed program recovery

The program descriptors were dumped after `JNI_OnLoad` using the existing
unidbg `metasec.dumpManagedPrograms` probe. Every previously missing export is
`kind=1`, i.e. an inline managed-bytecode body rather than a `kind=3` native
callback.

| Program | records | status |
|---|---:|---|
| F3 | 26 | all decoded; small byte mixer |
| F4 | 17 | all decoded; nibble/bit helper |
| F6 | 25 | all decoded; two native-binding calls |
| F9 | 10,821 | bytecode recovered; 21 records across 8 new opcode values remain unclassified |
| F10 | 102 | 8 records of new opcode `0x66` remain unclassified |
| F11 | 984 | one record of new opcode `0x5c` remains unclassified |
| F14 | 517 | all decoded; CF-heavy managed helper |

Evidence source: `unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/summary.md`.
The matching `*.decoded.asm` and `*.linear.c` files are bytecode-level lifts;
the execution framework is in `../managed_vm_runtime_350101/`.
