# CS_ARCH_RISCV, CS_MODE_RISCV32, None
0x37,0x34,0x00,0x00 = lui s0, 3
0x97,0x82,0x00,0x00 = auipc t0, 8
0x2f,0xae,0xaa,0x0a = amoswap.w.rl t3, a0, (s5)
0xe3,0x1f,0x31,0x5e = bne sp, gp, 0xdfe
0x73,0x00,0x00,0x00 = ecall
0x33,0x00,0x31,0x02 = mul zero, sp, gp
0x53,0x00,0x31,0x28 = fmin.s ft0, ft2, ft3
0x53,0x10,0x31,0x2a = fmax.d ft0, ft2, ft3
0x27,0xaa,0x6a,0x00 = fsw ft6, 0x14(s5)

// issues 
0xef,0xf0,0x1f,0xff = jal -0x10 
