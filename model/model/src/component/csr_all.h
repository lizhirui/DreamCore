#pragma once
#include "./csr/marchid.h"
#include "./csr/mcause.h"
#include "./csr/mconfigptr.h"
#include "./csr/mcounteren.h"
#include "./csr/mcycle.h"
#include "./csr/mcycleh.h"
#include "./csr/mepc.h"
#include "./csr/mhartid.h"
#include "./csr/mie.h"
#include "./csr/mimpid.h"
#include "./csr/minstret.h"
#include "./csr/minstreth.h"
#include "./csr/mip.h"
#include "./csr/misa.h"
#include "./csr/mscratch.h"
#include "./csr/mstatus.h"
#include "./csr/mstatush.h"
#include "./csr/mtval.h"
#include "./csr/mtvec.h"
#include "./csr/mvendorid.h"
#include "./csr/pmpaddr.h"
#include "./csr/pmpcfg.h"
#include "./csr/charfifo.h"
#include "./csr/finish.h"
#include "./csr/mhpmcounter.h"
#include "./csr/mhpmcounterh.h"

#define CSR_MVENDORID 0xf11
#define CSR_MARCHID 0xf12
#define CSR_MIMPID 0xf13
#define CSR_MHARTID 0xf14
#define CSR_MCONFIGPTR 0xf15
#define CSR_MSTATUS 0x300
#define CSR_MISA 0x301
#define CSR_MIE 0x304
#define CSR_MTVEC 0x305
#define CSR_MCOUNTEREN 0x306
#define CSR_MSTATUSH 0x310
#define CSR_MSCRATCH 0x340
#define CSR_MEPC 0x341
#define CSR_MCAUSE 0x342
#define CSR_MTVAL 0x343
#define CSR_MIP 0x344
#define CSR_CHARFIFO 0x800
#define CSR_FINISH 0x804
#define CSR_MCYCLE 0xB00
#define CSR_MINSTRET 0xB02
#define CSR_MCYCLEH 0xB80
#define CSR_MINSTRETH 0xB82

#define CSR_BRANCHNUM 0xB03
#define CSR_BRANCHNUMH 0xB83
#define CSR_BRANCHPREDICTED 0xB04
#define CSR_BRANCHPREDICTEDH 0xB84
#define CSR_BRANCHHIT 0xB05
#define CSR_BRANCHHITH 0xB85
#define CSR_BRANCHMISS 0xB06
#define CSR_BRANCHMISSH 0xB86
#define CSR_FD 0xB07
#define CSR_FDH 0xB87
#define CSR_DR 0xB08
#define CSR_DRH 0xB88
#define CSR_IQ 0xB09
#define CSR_IQH 0xB89
#define CSR_IE 0xB0A
#define CSR_IEH 0xB8A
#define CSR_CB 0xB0B
#define CSR_CBH 0xB8B
#define CSR_ROB 0xB0C
#define CSR_ROBH 0xB8C
#define CSR_PHY 0xB0D
#define CSR_PHYH 0xB8D
#define CSR_RAS 0xB0E
#define CSR_RASH 0xB8E
#define CSR_FNF 0xB0F
#define CSR_FNFH 0xB8F