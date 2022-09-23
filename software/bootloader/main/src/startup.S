//#define USE_MODEL

    .section .text.entry
    .global _start
_start:
    csrw minstret, zero
    csrw minstreth, zero

    li x1, 0
    li x2, 0
    li x3, 0
    li x4, 0
    li x5, 0
    li x6, 0
    li x7, 0
    li x8, 0
    li x9, 0
    li x10, 0
    li x11, 0
    li x12, 0
    li x13, 0
    li x14, 0
    li x15, 0
    li x16, 0
    li x17, 0
    li x18, 0
    li x19, 0
    li x20, 0
    li x21, 0
    li x22, 0
    li x23, 0
    li x24, 0
    li x25, 0
    li x26, 0
    li x27, 0
    li x28, 0
    li x29, 0
    li x30, 0
    li x31, 0

    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop
    la sp, __stack_default

    la t0, __bss_start
    la t1, __bss_end

zero_bss:
    sw x0, 0(t0)
    addi t0, t0, 4
    blt t0, t1, zero_bss

    li a0, 0
    li a1, 0
    call main

#ifdef USE_MODEL
	.global send_char
send_char:
    csrw 0x800, a0
    ret

    .global read_char
read_char:
    csrr a0, 0x800
    li t0, 0x80000000
    and t0, t0, a0
    bnez t0, clear_char
    ret
clear_char:
    li t0, 0x80000000
    csrw 0x800, t0
    andi a0, a0, 0xff
    li t0, 0x40000000
    or a0, a0, t0
    ret
#else
    .global send_char
send_char:
    csrw 0x810, a0
send_char_wait:
    csrr t0, 0x810
    srl t0, t0, 31
    bnez t0, send_char_wait
    ret

    .global read_char
read_char:
    csrr a0, 0x810
    li t0, 0x40000000
    and t0, t0, a0
    bnez t0, clear_char
    ret
clear_char:
    li t0, 0x80000000
    csrw 0x810, t0
    ret
#endif