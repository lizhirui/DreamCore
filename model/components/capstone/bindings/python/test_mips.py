#!/usr/bin/env python

# Capstone Python bindings, by Nguyen Anh Quynnh <aquynh@gmail.com>
from __future__ import print_function
from capstone import *
from capstone.mips import *
from xprint import to_hex, to_x


MIPS_CODE = b"\x0C\x10\x00\x97\x00\x00\x00\x00\x24\x02\x00\x0c\x8f\xa2\x00\x00\x34\x21\x34\x56"
MIPS_CODE2 = b"\x56\x34\x21\x34\xc2\x17\x01\x00"
MIPS_32R6M = b"\x00\x07\x00\x07\x00\x11\x93\x7c\x01\x8c\x8b\x7c\x00\xc7\x48\xd0"
MIPS_32R6 = b"\xec\x80\x00\x19\x7c\x43\x22\xa0"

all_tests = (
        (CS_ARCH_MIPS, CS_MODE_MIPS32 + CS_MODE_BIG_ENDIAN, MIPS_CODE, "MIPS-32 (Big-endian)"),
        (CS_ARCH_MIPS, CS_MODE_MIPS64 + CS_MODE_LITTLE_ENDIAN, MIPS_CODE2, "MIPS-64-EL (Little-endian)"),
        (CS_ARCH_MIPS, CS_MODE_MIPS32R6 + CS_MODE_MICRO + CS_MODE_BIG_ENDIAN, MIPS_32R6M, "MIPS-32R6 | Micro (Big-endian)"),
        (CS_ARCH_MIPS, CS_MODE_MIPS32R6 + CS_MODE_BIG_ENDIAN, MIPS_32R6, "MIPS-32R6 (Big-endian)"),
)


def print_insn_detail(insn):
    # print address, mnemonic and operands
    print("0x%x:\t%s\t%s" % (insn.address, insn.mnemonic, insn.op_str))

    # "data" instruction generated by SKIPDATA option has no detail
    if insn.id == 0:
        return

    if len(insn.operands) > 0:
        print("\top_count: %u" % len(insn.operands))
        c = -1
        for i in insn.operands:
            c += 1
            if i.type == MIPS_OP_REG:
                print("\t\toperands[%u].type: REG = %s" % (c, insn.reg_name(i.reg)))
            if i.type == MIPS_OP_IMM:
                print("\t\toperands[%u].type: IMM = 0x%s" % (c, to_x(i.imm)))
            if i.type == MIPS_OP_MEM:
                print("\t\toperands[%u].type: MEM" % c)
                if i.mem.base != 0:
                    print("\t\t\toperands[%u].mem.base: REG = %s" \
                        % (c, insn.reg_name(i.mem.base)))
                if i.mem.disp != 0:
                    print("\t\t\toperands[%u].mem.disp: 0x%s" \
                        % (c, to_x(i.mem.disp)))


# ## Test class Cs
def test_class():
    for (arch, mode, code, comment) in all_tests:
        print("*" * 16)
        print("Platform: %s" % comment)
        print("Code: %s" % to_hex(code))
        print("Disasm:")

        try:
            md = Cs(arch, mode)
            md.detail = True
            for insn in md.disasm(code, 0x1000):
                print_insn_detail(insn)
                print()

            print("0x%x:\n" % (insn.address + insn.size))
        except CsError as e:
            print("ERROR: %s" % e)


if __name__ == '__main__':
    test_class()
