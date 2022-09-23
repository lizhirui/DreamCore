#pragma once
#include "common.h"
#include "../../component/fifo.h"
#include "../../component/port.h"
#include "../issue_execute.h"
#include "../execute.h"
#include "../execute_wb.h"
#include "../commit.h"

namespace pipeline
{
    namespace execute
    {
        class alu : public if_reset_t
        {
            private:
                uint32_t id;
                component::fifo<issue_execute_pack_t> *issue_alu_fifo;
                component::port<execute_wb_pack_t> *alu_wb_port;
                trace::trace_database tdb;

            public:
                alu(uint32_t id, component::fifo<issue_execute_pack_t> *issue_alu_fifo, component::port<execute_wb_pack_t> *alu_wb_port);
                virtual void reset();
                execute_feedback_channel_t run(commit_feedback_pack_t commit_feedback_pack);
        };
    }
}