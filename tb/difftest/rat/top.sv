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
    
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_new_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rat_rename_new_phy_id_valid;
    logic[`PHY_REG_ID_WIDTH - 1:0] rename_rat_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rat_phy_id_valid;
    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_arch_id[0:`RENAME_WIDTH - 1];
    logic rename_rat_map;
    
    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_read_arch_id[0:`RENAME_WIDTH - 1][0:2];
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_read_phy_id[0:`RENAME_WIDTH - 1][0:2];
    
    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_valid;
    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_visible;
    
    logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_valid;
    logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_visible;
    logic commit_rat_map_table_restore;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_release_phy_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_rat_release_phy_id_valid;
    logic commit_rat_release_map;
    
    logic[`PHY_REG_ID_WIDTH- 1:0] commit_rat_commit_phy_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_rat_commit_phy_id_valid;
    logic commit_rat_commit_map;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_new_phy_id;
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_old_phy_id;
    logic commit_rat_restore_map;

    integer i, j;
    longint cur_cycle;

    rat rat_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        rename_rat_phy_id_valid = 'b0;
        rename_rat_map = 'b0;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_rat_phy_id[i] = 'b0;
            rename_rat_arch_id[i] = 'b0;

            for(j = 0;j < 3;j++) begin
                rename_rat_read_arch_id[i][j] = 'b0;
            end
        end

        commit_rat_map_table_valid = 'b0;
        commit_rat_map_table_visible = 'b0;
        commit_rat_map_table_restore = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_rat_release_phy_id[i] = 'b0;
            commit_rat_commit_phy_id[i] = 'b0;
        end

        commit_rat_release_phy_id_valid = 'b0;
        commit_rat_release_map = 'b0;
        commit_rat_commit_phy_id_valid = 'b0;
        commit_rat_commit_map = 'b0;
        commit_rat_restore_new_phy_id = 'b0;
        commit_rat_restore_old_phy_id = 'b0;
        commit_rat_restore_map = 'b0;
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
                rename_rat_phy_id[i] = tdb.get_uint8(DOMAIN_INPUT, "rename_rat_phy_id", i);
                rename_rat_arch_id[i] = tdb.get_uint8(DOMAIN_INPUT, "rename_rat_arch_id", i);
                rename_rat_phy_id_valid[i] = tdb.get_uint8(DOMAIN_INPUT, "rename_rat_phy_id_valid", i);
            end

            rename_rat_map = tdb.get_uint8(DOMAIN_INPUT, "rename_rat_map", 0);

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                for(j = 0;j < 3;j++) begin
                    rename_rat_read_arch_id[i][j] = tdb.get_uint8(DOMAIN_INPUT, "rename_rat_read_arch_id", i * 3 + j);
                end
            end

            commit_rat_map_table_valid = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "commit_rat_map_table_valid", 0);
            commit_rat_map_table_visible = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "commit_rat_map_table_visible", 0);
            commit_rat_map_table_restore = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_map_table_restore", 0);

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                commit_rat_release_phy_id[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_release_phy_id", i);
                commit_rat_release_phy_id_valid[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_release_phy_id_valid", i);
            end

            commit_rat_release_map = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_release_map", 0);

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                commit_rat_commit_phy_id[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_commit_phy_id", i);
                commit_rat_commit_phy_id_valid[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_commit_phy_id_valid", i);
            end

            commit_rat_commit_map = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_commit_map", 0);

            commit_rat_restore_new_phy_id = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_restore_new_phy_id", 0);
            commit_rat_restore_old_phy_id = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_restore_old_phy_id", 0);
            commit_rat_restore_map = tdb.get_uint8(DOMAIN_INPUT, "commit_rat_restore_map", 0);
            eval();
            `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "rat_rename_map_table_valid", 0), rat_rename_map_table_valid)
            `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "rat_rename_map_table_visible", 0), rat_rename_map_table_visible)
            
            for(i = 0;i < `RENAME_WIDTH;i++) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rat_rename_new_phy_id_valid", i), rat_rename_new_phy_id_valid[i])

                if(rat_rename_new_phy_id_valid[i]) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rat_rename_new_phy_id", i), rat_rename_new_phy_id[i])
                end
            end

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                for(j = 0;j < 3;j++) begin
                    if(tdb.get_uint8(DOMAIN_INPUT, "rename_rat_read_arch_id", i * 3 + j) != 255) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rat_rename_read_phy_id", i * 3 + j), rat_rename_read_phy_id[i][j])
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
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/rat.tdb"});
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