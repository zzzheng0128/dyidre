=== call site (line 19964) ===
   46e9c:      	mov	w1, w24
   46ea0:      	bl	0x123f40 <.text+0xf0320>
   46ea4:      	ldr	x0, [sp, #0xb0]
   46ea8:      	add	w24, w24, #0x1
   46eac:      	add	x8, sp, #0xf0
   46eb0:      	mov	w1, w24
   46eb4:      	bl	0x123f40 <.text+0xf0320>
   46eb8:      	ldur	x25, [x29, #-0x78]
   46ebc:      	cbz	x25, 0x46f04 <.text+0x132e4>
   46ec0:      	ldr	x8, [sp, #0xf0]
   46ec4:      	cbz	x8, 0x46f04 <.text+0x132e4>
   46ec8:      	ldur	x26, [x29, #-0xc0]
   46ecc:      	mov	w0, #0x18               // =24
   46ed0:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   46ed4:      	mov	x1, x25
   46ed8:      	mov	x27, x0
   46edc:      	bl	0x10b68c <.text+0xd7a6c>
   46ee0:      	mov	w0, #0x18               // =24
   46ee4:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   46ee8:      	ldr	x1, [sp, #0xf0]
   46eec:      	mov	x25, x0
   46ef0:      	bl	0x10b68c <.text+0xd7a6c>
   46ef4:      	mov	x0, x26
   46ef8:      	mov	x1, x27
   46efc:      	mov	x2, x25
   46f00:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 37321) ===
   57dd0:      	mov	w0, #0x3                // =3
   57dd4:      	bl	0x1c2f40 <JNI_OnLoad+0x89390>
   57dd8:      	mov	w8, #0x6295             // =25237
   57ddc:      	mov	w9, #0x78               // =120
   57de0:      	mov	w1, #0x3                // =3
   57de4:      	strh	w8, [x0]
   57de8:      	strb	w9, [x0, #0x2]
   57dec:      	bl	0x12c9a4 <.text+0xf8d84>
   57df0:      	ldr	x8, [x27, #0xfd8]
   57df4:      	cbnz	x8, 0x57dfc <.text+0x241dc>
   57df8:      	str	x0, [x27, #0xfd8]
   57dfc:      	ldr	x1, [x27, #0xfd8]
   57e00:      	add	x0, sp, #0x50
   57e04:      	bl	0x10b5f0 <.text+0xd79d0>
   57e08:      	add	x1, sp, #0x50
   57e0c:      	mov	x0, x25
   57e10:      	bl	0x1198c0 <.text+0xe5ca0>
   57e14:      	add	x0, sp, #0x50
   57e18:      	bl	0x10b764 <.text+0xd7b44>
   57e1c:      	add	x0, sp, #0x50
   57e20:      	mov	x1, x22
   57e24:      	bl	0x12ab04 <.text+0xf6ee4>
   57e28:      	mov	x0, x24
   57e2c:      	mov	x1, x21
   57e30:      	mov	x2, x23
   57e34:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 53062) ===
   673c4:      	<unknown>
   673c8:      	uaddwt	z29.d, z19.d, z31.s
   673cc:      	add	sp, sp, #0xd41
   673d0:      	<unknown>
   673d4:      	ldff1b	{ z20.b }, p7/z, [x7, x22]
   673d8:      	<unknown>
   673dc:      	cmphi	p14.d, p0/z, z0.d, #0x22
   673e0:      	<unknown>
   673e4:      	ldrh	w28, [x22]
   673e8:      	ldur	w25, [x22, #0x2]
   673ec:      	ldur	w21, [x22, #0x6]
   673f0:      	mov	w0, #0x18               // =24
   673f4:      	add	x22, x22, #0xa
   673f8:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   673fc:      	mov	x1, x22
   67400:      	mov	w2, w21
   67404:      	mov	x23, x0
   67408:      	bl	0x10b488 <.text+0xd7868>
   6740c:      	mov	w0, #0x2                // =2
   67410:      	add	x22, x22, x21
   67414:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   67418:      	mov	x1, x0
   6741c:      	strh	w28, [x0]
   67420:      	mov	x0, x19
   67424:      	mov	x2, x23
   67428:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 53073) ===
   673f0:      	mov	w0, #0x18               // =24
   673f4:      	add	x22, x22, #0xa
   673f8:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   673fc:      	mov	x1, x22
   67400:      	mov	w2, w21
   67404:      	mov	x23, x0
   67408:      	bl	0x10b488 <.text+0xd7868>
   6740c:      	mov	w0, #0x2                // =2
   67410:      	add	x22, x22, x21
   67414:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   67418:      	mov	x1, x0
   6741c:      	strh	w28, [x0]
   67420:      	mov	x0, x19
   67424:      	mov	x2, x23
   67428:      	bl	0x11fc30 <.text+0xec010>
   6742c:      	mov	w0, #0x2                // =2
   67430:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   67434:      	mov	x21, x0
   67438:      	strh	w28, [x0]
   6743c:      	mov	w0, #0x4                // =4
   67440:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   67444:      	mov	x2, x0
   67448:      	str	w25, [x0]
   6744c:      	mov	x0, x20
   67450:      	mov	x1, x21
   67454:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 54864) ===
   68fec:      	ldr	x19, [sp, #0x10]
   68ff0:      	add	sp, sp, #0x30
   68ff4:      	ret
   68ff8:      	bl	0x33100 <__stack_chk_fail@plt>
   68ffc:      	str	x21, [sp, #-0x30]!
   69000:      	stp	x20, x19, [sp, #0x10]
   69004:      	stp	x29, x30, [sp, #0x20]
   69008:      	add	x29, sp, #0x20
   6900c:      	add	x20, x0, #0x18
   69010:      	add	x21, x1, #0x18
   69014:      	mov	x19, x1
   69018:      	mov	x0, x20
   6901c:      	mov	x1, x21
   69020:      	bl	0x11fe50 <.text+0xec230>
   69024:      	cbz	x0, 0x69038 <.text+0x35418>
   69028:      	ldp	x29, x30, [sp, #0x20]
   6902c:      	ldp	x20, x19, [sp, #0x10]
   69030:      	ldr	x21, [sp], #0x30
   69034:      	ret
   69038:      	mov	x0, x20
   6903c:      	mov	x2, x19
   69040:      	ldp	x29, x30, [sp, #0x20]
   69044:      	ldp	x20, x19, [sp, #0x10]
   69048:      	mov	x1, x21
   6904c:      	ldr	x21, [sp], #0x30
   69050:      	b	0x11fc30 <.text+0xec010>
=== call site (line 80558) ===
   82164:      	bl	0x12ab04 <.text+0xf6ee4>
   82168:      	ldr	x0, [x21, #0x8]
   8216c:      	mov	x1, x20
   82170:      	bl	0x11fe50 <.text+0xec230>
   82174:      	cbz	x0, 0x82190 <.text+0x4e570>
   82178:      	mov	x1, x19
   8217c:      	bl	0x10bad0 <.text+0xd7eb0>
   82180:      	tbz	w0, #0x0, 0x821cc <.text+0x4e5ac>
   82184:      	ldr	w8, [x19, #0xc]
   82188:      	cmp	w8, #0x1
   8218c:      	b.lt	0x821cc <.text+0x4e5ac>
   82190:      	ldr	x21, [x21, #0x8]
   82194:      	mov	w0, #0x18               // =24
   82198:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   8219c:      	ldr	x1, [x20, #0x10]
   821a0:      	mov	x20, x0
   821a4:      	bl	0x10b5f0 <.text+0xd79d0>
   821a8:      	mov	w0, #0x18               // =24
   821ac:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   821b0:      	ldr	x1, [x19, #0x10]
   821b4:      	mov	x19, x0
   821b8:      	bl	0x10b5f0 <.text+0xd79d0>
   821bc:      	mov	x0, x21
   821c0:      	mov	x1, x20
   821c4:      	mov	x2, x19
   821c8:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 84761) ===
   86310:      	ldr	x8, [sp, #0x88]
   86314:      	cbz	x8, 0x866cc <.text+0x52aac>
   86318:      	ldur	x0, [x29, #-0x98]
   8631c:      	add	x1, sp, #0xc8
   86320:      	bl	0x11fe50 <.text+0xec230>
   86324:      	cbz	x0, 0x8633c <.text+0x5271c>
   86328:      	ldr	w8, [x0]
   8632c:      	mov	x24, x0
   86330:      	add	w8, w8, #0x1
   86334:      	str	w8, [x0]
   86338:      	b	0x8637c <.text+0x5275c>
   8633c:      	mov	w0, #0x4                // =4
   86340:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   86344:      	ldur	x25, [x29, #-0x98]
   86348:      	mov	w8, #0x1                // =1
   8634c:      	mov	x24, x0
   86350:      	str	w8, [x0]
   86354:      	mov	w0, #0x18               // =24
   86358:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   8635c:      	add	x1, sp, #0xc8
   86360:      	mov	x26, x0
   86364:      	bl	0x10b68c <.text+0xd7a6c>
   86368:      	mov	x0, x25
   8636c:      	mov	x1, x26
   86370:      	mov	x2, x24
   86374:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 85487) ===
   86e68:      	adrp	x21, 0x2bd000
   86e6c:      	cbnz	x8, 0x86ea0 <.text+0x53280>
   86e70:      	mov	w0, #0x5                // =5
   86e74:      	bl	0x1c2f40 <JNI_OnLoad+0x89390>
   86e78:      	mov	w8, #0x31c3             // =12739
   86e7c:      	movk	w8, #0xa80c, lsl #16
   86e80:      	mov	w9, #0x60               // =96
   86e84:      	mov	w1, #0x5                // =5
   86e88:      	str	w8, [x0]
   86e8c:      	strb	w9, [x0, #0x4]
   86e90:      	bl	0x12c9a4 <.text+0xf8d84>
   86e94:      	ldr	x8, [x21, #0x380]
   86e98:      	cbnz	x8, 0x86ea0 <.text+0x53280>
   86e9c:      	str	x0, [x21, #0x380]
   86ea0:      	ldr	x1, [x21, #0x380]
   86ea4:      	mov	x0, x20
   86ea8:      	bl	0x10b5f0 <.text+0xd79d0>
   86eac:      	mov	w0, #0x18               // =24
   86eb0:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   86eb4:      	ldr	x1, [sp, #0x38]
   86eb8:      	mov	x21, x0
   86ebc:      	bl	0x10b68c <.text+0xd7a6c>
   86ec0:      	mov	x0, x19
   86ec4:      	mov	x1, x20
   86ec8:      	mov	x2, x21
   86ecc:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 109476) ===
   9e54c:      	mov	w0, #0x3                // =3
   9e550:      	bl	0x1c2f40 <JNI_OnLoad+0x89390>
   9e554:      	mov	w8, #0x50da             // =20698
   9e558:      	mov	w9, #0x91               // =145
   9e55c:      	mov	w1, #0x3                // =3
   9e560:      	strh	w8, [x0]
   9e564:      	strb	w9, [x0, #0x2]
   9e568:      	bl	0x12c648 <.text+0xf8a28>
   9e56c:      	ldr	x8, [x27, #0x9d8]
   9e570:      	cbnz	x8, 0x9e578 <.text+0x6a958>
   9e574:      	str	x0, [x27, #0x9d8]
   9e578:      	stur	x23, [x29, #-0xd0]
   9e57c:      	adrp	x23, 0x2bd000
   9e580:      	add	x23, x23, #0x9d8
   9e584:      	ldr	x1, [x23]
   9e588:      	mov	x0, x26
   9e58c:      	bl	0x10b5f0 <.text+0xd79d0>
   9e590:      	mov	w0, #0x18               // =24
   9e594:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   9e598:      	ldr	x1, [x20]
   9e59c:      	mov	x27, x0
   9e5a0:      	bl	0x10b68c <.text+0xd7a6c>
   9e5a4:      	mov	x0, x25
   9e5a8:      	mov	x1, x26
   9e5ac:      	mov	x2, x27
   9e5b0:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 109512) ===
   9e5dc:      	mov	w0, #0x3                // =3
   9e5e0:      	bl	0x1c2f40 <JNI_OnLoad+0x89390>
   9e5e4:      	mov	w8, #0x20c4             // =8388
   9e5e8:      	mov	w9, #0x78               // =120
   9e5ec:      	mov	w1, #0x3                // =3
   9e5f0:      	strh	w8, [x0]
   9e5f4:      	strb	w9, [x0, #0x2]
   9e5f8:      	bl	0x12c9a4 <.text+0xf8d84>
   9e5fc:      	adrp	x8, 0x2bd000
   9e600:      	ldr	x9, [x8, #0x9e0]
   9e604:      	cbnz	x9, 0x9e60c <.text+0x6a9ec>
   9e608:      	str	x0, [x8, #0x9e0]
   9e60c:      	adrp	x23, 0x2bd000
   9e610:      	add	x23, x23, #0x9e0
   9e614:      	ldr	x1, [x23]
   9e618:      	mov	x0, x26
   9e61c:      	bl	0x10b5f0 <.text+0xd79d0>
   9e620:      	mov	w0, #0x18               // =24
   9e624:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   9e628:      	ldr	x1, [x21]
   9e62c:      	mov	x27, x0
   9e630:      	bl	0x10b68c <.text+0xd7a6c>
   9e634:      	mov	x0, x25
   9e638:      	mov	x1, x26
   9e63c:      	mov	x2, x27
   9e640:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 109545) ===
   9e660:      	mov	x26, x0
   9e664:      	adrp	x27, 0x2bd000
   9e668:      	cbnz	x8, 0x9e698 <.text+0x6aa78>
   9e66c:      	mov	w0, #0x3                // =3
   9e670:      	bl	0x1c2f40 <JNI_OnLoad+0x89390>
   9e674:      	mov	w8, #0x6f47             // =28487
   9e678:      	mov	w9, #0x7f               // =127
   9e67c:      	mov	w1, #0x3                // =3
   9e680:      	strh	w8, [x0]
   9e684:      	strb	w9, [x0, #0x2]
   9e688:      	bl	0x12cf90 <.text+0xf9370>
   9e68c:      	ldr	x8, [x27, #0x9e8]
   9e690:      	cbnz	x8, 0x9e698 <.text+0x6aa78>
   9e694:      	str	x0, [x27, #0x9e8]
   9e698:      	ldr	x1, [x27, #0x9e8]
   9e69c:      	mov	x0, x26
   9e6a0:      	bl	0x10b5f0 <.text+0xd79d0>
   9e6a4:      	mov	w0, #0x18               // =24
   9e6a8:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   9e6ac:      	ldr	x1, [x22]
   9e6b0:      	mov	x27, x0
   9e6b4:      	bl	0x10b68c <.text+0xd7a6c>
   9e6b8:      	mov	x0, x25
   9e6bc:      	mov	x1, x26
   9e6c0:      	mov	x2, x27
   9e6c4:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 109748) ===
   9e98c:      	cbnz	x8, 0x9e9bc <.text+0x6ad9c>
   9e990:      	mov	w0, #0x3                // =3
   9e994:      	bl	0x1c2f40 <JNI_OnLoad+0x89390>
   9e998:      	mov	w8, #0x78cd             // =30925
   9e99c:      	mov	w9, #0x71               // =113
   9e9a0:      	mov	w1, #0x3                // =3
   9e9a4:      	strh	w8, [x0]
   9e9a8:      	strb	w9, [x0, #0x2]
   9e9ac:      	bl	0x12b904 <.text+0xf7ce4>
   9e9b0:      	ldr	x8, [x26, #0x9f0]
   9e9b4:      	cbnz	x8, 0x9e9bc <.text+0x6ad9c>
   9e9b8:      	str	x0, [x26, #0x9f0]
   9e9bc:      	adrp	x23, 0x2bd000
   9e9c0:      	add	x23, x23, #0x9f0
   9e9c4:      	ldr	x1, [x23]
   9e9c8:      	mov	x0, x25
   9e9cc:      	bl	0x10b5f0 <.text+0xd79d0>
   9e9d0:      	mov	w0, #0x18               // =24
   9e9d4:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
   9e9d8:      	ldr	x1, [x28]
   9e9dc:      	mov	x26, x0
   9e9e0:      	bl	0x10b68c <.text+0xd7a6c>
   9e9e4:      	mov	x0, x24
   9e9e8:      	mov	x1, x25
   9e9ec:      	mov	x2, x26
   9e9f0:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 203598) ===
   fa404:      	csel	x8, x8, x9, ne
   fa408:      	br	x8
   fa40c:      	mov	x0, sp
   fa410:      	bl	0xfa800 <.text+0xc6be0>
   fa414:      	mov	x1, x0
   fa418:      	add	x0, sp, #0x58
   fa41c:      	bl	0x10b5f0 <.text+0xd79d0>
   fa420:      	add	x1, sp, #0x58
   fa424:      	mov	x0, x22
   fa428:      	bl	0x10c0b0 <.text+0xd8490>
   fa42c:      	add	x0, sp, #0x58
   fa430:      	bl	0x10b764 <.text+0xd7b44>
   fa434:      	mov	x0, sp
   fa438:      	bl	0xfa84c <.text+0xc6c2c>
   fa43c:      	mov	x1, x0
   fa440:      	add	x0, sp, #0x58
   fa444:      	bl	0x10b5f0 <.text+0xd79d0>
   fa448:      	add	x1, sp, #0x58
   fa44c:      	mov	x0, x23
   fa450:      	bl	0x10c0f8 <.text+0xd84d8>
   fa454:      	add	x0, sp, #0x58
   fa458:      	bl	0x10b764 <.text+0xd7b44>
   fa45c:      	ldr	x0, [x21, #0x10]
   fa460:      	mov	x1, x22
   fa464:      	mov	x2, x23
   fa468:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 235304) ===
  11936c:      	mov	x21, x0
  119370:      	add	x1, x0, #0x80
  119374:      	mov	x0, sp
  119378:      	mov	w19, w2
  11937c:      	str	x8, [sp, #0x18]
  119380:      	bl	0x12ab04 <.text+0xf6ee4>
  119384:      	add	x21, x21, #0x8
  119388:      	mov	x0, x21
  11938c:      	mov	x1, x20
  119390:      	bl	0x11fe50 <.text+0xec230>
  119394:      	cbz	x0, 0x1193a4 <.text+0xe5784>
  119398:      	ldr	w20, [x0]
  11939c:      	str	w19, [x0]
  1193a0:      	b	0x1193dc <.text+0xe57bc>
  1193a4:      	mov	w0, #0x18               // =24
  1193a8:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  1193ac:      	mov	x1, x20
  1193b0:      	mov	x22, x0
  1193b4:      	bl	0x10b68c <.text+0xd7a6c>
  1193b8:      	mov	w0, #0x4                // =4
  1193bc:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  1193c0:      	mov	x2, x0
  1193c4:      	str	w19, [x0]
  1193c8:      	mov	x0, x21
  1193cc:      	mov	x1, x22
  1193d0:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 235426) ===
  119554:      	add	x19, x19, #0x8
  119558:      	mov	x0, x19
  11955c:      	mov	x1, x20
  119560:      	bl	0x11fe50 <.text+0xec230>
  119564:      	cbz	x0, 0x119588 <.text+0xe5968>
  119568:      	ldr	w19, [x0]
  11956c:      	mov	w8, #0xfffd             // =65533
  119570:      	movk	w8, #0x7fff, lsl #16
  119574:      	cmp	w19, w8
  119578:      	b.gt	0x1195c0 <.text+0xe59a0>
  11957c:      	add	w8, w19, #0x1
  119580:      	str	w8, [x0]
  119584:      	b	0x1195c0 <.text+0xe59a0>
  119588:      	mov	w0, #0x18               // =24
  11958c:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  119590:      	mov	x1, x20
  119594:      	mov	x21, x0
  119598:      	bl	0x10b68c <.text+0xd7a6c>
  11959c:      	mov	w0, #0x4                // =4
  1195a0:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  1195a4:      	mov	w8, #0x1                // =1
  1195a8:      	mov	x2, x0
  1195ac:      	str	w8, [x0]
  1195b0:      	mov	x0, x19
  1195b4:      	mov	x1, x21
  1195b8:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 235512) ===
  1196ac:      	mov	x21, x0
  1196b0:      	add	x1, x0, #0x80
  1196b4:      	mov	x0, sp
  1196b8:      	mov	x19, x2
  1196bc:      	str	x8, [sp, #0x18]
  1196c0:      	bl	0x12ab04 <.text+0xf6ee4>
  1196c4:      	add	x21, x21, #0x58
  1196c8:      	mov	x0, x21
  1196cc:      	mov	x1, x20
  1196d0:      	bl	0x11fe50 <.text+0xec230>
  1196d4:      	cbz	x0, 0x1196e4 <.text+0xe5ac4>
  1196d8:      	ldr	x20, [x0]
  1196dc:      	str	x19, [x0]
  1196e0:      	b	0x119718 <.text+0xe5af8>
  1196e4:      	mov	w0, #0x18               // =24
  1196e8:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  1196ec:      	mov	x1, x20
  1196f0:      	mov	x22, x0
  1196f4:      	bl	0x10b68c <.text+0xd7a6c>
  1196f8:      	mov	w0, #0x8                // =8
  1196fc:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  119700:      	mov	x2, x0
  119704:      	str	x19, [x0]
  119708:      	mov	x0, x21
  11970c:      	mov	x1, x22
  119710:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 235606) ===
  119824:      	mov	x0, sp
  119828:      	mov	x19, x2
  11982c:      	str	x8, [sp, #0x18]
  119830:      	bl	0x12ab04 <.text+0xf6ee4>
  119834:      	add	x20, x20, #0x30
  119838:      	mov	x0, x20
  11983c:      	mov	x1, x21
  119840:      	bl	0x11fe50 <.text+0xec230>
  119844:      	cbz	x0, 0x119854 <.text+0xe5c34>
  119848:      	mov	x1, x19
  11984c:      	bl	0x10b850 <.text+0xd7c30>
  119850:      	b	0x11988c <.text+0xe5c6c>
  119854:      	mov	w0, #0x18               // =24
  119858:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  11985c:      	mov	x1, x21
  119860:      	mov	x22, x0
  119864:      	bl	0x10b68c <.text+0xd7a6c>
  119868:      	mov	w0, #0x18               // =24
  11986c:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  119870:      	mov	x1, x19
  119874:      	mov	x21, x0
  119878:      	bl	0x10b68c <.text+0xd7a6c>
  11987c:      	mov	x0, x20
  119880:      	mov	x1, x22
  119884:      	mov	x2, x21
  119888:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 236478) ===
  11a5c4:      	str	x8, [sp, #0x18]
  11a5c8:      	ldr	x8, [x0, #0x100]
  11a5cc:      	mov	x0, sp
  11a5d0:      	mov	x19, x2
  11a5d4:      	mov	x1, x8
  11a5d8:      	bl	0x12ab04 <.text+0xf6ee4>
  11a5dc:      	ldr	x0, [x21, #0x18]
  11a5e0:      	mov	x1, x20
  11a5e4:      	bl	0x11fe50 <.text+0xec230>
  11a5e8:      	cbz	x0, 0x11a5f0 <.text+0xe69d0>
  11a5ec:      	tbz	w22, #0x0, 0x11a62c <.text+0xe6a0c>
  11a5f0:      	ldr	x21, [x21, #0x18]
  11a5f4:      	mov	w0, #0x18               // =24
  11a5f8:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  11a5fc:      	mov	x1, x20
  11a600:      	mov	x22, x0
  11a604:      	bl	0x10b68c <.text+0xd7a6c>
  11a608:      	mov	w0, #0x18               // =24
  11a60c:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  11a610:      	mov	x1, x19
  11a614:      	mov	x20, x0
  11a618:      	bl	0x10b68c <.text+0xd7a6c>
  11a61c:      	mov	x0, x21
  11a620:      	mov	x1, x22
  11a624:      	mov	x2, x20
  11a628:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 236571) ===
  11a738:      	mov	x20, x1
  11a73c:      	mov	x19, x2
  11a740:      	str	x8, [sp, #0x18]
  11a744:      	ldr	x8, [x0, #0x100]
  11a748:      	mov	x0, sp
  11a74c:      	mov	x1, x8
  11a750:      	bl	0x12ab04 <.text+0xf6ee4>
  11a754:      	ldr	x0, [x21, #0xc0]
  11a758:      	mov	x1, x20
  11a75c:      	bl	0x11fe50 <.text+0xec230>
  11a760:      	cbnz	x0, 0x11a7a0 <.text+0xe6b80>
  11a764:      	ldr	x21, [x21, #0xc0]
  11a768:      	mov	w0, #0x18               // =24
  11a76c:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  11a770:      	mov	x1, x20
  11a774:      	mov	x22, x0
  11a778:      	bl	0x10b68c <.text+0xd7a6c>
  11a77c:      	mov	w0, #0x18               // =24
  11a780:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  11a784:      	mov	x1, x19
  11a788:      	mov	x20, x0
  11a78c:      	bl	0x10b68c <.text+0xd7a6c>
  11a790:      	mov	x0, x21
  11a794:      	mov	x1, x22
  11a798:      	mov	x2, x20
  11a79c:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 236674) ===
  11a8d4:      	add	x1, sp, #0x10
  11a8d8:      	blr	x8
  11a8dc:      	cbnz	w0, 0x11a964 <.text+0xe6d44>
  11a8e0:      	ldr	x8, [sp]
  11a8e4:      	mov	x0, sp
  11a8e8:      	ldr	x8, [x8, #0x8]
  11a8ec:      	blr	x8
  11a8f0:      	ldr	x22, [x0]
  11a8f4:      	cbz	x22, 0x11a93c <.text+0xe6d1c>
  11a8f8:      	ldr	x21, [x0, #0x8]
  11a8fc:      	cbz	x21, 0x11a93c <.text+0xe6d1c>
  11a900:      	ldr	x23, [x19]
  11a904:      	mov	w0, #0x18               // =24
  11a908:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  11a90c:      	mov	x1, x22
  11a910:      	mov	x24, x0
  11a914:      	bl	0x10b68c <.text+0xd7a6c>
  11a918:      	mov	w0, #0x18               // =24
  11a91c:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  11a920:      	mov	x1, x21
  11a924:      	mov	x22, x0
  11a928:      	bl	0x10b68c <.text+0xd7a6c>
  11a92c:      	mov	x0, x23
  11a930:      	mov	x1, x24
  11a934:      	mov	x2, x22
  11a938:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 243147) ===
  120df8:      	ret
  120dfc:      	bl	0x33100 <__stack_chk_fail@plt>
  120e00:      	str	d8, [sp, #-0x30]!
  120e04:      	str	x21, [sp, #0x8]
  120e08:      	stp	x20, x19, [sp, #0x10]
  120e0c:      	stp	x29, x30, [sp, #0x20]
  120e10:      	add	x29, sp, #0x20
  120e14:      	mov	x20, x0
  120e18:      	mov	w0, #0x18               // =24
  120e1c:      	mov	v8.16b, v0.16b
  120e20:      	mov	x19, x1
  120e24:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  120e28:      	mov	x1, x19
  120e2c:      	mov	x21, x0
  120e30:      	bl	0x10b68c <.text+0xd7a6c>
  120e34:      	mov	w0, #0x8                // =8
  120e38:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  120e3c:      	str	d8, [x0]
  120e40:      	mov	x2, x0
  120e44:      	mov	x0, x20
  120e48:      	mov	x1, x21
  120e4c:      	ldp	x29, x30, [sp, #0x20]
  120e50:      	ldp	x20, x19, [sp, #0x10]
  120e54:      	ldr	x21, [sp, #0x8]
  120e58:      	ldr	d8, [sp], #0x30
  120e5c:      	b	0x11fc30 <.text+0xec010>
=== call site (line 248382) ===
  125fcc:      	add	x29, sp, #0x40
  125fd0:      	mrs	x22, TPIDR_EL0
  125fd4:      	ldr	x8, [x22, #0x28]
  125fd8:      	adrp	x9, 0x260000
  125fdc:      	mov	x20, x0
  125fe0:      	add	x9, x9, #0x5b8
  125fe4:      	str	x8, [sp, #0x18]
  125fe8:      	ldr	x8, [x0, #0x28]
  125fec:      	mov	x19, x1
  125ff0:      	add	x0, x8, #0x8
  125ff4:      	stp	x9, x8, [sp]
  125ff8:      	bl	0x33880 <pthread_mutex_lock@plt>
  125ffc:      	str	w0, [sp, #0x10]
  126000:      	cbz	x19, 0x126034 <.text+0xf2414>
  126004:      	mov	w0, #0x4                // =4
  126008:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  12600c:      	ldr	x8, [x19]
  126010:      	mov	x21, x0
  126014:      	mov	x0, x19
  126018:      	ldr	x8, [x8, #0x30]
  12601c:      	blr	x8
  126020:      	str	w0, [x21]
  126024:      	mov	x0, x20
  126028:      	mov	x1, x21
  12602c:      	mov	x2, x19
  126030:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 252932) ===
  12a6e8:      	add	x8, x8, #0x350
  12a6ec:      	str	x0, [x8], #0x8
  12a6f0:      	mov	x0, x8
  12a6f4:      	bl	0x1c52d0 <JNI_OnLoad+0x8b720>
  12a6f8:      	b	0x12a6a8 <.text+0xf6a88>
  12a6fc:      	str	x23, [sp, #-0x40]!
  12a700:      	stp	x22, x21, [sp, #0x10]
  12a704:      	stp	x20, x19, [sp, #0x20]
  12a708:      	stp	x29, x30, [sp, #0x30]
  12a70c:      	add	x29, sp, #0x30
  12a710:      	mov	x22, x0
  12a714:      	add	x19, x0, #0x8
  12a718:      	mov	w0, #0x18               // =24
  12a71c:      	mov	x20, x2
  12a720:      	mov	x21, x1
  12a724:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  12a728:      	mov	x1, x21
  12a72c:      	mov	x23, x0
  12a730:      	bl	0x10b68c <.text+0xd7a6c>
  12a734:      	mov	w0, #0x8                // =8
  12a738:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  12a73c:      	mov	x2, x0
  12a740:      	str	x20, [x0]
  12a744:      	mov	x0, x19
  12a748:      	mov	x1, x23
  12a74c:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 260013) ===
  131598:      	bl	0x131670 <.text+0xfda50>
  13159c:      	mov	x0, x21
  1315a0:      	mov	x1, x24
  1315a4:      	bl	0x1309c0 <.text+0xfcda0>
  1315a8:      	mov	x0, x21
  1315ac:      	mov	x1, x25
  1315b0:      	bl	0x1309c0 <.text+0xfcda0>
  1315b4:      	ldr	x24, [sp, #0x18]
  1315b8:      	cbz	x24, 0x131600 <.text+0xfd9e0>
  1315bc:      	ldr	x8, [sp, #0x8]
  1315c0:      	cbz	x8, 0x131600 <.text+0xfd9e0>
  1315c4:      	ldr	x25, [sp, #0x28]
  1315c8:      	mov	w0, #0x18               // =24
  1315cc:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  1315d0:      	mov	x1, x24
  1315d4:      	mov	x26, x0
  1315d8:      	bl	0x10b68c <.text+0xd7a6c>
  1315dc:      	mov	w0, #0x18               // =24
  1315e0:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  1315e4:      	ldr	x1, [sp, #0x8]
  1315e8:      	mov	x24, x0
  1315ec:      	bl	0x10b68c <.text+0xd7a6c>
  1315f0:      	mov	x0, x25
  1315f4:      	mov	x1, x26
  1315f8:      	mov	x2, x24
  1315fc:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 285403) ===
  14a24c:      	ldr	w8, [sp, #0x10]
  14a250:      	tbz	w8, #0x0, 0x14a348 <JNI_OnLoad+0x10798>
  14a254:      	mov	x8, #0x326d             // =12909
  14a258:      	ldr	x9, [sp, #0x128]
  14a25c:      	movk	x8, #0x853e, lsl #16
  14a260:      	ldr	x22, [sp, #0x28]
  14a264:      	movk	x8, #0xeaf7, lsl #32
  14a268:      	mov	w0, #0x18               // =24
  14a26c:      	movk	x8, #0xb192, lsl #48
  14a270:      	str	x9, [sp, #0x10]
  14a274:      	str	w22, [sp, #0x50]
  14a278:      	stur	x8, [x29, #-0x60]
  14a27c:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14a280:      	mov	x27, x0
  14a284:      	sub	x0, x29, #0x60
  14a288:      	mov	w1, #0x8                // =8
  14a28c:      	bl	0x12cf90 <.text+0xf9370>
  14a290:      	bl	0x14d49c <JNI_OnLoad+0x138ec>
  14a294:      	bl	0x14d264 <JNI_OnLoad+0x136b4>
  14a298:      	bl	0x14d35c <JNI_OnLoad+0x137ac>
  14a29c:      	bl	0x14d4e0 <JNI_OnLoad+0x13930>
  14a2a0:      	bl	0x14d4d4 <JNI_OnLoad+0x13924>
  14a2a4:      	ldr	x0, [sp, #0x10]
  14a2a8:      	mov	x1, x27
  14a2ac:      	mov	x2, x28
  14a2b0:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 285431) ===
  14a2bc:      	bl	0x14d2e0 <JNI_OnLoad+0x13730>
  14a2c0:      	mov	x8, #0x3ffd             // =16381
  14a2c4:      	rev	w9, w22
  14a2c8:      	movk	x8, #0xb6cd, lsl #16
  14a2cc:      	mov	w0, #0x18               // =24
  14a2d0:      	movk	x8, #0x7f04, lsl #32
  14a2d4:      	ldr	x22, [sp, #0x128]
  14a2d8:      	movk	x8, #0xb21f, lsl #48
  14a2dc:      	str	w9, [sp, #0x50]
  14a2e0:      	stur	x8, [x29, #-0x60]
  14a2e4:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14a2e8:      	mov	x27, x0
  14a2ec:      	sub	x0, x29, #0x60
  14a2f0:      	mov	w1, #0x8                // =8
  14a2f4:      	bl	0x12bfa8 <.text+0xf8388>
  14a2f8:      	bl	0x14d49c <JNI_OnLoad+0x138ec>
  14a2fc:      	bl	0x14d264 <JNI_OnLoad+0x136b4>
  14a300:      	bl	0x14d35c <JNI_OnLoad+0x137ac>
  14a304:      	bl	0x14d4e0 <JNI_OnLoad+0x13930>
  14a308:      	bl	0x14d4d4 <JNI_OnLoad+0x13924>
  14a30c:      	mov	x0, x22
  14a310:      	mov	x1, x27
  14a314:      	mov	x2, x28
  14a318:      	adrp	x28, 0x2c4000
  14a31c:      	add	x28, x28, #0xd88
  14a320:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 285566) ===
  14a4d8:      	ldr	w8, [sp, #0xc]
  14a4dc:      	sturb	w8, [x29, #-0x64]
  14a4e0:      	bl	0x171698 <JNI_OnLoad+0x37ae8>
  14a4e4:      	bl	0x4303c <.text+0xf41c>
  14a4e8:      	ldr	x22, [x0]
  14a4ec:      	adrp	x1, 0x27e000
  14a4f0:      	add	x1, x1, #0xe23
  14a4f4:      	add	x0, sp, #0x50
  14a4f8:      	bl	0x10b5f0 <.text+0xd79d0>
  14a4fc:      	add	x1, sp, #0x50
  14a500:      	mov	x0, x22
  14a504:      	mov	w2, #0x64               // =100
  14a508:      	bl	0x119348 <.text+0xe5728>
  14a50c:      	add	x0, sp, #0x50
  14a510:      	bl	0x10b764 <.text+0xd7b44>
  14a514:      	bl	0x14d284 <JNI_OnLoad+0x136d4>
  14a518:      	ldr	x1, [sp, #0xd8]
  14a51c:      	bl	0x14d44c <JNI_OnLoad+0x1389c>
  14a520:      	bl	0x14d264 <JNI_OnLoad+0x136b4>
  14a524:      	ldr	x1, [sp, #0xd0]
  14a528:      	mov	x25, x0
  14a52c:      	bl	0x10b5f0 <.text+0xd79d0>
  14a530:      	mov	x0, x22
  14a534:      	mov	x1, x24
  14a538:      	mov	x2, x25
  14a53c:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 285638) ===
  14a5f8:      	bl	0x42ce4 <.text+0xf0c4>
  14a5fc:      	tbnz	w22, #0x0, 0x14a660 <JNI_OnLoad+0x10ab0>
  14a600:      	mov	x8, #0xded              // =3565
  14a604:      	sub	x0, x29, #0x48
  14a608:      	movk	x8, #0x88c2, lsl #16
  14a60c:      	mov	w1, #0x8                // =8
  14a610:      	movk	x8, #0xc534, lsl #32
  14a614:      	movk	x8, #0xb691, lsl #48
  14a618:      	stur	x8, [x29, #-0x48]
  14a61c:      	bl	0x12c648 <.text+0xf8a28>
  14a620:      	mov	x22, x0
  14a624:      	mov	w0, #0x18               // =24
  14a628:      	ldr	x23, [sp, #0x128]
  14a62c:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14a630:      	mov	x1, x22
  14a634:      	bl	0x14d44c <JNI_OnLoad+0x1389c>
  14a638:      	bl	0x14d264 <JNI_OnLoad+0x136b4>
  14a63c:      	ldur	x8, [x29, #-0xc0]
  14a640:      	mov	x22, x0
  14a644:      	ldr	x1, [x8, #0x10]
  14a648:      	ldr	w2, [x8, #0xc]
  14a64c:      	bl	0x10b488 <.text+0xd7868>
  14a650:      	mov	x0, x23
  14a654:      	mov	x1, x24
  14a658:      	mov	x2, x22
  14a65c:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 286156) ===
  14ae10:      	mov	w0, #0x18               // =24
  14ae14:      	ldr	x24, [sp, #0x178]
  14ae18:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14ae1c:      	sub	x1, x29, #0xe8
  14ae20:      	mov	x28, x25
  14ae24:      	mov	x25, x0
  14ae28:      	bl	0x10b68c <.text+0xd7a6c>
  14ae2c:      	bl	0x14d264 <JNI_OnLoad+0x136b4>
  14ae30:      	add	x1, sp, #0x150
  14ae34:      	mov	x22, x20
  14ae38:      	mov	x20, x26
  14ae3c:      	mov	x26, x0
  14ae40:      	bl	0x10b68c <.text+0xd7a6c>
  14ae44:      	mov	x0, x24
  14ae48:      	mov	x1, x25
  14ae4c:      	mov	x2, x26
  14ae50:      	mov	w24, #0x1dae            // =7598
  14ae54:      	mov	x25, x28
  14ae58:      	mov	w28, #0xf0c1            // =61633
  14ae5c:      	mov	x26, x20
  14ae60:      	mov	x20, x22
  14ae64:      	mov	w22, #0xef23            // =61219
  14ae68:      	movk	w24, #0xc7a7, lsl #16
  14ae6c:      	movk	w28, #0xb384, lsl #16
  14ae70:      	movk	w22, #0xe4d6, lsl #16
  14ae74:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 287293) ===
  14bfd4:      	mov	w8, #0x57               // =87
  14bfd8:      	mov	w9, #0x52               // =82
  14bfdc:      	csel	w8, w9, w8, eq
  14bfe0:      	ldr	x8, [x26, w8, uxtw #3]
  14bfe4:      	br	x8
  14bfe8:      	mov	w0, #0x18               // =24
  14bfec:      	ldur	x21, [x29, #-0x78]
  14bff0:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14bff4:      	mov	x22, x0
  14bff8:      	sub	x0, x29, #0x30
  14bffc:      	mov	w1, #0x9                // =9
  14c000:      	bl	0x12cf90 <.text+0xf9370>
  14c004:      	mov	x1, x0
  14c008:      	mov	x0, x22
  14c00c:      	bl	0x10b5f0 <.text+0xd79d0>
  14c010:      	mov	w0, #0x18               // =24
  14c014:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14c018:      	ldr	x8, [sp, #0x190]
  14c01c:      	mov	x23, x0
  14c020:      	ldr	x1, [x8, #0x10]
  14c024:      	ldr	w2, [x8, #0xc]
  14c028:      	bl	0x10b488 <.text+0xd7868>
  14c02c:      	mov	x0, x21
  14c030:      	mov	x1, x22
  14c034:      	mov	x2, x23
  14c038:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 287459) ===
  14c26c:      	br	x8
  14c270:      	sub	x8, x29, #0xf0
  14c274:      	add	x0, sp, #0x148
  14c278:      	mov	w1, #0x1                // =1
  14c27c:      	bl	0x11b47c <.text+0xe785c>
  14c280:      	mov	w0, #0x18               // =24
  14c284:      	ldur	x21, [x29, #-0x78]
  14c288:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14c28c:      	mov	x22, x0
  14c290:      	sub	x0, x29, #0x20
  14c294:      	mov	w1, #0xa                // =10
  14c298:      	bl	0x12b904 <.text+0xf7ce4>
  14c29c:      	mov	x1, x0
  14c2a0:      	mov	x0, x22
  14c2a4:      	bl	0x10b5f0 <.text+0xd79d0>
  14c2a8:      	mov	w0, #0x18               // =24
  14c2ac:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14c2b0:      	ldur	x8, [x29, #-0xf0]
  14c2b4:      	mov	x23, x0
  14c2b8:      	ldr	x1, [x8, #0x10]
  14c2bc:      	ldr	w2, [x8, #0xc]
  14c2c0:      	bl	0x10b488 <.text+0xd7868>
  14c2c4:      	mov	x0, x21
  14c2c8:      	mov	x1, x22
  14c2cc:      	mov	x2, x23
  14c2d0:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 287556) ===
  14c3f0:      	mov	w8, #0x57               // =87
  14c3f4:      	mov	w9, #0x35               // =53
  14c3f8:      	csel	w8, w9, w8, eq
  14c3fc:      	ldr	x8, [x26, w8, uxtw #3]
  14c400:      	br	x8
  14c404:      	mov	w0, #0x18               // =24
  14c408:      	ldur	x21, [x29, #-0x78]
  14c40c:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14c410:      	mov	x22, x0
  14c414:      	sub	x0, x29, #0x58
  14c418:      	mov	w1, #0x4                // =4
  14c41c:      	bl	0x12c648 <.text+0xf8a28>
  14c420:      	mov	x1, x0
  14c424:      	mov	x0, x22
  14c428:      	bl	0x10b5f0 <.text+0xd79d0>
  14c42c:      	mov	w0, #0x18               // =24
  14c430:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14c434:      	ldur	x8, [x29, #-0xc8]
  14c438:      	mov	x23, x0
  14c43c:      	ldr	x1, [x8, #0x10]
  14c440:      	ldr	w2, [x8, #0xc]
  14c444:      	bl	0x10b488 <.text+0xd7868>
  14c448:      	mov	x0, x21
  14c44c:      	mov	x1, x22
  14c450:      	mov	x2, x23
  14c454:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 288176) ===
  14cda0:      	mov	x20, x0
  14cda4:      	mov	x0, x19
  14cda8:      	mov	w1, #0x5                // =5
  14cdac:      	bl	0x1547c0 <JNI_OnLoad+0x1ac10>
  14cdb0:      	mov	x8, x20
  14cdb4:      	bl	0x119940 <.text+0xe5d20>
  14cdb8:      	ldp	x20, x19, [sp, #0x10]
  14cdbc:      	ldr	x30, [sp], #0x20
  14cdc0:      	ret
  14cdc4:      	stp	x30, x21, [sp, #-0x20]!
  14cdc8:      	stp	x20, x19, [sp, #0x10]
  14cdcc:      	mov	w1, #0x4                // =4
  14cdd0:      	mov	x19, x0
  14cdd4:      	bl	0x1547c0 <JNI_OnLoad+0x1ac10>
  14cdd8:      	mov	x20, x0
  14cddc:      	mov	x0, x19
  14cde0:      	mov	w1, #0x5                // =5
  14cde4:      	bl	0x1547c0 <JNI_OnLoad+0x1ac10>
  14cde8:      	mov	x21, x0
  14cdec:      	mov	x0, x19
  14cdf0:      	mov	w1, #0x6                // =6
  14cdf4:      	bl	0x1547c0 <JNI_OnLoad+0x1ac10>
  14cdf8:      	mov	x2, x0
  14cdfc:      	mov	x0, x20
  14ce00:      	mov	x1, x21
  14ce04:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 288470) ===
  14d238:      	mov	x0, x21
  14d23c:      	bl	0x154648 <JNI_OnLoad+0x1aa98>
  14d240:      	ldr	x8, [x22, #0x28]
  14d244:      	bl	0x14d310 <JNI_OnLoad+0x13760>
  14d248:      	b.ne	0x14d260 <JNI_OnLoad+0x136b0>
  14d24c:      	ldp	x20, x19, [sp, #0x50]
  14d250:      	ldp	x22, x21, [sp, #0x40]
  14d254:      	ldp	x29, x30, [sp, #0x30]
  14d258:      	add	sp, sp, #0x60
  14d25c:      	ret
  14d260:      	bl	0x33100 <__stack_chk_fail@plt>
  14d264:      	mov	w0, #0x18               // =24
  14d268:      	b	0x1c2edc <JNI_OnLoad+0x8932c>
  14d26c:      	ldr	x8, [sp, #0x48]
  14d270:      	ldr	w10, [x27]
  14d274:      	ldr	w9, [x8]
  14d278:      	add	w9, w10, w9
  14d27c:      	str	w9, [x8]
  14d280:      	ret
  14d284:      	mov	w0, #0x18               // =24
  14d288:      	ldr	x22, [sp, #0x128]
  14d28c:      	b	0x1c2edc <JNI_OnLoad+0x8932c>
  14d290:      	mov	x0, x22
  14d294:      	mov	x1, x27
  14d298:      	mov	x2, x28
  14d29c:      	b	0x11fc30 <.text+0xec010>
=== call site (line 288498) ===
  14d2a8:      	ldp	x24, x23, [sp, #0x30]
  14d2ac:      	ldp	x26, x25, [sp, #0x20]
  14d2b0:      	ldp	x28, x27, [sp, #0x10]
  14d2b4:      	ret
  14d2b8:      	ldr	x8, [sp, #0x68]
  14d2bc:      	sub	x0, x29, #0xc0
  14d2c0:      	ldr	x10, [sp, #0x28]
  14d2c4:      	ldr	x9, [x23]
  14d2c8:      	stp	x10, x8, [x29, #-0xc0]
  14d2cc:      	add	x10, sp, #0xd8
  14d2d0:      	add	x8, sp, #0xd0
  14d2d4:      	stp	x9, x22, [x29, #-0xb0]
  14d2d8:      	stp	x10, x8, [x29, #-0xa0]
  14d2dc:      	ret
  14d2e0:      	sub	x0, x29, #0xc0
  14d2e4:      	b	0x10b764 <.text+0xd7b44>
  14d2e8:      	ldr	x1, [sp, #0xd0]
  14d2ec:      	mov	x28, x0
  14d2f0:      	b	0x10b5f0 <.text+0xd79d0>
  14d2f4:      	ldr	x1, [sp, #0xd8]
  14d2f8:      	mov	x27, x0
  14d2fc:      	b	0x10b5f0 <.text+0xd79d0>
  14d300:      	mov	x0, x22
  14d304:      	mov	x1, x23
  14d308:      	mov	x2, x24
  14d30c:      	b	0x11fc30 <.text+0xec010>
=== call site (line 290373) ===
  14eff4:      	add	x0, sp, #0x8
  14eff8:      	ldr	x8, [x8, #0x18]
  14effc:      	blr	x8
  14f000:      	ldp	x1, x2, [sp, #0x8]
  14f004:      	ldur	x0, [x29, #-0x18]
  14f008:      	bl	0x1203b8 <.text+0xec798>
  14f00c:      	ldr	x8, [sp, #0x8]
  14f010:      	mov	x21, x0
  14f014:      	add	x0, sp, #0x8
  14f018:      	ldr	x8, [x8, #0x18]
  14f01c:      	blr	x8
  14f020:      	mov	w0, #0x18               // =24
  14f024:      	ldr	x22, [x19]
  14f028:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14f02c:      	mov	x1, x20
  14f030:      	mov	x23, x0
  14f034:      	bl	0x10b68c <.text+0xd7a6c>
  14f038:      	mov	w0, #0x18               // =24
  14f03c:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14f040:      	mov	x1, x21
  14f044:      	mov	x20, x0
  14f048:      	bl	0x10b68c <.text+0xd7a6c>
  14f04c:      	mov	x0, x22
  14f050:      	mov	x1, x23
  14f054:      	mov	x2, x20
  14f058:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 290564) ===
  14f2f0:      	add	x0, sp, #0x8
  14f2f4:      	ldr	x8, [x8, #0x18]
  14f2f8:      	blr	x8
  14f2fc:      	ldp	x1, x2, [sp, #0x8]
  14f300:      	ldur	x0, [x29, #-0x18]
  14f304:      	bl	0x1203b8 <.text+0xec798>
  14f308:      	ldr	x8, [sp, #0x8]
  14f30c:      	mov	x21, x0
  14f310:      	add	x0, sp, #0x8
  14f314:      	ldr	x8, [x8, #0x18]
  14f318:      	blr	x8
  14f31c:      	mov	w0, #0x18               // =24
  14f320:      	ldr	x22, [x19]
  14f324:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14f328:      	mov	x1, x20
  14f32c:      	mov	x23, x0
  14f330:      	bl	0x10b68c <.text+0xd7a6c>
  14f334:      	mov	w0, #0x18               // =24
  14f338:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  14f33c:      	mov	x1, x21
  14f340:      	mov	x20, x0
  14f344:      	bl	0x10b68c <.text+0xd7a6c>
  14f348:      	mov	x0, x22
  14f34c:      	mov	x1, x23
  14f350:      	mov	x2, x20
  14f354:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 291759) ===
  15059c:      	b.hs	0x150608 <JNI_OnLoad+0x16a58>
  1505a0:      	mov	x0, x20
  1505a4:      	bl	0x11b5e8 <.text+0xe79c8>
  1505a8:      	add	x20, x19, #0x18
  1505ac:      	str	x0, [sp, #0x8]
  1505b0:      	add	x1, sp, #0x8
  1505b4:      	mov	x0, x20
  1505b8:      	bl	0x11fe50 <.text+0xec230>
  1505bc:      	cbnz	x0, 0x150624 <JNI_OnLoad+0x16a74>
  1505c0:      	mov	x0, x20
  1505c4:      	bl	0x11fe48 <.text+0xec228>
  1505c8:      	ldr	x8, [x19, #0x60]
  1505cc:      	cmp	x0, x8
  1505d0:      	b.hs	0x150624 <JNI_OnLoad+0x16a74>
  1505d4:      	mov	w0, #0x8                // =8
  1505d8:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  1505dc:      	ldr	x8, [sp, #0x8]
  1505e0:      	mov	x19, x0
  1505e4:      	str	x8, [x0]
  1505e8:      	mov	w0, #0x4                // =4
  1505ec:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  1505f0:      	mov	x2, x0
  1505f4:      	str	wzr, [x0]
  1505f8:      	mov	x0, x20
  1505fc:      	mov	x1, x19
  150600:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 292278) ===
  150db8:      	adrp	x23, 0x2c4000
  150dbc:      	cbnz	x8, 0x150df0 <JNI_OnLoad+0x17240>
  150dc0:      	mov	w0, #0x5                // =5
  150dc4:      	bl	0x1c2f40 <JNI_OnLoad+0x89390>
  150dc8:      	mov	w8, #0x6082             // =24706
  150dcc:      	mov	w9, #0x60               // =96
  150dd0:      	movk	w8, #0xb140, lsl #16
  150dd4:      	mov	w1, #0x5                // =5
  150dd8:      	strb	w9, [x0, #0x4]
  150ddc:      	str	w8, [x0]
  150de0:      	bl	0x12c9a4 <.text+0xf8d84>
  150de4:      	ldr	x8, [x23, #0xf88]
  150de8:      	cbnz	x8, 0x150df0 <JNI_OnLoad+0x17240>
  150dec:      	str	x0, [x23, #0xf88]
  150df0:      	ldr	x1, [x23, #0xf88]
  150df4:      	mov	x0, x22
  150df8:      	mov	w2, w20
  150dfc:      	bl	0x10bbc0 <.text+0xd7fa0>
  150e00:      	ldr	x0, [x19]
  150e04:      	mov	x1, x21
  150e08:      	mov	x2, x22
  150e0c:      	ldr	x23, [sp, #0x10]
  150e10:      	ldp	x20, x19, [sp, #0x30]
  150e14:      	ldp	x22, x21, [sp, #0x20]
  150e18:      	ldp	x29, x30, [sp], #0x40
  150e1c:      	b	0x11fc30 <.text+0xec010>
=== call site (line 292390) ===
  150f78:      	stp	x9, x8, [x29, #-0x70]
  150f7c:      	ldr	x8, [x9, #0x8]
  150f80:      	blr	x8
  150f84:      	mov	x22, x0
  150f88:      	ldr	x1, [x0]
  150f8c:      	sub	x0, x29, #0x70
  150f90:      	bl	0x10b68c <.text+0xd7a6c>
  150f94:      	ldr	x1, [x22, #0x8]
  150f98:      	add	x0, sp, #0x18
  150f9c:      	bl	0x10b68c <.text+0xd7a6c>
  150fa0:      	sub	x0, x29, #0x70
  150fa4:      	bl	0x10c14c <.text+0xd852c>
  150fa8:      	mov	w0, #0x18               // =24
  150fac:      	ldr	x22, [sp, #0x40]
  150fb0:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  150fb4:      	sub	x1, x29, #0x70
  150fb8:      	mov	x23, x0
  150fbc:      	bl	0x10b68c <.text+0xd7a6c>
  150fc0:      	bl	0x151d5c <JNI_OnLoad+0x181ac>
  150fc4:      	add	x1, sp, #0x18
  150fc8:      	mov	x24, x0
  150fcc:      	bl	0x10b68c <.text+0xd7a6c>
  150fd0:      	mov	x0, x22
  150fd4:      	mov	x1, x23
  150fd8:      	mov	x2, x24
  150fdc:      	bl	0x11fc30 <.text+0xec010>
=== call site (line 293081) ===
  151a44:      	str	x8, [x23, #0x38]
  151a48:      	bl	0x171744 <JNI_OnLoad+0x37b94>
  151a4c:      	mov	w0, #0x18               // =24
  151a50:      	ldr	x27, [x23, #0x90]
  151a54:      	bl	0x1c2edc <JNI_OnLoad+0x8932c>
  151a58:      	ldr	x1, [x23, #0x48]
  151a5c:      	mov	x28, x0
  151a60:      	bl	0x10b5f0 <.text+0xd79d0>
  151a64:      	bl	0x151d5c <JNI_OnLoad+0x181ac>
  151a68:      	sub	x8, x29, #0xc0
  151a6c:      	mov	x20, x0
  151a70:      	ldr	x1, [x8, #0x40]
  151a74:      	bl	0x10b5f0 <.text+0xd79d0>
  151a78:      	mov	x0, x27
  151a7c:      	mov	x1, x28
  151a80:      	mov	x2, x20
  151a84:      	mov	w28, #0xf837            // =63543
  151a88:      	mov	w20, #0xbca1            // =48289
  151a8c:      	mov	w26, #0x9b0d            // =39693
  151a90:      	adrp	x27, 0x27f000
  151a94:      	add	x27, x27, #0x8cc
  151a98:      	movk	w28, #0x126e, lsl #16
  151a9c:      	movk	w20, #0xc63d, lsl #16
  151aa0:      	movk	w26, #0xa618, lsl #16
  151aa4:      	sub	x23, x29, #0xc0
  151aa8:      	bl	0x11fc30 <.text+0xec010>
