#pragma once
#include "common.h"
#include "pipeline_common.h"
#include "../component/port.h"
#include "../component/rat.h"
#include "../component/rob.h"
#include "../component/csrfile.h"
#include "../component/regfile.h"
#include "../component/checkpoint_buffer.h"
#include "../component/branch_predictor.h"
#include "../component/interrupt_interface.h"
#include "wb_commit.h"

namespace pipeline
{
    typedef struct commit_feedback_pack_t : public if_print_t
    {
        bool enable;
        bool next_handle_rob_id_valid;
        uint32_t next_handle_rob_id;
        bool has_exception;
        uint32_t exception_pc;
        bool flush;
        uint32_t committed_rob_id[COMMIT_WIDTH];
        bool committed_rob_id_valid[COMMIT_WIDTH];

        bool jump_enable;
        bool jump;
        uint32_t next_pc;

        virtual json get_json()
        {
            json t;
            t["enable"] = enable;
            t["next_handle_rob_id_valid"] = next_handle_rob_id_valid;
            t["next_handle_rob_id"] = next_handle_rob_id;
            t["committed_rob_id_valid_0"] = committed_rob_id_valid[0];
            t["committed_rob_id_0"] = committed_rob_id[0];
            t["committed_rob_id_valid_1"] = committed_rob_id_valid[1];
            t["committed_rob_id_1"] = committed_rob_id[1];
            t["has_exception"] = has_exception;
            t["exception_pc"] = exception_pc;
            t["flush"] = flush;
            t["jump_enable"] = jump_enable;
            t["jump"] = jump;
            t["next_pc"] = next_pc;
            return t;
        }
    }commit_feedback_pack_t;

    enum class state_t
    {
        normal,
        flush,
        interrupt_flush
    };

    class commit : public if_reset_t
    {
        private:
            component::port<wb_commit_pack_t> *wb_commit_port;
            component::rat *rat;
            component::rob *rob;
            component::csrfile *csr_file;
            component::regfile<phy_regfile_item_t> *phy_regfile;
            component::checkpoint_buffer *checkpoint_buffer;
            component::branch_predictor *branch_predictor;
            component::interrupt_interface *interrupt_interface;

            state_t cur_state;

            component::rob_item_t rob_item;
            uint32_t rob_item_id;
            uint32_t restore_rob_item_id;

            uint32_t interrupt_pc;
            riscv_interrupt_t interrupt_id;
            trace::trace_database tdb;

        public:
            commit(component::port<wb_commit_pack_t> *wb_commit_port, component::rat *rat, component::rob *rob, component::csrfile *csr_file, component::regfile<phy_regfile_item_t> *phy_regfile, component::checkpoint_buffer *checkpoint_buffer, component::branch_predictor *branch_predictor, component::interrupt_interface *interrupt_interface);
            virtual void reset();
            commit_feedback_pack_t run();
    };
}