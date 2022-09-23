#include <rtthread.h>
#include <rtdevice.h>
#include <finsh.h>

#ifdef RT_USING_HWTIMER

#define TIMER   "timer0"

static rt_err_t timer_timeout_cb(rt_device_t dev, rt_size_t size)
{
    rt_kprintf("enter hardware timer isr\n");

    return 0;
}

int hwtimer(void)
{
    rt_err_t err;
    rt_hwtimerval_t val;
    rt_device_t dev = RT_NULL;
    rt_tick_t tick;
    rt_hwtimer_mode_t mode;
    int freq = 10000;
    int t = 5;

    if ((dev = rt_device_find(TIMER)) == RT_NULL)
    {
        rt_kprintf("No Device: %s\n", TIMER);
        return -1;
    }

    if (rt_device_open(dev, RT_DEVICE_OFLAG_RDWR) != RT_EOK)
    {
        rt_kprintf("Open %s Fail\n", TIMER);
        return -1;
    }

    /* ʱ����� */
    /* ����ʱ������(Ĭ��1Mhz��֧�ֵ���С����Ƶ��) */
    err = rt_device_control(dev, HWTIMER_CTRL_FREQ_SET, &freq);
    if (err != RT_EOK)
    {
        rt_kprintf("Set Freq=%dhz Fail\n", freq);
        goto EXIT;
    }

    /* ����ģʽ */
    mode = HWTIMER_MODE_PERIOD;
    err = rt_device_control(dev, HWTIMER_CTRL_MODE_SET, &mode);

    tick = rt_tick_get();
    rt_kprintf("Start Timer> Tick: %d\n", tick);
    /* ���ö�ʱ����ʱֵ��������ʱ�� */
    val.sec = t;
    val.usec = 0;
    rt_kprintf("SetTime: Sec %d, Usec %d\n", val.sec, val.usec);
    if (rt_device_write(dev, 0, &val, sizeof(val)) != sizeof(val))
    {
        rt_kprintf("SetTime Fail\n");
        goto EXIT;
    }
    rt_kprintf("Sleep %d sec\n", t);
    rt_thread_delay(t*RT_TICK_PER_SECOND);

    /* ֹͣ��ʱ�� */
    err = rt_device_control(dev, HWTIMER_CTRL_STOP, RT_NULL);
    rt_kprintf("Timer Stoped\n");
    /* ��ȡ���� */
    rt_device_read(dev, 0, &val, sizeof(val));
    rt_kprintf("Read: Sec = %d, Usec = %d\n", val.sec, val.usec);

    /* ��ʱִ�лص����� -- ����ģʽ */
    /* ���ó�ʱ�ص����� */
    rt_device_set_rx_indicate(dev, timer_timeout_cb);

    /* ����ģʽ */
    mode = HWTIMER_MODE_PERIOD;
    err = rt_device_control(dev, HWTIMER_CTRL_MODE_SET, &mode);

    /* ���ö�ʱ����ʱֵ��������ʱ�� */
    val.sec = t;
    val.usec = 0;
    rt_kprintf("SetTime: Sec %d, Usec %d\n", val.sec, val.usec);
    if (rt_device_write(dev, 0, &val, sizeof(val)) != sizeof(val))
    {
        rt_kprintf("SetTime Fail\n");
        goto EXIT;
    }

    /* �ȴ��ص�����ִ�� */
    rt_thread_delay((t + 1)*RT_TICK_PER_SECOND);

EXIT:
    err = rt_device_close(dev);
    rt_kprintf("Close %s\n", TIMER);

    return err;
}
#ifdef FINSH_USING_MSH
MSH_CMD_EXPORT(hwtimer, "Test hardware timer");
#endif
#endif /* RT_USING_HWTIMER */
