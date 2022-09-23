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
    tdb_reader alu_tdb[0:`ALU_UNIT_NUM];
    tdb_reader bru_tdb[0:`BRU_UNIT_NUM];
    tdb_reader csr_tdb[0:`CSR_UNIT_NUM];
    tdb_reader div_tdb[0:`DIV_UNIT_NUM];
    tdb_reader lsu_tdb[0:`LSU_UNIT_NUM];
    tdb_reader mul_tdb[0:`MUL_UNIT_NUM];

    execute_feedback_channel_t alu_execute_channel_feedback_pack[0:`ALU_UNIT_NUM - 1];
    execute_feedback_channel_t bru_execute_channel_feedback_pack[0:`BRU_UNIT_NUM - 1];
    execute_feedback_channel_t csr_execute_channel_feedback_pack[0:`CSR_UNIT_NUM - 1];
    execute_feedback_channel_t div_execute_channel_feedback_pack[0:`DIV_UNIT_NUM - 1];
    execute_feedback_channel_t lsu_execute_channel_feedback_pack[0:`LSU_UNIT_NUM - 1];
    execute_feedback_channel_t mul_execute_channel_feedback_pack[0:`MUL_UNIT_NUM - 1];
    execute_feedback_pack_t execute_feedback_pack;

    integer i;
    string i_str;
    longint cur_cycle;
    int compare_ok;

    execute_feedback execute_feedback_inst(.*);

    task eval;
        #0.1;
    endtask

    task test;
        compare_ok = 0;

        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            `assert(alu_tdb[i].read_cur_row())
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            `assert(bru_tdb[i].read_cur_row())
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            `assert(csr_tdb[i].read_cur_row())
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            `assert(div_tdb[i].read_cur_row())
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            `assert(lsu_tdb[i].read_cur_row())
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            `assert(mul_tdb[i].read_cur_row())
        end

        cur_cycle = alu_tdb[0].get_cur_row();

        while(1) begin
            for(i = 0;i < `ALU_UNIT_NUM;i++) begin
                alu_tdb[i].move_to_next_row();

                if(!alu_tdb[i].read_cur_row()) begin
                    compare_ok = 1;
                    break;
                end
            end

            for(i = 0;i < `BRU_UNIT_NUM;i++) begin
                bru_tdb[i].move_to_next_row();

                if(!bru_tdb[i].read_cur_row()) begin
                    compare_ok = 1;
                    break;
                end
            end

            for(i = 0;i < `CSR_UNIT_NUM;i++) begin
                csr_tdb[i].move_to_next_row();

                if(!csr_tdb[i].read_cur_row()) begin
                    compare_ok = 1;
                    break;
                end
            end

            for(i = 0;i < `DIV_UNIT_NUM;i++) begin
                div_tdb[i].move_to_next_row();

                if(!div_tdb[i].read_cur_row()) begin
                    compare_ok = 1;
                    break;
                end
            end

            for(i = 0;i < `LSU_UNIT_NUM;i++) begin
                lsu_tdb[i].move_to_next_row();

                if(!lsu_tdb[i].read_cur_row()) begin
                    compare_ok = 1;
                    break;
                end
            end

            for(i = 0;i < `MUL_UNIT_NUM;i++) begin
                mul_tdb[i].move_to_next_row();

                if(!mul_tdb[i].read_cur_row()) begin
                    compare_ok = 1;
                    break;
                end
            end

            if(compare_ok) begin
                break;
            end

            cur_cycle = alu_tdb[0].get_cur_row();

            for(i = 0;i < `ALU_UNIT_NUM;i++) begin
                alu_execute_channel_feedback_pack[i].enable = alu_tdb[i].get_uint8(DOMAIN_OUTPUT, "alu_execute_channel_feedback_pack.enable", 0);
                alu_execute_channel_feedback_pack[i].phy_id = alu_tdb[i].get_uint8(DOMAIN_OUTPUT, "alu_execute_channel_feedback_pack.phy_id", 0);
                alu_execute_channel_feedback_pack[i].value = alu_tdb[i].get_uint32(DOMAIN_OUTPUT, "alu_execute_channel_feedback_pack.value", 0);
            end

            for(i = 0;i < `BRU_UNIT_NUM;i++) begin
                bru_execute_channel_feedback_pack[i].enable = bru_tdb[i].get_uint8(DOMAIN_OUTPUT, "bru_execute_channel_feedback_pack.enable", 0);
                bru_execute_channel_feedback_pack[i].phy_id = bru_tdb[i].get_uint8(DOMAIN_OUTPUT, "bru_execute_channel_feedback_pack.phy_id", 0);
                bru_execute_channel_feedback_pack[i].value = bru_tdb[i].get_uint32(DOMAIN_OUTPUT, "bru_execute_channel_feedback_pack.value", 0);
            end

            for(i = 0;i < `CSR_UNIT_NUM;i++) begin
                csr_execute_channel_feedback_pack[i].enable = csr_tdb[i].get_uint8(DOMAIN_OUTPUT, "csr_execute_channel_feedback_pack.enable", 0);
                csr_execute_channel_feedback_pack[i].phy_id = csr_tdb[i].get_uint8(DOMAIN_OUTPUT, "csr_execute_channel_feedback_pack.phy_id", 0);
                csr_execute_channel_feedback_pack[i].value = csr_tdb[i].get_uint32(DOMAIN_OUTPUT, "csr_execute_channel_feedback_pack.value", 0);
            end

            for(i = 0;i < `DIV_UNIT_NUM;i++) begin
                div_execute_channel_feedback_pack[i].enable = div_tdb[i].get_uint8(DOMAIN_OUTPUT, "div_execute_channel_feedback_pack.enable", 0);
                div_execute_channel_feedback_pack[i].phy_id = div_tdb[i].get_uint8(DOMAIN_OUTPUT, "div_execute_channel_feedback_pack.phy_id", 0);
                div_execute_channel_feedback_pack[i].value = div_tdb[i].get_uint32(DOMAIN_OUTPUT, "div_execute_channel_feedback_pack.value", 0);
            end

            for(i = 0;i < `LSU_UNIT_NUM;i++) begin
                lsu_execute_channel_feedback_pack[i].enable = lsu_tdb[i].get_uint8(DOMAIN_OUTPUT, "lsu_execute_channel_feedback_pack.enable", 0);
                lsu_execute_channel_feedback_pack[i].phy_id = lsu_tdb[i].get_uint8(DOMAIN_OUTPUT, "lsu_execute_channel_feedback_pack.phy_id", 0);
                lsu_execute_channel_feedback_pack[i].value = lsu_tdb[i].get_uint32(DOMAIN_OUTPUT, "lsu_execute_channel_feedback_pack.value", 0);
            end

            for(i = 0;i < `MUL_UNIT_NUM;i++) begin
                mul_execute_channel_feedback_pack[i].enable = mul_tdb[i].get_uint8(DOMAIN_OUTPUT, "mul_execute_channel_feedback_pack.enable", 0);
                mul_execute_channel_feedback_pack[i].phy_id = mul_tdb[i].get_uint8(DOMAIN_OUTPUT, "mul_execute_channel_feedback_pack.phy_id", 0);
                mul_execute_channel_feedback_pack[i].value = mul_tdb[i].get_uint32(DOMAIN_OUTPUT, "mul_execute_channel_feedback_pack.value", 0);
            end

            eval();

            for(i = 0;i < `ALU_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, alu_execute_channel_feedback_pack[i], execute_feedback_pack.channel[i])
            end

            for(i = 0;i < `BRU_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, bru_execute_channel_feedback_pack[i], execute_feedback_pack.channel[i + `ALU_UNIT_NUM])
            end

            for(i = 0;i < `CSR_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, csr_execute_channel_feedback_pack[i], execute_feedback_pack.channel[i + `ALU_UNIT_NUM + `BRU_UNIT_NUM])
            end

            for(i = 0;i < `DIV_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, div_execute_channel_feedback_pack[i], execute_feedback_pack.channel[i + `ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM])
            end

            for(i = 0;i < `LSU_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, lsu_execute_channel_feedback_pack[i], execute_feedback_pack.channel[i + `ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM])
            end

            for(i = 0;i < `MUL_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, mul_execute_channel_feedback_pack[i], execute_feedback_pack.channel[i + `ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + `LSU_UNIT_NUM])
            end
        end
    endtask

    initial begin
        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            alu_tdb[i] = new;
            i_str.itoa(i);
            alu_tdb[i].open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/execute_alu_", i_str, ".tdb"});
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            bru_tdb[i] = new;
            i_str.itoa(i);
            bru_tdb[i].open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/execute_bru_", i_str, ".tdb"});
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            csr_tdb[i] = new;
            i_str.itoa(i);
            csr_tdb[i].open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/execute_csr_", i_str, ".tdb"});
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            div_tdb[i] = new;
            i_str.itoa(i);
            div_tdb[i].open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/execute_div_", i_str, ".tdb"});
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            lsu_tdb[i] = new;
            i_str.itoa(i);
            lsu_tdb[i].open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/execute_lsu_", i_str, ".tdb"});
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            mul_tdb[i] = new;
            i_str.itoa(i);
            mul_tdb[i].open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/execute_mul_", i_str, ".tdb"});
        end

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