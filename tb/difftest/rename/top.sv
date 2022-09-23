`timescale 1ns/100ps
`include "tdb_reader.svh"
`include "config.svh"
`include "common.svh"

import tdb_reader::*;

import "DPI-C" function string getenv(input string env_name);

`define assert(condition) assert((condition)) else begin #10; $finish; end
`define assert_cycle(_cycle, condition) assert((condition)) else begin $display("cycle = %0d", (_cycle)); #10; $finish; end
`define assert_equal(_cycle, _expected, _actual) assert((_expected) == (_actual)) else begin $display("cycle = %0d, expected = %0x, actual = %0x", (_cycle), (_expected), (_actual)); #10; $finish; end

module top;
    tdb_reader tdb;

    logic clk;
    logic rst;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] rename_cpbuf_id[0:`RENAME_WIDTH - 1];
    checkpoint_t rename_cpbuf_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_cpbuf_we;
    checkpoint_t cpbuf_rename_data[0:`RENAME_WIDTH - 1];
    
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_new_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rat_rename_new_phy_id_valid;
    logic[`PHY_REG_ID_WIDTH - 1:0] rename_rat_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rat_phy_id_valid;
    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_arch_id[0:`RENAME_WIDTH - 1];
    logic rename_rat_map;
    
    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_valid;
    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_visible;
    
    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_read_arch_id[0:`RENAME_WIDTH - 1][0:2];
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_read_phy_id[0:`RENAME_WIDTH - 1][0:2];
    
    logic[`ROB_ID_WIDTH - 1:0] rob_rename_new_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rob_rename_new_id_valid;
    
    rob_item_t rename_rob_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rob_data_valid;
    logic rename_rob_push;
    
    logic rename_csrf_phy_regfile_full_add;
    logic rename_csrf_rob_full_add;
    
    decode_rename_pack_t decode_rename_fifo_data_out[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] decode_rename_fifo_data_out_valid;
    logic[`RENAME_WIDTH - 1:0] decode_rename_fifo_data_pop_valid;
    logic decode_rename_fifo_pop;
    
    rename_readreg_pack_t rename_readreg_port_data_in;
    logic rename_readreg_port_we;
    logic rename_readreg_port_flush;
    
    rename_feedback_pack_t rename_feedback_pack;
    issue_feedback_pack_t issue_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    checkpoint_t cp;
    decode_rename_pack_t t_pack;

    integer i, j;
    longint cur_cycle;

    rename rename_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        cp.rat_phy_map_table_valid = 'b0;
        cp.rat_phy_map_table_visible = 'b0;
        cp.global_history = 'b0;
        cp.local_history = 'b0;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            cpbuf_rename_data[i] = cp;
            rat_rename_new_phy_id[i] = 'b0;
            rat_rename_new_phy_id_valid = 'b0;
        end

        rat_rename_map_table_valid = 'b0;
        rat_rename_map_table_visible = 'b0;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            for(j = 0;j < 3;j++) begin
                rat_rename_read_phy_id[i][j] = 'b0;
            end

            rob_rename_new_id[i] = 'b0;
        end

        rob_rename_new_id_valid = 'b0;

        t_pack.enable = 'b0;
        t_pack.value = 'b0;
        t_pack.valid = 'b0;
        t_pack.pc = 'b0;
        t_pack.imm = 'b0;
        t_pack.has_exception = 'b0;
        t_pack.exception_id = riscv_exception_t::instruction_address_misaligned;
        t_pack.exception_value = 'b0;
        t_pack.predicted = 'b0;
        t_pack.predicted_jump = 'b0;
        t_pack.predicted_next_pc = 'b0;
        t_pack.checkpoint_id_valid = 'b0;
        t_pack.checkpoint_id = 'b0;
        t_pack.rs1 = 'b0;
        t_pack.arg1_src = arg_src_t::_reg;
        t_pack.rs1_need_map = 'b0;
        t_pack.rs2 = 'b0;
        t_pack.arg2_src = arg_src_t::_reg;
        t_pack.rs2_need_map = 'b0;
        t_pack.rd = 'b0;
        t_pack.rd_enable = 'b0;
        t_pack.need_rename = 'b0;
        t_pack.csr = 'b0;
        t_pack.op = op_t::add;
        t_pack.op_unit = op_unit_t::alu;
        t_pack.sub_op.alu_op = alu_op_t::add;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            decode_rename_fifo_data_out[i] = t_pack;
        end

        decode_rename_fifo_data_out_valid = 'b0;
        issue_feedback_pack.stall = 'b0;
        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.flush = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();

        while(1) begin
            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();

            if(!tdb.read_cur_row()) begin
                break;
            end

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                cpbuf_rename_data[i].global_history = tdb.get_uint16(DOMAIN_INPUT, "cpbuf_rename_data.global_history", i);
                cpbuf_rename_data[i].local_history = tdb.get_uint16(DOMAIN_INPUT, "cpbuf_rename_data.local_history", i);
                rat_rename_new_phy_id[i] = tdb.get_uint8(DOMAIN_INPUT, "rat_rename_new_phy_id", i);
            end

            rat_rename_new_phy_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rat_rename_new_phy_id_valid", 0);
            rat_rename_map_table_valid = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "rat_rename_map_table_valid", 0);
            rat_rename_map_table_visible = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "rat_rename_map_table_visible", 0);

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                for(j = 0;j < 3;j++) begin
                    rat_rename_read_phy_id[i][j] = tdb.get_uint8(DOMAIN_INPUT, "rat_rename_read_phy_id", i * 3 + j);
                end
            end

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                rob_rename_new_id[i] = tdb.get_uint8(DOMAIN_INPUT, "rob_rename_new_id", i);
            end

            rob_rename_new_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_rename_new_id_valid", 0);

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                decode_rename_fifo_data_out[i].enable = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.enable", i);
                decode_rename_fifo_data_out[i].value = tdb.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.value", i);
                decode_rename_fifo_data_out[i].valid = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.valid", i);
                decode_rename_fifo_data_out[i].pc = tdb.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.pc", i);
                decode_rename_fifo_data_out[i].imm = tdb.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.imm", i);
                decode_rename_fifo_data_out[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.has_exception", i);
                decode_rename_fifo_data_out[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.exception_id", i));
                decode_rename_fifo_data_out[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.exception_value", i);
                decode_rename_fifo_data_out[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.predicted", i);
                decode_rename_fifo_data_out[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.predicted_jump", i);
                decode_rename_fifo_data_out[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.predicted_next_pc", i);
                decode_rename_fifo_data_out[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.checkpoint_id_valid", i);
                decode_rename_fifo_data_out[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "decode_rename_fifo_data_out.checkpoint_id", i);
                decode_rename_fifo_data_out[i].rs1 = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rs1", i);
                decode_rename_fifo_data_out[i].arg1_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.arg1_src", i));
                decode_rename_fifo_data_out[i].rs1_need_map = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rs1_need_map", i);
                decode_rename_fifo_data_out[i].rs2 = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rs2", i);
                decode_rename_fifo_data_out[i].arg2_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.arg2_src", i));
                decode_rename_fifo_data_out[i].rs2_need_map = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rs2_need_map", i);
                decode_rename_fifo_data_out[i].rd = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rd", i);
                decode_rename_fifo_data_out[i].rd_enable = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rd_enable", i);
                decode_rename_fifo_data_out[i].need_rename = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.need_rename", i);
                decode_rename_fifo_data_out[i].csr = tdb.get_uint16(DOMAIN_INPUT, "decode_rename_fifo_data_out.csr", i);
                decode_rename_fifo_data_out[i].op = op_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.op", i));
                decode_rename_fifo_data_out[i].op_unit = op_unit_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.op_unit", i));
                decode_rename_fifo_data_out[i].sub_op.raw_data = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.sub_op", i);
            end

            decode_rename_fifo_data_out_valid = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out_valid", 0);

            issue_feedback_pack.stall = tdb.get_uint8(DOMAIN_INPUT, "issue_feedback_pack.stall", 0);
            commit_feedback_pack.enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0);
            commit_feedback_pack.flush = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0);
            eval();

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_feedback_pack.idle", 0), rename_feedback_pack.idle)

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_pop", 0), decode_rename_fifo_pop)

            if(decode_rename_fifo_pop) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_pop_valid", 0), decode_rename_fifo_data_pop_valid)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_cpbuf_we", 0), rename_cpbuf_we)

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                if(rename_cpbuf_we[i]) begin
                    `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "rename_cpbuf_data.rat_phy_map_table_valid", i), rename_cpbuf_data[i].rat_phy_map_table_valid)
                    `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "rename_cpbuf_data.rat_phy_map_table_visible", i), rename_cpbuf_data[i].rat_phy_map_table_visible)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rename_cpbuf_data.global_history", i), rename_cpbuf_data[i].global_history)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rename_cpbuf_data.local_history", i), rename_cpbuf_data[i].local_history)
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_flush", 0), rename_readreg_port_flush)

            if(!rename_readreg_port_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_we", 0), rename_readreg_port_we)
            end

            if(tdb.get_uint8(DOMAIN_OUTPUT, "rename_rat_map", 0) != 0) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rat_phy_id_valid", 0), rename_rat_phy_id_valid)
            end

            if(rename_rat_phy_id_valid != 0) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rat_map", 0), rename_rat_map)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data_valid", 0), rename_rob_data_valid)

            if(rename_rob_data_valid != 0) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_push", 0), rename_rob_push)
            end

            if(rename_rob_push && (rename_rob_data_valid != 0)) begin
                for(i = 0;i < `RENAME_WIDTH;i++) begin
                    if(rename_rob_data_valid[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.old_phy_reg_id_valid", i), rename_rob_data[i].old_phy_reg_id_valid)

                        if(rename_rob_data[i].old_phy_reg_id_valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.new_phy_reg_id", i), rename_rob_data[i].new_phy_reg_id)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.old_phy_reg_id", i), rename_rob_data[i].old_phy_reg_id)
                        end

                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.finish", i), rename_rob_data[i].finish)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_rob_data.pc", i), rename_rob_data[i].pc)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_rob_data.inst_value", i), rename_rob_data[i].inst_value)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.has_exception", i), rename_rob_data[i].has_exception)
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "rename_rob_data.exception_id", i)), rename_rob_data[i].exception_id)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_rob_data.exception_value", i), rename_rob_data[i].exception_value)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.predicted", i), rename_rob_data[i].predicted)

                        if(rename_rob_data[i].predicted) begin
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.predicted_jump", i), rename_rob_data[i].predicted_jump)

                            if(rename_rob_data[i].predicted_jump) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_rob_data.predicted_next_pc", i), rename_rob_data[i].predicted_next_pc)
                            end
                        end

                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.checkpoint_id_valid", i), rename_rob_data[i].checkpoint_id_valid)

                        if(rename_rob_data[i].checkpoint_id_valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_rob_data.checkpoint_id", i), rename_rob_data[i].checkpoint_id)
                        end

                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.bru_op", i), rename_rob_data[i].bru_op)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.bru_jump", i), rename_rob_data[i].bru_jump)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_rob_data.bru_next_pc", i), rename_rob_data[i].bru_next_pc)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.is_mret", i), rename_rob_data[i].is_mret)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rob_data.csr_newvalue_valid", i), rename_rob_data[i].csr_newvalue_valid)

                        if(rename_rob_data[i].csr_newvalue_valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rename_rob_data.csr_addr", i), rename_rob_data[i].csr_addr)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_rob_data.csr_newvalue", i), rename_rob_data[i].csr_newvalue)
                        end


                    end
                end
            end
            
            if(!rename_readreg_port_flush && rename_readreg_port_we) begin
                for(i = 0;i < `RENAME_WIDTH;i++) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.enable", i), rename_readreg_port_data_in.op_info[i].enable)

                    if(rename_readreg_port_data_in.op_info[i].enable) begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_readreg_port_data_in.value", i), rename_readreg_port_data_in.op_info[i].value)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.valid", i), rename_readreg_port_data_in.op_info[i].valid)

                        if(rename_readreg_port_data_in.op_info[i].valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_readreg_port_data_in.imm", i), rename_readreg_port_data_in.op_info[i].imm)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rs1", i), rename_readreg_port_data_in.op_info[i].rs1)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.arg1_src", i)), rename_readreg_port_data_in.op_info[i].arg1_src)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rs1_need_map", i), rename_readreg_port_data_in.op_info[i].rs1_need_map)

                            if(rename_readreg_port_data_in.op_info[i].rs1_need_map) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rs1_phy", i), rename_readreg_port_data_in.op_info[i].rs1_phy)
                            end
                            
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rs2", i), rename_readreg_port_data_in.op_info[i].rs2)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.arg2_src", i)), rename_readreg_port_data_in.op_info[i].arg2_src)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rs2_need_map", i), rename_readreg_port_data_in.op_info[i].rs2_need_map)

                            if(rename_readreg_port_data_in.op_info[i].rs2_need_map) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rs2_phy", i), rename_readreg_port_data_in.op_info[i].rs2_phy)
                            end

                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rd", i), rename_readreg_port_data_in.op_info[i].rd)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rd_enable", i), rename_readreg_port_data_in.op_info[i].rd_enable)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.need_rename", i), rename_readreg_port_data_in.op_info[i].need_rename)

                            if(rename_readreg_port_data_in.op_info[i].rd_enable && rename_readreg_port_data_in.op_info[i].need_rename) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rd_phy", i), rename_readreg_port_data_in.op_info[i].rd_phy)
                            end

                            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rename_readreg_port_data_in.csr", i), rename_readreg_port_data_in.op_info[i].csr)

                            if(rename_readreg_port_data_in.op_info[i].rs1_need_map) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rat_read_arch_id", i * 3), rename_rat_read_arch_id[i][0])
                            end

                            if(rename_readreg_port_data_in.op_info[i].rs2_need_map) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rat_read_arch_id", i * 3 + 1), rename_rat_read_arch_id[i][1])
                            end

                            if(rename_readreg_port_data_in.op_info[i].need_rename) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rat_read_arch_id", i * 3 + 2), rename_rat_read_arch_id[i][2])
                            end

                            if(rename_rat_phy_id_valid[i]) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rat_phy_id", i), rename_rat_phy_id[i])
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_rat_arch_id", i), rename_rat_arch_id[i])
                            end
                        end

                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.rob_id", i), rename_readreg_port_data_in.op_info[i].rob_id)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_readreg_port_data_in.pc", i), rename_readreg_port_data_in.op_info[i].pc)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.has_exception", i), rename_readreg_port_data_in.op_info[i].has_exception)

                        if(rename_readreg_port_data_in.op_info[i].has_exception) begin
                            `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "rename_readreg_port_data_in.exception_id", i)), rename_readreg_port_data_in.op_info[i].exception_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_readreg_port_data_in.exception_value", i), rename_readreg_port_data_in.op_info[i].exception_value)
                        end
                            
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.predicted", i), rename_readreg_port_data_in.op_info[i].predicted)

                        if(rename_readreg_port_data_in.op_info[i].predicted) begin
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.predicted_jump", i), rename_readreg_port_data_in.op_info[i].predicted_jump)

                            if(rename_readreg_port_data_in.op_info[i].predicted_jump) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rename_readreg_port_data_in.predicted_next_pc", i), rename_readreg_port_data_in.op_info[i].predicted_next_pc)
                            end
                        end
                        
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.checkpoint_id_valid", i), rename_readreg_port_data_in.op_info[i].checkpoint_id_valid)

                        if(rename_readreg_port_data_in.op_info[i].checkpoint_id_valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rename_readreg_port_data_in.checkpoint_id", i), rename_readreg_port_data_in.op_info[i].checkpoint_id)
                            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rename_cpbuf_id", i), rename_cpbuf_id[i])
                        end
                        
                        `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.op", i)), rename_readreg_port_data_in.op_info[i].op)
                        `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.op_unit", i)), rename_readreg_port_data_in.op_info[i].op_unit)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_readreg_port_data_in.sub_op", i), rename_readreg_port_data_in.op_info[i].sub_op.raw_data)
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_csrf_phy_regfile_full_add", 0), rename_csrf_phy_regfile_full_add)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rename_csrf_rob_full_add", 0), rename_csrf_rob_full_add)
            wait_clk();
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/rename.tdb"});
        test();
        $display("TEST PASSED");
        $finish;
    end

    `ifdef FSDB_DUMP
        initial begin
            $fsdbDumpfile("top.fsdb");
            $fsdbDumpvars(0, 0, "+all");
            $fsdbDumpMDA();
        end
    `endif
endmodule