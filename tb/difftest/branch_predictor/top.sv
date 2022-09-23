`timescale 1ns/100ps
`include "tdb_reader.svh"
`include "config.svh"
`include "common.svh"

import tdb_reader::*;

import "DPI-C" function string getenv(input string env_name);

`define assert(condition) assert((condition)) else begin #10; $finish; end
`define assert_cycle(_cycle, condition) assert((condition)) else begin $display("cycle = %0d", (_cycle)); #10; $finish; end
`define assert_equal(_cycle, _expected, _actual) assert((_expected) == (_actual)) else begin dump_info(); $display("cycle = %0d, expected = %0x, actual = %0x", (_cycle), (_expected), (_actual)); #10; $finish; end

module top;
    tdb_reader tdb;

    logic clk;
    logic rst;
    
    logic[`ADDR_WIDTH -1:0] fetch_bp_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_instruction;
    logic fetch_bp_valid;
    logic bp_fetch_jump;
    logic[`ADDR_WIDTH - 1:0] bp_fetch_next_pc;
    logic bp_fetch_valid;
    logic[`GSHARE_GLOBAL_HISTORY_WIDTH - 1:0] bp_fetch_global_history;
    logic[`LOCAL_BHT_WIDTH - 1:0] bp_fetch_local_history; 
    
    logic[`ADDR_WIDTH - 1:0] fetch_bp_update_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_update_instruction;
    logic fetch_bp_update_jump;
    logic[`ADDR_WIDTH - 1:0] fetch_bp_update_next_pc;
    logic fetch_bp_update_valid;
    
    logic[`ADDR_WIDTH - 1:0] bp_ras_addr;
    logic bp_ras_push;
    logic[`ADDR_WIDTH - 1:0] ras_bp_addr;
    logic bp_ras_pop;
    
    checkpoint_t exbru_bp_cp;
    logic[`ADDR_WIDTH -1:0] exbru_bp_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] exbru_bp_instruction;
    logic exbru_bp_jump;
    logic[`ADDR_WIDTH - 1:0] exbru_bp_next_pc;
    logic exbru_bp_hit;
    logic exbru_bp_valid;
    
    logic[`ADDR_WIDTH -1:0] commit_bp_pc[0:`COMMIT_WIDTH - 1];
    logic[`INSTRUCTION_WIDTH - 1:0] commit_bp_instruction[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_jump;
    logic[`ADDR_WIDTH - 1:0] commit_bp_next_pc[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_hit;
    logic[`COMMIT_WIDTH - 1:0] commit_bp_valid;

    logic ras_csrf_ras_full_add;//no test

    checkpoint_t cp;

    integer i, j;
    longint cur_cycle;

    branch_predictor branch_predictor_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task dump_info;
        $display("--------Actual Information--------");
        $display("fetch <-> bp");
        $display("fetch_bp_pc = %08x", fetch_bp_pc);
        $display("fetch_bp_instruction = %08x", fetch_bp_instruction);
        $display("fetch_bp_valid = %0x", fetch_bp_valid);
        $display("bp_fetch_jump = %0x", bp_fetch_jump);
        $display("bp_fetch_next_pc = %08x", bp_fetch_next_pc);
        $display("bp_fetch_valid = %0x", bp_fetch_valid);
        $display("bp_fetch_global_history = %03x", bp_fetch_global_history);
        $display("bp_fetch_local_history = %03x", bp_fetch_local_history);
        $display("fetch_bp_update_pc = %08x", fetch_bp_update_pc);
        $display("fetch_bp_update_instruction = %08x", fetch_bp_update_instruction);
        $display("fetch_bp_update_jump = %0x", fetch_bp_update_jump);
        $display("fetch_bp_update_next_pc = %08x", fetch_bp_update_next_pc);
        $display("fetch_bp_update_valid = %0x", fetch_bp_update_valid);
        $display("");
        $display("ras <-> bp");
        $display("bp_ras_addr = %08x", bp_ras_addr);
        $display("bp_ras_push = %0x", bp_ras_push);
        $display("ras_bp_addr = %08x", ras_bp_addr);
        $display("bp_ras_pop = %0x", bp_ras_pop);
        $display("");
        $display("exbru <-> bp");
        $display("exbru_bp_cp.global_history = %03x", exbru_bp_cp.global_history);
        $display("exbru_bp_cp.local_history = %03x", exbru_bp_cp.local_history);
        $display("exbru_bp_pc = %08x", exbru_bp_pc);
        $display("exbru_bp_instruction = %08x", exbru_bp_instruction);
        $display("exbru_bp_jump = %0x", exbru_bp_jump);
        $display("exbru_bp_next_pc = %08x", exbru_bp_next_pc);
        $display("exbru_bp_hit = %0x", exbru_bp_hit);
        $display("exbru_bp_valid = %0x", exbru_bp_valid);
        $display("");
        $display("commit <-> bp");

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            $display("commit_bp_pc[%0d] = %08x", i, commit_bp_pc[i]);
            $display("commit_bp_instruction[%0d] = %08x", i, commit_bp_instruction[i]);
            $display("commit_bp_jump[%0d] = %0x", i, commit_bp_jump[i]);
            $display("commit_bp_next_pc[%0d] = %08x", i, commit_bp_next_pc[i]);
            $display("commit_bp_hit[%0d] = %0x", i, commit_bp_hit[i]);
            $display("commit_bp_valid[%0d] = %0x", i, commit_bp_valid[i]);
        end

        $display("");
        $display("<internal state>");
        $display("fetch_opcode = %0x", branch_predictor_inst.fetch_opcode);
        $display("fetch_rd = %0x", branch_predictor_inst.fetch_rd);
        $display("fetch_rs1 = %0x", branch_predictor_inst.fetch_rs1);
        $display("fetch_imm_b = %0x", branch_predictor_inst.fetch_imm_b);
        $display("fetch_imm_j = %0x", branch_predictor_inst.fetch_imm_j);
        $display("fetch_rd_is_link = %0x", branch_predictor_inst.fetch_rd_is_link);
        $display("fetch_rs1_is_link = %0x", branch_predictor_inst.fetch_rs1_is_link);
        $display("fetch_is_branch = %0x", branch_predictor_inst.fetch_is_branch);
        $display("fetch_is_call = %0x", branch_predictor_inst.fetch_is_call);
        $display("fetch_is_normal_jump = %0x", branch_predictor_inst.fetch_is_normal_jump);
        $display("fetch_is_jal = %0x", branch_predictor_inst.fetch_is_jal);
        $display("fetch_is_jalr = %0x", branch_predictor_inst.fetch_is_jalr);
        $display("");
        $display("gshare_jump = %0x", branch_predictor_inst.gshare_jump);
        $display("gshare_next_pc = %08x", branch_predictor_inst.gshare_next_pc);
        $display("local_jump = %0x", branch_predictor_inst.local_jump);
        $display("local_next_pc = %08x", branch_predictor_inst.local_next_pc);
        $display("call_next_pc = %08x", branch_predictor_inst.call_next_pc);
        $display("normal_next_pc = %08x", branch_predictor_inst.normal_next_pc);
        $display("");
        $display("exbru_is_branch = %0x", branch_predictor_inst.exbru_is_branch);
        $display("");
        $display("commit_opcode = %0x", branch_predictor_inst.commit_opcode);
        $display("commit_rd = %0x", branch_predictor_inst.commit_rd);
        $display("commit_rs1 = %0x", branch_predictor_inst.commit_rs1);
        $display("commit_rd_is_link = %0x", branch_predictor_inst.commit_rd_is_link);
        $display("commit_rs1_is_link = %0x", branch_predictor_inst.commit_rs1_is_link);
        $display("commit_is_branch = %0x", branch_predictor_inst.commit_is_branch);
        $display("commit_is_call = %0x", branch_predictor_inst.commit_is_call);
        $display("commit_is_normal_jump = %0x", branch_predictor_inst.commit_is_normal_jump);
        $display("commit_index = %0x", branch_predictor_inst.commit_index);
        $display("");
        $display("gshare_global_history = %03x", branch_predictor_inst.gshare_global_history);
        $display("gshare_global_history_next = %03x", branch_predictor_inst.gshare_global_history_next);
        $display("gshare_global_history_retired = %03x", branch_predictor_inst.gshare_global_history_retired);
        $display("gshare_global_history_feedback = %03x", branch_predictor_inst.gshare_global_history_feedback);
        $display("gshare_pht_write_addr = %08x", branch_predictor_inst.gshare_pht_write_addr);
        $display("gshare_pht_write_data = %0x", branch_predictor_inst.gshare_pht_write_data);
        $display("gshare_pht_we = %0x", branch_predictor_inst.gshare_pht_we);
        $display("");
        $display("local_bht_feedback_commit = %03x", branch_predictor_inst.local_bht_feedback_commit);
        $display("local_bht_feedback_commit_p1 = %03x", branch_predictor_inst.local_bht_feedback_commit_p1);
        $display("local_bht_feedback_commit_valid = %0x", branch_predictor_inst.local_bht_feedback_commit_valid);
        $display("local_bht_feedback_bru = %03x", branch_predictor_inst.local_bht_feedback_bru);
        $display("local_bht_feedback_bru_p1 = %03x", branch_predictor_inst.local_bht_feedback_bru_p1);
        $display("local_bht_feedback_bru_valid = %0x", branch_predictor_inst.local_bht_feedback_bru_valid);
        $display("local_bht_write_addr = %08x", branch_predictor_inst.local_bht_write_addr);
        $display("local_pht_write_addr = %08x", branch_predictor_inst.local_pht_write_addr);
        $display("local_pht_write_data = %0x", branch_predictor_inst.local_pht_write_data);
        $display("local_pht_we = %0x", branch_predictor_inst.local_pht_we);
        $display("");
        $display("cpht_write_addr = %08x", branch_predictor_inst.cpht_write_addr);
        $display("cpht_write_data = %0x", branch_predictor_inst.cpht_write_data);
        $display("cpht_we = %0x", branch_predictor_inst.cpht_we);
        $display("");
        $display("call_global_history = %08x", branch_predictor_inst.call_global_history);
        $display("call_target_cache_feedback = %03x", branch_predictor_inst.call_target_cache_feedback);
        $display("call_target_cache_feedback_addr = %03x", branch_predictor_inst.call_target_cache_feedback_addr);
        $display("call_target_cache_feedback_valid = %0x", branch_predictor_inst.call_target_cache_feedback_valid);
        $display("normal_global_history = %03x", branch_predictor_inst.normal_global_history);
        $display("normal_target_cache_feedback = %08x", branch_predictor_inst.normal_target_cache_feedback);
        $display("normal_target_cache_feedback_addr = %03x", branch_predictor_inst.normal_target_cache_feedback_addr);
        $display("normal_target_cache_feedback_valid = %0x", branch_predictor_inst.normal_target_cache_feedback_valid);
        $display("");
        $display("--------Expected Information--------");
        $display("fetch <-> bp");
        $display("bp_fetch_jump = %0x", tdb.get_uint8(DOMAIN_OUTPUT, "bp_fetch_jump", 0));
        $display("bp_fetch_next_pc = %08x", tdb.get_uint32(DOMAIN_OUTPUT, "bp_fetch_next_pc", 0));
        $display("bp_fetch_global_history = %03x", tdb.get_uint16(DOMAIN_OUTPUT, "bp_fetch_global_history", 0));
        $display("bp_fetch_local_history = %03x", tdb.get_uint16(DOMAIN_OUTPUT, "bp_fetch_local_history", 0));
        $display("bp_fetch_valid = %0x", tdb.get_uint8(DOMAIN_OUTPUT, "bp_fetch_valid", 0));
        $display("");
    endtask

    task test;
        rst = 1;
        fetch_bp_pc = 'b0;
        fetch_bp_instruction = 'b0;
        fetch_bp_valid = 'b0;
        fetch_bp_update_pc = 'b0;
        fetch_bp_update_instruction = 'b0;
        fetch_bp_update_jump = 'b0;
        fetch_bp_update_next_pc = 'b0;
        fetch_bp_update_valid = 'b0;
        ras_bp_addr = 'b0;
        cp.rat_phy_map_table_valid = 'b0;
        cp.rat_phy_map_table_visible = 'b0;
        cp.global_history = 'b0;
        cp.local_history = 'b0;
        exbru_bp_cp = cp;
        exbru_bp_pc = 'b0;
        exbru_bp_instruction = 'b0;
        exbru_bp_jump = 'b0;
        exbru_bp_next_pc = 'b0;
        exbru_bp_hit = 'b0;
        exbru_bp_valid = 'b0;
        
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_bp_pc[i] = 'b0;
            commit_bp_instruction[i] = 'b0;
            commit_bp_jump[i] = 'b0;
            commit_bp_next_pc[i] = 'b0;
            commit_bp_hit[i] = 'b0;
            commit_bp_valid[i] = 'b0;    
        end

        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();

        while(1) begin
            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_STATUS, "gshare_global_history", 0), branch_predictor_inst.gshare_global_history)
            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_STATUS, "gshare_global_history_retired", 0), branch_predictor_inst.gshare_global_history_retired)
            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_STATUS, "call_global_history", 0), branch_predictor_inst.call_global_history)
            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_STATUS, "normal_global_history", 0), branch_predictor_inst.normal_global_history)
            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();

            if(!tdb.read_cur_row()) begin
                break;
            end

            fetch_bp_pc = tdb.get_uint32(DOMAIN_INPUT, "fetch_bp_pc", 0);
            fetch_bp_instruction = tdb.get_uint32(DOMAIN_INPUT, "fetch_bp_instruction", 0);
            fetch_bp_valid = tdb.get_uint8(DOMAIN_INPUT, "fetch_bp_valid", 0);
            fetch_bp_update_pc = tdb.get_uint32(DOMAIN_INPUT, "fetch_bp_update_pc", 0);
            fetch_bp_update_instruction = tdb.get_uint32(DOMAIN_INPUT, "fetch_bp_update_instruction", 0);
            fetch_bp_update_jump = tdb.get_uint8(DOMAIN_INPUT, "fetch_bp_update_jump", 0);
            fetch_bp_update_next_pc = tdb.get_uint32(DOMAIN_INPUT, "fetch_bp_update_next_pc", 0);
            fetch_bp_update_valid = tdb.get_uint8(DOMAIN_INPUT, "fetch_bp_update_valid", 0);
            exbru_bp_cp.rat_phy_map_table_valid = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "exbru_bp_cp.rat_phy_map_table_valid", 0);
            exbru_bp_cp.rat_phy_map_table_visible = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "exbru_bp_cp.rat_phy_map_table_visible", 0);
            exbru_bp_cp.global_history = tdb.get_uint16(DOMAIN_INPUT, "exbru_bp_cp.global_history", 0);
            exbru_bp_cp.local_history = tdb.get_uint16(DOMAIN_INPUT, "exbru_bp_cp.local_history", 0);
            exbru_bp_pc = tdb.get_uint32(DOMAIN_INPUT, "exbru_bp_pc", 0);
            exbru_bp_instruction = tdb.get_uint32(DOMAIN_INPUT, "exbru_bp_instruction", 0);
            exbru_bp_jump = tdb.get_uint8(DOMAIN_INPUT, "exbru_bp_jump", 0);
            exbru_bp_next_pc = tdb.get_uint32(DOMAIN_INPUT, "exbru_bp_next_pc", 0);
            exbru_bp_hit = tdb.get_uint8(DOMAIN_INPUT, "exbru_bp_hit", 0);
            exbru_bp_valid = tdb.get_uint8(DOMAIN_INPUT, "exbru_bp_valid", 0);

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                commit_bp_pc[i] = tdb.get_uint32(DOMAIN_INPUT, "commit_bp_pc", i);
                commit_bp_instruction[i] = tdb.get_uint32(DOMAIN_INPUT, "commit_bp_instruction", i);
                commit_bp_next_pc[i] = tdb.get_uint32(DOMAIN_INPUT, "commit_bp_next_pc", i);
            end

            commit_bp_jump = tdb.get_uint8(DOMAIN_INPUT, "commit_bp_jump", 0);
            commit_bp_hit = tdb.get_uint8(DOMAIN_INPUT, "commit_bp_hit", 0);
            commit_bp_valid = tdb.get_uint8(DOMAIN_INPUT, "commit_bp_valid", 0);

            ras_bp_addr = tdb.get_uint32(DOMAIN_INPUT, "ras_bp_addr", 0);
            eval();

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bp_fetch_valid", 0), bp_fetch_valid)

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bp_ras_pop", 0), bp_ras_pop)

            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "call_global_history_next", 0), branch_predictor_inst.call_global_history_next)
            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "normal_global_history_next", 0), branch_predictor_inst.normal_global_history_next)

            if(bp_fetch_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_opcode", 0), branch_predictor_inst.fetch_opcode)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_rd", 0), branch_predictor_inst.fetch_rd)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_rs1", 0), branch_predictor_inst.fetch_rs1)
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "fetch_imm_b", 0), branch_predictor_inst.fetch_imm_b)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_imm_j", 0), branch_predictor_inst.fetch_imm_j)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_rd_is_link", 0), branch_predictor_inst.fetch_rd_is_link)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_rs1_is_link", 0), branch_predictor_inst.fetch_rs1_is_link)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_is_branch", 0), branch_predictor_inst.fetch_is_branch)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_is_call", 0), branch_predictor_inst.fetch_is_call)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_is_normal_jump", 0), branch_predictor_inst.fetch_is_normal_jump)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_is_jal", 0), branch_predictor_inst.fetch_is_jal)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_is_jalr", 0), branch_predictor_inst.fetch_is_jalr)

                if(branch_predictor_inst.fetch_is_branch) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "gshare_pht_out", 0), branch_predictor_inst.gshare_pht_data_fix)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "local_pht_out", 0), branch_predictor_inst.local_pht_data_fix)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "cpht_out", 0), branch_predictor_inst.cpht_data_fix)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "gshare_global_history_feedback", 0), branch_predictor_inst.gshare_global_history_feedback)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "gshare_jump", 0), branch_predictor_inst.gshare_jump)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "local_jump", 0), branch_predictor_inst.local_jump)

                    if(branch_predictor_inst.cpht_data_fix <= 1) begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "gshare_next_pc", 0), branch_predictor_inst.gshare_next_pc)
                    end
                    else begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "local_next_pc", 0), branch_predictor_inst.local_next_pc)
                    end
                    
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "bp_fetch_global_history", 0), bp_fetch_global_history)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "bp_fetch_local_history", 0), bp_fetch_local_history)
                end
                else if(branch_predictor_inst.fetch_is_call) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "call_next_pc", 0), branch_predictor_inst.call_next_pc)
                end
                else if(branch_predictor_inst.fetch_is_normal_jump) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "normal_next_pc", 0), branch_predictor_inst.normal_next_pc)
                end

                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bp_fetch_jump", 0), bp_fetch_jump)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bp_fetch_next_pc", 0), bp_fetch_next_pc)
            end

            if(exbru_bp_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "exbru_is_branch", 0), branch_predictor_inst.exbru_is_branch)
            end

            if(commit_bp_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_index", 0), branch_predictor_inst.commit_index)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_opcode", 0), branch_predictor_inst.commit_opcode)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rd", 0), branch_predictor_inst.commit_rd)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rs1", 0), branch_predictor_inst.commit_rs1)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rd_is_link", 0), branch_predictor_inst.commit_rd_is_link)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rs1_is_link", 0), branch_predictor_inst.commit_rs1_is_link)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_is_branch", 0), branch_predictor_inst.commit_is_branch)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_is_call", 0), branch_predictor_inst.commit_is_call)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_is_normal_jump", 0), branch_predictor_inst.commit_is_normal_jump)
            end

            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "gshare_global_history_next", 0), branch_predictor_inst.gshare_global_history_next)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "gshare_pht_we", 0), branch_predictor_inst.gshare_pht_we)

            if(branch_predictor_inst.gshare_pht_we) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "gshare_pht_write_addr", 0), branch_predictor_inst.gshare_pht_write_addr)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "gshare_pht_write_data", 0), branch_predictor_inst.gshare_pht_write_data)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "local_bht_feedback_commit_valid", 0), branch_predictor_inst.local_bht_feedback_commit_valid)

            if(branch_predictor_inst.local_bht_feedback_commit_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "local_bht_feedback_commit", 0), branch_predictor_inst.local_bht_feedback_commit)
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "local_bht_feedback_commit_p1", 0), branch_predictor_inst.local_bht_feedback_commit_p1)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "local_bht_feedback_bru_valid", 0), branch_predictor_inst.local_bht_feedback_bru_valid)

            if(branch_predictor_inst.local_bht_feedback_bru_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "local_bht_feedback_bru", 0), branch_predictor_inst.local_bht_feedback_bru)
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "local_bht_feedback_bru_p1", 0), branch_predictor_inst.local_bht_feedback_bru_p1)
            end

            if(commit_bp_valid && branch_predictor_inst.commit_is_branch) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "local_bht_write_addr", 0), branch_predictor_inst.local_bht_write_addr)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "local_pht_we", 0), branch_predictor_inst.local_pht_we)

            if(branch_predictor_inst.local_pht_we) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "local_pht_write_addr", 0), branch_predictor_inst.local_pht_write_addr)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "local_pht_write_data", 0), branch_predictor_inst.local_pht_write_data)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "cpht_we", 0), branch_predictor_inst.cpht_we)

            if(branch_predictor_inst.cpht_we) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "cpht_write_addr", 0), branch_predictor_inst.cpht_write_addr)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "cpht_write_data", 0), branch_predictor_inst.cpht_write_data)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "call_target_cache_we", 0), branch_predictor_inst.call_target_cache_we)

            if(branch_predictor_inst.call_target_cache_we) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "call_target_cache_write_addr", 0), branch_predictor_inst.call_target_cache_write_addr)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "call_target_cache_write_data", 0), branch_predictor_inst.call_target_cache_write_data)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "normal_target_cache_we", 0), branch_predictor_inst.normal_target_cache_we)

            if(branch_predictor_inst.normal_target_cache_we) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "normal_target_cache_write_addr", 0), branch_predictor_inst.normal_target_cache_write_addr)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "normal_target_cache_write_data", 0), branch_predictor_inst.normal_target_cache_write_data)
            end
            
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bp_ras_push", 0), bp_ras_push)

            if(bp_ras_push) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bp_ras_addr", 0), bp_ras_addr)
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
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/branch_predictor.tdb"});
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