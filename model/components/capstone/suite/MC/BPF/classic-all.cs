# CS_ARCH_BPF, CS_MODE_LITTLE_ENDIAN+CS_MODE_BPF_CLASSIC, None
0x00,0x00,0x98,0xab,0x08,0x02,0x0e,0x45 = ld 0x450e0208
0x01,0x00,0x44,0x49,0x1f,0xfe,0xd3,0x93 = ldx 0x93d3fe1f
0x04,0x00,0xda,0x23,0x71,0xc5,0x51,0x42 = add 0x4251c571
0x05,0x00,0xd4,0xbd,0x37,0xc8,0x2c,0xd5 = jmp +0xd52cc837
0x06,0x00,0xa7,0x84,0x25,0x40,0x28,0x1c = ret 0x1c284025
0x07,0x00,0xe8,0xe8,0x48,0xe2,0x84,0x2a = tax
0x0c,0x00,0x55,0x8c,0x32,0xd8,0x21,0xe8 = add x
0x0e,0x00,0xd4,0x24,0x96,0xf7,0xa1,0x49 = ret x
0x14,0x00,0x6a,0xc8,0x14,0x50,0x2d,0x69 = sub 0x692d5014
0x15,0x00,0xc3,0x39,0x6e,0x4f,0x37,0x18 = jeq 0x18374f6e, +0xc3, +0x39
0x16,0x00,0x57,0xd2,0xc4,0xd4,0x8a,0x51 = ret a
0x1c,0x00,0xd1,0x51,0x90,0x8a,0x8d,0xea = sub x
0x1d,0x00,0x2e,0xa8,0xbc,0xa7,0xd5,0x3a = jeq x, +0x2e, +0xa8
0x20,0x00,0x9a,0x43,0x93,0x27,0xec,0xf7 = ld [0xf7ec2793]
0x24,0x00,0x0f,0x46,0xbe,0xe5,0xd2,0x4a = mul 0x4ad2e5be
0x25,0x00,0x8c,0x80,0xc1,0x03,0x38,0x61 = jgt 0x613803c1, +0x8c, +0x80
0x28,0x00,0xc3,0x05,0x73,0x01,0x39,0xbd = ldh [0xbd390173]
0x2c,0x00,0x7a,0x3d,0xad,0x19,0xe7,0xcc = mul x
0x2d,0x00,0xd9,0xc6,0xf7,0x72,0x9a,0x9d = jgt x, +0xd9, +0xc6
0x30,0x00,0x22,0x29,0x29,0x5b,0xb5,0x87 = ldb [0x87b55b29]
0x34,0x00,0xa8,0xfa,0x6a,0x92,0xa2,0xa8 = div 0xa8a2926a
0x35,0x00,0x24,0xdb,0x58,0x41,0xa8,0x58 = jge 0x58a84158, +0x24, +0xdb
0x3c,0x00,0x41,0xa6,0xd5,0x66,0x8a,0xdd = div x
0x3d,0x00,0xe4,0xbc,0x40,0xb3,0x4d,0x84 = jge x, +0xe4, +0xbc
0x40,0x00,0xf1,0xa0,0xd9,0x89,0x72,0x25 = ld [x+0x257289d9]
0x44,0x00,0x8d,0xf8,0x49,0xdb,0x10,0x82 = or 0x8210db49
0x45,0x00,0x43,0xfc,0x7d,0xa1,0x34,0xed = jset 0xed34a17d, +0x43, +0xfc
0x48,0x00,0x6b,0x89,0x0b,0xca,0xfb,0x1b = ldh [x+0x1bfbca0b]
0x4c,0x00,0xc9,0xff,0x36,0xe9,0x2a,0xe7 = or x
0x4d,0x00,0x0d,0xaa,0xc3,0x50,0xea,0x40 = jset x, +0xd, +0xaa
0x50,0x00,0xd9,0xf3,0xda,0xa7,0xd9,0xb1 = ldb [x+0xb1d9a7da]
0x54,0x00,0x14,0x82,0x29,0x82,0x6c,0x06 = and 0x66c8229
0x5c,0x00,0x80,0x37,0x5f,0x52,0xc0,0x84 = and x
0x60,0x00,0xba,0x4e,0xb5,0x3f,0xdc,0xd8 = ld m[0xd8dc3fb5]
0x61,0x00,0x06,0xd9,0xcd,0x84,0x58,0x94 = ldx m[0x945884cd]
0x62,0x00,0x2c,0x44,0xdf,0x71,0x48,0x1b = st m[0x1b4871df]
0x63,0x00,0xc9,0x53,0x7f,0x80,0x89,0x2d = stx m[0x2d89807f]
0x64,0x00,0x8a,0xe5,0xf0,0x0c,0xca,0xfd = lsh 0xfdca0cf0
0x6c,0x00,0xd3,0x85,0xc1,0x96,0xb1,0x48 = lsh x
0x74,0x00,0xfa,0x6f,0xe9,0xbe,0xde,0x7e = rsh 0x7edebee9
0x7c,0x00,0x0d,0x89,0xed,0x17,0x7d,0xcd = rsh x
0x80,0x00,0x70,0x62,0x0e,0x61,0x1b,0x94 = ld #len
0x81,0x00,0xa0,0x03,0xa2,0x5c,0x1f,0x2a = ldx #len
0x84,0x00,0x4f,0x0f,0xc9,0x4a,0x72,0xff = neg
0x87,0x00,0x17,0x2a,0x9a,0xd6,0xb6,0x8f = txa
0x94,0x00,0x85,0x0c,0x29,0xb2,0xbe,0x83 = mod 0x83beb229
0x9c,0x00,0x30,0x3f,0x9d,0x33,0x89,0x50 = mod x
0xa1,0x00,0x53,0x03,0xdd,0xdf,0xd4,0xe3 = ldx 4*([0xe3d4dfdd]&0xf)
0xa4,0x00,0x66,0x8f,0x3c,0xde,0xe2,0x4d = xor 0x4de2de3c
0xac,0x00,0x02,0x2f,0x1e,0xe3,0x2e,0x84 = xor x
