`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data;
    logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data_feedback;
    logic stbuf_exlsu_bus_ready;
    
    logic[`ROB_ID_WIDTH - 1:0] exlsu_stbuf_rob_id;
    logic[`ADDR_WIDTH - 1:0] exlsu_stbuf_write_addr;
    logic[`SIZE_WIDTH - 1:0] exlsu_stbuf_write_size;
    logic[`BUS_DATA_WIDTH - 1:0] exlsu_stbuf_write_data;
    logic exlsu_stbuf_push;
    logic stbuf_exlsu_full;
    
    issue_execute_pack_t issue_lsu_fifo_data_out;
    logic issue_lsu_fifo_data_out_valid;
    logic issue_lsu_fifo_pop;
    
    execute_wb_pack_t lsu_wb_port_data_in;
    logic lsu_wb_port_we;
    logic lsu_wb_port_flush;
    
    execute_feedback_channel_t lsu_execute_channel_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    issue_execute_pack_t t_pack;
    
    execute_lsu execute_lsu_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task test;
        rst = 1;
        stbuf_exlsu_bus_data = 'b0;
        stbuf_exlsu_bus_data_feedback = 'b0;
        stbuf_exlsu_bus_ready = 'b0;
        stbuf_exlsu_full = 'b0;
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
        t_pack.src1_value = 'b0;
        t_pack.src1_loaded = 'b0;
        t_pack.rs2 = 'b0;
        t_pack.arg2_src = arg_src_t::_reg;
        t_pack.rs2_need_map = 'b0;
        t_pack.rs2_phy = 'b0;
        t_pack.src2_value = 'b0;
        t_pack.src2_loaded = 'b0;
        t_pack.rd = 'b0;
        t_pack.rd_enable = 'b0;
        t_pack.need_rename = 'b0;
        t_pack.rd_phy = 'b0;
        t_pack.csr = 'b0;
        t_pack.lsu_addr = 'b0;
        t_pack.op = op_t::lb;
        t_pack.op_unit = op_unit_t::lsu;
        t_pack.sub_op.lsu_op = lsu_op_t::lb;
        issue_lsu_fifo_data_out = t_pack;
        issue_lsu_fifo_data_out_valid = 'b0;
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
        wait_clk();
        assert(lsu_wb_port_data_in.enable == 'b0) else $finish;
        assert(lsu_wb_port_we == 'b0) else $finish;
        assert(lsu_wb_port_flush == 'b1) else $finish;
        assert(issue_lsu_fifo_pop == 'b0) else $finish;
        assert(lsu_execute_channel_feedback_pack.enable == 'b0) else $finish;
        wait_clk();
        t_pack.enable = 'b1;
        t_pack.has_exception = 'b1;
        t_pack.exception_id = riscv_exception_t::illegal_instruction;
        issue_lsu_fifo_data_out = t_pack;
        wait_clk();
        assert(lsu_wb_port_we == 'b0) else $finish;
        assert(lsu_wb_port_flush == 'b1) else $finish;
        assert(issue_lsu_fifo_pop == 'b0) else $finish;
        assert(lsu_execute_channel_feedback_pack.enable == 'b0) else $finish;
        issue_lsu_fifo_data_out_valid = 'b1;
        stbuf_exlsu_bus_ready = 'b1;
        wait_clk();
        assert(lsu_wb_port_data_in.enable == 'b1) else $finish;
        assert(lsu_wb_port_data_in.valid == 'b0) else $finish;
        assert(lsu_wb_port_data_in.has_exception == 'b1) else $finish;
        assert(lsu_wb_port_data_in.exception_id == riscv_exception_t::illegal_instruction) else $finish;
        assert(lsu_wb_port_we == 'b1) else $finish;
        assert(lsu_wb_port_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_pop == 'b1) else $finish;
        assert(lsu_execute_channel_feedback_pack.enable == 'b0) else $finish;
        t_pack.valid = 'b1;
        t_pack.has_exception = 'b0;
        issue_lsu_fifo_data_out = t_pack;
        wait_clk();
        assert(lsu_wb_port_data_in.enable == 'b1) else $finish;
        assert(lsu_wb_port_data_in.valid == 'b1) else $finish;
        assert(lsu_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(lsu_wb_port_we == 'b1) else $finish;
        assert(lsu_wb_port_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_pop == 'b1) else $finish;
        assert(lsu_execute_channel_feedback_pack.enable == 'b0) else $finish;
        t_pack.has_exception = 'b1;
        t_pack.exception_id = riscv_exception_t::breakpoint;
        issue_lsu_fifo_data_out = t_pack;
        wait_clk();
        assert(lsu_wb_port_data_in.enable == 'b1) else $finish;
        assert(lsu_wb_port_data_in.valid == 'b1) else $finish;
        assert(lsu_wb_port_data_in.has_exception == 'b1) else $finish;
        assert(lsu_wb_port_data_in.exception_id == riscv_exception_t::breakpoint) else $finish;
        assert(lsu_wb_port_we == 'b1) else $finish;
        assert(lsu_wb_port_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_pop == 'b1) else $finish;
        assert(lsu_execute_channel_feedback_pack.enable == 'b0) else $finish;
        t_pack.has_exception = 'b0;
        t_pack.rd_phy = 'd10;
        t_pack.rd_enable = 'b1;
        t_pack.need_rename = 'b1;
        t_pack.op = op_t::lw;
        t_pack.sub_op.lsu_op = lsu_op_t::lw;
        stbuf_exlsu_bus_data_feedback = 'hdace1557;
        issue_lsu_fifo_data_out = t_pack;
        wait_clk();
        assert(lsu_wb_port_data_in.enable == 'b1) else $finish;
        assert(lsu_wb_port_data_in.valid == 'b1) else $finish;
        assert(lsu_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(lsu_wb_port_data_in.rd_value == stbuf_exlsu_bus_data_feedback) else $finish;
        assert(lsu_wb_port_we == 'b1) else $finish;
        assert(lsu_wb_port_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_pop == 'b1) else $finish;
        assert(lsu_execute_channel_feedback_pack.enable == 'b1) else $finish;
        assert(lsu_execute_channel_feedback_pack.phy_id == unsigned'('d10)) else $finish;
        assert(lsu_execute_channel_feedback_pack.value == stbuf_exlsu_bus_data_feedback) else $finish;
        assert(exlsu_stbuf_push == 'b0) else $finish;
        t_pack.rob_id = 'd7;
        t_pack.rd_enable = 'b0;
        t_pack.need_rename = 'b0;
        t_pack.lsu_addr = 'haaccbeef;
        t_pack.src2_value = 'hdeadbeef;
        t_pack.op = op_t::sh;
        t_pack.sub_op.lsu_op = lsu_op_t::sh;
        issue_lsu_fifo_data_out = t_pack;
        stbuf_exlsu_full = 'b1;
        wait_clk();
        assert(exlsu_stbuf_push == 'b0) else $finish;
        assert(issue_lsu_fifo_pop == 'b0) else $finish; 
        stbuf_exlsu_full = 'b0;
        wait_clk();
        assert(exlsu_stbuf_rob_id == t_pack.rob_id) else $finish;
        assert(exlsu_stbuf_write_addr == t_pack.lsu_addr) else $finish;
        assert(exlsu_stbuf_write_size == 'h2) else $finish;
        assert(exlsu_stbuf_write_data == t_pack.src2_value[15:0]) else $finish;
        assert(exlsu_stbuf_push == 'b1) else $finish;
        assert(issue_lsu_fifo_pop == 'b1) else $finish; 
        commit_feedback_pack.enable = 'b1;
        wait_clk();
        assert(lsu_wb_port_data_in.enable == 'b1) else $finish;
        assert(lsu_wb_port_data_in.valid == 'b1) else $finish;
        assert(lsu_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(lsu_wb_port_we == 'b1) else $finish;
        assert(lsu_wb_port_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_pop == 'b1) else $finish;
        assert(lsu_execute_channel_feedback_pack.enable == 'b0) else $finish;
        commit_feedback_pack.flush = 'b1;
        wait_clk();
        assert(lsu_wb_port_we == 'b0) else $finish;
        assert(lsu_wb_port_flush == 'b1) else $finish;
        assert(issue_lsu_fifo_pop == 'b0) else $finish;
        assert(lsu_execute_channel_feedback_pack.enable == 'b0) else $finish;
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