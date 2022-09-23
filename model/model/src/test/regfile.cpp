#include "common.h"
#include "regfile.h"
#include "../component/regfile.h"

namespace test
{
    namespace regfile
    {
        void test()
        {
            component::regfile<uint32_t> regfile(32);
            
            for(uint32_t i = 0;i < 32;i++)
            {
                assert(regfile.read(i) == 0);
            }

            for(uint32_t i = 0;i < 32;i++)
            {
                regfile.write(i, i, true);
            }

            for(uint32_t i = 0;i < 32;i++)
            {
                assert(regfile.read(i) == i);
            }

            for(uint32_t i = 0;i < 32;i++)
            {
                regfile.write_sync(i, i + 1, true);
            }

            for(uint32_t i = 0;i < 32;i++)
            {
                assert(regfile.read(i) == i);
            }

            regfile.sync();

            for(uint32_t i = 0;i < 32;i++)
            {
                assert(regfile.read(i) == i + 1);
            }
        }
    }
}