# CF57 `strtoull` binding — 350.101

The wrapper at `0x16F890` is a direct ABI adapter:

```asm
slot4 -> X0  ; const char *nptr
slot5 -> X1  ; char **endptr
slot6 -> X2  ; int base
bl strtoull@plt
X0 -> managedFrameSetSlot_350(frame, 2, X0)
```

The standalone runtime therefore requires raw mapped NUL-terminated bytes in
slot4.  It implements whitespace/sign/base handling, the optional raw endptr
write, unsigned 64-bit wrap for a negative successful conversion, and native
`strtoull` overflow saturation to `UINT64_MAX`.  Invalid bases stay explicit
runtime errors instead of being silently coerced by Python parsing.
