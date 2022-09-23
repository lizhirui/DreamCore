#pragma once
#include "common.h"
#include "../../component/fifo.h"
#include "../../component/port.h"
#include "../../component/csrfile.h"
#include "../../component/csr_all.h"
#include "../../component/branch_predictor.h"
#include "../component/checkpoint_buffer.h"
#include "../issue_execute.h"
#include "../execute.h"
#include "../execute_wb.h"
#include "../commit.h"

namespace pipeline
{
    namespace execute
    {
        class bru : public if_reset_t
        {
            private:
                uint32_t id;
                component::fifo<issue_execute_pack_t> *issue_bru_fifo;
                component::port<execute_wb_pack_t> *bru_wb_port;
                component::csrfile *csr_file;
                component::branch_predictor *branch_predictor;
                component::checkpoint_buffer *checkpoint_buffer;
                trace::trace_database tdb;

            public:
                bru(uint32_t id, component::fifo<issue_execute_pack_t> *issue_bru_fifo, component::port<execute_wb_pack_t> *bru_wb_port, component::csrfile *csr_file, component::branch_predictor *branch_predictor, component::checkpoint_buffer *checkpoint_buffer);
                virtual void reset();
                execute_feedback_channel_t run(commit_feedback_pack_t commit_feedback_pack);
        };
    }
}