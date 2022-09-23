`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`ADDR_WIDTH - 1:0] fetch_bp_update_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_update_instruction;
    logic fetch_bp_update_jump;
    logic[`ADDR_WIDTH - 1:0] fetch_bp_update_next_pc;
    logic fetch_bp_update_valid;
    
    logic[`ADDR_WIDTH -1:0] fetch_bp_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_instruction;
    logic fetch_bp_valid;
    logic bp_fetch_jump;
    logic[`ADDR_WIDTH - 1:0] bp_fetch_next_pc;
    logic bp_fetch_valid;
    logic[`GSHARE_GLOBAL_HISTORY_WIDTH - 1:0] bp_fetch_global_history;
    logic[`LOCAL_BHT_WIDTH - 1:0] bp_fetch_local_history; 
    
    logic[`ADDR_WIDTH - 1:0] fetch_bus_addr;
    logic fetch_bus_read_req;
    logic[`INSTRUCTION_WIDTH * `FETCH_WIDTH - 1:0] bus_fetch_data;
    logic bus_fetch_read_ack;
    
    logic fetch_csrf_checkpoint_buffer_full_add;
    logic fetch_csrf_fetch_not_full_add;
    logic fetch_csrf_fetch_decode_fifo_full_add;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] cpbuf_fetch_new_id;
    logic cpbuf_fetch_new_id_valid;
    checkpoint_t fetch_cpbuf_data;
    logic fetch_cpbuf_push;
    
    logic stbuf_all_empty;
    
    logic[`FETCH_WIDTH - 1:0] fetch_decode_fifo_data_in_enable;
    fetch_decode_pack_t fetch_decode_fifo_data_in[0:`FETCH_WIDTH - 1];
    logic[`FETCH_WIDTH - 1:0] fetch_decode_fifo_data_in_valid;
    logic fetch_decode_fifo_push;
    logic fetch_decode_fifo_flush;
    
    decode_feedback_pack_t decode_feedback_pack;
    rename_feedback_pack_t rename_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    integer i, j;

    fetch fetch_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        bp_fetch_jump = 'b0;
        bp_fetch_next_pc = 'b0;
        bp_fetch_valid = 'b0;
        bp_fetch_global_history = 'b0;
        bp_fetch_local_history = 'b0;
        bus_fetch_data = 'b0;
        bus_fetch_read_ack = 'b0;
        cpbuf_fetch_new_id = 'b0;
        cpbuf_fetch_new_id_valid = 'b0;
        stbuf_all_empty = 'b0;
        fetch_decode_fifo_data_in_enable = 'b0;
        decode_feedback_pack.idle = 'b0;
        rename_feedback_pack.idle = 'b0;
        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.flush = 'b0;
        commit_feedback_pack.jump_enable = 'b0;
        commit_feedback_pack.jump = 'b0;
        commit_feedback_pack.next_pc = 'b0;
        commit_feedback_pack.has_exception = 'b0;
        commit_feedback_pack.exception_pc = 'b0;
        wait_clk();
        rst = 0;
        assert(fetch_bp_update_valid == 'b0) else $finish;
        assert(fetch_bp_valid == 'b0) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b0) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b0) else $finish;
        assert(fetch_decode_fifo_push == 'b0) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        bus_fetch_data = 128'h83018213_c1810193_7d008113_3e800093;
        eval();
        assert(fetch_bp_update_valid == 'b0) else $finish;
        assert(fetch_bp_valid == 'b0) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b0) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b0) else $finish;
        assert(fetch_decode_fifo_push == 'b0) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        bus_fetch_read_ack = 'b1;
        eval();
        assert(fetch_bp_update_valid == 'b0) else $finish;
        assert(fetch_bp_valid == 'b0) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b1) else $finish;
        assert(fetch_cpbuf_push == 'b0) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b0) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        fetch_decode_fifo_data_in_enable = 'b1;
        eval();
        assert(fetch_bp_update_valid == 'b0) else $finish;
        assert(fetch_bp_valid == 'b0) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 4)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b1) else $finish;
        assert(fetch_cpbuf_push == 'b0) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b1) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        wait_clk();
        fetch_decode_fifo_data_in_enable = 'b1111;
        eval();
        assert(fetch_bp_update_valid == 'b0) else $finish;
        assert(fetch_bp_valid == 'b0) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 20)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b0) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b1111) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        wait_clk();
        commit_feedback_pack.enable = 'b1;
        commit_feedback_pack.flush = 'b1;
        fetch_decode_fifo_data_in_enable = 'b0;
        eval();
        assert(fetch_bp_update_valid == 'b0) else $finish;
        assert(fetch_bp_valid == 'b0) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 20)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b0) else $finish;
        assert(fetch_decode_fifo_flush == 'b1) else $finish;
        fetch_decode_fifo_data_in_enable = 'b1111;
        eval();
        assert(fetch_bp_update_valid == 'b0) else $finish;
        assert(fetch_bp_valid == 'b0) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 20)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b0) else $finish;
        assert(fetch_decode_fifo_flush == 'b1) else $finish;
        commit_feedback_pack.has_exception = 'b1;
        commit_feedback_pack.exception_pc = 'hdeadbeef;
        commit_feedback_pack.jump_enable = 'b1;
        commit_feedback_pack.next_pc = 'haabbccdd;
        eval();
        assert(fetch_bus_addr == 'hdeadbeef) else $finish;
        commit_feedback_pack.has_exception = 'b0;
        eval();
        assert(fetch_bus_addr == 'haabbccdd) else $finish;
        commit_feedback_pack.jump_enable = 'b0;
        wait_clk();
        commit_feedback_pack.enable = 'b1;
        commit_feedback_pack.flush = 'b0;
        fetch_decode_fifo_data_in_enable = 'b1111;
        bus_fetch_data = 128'h83018213_c1810193_0000100f_3e800093;//fence.i = 0000100f
        eval();
        assert(fetch_bp_update_valid == 'b0) else $finish;
        assert(fetch_bp_valid == 'b0) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 24)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b0) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b1) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        wait_clk();
        bus_fetch_data = 128'h83018213_c1810193_3e800093_0000100f;//fence.i = 0000100f
        eval();
        assert(fetch_bp_update_valid == 'b0) else $finish;
        assert(fetch_bp_valid == 'b0) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 24)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b0) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b0) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        stbuf_all_empty = 'b1;
        eval();
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 24)) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b0) else $finish;
        decode_feedback_pack.idle = 'b1;
        eval();
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 24)) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b0) else $finish;
        rename_feedback_pack.idle = 'b1;
        eval();
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 24)) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b0) else $finish;
        commit_feedback_pack.enable = 'b0;
        eval();
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 40)) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b1111) else $finish;
        wait_clk();
        bus_fetch_data = 128'h83018213_c1810193_3e800093_00109463;//00109463 = bne ra, ra, 8
        bp_fetch_valid = 'b1;
        bp_fetch_jump = 'b1;
        bp_fetch_next_pc = 'ha1b2c3d4;
        eval();
        assert(fetch_bp_pc == unsigned'(`INIT_PC + 40)) else $finish;
        assert(fetch_bp_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_pc == unsigned'(`INIT_PC + 40)) else $finish;
        assert(fetch_bp_update_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_jump == 'b1) else $finish;
        assert(fetch_bp_update_next_pc == 'ha1b2c3d4) else $finish;
        assert(fetch_bp_update_valid == 'b1) else $finish;
        assert(fetch_bp_valid == 'b1) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 44)) else $finish;
        assert(fetch_bus_read_req == 'b0) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b1) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b1) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b1) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b1) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        cpbuf_fetch_new_id_valid = 'b1;
        bp_fetch_global_history = 'h123;
        bp_fetch_local_history = 'h456;
        eval();
        assert(fetch_bp_pc == unsigned'(`INIT_PC + 40)) else $finish;
        assert(fetch_bp_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_pc == unsigned'(`INIT_PC + 40)) else $finish;
        assert(fetch_bp_update_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_jump == 'b1) else $finish;
        assert(fetch_bp_update_next_pc == 'ha1b2c3d4) else $finish;
        assert(fetch_bp_update_valid == 'b1) else $finish;
        assert(fetch_bp_valid == 'b1) else $finish;
        assert(fetch_bus_addr == 'ha1b2c3d4) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b1) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b1) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b1) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        assert(fetch_cpbuf_data.global_history == bp_fetch_global_history) else $finish;
        assert(fetch_cpbuf_data.local_history == bp_fetch_local_history) else $finish;
        bp_fetch_jump = 'b0;
        eval();
        assert(fetch_bp_pc == unsigned'(`INIT_PC + 40)) else $finish;
        assert(fetch_bp_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_pc == unsigned'(`INIT_PC + 40)) else $finish;
        assert(fetch_bp_update_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_jump == 'b0) else $finish;
        assert(fetch_bp_update_next_pc == 'ha1b2c3d4) else $finish;
        assert(fetch_bp_update_valid == 'b1) else $finish;
        assert(fetch_bp_valid == 'b1) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 44)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b1) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b1) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b1) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        assert(fetch_cpbuf_data.global_history == bp_fetch_global_history) else $finish;
        assert(fetch_cpbuf_data.local_history == bp_fetch_local_history) else $finish;
        bus_fetch_data = 128'h83018213_c1810193_00109463_3e800093;//00109463 = bne ra, ra, 8
        eval();
        assert(fetch_bp_pc == unsigned'(`INIT_PC + 44)) else $finish;
        assert(fetch_bp_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_pc == unsigned'(`INIT_PC + 44)) else $finish;
        assert(fetch_bp_update_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_jump == 'b0) else $finish;
        assert(fetch_bp_update_next_pc == 'ha1b2c3d4) else $finish;
        assert(fetch_bp_update_valid == 'b1) else $finish;
        assert(fetch_bp_valid == 'b1) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 48)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b1) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b1) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b11) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        assert(fetch_cpbuf_data.global_history == bp_fetch_global_history) else $finish;
        assert(fetch_cpbuf_data.local_history == bp_fetch_local_history) else $finish;
        bus_fetch_data = 128'h00109463_83018213_c1810193_3e800093;//00109463 = bne ra, ra, 8
        eval();
        assert(fetch_bp_pc == unsigned'(`INIT_PC + 52)) else $finish;
        assert(fetch_bp_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_pc == unsigned'(`INIT_PC + 52)) else $finish;
        assert(fetch_bp_update_instruction == 'h00109463) else $finish;
        assert(fetch_bp_update_jump == 'b0) else $finish;
        assert(fetch_bp_update_next_pc == 'ha1b2c3d4) else $finish;
        assert(fetch_bp_update_valid == 'b1) else $finish;
        assert(fetch_bp_valid == 'b1) else $finish;
        assert(fetch_bus_addr == unsigned'(`INIT_PC + 56)) else $finish;
        assert(fetch_bus_read_req == 'b1) else $finish;
        assert(fetch_csrf_checkpoint_buffer_full_add == 'b0) else $finish;
        assert(fetch_csrf_fetch_not_full_add == 'b1) else $finish;
        assert(fetch_csrf_fetch_decode_fifo_full_add == 'b0) else $finish;
        assert(fetch_cpbuf_push == 'b1) else $finish;
        assert(fetch_decode_fifo_data_in_valid == 'b1111) else $finish;
        assert(fetch_decode_fifo_push == 'b1) else $finish;
        assert(fetch_decode_fifo_flush == 'b0) else $finish;
        assert(fetch_cpbuf_data.global_history == bp_fetch_global_history) else $finish;
        assert(fetch_cpbuf_data.local_history == bp_fetch_local_history) else $finish;
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