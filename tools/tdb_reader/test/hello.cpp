#include "svdpi.h"
#include "vc_hdrs.h"

void c_task(int i, int *o)
{
    printf("Hello from c_task(%d)\n", i);
    verilog_task(i, o); /* Call back into Verilog */
    *o = i;
}

extern void c_task(int i)
{
    printf("Hello from c_task(%d)\n", i);
}