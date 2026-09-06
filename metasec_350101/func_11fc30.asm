  11fc30:      	sub	sp, sp, #0x80
  11fc34:      	stp	x24, x23, [sp, #0x40]
  11fc38:      	stp	x22, x21, [sp, #0x50]
  11fc3c:      	stp	x20, x19, [sp, #0x60]
  11fc40:      	stp	x29, x30, [sp, #0x70]
  11fc44:      	add	x29, sp, #0x70
  11fc48:      	mrs	x24, TPIDR_EL0
  11fc4c:      	ldr	x8, [x24, #0x28]
  11fc50:      	add	x22, x0, #0x20
  11fc54:      	mov	x21, x0
  11fc58:      	mov	x0, x22
  11fc5c:      	mov	x19, x2
  11fc60:      	mov	x20, x1
  11fc64:      	str	x8, [sp, #0x38]
  11fc68:      	bl	0x10e914 <.text+0xdacf4>
  11fc6c:      	mov	x23, x0
  11fc70:      	stp	x0, x1, [sp, #0x28]
  11fc74:      	mov	x0, x22
  11fc78:      	bl	0x10e824 <.text+0xdac04>
  11fc7c:      	stp	x0, x1, [sp, #0x18]
  11fc80:      	ldr	x8, [x23, #0x58]
  11fc84:      	add	x0, sp, #0x28
  11fc88:      	add	x1, sp, #0x18
  11fc8c:      	blr	x8
  11fc90:      	cbz	w0, 0x11fcb4 <.text+0xec094>
  11fc94:      	mov	x0, x20
  11fc98:      	mov	x1, x19
  11fc9c:      	bl	0x11fbdc <.text+0xebfbc>
  11fca0:      	mov	x1, x0
  11fca4:      	mov	x8, sp
  11fca8:      	mov	x0, x22
  11fcac:      	bl	0x10e8fc <.text+0xdacdc>
  11fcb0:      	b	0x11fce4 <.text+0xec0c4>
  11fcb4:      	ldr	x8, [sp, #0x28]
  11fcb8:      	add	x0, sp, #0x28
  11fcbc:      	ldr	x8, [x8, #0x8]
  11fcc0:      	blr	x8
  11fcc4:      	ldr	x8, [x21, #0x8]
  11fcc8:      	mov	x22, x0
  11fccc:      	mov	x0, x20
  11fcd0:      	blr	x8
  11fcd4:      	ldr	x8, [x21, #0x10]
  11fcd8:      	ldr	x0, [x22, #0x8]
  11fcdc:      	blr	x8
  11fce0:      	str	x19, [x22, #0x8]
  11fce4:      	ldr	x8, [x24, #0x28]
  11fce8:      	ldr	x9, [sp, #0x38]
  11fcec:      	cmp	x8, x9
  11fcf0:      	b.ne	0x11fd0c <.text+0xec0ec>
  11fcf4:      	ldp	x29, x30, [sp, #0x70]
  11fcf8:      	ldp	x20, x19, [sp, #0x60]
  11fcfc:      	ldp	x22, x21, [sp, #0x50]
  11fd00:      	ldp	x24, x23, [sp, #0x40]
  11fd04:      	add	sp, sp, #0x80
  11fd08:      	ret
