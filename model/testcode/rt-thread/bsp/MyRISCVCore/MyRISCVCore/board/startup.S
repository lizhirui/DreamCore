/*
 * Copyright (c) 2020-2020, AnnikaChip Development Team
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-11-08     lizhirui     first version
 *
 */

#include "riscv_encoding.h"
    .section .init

    .globl _start
    .type _start,@function

/**
 * Reset Handler called on controller reset
 */
_start:
    /* Initialize all registers */
    li  x1,  0
	li  x2,  0
	li  x3,  0
	li  x4,  0
	li  x5,  0
	li  x6,  0
	li  x7,  0
	li  x8,  0
	li  x9,  0
	li  x10, 0
	li  x11, 0
	li  x12, 0
	li  x13, 0
	li  x14, 0
	li  x15, 0
	li  x16, 0
	li  x17, 0
	li  x18, 0
	li  x19, 0
	li  x20, 0
	li  x21, 0
	li  x22, 0
	li  x23, 0
	li  x24, 0
	li  x25, 0
	li  x26, 0
	li  x27, 0
	li  x28, 0
	li  x29, 0
	li  x30, 0
	li  x31, 0

    /* Initialize Normal Stack defined in linker.ld*/
	la  sp,  _sp
    
    /* ===== Startup Stage 1 ===== */
    /* Disable Global Interrupt */
    csrc CSR_MSTATUS, MSTATUS_MIE
    /* Initialize GP */
    .option push
    .option norelax
    la gp, __global_pointer$

    .option pop
    /*
     * Set Exception Entry MTVEC to exc_entry
     * Due to settings above, Exception and NMI
     * will share common entry.
     */
    la t0, exc_entry
    csrw CSR_MTVEC, t0
    /* ===== Startup Stage 2 ===== */
    /* Disable mcycle and minstret counter */
    csrci CSR_MCOUNTEREN, 0x5

    /* Load data section */
    la a0, _data_lma
    la a1, _data
    la a2, _edata
    bgeu a1, a2, 2f
    1:
    lw t0, (a0)
    sw t0, (a1)
    addi a0, a0, 4
    addi a1, a1, 4
    bltu a1, a2, 1b
    2:

    /* Clear bss section */
    la a0, __bss_start
    la a1, _end
    bgeu a0, a1, 2f
    1:
    sw zero, (a0)
    addi a0, a0, 4
    bltu a0, a1, 1b
    2:

    /* Call global constructors */
    la a0, __libc_fini_array
    call atexit
    /* Call C/C++ constructor start up code */
    call __libc_init_array
    /* ===== Call Main Function  ===== */
    /* argc = argv = envp = 0 */
    li a0, 0
    li a1, 0
    li a2, 0
    call entry

1:
    j 1b
