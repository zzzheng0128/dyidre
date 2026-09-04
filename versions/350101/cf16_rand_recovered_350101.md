# CF16 random-value binding — 350.101

`CF16` is the native managed binding at `+0x16EE94`.  It is not a global
singleton accessor as an earlier trace-only label suggested.

## Static proof

The wrapper has no data arguments other than `X0=ManagedFrame350 *frame`:

```asm
16EE94  mov x19, x0
16EE9C  bl  0x12E0C8
16EEA0  mov w2, w0
16EEA4  mov x0, x19
16EEA8  mov w1, #2
16EEAC  bl  0x1547D4 ; managedFrameSetSlot_350(frame, 2, value)
```

`0x12E0C8` tests byte `+0x2C4440` bit 0.  Before the first use it derives a
seed through `0x133F90`, calls `srand(seed)`, marks the guard, and then calls
`rand@plt`; the normal path directly calls `rand@plt`.  Its `W0` return is
therefore a native C-library random value in the 31-bit `RAND_MAX` range.

## Standalone-runtime contract

`CfRegistry350(..., random_u31_provider=...)` implements CF16 and stores
`provider() & 0x7fffffff` into slot 2.  The provider is injectable because
the native seed is process-local and has not been traced; a default provider
uses a fresh 31-bit host value.  This gives executable control/data-flow
semantics without falsely presenting a host PRNG sequence as a device oracle.
