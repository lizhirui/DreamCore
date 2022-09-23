/*
 * Copyright (c) 2006-2020, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-04-15     hqfang       first version
 */

#include <rtthread.h>
#include <rtdevice.h>

#include "drv_uart.h"

long testapp();

int main(int argc, char *argv[])
{
    rt_hw_uart_start_rx_thread();
    testapp();
    return RT_EOK;
}

/******************** end of file *******************/