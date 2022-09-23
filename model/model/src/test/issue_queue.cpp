#include "common.h"
#include "issue_queue.h"
#include "../component/issue_queue.h"

namespace test
{
    namespace issue_queue
    {
        void test()
        {
            component::issue_queue<if_print_fake<uint32_t>> u_fifo(5);
            if_print_fake<uint32_t> x;
            uint32_t y1, y2;
            
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
            assert(!u_fifo.get_front(&x));
            assert(!u_fifo.get_front_id(&y1));
            assert(u_fifo.push(3));
            assert(u_fifo.get_front(&x));
            assert(x == 3);
            assert(u_fifo.get_front_id(&y1));
            assert(u_fifo.push(4));
            assert(u_fifo.get_next_id(y1, &y1));
            assert(u_fifo.get_tail_id(&y2));
            assert(y1 == y2);
            assert(u_fifo.get_tail_id(&y2));
            u_fifo.set_item_sync(y2, 1);
            assert(u_fifo.get_item(y2) == 4);
            u_fifo.sync();
            assert(u_fifo.get_item(y2) == 1);
            u_fifo.pop_sync();
            assert(u_fifo.get_front(&x));
            assert(x == 3);
            assert(u_fifo.get_size() == 2);
            u_fifo.sync();
            assert(u_fifo.get_front(&x));
            assert(x == 1);
            assert(u_fifo.get_size() == 1);
        }
    }
}
