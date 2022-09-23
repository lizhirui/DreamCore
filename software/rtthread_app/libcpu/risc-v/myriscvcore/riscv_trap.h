#ifndef __RISCV_TRAP_H__
#define __RISCV_TRAP_H__

    void enable_systimer_irq();
    void disable_systimer_irq();
    void enable_software_irq();
    void disable_software_irq();
    void enable_external_irq();
    void disable_external_irq();

    #define RISCV_TRAP_INT_NUM 12
    #define RISCV_TRAP_EXC_NUM 12

    #define RISCV_TRAP_INT_MACHINE_SOFTWARE 3
    #define RISCV_TRAP_INT_MACHINE_TIMER 7
    #define RISCV_TRAP_INT_MACHINE_EXTERNAL 11

    #define RISCV_TRAP_EXC_INSTRUCTION_ADDRESS_MISALIGNED 0
    #define RISCV_TRAP_EXC_INSTRUCTION_ACCESS_FAULT 1
    #define RISCV_TRAP_EXC_ILLEGAL_INSTRUCTION 2
    #define RISCV_TRAP_EXC_BREAKPOINT 3
    #define RISCV_TRAP_EXC_LOAD_ADDRESS_MISALIGNED 4
    #define RISCV_TRAP_EXC_LOAD_ACCESS_FAULT 5
    #define RISCV_TRAP_EXC_STORE_AMO_ADDRESS_MISALIGNED 6
    #define RISCV_TRAP_EXC_STORE_AMO_ACCESS_FAULT 7
    #define RISCV_TRAP_EXC_ENVIRONMENT_CALL_FROM_M_MODE 11

    typedef struct riscv_trap_arg
    {
        rt_bool_t is_interrupt;
        rt_uint32_t trap_id;
    }*riscv_trap_arg_t;

    typedef void (*riscv_trap_handler_t)(riscv_trap_arg_t);
    void enable_systimer_irq();
    void disable_systimer_irq();
    void enable_software_irq();
    void disable_software_irq();
    void enable_external_irq();
    void disable_external_irq();
    void riscv_trap_vector_init();
    void riscv_set_trap_int_handler(rt_uint32_t trap_id,riscv_trap_handler_t handler);
    void riscv_set_trap_exc_handler(rt_uint32_t trap_id,riscv_trap_handler_t handler);
    void riscv_clear_trap_int_handler(rt_uint32_t trap_id);
    void riscv_clear_trap_exc_handler(rt_uint32_t trap_id);

#endif