# CS_ARCH_ARM, CS_MODE_THUMB, None
// 0xff,0xf7,0x00,0xbc = b.w #-2044
// 0x00,0xf0,0xff,0xbb = b.w #2050
// 0x66,0xf6,0x30,0xbc = b.w #-1677212
// 0x99,0xf1,0xcf,0xbb = b.w #1677218
// 0x00,0xe4 = b #-2044
0xff,0xe3 = b #2050
0xff,0xf7,0xff,0xbb = b.w #-2046
0x00,0xf0,0x00,0xbc = b.w #2052
// 0x66,0xf6,0x30,0xbc = b.w #-1677212
// 0x99,0xf1,0xcf,0xbb = b.w #1677218
0x08,0xbf = it eq
// 0x00,0xe4 = beq #-2044
0x18,0xbf = it ne
// 0x01,0xe4 = bne #-2042
0xc8,0xbf = it gt
// 0xff,0xf7,0x00,0xbc = bgt.w #-2044
0xd8,0xbf = it le
// 0x00,0xf0,0xff,0xbb = ble.w #2050
0xa8,0xbf = it ge
// 0x66,0xf6,0x30,0xbc = bge.w #-1677212
0xb8,0xbf = it lt
// 0x99,0xf1,0xcf,0xbb = blt.w #1677218
0x80,0xd0 = beq #-252
0x7f,0xd1 = bne #258
0x3f,0xf5,0x80,0xaf = bmi.w #-252
0x40,0xf0,0x7f,0x80 = bne.w #258
0xc0,0xf6,0x00,0x80 = blt.w #-1048572
0xbf,0xf2,0xff,0xaf = bge.w #1048578
0x80,0xd1 = bne #-252
0x7f,0xdc = bgt #258
0x7f,0xf4,0x7f,0xaf = bne.w #-254
0x00,0xf3,0x80,0x80 = bgt.w #260
0x40,0xf4,0x00,0x80 = bne.w #-1048572
0x3f,0xf3,0xff,0xaf = bgt.w #1048578
0x08,0xbf = it eq
// 0x08,0x44 = addeq r0, r1
0x40,0xd1 = bne #132
0x0c,0xbf = ite eq
// 0x08,0x44 = addeq r0, r1
// 0x40,0xe0 = bne #132
// 0x00,0xe4 = b #-2044
// 0xff,0xf7,0x00,0xbc = b.w #-2044
// 0x00,0xf0,0xff,0xbb = b.w #2050
// 0x66,0xf6,0x30,0xbc = b.w #-1677212
// 0x99,0xf1,0xcf,0xbb = b.w #1677218
// 0x00,0xe4 = b #-2044
0xff,0xe3 = b #2050
0xff,0xf7,0xff,0xbb = b.w #-2046
0x00,0xf0,0x00,0xbc = b.w #2052
// 0x66,0xf6,0x30,0xbc = b.w #-1677212
// 0x99,0xf1,0xcf,0xbb = b.w #1677218
0x08,0xbf = it eq
// 0x00,0xe4 = beq #-2044
0x18,0xbf = it ne
// 0x01,0xe4 = bne #-2042
0xc8,0xbf = it gt
// 0xff,0xf7,0x00,0xbc = bgt.w #-2044
0xd8,0xbf = it le
// 0x00,0xf0,0xff,0xbb = ble.w #2050
0xa8,0xbf = it ge
// 0x66,0xf6,0x30,0xbc = bge.w #-1677212
0xb8,0xbf = it lt
// 0x99,0xf1,0xcf,0xbb = blt.w #1677218
0x80,0xd0 = beq #-252
0x7f,0xd1 = bne #258
0x3f,0xf5,0x80,0xaf = bmi.w #-252
0x40,0xf0,0x7f,0x80 = bne.w #258
0xc0,0xf6,0x00,0x80 = blt.w #-1048572
0xbf,0xf2,0xff,0xaf = bge.w #1048578
0x80,0xd1 = bne #-252
0x7f,0xdc = bgt #258
0x7f,0xf4,0x7f,0xaf = bne.w #-254
0x00,0xf3,0x80,0x80 = bgt.w #260
0x40,0xf4,0x00,0x80 = bne.w #-1048572
0x3f,0xf3,0xff,0xaf = bgt.w #1048578
0x08,0xbf = it eq
// 0x08,0x44 = addeq r0, r1
0x40,0xd1 = bne #132
0x0c,0xbf = ite eq
// 0x08,0x44 = addeq r0, r1
// 0x40,0xe0 = b #132
