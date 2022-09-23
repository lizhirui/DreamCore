(* For Capstone Engine. AUTO-GENERATED FILE, DO NOT EDIT [arm_const.ml] *)

let _ARM_SFT_INVALID = 0;;
let _ARM_SFT_ASR = 1;;
let _ARM_SFT_LSL = 2;;
let _ARM_SFT_LSR = 3;;
let _ARM_SFT_ROR = 4;;
let _ARM_SFT_RRX = 5;;
let _ARM_SFT_ASR_REG = 6;;
let _ARM_SFT_LSL_REG = 7;;
let _ARM_SFT_LSR_REG = 8;;
let _ARM_SFT_ROR_REG = 9;;
let _ARM_SFT_RRX_REG = 10;;

let _ARM_CC_INVALID = 0;;
let _ARM_CC_EQ = 1;;
let _ARM_CC_NE = 2;;
let _ARM_CC_HS = 3;;
let _ARM_CC_LO = 4;;
let _ARM_CC_MI = 5;;
let _ARM_CC_PL = 6;;
let _ARM_CC_VS = 7;;
let _ARM_CC_VC = 8;;
let _ARM_CC_HI = 9;;
let _ARM_CC_LS = 10;;
let _ARM_CC_GE = 11;;
let _ARM_CC_LT = 12;;
let _ARM_CC_GT = 13;;
let _ARM_CC_LE = 14;;
let _ARM_CC_AL = 15;;

let _ARM_SYSREG_INVALID = 0;;
let _ARM_SYSREG_SPSR_C = 1;;
let _ARM_SYSREG_SPSR_X = 2;;
let _ARM_SYSREG_SPSR_S = 4;;
let _ARM_SYSREG_SPSR_F = 8;;
let _ARM_SYSREG_CPSR_C = 16;;
let _ARM_SYSREG_CPSR_X = 32;;
let _ARM_SYSREG_CPSR_S = 64;;
let _ARM_SYSREG_CPSR_F = 128;;
let _ARM_SYSREG_APSR = 256;;
let _ARM_SYSREG_APSR_G = 257;;
let _ARM_SYSREG_APSR_NZCVQ = 258;;
let _ARM_SYSREG_APSR_NZCVQG = 259;;
let _ARM_SYSREG_IAPSR = 260;;
let _ARM_SYSREG_IAPSR_G = 261;;
let _ARM_SYSREG_IAPSR_NZCVQG = 262;;
let _ARM_SYSREG_IAPSR_NZCVQ = 263;;
let _ARM_SYSREG_EAPSR = 264;;
let _ARM_SYSREG_EAPSR_G = 265;;
let _ARM_SYSREG_EAPSR_NZCVQG = 266;;
let _ARM_SYSREG_EAPSR_NZCVQ = 267;;
let _ARM_SYSREG_XPSR = 268;;
let _ARM_SYSREG_XPSR_G = 269;;
let _ARM_SYSREG_XPSR_NZCVQG = 270;;
let _ARM_SYSREG_XPSR_NZCVQ = 271;;
let _ARM_SYSREG_IPSR = 272;;
let _ARM_SYSREG_EPSR = 273;;
let _ARM_SYSREG_IEPSR = 274;;
let _ARM_SYSREG_MSP = 275;;
let _ARM_SYSREG_PSP = 276;;
let _ARM_SYSREG_PRIMASK = 277;;
let _ARM_SYSREG_BASEPRI = 278;;
let _ARM_SYSREG_BASEPRI_MAX = 279;;
let _ARM_SYSREG_FAULTMASK = 280;;
let _ARM_SYSREG_CONTROL = 281;;
let _ARM_SYSREG_MSPLIM = 282;;
let _ARM_SYSREG_PSPLIM = 283;;
let _ARM_SYSREG_MSP_NS = 284;;
let _ARM_SYSREG_PSP_NS = 285;;
let _ARM_SYSREG_MSPLIM_NS = 286;;
let _ARM_SYSREG_PSPLIM_NS = 287;;
let _ARM_SYSREG_PRIMASK_NS = 288;;
let _ARM_SYSREG_BASEPRI_NS = 289;;
let _ARM_SYSREG_FAULTMASK_NS = 290;;
let _ARM_SYSREG_CONTROL_NS = 291;;
let _ARM_SYSREG_SP_NS = 292;;
let _ARM_SYSREG_R8_USR = 293;;
let _ARM_SYSREG_R9_USR = 294;;
let _ARM_SYSREG_R10_USR = 295;;
let _ARM_SYSREG_R11_USR = 296;;
let _ARM_SYSREG_R12_USR = 297;;
let _ARM_SYSREG_SP_USR = 298;;
let _ARM_SYSREG_LR_USR = 299;;
let _ARM_SYSREG_R8_FIQ = 300;;
let _ARM_SYSREG_R9_FIQ = 301;;
let _ARM_SYSREG_R10_FIQ = 302;;
let _ARM_SYSREG_R11_FIQ = 303;;
let _ARM_SYSREG_R12_FIQ = 304;;
let _ARM_SYSREG_SP_FIQ = 305;;
let _ARM_SYSREG_LR_FIQ = 306;;
let _ARM_SYSREG_LR_IRQ = 307;;
let _ARM_SYSREG_SP_IRQ = 308;;
let _ARM_SYSREG_LR_SVC = 309;;
let _ARM_SYSREG_SP_SVC = 310;;
let _ARM_SYSREG_LR_ABT = 311;;
let _ARM_SYSREG_SP_ABT = 312;;
let _ARM_SYSREG_LR_UND = 313;;
let _ARM_SYSREG_SP_UND = 314;;
let _ARM_SYSREG_LR_MON = 315;;
let _ARM_SYSREG_SP_MON = 316;;
let _ARM_SYSREG_ELR_HYP = 317;;
let _ARM_SYSREG_SP_HYP = 318;;
let _ARM_SYSREG_SPSR_FIQ = 319;;
let _ARM_SYSREG_SPSR_IRQ = 320;;
let _ARM_SYSREG_SPSR_SVC = 321;;
let _ARM_SYSREG_SPSR_ABT = 322;;
let _ARM_SYSREG_SPSR_UND = 323;;
let _ARM_SYSREG_SPSR_MON = 324;;
let _ARM_SYSREG_SPSR_HYP = 325;;

let _ARM_MB_INVALID = 0;;
let _ARM_MB_RESERVED_0 = 1;;
let _ARM_MB_OSHLD = 2;;
let _ARM_MB_OSHST = 3;;
let _ARM_MB_OSH = 4;;
let _ARM_MB_RESERVED_4 = 5;;
let _ARM_MB_NSHLD = 6;;
let _ARM_MB_NSHST = 7;;
let _ARM_MB_NSH = 8;;
let _ARM_MB_RESERVED_8 = 9;;
let _ARM_MB_ISHLD = 10;;
let _ARM_MB_ISHST = 11;;
let _ARM_MB_ISH = 12;;
let _ARM_MB_RESERVED_12 = 13;;
let _ARM_MB_LD = 14;;
let _ARM_MB_ST = 15;;
let _ARM_MB_SY = 16;;

let _ARM_OP_INVALID = 0;;
let _ARM_OP_REG = 1;;
let _ARM_OP_IMM = 2;;
let _ARM_OP_MEM = 3;;
let _ARM_OP_FP = 4;;
let _ARM_OP_CIMM = 64;;
let _ARM_OP_PIMM = 65;;
let _ARM_OP_SETEND = 66;;
let _ARM_OP_SYSREG = 67;;

let _ARM_SETEND_INVALID = 0;;
let _ARM_SETEND_BE = 1;;
let _ARM_SETEND_LE = 2;;

let _ARM_CPSMODE_INVALID = 0;;
let _ARM_CPSMODE_IE = 2;;
let _ARM_CPSMODE_ID = 3;;

let _ARM_CPSFLAG_INVALID = 0;;
let _ARM_CPSFLAG_F = 1;;
let _ARM_CPSFLAG_I = 2;;
let _ARM_CPSFLAG_A = 4;;
let _ARM_CPSFLAG_NONE = 16;;

let _ARM_VECTORDATA_INVALID = 0;;
let _ARM_VECTORDATA_I8 = 1;;
let _ARM_VECTORDATA_I16 = 2;;
let _ARM_VECTORDATA_I32 = 3;;
let _ARM_VECTORDATA_I64 = 4;;
let _ARM_VECTORDATA_S8 = 5;;
let _ARM_VECTORDATA_S16 = 6;;
let _ARM_VECTORDATA_S32 = 7;;
let _ARM_VECTORDATA_S64 = 8;;
let _ARM_VECTORDATA_U8 = 9;;
let _ARM_VECTORDATA_U16 = 10;;
let _ARM_VECTORDATA_U32 = 11;;
let _ARM_VECTORDATA_U64 = 12;;
let _ARM_VECTORDATA_P8 = 13;;
let _ARM_VECTORDATA_F16 = 14;;
let _ARM_VECTORDATA_F32 = 15;;
let _ARM_VECTORDATA_F64 = 16;;
let _ARM_VECTORDATA_F16F64 = 17;;
let _ARM_VECTORDATA_F64F16 = 18;;
let _ARM_VECTORDATA_F32F16 = 19;;
let _ARM_VECTORDATA_F16F32 = 20;;
let _ARM_VECTORDATA_F64F32 = 21;;
let _ARM_VECTORDATA_F32F64 = 22;;
let _ARM_VECTORDATA_S32F32 = 23;;
let _ARM_VECTORDATA_U32F32 = 24;;
let _ARM_VECTORDATA_F32S32 = 25;;
let _ARM_VECTORDATA_F32U32 = 26;;
let _ARM_VECTORDATA_F64S16 = 27;;
let _ARM_VECTORDATA_F32S16 = 28;;
let _ARM_VECTORDATA_F64S32 = 29;;
let _ARM_VECTORDATA_S16F64 = 30;;
let _ARM_VECTORDATA_S16F32 = 31;;
let _ARM_VECTORDATA_S32F64 = 32;;
let _ARM_VECTORDATA_U16F64 = 33;;
let _ARM_VECTORDATA_U16F32 = 34;;
let _ARM_VECTORDATA_U32F64 = 35;;
let _ARM_VECTORDATA_F64U16 = 36;;
let _ARM_VECTORDATA_F32U16 = 37;;
let _ARM_VECTORDATA_F64U32 = 38;;
let _ARM_VECTORDATA_F16U16 = 39;;
let _ARM_VECTORDATA_U16F16 = 40;;
let _ARM_VECTORDATA_F16U32 = 41;;
let _ARM_VECTORDATA_U32F16 = 42;;

let _ARM_REG_INVALID = 0;;
let _ARM_REG_APSR = 1;;
let _ARM_REG_APSR_NZCV = 2;;
let _ARM_REG_CPSR = 3;;
let _ARM_REG_FPEXC = 4;;
let _ARM_REG_FPINST = 5;;
let _ARM_REG_FPSCR = 6;;
let _ARM_REG_FPSCR_NZCV = 7;;
let _ARM_REG_FPSID = 8;;
let _ARM_REG_ITSTATE = 9;;
let _ARM_REG_LR = 10;;
let _ARM_REG_PC = 11;;
let _ARM_REG_SP = 12;;
let _ARM_REG_SPSR = 13;;
let _ARM_REG_D0 = 14;;
let _ARM_REG_D1 = 15;;
let _ARM_REG_D2 = 16;;
let _ARM_REG_D3 = 17;;
let _ARM_REG_D4 = 18;;
let _ARM_REG_D5 = 19;;
let _ARM_REG_D6 = 20;;
let _ARM_REG_D7 = 21;;
let _ARM_REG_D8 = 22;;
let _ARM_REG_D9 = 23;;
let _ARM_REG_D10 = 24;;
let _ARM_REG_D11 = 25;;
let _ARM_REG_D12 = 26;;
let _ARM_REG_D13 = 27;;
let _ARM_REG_D14 = 28;;
let _ARM_REG_D15 = 29;;
let _ARM_REG_D16 = 30;;
let _ARM_REG_D17 = 31;;
let _ARM_REG_D18 = 32;;
let _ARM_REG_D19 = 33;;
let _ARM_REG_D20 = 34;;
let _ARM_REG_D21 = 35;;
let _ARM_REG_D22 = 36;;
let _ARM_REG_D23 = 37;;
let _ARM_REG_D24 = 38;;
let _ARM_REG_D25 = 39;;
let _ARM_REG_D26 = 40;;
let _ARM_REG_D27 = 41;;
let _ARM_REG_D28 = 42;;
let _ARM_REG_D29 = 43;;
let _ARM_REG_D30 = 44;;
let _ARM_REG_D31 = 45;;
let _ARM_REG_FPINST2 = 46;;
let _ARM_REG_MVFR0 = 47;;
let _ARM_REG_MVFR1 = 48;;
let _ARM_REG_MVFR2 = 49;;
let _ARM_REG_Q0 = 50;;
let _ARM_REG_Q1 = 51;;
let _ARM_REG_Q2 = 52;;
let _ARM_REG_Q3 = 53;;
let _ARM_REG_Q4 = 54;;
let _ARM_REG_Q5 = 55;;
let _ARM_REG_Q6 = 56;;
let _ARM_REG_Q7 = 57;;
let _ARM_REG_Q8 = 58;;
let _ARM_REG_Q9 = 59;;
let _ARM_REG_Q10 = 60;;
let _ARM_REG_Q11 = 61;;
let _ARM_REG_Q12 = 62;;
let _ARM_REG_Q13 = 63;;
let _ARM_REG_Q14 = 64;;
let _ARM_REG_Q15 = 65;;
let _ARM_REG_R0 = 66;;
let _ARM_REG_R1 = 67;;
let _ARM_REG_R2 = 68;;
let _ARM_REG_R3 = 69;;
let _ARM_REG_R4 = 70;;
let _ARM_REG_R5 = 71;;
let _ARM_REG_R6 = 72;;
let _ARM_REG_R7 = 73;;
let _ARM_REG_R8 = 74;;
let _ARM_REG_R9 = 75;;
let _ARM_REG_R10 = 76;;
let _ARM_REG_R11 = 77;;
let _ARM_REG_R12 = 78;;
let _ARM_REG_S0 = 79;;
let _ARM_REG_S1 = 80;;
let _ARM_REG_S2 = 81;;
let _ARM_REG_S3 = 82;;
let _ARM_REG_S4 = 83;;
let _ARM_REG_S5 = 84;;
let _ARM_REG_S6 = 85;;
let _ARM_REG_S7 = 86;;
let _ARM_REG_S8 = 87;;
let _ARM_REG_S9 = 88;;
let _ARM_REG_S10 = 89;;
let _ARM_REG_S11 = 90;;
let _ARM_REG_S12 = 91;;
let _ARM_REG_S13 = 92;;
let _ARM_REG_S14 = 93;;
let _ARM_REG_S15 = 94;;
let _ARM_REG_S16 = 95;;
let _ARM_REG_S17 = 96;;
let _ARM_REG_S18 = 97;;
let _ARM_REG_S19 = 98;;
let _ARM_REG_S20 = 99;;
let _ARM_REG_S21 = 100;;
let _ARM_REG_S22 = 101;;
let _ARM_REG_S23 = 102;;
let _ARM_REG_S24 = 103;;
let _ARM_REG_S25 = 104;;
let _ARM_REG_S26 = 105;;
let _ARM_REG_S27 = 106;;
let _ARM_REG_S28 = 107;;
let _ARM_REG_S29 = 108;;
let _ARM_REG_S30 = 109;;
let _ARM_REG_S31 = 110;;
let _ARM_REG_ENDING = 111;;
let _ARM_REG_R13 = _ARM_REG_SP;;
let _ARM_REG_R14 = _ARM_REG_LR;;
let _ARM_REG_R15 = _ARM_REG_PC;;
let _ARM_REG_SB = _ARM_REG_R9;;
let _ARM_REG_SL = _ARM_REG_R10;;
let _ARM_REG_FP = _ARM_REG_R11;;
let _ARM_REG_IP = _ARM_REG_R12;;

let _ARM_INS_INVALID = 0;;
let _ARM_INS_ADC = 1;;
let _ARM_INS_ADD = 2;;
let _ARM_INS_ADDW = 3;;
let _ARM_INS_ADR = 4;;
let _ARM_INS_AESD = 5;;
let _ARM_INS_AESE = 6;;
let _ARM_INS_AESIMC = 7;;
let _ARM_INS_AESMC = 8;;
let _ARM_INS_AND = 9;;
let _ARM_INS_ASR = 10;;
let _ARM_INS_B = 11;;
let _ARM_INS_BFC = 12;;
let _ARM_INS_BFI = 13;;
let _ARM_INS_BIC = 14;;
let _ARM_INS_BKPT = 15;;
let _ARM_INS_BL = 16;;
let _ARM_INS_BLX = 17;;
let _ARM_INS_BLXNS = 18;;
let _ARM_INS_BX = 19;;
let _ARM_INS_BXJ = 20;;
let _ARM_INS_BXNS = 21;;
let _ARM_INS_CBNZ = 22;;
let _ARM_INS_CBZ = 23;;
let _ARM_INS_CDP = 24;;
let _ARM_INS_CDP2 = 25;;
let _ARM_INS_CLREX = 26;;
let _ARM_INS_CLZ = 27;;
let _ARM_INS_CMN = 28;;
let _ARM_INS_CMP = 29;;
let _ARM_INS_CPS = 30;;
let _ARM_INS_CRC32B = 31;;
let _ARM_INS_CRC32CB = 32;;
let _ARM_INS_CRC32CH = 33;;
let _ARM_INS_CRC32CW = 34;;
let _ARM_INS_CRC32H = 35;;
let _ARM_INS_CRC32W = 36;;
let _ARM_INS_CSDB = 37;;
let _ARM_INS_DBG = 38;;
let _ARM_INS_DCPS1 = 39;;
let _ARM_INS_DCPS2 = 40;;
let _ARM_INS_DCPS3 = 41;;
let _ARM_INS_DFB = 42;;
let _ARM_INS_DMB = 43;;
let _ARM_INS_DSB = 44;;
let _ARM_INS_EOR = 45;;
let _ARM_INS_ERET = 46;;
let _ARM_INS_ESB = 47;;
let _ARM_INS_FADDD = 48;;
let _ARM_INS_FADDS = 49;;
let _ARM_INS_FCMPZD = 50;;
let _ARM_INS_FCMPZS = 51;;
let _ARM_INS_FCONSTD = 52;;
let _ARM_INS_FCONSTS = 53;;
let _ARM_INS_FLDMDBX = 54;;
let _ARM_INS_FLDMIAX = 55;;
let _ARM_INS_FMDHR = 56;;
let _ARM_INS_FMDLR = 57;;
let _ARM_INS_FMSTAT = 58;;
let _ARM_INS_FSTMDBX = 59;;
let _ARM_INS_FSTMIAX = 60;;
let _ARM_INS_FSUBD = 61;;
let _ARM_INS_FSUBS = 62;;
let _ARM_INS_HINT = 63;;
let _ARM_INS_HLT = 64;;
let _ARM_INS_HVC = 65;;
let _ARM_INS_ISB = 66;;
let _ARM_INS_IT = 67;;
let _ARM_INS_LDA = 68;;
let _ARM_INS_LDAB = 69;;
let _ARM_INS_LDAEX = 70;;
let _ARM_INS_LDAEXB = 71;;
let _ARM_INS_LDAEXD = 72;;
let _ARM_INS_LDAEXH = 73;;
let _ARM_INS_LDAH = 74;;
let _ARM_INS_LDC = 75;;
let _ARM_INS_LDC2 = 76;;
let _ARM_INS_LDC2L = 77;;
let _ARM_INS_LDCL = 78;;
let _ARM_INS_LDM = 79;;
let _ARM_INS_LDMDA = 80;;
let _ARM_INS_LDMDB = 81;;
let _ARM_INS_LDMIB = 82;;
let _ARM_INS_LDR = 83;;
let _ARM_INS_LDRB = 84;;
let _ARM_INS_LDRBT = 85;;
let _ARM_INS_LDRD = 86;;
let _ARM_INS_LDREX = 87;;
let _ARM_INS_LDREXB = 88;;
let _ARM_INS_LDREXD = 89;;
let _ARM_INS_LDREXH = 90;;
let _ARM_INS_LDRH = 91;;
let _ARM_INS_LDRHT = 92;;
let _ARM_INS_LDRSB = 93;;
let _ARM_INS_LDRSBT = 94;;
let _ARM_INS_LDRSH = 95;;
let _ARM_INS_LDRSHT = 96;;
let _ARM_INS_LDRT = 97;;
let _ARM_INS_LSL = 98;;
let _ARM_INS_LSR = 99;;
let _ARM_INS_MCR = 100;;
let _ARM_INS_MCR2 = 101;;
let _ARM_INS_MCRR = 102;;
let _ARM_INS_MCRR2 = 103;;
let _ARM_INS_MLA = 104;;
let _ARM_INS_MLS = 105;;
let _ARM_INS_MOV = 106;;
let _ARM_INS_MOVS = 107;;
let _ARM_INS_MOVT = 108;;
let _ARM_INS_MOVW = 109;;
let _ARM_INS_MRC = 110;;
let _ARM_INS_MRC2 = 111;;
let _ARM_INS_MRRC = 112;;
let _ARM_INS_MRRC2 = 113;;
let _ARM_INS_MRS = 114;;
let _ARM_INS_MSR = 115;;
let _ARM_INS_MUL = 116;;
let _ARM_INS_MVN = 117;;
let _ARM_INS_NEG = 118;;
let _ARM_INS_NOP = 119;;
let _ARM_INS_ORN = 120;;
let _ARM_INS_ORR = 121;;
let _ARM_INS_PKHBT = 122;;
let _ARM_INS_PKHTB = 123;;
let _ARM_INS_PLD = 124;;
let _ARM_INS_PLDW = 125;;
let _ARM_INS_PLI = 126;;
let _ARM_INS_POP = 127;;
let _ARM_INS_PUSH = 128;;
let _ARM_INS_QADD = 129;;
let _ARM_INS_QADD16 = 130;;
let _ARM_INS_QADD8 = 131;;
let _ARM_INS_QASX = 132;;
let _ARM_INS_QDADD = 133;;
let _ARM_INS_QDSUB = 134;;
let _ARM_INS_QSAX = 135;;
let _ARM_INS_QSUB = 136;;
let _ARM_INS_QSUB16 = 137;;
let _ARM_INS_QSUB8 = 138;;
let _ARM_INS_RBIT = 139;;
let _ARM_INS_REV = 140;;
let _ARM_INS_REV16 = 141;;
let _ARM_INS_REVSH = 142;;
let _ARM_INS_RFEDA = 143;;
let _ARM_INS_RFEDB = 144;;
let _ARM_INS_RFEIA = 145;;
let _ARM_INS_RFEIB = 146;;
let _ARM_INS_ROR = 147;;
let _ARM_INS_RRX = 148;;
let _ARM_INS_RSB = 149;;
let _ARM_INS_RSC = 150;;
let _ARM_INS_SADD16 = 151;;
let _ARM_INS_SADD8 = 152;;
let _ARM_INS_SASX = 153;;
let _ARM_INS_SBC = 154;;
let _ARM_INS_SBFX = 155;;
let _ARM_INS_SDIV = 156;;
let _ARM_INS_SEL = 157;;
let _ARM_INS_SETEND = 158;;
let _ARM_INS_SETPAN = 159;;
let _ARM_INS_SEV = 160;;
let _ARM_INS_SEVL = 161;;
let _ARM_INS_SG = 162;;
let _ARM_INS_SHA1C = 163;;
let _ARM_INS_SHA1H = 164;;
let _ARM_INS_SHA1M = 165;;
let _ARM_INS_SHA1P = 166;;
let _ARM_INS_SHA1SU0 = 167;;
let _ARM_INS_SHA1SU1 = 168;;
let _ARM_INS_SHA256H = 169;;
let _ARM_INS_SHA256H2 = 170;;
let _ARM_INS_SHA256SU0 = 171;;
let _ARM_INS_SHA256SU1 = 172;;
let _ARM_INS_SHADD16 = 173;;
let _ARM_INS_SHADD8 = 174;;
let _ARM_INS_SHASX = 175;;
let _ARM_INS_SHSAX = 176;;
let _ARM_INS_SHSUB16 = 177;;
let _ARM_INS_SHSUB8 = 178;;
let _ARM_INS_SMC = 179;;
let _ARM_INS_SMLABB = 180;;
let _ARM_INS_SMLABT = 181;;
let _ARM_INS_SMLAD = 182;;
let _ARM_INS_SMLADX = 183;;
let _ARM_INS_SMLAL = 184;;
let _ARM_INS_SMLALBB = 185;;
let _ARM_INS_SMLALBT = 186;;
let _ARM_INS_SMLALD = 187;;
let _ARM_INS_SMLALDX = 188;;
let _ARM_INS_SMLALTB = 189;;
let _ARM_INS_SMLALTT = 190;;
let _ARM_INS_SMLATB = 191;;
let _ARM_INS_SMLATT = 192;;
let _ARM_INS_SMLAWB = 193;;
let _ARM_INS_SMLAWT = 194;;
let _ARM_INS_SMLSD = 195;;
let _ARM_INS_SMLSDX = 196;;
let _ARM_INS_SMLSLD = 197;;
let _ARM_INS_SMLSLDX = 198;;
let _ARM_INS_SMMLA = 199;;
let _ARM_INS_SMMLAR = 200;;
let _ARM_INS_SMMLS = 201;;
let _ARM_INS_SMMLSR = 202;;
let _ARM_INS_SMMUL = 203;;
let _ARM_INS_SMMULR = 204;;
let _ARM_INS_SMUAD = 205;;
let _ARM_INS_SMUADX = 206;;
let _ARM_INS_SMULBB = 207;;
let _ARM_INS_SMULBT = 208;;
let _ARM_INS_SMULL = 209;;
let _ARM_INS_SMULTB = 210;;
let _ARM_INS_SMULTT = 211;;
let _ARM_INS_SMULWB = 212;;
let _ARM_INS_SMULWT = 213;;
let _ARM_INS_SMUSD = 214;;
let _ARM_INS_SMUSDX = 215;;
let _ARM_INS_SRSDA = 216;;
let _ARM_INS_SRSDB = 217;;
let _ARM_INS_SRSIA = 218;;
let _ARM_INS_SRSIB = 219;;
let _ARM_INS_SSAT = 220;;
let _ARM_INS_SSAT16 = 221;;
let _ARM_INS_SSAX = 222;;
let _ARM_INS_SSUB16 = 223;;
let _ARM_INS_SSUB8 = 224;;
let _ARM_INS_STC = 225;;
let _ARM_INS_STC2 = 226;;
let _ARM_INS_STC2L = 227;;
let _ARM_INS_STCL = 228;;
let _ARM_INS_STL = 229;;
let _ARM_INS_STLB = 230;;
let _ARM_INS_STLEX = 231;;
let _ARM_INS_STLEXB = 232;;
let _ARM_INS_STLEXD = 233;;
let _ARM_INS_STLEXH = 234;;
let _ARM_INS_STLH = 235;;
let _ARM_INS_STM = 236;;
let _ARM_INS_STMDA = 237;;
let _ARM_INS_STMDB = 238;;
let _ARM_INS_STMIB = 239;;
let _ARM_INS_STR = 240;;
let _ARM_INS_STRB = 241;;
let _ARM_INS_STRBT = 242;;
let _ARM_INS_STRD = 243;;
let _ARM_INS_STREX = 244;;
let _ARM_INS_STREXB = 245;;
let _ARM_INS_STREXD = 246;;
let _ARM_INS_STREXH = 247;;
let _ARM_INS_STRH = 248;;
let _ARM_INS_STRHT = 249;;
let _ARM_INS_STRT = 250;;
let _ARM_INS_SUB = 251;;
let _ARM_INS_SUBS = 252;;
let _ARM_INS_SUBW = 253;;
let _ARM_INS_SVC = 254;;
let _ARM_INS_SWP = 255;;
let _ARM_INS_SWPB = 256;;
let _ARM_INS_SXTAB = 257;;
let _ARM_INS_SXTAB16 = 258;;
let _ARM_INS_SXTAH = 259;;
let _ARM_INS_SXTB = 260;;
let _ARM_INS_SXTB16 = 261;;
let _ARM_INS_SXTH = 262;;
let _ARM_INS_TBB = 263;;
let _ARM_INS_TBH = 264;;
let _ARM_INS_TEQ = 265;;
let _ARM_INS_TRAP = 266;;
let _ARM_INS_TSB = 267;;
let _ARM_INS_TST = 268;;
let _ARM_INS_TT = 269;;
let _ARM_INS_TTA = 270;;
let _ARM_INS_TTAT = 271;;
let _ARM_INS_TTT = 272;;
let _ARM_INS_UADD16 = 273;;
let _ARM_INS_UADD8 = 274;;
let _ARM_INS_UASX = 275;;
let _ARM_INS_UBFX = 276;;
let _ARM_INS_UDF = 277;;
let _ARM_INS_UDIV = 278;;
let _ARM_INS_UHADD16 = 279;;
let _ARM_INS_UHADD8 = 280;;
let _ARM_INS_UHASX = 281;;
let _ARM_INS_UHSAX = 282;;
let _ARM_INS_UHSUB16 = 283;;
let _ARM_INS_UHSUB8 = 284;;
let _ARM_INS_UMAAL = 285;;
let _ARM_INS_UMLAL = 286;;
let _ARM_INS_UMULL = 287;;
let _ARM_INS_UQADD16 = 288;;
let _ARM_INS_UQADD8 = 289;;
let _ARM_INS_UQASX = 290;;
let _ARM_INS_UQSAX = 291;;
let _ARM_INS_UQSUB16 = 292;;
let _ARM_INS_UQSUB8 = 293;;
let _ARM_INS_USAD8 = 294;;
let _ARM_INS_USADA8 = 295;;
let _ARM_INS_USAT = 296;;
let _ARM_INS_USAT16 = 297;;
let _ARM_INS_USAX = 298;;
let _ARM_INS_USUB16 = 299;;
let _ARM_INS_USUB8 = 300;;
let _ARM_INS_UXTAB = 301;;
let _ARM_INS_UXTAB16 = 302;;
let _ARM_INS_UXTAH = 303;;
let _ARM_INS_UXTB = 304;;
let _ARM_INS_UXTB16 = 305;;
let _ARM_INS_UXTH = 306;;
let _ARM_INS_VABA = 307;;
let _ARM_INS_VABAL = 308;;
let _ARM_INS_VABD = 309;;
let _ARM_INS_VABDL = 310;;
let _ARM_INS_VABS = 311;;
let _ARM_INS_VACGE = 312;;
let _ARM_INS_VACGT = 313;;
let _ARM_INS_VACLE = 314;;
let _ARM_INS_VACLT = 315;;
let _ARM_INS_VADD = 316;;
let _ARM_INS_VADDHN = 317;;
let _ARM_INS_VADDL = 318;;
let _ARM_INS_VADDW = 319;;
let _ARM_INS_VAND = 320;;
let _ARM_INS_VBIC = 321;;
let _ARM_INS_VBIF = 322;;
let _ARM_INS_VBIT = 323;;
let _ARM_INS_VBSL = 324;;
let _ARM_INS_VCADD = 325;;
let _ARM_INS_VCEQ = 326;;
let _ARM_INS_VCGE = 327;;
let _ARM_INS_VCGT = 328;;
let _ARM_INS_VCLE = 329;;
let _ARM_INS_VCLS = 330;;
let _ARM_INS_VCLT = 331;;
let _ARM_INS_VCLZ = 332;;
let _ARM_INS_VCMLA = 333;;
let _ARM_INS_VCMP = 334;;
let _ARM_INS_VCMPE = 335;;
let _ARM_INS_VCNT = 336;;
let _ARM_INS_VCVT = 337;;
let _ARM_INS_VCVTA = 338;;
let _ARM_INS_VCVTB = 339;;
let _ARM_INS_VCVTM = 340;;
let _ARM_INS_VCVTN = 341;;
let _ARM_INS_VCVTP = 342;;
let _ARM_INS_VCVTR = 343;;
let _ARM_INS_VCVTT = 344;;
let _ARM_INS_VDIV = 345;;
let _ARM_INS_VDUP = 346;;
let _ARM_INS_VEOR = 347;;
let _ARM_INS_VEXT = 348;;
let _ARM_INS_VFMA = 349;;
let _ARM_INS_VFMS = 350;;
let _ARM_INS_VFNMA = 351;;
let _ARM_INS_VFNMS = 352;;
let _ARM_INS_VHADD = 353;;
let _ARM_INS_VHSUB = 354;;
let _ARM_INS_VINS = 355;;
let _ARM_INS_VJCVT = 356;;
let _ARM_INS_VLD1 = 357;;
let _ARM_INS_VLD2 = 358;;
let _ARM_INS_VLD3 = 359;;
let _ARM_INS_VLD4 = 360;;
let _ARM_INS_VLDMDB = 361;;
let _ARM_INS_VLDMIA = 362;;
let _ARM_INS_VLDR = 363;;
let _ARM_INS_VLLDM = 364;;
let _ARM_INS_VLSTM = 365;;
let _ARM_INS_VMAX = 366;;
let _ARM_INS_VMAXNM = 367;;
let _ARM_INS_VMIN = 368;;
let _ARM_INS_VMINNM = 369;;
let _ARM_INS_VMLA = 370;;
let _ARM_INS_VMLAL = 371;;
let _ARM_INS_VMLS = 372;;
let _ARM_INS_VMLSL = 373;;
let _ARM_INS_VMOV = 374;;
let _ARM_INS_VMOVL = 375;;
let _ARM_INS_VMOVN = 376;;
let _ARM_INS_VMOVX = 377;;
let _ARM_INS_VMRS = 378;;
let _ARM_INS_VMSR = 379;;
let _ARM_INS_VMUL = 380;;
let _ARM_INS_VMULL = 381;;
let _ARM_INS_VMVN = 382;;
let _ARM_INS_VNEG = 383;;
let _ARM_INS_VNMLA = 384;;
let _ARM_INS_VNMLS = 385;;
let _ARM_INS_VNMUL = 386;;
let _ARM_INS_VORN = 387;;
let _ARM_INS_VORR = 388;;
let _ARM_INS_VPADAL = 389;;
let _ARM_INS_VPADD = 390;;
let _ARM_INS_VPADDL = 391;;
let _ARM_INS_VPMAX = 392;;
let _ARM_INS_VPMIN = 393;;
let _ARM_INS_VPOP = 394;;
let _ARM_INS_VPUSH = 395;;
let _ARM_INS_VQABS = 396;;
let _ARM_INS_VQADD = 397;;
let _ARM_INS_VQDMLAL = 398;;
let _ARM_INS_VQDMLSL = 399;;
let _ARM_INS_VQDMULH = 400;;
let _ARM_INS_VQDMULL = 401;;
let _ARM_INS_VQMOVN = 402;;
let _ARM_INS_VQMOVUN = 403;;
let _ARM_INS_VQNEG = 404;;
let _ARM_INS_VQRDMLAH = 405;;
let _ARM_INS_VQRDMLSH = 406;;
let _ARM_INS_VQRDMULH = 407;;
let _ARM_INS_VQRSHL = 408;;
let _ARM_INS_VQRSHRN = 409;;
let _ARM_INS_VQRSHRUN = 410;;
let _ARM_INS_VQSHL = 411;;
let _ARM_INS_VQSHLU = 412;;
let _ARM_INS_VQSHRN = 413;;
let _ARM_INS_VQSHRUN = 414;;
let _ARM_INS_VQSUB = 415;;
let _ARM_INS_VRADDHN = 416;;
let _ARM_INS_VRECPE = 417;;
let _ARM_INS_VRECPS = 418;;
let _ARM_INS_VREV16 = 419;;
let _ARM_INS_VREV32 = 420;;
let _ARM_INS_VREV64 = 421;;
let _ARM_INS_VRHADD = 422;;
let _ARM_INS_VRINTA = 423;;
let _ARM_INS_VRINTM = 424;;
let _ARM_INS_VRINTN = 425;;
let _ARM_INS_VRINTP = 426;;
let _ARM_INS_VRINTR = 427;;
let _ARM_INS_VRINTX = 428;;
let _ARM_INS_VRINTZ = 429;;
let _ARM_INS_VRSHL = 430;;
let _ARM_INS_VRSHR = 431;;
let _ARM_INS_VRSHRN = 432;;
let _ARM_INS_VRSQRTE = 433;;
let _ARM_INS_VRSQRTS = 434;;
let _ARM_INS_VRSRA = 435;;
let _ARM_INS_VRSUBHN = 436;;
let _ARM_INS_VSDOT = 437;;
let _ARM_INS_VSELEQ = 438;;
let _ARM_INS_VSELGE = 439;;
let _ARM_INS_VSELGT = 440;;
let _ARM_INS_VSELVS = 441;;
let _ARM_INS_VSHL = 442;;
let _ARM_INS_VSHLL = 443;;
let _ARM_INS_VSHR = 444;;
let _ARM_INS_VSHRN = 445;;
let _ARM_INS_VSLI = 446;;
let _ARM_INS_VSQRT = 447;;
let _ARM_INS_VSRA = 448;;
let _ARM_INS_VSRI = 449;;
let _ARM_INS_VST1 = 450;;
let _ARM_INS_VST2 = 451;;
let _ARM_INS_VST3 = 452;;
let _ARM_INS_VST4 = 453;;
let _ARM_INS_VSTMDB = 454;;
let _ARM_INS_VSTMIA = 455;;
let _ARM_INS_VSTR = 456;;
let _ARM_INS_VSUB = 457;;
let _ARM_INS_VSUBHN = 458;;
let _ARM_INS_VSUBL = 459;;
let _ARM_INS_VSUBW = 460;;
let _ARM_INS_VSWP = 461;;
let _ARM_INS_VTBL = 462;;
let _ARM_INS_VTBX = 463;;
let _ARM_INS_VTRN = 464;;
let _ARM_INS_VTST = 465;;
let _ARM_INS_VUDOT = 466;;
let _ARM_INS_VUZP = 467;;
let _ARM_INS_VZIP = 468;;
let _ARM_INS_WFE = 469;;
let _ARM_INS_WFI = 470;;
let _ARM_INS_YIELD = 471;;
let _ARM_INS_ENDING = 472;;

let _ARM_GRP_INVALID = 0;;
let _ARM_GRP_JUMP = 1;;
let _ARM_GRP_CALL = 2;;
let _ARM_GRP_INT = 4;;
let _ARM_GRP_PRIVILEGE = 6;;
let _ARM_GRP_BRANCH_RELATIVE = 7;;
let _ARM_GRP_CRYPTO = 128;;
let _ARM_GRP_DATABARRIER = 129;;
let _ARM_GRP_DIVIDE = 130;;
let _ARM_GRP_FPARMV8 = 131;;
let _ARM_GRP_MULTPRO = 132;;
let _ARM_GRP_NEON = 133;;
let _ARM_GRP_T2EXTRACTPACK = 134;;
let _ARM_GRP_THUMB2DSP = 135;;
let _ARM_GRP_TRUSTZONE = 136;;
let _ARM_GRP_V4T = 137;;
let _ARM_GRP_V5T = 138;;
let _ARM_GRP_V5TE = 139;;
let _ARM_GRP_V6 = 140;;
let _ARM_GRP_V6T2 = 141;;
let _ARM_GRP_V7 = 142;;
let _ARM_GRP_V8 = 143;;
let _ARM_GRP_VFP2 = 144;;
let _ARM_GRP_VFP3 = 145;;
let _ARM_GRP_VFP4 = 146;;
let _ARM_GRP_ARM = 147;;
let _ARM_GRP_MCLASS = 148;;
let _ARM_GRP_NOTMCLASS = 149;;
let _ARM_GRP_THUMB = 150;;
let _ARM_GRP_THUMB1ONLY = 151;;
let _ARM_GRP_THUMB2 = 152;;
let _ARM_GRP_PREV8 = 153;;
let _ARM_GRP_FPVMLX = 154;;
let _ARM_GRP_MULOPS = 155;;
let _ARM_GRP_CRC = 156;;
let _ARM_GRP_DPVFP = 157;;
let _ARM_GRP_V6M = 158;;
let _ARM_GRP_VIRTUALIZATION = 159;;
let _ARM_GRP_ENDING = 160;;
