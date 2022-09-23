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
    
    logic[`PHY_REG_ID_WIDTH - 1:0] readreg_phyf_id[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] phyf_readreg_data[0:`READREG_WIDTH - 1][0:1];
    logic phyf_readreg_data_valid[0:`READREG_WIDTH - 1][0:1];
    
    rename_readreg_pack_t rename_readreg_port_data_out;
    
    readreg_issue_pack_t readreg_issue_port_data_in;
    logic readreg_issue_port_we;
    logic readreg_issue_port_flush;
    
    issue_feedback_pack_t issue_feedback_pack;
    execute_feedback_pack_t execute_feedback_pack;
    wb_feedback_pack_t wb_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    rename_readreg_op_info_t t_pack;

    integer i, j, k;
    longint cur_cycle;

    readreg readreg_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        
        for(i = 0;i < `READREG_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                phyf_readreg_data[i][j] = 'b0;
                phyf_readreg_data_valid[i][j] = 'b0;
            end
        end

        t_pack.enable = 'b0;
        t_pack.value = 'b0;
        t_pack.valid = 'b0;
        t_pack.rob_id = 'b0;
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
        t_pack.rs1_phy = 'b0;
        t_pack.rs2 = 'b0;
        t_pack.arg2_src = arg_src_t::_reg;
        t_pack.rs2_need_map = 'b0;
        t_pack.rs2_phy = 'b0;
        t_pack.rd = 'b0;
        t_pack.rd_enable = 'b0;
        t_pack.need_rename = 'b0;
        t_pack.rd_phy = 'b0;
        t_pack.op = op_t::add;
        t_pack.op_unit = op_unit_t::alu;
        t_pack.sub_op.alu_op = alu_op_t::add;
        rename_readreg_port_data_out.op_info[i] = t_pack;
        issue_feedback_pack.stall = 'b0;
        
        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            execute_feedback_pack.channel[i].enable = 'b0;
            execute_feedback_pack.channel[i].phy_id = 'b0;
            execute_feedback_pack.channel[i].value = 'b0;
        end

        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            wb_feedback_pack.channel[i].enable = 'b0;
            wb_feedback_pack.channel[i].phy_id = 'b0;
            wb_feedback_pack.channel[i].value = 'b0;
        end

        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.next_handle_rob_id_valid = 'b0;
        commit_feedback_pack.next_handle_rob_id = 'b0;
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
            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();

            if(!tdb.read_cur_row()) begin
                break;
            end

            for(i = 0;i < `READREG_WIDTH;i++) begin
                for(j = 0;j < 2;j++) begin
                    phyf_readreg_data[i][j] = tdb.get_uint32(DOMAIN_INPUT, "phyf_readreg_data", i * 2 + j);
                    phyf_readreg_data_valid[i][j] = tdb.get_uint8(DOMAIN_INPUT, "phyf_readreg_data_valid", i * 2 + j);
                end 
            end

            for(i = 0;i < `READREG_WIDTH;i++) begin
                rename_readreg_port_data_out.op_info[i].enable = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.enable", i);
                rename_readreg_port_data_out.op_info[i].value = tdb.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.value", i);
                rename_readreg_port_data_out.op_info[i].valid = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.valid", i);
                rename_readreg_port_data_out.op_info[i].rob_id = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rob_id", i);
                rename_readreg_port_data_out.op_info[i].pc = tdb.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.pc", i);
                rename_readreg_port_data_out.op_info[i].imm = tdb.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.imm", i);
                rename_readreg_port_data_out.op_info[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.has_exception", i);
                rename_readreg_port_data_out.op_info[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.exception_id", i));
                rename_readreg_port_data_out.op_info[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.exception_value", i);
                rename_readreg_port_data_out.op_info[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.predicted", i);
                rename_readreg_port_data_out.op_info[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.predicted_jump", i);
                rename_readreg_port_data_out.op_info[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.predicted_next_pc", i);
                rename_readreg_port_data_out.op_info[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.checkpoint_id_valid", i);
                rename_readreg_port_data_out.op_info[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "rename_readreg_port_data_out.checkpoint_id", i);
                rename_readreg_port_data_out.op_info[i].rs1 = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs1", i);
                rename_readreg_port_data_out.op_info[i].arg1_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.arg1_src", i));
                rename_readreg_port_data_out.op_info[i].rs1_need_map = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs1_need_map", i);
                rename_readreg_port_data_out.op_info[i].rs1_phy = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs1_phy", i);
                rename_readreg_port_data_out.op_info[i].rs2 = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs2", i);
                rename_readreg_port_data_out.op_info[i].arg2_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.arg2_src", i));
                rename_readreg_port_data_out.op_info[i].rs2_need_map = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs2_need_map", i);
                rename_readreg_port_data_out.op_info[i].rs2_phy = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs2_phy", i);
                rename_readreg_port_data_out.op_info[i].rd = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rd", i);
                rename_readreg_port_data_out.op_info[i].rd_enable = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rd_enable", i);
                rename_readreg_port_data_out.op_info[i].need_rename = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.need_rename", i);
                rename_readreg_port_data_out.op_info[i].rd_phy = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rd_phy", i);
                rename_readreg_port_data_out.op_info[i].csr = tdb.get_uint16(DOMAIN_INPUT, "rename_readreg_port_data_out.csr", i);
                rename_readreg_port_data_out.op_info[i].op = op_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.op", i));
                rename_readreg_port_data_out.op_info[i].op_unit = op_unit_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.op_unit", i));
                rename_readreg_port_data_out.op_info[i].sub_op.raw_data = tdb.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.sub_op", i);
            end

            issue_feedback_pack.stall = tdb.get_uint8(DOMAIN_INPUT, "issue_feedback_pack.stall", 0);

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                execute_feedback_pack.channel[i].enable = tdb.get_uint8(DOMAIN_INPUT, "execute_feedback_pack.enable", i);
                execute_feedback_pack.channel[i].phy_id = tdb.get_uint8(DOMAIN_INPUT, "execute_feedback_pack.phy_id", i);
                execute_feedback_pack.channel[i].value = tdb.get_uint32(DOMAIN_INPUT, "execute_feedback_pack.value", i);
                wb_feedback_pack.channel[i].enable = tdb.get_uint8(DOMAIN_INPUT, "wb_feedback_pack.enable", i);
                wb_feedback_pack.channel[i].phy_id = tdb.get_uint8(DOMAIN_INPUT, "wb_feedback_pack.phy_id", i);
                wb_feedback_pack.channel[i].value = tdb.get_uint32(DOMAIN_INPUT, "wb_feedback_pack.value", i);
            end

            commit_feedback_pack.enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0);
            commit_feedback_pack.flush = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0);
            eval();

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_flush", 0), readreg_issue_port_flush)

            if(!readreg_issue_port_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_we", 0), readreg_issue_port_we)
            end
            
            if(!readreg_issue_port_flush && readreg_issue_port_we) begin
                for(i = 0;i < `READREG_WIDTH;i++) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.enable", i), readreg_issue_port_data_in.op_info[i].enable)

                    if(readreg_issue_port_data_in.op_info[i].enable) begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "readreg_issue_port_data_in.value", i), readreg_issue_port_data_in.op_info[i].value)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.valid", i), readreg_issue_port_data_in.op_info[i].valid)

                        if(readreg_issue_port_data_in.op_info[i].valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "readreg_issue_port_data_in.imm", i), readreg_issue_port_data_in.op_info[i].imm)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rs1", i), readreg_issue_port_data_in.op_info[i].rs1)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.arg1_src", i)), readreg_issue_port_data_in.op_info[i].arg1_src)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rs1_need_map", i), readreg_issue_port_data_in.op_info[i].rs1_need_map)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rs1_phy", i), readreg_issue_port_data_in.op_info[i].rs1_phy)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "readreg_issue_port_data_in.src1_value", i), readreg_issue_port_data_in.op_info[i].src1_value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.src1_loaded", i), readreg_issue_port_data_in.op_info[i].src1_loaded)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rs2", i), readreg_issue_port_data_in.op_info[i].rs2)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.arg2_src", i)), readreg_issue_port_data_in.op_info[i].arg2_src)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rs2_need_map", i), readreg_issue_port_data_in.op_info[i].rs2_need_map)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rs2_phy", i), readreg_issue_port_data_in.op_info[i].rs2_phy)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "readreg_issue_port_data_in.src2_value", i), readreg_issue_port_data_in.op_info[i].src2_value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.src2_loaded", i), readreg_issue_port_data_in.op_info[i].src2_loaded)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rd", i), readreg_issue_port_data_in.op_info[i].rd)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rd_enable", i), readreg_issue_port_data_in.op_info[i].rd_enable)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.need_rename", i), readreg_issue_port_data_in.op_info[i].need_rename)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rd_phy", i), readreg_issue_port_data_in.op_info[i].rd_phy)
                            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "readreg_issue_port_data_in.csr", i), readreg_issue_port_data_in.op_info[i].csr)

                            if(readreg_issue_port_data_in.op_info[i].rs1_need_map) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_phyf_id", i * 2), readreg_phyf_id[i][0])
                            end

                            if(readreg_issue_port_data_in.op_info[i].rs2_need_map) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_phyf_id", i * 2 + 1), readreg_phyf_id[i][1])
                            end
                        end

                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.rob_id", i), readreg_issue_port_data_in.op_info[i].rob_id)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "readreg_issue_port_data_in.pc", i), readreg_issue_port_data_in.op_info[i].pc)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.has_exception", i), readreg_issue_port_data_in.op_info[i].has_exception)

                        if(readreg_issue_port_data_in.op_info[i].has_exception) begin
                            `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "readreg_issue_port_data_in.exception_id", i)), readreg_issue_port_data_in.op_info[i].exception_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "readreg_issue_port_data_in.exception_value", i), readreg_issue_port_data_in.op_info[i].exception_value)
                        end
                            
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.predicted", i), readreg_issue_port_data_in.op_info[i].predicted)

                        if(readreg_issue_port_data_in.op_info[i].predicted) begin
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.predicted_jump", i), readreg_issue_port_data_in.op_info[i].predicted_jump)

                            if(readreg_issue_port_data_in.op_info[i].predicted_jump) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "readreg_issue_port_data_in.predicted_next_pc", i), readreg_issue_port_data_in.op_info[i].predicted_next_pc)
                            end
                        end
                        
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.checkpoint_id_valid", i), readreg_issue_port_data_in.op_info[i].checkpoint_id_valid)

                        if(readreg_issue_port_data_in.op_info[i].checkpoint_id_valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "readreg_issue_port_data_in.checkpoint_id", i), readreg_issue_port_data_in.op_info[i].checkpoint_id)
                        end
                        
                        `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.op", i)), readreg_issue_port_data_in.op_info[i].op)
                        `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.op_unit", i)), readreg_issue_port_data_in.op_info[i].op_unit)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "readreg_issue_port_data_in.sub_op", i), readreg_issue_port_data_in.op_info[i].sub_op.raw_data)
                    end
                end
            end

            wait_clk();
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/readreg.tdb"});
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