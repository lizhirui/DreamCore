#include "common.h"
#include "div.h"

namespace pipeline
{
    namespace execute
    {
        div::div(uint32_t id, component::fifo<issue_execute_pack_t> *issue_div_fifo, component::port<execute_wb_pack_t> *div_wb_port) : tdb(TRACE_EXECUTE_DIV)
        {
            this->id = id;
            this->issue_div_fifo = issue_div_fifo;
            this->div_wb_port = div_wb_port;
        }

        void div::reset()
        {
            this->tdb.create(TRACE_DIR + "execute_div_" + std::to_string(id) + ".tdb");

            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.enable", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.valid", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rob_id", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.pc", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.imm", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.has_exception", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.exception_id", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.exception_value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.predicted", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.predicted_jump", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.predicted_next_pc", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.checkpoint_id_valid", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.checkpoint_id", sizeof(uint16_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rs1", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.arg1_src", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rs1_need_map", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rs1_phy", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.src1_value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.src1_loaded", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rs2", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.arg2_src", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rs2_need_map", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rs2_phy", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.src2_value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.src2_loaded", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rd", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rd_enable", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.need_rename", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.rd_phy", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.csr", sizeof(uint16_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.lsu_addr", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.op", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.op_unit", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out.sub_op", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_data_out_valid", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_pop", sizeof(uint8_t), 1);

            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.enable", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.valid", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rob_id", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.pc", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.imm", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.has_exception", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.exception_id", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.exception_value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.predicted", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.predicted_jump", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.predicted_next_pc", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.checkpoint_id_valid", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.checkpoint_id", sizeof(uint16_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.bru_jump", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.bru_next_pc", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rs1", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.arg1_src", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rs1_need_map", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rs1_phy", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.src1_value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.src1_loaded", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rs2", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.arg2_src", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rs2_need_map", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rs2_phy", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.src2_value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.src2_loaded", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rd", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rd_enable", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.need_rename", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rd_phy", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.rd_value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.csr", sizeof(uint16_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.csr_newvalue", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.csr_newvalue_valid", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.op", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.op_unit", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_data_in.sub_op", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_we", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_wb_port_flush", sizeof(uint8_t), 1);

            this->tdb.mark_signal(trace::domain_t::output, "div_execute_channel_feedback_pack.enable", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_execute_channel_feedback_pack.phy_id", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::output, "div_execute_channel_feedback_pack.value", sizeof(uint32_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.enable", sizeof(uint8_t), 1);
            this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.flush", sizeof(uint8_t), 1);

            this->tdb.write_metainfo();
            this->tdb.trace_on();
            this->tdb.capture_status();
            this->tdb.write_row();
        }

        execute_feedback_channel_t div::run(commit_feedback_pack_t commit_feedback_pack)
        {
            this->tdb.capture_input();

            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.enable", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.value", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.valid", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rob_id", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.pc", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.imm", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.has_exception", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.exception_id", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.exception_value", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.predicted", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.predicted_jump", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.predicted_next_pc", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.checkpoint_id_valid", 0, 0);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "issue_div_fifo_data_out.checkpoint_id", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs1", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.arg1_src", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs1_need_map", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs1_phy", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.src1_value", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.src1_loaded", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs2", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.arg2_src", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs2_need_map", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs2_phy", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.src2_value", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.src2_loaded", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rd", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rd_enable", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.need_rename", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rd_phy", 0, 0);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "issue_div_fifo_data_out.csr", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.lsu_addr", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.op", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.op_unit", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.sub_op", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out_valid", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_pop", 0, 0);

            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.enable", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.value", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.valid", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rob_id", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.pc", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.imm", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.has_exception", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.exception_id", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.exception_value", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.predicted", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.predicted_jump", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.predicted_next_pc", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.checkpoint_id_valid", 0, 0);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "div_wb_port_data_in.checkpoint_id", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.bru_jump", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.bru_next_pc", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs1", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.arg1_src", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs1_need_map", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs1_phy", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.src1_value", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.src1_loaded", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs2", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.arg2_src", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs2_need_map", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs2_phy", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.src2_value", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.src2_loaded", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rd", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rd_enable", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.need_rename", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rd_phy", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.rd_value", 0, 0);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "div_wb_port_data_in.csr", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.csr_newvalue", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.csr_newvalue_valid", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.op", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.op_unit", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.sub_op", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_we", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_flush", 0, 0);

            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_execute_channel_feedback_pack.enable", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_execute_channel_feedback_pack.phy_id", 0, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_execute_channel_feedback_pack.value", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", 0, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", 0, 0);

            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", commit_feedback_pack.enable, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", commit_feedback_pack.flush, 0);

            execute_wb_pack_t send_pack;

            memset(&send_pack, 0, sizeof(send_pack));
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out_valid", !issue_div_fifo->is_empty(), 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_flush",issue_div_fifo->is_empty() || (commit_feedback_pack.enable && commit_feedback_pack.flush), 0);

            if(!issue_div_fifo->is_empty() && !(commit_feedback_pack.enable && commit_feedback_pack.flush))
            {
                issue_execute_pack_t rev_pack;
                assert(issue_div_fifo->pop(&rev_pack));

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.enable", rev_pack.enable, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.value", rev_pack.value, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.valid", rev_pack.valid, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rob_id", rev_pack.rob_id, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.pc", rev_pack.pc, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.imm", rev_pack.imm, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.has_exception", rev_pack.has_exception, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.exception_id", (uint32_t)rev_pack.exception_id, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.exception_value", rev_pack.exception_value, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.predicted", rev_pack.predicted, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.predicted_jump", rev_pack.predicted_jump, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.predicted_next_pc", rev_pack.predicted_next_pc, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.checkpoint_id_valid", rev_pack.checkpoint_id_valid, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "issue_div_fifo_data_out.checkpoint_id", rev_pack.checkpoint_id, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs1", rev_pack.rs1, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.arg1_src", (uint8_t)rev_pack.arg1_src, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs1_need_map", rev_pack.rs1_need_map, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs1_phy", rev_pack.rs1_phy, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.src1_value", rev_pack.src1_value, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.src1_loaded", rev_pack.src1_loaded, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs2", rev_pack.rs2, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.arg2_src", (uint8_t)rev_pack.arg2_src, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs2_need_map", rev_pack.rs2_need_map, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rs2_phy", rev_pack.rs2_phy, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.src2_value", rev_pack.src2_value, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.src2_loaded", rev_pack.src2_loaded, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rd", rev_pack.rd, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rd_enable", rev_pack.rd_enable, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.need_rename", rev_pack.need_rename, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.rd_phy", rev_pack.rd_phy, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "issue_div_fifo_data_out.csr", rev_pack.csr, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_div_fifo_data_out.lsu_addr", rev_pack.lsu_addr, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.op", (uint8_t)rev_pack.op, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.op_unit", (uint8_t)rev_pack.op_unit, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_data_out.sub_op", *(uint8_t *)&rev_pack.sub_op, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_pop", 1, 0);
                
                send_pack.enable = rev_pack.enable;
                send_pack.value = rev_pack.value;
                send_pack.valid = rev_pack.valid;
                send_pack.rob_id = rev_pack.rob_id;
                send_pack.pc = rev_pack.pc;
                send_pack.imm = rev_pack.imm;
                send_pack.has_exception = rev_pack.has_exception;
                send_pack.exception_id = rev_pack.exception_id;
                send_pack.exception_value = rev_pack.exception_value;

                send_pack.predicted = rev_pack.predicted;
                send_pack.predicted_jump = rev_pack.predicted_jump;
                send_pack.predicted_next_pc = rev_pack.predicted_next_pc;
                send_pack.checkpoint_id_valid = rev_pack.checkpoint_id_valid;
                send_pack.checkpoint_id = rev_pack.checkpoint_id;

                send_pack.rs1 = rev_pack.rs1;
                send_pack.arg1_src = rev_pack.arg1_src;
                send_pack.rs1_need_map = rev_pack.rs1_need_map;
                send_pack.rs1_phy = rev_pack.rs1_phy;
                send_pack.src1_value = rev_pack.src1_value;
                send_pack.src1_loaded = rev_pack.src1_loaded;

                send_pack.rs2 = rev_pack.rs2;
                send_pack.arg2_src = rev_pack.arg2_src;
                send_pack.rs2_need_map = rev_pack.rs2_need_map;
                send_pack.rs2_phy = rev_pack.rs2_phy;
                send_pack.src2_value = rev_pack.src2_value;
                send_pack.src2_loaded = rev_pack.src2_loaded;

                send_pack.rd = rev_pack.rd;
                send_pack.rd_enable = rev_pack.rd_enable;
                send_pack.need_rename = rev_pack.need_rename;
                send_pack.rd_phy = rev_pack.rd_phy;

                send_pack.csr = rev_pack.csr;
                send_pack.op = rev_pack.op;
                send_pack.op_unit = rev_pack.op_unit;
                memcpy(&send_pack.sub_op, &rev_pack.sub_op, sizeof(rev_pack.sub_op));
                auto overflow = (rev_pack.src1_value == 0x80000000) && (rev_pack.src2_value == 0xFFFFFFFF);

                if(rev_pack.enable && rev_pack.valid)
                {
                    switch(rev_pack.sub_op.div_op)
                    {
                        case div_op_t::div:
                            send_pack.rd_value = (rev_pack.src2_value == 0) ? 0xFFFFFFFF : overflow ? 0x80000000 : ((uint32_t)(((int32_t)rev_pack.src1_value) / ((int32_t)rev_pack.src2_value)));
                            break;

                        case div_op_t::divu:
                            send_pack.rd_value = (rev_pack.src2_value == 0) ? 0xFFFFFFFF : ((uint32_t)(((uint32_t)rev_pack.src1_value) / ((uint32_t)rev_pack.src2_value)));
                            break;

                        case div_op_t::rem:
                            send_pack.rd_value = (rev_pack.src2_value == 0) ? rev_pack.src1_value : overflow ? 0 : ((uint32_t)(((int32_t)rev_pack.src1_value) % ((int32_t)rev_pack.src2_value)));
                            break;

                        case div_op_t::remu:
                            send_pack.rd_value = (rev_pack.src2_value == 0) ? rev_pack.src1_value : (((uint32_t)((int32_t)rev_pack.src1_value) % ((int32_t)rev_pack.src2_value)));
                            break;
                    }
                }
            }

            div_wb_port->set(send_pack);

            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.enable", send_pack.enable, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.value", send_pack.value, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.valid", send_pack.valid, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rob_id", send_pack.rob_id, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.pc", send_pack.pc, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.imm", send_pack.imm, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.has_exception", send_pack.has_exception, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.exception_id", (uint32_t)send_pack.exception_id, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.exception_value", send_pack.exception_value, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.predicted", send_pack.predicted, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.predicted_jump", send_pack.predicted_jump, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.predicted_next_pc", send_pack.predicted_next_pc, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.checkpoint_id_valid", send_pack.checkpoint_id_valid, 0);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "div_wb_port_data_in.checkpoint_id", send_pack.checkpoint_id, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.bru_jump", send_pack.bru_jump, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.bru_next_pc", send_pack.bru_next_pc, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs1", send_pack.rs1, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.arg1_src", (uint8_t)send_pack.arg1_src, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs1_need_map", send_pack.rs1_need_map, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs1_phy", send_pack.rs1_phy, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.src1_value", send_pack.src1_value, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.src1_loaded", send_pack.src1_loaded, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs2", send_pack.rs2, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.arg2_src", (uint8_t)send_pack.arg2_src, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs2_need_map", send_pack.rs2_need_map, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rs2_phy", send_pack.rs2_phy, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.src2_value", send_pack.src2_value, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.src2_loaded", send_pack.src2_loaded, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rd", send_pack.rd, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rd_enable", send_pack.rd_enable, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.need_rename", send_pack.need_rename, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.rd_phy", send_pack.rd_phy, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.rd_value", send_pack.rd_value, 0);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "div_wb_port_data_in.csr", send_pack.csr, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_wb_port_data_in.csr_newvalue", send_pack.csr_newvalue, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.csr_newvalue_valid", send_pack.csr_newvalue_valid, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.op", (uint8_t)send_pack.op, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.op_unit", (uint8_t)send_pack.op_unit, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_data_in.sub_op", *(uint8_t *)&send_pack.sub_op, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_wb_port_we", 1, 0);

            execute_feedback_channel_t feedback_pack;
            feedback_pack.enable = send_pack.enable && send_pack.valid && send_pack.rd_enable && send_pack.need_rename && !send_pack.has_exception;
            feedback_pack.phy_id = send_pack.rd_phy;
            feedback_pack.value = send_pack.rd_value;

            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_execute_channel_feedback_pack.enable", feedback_pack.enable, 0);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "div_execute_channel_feedback_pack.phy_id", feedback_pack.phy_id, 0);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "div_execute_channel_feedback_pack.value", feedback_pack.value, 0);

            this->tdb.capture_output_status();
            this->tdb.write_row();
            return feedback_pack;
        }
    }
}