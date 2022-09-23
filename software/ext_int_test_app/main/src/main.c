#include <stdint.h>

void send_char(char ch);

void send_str(char *str)
{
    while(*str)
    {
        send_char(*(str++));
    }
}

uint32_t read_mcycle();

void delay(uint32_t ms)
{
    while(ms--)
    {
        uint32_t start = read_mcycle();
        while(read_mcycle() - start < 10000);
    }
}

void main()
{
    while(1)
    {
        send_str("Hello World, RISC-V Out-Of-Order Core by LiZhirui!\n");
        delay(1000);
    }
}

void trap_entry_c()
{
    send_str("Interrupt Occured!\n");
    delay(1000);
}