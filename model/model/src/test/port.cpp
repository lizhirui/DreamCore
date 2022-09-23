#include "common.h"
#include "port.h"
#include "../component/port.h"

namespace test
{
    namespace port
    {
        void test()
        {
            component::port<if_print_fake<int>> u_port(0);

            assert(u_port.get() == 0);
            u_port.set(1);
            assert(u_port.get() == 1);
        }
    }
}