#include "common.h"
#include "fifo.h"
#include "../component/stack.h"

namespace test
{
    namespace stack
    {
        void test()
        {
            component::stack<if_print_fake<int>> u_stack(5);
            if_print_fake<int> x;

            assert(u_stack.is_empty());
            assert(!u_stack.is_full());
            assert(!u_stack.pop(&x));
            assert(u_stack.push(1));
            assert(u_stack.push(2));
            assert(u_stack.push(3));
            assert(u_stack.push(4));
            assert(!u_stack.is_full());
            assert(u_stack.push(5));
            assert(u_stack.is_full());
            assert(!u_stack.push(6));
            assert(u_stack.is_full());
            assert(u_stack.pop(&x));
            assert(x == 5);
            assert(u_stack.pop(&x));
            assert(x == 4);
            assert(u_stack.pop(&x));
            assert(x == 3);
            assert(u_stack.pop(&x));
            assert(x == 2);
            assert(u_stack.pop(&x));
            assert(x == 1);
            assert(!u_stack.pop(&x));
            assert(u_stack.is_empty());
            assert(!u_stack.is_full());
        }
    }
}