//#define USE_MODEL

    .section .text.entry
    .global _start
_start:
    csrw minstret, zero
    csrw minstreth, zero
    la t0, trap_entry
    csrw mtvec, t0
    li t0, 0x800
    csrw mie, t0
    li t0, 0x00000008
    csrw mstatus, t0

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
#else
    .global send_char
send_char:
    csrw 0x810, a0
send_char_wait:
    csrr t0, 0x810
    srl t0, t0, 31
    bnez t0, send_char_wait
    ret
#endif

trap_entry:
    addi sp, sp, -17 * 4
    sw x1, 0 * 4(sp)
    sw x4, 1 * 4(sp)
    sw x5, 2 * 4(sp)
    sw x6, 3 * 4(sp)
    sw x7, 4 * 4(sp)
    sw x10, 5 * 4(sp)
    sw x11, 6 * 4(sp)
    sw x12, 7 * 4(sp)
    sw x13, 8 * 4(sp)
    sw x14, 9 * 4(sp)
    sw x15, 10 * 4(sp)
    sw x16, 11 * 4(sp)
    sw x17, 12 * 4(sp)
    sw x28, 13 * 4(sp)
    sw x29, 14 * 4(sp)
    sw x30, 15 * 4(sp)
    sw x31, 16 * 4(sp)
    call trap_entry_c
    lw x1, 0 * 4(sp)
    lw x4, 1 * 4(sp)
    lw x5, 2 * 4(sp)
    lw x6, 3 * 4(sp)
    lw x7, 4 * 4(sp)
    lw x10, 5 * 4(sp)
    lw x11, 6 * 4(sp)
    lw x12, 7 * 4(sp)
    lw x13, 8 * 4(sp)
    lw x14, 9 * 4(sp)
    lw x15, 10 * 4(sp)
    lw x16, 11 * 4(sp)
    lw x17, 12 * 4(sp)
    lw x28, 13 * 4(sp)
    lw x29, 14 * 4(sp)
    lw x30, 15 * 4(sp)
    lw x31, 16 * 4(sp)
    addi sp, sp, 17 * 4
    mret

    .global read_mcycle
read_mcycle:
    csrr a0, mcycle
    ret