#include "common.h"
#include "test.h"
#include "fifo.h"
#include "stack.h"
#include "port.h"
#include "rat.h"
#include "regfile.h"
#include "issue_queue.h"

namespace test
{
    void test()
    {
        fifo::test();
        stack::test();
        port::test();
        rat::test();
        regfile::test();
        issue_queue::test();
        std::cout << "Self-Test Passed" << std::endl;
    }
}
