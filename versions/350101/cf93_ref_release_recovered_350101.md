# CF93 shared-reference release — 350.101

`CF93` at `0x170078` loads `slot4` and calls `0x479EC`; it then returns
directly, with no `managedFrameSetSlot_350` call.  `0x479EC` locks the pair
and invokes `0x4AE8C`, which decrements the control block, destroys the object
when the count reaches zero, and clears both pointer words.  The standalone
model therefore clears `Ref.value` and deliberately leaves slot2 unchanged.
