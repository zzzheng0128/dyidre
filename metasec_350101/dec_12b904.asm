  12b904:      	sub	sp, sp, #0x90
  12b908:      	str	x19, [sp, #0x70]
  12b90c:      	stp	x29, x30, [sp, #0x80]
  12b910:      	add	x29, sp, #0x80
  12b914:      	mrs	x8, TPIDR_EL0
  12b918:      	ldr	x8, [x8, #0x28]
  12b91c:      	stur	x8, [x29, #-0x18]
  12b920:      	str	x0, [sp, #0x38]
  12b924:      	str	w1, [sp, #0x34]
  12b928:      	bl	0x46840 <.text+0x12c20>
  12b92c:      	bl	0x12bf8c <.text+0xf836c>
  12b930:      	bl	0x12bf94 <.text+0xf8374>
  12b934:      	str	x0, [sp, #0x28]
  12b938:      	sub	sp, sp, #0x50
  12b93c:      	stp	x29, x30, [sp, #0x40]
  12b940:      	stp	x0, x1, [sp]
  12b944:      	stp	x2, x3, [sp, #0x10]
  12b948:      	stp	x4, x5, [sp, #0x20]
  12b94c:      	stp	x6, x7, [sp, #0x30]
  12b950:      	bl	0x12b960 <.text+0xf7d40>
  12b954:      	mov	x1, x0
  12b958:      	add	x1, x1, #0x38
  12b95c:      	br	x1
  12b960:      	sub	sp, sp, #0x10
  12b964:      	stp	x29, x30, [sp]
  12b968:      	ldr	x0, [sp, #0x8]
  12b96c:      	ldp	x29, x30, [sp]
  12b970:      	add	sp, sp, #0x10
  12b974:      	ret
  12b978:      	sub	sp, sp, #0x40
  12b97c:      	stp	x29, x30, [sp, #0x30]
  12b980:      	<unknown>
  12b984:      	svc	#0
  12b988:      	add	sp, sp, #0x50
  12b98c:      	ldp	x6, x7, [sp, #0x30]
  12b990:      	ldp	x4, x5, [sp, #0x20]
  12b994:      	ldp	x2, x3, [sp, #0x10]
  12b998:      	ldp	x0, x1, [sp]
  12b99c:      	ldp	x29, x30, [sp, #0x40]
  12b9a0:      	add	sp, sp, #0x50
  12b9a4:      	bl	0x46840 <.text+0x12c20>
  12b9a8:      	bl	0x12bf8c <.text+0xf836c>
  12b9ac:      	bl	0x12bf9c <.text+0xf837c>
  12b9b0:      	str	x0, [sp, #0x20]
  12b9b4:      	ldr	x8, [sp, #0x28]
  12b9b8:      	mov	w9, #0x1                // =1
  12b9bc:      	str	x9, [sp, #0x40]
  12b9c0:      	ldr	x10, [sp, #0x40]
  12b9c4:      	adrp	x11, 0x12b000 <.text+0xf73e0>
  12b9c8:      	add	x11, x11, #0x9f0
  12b9cc:      	mul	x10, x10, x11
  12b9d0:      	str	x9, [sp, #0x40]
  12b9d4:      	ldr	x9, [sp, #0x40]
  12b9d8:      	adrp	x11, 0x12b000 <.text+0xf73e0>
  12b9dc:      	add	x11, x11, #0xd7c
  12b9e0:      	mul	x9, x9, x11
  12b9e4:      	cmp	x8, #0x0
  12b9e8:      	csel	x8, x10, x9, hi
  12b9ec:      	br	x8
  12b9f0:      	ldr	x8, [sp, #0x20]
  12b9f4:      	mov	w9, #0x1                // =1
  12b9f8:      	str	x9, [sp, #0x40]
  12b9fc:      	ldr	x9, [sp, #0x40]
  12ba00:      	adrp	x10, 0x12b000 <.text+0xf73e0>
  12ba04:      	add	x10, x10, #0xa40
  12ba08:      	mul	x9, x9, x10
  12ba0c:      	stur	xzr, [x29, #-0x30]
  12ba10:      	mov	w10, #0x38b             // =907
  12ba14:      	stur	x10, [x29, #-0x38]
  12ba18:      	ldur	x10, [x29, #-0x30]
  12ba1c:      	ldur	x11, [x29, #-0x38]
  12ba20:      	adrp	x12, 0x12b000 <.text+0xf73e0>
  12ba24:      	add	x12, x12, #0xd7c
  12ba28:      	and	x13, x12, x10
  12ba2c:      	eor	x10, x12, x10
  12ba30:      	madd	x10, x13, x11, x10
  12ba34:      	cmp	x8, #0x0
  12ba38:      	csel	x8, x9, x10, hi
  12ba3c:      	br	x8
  12ba40:      	str	xzr, [sp, #0x18]
  12ba44:      	str	xzr, [sp, #0x10]
  12ba48:      	bl	0x1304d4 <.text+0xfc8b4>
  12ba4c:      	str	x0, [sp, #0x18]
  12ba50:      	mov	w8, #0x8                // =8
  12ba54:      	stur	x8, [x29, #-0x28]
  12ba58:      	ldur	x8, [x29, #-0x28]
  12ba5c:      	add	w9, w8, #0x1
  12ba60:      	mul	w8, w8, w9
  12ba64:      	and	x8, x8, #0x1
  12ba68:      	adrp	x9, 0x12b000 <.text+0xf73e0>
  12ba6c:      	add	x9, x9, #0xa78
  12ba70:      	add	x8, x9, x8
  12ba74:      	br	x8
  12ba78:      	ldr	x19, [sp, #0x18]
  12ba7c:      	bl	0x146638 <JNI_OnLoad+0xca88>
  12ba80:      	sxtw	x8, w0
  12ba84:      	mov	w9, #0xd                // =13
  12ba88:      	stur	x9, [x29, #-0x28]
  12ba8c:      	ldur	x9, [x29, #-0x28]
  12ba90:      	add	x10, x9, #0x1
  12ba94:      	add	x11, x9, #0x2
  12ba98:      	mul	x9, x9, x10
  12ba9c:      	mul	x9, x9, x11
  12baa0:      	mov	x10, #-0x5555555555555556 // =-6148914691236517206
  12baa4:      	movk	x10, #0xaaab
  12baa8:      	umulh	x10, x9, x10
  12baac:      	lsr	x10, x10, #1
  12bab0:      	add	x10, x10, x10, lsl #1
  12bab4:      	subs	x9, x9, x10
  12bab8:      	adrp	x10, 0x12b000 <.text+0xf73e0>
  12babc:      	add	x10, x10, #0xaf8
  12bac0:      	add	x9, x10, x9
  12bac4:      	stur	xzr, [x29, #-0x30]
  12bac8:      	mov	w10, #0x99e             // =2462
  12bacc:      	stur	x10, [x29, #-0x38]
  12bad0:      	ldur	x10, [x29, #-0x30]
  12bad4:      	ldur	x11, [x29, #-0x38]
  12bad8:      	adrp	x12, 0x12b000 <.text+0xf73e0>
  12badc:      	add	x12, x12, #0xb14
  12bae0:      	and	x13, x12, x10
  12bae4:      	eor	x10, x12, x10
  12bae8:      	madd	x10, x13, x11, x10
  12baec:      	cmp	x19, x8
  12baf0:      	csel	x8, x9, x10, lo
  12baf4:      	br	x8
  12baf8:      	mov	w8, #0x1                // =1
  12bafc:      	str	x8, [sp, #0x40]
  12bb00:      	ldr	x8, [sp, #0x40]
  12bb04:      	adrp	x9, 0x12b000 <.text+0xf73e0>
  12bb08:      	add	x9, x9, #0xd38
  12bb0c:      	mul	x8, x8, x9
  12bb10:      	br	x8
  12bb14:      	ldr	x8, [sp, #0x18]
  12bb18:      	ldr	x8, [x8, #0x8]
  12bb1c:      	str	x8, [sp, #0x10]
  12bb20:      	ldr	x8, [sp, #0x10]
  12bb24:      	ldr	x9, [sp, #0x28]
  12bb28:      	mov	w10, #0x4               // =4
  12bb2c:      	stur	x10, [x29, #-0x28]
  12bb30:      	ldur	x10, [x29, #-0x28]
  12bb34:      	add	x11, x10, #0x1
  12bb38:      	add	x12, x10, #0x2
  12bb3c:      	mul	x10, x10, x11
  12bb40:      	mul	x10, x10, x12
  12bb44:      	mov	x11, #-0x5555555555555556 // =-6148914691236517206
  12bb48:      	movk	x11, #0xaaab
  12bb4c:      	umulh	x11, x10, x11
  12bb50:      	lsr	x11, x11, #1
  12bb54:      	add	x11, x11, x11, lsl #1
  12bb58:      	subs	x10, x10, x11
  12bb5c:      	adrp	x11, 0x12b000 <.text+0xf73e0>
  12bb60:      	add	x11, x11, #0xb8c
  12bb64:      	add	x10, x11, x10
  12bb68:      	mov	w11, #0x1               // =1
  12bb6c:      	str	x11, [sp, #0x40]
  12bb70:      	ldr	x11, [sp, #0x40]
  12bb74:      	adrp	x12, 0x12b000 <.text+0xf73e0>
  12bb78:      	add	x12, x12, #0xc14
  12bb7c:      	mul	x11, x11, x12
  12bb80:      	cmp	x8, x9
  12bb84:      	csel	x8, x10, x11, hi
  12bb88:      	br	x8
  12bb8c:      	ldr	x8, [sp, #0x10]
  12bb90:      	ldr	x9, [sp, #0x20]
  12bb94:      	mov	w10, #0xc               // =12
  12bb98:      	stur	x10, [x29, #-0x28]
  12bb9c:      	ldur	x10, [x29, #-0x28]
  12bba0:      	add	w11, w10, #0x1
  12bba4:      	mul	w10, w10, w11
  12bba8:      	and	x10, x10, #0x1
  12bbac:      	adrp	x11, 0x12b000 <.text+0xf73e0>
  12bbb0:      	add	x11, x11, #0xbec
  12bbb4:      	add	x10, x11, x10
  12bbb8:      	stur	xzr, [x29, #-0x30]
  12bbbc:      	mov	w11, #0x476             // =1142
  12bbc0:      	stur	x11, [x29, #-0x38]
  12bbc4:      	ldur	x11, [x29, #-0x30]
  12bbc8:      	ldur	x12, [x29, #-0x38]
  12bbcc:      	adrp	x13, 0x12b000 <.text+0xf73e0>
  12bbd0:      	add	x13, x13, #0xc14
  12bbd4:      	and	x14, x13, x11
  12bbd8:      	eor	x11, x13, x11
  12bbdc:      	madd	x11, x14, x12, x11
  12bbe0:      	cmp	x8, x9
  12bbe4:      	csel	x8, x10, x11, lo
  12bbe8:      	br	x8
  12bbec:      	ldr	x0, [sp, #0x10]
  12bbf0:      	bl	0x12bfa4 <.text+0xf8384>
  12bbf4:      	str	x0, [sp, #0x10]
  12bbf8:      	mov	w8, #0x1                // =1
  12bbfc:      	str	x8, [sp, #0x40]
  12bc00:      	ldr	x8, [sp, #0x40]
  12bc04:      	adrp	x9, 0x12b000 <.text+0xf73e0>
  12bc08:      	add	x9, x9, #0xccc
  12bc0c:      	mul	x8, x8, x9
  12bc10:      	br	x8
  12bc14:      	stur	xzr, [x29, #-0x30]
  12bc18:      	mov	w8, #0x5d6              // =1494
  12bc1c:      	stur	x8, [x29, #-0x38]
  12bc20:      	ldur	x8, [x29, #-0x30]
  12bc24:      	ldur	x9, [x29, #-0x38]
  12bc28:      	adrp	x10, 0x12b000 <.text+0xf73e0>
  12bc2c:      	add	x10, x10, #0xc40
  12bc30:      	and	x11, x10, x8
  12bc34:      	eor	x8, x10, x8
  12bc38:      	madd	x8, x11, x9, x8
  12bc3c:      	br	x8
  12bc40:      	mov	w8, #0x7                // =7
  12bc44:      	stur	x8, [x29, #-0x28]
  12bc48:      	ldur	x8, [x29, #-0x28]
  12bc4c:      	add	x9, x8, #0x1
  12bc50:      	add	x10, x8, #0x2
  12bc54:      	mul	x8, x8, x9
  12bc58:      	mul	x8, x8, x10
  12bc5c:      	mov	x9, #-0x5555555555555556 // =-6148914691236517206
  12bc60:      	movk	x9, #0xaaab
  12bc64:      	umulh	x9, x8, x9
  12bc68:      	lsr	x9, x9, #1
  12bc6c:      	add	x9, x9, x9, lsl #1
  12bc70:      	subs	x8, x8, x9
  12bc74:      	adrp	x9, 0x12b000 <.text+0xf73e0>
