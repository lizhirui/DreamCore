#include "common.h"
#include "config.h"
#include "pipeline_common.h"
#include "readreg.h"
#include "issue.h"
#include "wb.h"

namespace pipeline
{
    readreg::readreg(component::port<rename_readreg_pack_t> *rename_readreg_port, component::port<readreg_issue_pack_t> *readreg_issue_port, component::regfile<phy_regfile_item_t> *phy_regfile, component::checkpoint_buffer *checkpoint_buffer, component::rat *rat) : tdb(TRACE_READREG)
    {
        this->rename_readreg_port = rename_readreg_port;
        this->readreg_issue_port = readreg_issue_port;
        this->phy_regfile = phy_regfile;
        this->checkpoint_buffer = checkpoint_buffer;
        this->rat = rat;
    }

    void readreg::reset()
    {
        this->tdb.create(TRACE_DIR + "readreg.tdb");
        this->tdb.mark_signal(trace::domain_t::output, "readreg_phyf_id", sizeof(uint8_t), READREG_WIDTH * 2);
        this->tdb.mark_signal(trace::domain_t::input, "phyf_readreg_data", sizeof(uint32_t), READREG_WIDTH * 2);
        this->tdb.mark_signal(trace::domain_t::input, "phyf_readreg_data_valid", sizeof(uint8_t), READREG_WIDTH * 2);

        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.enable", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.valid", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rob_id", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.pc", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.imm", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.has_exception", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.exception_id", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.exception_value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.predicted", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.predicted_jump", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.predicted_next_pc", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.checkpoint_id_valid", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.checkpoint_id", sizeof(uint16_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rs1", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.arg1_src", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rs1_need_map", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rs1_phy", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rs2", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.arg2_src", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rs2_need_map", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rs2_phy", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rd", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rd_enable", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.need_rename", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.rd_phy", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.csr", sizeof(uint16_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.op", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.op_unit", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rename_readreg_port_data_out.sub_op", sizeof(uint8_t), READREG_WIDTH);

        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.enable", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.valid", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rob_id", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.pc", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.imm", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.has_exception", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.exception_id", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.exception_value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.predicted", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.predicted_jump", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.predicted_next_pc", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.checkpoint_id_valid", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.checkpoint_id", sizeof(uint16_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rs1", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.arg1_src", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rs1_need_map", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rs1_phy", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.src1_value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.src1_loaded", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rs2", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.arg2_src", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rs2_need_map", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rs2_phy", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.src2_value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.src2_loaded", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rd", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rd_enable", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.need_rename", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.rd_phy", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.csr", sizeof(uint16_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.op", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.op_unit", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_data_in.sub_op", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_we", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "readreg_issue_port_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "issue_feedback_pack.stall", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "execute_feedback_pack.enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_feedback_pack.phy_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_feedback_pack.value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_feedback_pack.enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_feedback_pack.phy_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_feedback_pack.value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.flush", sizeof(uint8_t), 1);

        this->tdb.write_metainfo();
        this->tdb.trace_on();
        this->tdb.capture_status();
        this->tdb.write_row();
    }

    void readreg::run(issue_feedback_pack_t issue_pack, execute_feedback_pack_t execute_feedback_pack, wb_feedback_pack_t wb_feedback_pack, commit_feedback_pack_t commit_feedback_pack)
    {
        this->tdb.capture_input();
                
        for(auto i = 0;i < READREG_WIDTH * 2;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_phyf_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "phyf_readreg_data", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "phyf_readreg_data_valid", 0, i);
        }

        for(auto i = 0;i < READREG_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rename_readreg_port_data_out.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs1_phy", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs2_phy", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rename_readreg_port_data_out.csr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.sub_op", 0, i);
    
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "readreg_issue_port_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "readreg_issue_port_data_in.csr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_we", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_feedback_pack.stall", 0, 0);
        
        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_feedback_pack.enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_feedback_pack.phy_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_feedback_pack.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_feedback_pack.enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_feedback_pack.phy_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_feedback_pack.value", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_feedback_pack.stall", issue_pack.stall, 0);
        
        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_feedback_pack.enable", execute_feedback_pack.channel[i].enable, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_feedback_pack.phy_id", execute_feedback_pack.channel[i].phy_id, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_feedback_pack.value", execute_feedback_pack.channel[i].value, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_feedback_pack.enable", wb_feedback_pack.channel[i].enable, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_feedback_pack.phy_id", wb_feedback_pack.channel[i].phy_id, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_feedback_pack.value", wb_feedback_pack.channel[i].value, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", commit_feedback_pack.enable, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", commit_feedback_pack.flush, 0);

        rename_readreg_pack_t rev_pack;
        bool stall = issue_pack.stall;

        if(!(commit_feedback_pack.enable && commit_feedback_pack.flush))
        {
            if(!stall)
            {   
                rev_pack = this->rename_readreg_port->get();

                readreg_issue_pack_t send_pack;
                memset(&send_pack, 0, sizeof(send_pack));

                //generate base send_pack
                for(uint32_t i = 0;i < READREG_WIDTH;i++)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.enable", rev_pack.op_info[i].enable, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.value", rev_pack.op_info[i].value, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.valid", rev_pack.op_info[i].valid, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rob_id", rev_pack.op_info[i].rob_id, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.pc", rev_pack.op_info[i].pc, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.imm", rev_pack.op_info[i].imm, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.has_exception", rev_pack.op_info[i].has_exception, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.exception_id", (uint32_t)rev_pack.op_info[i].exception_id, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.exception_value", rev_pack.op_info[i].exception_value, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.predicted", rev_pack.op_info[i].predicted, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.predicted_jump", rev_pack.op_info[i].predicted_jump, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_readreg_port_data_out.predicted_next_pc", rev_pack.op_info[i].predicted_next_pc, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.checkpoint_id_valid", rev_pack.op_info[i].checkpoint_id_valid, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rename_readreg_port_data_out.checkpoint_id", rev_pack.op_info[i].checkpoint_id, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs1", rev_pack.op_info[i].rs1, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.arg1_src", (uint8_t)rev_pack.op_info[i].arg1_src, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs1_need_map", rev_pack.op_info[i].rs1_need_map, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs1_phy", rev_pack.op_info[i].rs1_phy, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs2", rev_pack.op_info[i].rs2, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.arg2_src", (uint8_t)rev_pack.op_info[i].arg2_src, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs2_need_map", rev_pack.op_info[i].rs2_need_map, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rs2_phy", rev_pack.op_info[i].rs2_phy, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rd", rev_pack.op_info[i].rd, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rd_enable", rev_pack.op_info[i].rd_enable, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.need_rename", rev_pack.op_info[i].need_rename, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.rd_phy", rev_pack.op_info[i].rd_phy, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rename_readreg_port_data_out.csr", rev_pack.op_info[i].csr, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.op", (uint8_t)rev_pack.op_info[i].op, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.op_unit", (uint8_t)rev_pack.op_info[i].op_unit, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_readreg_port_data_out.sub_op", *(uint8_t *)&rev_pack.op_info[i].sub_op, i);

                    send_pack.op_info[i].enable = rev_pack.op_info[i].enable;
                    send_pack.op_info[i].value = rev_pack.op_info[i].value;
                    send_pack.op_info[i].valid = rev_pack.op_info[i].valid;
                    send_pack.op_info[i].rob_id = rev_pack.op_info[i].rob_id;
                    send_pack.op_info[i].pc = rev_pack.op_info[i].pc;
                    send_pack.op_info[i].imm = rev_pack.op_info[i].imm;
                    send_pack.op_info[i].has_exception = rev_pack.op_info[i].has_exception;
                    send_pack.op_info[i].exception_id = rev_pack.op_info[i].exception_id;
                    send_pack.op_info[i].exception_value = rev_pack.op_info[i].exception_value;

                    send_pack.op_info[i].predicted = rev_pack.op_info[i].predicted;
                    send_pack.op_info[i].predicted_jump = rev_pack.op_info[i].predicted_jump;
                    send_pack.op_info[i].predicted_next_pc = rev_pack.op_info[i].predicted_next_pc;
                    send_pack.op_info[i].checkpoint_id_valid = rev_pack.op_info[i].checkpoint_id_valid;
                    send_pack.op_info[i].checkpoint_id = rev_pack.op_info[i].checkpoint_id;

                    send_pack.op_info[i].rs1 = rev_pack.op_info[i].rs1;
                    send_pack.op_info[i].arg1_src = rev_pack.op_info[i].arg1_src;
                    send_pack.op_info[i].rs1_need_map = rev_pack.op_info[i].rs1_need_map;
                    send_pack.op_info[i].rs1_phy = rev_pack.op_info[i].rs1_phy;

                    send_pack.op_info[i].rs2 = rev_pack.op_info[i].rs2;
                    send_pack.op_info[i].arg2_src = rev_pack.op_info[i].arg2_src;
                    send_pack.op_info[i].rs2_need_map = rev_pack.op_info[i].rs2_need_map;
                    send_pack.op_info[i].rs2_phy = rev_pack.op_info[i].rs2_phy;

                    send_pack.op_info[i].rd = rev_pack.op_info[i].rd;
                    send_pack.op_info[i].rd_enable = rev_pack.op_info[i].rd_enable;
                    send_pack.op_info[i].need_rename = rev_pack.op_info[i].need_rename;
                    send_pack.op_info[i].rd_phy = rev_pack.op_info[i].rd_phy;

                    send_pack.op_info[i].csr = rev_pack.op_info[i].csr;
                    send_pack.op_info[i].op = rev_pack.op_info[i].op;
                    send_pack.op_info[i].op_unit = rev_pack.op_info[i].op_unit;
                    memcpy(&send_pack.op_info[i].sub_op, &rev_pack.op_info[i].sub_op, sizeof(rev_pack.op_info[i].sub_op));
                }

                for(uint32_t i = 0;i < READREG_WIDTH;i++)
                {
                    if(rev_pack.op_info[i].enable && rev_pack.op_info[i].valid)
                    {
                        if(rev_pack.op_info[i].rs1_need_map)
                        {
                            auto reg_item = phy_regfile->read(rev_pack.op_info[i].rs1_phy);
                            auto reg_data_valid = phy_regfile->read_data_valid(rev_pack.op_info[i].rs1_phy);

                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_phyf_id", rev_pack.op_info[i].rs1_phy, i * 2);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "phyf_readreg_data", reg_item.value, i * 2);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "phyf_readreg_data_valid", reg_data_valid, i * 2);

                            phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "readreg_phyf_id", rev_pack.op_info[i].rs1_phy, i * 2);
	                        phy_regfile->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "phyf_readreg_data", reg_item.value, i * 2);
	                        phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "phyf_readreg_data_valid", reg_data_valid, i * 2);

                            if(reg_data_valid)
                            {
                                send_pack.op_info[i].src1_value = reg_item.value;
                                send_pack.op_info[i].src1_loaded = true;
                            }
                            else
                            {
                                for(auto j = 0;j < EXECUTE_UNIT_NUM;j++)
                                {
                                    if(execute_feedback_pack.channel[j].enable && (rev_pack.op_info[i].rs1_phy == execute_feedback_pack.channel[j].phy_id))
                                    {
                                        send_pack.op_info[i].src1_value = execute_feedback_pack.channel[j].value;
                                        send_pack.op_info[i].src1_loaded = true;
                                        break;
                                    }
                                    else if(wb_feedback_pack.channel[j].enable && (rev_pack.op_info[i].rs1_phy == wb_feedback_pack.channel[j].phy_id))
                                    {
                                        send_pack.op_info[i].src1_value = wb_feedback_pack.channel[j].value;
                                        send_pack.op_info[i].src1_loaded = true;
                                        break;
                                    }
                                }
                            }
                        }
                        else if(rev_pack.op_info[i].arg1_src == arg_src_t::imm)
                        {
                            send_pack.op_info[i].src1_value = rev_pack.op_info[i].imm;
                            send_pack.op_info[i].src1_loaded = true;
                        }
                        else
                        {
                            send_pack.op_info[i].src1_value = 0;
                            send_pack.op_info[i].src1_loaded = true;
                        }

                        if(rev_pack.op_info[i].rs2_need_map)
                        {
                            auto reg_item = phy_regfile->read(rev_pack.op_info[i].rs2_phy);
                            auto reg_data_valid = phy_regfile->read_data_valid(rev_pack.op_info[i].rs2_phy);

                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_phyf_id", rev_pack.op_info[i].rs2_phy, i * 2 + 1);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "phyf_readreg_data", reg_item.value, i * 2 + 1);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "phyf_readreg_data_valid", reg_data_valid, i * 2 + 1);

                            phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "readreg_phyf_id", rev_pack.op_info[i].rs2_phy, i * 2 + 1);
	                        phy_regfile->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "phyf_readreg_data", reg_item.value, i * 2 + 1);
	                        phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "phyf_readreg_data_valid", reg_data_valid, i * 2 + 1);

                            if(reg_data_valid)
                            {
                                send_pack.op_info[i].src2_value = reg_item.value;
                                send_pack.op_info[i].src2_loaded = true;
                            }
                            else
                            {
                                for(auto j = 0;j < EXECUTE_UNIT_NUM;j++)
                                {
                                    if(execute_feedback_pack.channel[j].enable && (rev_pack.op_info[i].rs2_phy == execute_feedback_pack.channel[j].phy_id))
                                    {
                                        send_pack.op_info[i].src2_value = execute_feedback_pack.channel[j].value;
                                        send_pack.op_info[i].src2_loaded = true;
                                        break;
                                    }
                                    else if(wb_feedback_pack.channel[j].enable && (rev_pack.op_info[i].rs2_phy == wb_feedback_pack.channel[j].phy_id))
                                    {
                                        send_pack.op_info[i].src2_value = wb_feedback_pack.channel[j].value;
                                        send_pack.op_info[i].src2_loaded = true;
                                        break;
                                    }
                                }
                            }
                        }
                        else if(rev_pack.op_info[i].arg2_src == arg_src_t::imm)
                        {
                            send_pack.op_info[i].src2_value = rev_pack.op_info[i].imm;
                            send_pack.op_info[i].src2_loaded = true;
                        }
                        else
                        {
                            send_pack.op_info[i].src2_value = 0;
                            send_pack.op_info[i].src2_loaded = true;
                        }
                    }
                    else
                    {
                        //pass issue stage for invalid items
                        send_pack.op_info[i].src1_loaded = true;
                        send_pack.op_info[i].src2_loaded = true;
                    }

                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.enable", send_pack.op_info[i].enable, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.value", send_pack.op_info[i].value, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.valid", send_pack.op_info[i].valid, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rob_id", send_pack.op_info[i].rob_id, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.pc", send_pack.op_info[i].pc, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.imm", send_pack.op_info[i].imm, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.has_exception", send_pack.op_info[i].has_exception, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.exception_id", (uint32_t)send_pack.op_info[i].exception_id, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.exception_value", send_pack.op_info[i].exception_value, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.predicted", send_pack.op_info[i].predicted, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.predicted_jump", send_pack.op_info[i].predicted_jump, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.predicted_next_pc", send_pack.op_info[i].predicted_next_pc, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.checkpoint_id_valid", send_pack.op_info[i].checkpoint_id_valid, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "readreg_issue_port_data_in.checkpoint_id", send_pack.op_info[i].checkpoint_id, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs1", send_pack.op_info[i].rs1, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.arg1_src", (uint8_t)send_pack.op_info[i].arg1_src, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs1_need_map", send_pack.op_info[i].rs1_need_map, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs1_phy", send_pack.op_info[i].rs1_phy, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.src1_value", send_pack.op_info[i].src1_value, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.src1_loaded", send_pack.op_info[i].src1_loaded, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs2", send_pack.op_info[i].rs2, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.arg2_src", (uint8_t)send_pack.op_info[i].arg2_src, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs2_need_map", send_pack.op_info[i].rs2_need_map, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rs2_phy", send_pack.op_info[i].rs2_phy, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "readreg_issue_port_data_in.src2_value", send_pack.op_info[i].src2_value, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.src2_loaded", send_pack.op_info[i].src2_loaded, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rd", send_pack.op_info[i].rd, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rd_enable", send_pack.op_info[i].rd_enable, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.need_rename", send_pack.op_info[i].need_rename, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.rd_phy", send_pack.op_info[i].rd_phy, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "readreg_issue_port_data_in.csr", send_pack.op_info[i].csr, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.op", (uint8_t)send_pack.op_info[i].op, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.op_unit", (uint8_t)send_pack.op_info[i].op_unit, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_data_in.sub_op", *(uint8_t *)&send_pack.op_info[i].sub_op, i);
                }

                readreg_issue_port->set(send_pack);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_we", 1, 0);
            }
        }
        else
        {
            readreg_issue_pack_t send_pack;
            memset(&send_pack, 0, sizeof(send_pack));
            readreg_issue_port->set(send_pack);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "readreg_issue_port_flush", 1, 0);
        }

        this->tdb.capture_output_status();
        this->tdb.write_row();
    }
}
