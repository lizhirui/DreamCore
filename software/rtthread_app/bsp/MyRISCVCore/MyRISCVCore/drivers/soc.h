#ifndef __SOC_H__
#define __SOC_H__

    #define SYSFREQ 50000000UL

    #define get_array_length(x) (sizeof(x) / sizeof(x[0]))
    #define get_struct_member_size(type,member) (sizeof(((type *)0) -> member))
    #define get_struct_member_offset(type,member) ((rt_uint32_t)&(((type *)0) -> member))

    #include "riscv.h"
    #include "drv_uart.h"
    #include "clint.h"
    #include "drv_systimer.h"

#endif