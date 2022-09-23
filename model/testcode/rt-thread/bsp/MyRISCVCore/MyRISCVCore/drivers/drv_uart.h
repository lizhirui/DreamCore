#ifndef __DRV_UART_H__
#define __DRV_UART_H__

    #define UARTDBG_BASE 0x51000000U

    #define REG_STATE_TXFULL (1U << 1)
    #define REG_STATE_RXEMPTY (1U << 0)

    void rt_hw_uart_init();
    void rt_hw_uart_start_rx_thread();

#endif