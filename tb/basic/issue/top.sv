`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic stbuf_all_empty;
        
    logic[`PHY_REG_ID_WIDTH - 1:0] issue_phyf_id[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] phyf_issue_data[0:`READREG_WIDTH - 1][0:1];
    logic phyf_issue_data_valid[0:`READREG_WIDTH - 1][0:1];

    logic[`ADDR_WIDTH - 1:0] issue_stbuf_read_addr;
    logic[`SIZE_WIDTH - 1:0] issue_stbuf_read_size;
    logic issue_stbuf_rd;
    
    logic issue_csrf_issue_execute_fifo_full_add;
    logic issue_csrf_issue_queue_full_add;
    
    readreg_issue_pack_t readreg_issue_port_data_out;
    
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_full;
    issue_execute_pack_t issue_alu_fifo_data_in[0:`ALU_UNIT_NUM - 1];
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_push;
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_flush;
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_full;
    issue_execute_pack_t issue_bru_fifo_data_in[0:`BRU_UNIT_NUM - 1];
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_push;
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_flush;
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_full;
    issue_execute_pack_t issue_csr_fifo_data_in[0:`CSR_UNIT_NUM - 1];
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_push;
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_flush;
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_full;
    issue_execute_pack_t issue_div_fifo_data_in[0:`DIV_UNIT_NUM - 1];
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_push;
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_flush;
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_full;
    issue_execute_pack_t issue_lsu_fifo_data_in[0:`LSU_UNIT_NUM - 1];
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_push;
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_flush;
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_full;
    issue_execute_pack_t issue_mul_fifo_data_in[0:`MUL_UNIT_NUM - 1];
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_push;
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_flush;
    
    issue_feedback_pack_t issue_feedback_pack;
    execute_feedback_pack_t execute_feedback_pack;
    wb_feedback_pack_t wb_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    integer i, j, k;

    issue issue_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task clear_input;
        //two ready alu instruction test
        for(i = 0;i < `READREG_WIDTH;i++) begin
            readreg_issue_port_data_out.op_info[i].enable = 'b0;
            readreg_issue_port_data_out.op_info[i].value = 'b0;
            readreg_issue_port_data_out.op_info[i].valid = 'b0;
            readreg_issue_port_data_out.op_info[i].rob_id = 'b0;
            readreg_issue_port_data_out.op_info[i].pc = 'b0;
            readreg_issue_port_data_out.op_info[i].imm = 'b0;
            readreg_issue_port_data_out.op_info[i].has_exception = 'b0;
            readreg_issue_port_data_out.op_info[i].exception_id = riscv_exception_t::instruction_address_misaligned;
            readreg_issue_port_data_out.op_info[i].exception_value = 'b0;
            readreg_issue_port_data_out.op_info[i].predicted = 'b0;
            readreg_issue_port_data_out.op_info[i].predicted_jump = 'b0;
            readreg_issue_port_data_out.op_info[i].predicted_next_pc = 'b0;
            readreg_issue_port_data_out.op_info[i].checkpoint_id_valid = 'b0;
            readreg_issue_port_data_out.op_info[i].checkpoint_id = 'b0;
            readreg_issue_port_data_out.op_info[i].rs1 = 'b0;
            readreg_issue_port_data_out.op_info[i].arg1_src = arg_src_t::_reg;
            readreg_issue_port_data_out.op_info[i].rs1_need_map = 'b0;
            readreg_issue_port_data_out.op_info[i].rs1_phy = 'b0;
            readreg_issue_port_data_out.op_info[i].src1_value = 'b0;
            readreg_issue_port_data_out.op_info[i].src1_loaded = 'b0;
            readreg_issue_port_data_out.op_info[i].rs2 = 'b0;
            readreg_issue_port_data_out.op_info[i].arg2_src = arg_src_t::_reg;
            readreg_issue_port_data_out.op_info[i].rs2_need_map = 'b0;
            readreg_issue_port_data_out.op_info[i].rs2_phy = 'b0;
            readreg_issue_port_data_out.op_info[i].src2_value = 'b0;
            readreg_issue_port_data_out.op_info[i].src2_loaded = 'b0;
            readreg_issue_port_data_out.op_info[i].rd = 'b0;
            readreg_issue_port_data_out.op_info[i].rd_enable = 'b0;
            readreg_issue_port_data_out.op_info[i].need_rename = 'b0;
            readreg_issue_port_data_out.op_info[i].rd_phy = 'b0;
            readreg_issue_port_data_out.op_info[i].csr = 'b0;
            readreg_issue_port_data_out.op_info[i].op = op_t::add;
            readreg_issue_port_data_out.op_info[i].op_unit = op_unit_t::alu;
            readreg_issue_port_data_out.op_info[i].sub_op.alu_op = alu_op_t::add;
        end
    endtask

    task test;
        rst = 1;
        stbuf_all_empty = 'b0;

        for(i = 0;i < `READREG_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                phyf_issue_data[i][j] = 'b0;
                phyf_issue_data_valid[i][j] = 'b0;
            end
        end

        clear_input();
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
        assert(issue_stbuf_rd == 'b0) else $finish;
        assert(issue_csrf_issue_execute_fifo_full_add == 'b0) else $finish;
        assert(issue_csrf_issue_queue_full_add == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;
        assert(issue_feedback_pack.stall == 'b0) else $finish;

        //flush test
        commit_feedback_pack.enable = 'b1;
        commit_feedback_pack.flush = 'b1;
        eval();
        assert(issue_alu_fifo_flush == '1) else $finish;
        assert(issue_bru_fifo_flush == '1) else $finish;
        assert(issue_csr_fifo_flush == '1) else $finish;
        assert(issue_div_fifo_flush == '1) else $finish;
        assert(issue_lsu_fifo_flush == '1) else $finish;
        assert(issue_mul_fifo_flush == '1) else $finish;
        commit_feedback_pack.enable = 'b0;
        eval();
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;
        commit_feedback_pack.flush = 'b0;
        eval();

        //two alu op test
        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            readreg_issue_port_data_out.op_info[i].enable = 'b1;
            readreg_issue_port_data_out.op_info[i].valid = 'b1;
            readreg_issue_port_data_out.op_info[i].pc = unsigned'('h15744456 + i);
            readreg_issue_port_data_out.op_info[i].op_unit = op_unit_t::alu;
            readreg_issue_port_data_out.op_info[i].src1_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src1_value = unsigned'('h123acced + i);
            readreg_issue_port_data_out.op_info[i].src2_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src2_value = unsigned'('h45617e4f + i);
        end

        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b11) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            assert(issue_alu_fifo_data_in[i].enable == 'b1) else $finish;
            assert(issue_alu_fifo_data_in[i].valid == 'b1) else $finish;
            assert(issue_alu_fifo_data_in[i].pc == readreg_issue_port_data_out.op_info[i].pc) else $finish;
            assert(issue_alu_fifo_data_in[i].op_unit == op_unit_t::alu) else $finish;
            assert(issue_alu_fifo_data_in[i].src1_loaded == 'b1) else $finish;
            assert(issue_alu_fifo_data_in[i].src1_value == readreg_issue_port_data_out.op_info[i].src1_value) else $finish;
            assert(issue_alu_fifo_data_in[i].src2_loaded == 'b1) else $finish;
            assert(issue_alu_fifo_data_in[i].src2_value == readreg_issue_port_data_out.op_info[i].src2_value) else $finish;
        end

        clear_input();
        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

        //one bru op test
        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            readreg_issue_port_data_out.op_info[i].enable = 'b1;
            readreg_issue_port_data_out.op_info[i].valid = 'b1;
            readreg_issue_port_data_out.op_info[i].pc = unsigned'('h15744456 + i);
            readreg_issue_port_data_out.op_info[i].op_unit = op_unit_t::bru;
            readreg_issue_port_data_out.op_info[i].src1_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src1_value = unsigned'('h123acced + i);
            readreg_issue_port_data_out.op_info[i].src2_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src2_value = unsigned'('h45617e4f + i);
        end

        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b1) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

         for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            assert(issue_bru_fifo_data_in[i].enable == 'b1) else $finish;
            assert(issue_bru_fifo_data_in[i].valid == 'b1) else $finish;
            assert(issue_bru_fifo_data_in[i].pc == readreg_issue_port_data_out.op_info[i].pc) else $finish;
            assert(issue_bru_fifo_data_in[i].op_unit == op_unit_t::bru) else $finish;
            assert(issue_bru_fifo_data_in[i].src1_loaded == 'b1) else $finish;
            assert(issue_bru_fifo_data_in[i].src1_value == readreg_issue_port_data_out.op_info[i].src1_value) else $finish;
            assert(issue_bru_fifo_data_in[i].src2_loaded == 'b1) else $finish;
            assert(issue_bru_fifo_data_in[i].src2_value == readreg_issue_port_data_out.op_info[i].src2_value) else $finish;
        end
        
        clear_input();
        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

        //one csr op test
        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            readreg_issue_port_data_out.op_info[i].enable = 'b1;
            readreg_issue_port_data_out.op_info[i].valid = 'b1;
            readreg_issue_port_data_out.op_info[i].pc = unsigned'('h15744456 + i);
            readreg_issue_port_data_out.op_info[i].op_unit = op_unit_t::csr;
            readreg_issue_port_data_out.op_info[i].src1_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src1_value = unsigned'('h123acced + i);
            readreg_issue_port_data_out.op_info[i].src2_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src2_value = unsigned'('h45617e4f + i);
        end

        commit_feedback_pack.next_handle_rob_id_valid = 'b1;
        commit_feedback_pack.next_handle_rob_id = 'b0;
        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b1) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

         for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            assert(issue_csr_fifo_data_in[i].enable == 'b1) else $finish;
            assert(issue_csr_fifo_data_in[i].valid == 'b1) else $finish;
            assert(issue_csr_fifo_data_in[i].pc == readreg_issue_port_data_out.op_info[i].pc) else $finish;
            assert(issue_csr_fifo_data_in[i].op_unit == op_unit_t::csr) else $finish;
            assert(issue_csr_fifo_data_in[i].src1_loaded == 'b1) else $finish;
            assert(issue_csr_fifo_data_in[i].src1_value == readreg_issue_port_data_out.op_info[i].src1_value) else $finish;
            assert(issue_csr_fifo_data_in[i].src2_loaded == 'b1) else $finish;
            assert(issue_csr_fifo_data_in[i].src2_value == readreg_issue_port_data_out.op_info[i].src2_value) else $finish;
        end
        
        clear_input();
        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

        //clear csr waiting state
        rst = 1;
        wait_clk();
        rst = 0;

        //one div op test
        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            readreg_issue_port_data_out.op_info[i].enable = 'b1;
            readreg_issue_port_data_out.op_info[i].valid = 'b1;
            readreg_issue_port_data_out.op_info[i].pc = unsigned'('h15744456 + i);
            readreg_issue_port_data_out.op_info[i].op_unit = op_unit_t::div;
            readreg_issue_port_data_out.op_info[i].src1_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src1_value = unsigned'('h123acced + i);
            readreg_issue_port_data_out.op_info[i].src2_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src2_value = unsigned'('h45617e4f + i);
        end

        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b1) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

         for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            assert(issue_div_fifo_data_in[i].enable == 'b1) else $finish;
            assert(issue_div_fifo_data_in[i].valid == 'b1) else $finish;
            assert(issue_div_fifo_data_in[i].pc == readreg_issue_port_data_out.op_info[i].pc) else $finish;
            assert(issue_div_fifo_data_in[i].op_unit == op_unit_t::div) else $finish;
            assert(issue_div_fifo_data_in[i].src1_loaded == 'b1) else $finish;
            assert(issue_div_fifo_data_in[i].src1_value == readreg_issue_port_data_out.op_info[i].src1_value) else $finish;
            assert(issue_div_fifo_data_in[i].src2_loaded == 'b1) else $finish;
            assert(issue_div_fifo_data_in[i].src2_value == readreg_issue_port_data_out.op_info[i].src2_value) else $finish;
        end
        
        clear_input();
        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

        //one lsu op test
        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            readreg_issue_port_data_out.op_info[i].enable = 'b1;
            readreg_issue_port_data_out.op_info[i].valid = 'b1;
            readreg_issue_port_data_out.op_info[i].pc = unsigned'('h15744456 + i);
            readreg_issue_port_data_out.op_info[i].op_unit = op_unit_t::lsu;
            readreg_issue_port_data_out.op_info[i].src1_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src1_value = unsigned'('h123acced + i);
            readreg_issue_port_data_out.op_info[i].src2_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src2_value = unsigned'('h45617e4f + i);
        end

        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b1) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            assert(issue_lsu_fifo_data_in[i].enable == 'b1) else $finish;
            assert(issue_lsu_fifo_data_in[i].valid == 'b1) else $finish;
            assert(issue_lsu_fifo_data_in[i].pc == readreg_issue_port_data_out.op_info[i].pc) else $finish;
            assert(issue_lsu_fifo_data_in[i].op_unit == op_unit_t::lsu) else $finish;
            assert(issue_lsu_fifo_data_in[i].src1_loaded == 'b1) else $finish;
            assert(issue_lsu_fifo_data_in[i].src1_value == readreg_issue_port_data_out.op_info[i].src1_value) else $finish;
            assert(issue_lsu_fifo_data_in[i].src2_loaded == 'b1) else $finish;
            assert(issue_lsu_fifo_data_in[i].src2_value == readreg_issue_port_data_out.op_info[i].src2_value) else $finish;
        end
        
        clear_input();
        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

        //one mul op test
        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            readreg_issue_port_data_out.op_info[i].enable = 'b1;
            readreg_issue_port_data_out.op_info[i].valid = 'b1;
            readreg_issue_port_data_out.op_info[i].pc = unsigned'('h15744456 + i);
            readreg_issue_port_data_out.op_info[i].op_unit = op_unit_t::mul;
            readreg_issue_port_data_out.op_info[i].src1_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src1_value = unsigned'('h123acced + i);
            readreg_issue_port_data_out.op_info[i].src2_loaded = 'b1;
            readreg_issue_port_data_out.op_info[i].src2_value = unsigned'('h45617e4f + i);
        end

        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b11) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            assert(issue_mul_fifo_data_in[i].enable == 'b1) else $finish;
            assert(issue_mul_fifo_data_in[i].valid == 'b1) else $finish;
            assert(issue_mul_fifo_data_in[i].pc == readreg_issue_port_data_out.op_info[i].pc) else $finish;
            assert(issue_mul_fifo_data_in[i].op_unit == op_unit_t::mul) else $finish;
            assert(issue_mul_fifo_data_in[i].src1_loaded == 'b1) else $finish;
            assert(issue_mul_fifo_data_in[i].src1_value == readreg_issue_port_data_out.op_info[i].src1_value) else $finish;
            assert(issue_mul_fifo_data_in[i].src2_loaded == 'b1) else $finish;
            assert(issue_mul_fifo_data_in[i].src2_value == readreg_issue_port_data_out.op_info[i].src2_value) else $finish;
        end
        
        clear_input();
        wait_clk();
        assert(issue_feedback_pack.stall == 'b0) else $finish;
        assert(issue_alu_fifo_push == 'b0) else $finish;
        assert(issue_bru_fifo_push == 'b0) else $finish;
        assert(issue_csr_fifo_push == 'b0) else $finish;
        assert(issue_div_fifo_push == 'b0) else $finish;
        assert(issue_lsu_fifo_push == 'b0) else $finish;
        assert(issue_mul_fifo_push == 'b0) else $finish;
        assert(issue_alu_fifo_flush == 'b0) else $finish;
        assert(issue_bru_fifo_flush == 'b0) else $finish;
        assert(issue_csr_fifo_flush == 'b0) else $finish;
        assert(issue_div_fifo_flush == 'b0) else $finish;
        assert(issue_lsu_fifo_flush == 'b0) else $finish;
        assert(issue_mul_fifo_flush == 'b0) else $finish;

        //round-robin test
        rst = 1;
        wait_clk();
        rst = 0;

        readreg_issue_port_data_out.op_info[0].enable = 'b1;
        readreg_issue_port_data_out.op_info[0].valid = 'b1;
        readreg_issue_port_data_out.op_info[0].pc = unsigned'('h15744456);
        readreg_issue_port_data_out.op_info[0].op_unit = op_unit_t::alu;
        readreg_issue_port_data_out.op_info[0].src1_loaded = 'b1;
        readreg_issue_port_data_out.op_info[0].src1_value = unsigned'('h123acced);
        readreg_issue_port_data_out.op_info[0].src2_loaded = 'b1;
        readreg_issue_port_data_out.op_info[0].src2_value = unsigned'('h45617e4f);
        wait_clk();
        assert(issue_alu_fifo_push == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].enable == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].valid == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].pc == readreg_issue_port_data_out.op_info[0].pc) else $finish;
        assert(issue_alu_fifo_data_in[0].op_unit == op_unit_t::alu) else $finish;
        assert(issue_alu_fifo_data_in[0].src1_loaded == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].src1_value == readreg_issue_port_data_out.op_info[0].src1_value) else $finish;
        assert(issue_alu_fifo_data_in[0].src2_loaded == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].src2_value == readreg_issue_port_data_out.op_info[0].src2_value) else $finish;

        issue_alu_fifo_full = 'b1;
        eval();
        assert(issue_alu_fifo_push == 'b10) else $finish;
        assert(issue_alu_fifo_data_in[1].enable == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[1].valid == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[1].pc == readreg_issue_port_data_out.op_info[0].pc) else $finish;
        assert(issue_alu_fifo_data_in[1].op_unit == op_unit_t::alu) else $finish;
        assert(issue_alu_fifo_data_in[1].src1_loaded == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[1].src1_value == readreg_issue_port_data_out.op_info[0].src1_value) else $finish;
        assert(issue_alu_fifo_data_in[1].src2_loaded == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[1].src2_value == readreg_issue_port_data_out.op_info[0].src2_value) else $finish;

        issue_alu_fifo_full = 'b0;
        wait_clk();
        assert(issue_alu_fifo_push == 'b10) else $finish;
        assert(issue_alu_fifo_data_in[1].enable == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[1].valid == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[1].pc == readreg_issue_port_data_out.op_info[0].pc) else $finish;
        assert(issue_alu_fifo_data_in[1].op_unit == op_unit_t::alu) else $finish;
        assert(issue_alu_fifo_data_in[1].src1_loaded == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[1].src1_value == readreg_issue_port_data_out.op_info[0].src1_value) else $finish;
        assert(issue_alu_fifo_data_in[1].src2_loaded == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[1].src2_value == readreg_issue_port_data_out.op_info[0].src2_value) else $finish;
        issue_alu_fifo_full = 'b10;
        eval();
        assert(issue_alu_fifo_push == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].enable == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].valid == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].pc == readreg_issue_port_data_out.op_info[0].pc) else $finish;
        assert(issue_alu_fifo_data_in[0].op_unit == op_unit_t::alu) else $finish;
        assert(issue_alu_fifo_data_in[0].src1_loaded == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].src1_value == readreg_issue_port_data_out.op_info[0].src1_value) else $finish;
        assert(issue_alu_fifo_data_in[0].src2_loaded == 'b1) else $finish;
        assert(issue_alu_fifo_data_in[0].src2_value == readreg_issue_port_data_out.op_info[0].src2_value) else $finish;
    
        //feedback test
        rst = 1;
        wait_clk();
        rst = 0;
        
        clear_input();
        readreg_issue_port_data_out.op_info[0].enable = 'b1;
        readreg_issue_port_data_out.op_info[0].valid = 'b1;
        readreg_issue_port_data_out.op_info[0].pc = unsigned'('h15744456);
        readreg_issue_port_data_out.op_info[0].op_unit = op_unit_t::alu;
        readreg_issue_port_data_out.op_info[0].src1_loaded = 'b0;
        readreg_issue_port_data_out.op_info[0].src1_value = unsigned'('h123acced);
        readreg_issue_port_data_out.op_info[0].rs1_phy = 'd5;
        readreg_issue_port_data_out.op_info[0].src2_loaded = 'b0;
        readreg_issue_port_data_out.op_info[0].src2_value = unsigned'('h45617e4f);
        readreg_issue_port_data_out.op_info[0].rs2_phy = 'd6;
        eval();
        assert(issue_inst.issue_iq_data[0].src1_loaded == 'b0) else $finish;
        assert(issue_phyf_id[0][0] == 'd5) else $finish;
        phyf_issue_data[0][0] = 'h18cde7de;
        eval();
        assert(issue_inst.issue_iq_data[0].src1_loaded == 'b0) else $finish;
        phyf_issue_data_valid[0][0] = 'b1;
        eval();
        assert(issue_inst.issue_iq_data[0].src1_loaded == 'b1) else $finish;
        assert(issue_inst.issue_iq_data[0].src1_value == 'h18cde7de) else $finish;
        phyf_issue_data_valid[0][0] = 'b0;

        execute_feedback_pack.channel[7].phy_id = 'd5;
        eval();
        assert(issue_inst.issue_iq_data[0].src1_loaded == 'b0) else $finish;
        execute_feedback_pack.channel[7].value = 'h1dedc81d;
        execute_feedback_pack.channel[7].enable = 'b1;
        eval();
        assert(issue_inst.issue_iq_data[0].src1_loaded == 'b1) else $finish;
        assert(issue_inst.issue_iq_data[0].src1_value == 'h1dedc81d) else $finish;
        execute_feedback_pack.channel[7].enable = 'b0;

        wb_feedback_pack.channel[0].phy_id = 'd5;
        eval();
        assert(issue_inst.issue_iq_data[0].src1_loaded == 'b0) else $finish;
        wb_feedback_pack.channel[0].value = 'hd2e5ccae;
        wb_feedback_pack.channel[0].enable = 'b1;
        eval();
        assert(issue_inst.issue_iq_data[0].src1_loaded == 'b1) else $finish;
        assert(issue_inst.issue_iq_data[0].src1_value == 'hd2e5ccae) else $finish;
        wb_feedback_pack.channel[0].enable = 'b0;

        wb_feedback_pack.channel[0].phy_id = 'd6;
        eval();
        assert(issue_inst.issue_iq_data[0].src2_loaded == 'b0) else $finish;
        wb_feedback_pack.channel[0].value = 'hd2e5ccaf;
        wb_feedback_pack.channel[0].enable = 'b1;
        eval();
        assert(issue_inst.issue_iq_data[0].src2_loaded == 'b1) else $finish;
        assert(issue_inst.issue_iq_data[0].src2_value == 'hd2e5ccaf) else $finish;
        wb_feedback_pack.channel[0].enable = 'b0;
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