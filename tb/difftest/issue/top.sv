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
    
    logic stbuf_all_empty;
        
    logic[`PHY_REG_ID_WIDTH - 1:0] issue_phyf_id[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] phyf_issue_data[0:`READREG_WIDTH - 1][0:1];
    logic phyf_issue_data_valid[0:`READREG_WIDTH - 1][0:1];

    logic[`ADDR_WIDTH - 1:0] issue_stbuf_read_addr;
    logic[`SIZE_WIDTH - 1:0] issue_stbuf_read_size;
    logic issue_stbuf_rd;
    
    logic issue_csrf_issue_execute_fifo_full_add;
    logic issue_csrf_issue_queue_full_add;
    
    readreg_issue_pack_t readreg_issue_port_data_out;
    
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_full;
    issue_execute_pack_t issue_alu_fifo_data_in[0:`ALU_UNIT_NUM - 1];
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_push;
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_flush;
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_full;
    issue_execute_pack_t issue_bru_fifo_data_in[0:`BRU_UNIT_NUM - 1];
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_push;
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_flush;
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_full;
    issue_execute_pack_t issue_csr_fifo_data_in[0:`CSR_UNIT_NUM - 1];
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_push;
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_flush;
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_full;
    issue_execute_pack_t issue_div_fifo_data_in[0:`DIV_UNIT_NUM - 1];
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_push;
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_flush;
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_full;
    issue_execute_pack_t issue_lsu_fifo_data_in[0:`LSU_UNIT_NUM - 1];
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_push;
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_flush;
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_full;
    issue_execute_pack_t issue_mul_fifo_data_in[0:`MUL_UNIT_NUM - 1];
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_push;
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_flush;
    
    issue_feedback_pack_t issue_feedback_pack;
    execute_feedback_pack_t execute_feedback_pack;
    wb_feedback_pack_t wb_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    integer i, j, k;
    longint cur_cycle;

    issue issue_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task clear_input;
        //two ready alu instruction test
        for(i = 0;i < `READREG_WIDTH;i++) begin
            readreg_issue_port_data_out.op_info[i].enable = 'b0;
            readreg_issue_port_data_out.op_info[i].value = 'b0;
            readreg_issue_port_data_out.op_info[i].valid = 'b0;
            readreg_issue_port_data_out.op_info[i].rob_id = 'b0;
            readreg_issue_port_data_out.op_info[i].pc = 'b0;
            readreg_issue_port_data_out.op_info[i].imm = 'b0;
            readreg_issue_port_data_out.op_info[i].has_exception = 'b0;
            readreg_issue_port_data_out.op_info[i].exception_id = riscv_exception_t::instruction_address_misaligned;
            readreg_issue_port_data_out.op_info[i].exception_value = 'b0;
            readreg_issue_port_data_out.op_info[i].predicted = 'b0;
            readreg_issue_port_data_out.op_info[i].predicted_jump = 'b0;
            readreg_issue_port_data_out.op_info[i].predicted_next_pc = 'b0;
            readreg_issue_port_data_out.op_info[i].checkpoint_id_valid = 'b0;
            readreg_issue_port_data_out.op_info[i].checkpoint_id = 'b0;
            readreg_issue_port_data_out.op_info[i].rs1 = 'b0;
            readreg_issue_port_data_out.op_info[i].arg1_src = arg_src_t::_reg;
            readreg_issue_port_data_out.op_info[i].rs1_need_map = 'b0;
            readreg_issue_port_data_out.op_info[i].rs1_phy = 'b0;
            readreg_issue_port_data_out.op_info[i].src1_value = 'b0;
            readreg_issue_port_data_out.op_info[i].src1_loaded = 'b0;
            readreg_issue_port_data_out.op_info[i].rs2 = 'b0;
            readreg_issue_port_data_out.op_info[i].arg2_src = arg_src_t::_reg;
            readreg_issue_port_data_out.op_info[i].rs2_need_map = 'b0;
            readreg_issue_port_data_out.op_info[i].rs2_phy = 'b0;
            readreg_issue_port_data_out.op_info[i].src2_value = 'b0;
            readreg_issue_port_data_out.op_info[i].src2_loaded = 'b0;
            readreg_issue_port_data_out.op_info[i].rd = 'b0;
            readreg_issue_port_data_out.op_info[i].rd_enable = 'b0;
            readreg_issue_port_data_out.op_info[i].need_rename = 'b0;
            readreg_issue_port_data_out.op_info[i].rd_phy = 'b0;
            readreg_issue_port_data_out.op_info[i].csr = 'b0;
            readreg_issue_port_data_out.op_info[i].op = op_t::add;
            readreg_issue_port_data_out.op_info[i].op_unit = op_unit_t::alu;
            readreg_issue_port_data_out.op_info[i].sub_op.alu_op = alu_op_t::add;
        end
    endtask

    task test;
        rst = 1;
        stbuf_all_empty = 'b0;

        for(i = 0;i < `READREG_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                phyf_issue_data[i][j] = 'b0;
                phyf_issue_data_valid[i][j] = 'b0;
            end
        end

        clear_input();
        issue_alu_fifo_full = 'b0;
        issue_bru_fifo_full = 'b0;
        issue_csr_fifo_full = 'b0;
        issue_div_fifo_full = 'b0;
        issue_lsu_fifo_full = 'b0;
        issue_mul_fifo_full = 'b0;

        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            execute_feedback_pack.channel[i].enable = 'b0;
            execute_feedback_pack.channel[i].phy_id = 'b0;
            execute_feedback_pack.channel[i].value = 'b0;
            wb_feedback_pack.channel[i].enable = 'b0;
            wb_feedback_pack.channel[i].phy_id = 'b0;
            wb_feedback_pack.channel[i].value = 'b0;
        end

        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.next_handle_rob_id_valid = 'b0;
        commit_feedback_pack.has_exception = 'b0;
        commit_feedback_pack.exception_pc = 'b0;
        commit_feedback_pack.flush = 'b0;
        commit_feedback_pack.committed_rob_id = 'b0;
        commit_feedback_pack.committed_rob_id_valid = 'b0;
        commit_feedback_pack.jump_enable = 'b0;
        commit_feedback_pack.jump = 'b0;
        commit_feedback_pack.next_pc = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();

        while(1) begin
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "is_inst_waiting", 0), issue_inst.issue_queue_inst.is_inst_waiting)

            if(issue_inst.issue_queue_inst.is_inst_waiting) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "inst_waiting_rob_id", 0), issue_inst.issue_queue_inst.inst_waiting_rob_id)
            end

            if((cur_cycle == 0) || issue_inst.busy) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "last_index", 0), issue_inst.last_index)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "alu_index", 0), issue_inst.alu_index)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "bru_index", 0), issue_inst.bru_index)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "csr_index", 0), issue_inst.csr_index)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "div_index", 0), issue_inst.div_index)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "lsu_index", 0), issue_inst.lsu_index)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "mul_index", 0), issue_inst.mul_index)
            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();

            if(!tdb.read_cur_row()) begin
                break;
            end

            stbuf_all_empty = tdb.get_uint8(DOMAIN_INPUT, "stbuf_all_empty", 0);

            for(i = 0;i < `READREG_WIDTH;i++) begin
                for(j = 0;j < 2;j++) begin
                    phyf_issue_data[i][j] = tdb.get_uint32(DOMAIN_INPUT, "phyf_issue_data", i * 2 + j);
                    phyf_issue_data_valid[i][j] = tdb.get_uint8(DOMAIN_INPUT, "phyf_issue_data_valid", i * 2 + j);
                end
            end

            for(i = 0;i < `READREG_WIDTH;i++) begin
                readreg_issue_port_data_out.op_info[i].enable = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.enable", i);
                readreg_issue_port_data_out.op_info[i].value = tdb.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.value", i);
                readreg_issue_port_data_out.op_info[i].valid = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.valid", i);
                readreg_issue_port_data_out.op_info[i].rob_id = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rob_id", i);
                readreg_issue_port_data_out.op_info[i].pc = tdb.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.pc", i);
                readreg_issue_port_data_out.op_info[i].imm = tdb.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.imm", i);
                readreg_issue_port_data_out.op_info[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.has_exception", i);
                readreg_issue_port_data_out.op_info[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.exception_id", i));
                readreg_issue_port_data_out.op_info[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.exception_value", i);
                readreg_issue_port_data_out.op_info[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.predicted", i);
                readreg_issue_port_data_out.op_info[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.predicted_jump", i);
                readreg_issue_port_data_out.op_info[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.predicted_next_pc", i);
                readreg_issue_port_data_out.op_info[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.checkpoint_id_valid", i);
                readreg_issue_port_data_out.op_info[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "readreg_issue_port_data_out.checkpoint_id", i);
                readreg_issue_port_data_out.op_info[i].rs1 = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs1", i);
                readreg_issue_port_data_out.op_info[i].arg1_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.arg1_src", i));
                readreg_issue_port_data_out.op_info[i].rs1_need_map = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs1_need_map", i);
                readreg_issue_port_data_out.op_info[i].rs1_phy = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs1_phy", i);
                readreg_issue_port_data_out.op_info[i].src1_value = tdb.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.src1_value", i);
                readreg_issue_port_data_out.op_info[i].src1_loaded = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.src1_loaded", i);
                readreg_issue_port_data_out.op_info[i].rs2 = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs2", i);
                readreg_issue_port_data_out.op_info[i].arg2_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.arg2_src", i));
                readreg_issue_port_data_out.op_info[i].rs2_need_map = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs2_need_map", i);
                readreg_issue_port_data_out.op_info[i].rs2_phy = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs2_phy", i);
                readreg_issue_port_data_out.op_info[i].src2_value = tdb.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.src2_value", i);
                readreg_issue_port_data_out.op_info[i].src2_loaded = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.src2_loaded", i);
                readreg_issue_port_data_out.op_info[i].rd = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rd", i);
                readreg_issue_port_data_out.op_info[i].rd_enable = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rd_enable", i);
                readreg_issue_port_data_out.op_info[i].need_rename = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.need_rename", i);
                readreg_issue_port_data_out.op_info[i].rd_phy = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rd_phy", i);
                readreg_issue_port_data_out.op_info[i].csr = tdb.get_uint16(DOMAIN_INPUT, "readreg_issue_port_data_out.csr", i);
                readreg_issue_port_data_out.op_info[i].op = op_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.op", i));
                readreg_issue_port_data_out.op_info[i].op_unit = op_unit_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.op_unit", i));
                readreg_issue_port_data_out.op_info[i].sub_op.raw_data = tdb.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.sub_op", i);
            end

            issue_alu_fifo_full = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_full", 0);
            issue_bru_fifo_full = tdb.get_uint8(DOMAIN_INPUT, "issue_bru_fifo_full", 0);
            issue_csr_fifo_full = tdb.get_uint8(DOMAIN_INPUT, "issue_csr_fifo_full", 0);
            issue_div_fifo_full = tdb.get_uint8(DOMAIN_INPUT, "issue_div_fifo_full", 0);
            issue_lsu_fifo_full = tdb.get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_full", 0);
            issue_mul_fifo_full = tdb.get_uint8(DOMAIN_INPUT, "issue_mul_fifo_full", 0);

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                execute_feedback_pack.channel[i].enable = tdb.get_uint8(DOMAIN_INPUT, "execute_feedback_pack.enable", i);
                execute_feedback_pack.channel[i].phy_id = tdb.get_uint8(DOMAIN_INPUT, "execute_feedback_pack.phy_id", i);
                execute_feedback_pack.channel[i].value = tdb.get_uint32(DOMAIN_INPUT, "execute_feedback_pack.value", i);
            end

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                wb_feedback_pack.channel[i].enable = tdb.get_uint8(DOMAIN_INPUT, "wb_feedback_pack.enable", i);
                wb_feedback_pack.channel[i].phy_id = tdb.get_uint8(DOMAIN_INPUT, "wb_feedback_pack.phy_id", i);
                wb_feedback_pack.channel[i].value = tdb.get_uint32(DOMAIN_INPUT, "wb_feedback_pack.value", i);
            end

            commit_feedback_pack.enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0);
            commit_feedback_pack.next_handle_rob_id_valid = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.next_handle_rob_id_valid", 0);
            commit_feedback_pack.next_handle_rob_id = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.next_handle_rob_id", 0);
            commit_feedback_pack.has_exception = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.has_exception", 0);
            commit_feedback_pack.exception_pc = tdb.get_uint32(DOMAIN_INPUT, "commit_feedback_pack.exception_pc", 0);
            commit_feedback_pack.flush = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0);
            
            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                commit_feedback_pack.committed_rob_id[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.committed_rob_id", i);
            end

            commit_feedback_pack.committed_rob_id_valid = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.committed_rob_id_valid", 0);
            commit_feedback_pack.next_handle_rob_id_valid = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.next_handle_rob_id_valid", 0);
            commit_feedback_pack.jump_enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.jump_enable", 0);
            commit_feedback_pack.jump = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.jump", 0);
            commit_feedback_pack.next_pc = tdb.get_uint32(DOMAIN_INPUT, "commit_feedback_pack.next_pc", 0);
            eval();

            if(!(commit_feedback_pack.enable && commit_feedback_pack.flush)) begin
                for(i = 0;i < `READREG_WIDTH;i++) begin
                    if(readreg_issue_port_data_out.op_info[i].enable && readreg_issue_port_data_out.op_info[i].valid) begin
                        if(!readreg_issue_port_data_out.op_info[i].src1_loaded) begin
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_phyf_id", i * 2), issue_phyf_id[i][0])
                        end

                        if(!readreg_issue_port_data_out.op_info[i].src2_loaded) begin
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_phyf_id", i * 2 + 1), issue_phyf_id[i][1])
                        end
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_stbuf_rd", 0), issue_stbuf_rd)

            if(issue_stbuf_rd) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_stbuf_read_addr", 0), issue_stbuf_read_addr)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_stbuf_read_size", 0), issue_stbuf_read_size)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csrf_issue_execute_fifo_full_add", 0), issue_csrf_issue_execute_fifo_full_add)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csrf_issue_queue_full_add", 0), issue_csrf_issue_queue_full_add)

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_flush", 0), issue_alu_fifo_flush)

            if(!issue_alu_fifo_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_push", 0), issue_alu_fifo_push)
            end
            
            if(!issue_alu_fifo_flush) begin
                for(i = 0;i < `ALU_UNIT_NUM;i++) begin
                    if(issue_alu_fifo_push[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.enable", i), issue_alu_fifo_data_in[i].enable)
                        
                        if(issue_alu_fifo_data_in[i].enable) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.value", i), issue_alu_fifo_data_in[i].value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.valid", i), issue_alu_fifo_data_in[i].valid)

                            if(issue_alu_fifo_data_in[i].valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.imm", i), issue_alu_fifo_data_in[i].imm)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rs1", i), issue_alu_fifo_data_in[i].rs1)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.arg1_src", i)), issue_alu_fifo_data_in[i].arg1_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rs1_need_map", i), issue_alu_fifo_data_in[i].rs1_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rs1_phy", i), issue_alu_fifo_data_in[i].rs1_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.src1_value", i), issue_alu_fifo_data_in[i].src1_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.src1_loaded", i), issue_alu_fifo_data_in[i].src1_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rs2", i), issue_alu_fifo_data_in[i].rs2)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.arg2_src", i)), issue_alu_fifo_data_in[i].arg2_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rs2_need_map", i), issue_alu_fifo_data_in[i].rs2_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rs2_phy", i), issue_alu_fifo_data_in[i].rs2_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.src2_value", i), issue_alu_fifo_data_in[i].src2_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.src2_loaded", i), issue_alu_fifo_data_in[i].src2_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rd", i), issue_alu_fifo_data_in[i].rd)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rd_enable", i), issue_alu_fifo_data_in[i].rd_enable)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.need_rename", i), issue_alu_fifo_data_in[i].need_rename)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rd_phy", i), issue_alu_fifo_data_in[i].rd_phy)
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.csr", i), issue_alu_fifo_data_in[i].csr)
                            end

                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.rob_id", i), issue_alu_fifo_data_in[i].rob_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.pc", i), issue_alu_fifo_data_in[i].pc)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.has_exception", i), issue_alu_fifo_data_in[i].has_exception)

                            if(issue_alu_fifo_data_in[i].has_exception) begin
                                `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.exception_id", i)), issue_alu_fifo_data_in[i].exception_id)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.exception_value", i), issue_alu_fifo_data_in[i].exception_value)
                            end
                                
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.predicted", i), issue_alu_fifo_data_in[i].predicted)

                            if(issue_alu_fifo_data_in[i].predicted) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.predicted_jump", i), issue_alu_fifo_data_in[i].predicted_jump)

                                if(issue_alu_fifo_data_in[i].predicted_jump) begin
                                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.predicted_next_pc", i), issue_alu_fifo_data_in[i].predicted_next_pc)
                                end
                            end
                            
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.checkpoint_id_valid", i), issue_alu_fifo_data_in[i].checkpoint_id_valid)

                            if(issue_alu_fifo_data_in[i].checkpoint_id_valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.checkpoint_id", i), issue_alu_fifo_data_in[i].checkpoint_id)
                            end
                            
                            `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.op", i)), issue_alu_fifo_data_in[i].op)
                            `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.op_unit", i)), issue_alu_fifo_data_in[i].op_unit)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_data_in.sub_op", i), issue_alu_fifo_data_in[i].sub_op.raw_data)
                        end
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_flush", 0), issue_bru_fifo_flush)

            if(!issue_bru_fifo_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_push", 0), issue_bru_fifo_push)
            end
            
            if(!issue_bru_fifo_flush) begin
                for(i = 0;i < `BRU_UNIT_NUM;i++) begin
                    if(issue_bru_fifo_push[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.enable", i), issue_bru_fifo_data_in[i].enable)
                        
                        if(issue_bru_fifo_data_in[i].enable) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.value", i), issue_bru_fifo_data_in[i].value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.valid", i), issue_bru_fifo_data_in[i].valid)

                            if(issue_bru_fifo_data_in[i].valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.imm", i), issue_bru_fifo_data_in[i].imm)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rs1", i), issue_bru_fifo_data_in[i].rs1)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.arg1_src", i)), issue_bru_fifo_data_in[i].arg1_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rs1_need_map", i), issue_bru_fifo_data_in[i].rs1_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rs1_phy", i), issue_bru_fifo_data_in[i].rs1_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.src1_value", i), issue_bru_fifo_data_in[i].src1_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.src1_loaded", i), issue_bru_fifo_data_in[i].src1_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rs2", i), issue_bru_fifo_data_in[i].rs2)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.arg2_src", i)), issue_bru_fifo_data_in[i].arg2_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rs2_need_map", i), issue_bru_fifo_data_in[i].rs2_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rs2_phy", i), issue_bru_fifo_data_in[i].rs2_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.src2_value", i), issue_bru_fifo_data_in[i].src2_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.src2_loaded", i), issue_bru_fifo_data_in[i].src2_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rd", i), issue_bru_fifo_data_in[i].rd)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rd_enable", i), issue_bru_fifo_data_in[i].rd_enable)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.need_rename", i), issue_bru_fifo_data_in[i].need_rename)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rd_phy", i), issue_bru_fifo_data_in[i].rd_phy)
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.csr", i), issue_bru_fifo_data_in[i].csr)
                            end

                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.rob_id", i), issue_bru_fifo_data_in[i].rob_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.pc", i), issue_bru_fifo_data_in[i].pc)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.has_exception", i), issue_bru_fifo_data_in[i].has_exception)

                            if(issue_bru_fifo_data_in[i].has_exception) begin
                                `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.exception_id", i)), issue_bru_fifo_data_in[i].exception_id)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.exception_value", i), issue_bru_fifo_data_in[i].exception_value)
                            end
                                
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.predicted", i), issue_bru_fifo_data_in[i].predicted)

                            if(issue_bru_fifo_data_in[i].predicted) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.predicted_jump", i), issue_bru_fifo_data_in[i].predicted_jump)

                                if(issue_bru_fifo_data_in[i].predicted_jump) begin
                                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.predicted_next_pc", i), issue_bru_fifo_data_in[i].predicted_next_pc)
                                end
                            end
                            
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.checkpoint_id_valid", i), issue_bru_fifo_data_in[i].checkpoint_id_valid)

                            if(issue_bru_fifo_data_in[i].checkpoint_id_valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.checkpoint_id", i), issue_bru_fifo_data_in[i].checkpoint_id)
                            end
                            
                            `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.op", i)), issue_bru_fifo_data_in[i].op)
                            `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.op_unit", i)), issue_bru_fifo_data_in[i].op_unit)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_bru_fifo_data_in.sub_op", i), issue_bru_fifo_data_in[i].sub_op.raw_data)
                        end
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_flush", 0), issue_csr_fifo_flush)

            if(!issue_csr_fifo_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_push", 0), issue_csr_fifo_push)
            end
            
            if(!issue_csr_fifo_flush) begin
                for(i = 0;i < `CSR_UNIT_NUM;i++) begin
                    if(issue_csr_fifo_push[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.enable", i), issue_csr_fifo_data_in[i].enable)
                        
                        if(issue_csr_fifo_data_in[i].enable) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.value", i), issue_csr_fifo_data_in[i].value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.valid", i), issue_csr_fifo_data_in[i].valid)

                            if(issue_csr_fifo_data_in[i].valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.imm", i), issue_csr_fifo_data_in[i].imm)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rs1", i), issue_csr_fifo_data_in[i].rs1)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.arg1_src", i)), issue_csr_fifo_data_in[i].arg1_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rs1_need_map", i), issue_csr_fifo_data_in[i].rs1_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rs1_phy", i), issue_csr_fifo_data_in[i].rs1_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.src1_value", i), issue_csr_fifo_data_in[i].src1_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.src1_loaded", i), issue_csr_fifo_data_in[i].src1_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rs2", i), issue_csr_fifo_data_in[i].rs2)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.arg2_src", i)), issue_csr_fifo_data_in[i].arg2_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rs2_need_map", i), issue_csr_fifo_data_in[i].rs2_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rs2_phy", i), issue_csr_fifo_data_in[i].rs2_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.src2_value", i), issue_csr_fifo_data_in[i].src2_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.src2_loaded", i), issue_csr_fifo_data_in[i].src2_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rd", i), issue_csr_fifo_data_in[i].rd)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rd_enable", i), issue_csr_fifo_data_in[i].rd_enable)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.need_rename", i), issue_csr_fifo_data_in[i].need_rename)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rd_phy", i), issue_csr_fifo_data_in[i].rd_phy)
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.csr", i), issue_csr_fifo_data_in[i].csr)
                            end

                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.rob_id", i), issue_csr_fifo_data_in[i].rob_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.pc", i), issue_csr_fifo_data_in[i].pc)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.has_exception", i), issue_csr_fifo_data_in[i].has_exception)

                            if(issue_csr_fifo_data_in[i].has_exception) begin
                                `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.exception_id", i)), issue_csr_fifo_data_in[i].exception_id)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.exception_value", i), issue_csr_fifo_data_in[i].exception_value)
                            end
                                
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.predicted", i), issue_csr_fifo_data_in[i].predicted)

                            if(issue_csr_fifo_data_in[i].predicted) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.predicted_jump", i), issue_csr_fifo_data_in[i].predicted_jump)

                                if(issue_csr_fifo_data_in[i].predicted_jump) begin
                                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.predicted_next_pc", i), issue_csr_fifo_data_in[i].predicted_next_pc)
                                end
                            end
                            
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.checkpoint_id_valid", i), issue_csr_fifo_data_in[i].checkpoint_id_valid)

                            if(issue_csr_fifo_data_in[i].checkpoint_id_valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.checkpoint_id", i), issue_csr_fifo_data_in[i].checkpoint_id)
                            end
                            
                            `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.op", i)), issue_csr_fifo_data_in[i].op)
                            `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.op_unit", i)), issue_csr_fifo_data_in[i].op_unit)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_csr_fifo_data_in.sub_op", i), issue_csr_fifo_data_in[i].sub_op.raw_data)
                        end
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_flush", 0), issue_div_fifo_flush)

            if(!issue_div_fifo_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_push", 0), issue_div_fifo_push)
            end
            
            if(!issue_div_fifo_flush) begin
                for(i = 0;i < `DIV_UNIT_NUM;i++) begin
                    if(issue_div_fifo_push[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.enable", i), issue_div_fifo_data_in[i].enable)
                        
                        if(issue_div_fifo_data_in[i].enable) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_div_fifo_data_in.value", i), issue_div_fifo_data_in[i].value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.valid", i), issue_div_fifo_data_in[i].valid)

                            if(issue_div_fifo_data_in[i].valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_div_fifo_data_in.imm", i), issue_div_fifo_data_in[i].imm)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rs1", i), issue_div_fifo_data_in[i].rs1)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.arg1_src", i)), issue_div_fifo_data_in[i].arg1_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rs1_need_map", i), issue_div_fifo_data_in[i].rs1_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rs1_phy", i), issue_div_fifo_data_in[i].rs1_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_div_fifo_data_in.src1_value", i), issue_div_fifo_data_in[i].src1_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.src1_loaded", i), issue_div_fifo_data_in[i].src1_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rs2", i), issue_div_fifo_data_in[i].rs2)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.arg2_src", i)), issue_div_fifo_data_in[i].arg2_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rs2_need_map", i), issue_div_fifo_data_in[i].rs2_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rs2_phy", i), issue_div_fifo_data_in[i].rs2_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_div_fifo_data_in.src2_value", i), issue_div_fifo_data_in[i].src2_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.src2_loaded", i), issue_div_fifo_data_in[i].src2_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rd", i), issue_div_fifo_data_in[i].rd)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rd_enable", i), issue_div_fifo_data_in[i].rd_enable)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.need_rename", i), issue_div_fifo_data_in[i].need_rename)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rd_phy", i), issue_div_fifo_data_in[i].rd_phy)
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_div_fifo_data_in.csr", i), issue_div_fifo_data_in[i].csr)
                            end

                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.rob_id", i), issue_div_fifo_data_in[i].rob_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_div_fifo_data_in.pc", i), issue_div_fifo_data_in[i].pc)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.has_exception", i), issue_div_fifo_data_in[i].has_exception)

                            if(issue_div_fifo_data_in[i].has_exception) begin
                                `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "issue_div_fifo_data_in.exception_id", i)), issue_div_fifo_data_in[i].exception_id)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_div_fifo_data_in.exception_value", i), issue_div_fifo_data_in[i].exception_value)
                            end
                                
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.predicted", i), issue_div_fifo_data_in[i].predicted)

                            if(issue_div_fifo_data_in[i].predicted) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.predicted_jump", i), issue_div_fifo_data_in[i].predicted_jump)

                                if(issue_div_fifo_data_in[i].predicted_jump) begin
                                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_div_fifo_data_in.predicted_next_pc", i), issue_div_fifo_data_in[i].predicted_next_pc)
                                end
                            end
                            
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.checkpoint_id_valid", i), issue_div_fifo_data_in[i].checkpoint_id_valid)

                            if(issue_div_fifo_data_in[i].checkpoint_id_valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_div_fifo_data_in.checkpoint_id", i), issue_div_fifo_data_in[i].checkpoint_id)
                            end
                            
                            `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.op", i)), issue_div_fifo_data_in[i].op)
                            `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.op_unit", i)), issue_div_fifo_data_in[i].op_unit)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_div_fifo_data_in.sub_op", i), issue_div_fifo_data_in[i].sub_op.raw_data)
                        end
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_flush", 0), issue_lsu_fifo_flush)

            if(!issue_lsu_fifo_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_push", 0), issue_lsu_fifo_push)
            end
            
            if(!issue_lsu_fifo_flush) begin
                for(i = 0;i < `LSU_UNIT_NUM;i++) begin
                    if(issue_lsu_fifo_push[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.enable", i), issue_lsu_fifo_data_in[i].enable)
                        
                        if(issue_lsu_fifo_data_in[i].enable) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.value", i), issue_lsu_fifo_data_in[i].value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.valid", i), issue_lsu_fifo_data_in[i].valid)

                            if(issue_lsu_fifo_data_in[i].valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.imm", i), issue_lsu_fifo_data_in[i].imm)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rs1", i), issue_lsu_fifo_data_in[i].rs1)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.arg1_src", i)), issue_lsu_fifo_data_in[i].arg1_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rs1_need_map", i), issue_lsu_fifo_data_in[i].rs1_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rs1_phy", i), issue_lsu_fifo_data_in[i].rs1_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.src1_value", i), issue_lsu_fifo_data_in[i].src1_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.src1_loaded", i), issue_lsu_fifo_data_in[i].src1_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rs2", i), issue_lsu_fifo_data_in[i].rs2)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.arg2_src", i)), issue_lsu_fifo_data_in[i].arg2_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rs2_need_map", i), issue_lsu_fifo_data_in[i].rs2_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rs2_phy", i), issue_lsu_fifo_data_in[i].rs2_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.src2_value", i), issue_lsu_fifo_data_in[i].src2_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.src2_loaded", i), issue_lsu_fifo_data_in[i].src2_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rd", i), issue_lsu_fifo_data_in[i].rd)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rd_enable", i), issue_lsu_fifo_data_in[i].rd_enable)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.need_rename", i), issue_lsu_fifo_data_in[i].need_rename)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rd_phy", i), issue_lsu_fifo_data_in[i].rd_phy)
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.csr", i), issue_lsu_fifo_data_in[i].csr)
                            end

                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.rob_id", i), issue_lsu_fifo_data_in[i].rob_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.pc", i), issue_lsu_fifo_data_in[i].pc)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.has_exception", i), issue_lsu_fifo_data_in[i].has_exception)

                            if(issue_lsu_fifo_data_in[i].has_exception) begin
                                `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.exception_id", i)), issue_lsu_fifo_data_in[i].exception_id)
                            end

                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.exception_value", i), issue_lsu_fifo_data_in[i].exception_value)
                                
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.predicted", i), issue_lsu_fifo_data_in[i].predicted)

                            if(issue_lsu_fifo_data_in[i].predicted) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.predicted_jump", i), issue_lsu_fifo_data_in[i].predicted_jump)

                                if(issue_lsu_fifo_data_in[i].predicted_jump) begin
                                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.predicted_next_pc", i), issue_lsu_fifo_data_in[i].predicted_next_pc)
                                end
                            end
                            
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.checkpoint_id_valid", i), issue_lsu_fifo_data_in[i].checkpoint_id_valid)

                            if(issue_lsu_fifo_data_in[i].checkpoint_id_valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.checkpoint_id", i), issue_lsu_fifo_data_in[i].checkpoint_id)
                            end
                            
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.lsu_addr", i), issue_lsu_fifo_data_in[i].lsu_addr)
                            `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.op", i)), issue_lsu_fifo_data_in[i].op)
                            `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.op_unit", i)), issue_lsu_fifo_data_in[i].op_unit)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_lsu_fifo_data_in.sub_op", i), issue_lsu_fifo_data_in[i].sub_op.raw_data)
                        end
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_flush", 0), issue_mul_fifo_flush)

            if(!issue_mul_fifo_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_push", 0), issue_mul_fifo_push)
            end
            
            if(!issue_mul_fifo_flush) begin
                for(i = 0;i < `MUL_UNIT_NUM;i++) begin
                    if(issue_mul_fifo_push[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.enable", i), issue_mul_fifo_data_in[i].enable)
                        
                        if(issue_mul_fifo_data_in[i].enable) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.value", i), issue_mul_fifo_data_in[i].value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.valid", i), issue_mul_fifo_data_in[i].valid)

                            if(issue_mul_fifo_data_in[i].valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.imm", i), issue_mul_fifo_data_in[i].imm)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rs1", i), issue_mul_fifo_data_in[i].rs1)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.arg1_src", i)), issue_mul_fifo_data_in[i].arg1_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rs1_need_map", i), issue_mul_fifo_data_in[i].rs1_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rs1_phy", i), issue_mul_fifo_data_in[i].rs1_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.src1_value", i), issue_mul_fifo_data_in[i].src1_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.src1_loaded", i), issue_mul_fifo_data_in[i].src1_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rs2", i), issue_mul_fifo_data_in[i].rs2)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.arg2_src", i)), issue_mul_fifo_data_in[i].arg2_src)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rs2_need_map", i), issue_mul_fifo_data_in[i].rs2_need_map)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rs2_phy", i), issue_mul_fifo_data_in[i].rs2_phy)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.src2_value", i), issue_mul_fifo_data_in[i].src2_value)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.src2_loaded", i), issue_mul_fifo_data_in[i].src2_loaded)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rd", i), issue_mul_fifo_data_in[i].rd)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rd_enable", i), issue_mul_fifo_data_in[i].rd_enable)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.need_rename", i), issue_mul_fifo_data_in[i].need_rename)
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rd_phy", i), issue_mul_fifo_data_in[i].rd_phy)
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.csr", i), issue_mul_fifo_data_in[i].csr)
                            end

                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.rob_id", i), issue_mul_fifo_data_in[i].rob_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.pc", i), issue_mul_fifo_data_in[i].pc)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.has_exception", i), issue_mul_fifo_data_in[i].has_exception)

                            if(issue_mul_fifo_data_in[i].has_exception) begin
                                `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.exception_id", i)), issue_mul_fifo_data_in[i].exception_id)
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.exception_value", i), issue_mul_fifo_data_in[i].exception_value)
                            end
                                
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.predicted", i), issue_mul_fifo_data_in[i].predicted)

                            if(issue_mul_fifo_data_in[i].predicted) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.predicted_jump", i), issue_mul_fifo_data_in[i].predicted_jump)

                                if(issue_mul_fifo_data_in[i].predicted_jump) begin
                                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.predicted_next_pc", i), issue_mul_fifo_data_in[i].predicted_next_pc)
                                end
                            end
                            
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.checkpoint_id_valid", i), issue_mul_fifo_data_in[i].checkpoint_id_valid)

                            if(issue_mul_fifo_data_in[i].checkpoint_id_valid) begin
                                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.checkpoint_id", i), issue_mul_fifo_data_in[i].checkpoint_id)
                            end
                            
                            `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.op", i)), issue_mul_fifo_data_in[i].op)
                            `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.op_unit", i)), issue_mul_fifo_data_in[i].op_unit)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_mul_fifo_data_in.sub_op", i), issue_mul_fifo_data_in[i].sub_op.raw_data)
                        end
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_feedback_pack.stall", 0), issue_feedback_pack.stall)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "busy", 0), issue_inst.busy)
            wait_clk();
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/issue.tdb"});
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