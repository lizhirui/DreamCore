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
    
    logic[`PHY_REG_ID_WIDTH - 1:0] issue_phyf_id[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] phyf_issue_data[0:`READREG_WIDTH - 1][0:1];
    logic phyf_issue_data_valid[0:`READREG_WIDTH - 1][0:1];
    
    logic[`PHY_REG_ID_WIDTH - 1:0] wb_phyf_id[0:`WB_WIDTH - 1];
    logic[`REG_DATA_WIDTH - 1:0] wb_phyf_data[0:`WB_WIDTH - 1];
    logic[`WB_WIDTH - 1:0] wb_phyf_we;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_phyf_invalid;

    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_flush_id;
    logic commit_phyf_flush_invalid;
    
    logic[`PHY_REG_NUM - 1:0] commit_phyf_data_valid;
    logic commit_phyf_data_valid_restore;

    integer i, j, k;
    integer i2, j2;
    longint cur_cycle;

    phy_regfile phy_regfile_inst(.*);

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
                readreg_phyf_id[i][j] = 'b0;
                issue_phyf_id[i][j] = 'b0;
            end
        end

        for(i = 0;i < `WB_WIDTH;i++) begin
            wb_phyf_id[i] = 'b0;
            wb_phyf_data[i] = 'b0;
            wb_phyf_we[i] = 'b0;
        end

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_phyf_id[i] = 'b0;
            commit_phyf_invalid[i] = 'b0;
        end

        commit_phyf_flush_id = 'b0;
        commit_phyf_flush_invalid = 'b0;
        commit_phyf_data_valid = 'b0;
        commit_phyf_data_valid_restore = 'b0;
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
                for(j = 0;j < 2;j++) begin
                    readreg_phyf_id[i][j] = tdb.get_uint8(DOMAIN_INPUT, "readreg_phyf_id", i * 2 + j);
                    issue_phyf_id[i][j] = tdb.get_uint8(DOMAIN_INPUT, "issue_phyf_id", i * 2 + j);
                end
            end

            for(i = 0;i < `WB_WIDTH;i++) begin
                wb_phyf_id[i] = tdb.get_uint8(DOMAIN_INPUT, "wb_phyf_id", i);
                wb_phyf_data[i] = tdb.get_uint32(DOMAIN_INPUT, "wb_phyf_data", i);
                wb_phyf_we[i] = tdb.get_uint8(DOMAIN_INPUT, "wb_phyf_we", i);
            end

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                commit_phyf_id[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_phyf_id", i);
                commit_phyf_invalid[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_phyf_invalid", i);
            end

            commit_phyf_flush_id = tdb.get_uint8(DOMAIN_INPUT, "commit_phyf_flush_id", 0);
            commit_phyf_flush_invalid = tdb.get_uint8(DOMAIN_INPUT, "commit_phyf_flush_invalid", 0);

            commit_phyf_data_valid = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "commit_phyf_data_valid", 0);
            commit_phyf_data_valid_restore = tdb.get_uint8(DOMAIN_INPUT, "commit_phyf_data_valid_restore", 0);
            eval();

            for(i = 0;i < `READREG_WIDTH;i++) begin
                for(j = 0;j < 2;j++) begin
                    if(tdb.get_uint8(DOMAIN_INPUT, "readreg_phyf_id", i * 2 + j) != 255) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "phyf_readreg_data_valid", i * 2 + j), phyf_readreg_data_valid[i][j])

                        if(phyf_readreg_data_valid[i][j]) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "phyf_readreg_data", i * 2 + j), phyf_readreg_data[i][j])
                        end
                    end
                    
                    if(tdb.get_uint8(DOMAIN_INPUT, "issue_phyf_id", i * 2 + j) != 255) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "phyf_issue_data_valid", i * 2 + j), phyf_issue_data_valid[i][j])

                        if(phyf_issue_data_valid[i][j]) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "phyf_issue_data", i * 2 + j), phyf_issue_data[i][j])
                        end
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
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/phy_regfile.tdb"});
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