#include <rtthread.h>

static rt_thread_t thread_a;
static rt_thread_t thread_b;
static rt_thread_t thread_c;

void thread_a_entry(void *arg)
{
    int i;

    for(i = 0;i < 10;i++)
    {
        rt_kprintf("[%d]Test rt__kprintf-a\n",i);
        rt_thread_mdelay(1);
    }
}

void thread_b_entry(void *arg)
{
    int i;

    for(i = 0;i < 10;i++)
    {
        rt_kprintf("[%d]Test rt__kprintf-b\n",i);
        rt_thread_mdelay(10);
    }
}

void thread_c_entry(void *arg)
{
    int i;

    for(i = 0;i < 10;i++)
    {
        rt_kprintf("[%d]Test rt__kprintf-c\n",i);
        rt_thread_mdelay(5);
    }
}

long testapp()
{
    thread_a = rt_thread_create("thread_a",thread_a_entry,RT_NULL,4096,10,10);
    thread_b = rt_thread_create("thread_b",thread_b_entry,RT_NULL,4096,10,10);
    thread_c = rt_thread_create("thread_c",thread_c_entry,RT_NULL,4096,10,10);
    rt_thread_startup(thread_a);
    rt_thread_startup(thread_b);
    rt_thread_startup(thread_c);
    return 0;
}
MSH_CMD_EXPORT(testapp, testapp);