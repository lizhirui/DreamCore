#ifndef __DRV_SYSTIMER_H__
#define __DRV_SYSTIMER_H__

    #define SYSTIMER_MSIP_FLAG (1U << 0)
    #define SYSTIMER_TIMER_EN_ENABLE (1U << 0)

    void systimer_set_load_value(rt_uint64_t value);
    rt_uint64_t systimer_get_load_value();
    void systimer_set_compare_value(rt_uint64_t value);
    rt_uint64_t systimer_get_compare_value();
    void systimer_start();
    void systimer_stop();
    void systick_config(rt_uint64_t ticks);
    void systick_reload(rt_uint64_t ticks);

#endif