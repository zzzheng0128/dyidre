=== 10f2e0 at line 225004 ===
  10f2e0:      	sub	sp, sp, #0x90
  10f2e4:      	stp	x28, x27, [sp, #0x30]
  10f2e8:      	stp	x26, x25, [sp, #0x40]
  10f2ec:      	stp	x24, x23, [sp, #0x50]
  10f2f0:      	stp	x22, x21, [sp, #0x60]
  10f2f4:      	stp	x20, x19, [sp, #0x70]
  10f2f8:      	stp	x29, x30, [sp, #0x80]
  10f2fc:      	add	x29, sp, #0x80
  10f300:      	mrs	x22, TPIDR_EL0
  10f304:      	ldr	x8, [x22, #0x28]
  10f308:      	mov	x21, x0
  10f30c:      	adrp	x25, 0x27d000
  10f310:      	mov	x19, x1
  10f314:      	str	x8, [sp, #0x28]
  10f318:      	ldr	x24, [x21], #0x18
  10f31c:      	add	x8, sp, #0x8
  10f320:      	mov	x20, x0
  10f324:      	add	x25, x25, #0xf80
  10f328:      	ldr	x26, [x24, #0x8]
  10f32c:      	add	x8, x8, #0x8
  10f330:      	mov	w27, #0x18              // =24
  10f334:      	mov	w28, #0x10              // =16
  10f338:      	stp	x25, x24, [sp, #0x8]
  10f33c:      	str	x8, [sp]
  10f340:      	cbz	x26, 0x10f370 <.text+0xdb750>
  10f344:      	ldp	x23, x8, [x20, #0x10]
  10f348:      	ldr	x1, [x26, #0x20]
  10f34c:      	mov	x0, x21
  10f350:      	blr	x8
  10f354:      	mov	x1, x19
  10f358:      	blr	x23
  10f35c:      	cmp	w0, #0x0
  10f360:      	csel	x8, x28, x27, ge
  10f364:      	csel	x24, x26, x24, ge
  10f368:      	ldr	x26, [x26, x8]
  10f36c:      	cbnz	x26, 0x10f344 <.text+0xdb724>
  10f370:      	ldr	x8, [x25, #0x58]
  10f374:      	add	x0, sp, #0x18
  10f378:      	add	x1, sp, #0x8
  10f37c:      	stp	x25, x24, [sp, #0x18]
  10f380:      	add	x24, sp, #0x18
  10f384:      	blr	x8
  10f388:      	cbz	w0, 0x10f398 <.text+0xdb778>
  10f38c:      	ldr	x9, [sp]
  10f390:      	add	x8, sp, #0x8
  10f394:      	b	0x10f3c4 <.text+0xdb7a4>
  10f398:      	ldr	x8, [sp, #0x20]
  10f39c:      	ldp	x23, x9, [x20, #0x10]
  10f3a0:      	mov	x0, x21
  10f3a4:      	ldr	x1, [x8, #0x20]
  10f3a8:      	blr	x9
  10f3ac:      	mov	x1, x0
  10f3b0:      	mov	x0, x19
  10f3b4:      	blr	x23
  10f3b8:      	tbnz	w0, #0x1f, 0x10f38c <.text+0xdb76c>
  10f3bc:      	add	x9, x24, #0x8
  10f3c0:      	add	x8, sp, #0x18
  10f3c4:      	ldr	x1, [x9]
  10f3c8:      	ldr	x0, [x8]
  10f3cc:      	ldr	x8, [x22, #0x28]
  10f3d0:      	ldr	x9, [sp, #0x28]
  10f3d4:      	cmp	x8, x9
  10f3d8:      	b.ne	0x10f3fc <.text+0xdb7dc>
  10f3dc:      	ldp	x29, x30, [sp, #0x80]
  10f3e0:      	ldp	x20, x19, [sp, #0x70]
  10f3e4:      	ldp	x22, x21, [sp, #0x60]
  10f3e8:      	ldp	x24, x23, [sp, #0x50]
  10f3ec:      	ldp	x26, x25, [sp, #0x40]
  10f3f0:      	ldp	x28, x27, [sp, #0x30]
  10f3f4:      	add	sp, sp, #0x90
  10f3f8:      	ret
  10f3fc:      	bl	0x33100 <__stack_chk_fail@plt>
  10f400:      	stp	x24, x23, [sp, #-0x40]!
  10f404:      	stp	x22, x21, [sp, #0x10]
  10f408:      	stp	x20, x19, [sp, #0x20]
  10f40c:      	stp	x29, x30, [sp, #0x30]
  10f410:      	add	x29, sp, #0x30
  10f414:      	mov	x22, x0
  10f418:      	ldr	x19, [x22], #0x18
  10f41c:      	mov	x20, x1
=== 10ec94 at line 224601 ===
  10ec94:      	ldr	x1, [x0]
  10ec98:      	adrp	x0, 0x27d000
  10ec9c:      	add	x0, x0, #0xf80
  10eca0:      	ret
  10eca4:      	ldr	x0, [x0, #0x8]
  10eca8:      	ret
  10ecac:      	sub	sp, sp, #0x90
  10ecb0:      	stp	x28, x27, [sp, #0x30]
  10ecb4:      	stp	x26, x25, [sp, #0x40]
  10ecb8:      	stp	x24, x23, [sp, #0x50]
  10ecbc:      	stp	x22, x21, [sp, #0x60]
  10ecc0:      	stp	x20, x19, [sp, #0x70]
  10ecc4:      	stp	x29, x30, [sp, #0x80]
  10ecc8:      	add	x29, sp, #0x80
  10eccc:      	mrs	x25, TPIDR_EL0
  10ecd0:      	mov	x19, x8
  10ecd4:      	ldr	x8, [x25, #0x28]
  10ecd8:      	mov	x22, x0
  10ecdc:      	mov	x20, x1
  10ece0:      	mov	x21, x0
  10ece4:      	str	x8, [sp, #0x28]
  10ece8:      	ldr	x23, [x22], #0x18
  10ecec:      	mov	w8, #0x1                // =1
  10ecf0:      	mov	w24, #0x18              // =24
  10ecf4:      	mov	w26, #0x10              // =16
  10ecf8:      	ldr	x9, [x23, #0x8]
  10ecfc:      	cbz	x9, 0x10ed4c <.text+0xdb12c>
  10ed00:      	ldp	x28, x8, [x21, #0x10]
  10ed04:      	mov	x0, x22
  10ed08:      	mov	x1, x20
  10ed0c:      	mov	x27, x9
  10ed10:      	blr	x8
  10ed14:      	ldr	x8, [x21, #0x18]
  10ed18:      	ldr	x1, [x27, #0x20]
  10ed1c:      	mov	x23, x0
  10ed20:      	mov	x0, x22
  10ed24:      	blr	x8
  10ed28:      	mov	x1, x0
  10ed2c:      	mov	x0, x23
  10ed30:      	blr	x28
  10ed34:      	cmp	w0, #0x0
  10ed38:      	csel	x8, x26, x24, lt
  10ed3c:      	ldr	x9, [x27, x8]
  10ed40:      	lsr	w8, w0, #31
  10ed44:      	mov	x23, x27
  10ed48:      	cbnz	x9, 0x10ed00 <.text+0xdb0e0>
  10ed4c:      	adrp	x9, 0x27d000
  10ed50:      	add	x9, x9, #0xf80
  10ed54:      	mov	x10, x23
  10ed58:      	stp	x9, x23, [sp, #0x18]
  10ed5c:      	cbz	w8, 0x10ed94 <.text+0xdb174>
  10ed60:      	ldr	x8, [x21]
  10ed64:      	ldr	x10, [x9, #0x58]
  10ed68:      	add	x0, sp, #0x18
  10ed6c:      	add	x1, sp, #0x8
  10ed70:      	ldr	x8, [x8, #0x10]
  10ed74:      	stp	x9, x8, [sp, #0x8]
  10ed78:      	blr	x10
  10ed7c:      	cbnz	w0, 0x10edd8 <.text+0xdb1b8>
  10ed80:      	ldr	x8, [sp, #0x18]
  10ed84:      	add	x0, sp, #0x18
  10ed88:      	ldr	x8, [x8, #0x28]
  10ed8c:      	blr	x8
  10ed90:      	ldr	x10, [sp, #0x20]
  10ed94:      	ldp	x26, x8, [x21, #0x10]
  10ed98:      	ldr	x1, [x10, #0x20]
  10ed9c:      	mov	x0, x22
  10eda0:      	blr	x8
  10eda4:      	ldr	x8, [x21, #0x18]
  10eda8:      	mov	x24, x0
  10edac:      	mov	x0, x22
  10edb0:      	mov	x1, x20
  10edb4:      	blr	x8
  10edb8:      	mov	x1, x0
  10edbc:      	mov	x0, x24
  10edc0:      	blr	x26
  10edc4:      	tbnz	w0, #0x1f, 0x10edd8 <.text+0xdb1b8>
  10edc8:      	ldp	x0, x1, [sp, #0x18]
  10edcc:      	mov	x8, x19
  10edd0:      	mov	w2, wzr
=== 10ecac at line 224607 ===
  10ecac:      	sub	sp, sp, #0x90
  10ecb0:      	stp	x28, x27, [sp, #0x30]
  10ecb4:      	stp	x26, x25, [sp, #0x40]
  10ecb8:      	stp	x24, x23, [sp, #0x50]
  10ecbc:      	stp	x22, x21, [sp, #0x60]
  10ecc0:      	stp	x20, x19, [sp, #0x70]
  10ecc4:      	stp	x29, x30, [sp, #0x80]
  10ecc8:      	add	x29, sp, #0x80
  10eccc:      	mrs	x25, TPIDR_EL0
  10ecd0:      	mov	x19, x8
  10ecd4:      	ldr	x8, [x25, #0x28]
  10ecd8:      	mov	x22, x0
  10ecdc:      	mov	x20, x1
  10ece0:      	mov	x21, x0
  10ece4:      	str	x8, [sp, #0x28]
  10ece8:      	ldr	x23, [x22], #0x18
  10ecec:      	mov	w8, #0x1                // =1
  10ecf0:      	mov	w24, #0x18              // =24
  10ecf4:      	mov	w26, #0x10              // =16
  10ecf8:      	ldr	x9, [x23, #0x8]
  10ecfc:      	cbz	x9, 0x10ed4c <.text+0xdb12c>
  10ed00:      	ldp	x28, x8, [x21, #0x10]
  10ed04:      	mov	x0, x22
  10ed08:      	mov	x1, x20
  10ed0c:      	mov	x27, x9
  10ed10:      	blr	x8
  10ed14:      	ldr	x8, [x21, #0x18]
  10ed18:      	ldr	x1, [x27, #0x20]
  10ed1c:      	mov	x23, x0
  10ed20:      	mov	x0, x22
  10ed24:      	blr	x8
  10ed28:      	mov	x1, x0
  10ed2c:      	mov	x0, x23
  10ed30:      	blr	x28
  10ed34:      	cmp	w0, #0x0
  10ed38:      	csel	x8, x26, x24, lt
  10ed3c:      	ldr	x9, [x27, x8]
  10ed40:      	lsr	w8, w0, #31
  10ed44:      	mov	x23, x27
  10ed48:      	cbnz	x9, 0x10ed00 <.text+0xdb0e0>
  10ed4c:      	adrp	x9, 0x27d000
  10ed50:      	add	x9, x9, #0xf80
  10ed54:      	mov	x10, x23
  10ed58:      	stp	x9, x23, [sp, #0x18]
  10ed5c:      	cbz	w8, 0x10ed94 <.text+0xdb174>
  10ed60:      	ldr	x8, [x21]
  10ed64:      	ldr	x10, [x9, #0x58]
  10ed68:      	add	x0, sp, #0x18
  10ed6c:      	add	x1, sp, #0x8
  10ed70:      	ldr	x8, [x8, #0x10]
  10ed74:      	stp	x9, x8, [sp, #0x8]
  10ed78:      	blr	x10
  10ed7c:      	cbnz	w0, 0x10edd8 <.text+0xdb1b8>
  10ed80:      	ldr	x8, [sp, #0x18]
  10ed84:      	add	x0, sp, #0x18
  10ed88:      	ldr	x8, [x8, #0x28]
  10ed8c:      	blr	x8
  10ed90:      	ldr	x10, [sp, #0x20]
  10ed94:      	ldp	x26, x8, [x21, #0x10]
  10ed98:      	ldr	x1, [x10, #0x20]
  10ed9c:      	mov	x0, x22
  10eda0:      	blr	x8
  10eda4:      	ldr	x8, [x21, #0x18]
  10eda8:      	mov	x24, x0
  10edac:      	mov	x0, x22
  10edb0:      	mov	x1, x20
  10edb4:      	blr	x8
  10edb8:      	mov	x1, x0
  10edbc:      	mov	x0, x24
  10edc0:      	blr	x26
  10edc4:      	tbnz	w0, #0x1f, 0x10edd8 <.text+0xdb1b8>
  10edc8:      	ldp	x0, x1, [sp, #0x18]
  10edcc:      	mov	x8, x19
  10edd0:      	mov	w2, wzr
  10edd4:      	b	0x10edf4 <.text+0xdb1d4>
  10edd8:      	mov	x0, x21
  10eddc:      	mov	x1, xzr
  10ede0:      	mov	x2, x23
  10ede4:      	mov	x3, x20
  10ede8:      	bl	0x10ee2c <.text+0xdb20c>
