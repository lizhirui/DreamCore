#include "common.h"
#include "config.h"
#include "pipeline_common.h"
#include "rename.h"
#include "issue.h"

namespace pipeline
{
    rename::rename(component::fifo<decode_rename_pack_t> *decode_rename_fifo, component::port<rename_readreg_pack_t> *rename_readreg_port, component::rat *rat, component::rob *rob, component::checkpoint_buffer *checkpoint_buffer) : tdb(TRACE_RENAME)
    {
        this->decode_rename_fifo = decode_rename_fifo;
        this->rename_readreg_port = rename_readreg_port;
        this->rat = rat;
        this->rob = rob;
        this->checkpoint_buffer = checkpoint_buffer;
        this->busy = false;
    }

    void rename::reset()
    {
        this->busy = false;
        this->tdb.create(TRACE_DIR + "rename.tdb");

        this->tdb.mark_signal(trace::domain_t::output, "rename_cpbuf_id", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal_bitmap(trace::domain_t::output, "rename_cpbuf_data.rat_phy_map_table_valid", PHY_REG_NUM, RENAME_WIDTH);
        this->tdb.mark_signal_bitmap(trace::domain_t::output, "rename_cpbuf_data.rat_phy_map_table_visible", PHY_REG_NUM, RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_cpbuf_data.global_history", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_cpbuf_data.local_history", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_cpbuf_we", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "cpbuf_rename_data.global_history", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "cpbuf_rename_data.local_history", sizeof(uint16_t), RENAME_WIDTH);

        this->tdb.mark_signal(trace::domain_t::input, "rat_rename_new_phy_id", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rat_rename_new_phy_id_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rat_phy_id", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rat_phy_id_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rat_arch_id", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rat_map", sizeof(uint8_t), 1);

        this->tdb.mark_signal_bitmap(trace::domain_t::input, "rat_rename_map_table_valid", PHY_REG_NUM, 1);
        this->tdb.mark_signal_bitmap(trace::domain_t::input, "rat_rename_map_table_visible", PHY_REG_NUM, 1);

        this->tdb.mark_signal(trace::domain_t::output, "rename_rat_read_arch_id", sizeof(uint8_t), RENAME_WIDTH * 3);
        this->tdb.mark_signal(trace::domain_t::input, "rat_rename_read_phy_id", sizeof(uint8_t), RENAME_WIDTH * 3);

        this->tdb.mark_signal(trace::domain_t::input, "rob_rename_new_id", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_rename_new_id_valid", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.new_phy_reg_id", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.old_phy_reg_id", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.old_phy_reg_id_valid", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.finish", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.pc", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.inst_value", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.has_exception", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.exception_id", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.exception_value", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.predicted", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.predicted_jump", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.predicted_next_pc", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.checkpoint_id_valid", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.checkpoint_id", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.bru_op", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.bru_jump", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.bru_next_pc", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.is_mret", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.csr_addr", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.csr_newvalue", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data.csr_newvalue_valid", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_data_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "rename_rob_push", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "rename_csrf_phy_regfile_full_add", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "rename_csrf_rob_full_add", sizeof(uint8_t), 1);
        
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.enable", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.value", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.valid", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.pc", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.imm", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.has_exception", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.exception_id", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.exception_value", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.predicted", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.predicted_jump", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.predicted_next_pc", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.checkpoint_id_valid", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.checkpoint_id", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.rs1", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.arg1_src", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.rs1_need_map", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.rs2", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.arg2_src", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.rs2_need_map", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.rd", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.rd_enable", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.need_rename", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.csr", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.op", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.op_unit", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out.sub_op", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_out_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_pop_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_pop", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.enable", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.value", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.valid", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rob_id", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.pc", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.imm", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.has_exception", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.exception_id", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.exception_value", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.predicted", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.predicted_jump", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.predicted_next_pc", sizeof(uint32_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.checkpoint_id_valid", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.checkpoint_id", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rs1", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.arg1_src", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rs1_need_map", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rs1_phy", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rs2", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.arg2_src", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rs2_need_map", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rs2_phy", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rd", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rd_enable", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.need_rename", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.rd_phy", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.csr", sizeof(uint16_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.op", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.op_unit", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_data_in.sub_op", sizeof(uint8_t), RENAME_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_we", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "rename_readreg_port_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "rename_feedback_pack.idle", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "issue_feedback_pack.stall", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.flush", sizeof(uint8_t), 1);

        this->tdb.write_metainfo();
        this->tdb.trace_on();
        this->tdb.capture_status();
        this->tdb.write_row();
    }

    rename_feedback_pack_t rename::run(issue_feedback_pack_t issue_pack, commit_feedback_pack_t commit_feedback_pack)
    {
        this->tdb.capture_input();

        for(auto i = 0;i < RENAME_WIDTH;i++)
        {
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_cpbuf_id", 0, i);
            this->tdb.update_signal_bitmap_all(trace::domain_t::output, "rename_cpbuf_data.rat_phy_map_table_valid", 0, i);
            this->tdb.update_signal_bitmap_all(trace::domain_t::output, "rename_cpbuf_data.rat_phy_map_table_visible", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_cpbuf_data.global_history", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_cpbuf_data.local_history", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_cpbuf_we", 0, 0);
        
        for(auto i = 0;i < RENAME_WIDTH;i++)
        {
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "cpbuf_rename_data.global_history", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "cpbuf_rename_data.local_history", 0, i);
    
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rat_rename_new_phy_id", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rat_rename_new_phy_id_valid", 0, 0);
        
        for(auto i = 0;i < RENAME_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_phy_id", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_phy_id_valid", 0, 0);
        
        for(auto i = 0;i < RENAME_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_arch_id", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_map", 0, 0);

        this->tdb.update_signal_bitmap_all(trace::domain_t::input, "rat_rename_map_table_valid", 0, 0);
        this->tdb.update_signal_bitmap_all(trace::domain_t::input, "rat_rename_map_table_visible", 0, 0);

        
        for(auto i = 0;i < RENAME_WIDTH * 3;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_read_arch_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rat_rename_read_phy_id", 0, i);
        }

        for(auto i = 0;i < RENAME_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_rename_new_id", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_rename_new_id_valid", 0, 0);

        
        for(auto i = 0;i < RENAME_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.new_phy_reg_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.old_phy_reg_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.old_phy_reg_id_valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.finish", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.inst_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_rob_data.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.bru_op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.bru_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.bru_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.is_mret", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_rob_data.csr_addr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.csr_newvalue", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.csr_newvalue_valid", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_push", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_csrf_phy_regfile_full_add", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_csrf_rob_full_add", 0, 0);
        
        
        for(auto i = 0;i < RENAME_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.valid", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "decode_rename_fifo_data_out.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.need_rename", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "decode_rename_fifo_data_out.csr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_pop_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_pop", 0, 0);

        
        for(auto i = 0;i < RENAME_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_readreg_port_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs1_phy", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs2_phy", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_readreg_port_data_in.csr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_we", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_feedback_pack.idle", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_feedback_pack.stall", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", 0, 0);
        
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_feedback_pack.stall", issue_pack.stall, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", commit_feedback_pack.enable, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", commit_feedback_pack.flush, 0);

        //rename_readreg_pack_t null_send_pack;
        bool stall = issue_pack.stall;

        rename_feedback_pack_t feedback_pack;

        feedback_pack.idle = decode_rename_fifo->is_empty();
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out_valid", (1U << std::min(decode_rename_fifo->get_size(), RENAME_WIDTH)) - 1U, 0);
        
        {
            component::checkpoint_t t_cp;
            rat->save(t_cp);
            this->tdb.update_signal_bitmap(trace::domain_t::input, "rat_rename_map_table_valid", &t_cp.rat_phy_map_table_valid, 0);
            this->tdb.update_signal_bitmap(trace::domain_t::input, "rat_rename_map_table_visible", &t_cp.rat_phy_map_table_visible, 0);
        }

        //memset(&null_send_pack, 0, sizeof(null_send_pack));

        if(!(commit_feedback_pack.enable && commit_feedback_pack.flush))
        {
            if(!stall)
            {
                //this->rename_readreg_port->set(null_send_pack);//bubble

                rename_readreg_pack_t send_pack;
                memset(&send_pack, 0, sizeof(send_pack));
                    
                uint32_t phy_reg_req_cnt = 0;
                uint32_t rob_req_cnt = 0;
                uint32_t new_phy_reg_id[RENAME_WIDTH];
                component::rob_item_t rob_item[RENAME_WIDTH];
                memset(rob_item, 0 ,sizeof(rob_item));
                uint32_t used_phy_reg_cnt = 0;
                component::checkpoint_t global_cp;
                rat->save(global_cp);

                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_pop", 1, 0);

                //generate base send_pack
                for(uint32_t i = 0;i < RENAME_WIDTH;i++)
                {
                    if(!decode_rename_fifo->is_empty())
                    {
                        decode_rename_fifo->get_front(&rev_pack);

                        //count new physical registers requirement and rob requirement
                        if(rev_pack.enable && rev_pack.valid && rev_pack.need_rename)
                        {
                            phy_reg_req_cnt++;
                        }

                        if(rev_pack.enable)
                        {
                            rob_req_cnt++;
                        }

                        {
                            auto cnt = rat->get_free_phy_id(phy_reg_req_cnt, new_phy_reg_id);

                            for(uint32_t j = 0;j < cnt;j++)
                            {
                                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rat_rename_new_phy_id", new_phy_reg_id[j], j);
                                this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "rat_rename_new_phy_id_valid", 1, j, 0);
                            }
                        }

                        //start to rename
                        if((rat->get_free_phy_id(phy_reg_req_cnt, new_phy_reg_id) >= phy_reg_req_cnt) && rob->get_free_space() >= 1)
                        {
                            decode_rename_fifo->pop(&rev_pack);

                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.enable", rev_pack.enable, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.value", rev_pack.value, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.valid", rev_pack.valid, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.pc", rev_pack.pc, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.imm", rev_pack.imm, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.has_exception", rev_pack.has_exception, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.exception_id", (uint32_t)rev_pack.exception_id, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.exception_value", rev_pack.exception_value, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.predicted", rev_pack.predicted, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.predicted_jump", rev_pack.predicted_jump, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "decode_rename_fifo_data_out.predicted_next_pc", rev_pack.predicted_next_pc, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.checkpoint_id_valid", rev_pack.checkpoint_id_valid, i);
                            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "decode_rename_fifo_data_out.checkpoint_id", rev_pack.checkpoint_id, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rs1", rev_pack.rs1, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.arg1_src", (uint8_t)rev_pack.arg1_src, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rs1_need_map", rev_pack.rs1_need_map, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rs2", rev_pack.rs2, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.arg2_src", (uint8_t)rev_pack.arg2_src, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rs2_need_map", rev_pack.rs2_need_map, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rd", rev_pack.rd, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.rd_enable", rev_pack.rd_enable, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.need_rename", rev_pack.need_rename, i);
                            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "decode_rename_fifo_data_out.csr", rev_pack.csr, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.op", (uint8_t)rev_pack.op, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.op_unit", (uint8_t)rev_pack.op_unit, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_out.sub_op", *(uint8_t *)&rev_pack.sub_op, i);
                            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_pop_valid", 1, i, 0);

                            send_pack.op_info[i].enable = rev_pack.enable;
                            send_pack.op_info[i].value = rev_pack.value;
                            send_pack.op_info[i].valid = rev_pack.valid;
                            send_pack.op_info[i].pc = rev_pack.pc;
                            send_pack.op_info[i].imm = rev_pack.imm;
                            send_pack.op_info[i].has_exception = rev_pack.has_exception;
                            send_pack.op_info[i].exception_id = rev_pack.exception_id;
                            send_pack.op_info[i].exception_value = rev_pack.exception_value;
                            send_pack.op_info[i].predicted = rev_pack.predicted;
                            send_pack.op_info[i].predicted_jump = rev_pack.predicted_jump;
                            send_pack.op_info[i].predicted_next_pc = rev_pack.predicted_next_pc;
                            send_pack.op_info[i].checkpoint_id_valid = rev_pack.checkpoint_id_valid;
                            send_pack.op_info[i].checkpoint_id = rev_pack.checkpoint_id;
                            send_pack.op_info[i].rs1 = rev_pack.rs1;
                            send_pack.op_info[i].arg1_src = rev_pack.arg1_src;
                            send_pack.op_info[i].rs1_need_map = rev_pack.rs1_need_map;
                            send_pack.op_info[i].rs2 = rev_pack.rs2;
                            send_pack.op_info[i].arg2_src = rev_pack.arg2_src;
                            send_pack.op_info[i].rs2_need_map = rev_pack.rs2_need_map;
                            send_pack.op_info[i].rd = rev_pack.rd;
                            send_pack.op_info[i].rd_enable = rev_pack.rd_enable;
                            send_pack.op_info[i].need_rename = rev_pack.need_rename;
                            send_pack.op_info[i].csr = rev_pack.csr;
                            send_pack.op_info[i].op = rev_pack.op;
                            send_pack.op_info[i].op_unit = rev_pack.op_unit;
                        
                            memcpy(&send_pack.op_info[i].sub_op, &rev_pack.sub_op, sizeof(rev_pack.sub_op));
                            //generate rob items
                            if(rev_pack.enable)
                            {
                                if(rev_pack.valid)
                                {
                                    if(rev_pack.need_rename)
                                    {
                                        rob_item[i].old_phy_reg_id_valid = true;
                                        assert(rat->get_phy_id(rev_pack.rd, &rob_item[i].old_phy_reg_id));

                                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_read_arch_id", rev_pack.rd, i * 3 + 2);
                                        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rat_rename_read_phy_id", rob_item[i].old_phy_reg_id, i * 3 + 2);

                                        rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rat_read_arch_id", rev_pack.rd, i * 3 + 2);
                                        rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rat_rename_read_phy_id", rob_item[i].old_phy_reg_id, i * 3 + 2);

                                        send_pack.op_info[i].rd_phy = new_phy_reg_id[used_phy_reg_cnt++];
                                        rat->set_map_sync(rev_pack.rd, send_pack.op_info[i].rd_phy);

                                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_phy_id", send_pack.op_info[i].rd_phy, i);
                                        this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "rename_rat_phy_id_valid", 1, i, 0);
                                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_arch_id", rev_pack.rd, i);
                                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_map", 1, 0);

                                        rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rat_phy_id", send_pack.op_info[i].rd_phy, i);
                                        rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rat_phy_id_valid", 1, i);
                                        rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rat_arch_id", rev_pack.rd, i);
                                        rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rat_map", 1, 0);

                                        rat->cp_set_map(global_cp, rev_pack.rd, send_pack.op_info[i].rd_phy);

                                        if(i > 0)
                                        {
                                            //old_phy_reg_id feedback
                                            for(auto j = i - 1;;j--)
                                            {
                                                if(send_pack.op_info[j].enable && send_pack.op_info[j].valid && send_pack.op_info[j].need_rename)
                                                {
                                                    if(rev_pack.rd == send_pack.op_info[j].rd)
                                                    {
                                                        rob_item[i].old_phy_reg_id = send_pack.op_info[j].rd_phy;
                                                        break;
                                                    }
                                                }

                                                if(j == 0)
                                                {
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        rob_item[i].old_phy_reg_id_valid = false;
                                        rob_item[i].old_phy_reg_id = 0;
                                    }
                                }

                                rob_item[i].finish = false;
                                //fill rob item
                                rob_item[i].new_phy_reg_id = send_pack.op_info[i].rd_phy;
                                rob_item[i].pc = rev_pack.pc;
                                rob_item[i].inst_value = rev_pack.value;
                                rob_item[i].has_exception = rev_pack.has_exception;
                                rob_item[i].exception_id = rev_pack.exception_id;
                                rob_item[i].exception_value = rev_pack.exception_value;
                                rob_item[i].is_mret = rev_pack.op == op_t::mret;
                                rob_item[i].csr_addr = rev_pack.csr;
                                //write to rob
                                assert(rob->get_new_id(&send_pack.op_info[i].rob_id));
                                uint32_t t;
                                assert(rob->push(rob_item[i], &t));
                                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_rename_new_id", send_pack.op_info[i].rob_id, i);
                                this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "rob_rename_new_id_valid", 1, i, 0);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.new_phy_reg_id", rob_item[i].new_phy_reg_id, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.old_phy_reg_id", rob_item[i].old_phy_reg_id, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.old_phy_reg_id_valid", rob_item[i].old_phy_reg_id_valid, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.finish", rob_item[i].finish, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.pc", rob_item[i].pc, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.inst_value", rob_item[i].inst_value, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.has_exception", rob_item[i].has_exception, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.exception_id", (uint32_t)rob_item[i].exception_id, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.exception_value", rob_item[i].exception_value, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.predicted", rob_item[i].predicted, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.predicted_jump", rob_item[i].predicted_jump, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.predicted_next_pc", rob_item[i].predicted_next_pc, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.checkpoint_id_valid", rob_item[i].checkpoint_id_valid, i);
                                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_rob_data.checkpoint_id", rob_item[i].checkpoint_id, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.bru_op", rob_item[i].bru_op, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.bru_jump", rob_item[i].bru_jump, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.bru_next_pc", rob_item[i].bru_next_pc, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.is_mret", rob_item[i].is_mret, i);
                                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_rob_data.csr_addr", rob_item[i].csr_addr, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_rob_data.csr_newvalue", rob_item[i].csr_newvalue, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_data.csr_newvalue_valid", rob_item[i].csr_newvalue_valid, i);
                                this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "rename_rob_data_valid", 1, i, 0);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rob_push", 1, 0);

                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.new_phy_reg_id", rob_item[i].new_phy_reg_id, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.old_phy_reg_id", rob_item[i].old_phy_reg_id, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.old_phy_reg_id_valid", rob_item[i].old_phy_reg_id_valid, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.finish", rob_item[i].finish, i);
                                rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.pc", rob_item[i].pc, i);
                                rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.inst_value", rob_item[i].inst_value, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.has_exception", rob_item[i].has_exception, i);
                                rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.exception_id", (uint32_t)rob_item[i].exception_id, i);
                                rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.exception_value", rob_item[i].exception_value, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.predicted", rob_item[i].predicted, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.predicted_jump", rob_item[i].predicted_jump, i);
                                rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.predicted_next_pc", rob_item[i].predicted_next_pc, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.checkpoint_id_valid", rob_item[i].checkpoint_id_valid, i);
                                rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "rename_rob_data.checkpoint_id", rob_item[i].checkpoint_id, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.bru_op", rob_item[i].bru_op, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.bru_jump", rob_item[i].bru_jump, i);
                                rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.bru_next_pc", rob_item[i].bru_next_pc, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.is_mret", rob_item[i].is_mret, i);
                                rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "rename_rob_data.csr_addr", rob_item[i].csr_addr, i);
                                rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.csr_newvalue", rob_item[i].csr_newvalue, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.csr_newvalue_valid", rob_item[i].csr_newvalue_valid, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data_valid", 1, i);
                                rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rob_push", 1, 0);

                                //start to map source registers
                                if(rev_pack.rs1_need_map)
                                {
                                    assert(rat->get_phy_id(rev_pack.rs1, &send_pack.op_info[i].rs1_phy));
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_read_arch_id", rev_pack.rs1, i * 3);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rat_rename_read_phy_id", send_pack.op_info[i].rs1_phy, i * 3);

                                    rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rat_read_arch_id", rev_pack.rs1, i * 3);
                                    rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rat_rename_read_phy_id", send_pack.op_info[i].rs1_phy, i * 3);
                                }

                                if(rev_pack.rs2_need_map)
                                {
                                    assert(rat->get_phy_id(rev_pack.rs2, &send_pack.op_info[i].rs2_phy));
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_rat_read_arch_id", rev_pack.rs2, i * 3 + 1);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rat_rename_read_phy_id", send_pack.op_info[i].rs2_phy, i * 3 + 1);

                                    rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_rat_read_arch_id", rev_pack.rs2, i * 3 + 1);
                                    rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rat_rename_read_phy_id", send_pack.op_info[i].rs2_phy, i * 3 + 1);
                                }

                                //source registers feedback
                                if(rev_pack.valid)
                                {
                                    for(uint32_t j = 0;j < i;j++)
                                    {
                                        if(send_pack.op_info[j].enable && send_pack.op_info[j].valid && send_pack.op_info[j].rd_enable)
                                        {
                                            if(send_pack.op_info[i].rs1_need_map && (send_pack.op_info[i].rs1 == send_pack.op_info[j].rd))
                                            {
                                                send_pack.op_info[i].rs1_phy = send_pack.op_info[j].rd_phy;
                                            }

                                            if(send_pack.op_info[i].rs2_need_map && (send_pack.op_info[i].rs2 == send_pack.op_info[j].rd))
                                            {
                                                send_pack.op_info[i].rs2_phy = send_pack.op_info[j].rd_phy;
                                            }
                                        }
                                    }
                                }

                                if(rev_pack.valid && rev_pack.predicted && rev_pack.checkpoint_id_valid)
                                {
                                    component::checkpoint_t cp;
                                    global_cp.clone(cp);
                                    component::checkpoint_t origin_cp = checkpoint_buffer->get_item(rev_pack.checkpoint_id);
                                    cp.global_history = origin_cp.global_history;
                                    cp.local_history = origin_cp.local_history;
                                    checkpoint_buffer->set_item_sync(rev_pack.checkpoint_id, cp);

                                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_cpbuf_id", rev_pack.checkpoint_id, i);
                                    this->tdb.update_signal_bitmap(trace::domain_t::output, "rename_cpbuf_data.rat_phy_map_table_valid", &cp.rat_phy_map_table_valid, i);
                                    this->tdb.update_signal_bitmap(trace::domain_t::output, "rename_cpbuf_data.rat_phy_map_table_visible", &cp.rat_phy_map_table_visible, i);
                                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_cpbuf_data.global_history", cp.global_history, i);
                                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_cpbuf_data.local_history", cp.local_history, i);
                                    this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "rename_cpbuf_we", 1, i, 0);
                                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "cpbuf_rename_data.global_history", origin_cp.global_history, i);
                                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "cpbuf_rename_data.local_history", origin_cp.local_history, i);

                                    checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "rename_cpbuf_id", rev_pack.checkpoint_id, i);
	                                checkpoint_buffer->get_tdb()->update_signal_bitmap(trace::domain_t::input, "rename_cpbuf_data.rat_phy_map_table_valid", &cp.rat_phy_map_table_valid, i);
	                                checkpoint_buffer->get_tdb()->update_signal_bitmap(trace::domain_t::input, "rename_cpbuf_data.rat_phy_map_table_visible", &cp.rat_phy_map_table_visible, i);
	                                checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "rename_cpbuf_data.global_history", cp.global_history, i);
	                                checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "rename_cpbuf_data.local_history", cp.local_history, i);
	                                checkpoint_buffer->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_cpbuf_we", 1, i);
	                                checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "cpbuf_rename_data.global_history", origin_cp.global_history, i);
	                                checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "cpbuf_rename_data.local_history", origin_cp.local_history, i);
                                }

                                /*if(rev_pack.valid && (rev_pack.op_unit == op_unit_t::bru))
                                {
                                    break;
                                }*/

                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.enable", send_pack.op_info[i].enable, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.value", send_pack.op_info[i].value, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.valid", send_pack.op_info[i].valid, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rob_id", send_pack.op_info[i].rob_id, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.pc", send_pack.op_info[i].pc, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.imm", send_pack.op_info[i].imm, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.has_exception", send_pack.op_info[i].has_exception, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.exception_id", (uint32_t)send_pack.op_info[i].exception_id, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.exception_value", send_pack.op_info[i].exception_value, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.predicted", send_pack.op_info[i].predicted, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.predicted_jump", send_pack.op_info[i].predicted_jump, i);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rename_readreg_port_data_in.predicted_next_pc", send_pack.op_info[i].predicted_next_pc, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.checkpoint_id_valid", send_pack.op_info[i].checkpoint_id_valid, i);
                                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_readreg_port_data_in.checkpoint_id", send_pack.op_info[i].checkpoint_id, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs1", send_pack.op_info[i].rs1, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.arg1_src", (uint8_t)send_pack.op_info[i].arg1_src, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs1_need_map", send_pack.op_info[i].rs1_need_map, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs1_phy", send_pack.op_info[i].rs1_phy, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs2", send_pack.op_info[i].rs2, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.arg2_src", (uint8_t)send_pack.op_info[i].arg2_src, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs2_need_map", send_pack.op_info[i].rs2_need_map, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rs2_phy", send_pack.op_info[i].rs2_phy, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rd", send_pack.op_info[i].rd, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rd_enable", send_pack.op_info[i].rd_enable, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.need_rename", send_pack.op_info[i].need_rename, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.rd_phy", send_pack.op_info[i].rd_phy, i);
                                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rename_readreg_port_data_in.csr", send_pack.op_info[i].csr, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.op", (uint8_t)send_pack.op_info[i].op, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.op_unit", (uint8_t)send_pack.op_info[i].op_unit, i);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_data_in.sub_op", *(uint8_t *)&send_pack.op_info[i].sub_op, i);
                            }
                        }
                        else if(rat->get_free_phy_id(phy_reg_req_cnt, new_phy_reg_id) < phy_reg_req_cnt)
                        {
                            phy_regfile_full_add();
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_csrf_phy_regfile_full_add", 1, 0);

                            if(rob->get_free_space() < (rob_req_cnt))
                            {
                                rob_full_add();
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_csrf_rob_full_add", 1, 0);
                            }

                            assert(true);//phy_regfile is full
                            break;
                        }
                        else
                        {
                            rob_full_add();
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_csrf_rob_full_add", 1, 0);
                            assert(true);//is busy
                            break;
                        }
                    }
                    else
                    {
                        break;
                    }
                }

                rename_readreg_port->set(send_pack);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_we", 1, 0);
            }
        }
        else
        {
            rename_readreg_pack_t send_pack;
            memset(&send_pack, 0, sizeof(send_pack));
            rename_readreg_port->set(send_pack);
            busy = false;
            memset(&rev_pack, 0, sizeof(rev_pack));
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_readreg_port_flush", 1, 0);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rename_feedback_pack.idle", feedback_pack.idle, 0);
        
        this->tdb.capture_output_status();
        this->tdb.write_row();
        return feedback_pack;
    }
}