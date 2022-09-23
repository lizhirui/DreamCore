#ifndef __CLINT_H__
#define __CLINT_H__

    typedef struct clint
    {
        __IOM rt_uint32_t MSIP;             /* Offset: 0x0000 (R/W) Software Interrupt Register */
        rt_uint32_t resv0[(0x2000 - 0x0000 - sizeof(rt_uint32_t)) / sizeof(rt_uint32_t)];
        __IOM rt_uint32_t timer_en_reserved;         /* Offset: 0x2000 (R/W) System Timer Enable Register */
        rt_uint32_t resv1[(0x4000 - 0x2000 - sizeof(rt_uint32_t)) / sizeof(rt_uint32_t)];
        __IOM rt_uint64_t timer_cmp;      /* Offset: 0x4000 (R/W) System Timer Current Value Register */
        rt_uint32_t resv2[(0xBFF8 - 0x4000 - sizeof(rt_uint64_t)) / sizeof(rt_uint32_t)];
        __IOM rt_uint64_t timer_value;        /* Offset: 0xBFF8 (R/W) System Timer Compare Value Register */
    }*clint_t;

    #define CLINT_BASEADDR 0x20000000

    #define CLINT_MSIP_FLAG (1U << 0)

    void clint_yield_swi();
    void clint_clear_swi_flag();

#endif