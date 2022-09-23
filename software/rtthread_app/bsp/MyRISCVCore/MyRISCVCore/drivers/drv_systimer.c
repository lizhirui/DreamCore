#include <rtthread.h>
#include "soc.h"

static clint_t clint = (clint_t)CLINT_BASEADDR;

void systimer_set_load_value(rt_uint64_t value)
{
    clint -> timer_value = value;
}

rt_uint64_t systimer_get_load_value()
{
    return clint -> timer_value;
}

void systimer_set_compare_value(rt_uint64_t value)
{
    clint -> timer_cmp = value;
}

rt_uint64_t systimer_get_compare_value()
{
    return clint -> timer_cmp;
}

void systimer_start()
{
    //clint -> timer_en |= SYSTIMER_TIMER_EN_ENABLE;
}

void systimer_stop()
{
    //clint -> timer_en &= ~SYSTIMER_TIMER_EN_ENABLE;
}

void systick_config(rt_uint64_t ticks)
{
    systimer_set_load_value(0);
    systimer_set_compare_value(ticks);
    enable_systimer_irq();
}

void systick_reload(rt_uint64_t ticks)
{
    rt_uint64_t cur_ticks = clint -> timer_value;
    rt_uint64_t reload_ticks = ticks + cur_ticks;

    if(__USUALLY(reload_ticks > cur_ticks))
    {
        clint -> timer_cmp = reload_ticks;
    }
    else
    {
        clint -> timer_value = 0;
        clint -> timer_cmp = ticks;
    }
}