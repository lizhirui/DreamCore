#include "common.h"
#include "fifo.h"
#include "../component/fifo.h"

namespace test
{
    namespace fifo
    {
        void test()
        {
            component::fifo<if_print_fake<int>> u_fifo(5);
            if_print_fake<int> x;

            assert(u_fifo.is_empty());
            assert(u_fifo.push(1));
            assert(!u_fifo.is_empty());
            assert(u_fifo.push(2));
            assert(u_fifo.push(3));
            assert(u_fifo.push(4));
            assert(!u_fifo.is_full());
            assert(u_fifo.push(5));
            assert(u_fifo.is_full());
            assert(!u_fifo.push(6));
            assert(u_fifo.pop(&x));
            assert(x == 1);
            assert(u_fifo.pop(&x));
            assert(x == 2);
            assert(u_fifo.pop(&x));
            assert(x == 3);
            assert(u_fifo.pop(&x));
            assert(x == 4);
            assert(!u_fifo.is_empty());
            assert(u_fifo.pop(&x));
            assert(u_fifo.is_empty());
            assert(x == 5);
            assert(!u_fifo.pop(&x));
        }
    }
}