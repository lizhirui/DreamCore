`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`ADDR_WIDTH - 1:0] issue_stbuf_read_addr;
    logic[`SIZE_WIDTH - 1:0] issue_stbuf_read_size;
    logic issue_stbuf_rd;
    logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data;
    logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data_feedback;
    logic stbuf_exlsu_bus_ready;
    
    logic[`ROB_ID_WIDTH - 1:0] exlsu_stbuf_rob_id;
    logic[`ADDR_WIDTH - 1:0] exlsu_stbuf_write_addr;
    logic[`SIZE_WIDTH - 1:0] exlsu_stbuf_write_size;
    logic[`BUS_DATA_WIDTH - 1:0] exlsu_stbuf_write_data;
    logic exlsu_stbuf_push;
    logic stbuf_exlsu_full;
    
    logic stbuf_all_empty;
    
    logic[`ADDR_WIDTH - 1:0] stbuf_bus_read_addr;
    logic[`ADDR_WIDTH - 1:0] stbuf_bus_write_addr;
    logic[`SIZE_WIDTH - 1:0] stbuf_bus_read_size;
    logic[`SIZE_WIDTH - 1:0] stbuf_bus_write_size;
    logic[`REG_DATA_WIDTH - 1:0] stbuf_bus_data;
    logic stbuf_bus_read_req;
    logic stbuf_bus_write_req;
    logic[`REG_DATA_WIDTH - 1:0] bus_stbuf_data;
    logic bus_stbuf_read_ack;
    logic bus_stbuf_write_ack;
    
    commit_feedback_pack_t commit_feedback_pack;

    integer i, j;

    store_buffer store_buffer_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        issue_stbuf_read_addr = 'b0;
        issue_stbuf_read_size = 'b0;
        issue_stbuf_rd = 'b0;
        exlsu_stbuf_rob_id = 'b0;
        exlsu_stbuf_write_addr = 'b0;
        exlsu_stbuf_write_size = 'b0;
        exlsu_stbuf_write_data = 'b0;
        exlsu_stbuf_push = 'b0;
        bus_stbuf_data = 'b0;
        bus_stbuf_read_ack = 'b0;
        bus_stbuf_write_ack = 'b0;
        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.next_handle_rob_id_valid = 'b0;
        commit_feedback_pack.next_handle_rob_id = 'b0;
        commit_feedback_pack.has_exception = 'b0;
        commit_feedback_pack.exception_pc = 'b0;
        commit_feedback_pack.flush = 'b0;
        
        for(i = 0;i < `ROB_ID_WIDTH;i++) begin
            commit_feedback_pack.committed_rob_id[i] = 'b0;
        end

        commit_feedback_pack.committed_rob_id_valid = 'b0;
        commit_feedback_pack.jump_enable = 'b0;
        commit_feedback_pack.jump = 'b0;
        commit_feedback_pack.next_pc = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(stbuf_exlsu_bus_ready == 'b0) else $finish;
        assert(stbuf_exlsu_full == 'b0) else $finish;
        assert(stbuf_all_empty == 'b1) else $finish;
        assert(stbuf_bus_read_req == 'b0) else $finish;
        assert(stbuf_bus_write_req == 'b0) else $finish;
        issue_stbuf_read_addr = 'h1524abe0;
        issue_stbuf_read_size = 'b01;
        issue_stbuf_rd = 'b1;
        eval();
        assert(stbuf_bus_read_addr == issue_stbuf_read_addr) else $finish;
        assert(stbuf_bus_read_size == issue_stbuf_read_size) else $finish;
        assert(stbuf_bus_read_req == 'b1) else $finish;
        wait_clk();
        assert(stbuf_exlsu_bus_ready == 'b0) else $finish;
        bus_stbuf_read_ack = 'b1;
        bus_stbuf_data = 'hdeadbeef;
        eval();
        assert(stbuf_exlsu_bus_ready == 'b1) else $finish;
        assert(stbuf_exlsu_bus_data == bus_stbuf_data) else $finish;
        assert(stbuf_exlsu_bus_data_feedback == bus_stbuf_data) else $finish;
        wait_clk();
        exlsu_stbuf_rob_id = 'd5;
        exlsu_stbuf_write_addr = 'b0;
        exlsu_stbuf_write_size = 'h4;
        exlsu_stbuf_write_data = 'haabbccdd;
        exlsu_stbuf_push = 'b1;
        issue_stbuf_read_addr = 'b0;
        issue_stbuf_read_size = 'h4;
        wait_clk();
        assert(stbuf_exlsu_bus_data == bus_stbuf_data) else $finish;
        assert(stbuf_exlsu_bus_data_feedback == exlsu_stbuf_write_data) else $finish;
        rst = 1;
        wait_clk();
        rst = 0;
        assert(stbuf_exlsu_bus_data_feedback == bus_stbuf_data) else $finish;
        exlsu_stbuf_write_addr = 'h2;
        wait_clk();
        assert(stbuf_exlsu_bus_data_feedback == 'hccddbeef) else $finish;
        rst = 1;
        wait_clk();
        rst = 0;
        exlsu_stbuf_write_addr = 'b0;
        issue_stbuf_read_addr = 'h2;
        wait_clk();
        assert(stbuf_exlsu_bus_data_feedback == 'hdeadaabb) else $finish;
        rst = 1;
        wait_clk();
        rst = 0;
        exlsu_stbuf_write_size = 'h2;
        issue_stbuf_read_addr = 'b0;
        wait_clk();
        assert(stbuf_exlsu_bus_data_feedback == 'hdeadccdd) else $finish;
        rst = 1;
        wait_clk();
        rst = 0;
        exlsu_stbuf_write_addr = 'h2;
        wait_clk();
        assert(stbuf_exlsu_bus_data_feedback == 'hccddbeef) else $finish;
        rst = 1;
        wait_clk();
        rst = 0;
        exlsu_stbuf_write_addr = 'b0;
        exlsu_stbuf_write_size = 'h2;
        exlsu_stbuf_write_data = 'hffee;
        wait_clk();
        exlsu_stbuf_write_addr = 'h3;
        exlsu_stbuf_write_size = 'h1;
        exlsu_stbuf_write_data = 'h3f;
        wait_clk();
        exlsu_stbuf_write_addr = 'h4;
        exlsu_stbuf_write_size = 'h4;
        exlsu_stbuf_write_data = 'hddccbbaa;
        issue_stbuf_read_addr = 'h1;
        wait_clk();
        assert(stbuf_exlsu_bus_data_feedback == 'haa3fbeff) else $finish;
        rst = 1;
        wait_clk();
        rst = 0;
        assert(stbuf_all_empty == 'b1) else $finish;

        for(i = 0;i < `STORE_BUFFER_SIZE;i++) begin
            assert(stbuf_exlsu_full == 'b0) else $finish;
            wait_clk();
            assert(stbuf_all_empty == 'b0) else $finish;
        end

        assert(stbuf_exlsu_full == 'b1) else $finish;
        rst = 1;
        wait_clk();
        rst = 0;
        assert(`ROB_SIZE >= `STORE_BUFFER_SIZE) else $finish;
        assert(`STORE_BUFFER_SIZE % `COMMIT_WIDTH == 0) else $finish;

        for(i = 0;i < `STORE_BUFFER_SIZE;i++) begin
            exlsu_stbuf_rob_id = unsigned'(i);
            exlsu_stbuf_write_addr = unsigned'(i);
            exlsu_stbuf_write_size = 'h4;
            exlsu_stbuf_write_data = 'h1581abcf + unsigned'(i);
            wait_clk();
            assert(stbuf_all_empty == 'b0) else $finish;
        end

        exlsu_stbuf_push = 'b0;

        for(i = 0;i < `STORE_BUFFER_SIZE / `COMMIT_WIDTH;i++) begin
            assert(stbuf_all_empty == 'b0) else $finish;
            commit_feedback_pack.enable = 'b1;

            for(j = 0;j < `COMMIT_WIDTH;j++) begin
                commit_feedback_pack.committed_rob_id_valid[j] = 'b1;
                commit_feedback_pack.committed_rob_id[j] = unsigned'(i * `COMMIT_WIDTH + j);
            end

            bus_stbuf_write_ack = 'b0;
            wait_clk();
            bus_stbuf_write_ack = 'b1;
            eval();

            for(j = 0;j < `COMMIT_WIDTH;j++) begin
                assert(stbuf_bus_write_addr == unsigned'(i * `COMMIT_WIDTH + j)) else $finish;
                assert(stbuf_bus_write_size == 'h4) else $finish;
                assert(stbuf_bus_data == 'h1581abcf + unsigned'(i * `COMMIT_WIDTH + j)) else $finish;
                assert(stbuf_bus_write_req == 'b1) else $finish;               
                wait_clk();
            end
        end

        assert(stbuf_all_empty == 'b1) else $finish;
        rst = 1;
        wait_clk();
        rst = 0;
        exlsu_stbuf_rob_id = 'b1;
        exlsu_stbuf_push = 'b1;
        wait_clk();
        exlsu_stbuf_push = 'b0;
        assert(stbuf_all_empty == 'b0) else $finish;
        commit_feedback_pack.enable = 'b1;
        commit_feedback_pack.committed_rob_id_valid = 'b0;
        commit_feedback_pack.flush = 'b1;
        wait_clk();
        assert(stbuf_all_empty == 'b1) else $finish;
        commit_feedback_pack.flush = 'b0;
        exlsu_stbuf_rob_id = 'b1;
        exlsu_stbuf_push = 'b1;
        wait_clk();
        exlsu_stbuf_push = 'b0;
        assert(stbuf_all_empty == 'b0) else $finish;
        commit_feedback_pack.enable = 'b1;
        commit_feedback_pack.flush = 'b1;
        commit_feedback_pack.committed_rob_id_valid = 'b1;
        commit_feedback_pack.committed_rob_id[0] = 'b1;
        wait_clk();
        assert(stbuf_all_empty == 'b0) else $finish;
        commit_feedback_pack.committed_rob_id_valid = 'b0;
        assert(stbuf_bus_write_req == 'b0) else $finish;
        wait_clk();
        assert(stbuf_all_empty == 'b0) else $finish;
        commit_feedback_pack.flush = 'b0;
        eval();
        assert(stbuf_bus_write_req == 'b1) else $finish;
        bus_stbuf_write_ack = 'b1;
        wait_clk();
        assert(stbuf_all_empty == 'b1) else $finish;
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
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