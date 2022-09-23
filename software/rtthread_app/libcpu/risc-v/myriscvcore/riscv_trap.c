#include <rtthread.h>
#include "riscv.h"

static riscv_trap_handler_t riscv_trap_int_handler[RISCV_TRAP_INT_NUM];
static riscv_trap_handler_t riscv_trap_exc_handler[RISCV_TRAP_EXC_NUM];

void riscv_trap_handler_entry();

void enable_systimer_irq()
{
    __RV_CSR_SET(CSR_MIE, MIE_MTIE);
}

void disable_systimer_irq()
{
    __RV_CSR_CLEAR(CSR_MIE, MIE_MTIE);
}

void enable_software_irq()
{
    __RV_CSR_SET(CSR_MIE, MIE_MSIE);
}

void disable_software_irq()
{
    __RV_CSR_CLEAR(CSR_MIE, MIE_MSIE);
}

void enable_external_irq()
{
    __RV_CSR_SET(CSR_MIE, MIE_MEIE);
}

void disable_external_irq()
{
    __RV_CSR_CLEAR(CSR_MIE, MIE_MEIE);
}

static void default_trap_handler(riscv_trap_arg_t arg)
{
    rt_kprintf("Unhandled Trap!\n");
    while(1);
}

void core_exception_handler(unsigned long mcause, unsigned long sp)
{
    rt_uint32_t trap_id = mcause & (~(1 << 31));
    struct riscv_trap_arg arg;
    arg.trap_id = trap_id;

    if(mcause & (1 << 31))
    {
        RT_ASSERT(trap_id < RISCV_TRAP_INT_NUM);
        arg.is_interrupt = RT_TRUE;
        riscv_trap_int_handler[trap_id](&arg);
    }
    else
    {
        RT_ASSERT(trap_id < RISCV_TRAP_EXC_NUM);
        arg.is_interrupt = RT_FALSE;
        riscv_trap_exc_handler[trap_id](&arg);
    }
    
}

void riscv_trap_vector_init()
{
    rt_uint32_t i;

    __RV_CSR_WRITE(CSR_MTVEC, (uint32_t)riscv_trap_handler_entry);

    for(i = 0;i < RISCV_TRAP_INT_NUM;i++)
    {
        riscv_trap_int_handler[i] = default_trap_handler;
    }

    for(i = 0;i < RISCV_TRAP_EXC_NUM;i++)
    {
        riscv_trap_exc_handler[i] = default_trap_handler;
    }
}

void riscv_set_trap_int_handler(rt_uint32_t trap_id,riscv_trap_handler_t handler)
{
    RT_ASSERT(trap_id < RISCV_TRAP_INT_NUM);
    riscv_trap_int_handler[trap_id] = handler;
}

void riscv_set_trap_exc_handler(rt_uint32_t trap_id,riscv_trap_handler_t handler)
{
    RT_ASSERT(trap_id < RISCV_TRAP_EXC_NUM);
    riscv_trap_exc_handler[trap_id] = handler;
}

void riscv_clear_trap_int_handler(rt_uint32_t trap_id)
{
    RT_ASSERT(trap_id < RISCV_TRAP_INT_NUM);
    riscv_trap_int_handler[trap_id] = default_trap_handler;
}

void riscv_clear_trap_exc_handler(rt_uint32_t trap_id)
{
    RT_ASSERT(trap_id < RISCV_TRAP_EXC_NUM);
    riscv_trap_exc_handler[trap_id] = default_trap_handler;
}