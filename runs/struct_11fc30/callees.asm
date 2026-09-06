=== 10e914 at line 224377 ===
  10e914:      	ldr	x0, [x0]
  10e918:      	b	0x10f2e0 <.text+0xdb6c0>
  10e91c:      	b	0x330c0 <malloc@plt>
  10e920:      	b	0x33330 <free@plt>
  10e924:      	stp	x0, x1, [x8]
  10e928:      	str	w2, [x8, #0x10]
  10e92c:      	ret
=== 10e824 at line 224317 ===
  10e824:      	ldr	x0, [x0]
  10e828:      	b	0x10ec94 <.text+0xdb074>
  10e82c:      	ldr	x0, [x0]
  10e830:      	b	0x10eca4 <.text+0xdb084>
  10e834:      	sub	sp, sp, #0x60
  10e838:      	stp	x22, x21, [sp, #0x30]
  10e83c:      	stp	x20, x19, [sp, #0x40]
  10e840:      	stp	x29, x30, [sp, #0x50]
  10e844:      	add	x29, sp, #0x50
  10e848:      	mrs	x22, TPIDR_EL0
  10e84c:      	ldr	x8, [x22, #0x28]
  10e850:      	mov	x19, x1
  10e854:      	mov	x20, x0
  10e858:      	str	x8, [sp, #0x28]
  10e85c:      	bl	0x10e8f4 <.text+0xdacd4>
  10e860:      	mov	x21, x0
  10e864:      	stp	x0, x1, [sp, #0x18]
  10e868:      	mov	x0, x20
  10e86c:      	bl	0x10e824 <.text+0xdac04>
  10e870:      	stp	x0, x1, [sp, #0x8]
  10e874:      	ldr	x8, [x21, #0x58]
  10e878:      	add	x0, sp, #0x18
  10e87c:      	add	x1, sp, #0x8
  10e880:      	blr	x8
  10e884:      	cbz	w0, 0x10e890 <.text+0xdac70>
  10e888:      	mov	x0, xzr
  10e88c:      	b	0x10e8cc <.text+0xdacac>
  10e890:      	ldr	x8, [x20]
  10e894:      	ldr	x9, [sp, #0x18]
  10e898:      	add	x0, sp, #0x18
  10e89c:      	ldr	x20, [x8, #0x10]
  10e8a0:      	ldr	x8, [x9, #0x8]
  10e8a4:      	blr	x8
  10e8a8:      	ldr	x1, [x0]
  10e8ac:      	mov	x0, x19
  10e8b0:      	blr	x20
  10e8b4:      	tbnz	w0, #0x1f, 0x10e888 <.text+0xdac68>
  10e8b8:      	ldr	x8, [sp, #0x18]
  10e8bc:      	add	x0, sp, #0x18
  10e8c0:      	ldr	x8, [x8, #0x8]
  10e8c4:      	blr	x8
  10e8c8:      	ldr	x0, [x0, #0x8]
  10e8cc:      	ldr	x8, [x22, #0x28]
  10e8d0:      	ldr	x9, [sp, #0x28]
  10e8d4:      	cmp	x8, x9
  10e8d8:      	b.ne	0x10e8f0 <.text+0xdacd0>
  10e8dc:      	ldp	x29, x30, [sp, #0x50]
  10e8e0:      	ldp	x20, x19, [sp, #0x40]
  10e8e4:      	ldp	x22, x21, [sp, #0x30]
  10e8e8:      	add	sp, sp, #0x60
  10e8ec:      	ret
=== 10e8fc at line 224371 ===
  10e8fc:      	ldr	x0, [x0]
  10e900:      	b	0x10ecac <.text+0xdb08c>
  10e904:      	ldr	x0, [x0]
  10e908:      	b	0x10ef3c <.text+0xdb31c>
  10e90c:      	ldr	x0, [x0]
  10e910:      	b	0x10ec0c <.text+0xdafec>
  10e914:      	ldr	x0, [x0]
  10e918:      	b	0x10f2e0 <.text+0xdb6c0>
  10e91c:      	b	0x330c0 <malloc@plt>
  10e920:      	b	0x33330 <free@plt>
  10e924:      	stp	x0, x1, [x8]
  10e928:      	str	w2, [x8, #0x10]
  10e92c:      	ret
=== 11fbdc at line 241963 ===
  11fbdc:      	stp	x20, x19, [sp, #-0x20]!
  11fbe0:      	stp	x29, x30, [sp, #0x10]
  11fbe4:      	add	x29, sp, #0x10
  11fbe8:      	mov	x20, x0
  11fbec:      	mov	w0, #0x10               // =16
  11fbf0:      	mov	x19, x1
  11fbf4:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  11fbf8:      	ldp	x29, x30, [sp, #0x10]
  11fbfc:      	stp	x20, x19, [x0]
  11fc00:      	ldp	x20, x19, [sp], #0x20
  11fc04:      	ret
