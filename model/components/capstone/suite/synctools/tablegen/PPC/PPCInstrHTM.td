//===-- PPCInstrHTM.td - The PowerPC Hardware Transactional Memory  -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the Hardware Transactional Memory extension to the
// PowerPC instruction set.
//
//===----------------------------------------------------------------------===//



def HasHTM : Predicate<"PPCSubTarget->hasHTM()">;

def HTM_get_imm : SDNodeXForm<imm, [{
  return getI32Imm (N->getZExtValue(), SDLoc(N));
}]>;

let hasSideEffects = 1, usesCustomInserter = 1  in {
def TCHECK_RET : Pseudo<(outs gprc:$out), (ins), "#TCHECK_RET", []>;
def TBEGIN_RET : PPCCustomInserterPseudo<(outs gprc:$out), (ins u1imm:$R), "#TBEGIN_RET", []>;
}


let Predicates = [HasHTM] in {

let Defs = [CR0] in {
def TBEGIN : XForm_htm0 <31, 654,
                         (outs), (ins u1imm:$R), "tbegin. $R", IIC_SprMTSPR, []>;

def TEND : XForm_htm1 <31, 686,
                       (outs), (ins u1imm:$A), "tend. $A", IIC_SprMTSPR, []>;

def TABORT : XForm_base_r3xo <31, 910,
                              (outs), (ins gprc:$A), "tabort. $A", IIC_SprMTSPR,
                              []>, isDOT {
  let RST = 0;
  let B = 0;
}

def TABORTWC : XForm_base_r3xo <31, 782,
                                (outs), (ins u5imm:$RTS, gprc:$A, gprc:$B),
                                "tabortwc. $RTS, $A, $B", IIC_SprMTSPR, []>,
                                isDOT;

def TABORTWCI : XForm_base_r3xo <31, 846,
                                 (outs), (ins u5imm:$RTS, gprc:$A, u5imm:$B),
                                 "tabortwci. $RTS, $A, $B", IIC_SprMTSPR, []>,
                                 isDOT;

def TABORTDC : XForm_base_r3xo <31, 814,
                                (outs), (ins u5imm:$RTS, gprc:$A, gprc:$B),
                                "tabortdc. $RTS, $A, $B", IIC_SprMTSPR, []>,
                                isDOT;

def TABORTDCI : XForm_base_r3xo <31, 878,
                                 (outs), (ins u5imm:$RTS, gprc:$A, u5imm:$B),
                                 "tabortdci. $RTS, $A, $B", IIC_SprMTSPR, []>,
                                 isDOT;

def TSR : XForm_htm2 <31, 750,
                      (outs), (ins u1imm:$L), "tsr. $L", IIC_SprMTSPR, []>,
                      isDOT;

def TRECLAIM : XForm_base_r3xo <31, 942,
                                (outs), (ins gprc:$A), "treclaim. $A",
                                IIC_SprMTSPR, []>,
                                isDOT {
  let RST = 0;
  let B = 0;
}

def TRECHKPT : XForm_base_r3xo <31, 1006,
                                (outs), (ins), "trechkpt.", IIC_SprMTSPR, []>,
                                isDOT {
  let RST = 0;
  let A = 0;
  let B = 0;
}

}//Defs = [CR0]

def TCHECK : XForm_htm3 <31, 718,
                        (outs crrc:$BF), (ins), "tcheck $BF", IIC_SprMTSPR, []>;
// Builtins

// All HTM instructions, with the exception of tcheck, set CR0 with the
// value of the MSR Transaction State (TS) bits that exist before the
// instruction is executed.  For tbegin., the EQ bit in CR0 can be used
// to determine whether the transaction was successfully started (0) or
// failed (1).  We use an XORI pattern to 'flip' the bit to match the
// tbegin builtin API which defines a return value of 1 as success.

def : Pat<(int_ppc_tbegin i32:$R),
           (XORI (TBEGIN_RET(HTM_get_imm imm:$R)), 1)>;

def : Pat<(int_ppc_tend i32:$R),
          (TEND (HTM_get_imm imm:$R))>;

def : Pat<(int_ppc_tabort i32:$R),
          (TABORT $R)>;

def : Pat<(int_ppc_tabortwc i32:$TO, i32:$RA, i32:$RB),
          (TABORTWC (HTM_get_imm imm:$TO), $RA, $RB)>;

def : Pat<(int_ppc_tabortwci i32:$TO, i32:$RA, i32:$SI),
          (TABORTWCI (HTM_get_imm imm:$TO), $RA, (HTM_get_imm imm:$SI))>;

def : Pat<(int_ppc_tabortdc i32:$TO, i32:$RA, i32:$RB),
          (TABORTDC (HTM_get_imm imm:$TO), $RA, $RB)>;

def : Pat<(int_ppc_tabortdci i32:$TO, i32:$RA, i32:$SI),
          (TABORTDCI (HTM_get_imm imm:$TO), $RA, (HTM_get_imm imm:$SI))>;

def : Pat<(int_ppc_tcheck),
          (TCHECK_RET)>;

def : Pat<(int_ppc_treclaim i32:$RA),
          (TRECLAIM $RA)>;

def : Pat<(int_ppc_trechkpt),
          (TRECHKPT)>;

def : Pat<(int_ppc_tsr i32:$L),
          (TSR (HTM_get_imm imm:$L))>;

def : Pat<(int_ppc_get_texasr),
          (MFSPR8 130)>;

def : Pat<(int_ppc_get_texasru),
          (MFSPR8 131)>;

def : Pat<(int_ppc_get_tfhar),
          (MFSPR8 128)>;

def : Pat<(int_ppc_get_tfiar),
          (MFSPR8 129)>;


def : Pat<(int_ppc_set_texasr i64:$V),
          (MTSPR8 130, $V)>;

def : Pat<(int_ppc_set_texasru i64:$V),
          (MTSPR8 131, $V)>;

def : Pat<(int_ppc_set_tfhar i64:$V),
          (MTSPR8 128, $V)>;

def : Pat<(int_ppc_set_tfiar i64:$V),
          (MTSPR8 129, $V)>;


// Extended mnemonics
def : Pat<(int_ppc_tendall),
          (TEND 1)>;

def : Pat<(int_ppc_tresume),
          (TSR 1)>;

def : Pat<(int_ppc_tsuspend),
          (TSR 0)>;

def : Pat<(i64 (int_ppc_ttest)),
          (RLDICL (i64 (COPY (TABORTWCI 0, ZERO, 0))), 36, 28)>;

} // [HasHTM]
