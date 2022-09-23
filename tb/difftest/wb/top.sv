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
    
    logic[`PHY_REG_ID_WIDTH - 1:0] wb_phyf_id[0:`WB_WIDTH - 1];
    logic[`REG_DATA_WIDTH - 1:0] wb_phyf_data[0:`WB_WIDTH - 1];
    logic[`WB_WIDTH - 1:0] wb_phyf_we;
    
    execute_wb_pack_t alu_wb_port_data_out[0:`ALU_UNIT_NUM - 1];
    execute_wb_pack_t bru_wb_port_data_out[0:`BRU_UNIT_NUM - 1];
    execute_wb_pack_t csr_wb_port_data_out[0:`CSR_UNIT_NUM - 1];
    execute_wb_pack_t div_wb_port_data_out[0:`DIV_UNIT_NUM - 1];
    execute_wb_pack_t lsu_wb_port_data_out[0:`LSU_UNIT_NUM - 1];
    execute_wb_pack_t mul_wb_port_data_out[0:`MUL_UNIT_NUM - 1];
    
    wb_commit_pack_t wb_commit_port_data_in;
    logic wb_commit_port_we;
    logic wb_commit_port_flush;
    
    wb_feedback_pack_t wb_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    execute_wb_pack_t execute_wb_port_data_out[0:`EXECUTE_UNIT_NUM - 1];

    integer i;
    longint cur_cycle;

    wb wb_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;

        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            alu_wb_port_data_out[i].enable = 'b1;
            alu_wb_port_data_out[i].valid = 'b1;
            alu_wb_port_data_out[i].has_exception = 'b0;
            alu_wb_port_data_out[i].rd_enable = 'b1;
            alu_wb_port_data_out[i].need_rename = 'b1;
            alu_wb_port_data_out[i].rd_phy = unsigned'(i);
            alu_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(i);
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            bru_wb_port_data_out[i].enable = 'b1;
            bru_wb_port_data_out[i].valid = 'b1;
            bru_wb_port_data_out[i].has_exception = 'b0;
            bru_wb_port_data_out[i].rd_enable = 'b1;
            bru_wb_port_data_out[i].need_rename = 'b1;
            bru_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + i);
            bru_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + i);
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            csr_wb_port_data_out[i].enable = 'b1;
            csr_wb_port_data_out[i].valid = 'b1;
            csr_wb_port_data_out[i].has_exception = 'b0;
            csr_wb_port_data_out[i].rd_enable = 'b1;
            csr_wb_port_data_out[i].need_rename = 'b1;
            csr_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + i);
            csr_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + i);
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            div_wb_port_data_out[i].enable = 'b1;
            div_wb_port_data_out[i].valid = 'b1;
            div_wb_port_data_out[i].has_exception = 'b0;
            div_wb_port_data_out[i].rd_enable = 'b1;
            div_wb_port_data_out[i].need_rename = 'b1;
            div_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + i);
            div_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + i);
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            lsu_wb_port_data_out[i].enable = 'b1;
            lsu_wb_port_data_out[i].valid = 'b1;
            lsu_wb_port_data_out[i].has_exception = 'b0;
            lsu_wb_port_data_out[i].rd_enable = 'b1;
            lsu_wb_port_data_out[i].need_rename = 'b1;
            lsu_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + i);
            lsu_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + i);
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            mul_wb_port_data_out[i].enable = 'b1;
            mul_wb_port_data_out[i].valid = 'b1;
            mul_wb_port_data_out[i].has_exception = 'b0;
            mul_wb_port_data_out[i].rd_enable = 'b1;
            mul_wb_port_data_out[i].need_rename = 'b1;
            mul_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + `LSU_UNIT_NUM + i);
            mul_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + `LSU_UNIT_NUM + i);
        end

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

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                execute_wb_port_data_out[i].enable = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.enable", i);
                execute_wb_port_data_out[i].value = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.value", i);
                execute_wb_port_data_out[i].valid = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.valid", i);
                execute_wb_port_data_out[i].rob_id = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rob_id", i);
                execute_wb_port_data_out[i].pc = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.pc", i);
                execute_wb_port_data_out[i].imm = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.imm", i);
                execute_wb_port_data_out[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.has_exception", i);
                execute_wb_port_data_out[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.exception_id", i));
                execute_wb_port_data_out[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.exception_value", i);
                execute_wb_port_data_out[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.predicted", i);
                execute_wb_port_data_out[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.predicted_jump", i);
                execute_wb_port_data_out[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.predicted_next_pc", i);
                execute_wb_port_data_out[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.checkpoint_id_valid", i);
                execute_wb_port_data_out[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "execute_wb_port_data_out.checkpoint_id", i);
                execute_wb_port_data_out[i].bru_jump = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.bru_jump", i);
                execute_wb_port_data_out[i].bru_next_pc = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.bru_next_pc", i);
                execute_wb_port_data_out[i].rs1 = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs1", i);
                execute_wb_port_data_out[i].arg1_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.arg1_src", i));
                execute_wb_port_data_out[i].rs1_need_map = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs1_need_map", i);
                execute_wb_port_data_out[i].rs1_phy = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs1_phy", i);
                execute_wb_port_data_out[i].src1_value = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.src1_value", i);
                execute_wb_port_data_out[i].src1_loaded = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.src1_loaded", i);
                execute_wb_port_data_out[i].rs2 = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs2", i);
                execute_wb_port_data_out[i].arg2_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.arg2_src", i));
                execute_wb_port_data_out[i].rs2_need_map = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs2_need_map", i);
                execute_wb_port_data_out[i].rs2_phy = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs2_phy", i);
                execute_wb_port_data_out[i].src2_value = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.src2_value", i);
                execute_wb_port_data_out[i].src2_loaded = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.src2_loaded", i);
                execute_wb_port_data_out[i].rd = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rd", i);
                execute_wb_port_data_out[i].rd_enable = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rd_enable", i);
                execute_wb_port_data_out[i].need_rename = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.need_rename", i);
                execute_wb_port_data_out[i].rd_phy = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rd_phy", i);
                execute_wb_port_data_out[i].rd_value = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.rd_value", i);
                execute_wb_port_data_out[i].csr = tdb.get_uint16(DOMAIN_INPUT, "execute_wb_port_data_out.csr", i);
                execute_wb_port_data_out[i].csr_newvalue = tdb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.csr_newvalue", i);
                execute_wb_port_data_out[i].csr_newvalue_valid = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.csr_newvalue_valid", i);
                execute_wb_port_data_out[i].op = op_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.op", i));
                execute_wb_port_data_out[i].op_unit = op_unit_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.op_unit", i));
                execute_wb_port_data_out[i].sub_op.raw_data = tdb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.sub_op", i);
            end

            for(i = 0;i < `ALU_UNIT_NUM;i++) begin
                alu_wb_port_data_out[i] = execute_wb_port_data_out[i];
            end

            for(i = 0;i < `BRU_UNIT_NUM;i++) begin
                bru_wb_port_data_out[i] = execute_wb_port_data_out[`ALU_UNIT_NUM + i];
            end

            for(i = 0;i < `CSR_UNIT_NUM;i++) begin
                csr_wb_port_data_out[i] = execute_wb_port_data_out[`ALU_UNIT_NUM + `BRU_UNIT_NUM + i];
            end

            for(i = 0;i < `DIV_UNIT_NUM;i++) begin
                div_wb_port_data_out[i] = execute_wb_port_data_out[`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + i];
            end

            for(i = 0;i < `LSU_UNIT_NUM;i++) begin
                lsu_wb_port_data_out[i] = execute_wb_port_data_out[`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + i];
            end

            for(i = 0;i < `MUL_UNIT_NUM;i++) begin
                mul_wb_port_data_out[i] = execute_wb_port_data_out[`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + `LSU_UNIT_NUM + i];
            end
            
            commit_feedback_pack.enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0);
            commit_feedback_pack.flush = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0);
            eval();
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_phyf_we", 0), wb_phyf_we)

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_flush", 0), wb_commit_port_flush)

            if(!wb_commit_port_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_we", 0), wb_commit_port_we)
            end
            
            if(!wb_commit_port_flush && wb_commit_port_we) begin
                for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.enable", i), wb_commit_port_data_in.op_info[i].enable)
                    
                    if(wb_commit_port_data_in.op_info[i].enable) begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.value", i), wb_commit_port_data_in.op_info[i].value)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.valid", i), wb_commit_port_data_in.op_info[i].valid)

                        if(wb_commit_port_data_in.op_info[i].valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.imm", i), wb_commit_port_data_in.op_info[i].imm)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rs1", i), wb_commit_port_data_in.op_info[i].rs1)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.arg1_src", i)), wb_commit_port_data_in.op_info[i].arg1_src)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rs1_need_map", i), wb_commit_port_data_in.op_info[i].rs1_need_map)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rs1_phy", i), wb_commit_port_data_in.op_info[i].rs1_phy)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.src1_value", i), wb_commit_port_data_in.op_info[i].src1_value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.src1_loaded", i), wb_commit_port_data_in.op_info[i].src1_loaded)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rs2", i), wb_commit_port_data_in.op_info[i].rs2)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.arg2_src", i)), wb_commit_port_data_in.op_info[i].arg2_src)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rs2_need_map", i), wb_commit_port_data_in.op_info[i].rs2_need_map)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rs2_phy", i), wb_commit_port_data_in.op_info[i].rs2_phy)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.src2_value", i), wb_commit_port_data_in.op_info[i].src2_value)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.src2_loaded", i), wb_commit_port_data_in.op_info[i].src2_loaded)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rd", i), wb_commit_port_data_in.op_info[i].rd)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rd_enable", i), wb_commit_port_data_in.op_info[i].rd_enable)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.need_rename", i), wb_commit_port_data_in.op_info[i].need_rename)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rd_phy", i), wb_commit_port_data_in.op_info[i].rd_phy)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.rd_value", i), wb_commit_port_data_in.op_info[i].rd_value)
                            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "wb_commit_port_data_in.csr", i), wb_commit_port_data_in.op_info[i].csr)
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.csr_newvalue_valid", i), wb_commit_port_data_in.op_info[i].csr_newvalue_valid)

                            if(wb_commit_port_data_in.op_info[i].csr_newvalue_valid) begin
                                 `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.csr_newvalue", i), wb_commit_port_data_in.op_info[i].csr_newvalue)
                            end

                            if(wb_phyf_we[i]) begin
                                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_phyf_id", i), wb_phyf_id[i])
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_phyf_data", i), wb_phyf_data[i])
                            end
                        end

                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.rob_id", i), wb_commit_port_data_in.op_info[i].rob_id)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.pc", i), wb_commit_port_data_in.op_info[i].pc)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.has_exception", i), wb_commit_port_data_in.op_info[i].has_exception)

                        if(wb_commit_port_data_in.op_info[i].has_exception) begin
                            `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.exception_id", i)), wb_commit_port_data_in.op_info[i].exception_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.exception_value", i), wb_commit_port_data_in.op_info[i].exception_value)
                        end
                            
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.predicted", i), wb_commit_port_data_in.op_info[i].predicted)

                        if(wb_commit_port_data_in.op_info[i].predicted) begin
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.predicted_jump", i), wb_commit_port_data_in.op_info[i].predicted_jump)

                            if(wb_commit_port_data_in.op_info[i].predicted_jump) begin
                                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.predicted_next_pc", i), wb_commit_port_data_in.op_info[i].predicted_next_pc)
                            end
                        end
                        
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.checkpoint_id_valid", i), wb_commit_port_data_in.op_info[i].checkpoint_id_valid)

                        if(wb_commit_port_data_in.op_info[i].checkpoint_id_valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "wb_commit_port_data_in.checkpoint_id", i), wb_commit_port_data_in.op_info[i].checkpoint_id)
                        end

                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.bru_jump", i), wb_commit_port_data_in.op_info[i].bru_jump)

                        if(wb_commit_port_data_in.op_info[i].bru_jump) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_commit_port_data_in.bru_next_pc", i), wb_commit_port_data_in.op_info[i].bru_next_pc)
                        end
                        
                        `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.op", i)), wb_commit_port_data_in.op_info[i].op)
                        `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.op_unit", i)), wb_commit_port_data_in.op_info[i].op_unit)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_commit_port_data_in.sub_op", i), wb_commit_port_data_in.op_info[i].sub_op.raw_data)
                    end
                end
            end

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_feedback_pack.enable", i), wb_feedback_pack.channel[i].enable)

                if(wb_feedback_pack.channel[i].enable) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "wb_feedback_pack.phy_id", i), wb_feedback_pack.channel[i].phy_id)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "wb_feedback_pack.value", i), wb_feedback_pack.channel[i].value)
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
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/wb.tdb"});
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