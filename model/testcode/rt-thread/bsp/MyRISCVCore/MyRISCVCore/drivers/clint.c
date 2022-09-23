#include <rtthread.h>
#include "soc.h"

static clint_t clint = (clint_t)CLINT_BASEADDR;

void clint_yield_swi()
{
    clint -> MSIP |= CLINT_MSIP_FLAG;
}

void clint_clear_swi_flag()
{
    clint -> MSIP &= ~CLINT_MSIP_FLAG;
}