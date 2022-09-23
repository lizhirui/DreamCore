/*
 * Copyright (c) 2020-2020, AnnikaChip Development Team
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-11-08     lizhirui     first version
 *
 */

#include <rtthread.h>
#include <rtdevice.h>
#include "board.h"
#include "cpuport.h"
#include "soc.h"

/** _end symbol defined in linker script of Nuclei SDK */
extern void *_end;

/** _heap_end symbol defined in linker script of Nuclei SDK */
extern void *_heap_end;
#define HEAP_BEGIN  &_end
#define HEAP_END    &_heap_end

void _fini()
{

}

void rt_hw_drivers_init(void)
{
    #ifdef BSP_USING_UART
        rt_hw_uart_init();
    #endif
}

/**
 * @brief Setup hardware board for rt-thread
 *
 */
void rt_hw_board_init(void)
{
    __disable_irq();
    /* RISC-V Trap Vector Initialization */
    riscv_trap_vector_init();
    /* OS Tick Configuration */
    rt_hw_ticksetup();
#ifdef RT_USING_HEAP
    rt_system_heap_init((void *) HEAP_BEGIN, (void *) HEAP_END);
#endif

    /* Board hardware drivers initialization */
    rt_hw_drivers_init();

    /* Set the shell console output device */
#ifdef RT_USING_CONSOLE
    rt_console_set_device(RT_CONSOLE_DEVICE_NAME);
#endif
    /* Board underlying hardware initialization */
#ifdef RT_USING_COMPONENTS_INIT
    rt_components_board_init();
#endif
    disable_external_irq();
}

/******************** end of file *******************/

