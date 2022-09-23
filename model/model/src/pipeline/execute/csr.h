#pragma once
#include "common.h"
#include "../../component/fifo.h"
#include "../../component/port.h"
#include "../../component/csrfile.h"
#include "../issue_execute.h"
#include "../execute.h"
#include "../execute_wb.h"
#include "../commit.h"

namespace pipeline
{
    namespace execute
    {
        class csr : if_reset_t
        {
            private:
                uint32_t id;
                component::fifo<issue_execute_pack_t> *issue_csr_fifo;
                component::port<execute_wb_pack_t> *csr_wb_port;
                component::csrfile *csr_file;
                trace::trace_database tdb;
                
                issue_execute_pack_t rev_pack;

            public:
                csr(uint32_t id, component::fifo<issue_execute_pack_t> *issue_csr_fifo, component::port<execute_wb_pack_t> *csr_wb_port, component::csrfile *csr_file);
                virtual void reset();
                execute_feedback_channel_t run(commit_feedback_pack_t commit_feedback_pack);
        };
    }
}