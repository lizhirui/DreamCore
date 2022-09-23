#include "common.h"
#include "wb.h"

namespace pipeline
{
    wb::wb(component::port<execute_wb_pack_t> **alu_wb_port, component::port<execute_wb_pack_t> **bru_wb_port, component::port<execute_wb_pack_t> **csr_wb_port, component::port<execute_wb_pack_t> **div_wb_port, component::port<execute_wb_pack_t> **lsu_wb_port, component::port<execute_wb_pack_t> **mul_wb_port, component::port<wb_commit_pack_t> *wb_commit_port, component::regfile<phy_regfile_item_t> *phy_regfile, component::checkpoint_buffer *checkpoint_buffer) : tdb(TRACE_WB)
    {
        this->alu_wb_port = alu_wb_port;
        this->bru_wb_port = bru_wb_port;
        this->csr_wb_port = csr_wb_port;
        this->div_wb_port = div_wb_port;
        this->lsu_wb_port = lsu_wb_port;
        this->mul_wb_port = mul_wb_port;
        this->wb_commit_port = wb_commit_port;
        this->phy_regfile = phy_regfile;
        this->checkpoint_buffer = checkpoint_buffer;
    }

    void wb::reset()
    {
        this->tdb.create(TRACE_DIR + "wb.tdb");
        this->tdb.mark_signal(trace::domain_t::output, "wb_phyf_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_phyf_data", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_phyf_we", sizeof(uint8_t), 1);
        
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rob_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.imm", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.has_exception", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.exception_id", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.exception_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.predicted", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.predicted_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.predicted_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.checkpoint_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.checkpoint_id", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.bru_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.bru_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rs1", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.arg1_src", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rs1_need_map", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rs1_phy", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.src1_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.src1_loaded", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rs2", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.arg2_src", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rs2_need_map", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rs2_phy", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.src2_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.src2_loaded", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rd", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rd_enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.need_rename", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rd_phy", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.rd_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.csr", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.csr_newvalue", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.csr_newvalue_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.op", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.op_unit", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_wb_port_data_out.sub_op", sizeof(uint8_t), EXECUTE_UNIT_NUM);

        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rob_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.imm", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.has_exception", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.exception_id", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.exception_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.predicted", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.predicted_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.predicted_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.checkpoint_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.checkpoint_id", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.bru_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.bru_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rs1", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.arg1_src", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rs1_need_map", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rs1_phy", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.src1_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.src1_loaded", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rs2", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.arg2_src", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rs2_need_map", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rs2_phy", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.src2_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.src2_loaded", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rd", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rd_enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.need_rename", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rd_phy", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.rd_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.csr", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.csr_newvalue", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.csr_newvalue_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.op", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.op_unit", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_data_in.sub_op", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_we", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "wb_commit_port_flush", sizeof(uint8_t), 1);
    
        this->tdb.mark_signal(trace::domain_t::output, "wb_feedback_pack.enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_feedback_pack.phy_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "wb_feedback_pack.value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.flush", sizeof(uint8_t), 1);

        this->tdb.write_metainfo();
        this->tdb.trace_on();
        this->tdb.capture_status();
        this->tdb.write_row();
    }

    void wb::init()
    {
        for(auto i = 0;i < ALU_UNIT_NUM;i++)
        {
            this->execute_wb_port.push_back(alu_wb_port[i]);
        }

        for(auto i = 0;i < BRU_UNIT_NUM;i++)
        {
            this->execute_wb_port.push_back(bru_wb_port[i]);
        }

        for(auto i = 0;i < CSR_UNIT_NUM;i++)
        {
            this->execute_wb_port.push_back(csr_wb_port[i]);
        }

        for(auto i = 0;i < DIV_UNIT_NUM;i++)
        {
            this->execute_wb_port.push_back(div_wb_port[i]);
        }

        for(auto i = 0;i < LSU_UNIT_NUM;i++)
        {
            this->execute_wb_port.push_back(lsu_wb_port[i]);
        }

        for(auto i = 0;i < MUL_UNIT_NUM;i++)
        {
            this->execute_wb_port.push_back(mul_wb_port[i]);
        }
    }

    wb_feedback_pack_t wb::run(commit_feedback_pack_t commit_feedback_pack)
    {
        this->tdb.capture_input();
                
        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_phyf_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_phyf_data", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_phyf_we", 0, 0);
        
        
        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "execute_wb_port_data_out.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.bru_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.bru_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rd_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.rd_value", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "execute_wb_port_data_out.csr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.csr_newvalue", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.csr_newvalue_valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.sub_op", 0, i);
    
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "wb_commit_port_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.bru_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.bru_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rd_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.rd_value", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "wb_commit_port_data_in.csr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.csr_newvalue", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.csr_newvalue_valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_we", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_flush", 0, 0);
    
        
        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_feedback_pack.enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_feedback_pack.phy_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_feedback_pack.value", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", commit_feedback_pack.enable, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", commit_feedback_pack.flush, 0);
        
        wb_commit_pack_t send_pack;
        wb_feedback_pack_t feedback_pack;
        memset(&send_pack, 0, sizeof(send_pack));
        memset(&feedback_pack, 0, sizeof(feedback_pack));

        if(!(commit_feedback_pack.enable && commit_feedback_pack.flush))
        {
            for(auto i = 0;i < this->execute_wb_port.size();i++)
            {
                execute_wb_pack_t rev_pack;
                rev_pack = this->execute_wb_port[i]->get();

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.enable", rev_pack.enable, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.value", rev_pack.value, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.valid", rev_pack.valid, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rob_id", rev_pack.rob_id, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.pc", rev_pack.pc, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.imm", rev_pack.imm, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.has_exception", rev_pack.has_exception, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.exception_id", (uint32_t)rev_pack.exception_id, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.exception_value", rev_pack.exception_value, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.predicted", rev_pack.predicted, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.predicted_jump", rev_pack.predicted_jump, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.predicted_next_pc", rev_pack.predicted_next_pc, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.checkpoint_id_valid", rev_pack.checkpoint_id_valid, i);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "execute_wb_port_data_out.checkpoint_id", rev_pack.checkpoint_id, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.bru_jump", rev_pack.bru_jump, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.bru_next_pc", rev_pack.bru_next_pc, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs1", rev_pack.rs1, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.arg1_src", (uint8_t)rev_pack.arg1_src, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs1_need_map", rev_pack.rs1_need_map, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs1_phy", rev_pack.rs1_phy, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.src1_value", rev_pack.src1_value, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.src1_loaded", rev_pack.src1_loaded, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs2", rev_pack.rs2, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.arg2_src", (uint8_t)rev_pack.arg2_src, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs2_need_map", rev_pack.rs2_need_map, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rs2_phy", rev_pack.rs2_phy, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.src2_value", rev_pack.src2_value, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.src2_loaded", rev_pack.src2_loaded, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rd", rev_pack.rd, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rd_enable", rev_pack.rd_enable, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.need_rename", rev_pack.need_rename, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.rd_phy", rev_pack.rd_phy, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.rd_value", rev_pack.rd_value, i);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "execute_wb_port_data_out.csr", rev_pack.csr, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_wb_port_data_out.csr_newvalue", rev_pack.csr_newvalue, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.csr_newvalue_valid", rev_pack.csr_newvalue_valid, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.op", (uint8_t)rev_pack.op, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.op_unit", (uint8_t)rev_pack.op_unit, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_wb_port_data_out.sub_op", *(uint8_t *)&rev_pack.sub_op, i);
            
                send_pack.op_info[i].enable = rev_pack.enable;
                send_pack.op_info[i].value = rev_pack.value;
                send_pack.op_info[i].valid = rev_pack.valid;
                send_pack.op_info[i].rob_id = rev_pack.rob_id;
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

                send_pack.op_info[i].bru_jump = rev_pack.bru_jump;
                send_pack.op_info[i].bru_next_pc = rev_pack.bru_next_pc;

                send_pack.op_info[i].rs1 = rev_pack.rs1;
                send_pack.op_info[i].arg1_src = rev_pack.arg1_src;
                send_pack.op_info[i].rs1_need_map = rev_pack.rs1_need_map;
                send_pack.op_info[i].rs1_phy = rev_pack.rs1_phy;
                send_pack.op_info[i].src1_value = rev_pack.src1_value;
                send_pack.op_info[i].src1_loaded = rev_pack.src1_loaded;

                send_pack.op_info[i].rs2 = rev_pack.rs2;
                send_pack.op_info[i].arg2_src = rev_pack.arg2_src;
                send_pack.op_info[i].rs2_need_map = rev_pack.rs2_need_map;
                send_pack.op_info[i].rs2_phy = rev_pack.rs2_phy;
                send_pack.op_info[i].src2_value = rev_pack.src2_value;
                send_pack.op_info[i].src2_loaded = rev_pack.src2_loaded;

                send_pack.op_info[i].rd = rev_pack.rd;
                send_pack.op_info[i].rd_enable = rev_pack.rd_enable;
                send_pack.op_info[i].need_rename = rev_pack.need_rename;
                send_pack.op_info[i].rd_phy = rev_pack.rd_phy;
                send_pack.op_info[i].rd_value = rev_pack.rd_value;

                send_pack.op_info[i].csr = rev_pack.csr;
                send_pack.op_info[i].csr_newvalue = rev_pack.csr_newvalue;
                send_pack.op_info[i].csr_newvalue_valid = rev_pack.csr_newvalue_valid;
                send_pack.op_info[i].op = rev_pack.op;
                send_pack.op_info[i].op_unit = rev_pack.op_unit;
                memcpy(&send_pack.op_info[i].sub_op, &rev_pack.sub_op, sizeof(rev_pack.sub_op));

                if(rev_pack.enable && rev_pack.valid && !rev_pack.has_exception && rev_pack.rd_enable && rev_pack.need_rename)
                {
                    phy_regfile_item_t t_item;

                    t_item.value = rev_pack.rd_value;
                    //t_item.valid = true;
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_phyf_id", rev_pack.rd_phy, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_phyf_data", t_item.value, i);
                    this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "wb_phyf_we", 1, i, 0);

                    phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "wb_phyf_id", rev_pack.rd_phy, i);
	                phy_regfile->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "wb_phyf_data", t_item.value, i);
	                phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "wb_phyf_we", 1, i);

                    phy_regfile->write_sync(rev_pack.rd_phy, t_item, true);
                    feedback_pack.channel[i].enable = true;
                    feedback_pack.channel[i].phy_id = rev_pack.rd_phy;
                    feedback_pack.channel[i].value = rev_pack.rd_value;
                }

                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.enable", send_pack.op_info[i].enable, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.value", send_pack.op_info[i].value, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.valid", send_pack.op_info[i].valid, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rob_id", send_pack.op_info[i].rob_id, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.pc", send_pack.op_info[i].pc, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.imm", send_pack.op_info[i].imm, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.has_exception", send_pack.op_info[i].has_exception, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.exception_id", (uint32_t)send_pack.op_info[i].exception_id, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.exception_value", send_pack.op_info[i].exception_value, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.predicted", send_pack.op_info[i].predicted, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.predicted_jump", send_pack.op_info[i].predicted_jump, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.predicted_next_pc", send_pack.op_info[i].predicted_next_pc, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.checkpoint_id_valid", send_pack.op_info[i].checkpoint_id_valid, i);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "wb_commit_port_data_in.checkpoint_id", send_pack.op_info[i].checkpoint_id, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.bru_jump", send_pack.op_info[i].bru_jump, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.bru_next_pc", send_pack.op_info[i].bru_next_pc, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs1", send_pack.op_info[i].rs1, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.arg1_src", (uint8_t)send_pack.op_info[i].arg1_src, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs1_need_map", send_pack.op_info[i].rs1_need_map, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs1_phy", send_pack.op_info[i].rs1_phy, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.src1_value", send_pack.op_info[i].src1_value, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.src1_loaded", send_pack.op_info[i].src1_loaded, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs2", send_pack.op_info[i].rs2, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.arg2_src", (uint8_t)send_pack.op_info[i].arg2_src, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs2_need_map", send_pack.op_info[i].rs2_need_map, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rs2_phy", send_pack.op_info[i].rs2_phy, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.src2_value", send_pack.op_info[i].src2_value, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.src2_loaded", send_pack.op_info[i].src2_loaded, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rd", send_pack.op_info[i].rd, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rd_enable", send_pack.op_info[i].rd_enable, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.need_rename", send_pack.op_info[i].need_rename, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.rd_phy", send_pack.op_info[i].rd_phy, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.rd_value", send_pack.op_info[i].rd_value, i);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "wb_commit_port_data_in.csr", send_pack.op_info[i].csr, i);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_commit_port_data_in.csr_newvalue", send_pack.op_info[i].csr_newvalue, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.csr_newvalue_valid", send_pack.op_info[i].csr_newvalue_valid, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.op", (uint8_t)send_pack.op_info[i].op, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.op_unit", (uint8_t)send_pack.op_info[i].op_unit, i);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_data_in.sub_op", *(uint8_t *)&send_pack.op_info[i].sub_op, i);
            }

            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_we", 1, 0);
        }
        else
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_commit_port_flush", 1, 0);
        }

        wb_commit_port->set(send_pack);

        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_feedback_pack.enable", feedback_pack.channel[i].enable, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "wb_feedback_pack.phy_id", feedback_pack.channel[i].phy_id, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "wb_feedback_pack.value", feedback_pack.channel[i].value, i);
        }

        this->tdb.capture_output_status();
        this->tdb.write_row();
        return feedback_pack;
    }
}