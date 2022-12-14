/*
 * MOS65XX_GRP_BRANCH_RELATIVE handled elsewhere based on address mode
 * MOS65XX_REG_SP handled elsewhere for push/pop instructions
 * BLOCK moves handled elsewhere.
 * MOS65XX_REG_Y handled elsewhere for abs,y zp, y etc
 * MOS65XX_REG_X handled elsewhere for abs,x zp, x etc
 * MOS65XX_REG_DP handled elsewhere for zp zp,x zp,y etc
 */

	{ "invalid", MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "adc",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_ACC,     true },
	{ "and",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_ACC,     true },
	{ "asl",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "bbr",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "bbs",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "bcc",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "bcs",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "beq",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "bit",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_ACC,     true },
	{ "bmi",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "bne",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "bpl",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "bra",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "brk",     MOS65XX_GRP_INT,             MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "brl",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "bvc",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "bvs",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "clc",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "cld",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "cli",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "clv",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "cmp",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_ACC,     true },
	{ "cop",     MOS65XX_GRP_INT,             MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "cpx",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_X,       true },
	{ "cpy",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_Y,       true },
	{ "dec",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "dex",     MOS65XX_GRP_INVALID,         MOS65XX_REG_X,       MOS65XX_REG_X,       true },
	{ "dey",     MOS65XX_GRP_INVALID,         MOS65XX_REG_Y,       MOS65XX_REG_Y,       true },
	{ "eor",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_ACC,     true },
	{ "inc",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "inx",     MOS65XX_GRP_INVALID,         MOS65XX_REG_X,       MOS65XX_REG_X,       true },
	{ "iny",     MOS65XX_GRP_INVALID,         MOS65XX_REG_Y,       MOS65XX_REG_Y,       true },
	{ "jml",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "jmp",     MOS65XX_GRP_JUMP,            MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "jsl",     MOS65XX_GRP_CALL,            MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "jsr",     MOS65XX_GRP_CALL,            MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "lda",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_INVALID, true },
	{ "ldx",     MOS65XX_GRP_INVALID,         MOS65XX_REG_X,       MOS65XX_REG_INVALID, true },
	{ "ldy",     MOS65XX_GRP_INVALID,         MOS65XX_REG_Y,       MOS65XX_REG_INVALID, true },
	{ "lsr",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "mvn",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "mvp",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "nop",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "ora",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_ACC,     true },
	{ "pea",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "pei",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "per",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "pha",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_ACC,     false },
	{ "phb",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_B,       false },
	{ "phd",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_DP,      false },
	{ "phk",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_K,       false },
	{ "php",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_P,       false },
	{ "phx",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_X,       false },
	{ "phy",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_Y,       false },
	{ "pla",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_INVALID, true },
	{ "plb",     MOS65XX_GRP_INVALID,         MOS65XX_REG_B,       MOS65XX_REG_INVALID, true },
	{ "pld",     MOS65XX_GRP_INVALID,         MOS65XX_REG_DP,      MOS65XX_REG_INVALID, true },
	{ "plp",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "plx",     MOS65XX_GRP_INVALID,         MOS65XX_REG_X,       MOS65XX_REG_INVALID, true },
	{ "ply",     MOS65XX_GRP_INVALID,         MOS65XX_REG_Y,       MOS65XX_REG_INVALID, true },
	{ "rep",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "rmb",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "rol",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "ror",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "rti",     MOS65XX_GRP_IRET,            MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "rtl",     MOS65XX_GRP_RET,             MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "rts",     MOS65XX_GRP_RET,             MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "sbc",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_ACC,     true },
	{ "sec",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "sed",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "sei",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "sep",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },
	{ "smb",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "sta",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_ACC,     false },
	{ "stp",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "stx",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_X,       false },
	{ "sty",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_Y,       false },
	{ "stz",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "tax",     MOS65XX_GRP_INVALID,         MOS65XX_REG_X,       MOS65XX_REG_ACC,     true },
	{ "tay",     MOS65XX_GRP_INVALID,         MOS65XX_REG_Y,       MOS65XX_REG_ACC,     true },
	{ "tcd",     MOS65XX_GRP_INVALID,         MOS65XX_REG_DP,      MOS65XX_REG_ACC,     true },
	{ "tcs",     MOS65XX_GRP_INVALID,         MOS65XX_REG_SP,      MOS65XX_REG_ACC,     false },
	{ "tdc",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_DP,      true },
	{ "trb",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_ACC,     true },
	{ "tsb",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_ACC,     true },
	{ "tsc",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_SP,      true },
	{ "tsx",     MOS65XX_GRP_INVALID,         MOS65XX_REG_X,       MOS65XX_REG_SP,      true },
	{ "txa",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_X,       true },
	{ "txs",     MOS65XX_GRP_INVALID,         MOS65XX_REG_SP,      MOS65XX_REG_X,       false },
	{ "txy",     MOS65XX_GRP_INVALID,         MOS65XX_REG_Y,       MOS65XX_REG_X,       true },
	{ "tya",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_Y,       true },
	{ "tyx",     MOS65XX_GRP_INVALID,         MOS65XX_REG_X,       MOS65XX_REG_Y,       true },
	{ "wai",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "wdm",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, false },
	{ "xba",     MOS65XX_GRP_INVALID,         MOS65XX_REG_ACC,     MOS65XX_REG_ACC,     true },
	{ "xce",     MOS65XX_GRP_INVALID,         MOS65XX_REG_INVALID, MOS65XX_REG_INVALID, true },