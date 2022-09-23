/*
 * Copyright (c) 2020-2020, myriscvcore Development Team
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-11-08     lizhirui     first version
 *
 */

#include <rtthread.h>
#include <rtdevice.h>
#include "soc.h"

struct myriscvcore_uart_device
{
    struct rt_serial_device parent;
    rt_bool_t isr_enabled;
};

struct myriscvcore_uart_config
{
    rt_uint32_t base_addr;
    rt_uint32_t baud_rate;
};

void send_char(uint32_t ch);
uint32_t rev_char();

static const struct myriscvcore_uart_config uart_config[] = {{UARTDBG_BASE,115200}};
static volatile struct myriscvcore_uart_device uart_device[get_array_length(uart_config)];

static rt_err_t myriscvcore_configure(struct myriscvcore_uart_device *serial,struct serial_configure *cfg)
{
    RT_ASSERT(serial != RT_NULL);
    RT_ASSERT(cfg != RT_NULL);
    serial -> parent.config.baud_rate = cfg -> baud_rate;
    return RT_EOK;
}

static rt_err_t myriscvcore_control(struct myriscvcore_uart_device *serial,int cmd,void *arg)
{
    RT_ASSERT(serial != RT_NULL);

    switch(cmd)
    {
        case RT_DEVICE_CTRL_SET_INT:
            if(((rt_uint32_t)arg) == RT_DEVICE_FLAG_INT_RX)
            {
                serial -> isr_enabled = RT_TRUE;
            }

            break;

        case RT_DEVICE_CTRL_CLR_INT:
            if(((rt_uint32_t)arg) == RT_DEVICE_FLAG_INT_RX)
            {
                serial -> isr_enabled = RT_FALSE;
            }

            break;
    }

    return RT_EOK;
}

static int myriscvcore_putc(struct myriscvcore_uart_device *serial,char ch)
{
    RT_ASSERT(serial != RT_NULL);
    send_char(ch);
    return 1;
}

static int myriscvcore_getc(struct myriscvcore_uart_device *serial)
{
    uint32_t ret = rev_char();

    if(ret & 0x80000000)
    {
        send_char(0x80000000);
        return ret & 0xff;
    }

    return -1;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wincompatible-pointer-types"
static const struct rt_uart_ops uart_ops = {myriscvcore_configure,myriscvcore_control,myriscvcore_putc,myriscvcore_getc};
#pragma GCC diagnostic pop

static void uart_rx(void *param)
{
    struct myriscvcore_uart_device *serial = (struct myriscvcore_uart_device *)param;

    while(1)
    {
        if(serial -> isr_enabled)
        {
            uint32_t ret = rev_char();

            if(ret & 0x80000000)
            {
                rt_hw_serial_isr((struct rt_serial_device *)serial,RT_SERIAL_EVENT_RX_IND);
            }
        }

        rt_thread_mdelay(10);
    }
}

void rt_hw_uart_start_rx_thread()
{
    int index;

    for(index = 0;index < get_array_length(uart_device);index++)
    {
        rt_thread_t th;
        RT_ASSERT((th = rt_thread_create("uartrx_dbg",uart_rx,(void *)&uart_device[index],8192,8,20)) != RT_NULL);
        RT_ASSERT(rt_thread_startup(th) == RT_EOK);
    }
}

void rt_hw_uart_init(void)
{
    int index;
    rt_err_t result = RT_EOK;

    for(index = 0;index < get_array_length(uart_device);index++)
    {
        uart_device[index].parent.config.baud_rate = uart_config[index].baud_rate;
        uart_device[index].parent.config.data_bits = 8;
        uart_device[index].parent.config.stop_bits = 1;
        uart_device[index].parent.config.bufsz = 2048;
        uart_device[index].parent.ops = &uart_ops;
        uart_device[index].isr_enabled = RT_FALSE;
        result = rt_hw_serial_register((struct rt_serial_device *)&uart_device[index],"dbg",RT_DEVICE_FLAG_RDWR | RT_DEVICE_FLAG_INT_RX,RT_NULL);
        RT_ASSERT(result == RT_EOK);
    }
}