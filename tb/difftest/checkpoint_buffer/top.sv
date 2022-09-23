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
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] cpbuf_fetch_new_id;
    logic cpbuf_fetch_new_id_valid;
    checkpoint_t fetch_cpbuf_data;
    logic fetch_cpbuf_push;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] rename_cpbuf_id[0:`RENAME_WIDTH - 1];
    checkpoint_t rename_cpbuf_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_cpbuf_we;
    checkpoint_t cpbuf_rename_data[0:`RENAME_WIDTH - 1];
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] exbru_cpbuf_id;
    checkpoint_t cpbuf_exbru_data;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] commit_cpbuf_id[0:`COMMIT_WIDTH - 1];
    checkpoint_t cpbuf_commit_data[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_cpbuf_pop;
    logic commit_cpbuf_flush;

    integer i, j;
    longint cur_cycle;
    
    checkpoint_t cp_test;

    checkpoint_buffer checkpoint_buffer_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        cp_test.rat_phy_map_table_valid = 'b0;
        cp_test.rat_phy_map_table_visible = 'b0;
        cp_test.global_history = 'b0;
        cp_test.local_history = 'b0;
        fetch_cpbuf_data = cp_test;
        fetch_cpbuf_push = 'b0;
        
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_cpbuf_id[i] = 'b0;
            rename_cpbuf_data[i] = 'b0;
            rename_cpbuf_we[i] = 'b0;
        end

        exbru_cpbuf_id = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_cpbuf_id[i] = 'b0;
            commit_cpbuf_pop = 'b0;
        end

        commit_cpbuf_flush = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();

        while(1) begin
            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_STATUS, "rptr", 0), checkpoint_buffer_inst.rptr)
            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_STATUS, "wptr", 0), checkpoint_buffer_inst.wptr)
            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();

            if(!tdb.read_cur_row()) begin
                break;
            end

            fetch_cpbuf_data.global_history = tdb.get_uint16(DOMAIN_INPUT, "fetch_cpbuf_data.global_history", 0);
            fetch_cpbuf_data.local_history = tdb.get_uint16(DOMAIN_INPUT, "fetch_cpbuf_data.local_history", 0);
            fetch_cpbuf_push = tdb.get_uint8(DOMAIN_INPUT, "fetch_cpbuf_push", 0);

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                rename_cpbuf_id[i] = tdb.get_uint16(DOMAIN_INPUT, "rename_cpbuf_id", i);
                rename_cpbuf_data[i].rat_phy_map_table_valid = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "rename_cpbuf_data.rat_phy_map_table_valid", i);
                rename_cpbuf_data[i].rat_phy_map_table_visible = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "rename_cpbuf_data.rat_phy_map_table_visible", i);
                rename_cpbuf_data[i].global_history = tdb.get_uint16(DOMAIN_INPUT, "rename_cpbuf_data.global_history", i);
                rename_cpbuf_data[i].local_history = tdb.get_uint16(DOMAIN_INPUT, "rename_cpbuf_data.local_history", i);
                rename_cpbuf_we[i] = tdb.get_uint8(DOMAIN_INPUT, "rename_cpbuf_we", i);
            end

            exbru_cpbuf_id = tdb.get_uint16(DOMAIN_INPUT, "exbru_cpbuf_id", 0);

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                commit_cpbuf_id[i] = tdb.get_uint16(DOMAIN_INPUT, "commit_cpbuf_id", i);
                commit_cpbuf_pop[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_cpbuf_pop", i);
            end

            commit_cpbuf_flush = tdb.get_uint8(DOMAIN_INPUT, "commit_cpbuf_flush", 0);
            eval();

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "cpbuf_fetch_new_id_valid", 0), cpbuf_fetch_new_id_valid)

            if(cpbuf_fetch_new_id_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "cpbuf_fetch_new_id", 0), cpbuf_fetch_new_id)
            end

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                if(tdb.get_uint16(DOMAIN_INPUT, "rename_cpbuf_id", i) != 65535) begin
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "cpbuf_rename_data.global_history", i), cpbuf_rename_data[i].global_history)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "cpbuf_rename_data.local_history", i), cpbuf_rename_data[i].local_history)
                end
            end

            if(tdb.get_uint16(DOMAIN_INPUT, "exbru_cpbuf_id", 0) != 65535) begin
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "cpbuf_exbru_data.rat_phy_map_table_valid", 0), cpbuf_exbru_data.rat_phy_map_table_valid)
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "cpbuf_exbru_data.rat_phy_map_table_visible", 0), cpbuf_exbru_data.rat_phy_map_table_visible)
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "cpbuf_exbru_data.global_history", 0), cpbuf_exbru_data.global_history)
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "cpbuf_exbru_data.local_history", 0), cpbuf_exbru_data.local_history)
            end

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                if(tdb.get_uint16(DOMAIN_INPUT, "commit_cpbuf_id", i) != 65535) begin
                    `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "cpbuf_commit_data.rat_phy_map_table_valid", i), cpbuf_commit_data[i].rat_phy_map_table_valid)
                    `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "cpbuf_commit_data.rat_phy_map_table_visible", i), cpbuf_commit_data[i].rat_phy_map_table_visible)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "cpbuf_commit_data.global_history", i), cpbuf_commit_data[i].global_history)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "cpbuf_commit_data.local_history", i), cpbuf_commit_data[i].local_history)
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
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/checkpoint_buffer.tdb"});
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