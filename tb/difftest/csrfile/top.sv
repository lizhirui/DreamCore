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
    
    logic[`CSR_ADDR_WIDTH - 1:0] excsr_csrf_addr;
    logic[`REG_DATA_WIDTH - 1:0] csrf_excsr_data;
    
    logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_read_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] csrf_commit_read_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_write_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] commit_csrf_write_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] commit_csrf_we;
    
    logic[`REG_DATA_WIDTH - 1:0] intif_csrf_mip_data;
    
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mie_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mstatus_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mip_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mepc_data;
    
    logic fetch_csrf_checkpoint_buffer_full_add;
    logic fetch_csrf_fetch_not_full_add;
    logic fetch_csrf_fetch_decode_fifo_full_add;
    logic decode_csrf_decode_rename_fifo_full_add;
    logic rename_csrf_phy_regfile_full_add;
    logic rename_csrf_rob_full_add;
    logic issue_csrf_issue_execute_fifo_full_add;
    logic issue_csrf_issue_queue_full_add;
    logic commit_csrf_branch_num_add;
    logic commit_csrf_branch_predicted_add;
    logic commit_csrf_branch_hit_add;
    logic commit_csrf_branch_miss_add;
    logic[$clog2(`COMMIT_WIDTH):0] commit_csrf_commit_num_add;
    logic ras_csrf_ras_full_add;

    integer i;
    longint cur_cycle;

    csrfile csrfile_inst(
        .*,
        .uart_send_data(),
        .uart_send(),
        .uart_send_busy(1'b0),
        .uart_rev_data(8'b0),
        .uart_rev_data_valid(1'b0),
        .uart_rev_data_invalid()
    );
    
    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        excsr_csrf_addr = 'b0;

        for(i = 0;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
            commit_csrf_read_addr[i] = 'b0;
            commit_csrf_write_addr[i] = 'b0;
            commit_csrf_write_data[i] = 'b0;
            commit_csrf_we[i] = 'b0;
        end

        intif_csrf_mip_data = 'b0;
        fetch_csrf_checkpoint_buffer_full_add = 'b0;
        fetch_csrf_fetch_not_full_add = 'b0;
        fetch_csrf_fetch_decode_fifo_full_add = 'b0;
        decode_csrf_decode_rename_fifo_full_add = 'b0;
        rename_csrf_phy_regfile_full_add = 'b0;
        rename_csrf_rob_full_add = 'b0;
        issue_csrf_issue_execute_fifo_full_add = 'b0;
        issue_csrf_issue_queue_full_add = 'b0;
        commit_csrf_branch_num_add = 'b0;
        commit_csrf_branch_predicted_add = 'b0;
        commit_csrf_branch_hit_add = 'b0;
        commit_csrf_branch_miss_add = 'b0;
        commit_csrf_commit_num_add = 'b0;
        ras_csrf_ras_full_add = 'b0;
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

            excsr_csrf_addr = tdb.get_uint16(DOMAIN_INPUT, "excsr_csrf_addr", 0);
            
            for(i = 0;i < 4;i++) begin
                commit_csrf_read_addr[i] = tdb.get_uint16(DOMAIN_INPUT, "commit_csrf_read_addr", i);
                commit_csrf_write_addr[i] = tdb.get_uint16(DOMAIN_INPUT, "commit_csrf_write_addr", i);
                commit_csrf_write_data[i] = tdb.get_uint32(DOMAIN_INPUT, "commit_csrf_write_data", i);
                commit_csrf_we[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_csrf_we", i);
            end

            intif_csrf_mip_data = tdb.get_uint32(DOMAIN_INPUT, "intif_csrf_mip_data", 0);

            fetch_csrf_checkpoint_buffer_full_add = tdb.get_uint8(DOMAIN_INPUT, "fetch_csrf_checkpoint_buffer_full_add", 0);
            fetch_csrf_fetch_not_full_add = tdb.get_uint8(DOMAIN_INPUT, "fetch_csrf_fetch_not_full_add", 0);
            fetch_csrf_fetch_decode_fifo_full_add = tdb.get_uint8(DOMAIN_INPUT, "fetch_csrf_fetch_decode_fifo_full_add", 0);
            decode_csrf_decode_rename_fifo_full_add = tdb.get_uint8(DOMAIN_INPUT, "decode_csrf_decode_rename_fifo_full_add", 0);
            rename_csrf_phy_regfile_full_add = tdb.get_uint8(DOMAIN_INPUT, "rename_csrf_phy_regfile_full_add", 0);
            rename_csrf_rob_full_add = tdb.get_uint8(DOMAIN_INPUT, "rename_csrf_rob_full_add", 0);
            issue_csrf_issue_execute_fifo_full_add = tdb.get_uint8(DOMAIN_INPUT, "issue_csrf_issue_execute_fifo_full_add", 0);
            issue_csrf_issue_queue_full_add = tdb.get_uint8(DOMAIN_INPUT, "issue_csrf_issue_queue_full_add", 0);
            commit_csrf_branch_num_add = tdb.get_uint8(DOMAIN_INPUT, "commit_csrf_branch_num_add", 0);
            commit_csrf_branch_predicted_add = tdb.get_uint8(DOMAIN_INPUT, "commit_csrf_branch_predicted_add", 0);
            commit_csrf_branch_hit_add = tdb.get_uint8(DOMAIN_INPUT, "commit_csrf_branch_hit_add", 0);
            commit_csrf_branch_miss_add = tdb.get_uint8(DOMAIN_INPUT, "commit_csrf_branch_miss_add", 0);
            commit_csrf_commit_num_add = tdb.get_uint8(DOMAIN_INPUT, "commit_csrf_commit_num_add", 0);
            ras_csrf_ras_full_add = tdb.get_uint8(DOMAIN_INPUT, "ras_csrf_ras_full_add", 0);
            eval();

            if(tdb.get_uint16(DOMAIN_INPUT, "excsr_csrf_addr", 0) != 65535) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "csrf_excsr_data", 0), csrf_excsr_data)
            end

            for(i = 0;i < 4;i++) begin
                if(tdb.get_uint16(DOMAIN_INPUT, "commit_csrf_read_addr", i) != 65535) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "csrf_commit_read_data", i), csrf_commit_read_data[i])
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "csrf_all_mie_data", 0), csrf_all_mie_data)
            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "csrf_all_mstatus_data", 0), csrf_all_mstatus_data)
            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "csrf_all_mip_data", 0), csrf_all_mip_data)
            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "csrf_all_mepc_data", 0), csrf_all_mepc_data)
            wait_clk();
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/csrfile.tdb"});
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