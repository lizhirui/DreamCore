# CS_ARCH_MIPS, CS_MODE_MIPS32+CS_MODE_MICRO, None
0xe6,0x00,0x58,0x48 = movz $t1, $a2, $a3
0xe6,0x00,0x18,0x48 = movn $t1, $a2, $a3
0x26,0x55,0x7b,0x09 = movt $t1, $a2, $fcc0
0x26,0x55,0x7b,0x01 = movf $t1, $a2, $fcc0
