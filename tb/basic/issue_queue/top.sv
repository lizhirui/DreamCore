`include "config.svh"
`include "common.svh"

module top;
    localparam INPUT_PORT_NUM = `READREG_WIDTH;
    localparam OUTPUT_PORT_NUM = `ISSUE_WIDTH;
    localparam DEPTH = `ISSUE_QUEUE_SIZE;    

    logic clk;
    logic rst;

    logic[INPUT_PORT_NUM - 1:0] iq_issue_data_channel_enable;
    issue_queue_item_t issue_iq_data[0:INPUT_PORT_NUM - 1];
    logic[INPUT_PORT_NUM - 1:0] issue_iq_data_valid;
    logic issue_iq_push;
    logic iq_issue_full;
    logic issue_iq_flush;
    
    issue_queue_item_t iq_issue_data[0:OUTPUT_PORT_NUM - 1];
    logic[OUTPUT_PORT_NUM - 1:0] iq_issue_data_valid;
    logic iq_issue_empty;

    logic stbuf_all_empty;
    
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_full;
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_full;
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_full;
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_full;
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_full;
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_full;

    logic iq_issue_issue_execute_fifo_full_add;
    
    execute_feedback_pack_t execute_feedback_pack;
    wb_feedback_pack_t wb_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    integer i, j;

    issue_queue #(
        .INPUT_PORT_NUM(INPUT_PORT_NUM),
        .OUTPUT_PORT_NUM(OUTPUT_PORT_NUM),
        .DEPTH(DEPTH)
    )issue_queue_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        
        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b0;
            issue_iq_data[i].value = 'b0;
            issue_iq_data[i].valid = 'b0;
            issue_iq_data[i].rob_id = 'b0;
            issue_iq_data[i].pc = 'b0;
            issue_iq_data[i].imm = 'b0;
            issue_iq_data[i].has_exception = 'b0;
            issue_iq_data[i].exception_id = riscv_exception_t::instruction_address_misaligned;
            issue_iq_data[i].exception_value = 'b0;
            issue_iq_data[i].predicted = 'b0;
            issue_iq_data[i].predicted_jump = 'b0;
            issue_iq_data[i].predicted_next_pc = 'b0;
            issue_iq_data[i].checkpoint_id_valid = 'b0;
            issue_iq_data[i].checkpoint_id = 'b0;
            issue_iq_data[i].rs1 = 'b0;
            issue_iq_data[i].arg1_src = arg_src_t::_reg;
            issue_iq_data[i].rs1_need_map = 'b0;
            issue_iq_data[i].rs1_phy = 'b0;
            issue_iq_data[i].src1_value = 'b0;
            issue_iq_data[i].src1_loaded = 'b0;
            issue_iq_data[i].rs2 = 'b0;
            issue_iq_data[i].arg2_src = arg_src_t::_reg;
            issue_iq_data[i].rs2_need_map = 'b0;
            issue_iq_data[i].rs2_phy = 'b0;
            issue_iq_data[i].src2_value = 'b0;
            issue_iq_data[i].src2_loaded = 'b0;
            issue_iq_data[i].rd = 'b0;
            issue_iq_data[i].rd_enable = 'b0;
            issue_iq_data[i].need_rename = 'b0;
            issue_iq_data[i].rd_phy = 'b0;
            issue_iq_data[i].csr = 'b0;
            issue_iq_data[i].op = op_t::add;
            issue_iq_data[i].op_unit = op_unit_t::alu;
            issue_iq_data[i].sub_op.alu_op = alu_op_t::add;
        end

        issue_iq_data_valid = 'b0;
        issue_iq_push = 'b0;
        issue_iq_flush = 'b0;
        stbuf_all_empty = 'b0;
        issue_alu_fifo_full = 'b0;
        issue_bru_fifo_full = 'b0;
        issue_csr_fifo_full = 'b0;
        issue_div_fifo_full = 'b0;
        issue_lsu_fifo_full = 'b0;
        issue_mul_fifo_full = 'b0;
        
        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            execute_feedback_pack.channel[i].enable = 'b0;
            execute_feedback_pack.channel[i].phy_id = 'b0;
            execute_feedback_pack.channel[i].value = 'b0;
            wb_feedback_pack.channel[i].enable = 'b0;
            wb_feedback_pack.channel[i].phy_id = 'b0;
            wb_feedback_pack.channel[i].value = 'b0;
        end

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
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        //two ready alu instruction test
        for(i = 0;i < OUTPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::alu;
            issue_iq_data[i].src1_loaded = 'b1;
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].src2_loaded = 'b1;
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b11) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        
        for(i = 0;i < OUTPUT_PORT_NUM;i++) begin
            assert(iq_issue_data[i].enable == 'b1) else $finish;
            assert(iq_issue_data[i].valid == 'b1) else $finish;
            assert(iq_issue_data[i].pc == issue_iq_data[i].pc) else $finish;
            assert(iq_issue_data[i].op_unit == op_unit_t::alu) else $finish;
            assert(iq_issue_data[i].src1_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src1_value == issue_iq_data[i].src1_value) else $finish;
            assert(iq_issue_data[i].src2_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src2_value == issue_iq_data[i].src2_value) else $finish;
            assert(iq_issue_data[i] == issue_iq_data[i]) else $finish;
        end

        //disable a alu unit
        issue_alu_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        
        for(i = 0;i < 1;i++) begin
            assert(iq_issue_data[i].enable == 'b1) else $finish;
            assert(iq_issue_data[i].valid == 'b1) else $finish;
            assert(iq_issue_data[i].pc == issue_iq_data[i].pc) else $finish;
            assert(iq_issue_data[i].op_unit == op_unit_t::alu) else $finish;
            assert(iq_issue_data[i].src1_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src1_value == issue_iq_data[i].src1_value) else $finish;
            assert(iq_issue_data[i].src2_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src2_value == issue_iq_data[i].src2_value) else $finish;
            assert(iq_issue_data[i] == issue_iq_data[i]) else $finish;
        end

        //disable another alu unit
        issue_alu_fifo_full[0] = 'b0;
        issue_alu_fifo_full[1] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        
        for(i = 0;i < 1;i++) begin
            assert(iq_issue_data[i].enable == 'b1) else $finish;
            assert(iq_issue_data[i].valid == 'b1) else $finish;
            assert(iq_issue_data[i].pc == issue_iq_data[i].pc) else $finish;
            assert(iq_issue_data[i].op_unit == op_unit_t::alu) else $finish;
            assert(iq_issue_data[i].src1_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src1_value == issue_iq_data[i].src1_value) else $finish;
            assert(iq_issue_data[i].src2_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src2_value == issue_iq_data[i].src2_value) else $finish;
            assert(iq_issue_data[i] == issue_iq_data[i]) else $finish;
        end

        //disable all alu unit
        issue_alu_fifo_full[0] = 'b1;
        issue_alu_fifo_full[1] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        
        for(i = 0;i < 1;i++) begin
            assert(iq_issue_data[i].enable == 'b1) else $finish;
            assert(iq_issue_data[i].valid == 'b1) else $finish;
            assert(iq_issue_data[i].pc == issue_iq_data[i].pc) else $finish;
            assert(iq_issue_data[i].op_unit == op_unit_t::alu) else $finish;
            assert(iq_issue_data[i].src1_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src1_value == issue_iq_data[i].src1_value) else $finish;
            assert(iq_issue_data[i].src2_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src2_value == issue_iq_data[i].src2_value) else $finish;
            assert(iq_issue_data[i] == issue_iq_data[i]) else $finish;
        end

        //flush
        issue_alu_fifo_full[0] = 'b0;
        issue_alu_fifo_full[1] = 'b0;
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        //out-of-order alu test
        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::alu;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b11) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < OUTPUT_PORT_NUM;i++) begin
            assert(iq_issue_data[i].enable == 'b1) else $finish;
            assert(iq_issue_data[i].valid == 'b1) else $finish;
            assert(iq_issue_data[i].pc == issue_iq_data[i * 2 + 1].pc) else $finish;
            assert(iq_issue_data[i].op_unit == op_unit_t::alu) else $finish;
            assert(iq_issue_data[i].src1_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src1_value == issue_iq_data[i * 2 + 1].src1_value) else $finish;
            assert(iq_issue_data[i].src2_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src2_value == issue_iq_data[i * 2 + 1].src2_value) else $finish;
            assert(iq_issue_data[i] == issue_iq_data[i * 2 + 1]) else $finish;
        end
        //one alu unit only
        issue_alu_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < 1;i++) begin
            assert(iq_issue_data[i].enable == 'b1) else $finish;
            assert(iq_issue_data[i].valid == 'b1) else $finish;
            assert(iq_issue_data[i].pc == issue_iq_data[i * 2 + 1].pc) else $finish;
            assert(iq_issue_data[i].op_unit == op_unit_t::alu) else $finish;
            assert(iq_issue_data[i].src1_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src1_value == issue_iq_data[i * 2 + 1].src1_value) else $finish;
            assert(iq_issue_data[i].src2_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src2_value == issue_iq_data[i * 2 + 1].src2_value) else $finish;
            assert(iq_issue_data[i] == issue_iq_data[i * 2 + 1]) else $finish;
        end
        //zero idle alu
        issue_alu_fifo_full[1] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        issue_alu_fifo_full[0] = 'b0;
        issue_alu_fifo_full[1] = 'b0;
        //execute feedback test
        execute_feedback_pack.channel[0].enable = 'b1;
        execute_feedback_pack.channel[0].phy_id = 'b0;
        execute_feedback_pack.channel[0].value = 'h1582a6c5;
        execute_feedback_pack.channel[1].enable = 'b1;
        execute_feedback_pack.channel[1].phy_id = 'b1;
        execute_feedback_pack.channel[1].value = 'h1887c1d5;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b11) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        assert(iq_issue_data[0].enable == 'b1) else $finish;
        assert(iq_issue_data[0].valid == 'b1) else $finish;
        assert(iq_issue_data[0].pc == issue_iq_data[0].pc) else $finish;
        assert(iq_issue_data[0].op_unit == op_unit_t::alu) else $finish;
        assert(iq_issue_data[0].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src1_value == 'h1582a6c5) else $finish;
        assert(iq_issue_data[0].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src2_value == 'h1887c1d5) else $finish;
        assert(iq_issue_data[1].enable == 'b1) else $finish;
        assert(iq_issue_data[1].valid == 'b1) else $finish;
        assert(iq_issue_data[1].pc == issue_iq_data[1].pc) else $finish;
        assert(iq_issue_data[1].op_unit == op_unit_t::alu) else $finish;
        assert(iq_issue_data[1].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[1].src1_value == issue_iq_data[1].src1_value) else $finish;
        assert(iq_issue_data[1].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[1].src2_value == issue_iq_data[1].src2_value) else $finish;
        assert(iq_issue_data[1] == issue_iq_data[1]) else $finish;
        //wb feedback test
        execute_feedback_pack.channel[0].enable = 'b0;
        execute_feedback_pack.channel[1].enable = 'b0;
        wb_feedback_pack.channel[0].enable = 'b1;
        wb_feedback_pack.channel[0].phy_id = 'b0;
        wb_feedback_pack.channel[0].value = 'h1582a6f5;
        wb_feedback_pack.channel[1].enable = 'b1;
        wb_feedback_pack.channel[1].phy_id = 'b1;
        wb_feedback_pack.channel[1].value = 'h1887c135;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b11) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        assert(iq_issue_data[0].enable == 'b1) else $finish;
        assert(iq_issue_data[0].valid == 'b1) else $finish;
        assert(iq_issue_data[0].pc == issue_iq_data[0].pc) else $finish;
        assert(iq_issue_data[0].op_unit == op_unit_t::alu) else $finish;
        assert(iq_issue_data[0].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src1_value == 'h1582a6f5) else $finish;
        assert(iq_issue_data[0].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src2_value == 'h1887c135) else $finish;
        assert(iq_issue_data[1].enable == 'b1) else $finish;
        assert(iq_issue_data[1].valid == 'b1) else $finish;
        assert(iq_issue_data[1].pc == issue_iq_data[1].pc) else $finish;
        assert(iq_issue_data[1].op_unit == op_unit_t::alu) else $finish;
        assert(iq_issue_data[1].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[1].src1_value == issue_iq_data[1].src1_value) else $finish;
        assert(iq_issue_data[1].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[1].src2_value == issue_iq_data[1].src2_value) else $finish;
        assert(iq_issue_data[1] == issue_iq_data[1]) else $finish;
        //div test
        wb_feedback_pack.channel[0].enable = 'b0;
        wb_feedback_pack.channel[1].enable = 'b0;
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        //out-of-order div test
        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::div;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < 1;i++) begin
            assert(iq_issue_data[i].enable == 'b1) else $finish;
            assert(iq_issue_data[i].valid == 'b1) else $finish;
            assert(iq_issue_data[i].pc == issue_iq_data[i * 2 + 1].pc) else $finish;
            assert(iq_issue_data[i].op_unit == op_unit_t::div) else $finish;
            assert(iq_issue_data[i].src1_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src1_value == issue_iq_data[i * 2 + 1].src1_value) else $finish;
            assert(iq_issue_data[i].src2_loaded == 'b1) else $finish;
            assert(iq_issue_data[i].src2_value == issue_iq_data[i * 2 + 1].src2_value) else $finish;
            assert(iq_issue_data[i] == issue_iq_data[i * 2 + 1]) else $finish;
        end

        //zero idle div
        issue_div_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //csr first test
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].rob_id = unsigned'(3 + i);
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::csr;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = ~unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = ~unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //set next_rob_id
        commit_feedback_pack.next_handle_rob_id = 'h3;
        commit_feedback_pack.next_handle_rob_id_valid = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        assert(iq_issue_data[0].enable == 'b1) else $finish;
        assert(iq_issue_data[0].valid == 'b1) else $finish;
        assert(iq_issue_data[0].pc == issue_iq_data[0].pc) else $finish;
        assert(iq_issue_data[0].op_unit == op_unit_t::csr) else $finish;
        assert(iq_issue_data[0].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src1_value == issue_iq_data[0].src1_value) else $finish;
        assert(iq_issue_data[0].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src2_value == issue_iq_data[0].src2_value) else $finish;
        //zero idle csr
        issue_csr_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //csr second test
        issue_csr_fifo_full[0] = 'b0;
        commit_feedback_pack.next_handle_rob_id = 'b0;
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].rob_id = unsigned'(3 + i);
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::csr;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //set next_rob_id
        commit_feedback_pack.next_handle_rob_id = 'h3;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //zero idle csr
        issue_csr_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //mret first test
        commit_feedback_pack.next_handle_rob_id = 'b0;
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].rob_id = unsigned'(3 + i);
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::bru;
            issue_iq_data[i].op = op_t::mret;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = ~unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = ~unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //set next_rob_id
        commit_feedback_pack.next_handle_rob_id = 'h3;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        assert(iq_issue_data[0].enable == 'b1) else $finish;
        assert(iq_issue_data[0].valid == 'b1) else $finish;
        assert(iq_issue_data[0].pc == issue_iq_data[0].pc) else $finish;
        assert(iq_issue_data[0].op_unit == op_unit_t::bru) else $finish;
        assert(iq_issue_data[0].op == op_t::mret) else $finish;
        assert(iq_issue_data[0].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src1_value == issue_iq_data[0].src1_value) else $finish;
        assert(iq_issue_data[0].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src2_value == issue_iq_data[0].src2_value) else $finish;
        //zero idle bru
        issue_bru_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //mret second test
        issue_bru_fifo_full[0] = 'b0;
        commit_feedback_pack.next_handle_rob_id = 'b0;
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].rob_id = unsigned'(3 + i);
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::bru;
            issue_iq_data[i].op = op_t::mret;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //set next_rob_id
        commit_feedback_pack.next_handle_rob_id = 'h3;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //zero idle bru
        issue_bru_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //fence first test
        commit_feedback_pack.next_handle_rob_id = 'b0;
        issue_alu_fifo_full[0] = 'b0;
        issue_alu_fifo_full[1] = 'b0;
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].rob_id = unsigned'(3 + i);
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::alu;
            issue_iq_data[i].op = op_t::fence;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = ~unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = ~unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //set next_rob_id
        commit_feedback_pack.next_handle_rob_id = 'h3;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //enable stbuf_all_empty
        stbuf_all_empty = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        assert(iq_issue_data[0].enable == 'b1) else $finish;
        assert(iq_issue_data[0].valid == 'b1) else $finish;
        assert(iq_issue_data[0].pc == issue_iq_data[0].pc) else $finish;
        assert(iq_issue_data[0].op_unit == op_unit_t::alu) else $finish;
        assert(iq_issue_data[0].op == op_t::fence) else $finish;
        assert(iq_issue_data[0].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src1_value == issue_iq_data[0].src1_value) else $finish;
        assert(iq_issue_data[0].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src2_value == issue_iq_data[0].src2_value) else $finish;
        //one idle alu
        issue_alu_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        assert(iq_issue_data[0].enable == 'b1) else $finish;
        assert(iq_issue_data[0].valid == 'b1) else $finish;
        assert(iq_issue_data[0].pc == issue_iq_data[0].pc) else $finish;
        assert(iq_issue_data[0].op_unit == op_unit_t::alu) else $finish;
        assert(iq_issue_data[0].op == op_t::fence) else $finish;
        assert(iq_issue_data[0].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src1_value == issue_iq_data[0].src1_value) else $finish;
        assert(iq_issue_data[0].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src2_value == issue_iq_data[0].src2_value) else $finish;
        //one another idle alu
        issue_alu_fifo_full[0] = 'b0;
        issue_alu_fifo_full[1] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        assert(iq_issue_data[0].enable == 'b1) else $finish;
        assert(iq_issue_data[0].valid == 'b1) else $finish;
        assert(iq_issue_data[0].pc == issue_iq_data[0].pc) else $finish;
        assert(iq_issue_data[0].op_unit == op_unit_t::alu) else $finish;
        assert(iq_issue_data[0].op == op_t::fence) else $finish;
        assert(iq_issue_data[0].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src1_value == issue_iq_data[0].src1_value) else $finish;
        assert(iq_issue_data[0].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src2_value == issue_iq_data[0].src2_value) else $finish;
        //zero idle alu
        issue_alu_fifo_full[0] = 'b1;
        issue_alu_fifo_full[1] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //fence second test
        issue_bru_fifo_full[0] = 'b0;
        commit_feedback_pack.next_handle_rob_id = 'b0;
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].rob_id = unsigned'(3 + i);
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::alu;
            issue_iq_data[i].op = op_t::fence;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //set next_rob_id
        commit_feedback_pack.next_handle_rob_id = 'h3;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //one idle alu
        issue_alu_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //one another idle alu
        issue_alu_fifo_full[0] = 'b0;
        issue_alu_fifo_full[1] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //zero idle alu
        issue_alu_fifo_full[0] = 'b1;
        issue_alu_fifo_full[1] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //lsu first test
        commit_feedback_pack.next_handle_rob_id = 'b0;
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].rob_id = unsigned'(3 + i);
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::lsu;
            issue_iq_data[i].op = op_t::lb;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = ~unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = ~unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b1) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        assert(iq_issue_data[0].enable == 'b1) else $finish;
        assert(iq_issue_data[0].valid == 'b1) else $finish;
        assert(iq_issue_data[0].pc == issue_iq_data[0].pc) else $finish;
        assert(iq_issue_data[0].op_unit == op_unit_t::lsu) else $finish;
        assert(iq_issue_data[0].op == op_t::lb) else $finish;
        assert(iq_issue_data[0].src1_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src1_value == issue_iq_data[0].src1_value) else $finish;
        assert(iq_issue_data[0].src2_loaded == 'b1) else $finish;
        assert(iq_issue_data[0].src2_value == issue_iq_data[0].src2_value) else $finish;
        //zero idle lsu
        issue_lsu_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //lsu second test
        issue_lsu_fifo_full[0] = 'b0;
        commit_feedback_pack.next_handle_rob_id = 'b0;
        issue_iq_flush = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].rob_id = unsigned'(3 + i);
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::lsu;
            issue_iq_data[i].op = op_t::lb;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = unsigned'(i & 1);
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = unsigned'(i & 1);
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        issue_iq_push = 'b1;
        wait_clk();
        issue_iq_push = 'b0;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //zero idle lsu
        issue_lsu_fifo_full[0] = 'b1;
        eval();
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b0) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        //base fifo test
        issue_iq_flush = 'b1;
        issue_alu_fifo_full[0] = 'b1;
        issue_alu_fifo_full[1] = 'b1;
        wait_clk();
        issue_iq_flush = 'b0;
        assert(iq_issue_data_channel_enable == 'b1111) else $finish;
        assert(iq_issue_full == 'b0) else $finish;
        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;

        for(i = 0;i < INPUT_PORT_NUM;i++) begin
            issue_iq_data[i].enable = 'b1;
            issue_iq_data[i].valid = 'b1;
            issue_iq_data[i].rob_id = unsigned'(3 + i);
            issue_iq_data[i].pc = unsigned'('h15744456 + i);
            issue_iq_data[i].op_unit = op_unit_t::alu;
            issue_iq_data[i].op = op_t::add;
            issue_iq_data[i].rs1_phy = unsigned'(i * 2);
            issue_iq_data[i].src1_loaded = 'b1;
            issue_iq_data[i].src1_value = unsigned'('h123acced + i);
            issue_iq_data[i].rs2_phy = unsigned'(i * 2 + 1);
            issue_iq_data[i].src2_loaded = 'b1;
            issue_iq_data[i].src2_value = unsigned'('h45617e4f + i);
            issue_iq_data_valid[i] = 'b1;
        end

        for(i = 0;i < 4;i++) begin
            assert(iq_issue_data_channel_enable == 'b1111) else $finish;
            assert(iq_issue_full == 'b0) else $finish;
            assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
            issue_iq_push = 'b1;
            wait_clk();
            issue_iq_push = 'b0;
            eval();
            assert(iq_issue_data_valid == 'b0) else $finish;
            assert(iq_issue_empty == 'b0) else $finish;
        end

        assert(iq_issue_data_channel_enable == 'b0) else $finish;
        assert(iq_issue_full == 'b1) else $finish;
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        issue_iq_push = 'b1;
        eval();
        assert(iq_issue_issue_execute_fifo_full_add == 'b1) else $finish;
        issue_iq_data_valid = 'b1;
        eval();
        assert(iq_issue_issue_execute_fifo_full_add == 'b1) else $finish;
        issue_iq_data_valid = 'b0;
        eval();
        assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        issue_iq_push = 'b0;
        issue_alu_fifo_full[0] = 'b0;
        issue_alu_fifo_full[1] = 'b0;
        eval();

        for(i = 0;i < 8;i++) begin
            assert(iq_issue_data_valid == 'b11) else $finish;
            assert(iq_issue_empty == 'b0) else $finish;
            wait_clk();

            if(i == 0) begin
                assert(iq_issue_data_channel_enable == 'b11) else $finish;
            end
            else begin
                assert(iq_issue_data_channel_enable == 'b1111) else $finish;
            end

            assert(iq_issue_full == 'b0) else $finish;
            assert(iq_issue_issue_execute_fifo_full_add == 'b0) else $finish;
        end

        assert(iq_issue_data_valid == 'b0) else $finish;
        assert(iq_issue_empty == 'b1) else $finish;
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