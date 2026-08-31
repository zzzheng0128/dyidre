# Generic VM Reverse Engineering Playbook

This playbook provides a reusable workflow for analysing custom virtual machines (VMs) embedded inside native binaries. It focuses on the methodology and tooling patterns rather than sample-specific details, so it can be applied to unfamiliar VM implementations encountered in malware, protectors, or DRM systems.

---

## 1. Reconnaissance and Triage

1. **Identify VM presence.** Look for large jump tables, bytecode blobs, or routines that manipulate obfuscated opcode streams.
2. **Locate bytecode storage.** Common locations include embedded arrays inside shared objects, compressed resources, or decrypted segments at runtime. Extract candidate regions for later decoding.
3. **Map interpreter entry points.** Find dispatcher loops that repeatedly fetch an instruction, switch on an opcode, and manipulate a VM state (register set, stack, memory window).
4. **Capture runtime context.** Record register usage, stack layout, and any ancillary data structures (e.g., external call tables, constant pools). Tools: IDA, Ghidra, Binary Ninja, dynamic tracing.

---

## 2. Opcode Schema Discovery

1. **Understand instruction fetch.** Determine word size (e.g., 32-bit, 64-bit) and endianness. Note how opcodes are read (direct pointer, decrypted stream, compressed bits).
2. **Reverse dispatcher.** The interpreter typically masks or shifts parts of the opcode to obtain `op1`, `op2`, or other fields. Document these bit extractions carefully.
3. **Extract register/operand encodings.** Observe how the interpreter retrieves source/destination registers, immediate values, or flags. Sketch helper formulas like `_extract_fields()` or `_immXX()` functions for future automation.
4. **Group opcode families.** Many VMs separate opcodes into primary categories (e.g., memory, arithmetic, flow control) with sub-opcodes handled inside nested switches. Catalogue these families as the foundation for scripting.

---

## 3. Tooling Setup

1. **Build a lightweight decoder scaffold.**
   - Language: Python is convenient for rapid iteration.
   - Components: register name tables, immediate decoding helpers, statistics collector, pretty-printer for assembly-like output.
2. **Automate bytecode extraction.** Embed logic or command-line parameters to specify start offsets and lengths. Allow custom ranges so new bytecode blocks can be explored without editing code.
3. **Integrate stats reporting.** Track which opcodes are recognised; highlight unknown `op1`/`op2` combinations to drive further analysis.
4. **Version control.** Keep the decoder under git to manage incremental insights and share with teammates.

---

## 4. Iterative Opcode Recovery Process

1. **Initial pass.** Run the decoder with minimal handlers (e.g., `UNKN` for all). Collect histogram of opcode values to prioritise work.
2. **Interpreter cross-reference.** For each new opcode, examine the corresponding branch in the interpreter to infer semantics. Translate behaviour into pseudo-assembly.
3. **Implement handler.** Add a decoding function that formats operands, updates statistics, and optionally adds clarifying comments for complex cases.
4. **Regression check.** Re-run decoder over all known bytecode blobs. Ensure previously decoded instructions remain stable and unknown lists shrink.
5. **Documentation cadence.** Maintain a change log of newly decoded opcodes and their semantics. Optional: keep a markdown ledger or structured JSON for cross-team sharing.

---

## 5. Validation Strategies

1. **Cross-run consistency.** When multiple bytecode blobs exist, confirm common opcode values map to identical semantics.
2. **Runtime verification.** If possible, instrument the interpreter (e.g., with Frida, DynamoRIO) to log actual register/memory effects and compare with decoded output.
3. **Round-trip tests.** For mature projects, write an emulator or translator and execute known inputs to ensure decoded behaviour matches original program output.
4. **Statistical coverage.** Aim for zero unknown opcodes in all analysed bytecode regions before declaring completion.

---

## 6. Knowledge Transfer Checklist

- Record:
  - Opcode extraction formulas (bit masks/shifts).
  - Register file layout and width distinctions (32 vs 64-bit registers, floating-point sets, special purpose registers).
  - Immediate encoding rules, including sign extension and scaling.
  - Special behaviours (conditional execution, call trampolines, VM exits).
- Store supporting scripts, command invocations, and interpreter annotations in a shared repository.
- Create template handler implementations for common instruction classes (ALU, load/store, branch) to accelerate onboarding for new analysts.

---

## 7. Advanced Enhancements

- **Dynamic instrumentation:** Build tooling to trace opcode execution live, producing ground-truth logs.
- **Deobfuscation pipelines:** Automate extraction of encrypted bytecode by hooking the loader or dumping memory after decryption.
- **Semantic lifting:** Convert decoded VM instructions into intermediate representations (e.g., LLVM IR) for deeper analysis or decompilation.
- **Test harnesses:** Implement unit tests per opcode to ensure decoders/emulators remain correct as they evolve.

---

## 8. Suggested Toolkit

- Disassemblers: IDA Pro, Ghidra, Binary Ninja.
- Scripting: Python (struct, argparse, dataclasses), Capstone/Keystone for ARM64 references.
- Dynamic tools: Frida, Unicorn Engine, Qiling, Pin/DynamoRIO.
- Version control: Git + markdown documentation.
- Automation hints: Use PowerShell or Bash scripts to orchestrate decoder runs over multiple bytecode regions.

---

## 9. Quick Reference Commands

```powershell
# Run generic decoder against a new range
python vm_decoder.py --start <offset> --size <bytes> --out-dir output_dir

# Triage unknown opcodes after a run
Select-String -Path output_dir\*.asm -Pattern "UNKN"

# Evaluate immediate decoding for a suspicious opcode
python -c "from vm_decoder import VMDecoder; print(hex(VMDecoder._imm16(0xDEADBEEF)))"
```

Modify these commands to match your project (executable name, language choice, etc.).

---

## 10. Summary

By following this playbook—discover dispatcher logic, scaffold a decoder, iterate with interpreter references, and continually validate—you can rapidly dissect unfamiliar virtual machines. The key is systematic documentation of decoding rules, automated tooling for feedback, and disciplined expansion of opcode coverage.
