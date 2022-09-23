`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] rename_cpbuf_id[0:`RENAME_WIDTH - 1];
    checkpoint_t rename_cpbuf_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_cpbuf_we;
    checkpoint_t cpbuf_rename_data[0:`RENAME_WIDTH - 1];
    
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_new_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rat_rename_new_phy_id_valid;
    logic[`PHY_REG_ID_WIDTH - 1:0] rename_rat_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rat_phy_id_valid;
    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_arch_id[0:`RENAME_WIDTH - 1];
    logic rename_rat_map;
    
    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_valid;
    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_visible;
    
    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_read_arch_id[0:`RENAME_WIDTH - 1][0:2];
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_read_phy_id[0:`RENAME_WIDTH - 1][0:2];
    
    logic[`ROB_ID_WIDTH - 1:0] rob_rename_new_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rob_rename_new_id_valid;
    
    rob_item_t rename_rob_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rob_data_valid;
    logic rename_rob_push;
    
    logic rename_csrf_phy_regfile_full_add;
    logic rename_csrf_rob_full_add;
    
    decode_rename_pack_t decode_rename_fifo_data_out[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] decode_rename_fifo_data_out_valid;
    logic[`RENAME_WIDTH - 1:0] decode_rename_fifo_data_pop_valid;
    logic decode_rename_fifo_pop;
    
    rename_readreg_pack_t rename_readreg_port_data_in;
    logic rename_readreg_port_we;
    logic rename_readreg_port_flush;
    
    rename_feedback_pack_t rename_feedback_pack;
    issue_feedback_pack_t issue_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    checkpoint_t cp;
    decode_rename_pack_t t_pack;

    integer i, j;

    rename rename_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        cp.rat_phy_map_table_valid = 'b0;
        cp.rat_phy_map_table_visible = 'b0;
        cp.global_history = 'b0;
        cp.local_history = 'b0;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            cpbuf_rename_data[i] = cp;
            rat_rename_new_phy_id[i] = 'b0;
            rat_rename_new_phy_id_valid = 'b0;
        end

        rat_rename_map_table_valid = 'b0;
        rat_rename_map_table_visible = 'b0;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            for(j = 0;j < 3;j++) begin
                rat_rename_read_phy_id[i][j] = 'b0;
            end

            rob_rename_new_id[i] = 'b0;
        end

        rob_rename_new_id_valid = 'b0;

        t_pack.enable = 'b0;
        t_pack.value = 'b0;
        t_pack.valid = 'b0;
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
        t_pack.rs2 = 'b0;
        t_pack.arg2_src = arg_src_t::_reg;
        t_pack.rs2_need_map = 'b0;
        t_pack.rd = 'b0;
        t_pack.rd_enable = 'b0;
        t_pack.need_rename = 'b0;
        t_pack.csr = 'b0;
        t_pack.op = op_t::add;
        t_pack.op_unit = op_unit_t::alu;
        t_pack.sub_op.alu_op = alu_op_t::add;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            decode_rename_fifo_data_out[i] = t_pack;
        end

        decode_rename_fifo_data_out_valid = 'b0;
        issue_feedback_pack.stall = 'b0;
        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.flush = 'b0;
        wait_clk();
        rst = 0;
        assert(rename_cpbuf_we == 'b0) else $finish;
        assert(rename_rat_phy_id_valid == 'b0) else $finish;
        assert(rename_rat_map == 'b1) else $finish;
        assert(rename_rob_data_valid == 'b0) else $finish;
        assert(rename_rob_push == 'b1) else $finish;
        assert(rename_csrf_phy_regfile_full_add == 'b0) else $finish;
        assert(rename_csrf_rob_full_add == 'b0) else $finish;
        assert(decode_rename_fifo_data_pop_valid == 'b0) else $finish;
        assert(decode_rename_fifo_pop == 'b1) else $finish;
        assert(rename_readreg_port_we == 'b1) else $finish;
        assert(rename_readreg_port_flush == 'b0) else $finish;
        assert(rename_feedback_pack.idle == 'b1) else $finish;
        decode_rename_fifo_data_out_valid = 'b1111;
        t_pack.enable = 'b1;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            decode_rename_fifo_data_out[i] = t_pack;
        end

        eval();
        assert(decode_rename_fifo_data_pop_valid == 'b0) else $finish;
        rat_rename_new_phy_id_valid = 'b1;
        assert(rename_csrf_phy_regfile_full_add == 'b0) else $finish;
        assert(rename_csrf_rob_full_add == 'b1) else $finish;
        eval();
        assert(decode_rename_fifo_data_pop_valid == 'b0) else $finish;
        assert(rename_csrf_phy_regfile_full_add == 'b0) else $finish;
        assert(rename_csrf_rob_full_add == 'b1) else $finish;
        rob_rename_new_id_valid = 'b1;
        eval();
        assert(decode_rename_fifo_data_pop_valid == 'b1) else $finish;
        assert(rename_csrf_phy_regfile_full_add == 'b0) else $finish;
        assert(rename_csrf_rob_full_add == 'b1) else $finish;
        rat_rename_new_phy_id_valid = 'b0;
        eval();
        assert(decode_rename_fifo_data_pop_valid == 'b1) else $finish;
        assert(rename_csrf_phy_regfile_full_add == 'b0) else $finish;
        assert(rename_csrf_rob_full_add == 'b1) else $finish;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rat_rename_new_phy_id_valid[i] = 'b1;
            rat_rename_new_phy_id[i] = unsigned'('d10 + i);
            rob_rename_new_id_valid[i] = 'b1;
            rob_rename_new_id[i] = unsigned'('d5 + i);
        end

        eval();
        assert(decode_rename_fifo_data_pop_valid == 'b1111) else $finish;
        assert(rename_csrf_phy_regfile_full_add == 'b0) else $finish;
        assert(rename_csrf_rob_full_add == 'b0) else $finish;
        
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(rename_readreg_port_data_in.op_info[i].enable == 'b1) else $finish;
            assert(rename_readreg_port_data_in.op_info[i].rob_id == unsigned'(5 + i)) else $finish;
        end

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            decode_rename_fifo_data_out[i].valid = 'b1;
            decode_rename_fifo_data_out[i].rd = unsigned'(1 + i);
            decode_rename_fifo_data_out[i].need_rename = 'b1;
            decode_rename_fifo_data_out[i].rd_enable = 'b1;
            decode_rename_fifo_data_out[i].rs1 = unsigned'(10 + i);
            decode_rename_fifo_data_out[i].rs1_need_map = 'b1;
            decode_rename_fifo_data_out[i].rs2 = unsigned'(20 + i);
            decode_rename_fifo_data_out[i].rs2_need_map = 'b1;
        end

        rat_rename_map_table_valid = 'b1111111;//0-6
        rat_rename_map_table_visible = 'b1111111;//0-6
        rat_rename_new_phy_id_valid = 'b0;
        eval();
        assert(decode_rename_fifo_data_pop_valid == 'b0) else $finish;
        assert(rename_csrf_phy_regfile_full_add == 'b1) else $finish;
        assert(rename_csrf_rob_full_add == 'b0) else $finish;
        eval();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rat_rename_new_phy_id_valid[i] = 'b1;
            rat_rename_new_phy_id[i] = unsigned'('d10 + i);
        end

        eval();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(rename_rat_read_arch_id[i][0] == unsigned'(10 + i)) else $finish;
            rat_rename_read_phy_id[i][0] = unsigned'(11 + i);
            assert(rename_rat_read_arch_id[i][1] == unsigned'(20 + i)) else $finish;
            rat_rename_read_phy_id[i][1] = unsigned'(21 + i);
            assert(rename_rat_read_arch_id[i][2] == unsigned'(1 + i)) else $finish;
            rat_rename_read_phy_id[i][2] = unsigned'(1 + i);
        end

        eval();
        assert(decode_rename_fifo_data_pop_valid == 'b1111) else $finish;
        assert(rename_rob_push == 'b1) else $finish;
        assert(rename_rat_map == 'b1) else $finish;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(rename_readreg_port_data_in.op_info[i].enable == 'b1) else $finish;
            assert(rename_readreg_port_data_in.op_info[i].rob_id == unsigned'(5 + i)) else $finish;
            assert(rename_readreg_port_data_in.op_info[i].rd_phy == unsigned'(10 + i)) else $finish;
            assert(rename_readreg_port_data_in.op_info[i].rs1_phy == unsigned'(11 + i)) else $finish;
            assert(rename_readreg_port_data_in.op_info[i].rs2_phy == unsigned'(21 + i)) else $finish;
            assert(rename_rob_data[i].old_phy_reg_id == unsigned'(1 + i)) else $finish;
            assert(rename_rob_data_valid[i] == 'b1) else $finish;
            assert(rename_cpbuf_we[i] == 'b0) else $finish;
            decode_rename_fifo_data_out[i].checkpoint_id_valid = 'b1;
            eval();
            assert(rename_cpbuf_we[i] == 'b1) else $finish;
            assert(rename_rat_phy_id[i] == rename_readreg_port_data_in.op_info[i].rd_phy) else $finish;
            assert(rename_rat_arch_id[i] == rename_readreg_port_data_in.op_info[i].rd) else $finish;
            assert(rename_rat_phy_id_valid[i] == 'b1) else $finish;

            if(i == 0) begin
                for(j = 0;j < `PHY_REG_NUM;j++) begin
                    if(j == unsigned'(10 + i)) begin//new phy id
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == 'b1) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == 'b1) else $finish;
                    end
                    else if(j == rename_rob_data[i].old_phy_reg_id) begin//old phy id
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == 'b1) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == 'b0) else $finish;
                    end
                    else begin
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == rat_rename_map_table_valid[j]) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == rat_rename_map_table_visible[j]) else $finish;
                    end
                end
            end
            else begin
                for(j = 0;j < `PHY_REG_NUM;j++) begin
                    if(j == unsigned'(10 + i)) begin//new phy id
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == 'b1) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == 'b1) else $finish;
                    end
                    else if(j == unsigned'(1 + i)) begin//old phy id
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == 'b1) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == 'b0) else $finish;
                    end
                    else begin
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == rename_cpbuf_data[i - 1].rat_phy_map_table_valid[j]) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == rename_cpbuf_data[i - 1].rat_phy_map_table_visible[j]) else $finish;
                    end
                end
            end
        end

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            decode_rename_fifo_data_out[i].pc = unsigned'('h80000000 + i);
            decode_rename_fifo_data_out[i].value = unsigned'('hdeadbeef + i);
            decode_rename_fifo_data_out[i].has_exception = i & 1;
            decode_rename_fifo_data_out[i].exception_value = unsigned'('haabbccdd + i);
            decode_rename_fifo_data_out[i].csr = unsigned'('h123 + i);
            decode_rename_fifo_data_out[i].rd = 'b1;
            decode_rename_fifo_data_out[i].rs1 = 'b1;
            decode_rename_fifo_data_out[i].rs2 = 'b1;
            decode_rename_fifo_data_out[i].checkpoint_id = unsigned'(2 + i);
            cpbuf_rename_data[i].global_history = unsigned'('h123 + i);
            cpbuf_rename_data[i].local_history = unsigned'('h456 + i);
        end

        eval();

        assert(decode_rename_fifo_data_pop_valid == 'b1111) else $finish;
        assert(rename_rob_push == 'b1) else $finish;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(rename_readreg_port_data_in.op_info[i].enable == 'b1) else $finish;
            assert(rename_readreg_port_data_in.op_info[i].rob_id == unsigned'(5 + i)) else $finish;
            assert(rename_readreg_port_data_in.op_info[i].rd_phy == unsigned'(10 + i)) else $finish;
            assert(rename_rob_data_valid[i] == 'b1) else $finish;
            assert(rename_cpbuf_we[i] == 'b1) else $finish;
            assert(rename_cpbuf_id[i] == unsigned'(2 + i)) else $finish;
            assert(rename_cpbuf_data[i].global_history == cpbuf_rename_data[i].global_history) else $finish;
            assert(rename_cpbuf_data[i].local_history == cpbuf_rename_data[i].local_history) else $finish;
            assert(rename_rob_data[i].new_phy_reg_id == rename_readreg_port_data_in.op_info[i].rd_phy) else $finish;
            assert(rename_rob_data[i].finish == 'b0) else $finish;
            assert(rename_rob_data[i].pc == rename_readreg_port_data_in.op_info[i].pc) else $finish;
            assert(rename_rob_data[i].inst_value == rename_readreg_port_data_in.op_info[i].value) else $finish;
            assert(rename_rob_data[i].has_exception == rename_readreg_port_data_in.op_info[i].has_exception) else $finish;
            assert(rename_rob_data[i].exception_id == rename_readreg_port_data_in.op_info[i].exception_id) else $finish;
            assert(rename_rob_data[i].exception_value == rename_readreg_port_data_in.op_info[i].exception_value) else $finish;
            assert(rename_rob_data[i].predicted == 'b0) else $finish;
            assert(rename_rob_data[i].predicted_jump == 'b0) else $finish;
            assert(rename_rob_data[i].predicted_next_pc == 'b0) else $finish;
            assert(rename_rob_data[i].checkpoint_id_valid == 'b0) else $finish;
            assert(rename_rob_data[i].checkpoint_id == 'b0) else $finish;
            assert(rename_rob_data[i].bru_op == 'b0) else $finish;
            assert(rename_rob_data[i].bru_jump == 'b0) else $finish;
            assert(rename_rob_data[i].bru_next_pc == 'b0) else $finish;
            assert(rename_rob_data[i].is_mret == 'b0) else $finish;
            assert(rename_rob_data[i].csr_addr == rename_readreg_port_data_in.op_info[i].csr) else $finish;
            assert(rename_rob_data[i].csr_newvalue == 'b0) else $finish;
            assert(rename_rob_data[i].csr_newvalue_valid == 'b0) else $finish;

            if(i == 0) begin
                assert(rename_rob_data[i].old_phy_reg_id == unsigned'(1 + i)) else $finish;
                assert(rename_readreg_port_data_in.op_info[i].rs1_phy == unsigned'(11)) else $finish;
                assert(rename_readreg_port_data_in.op_info[i].rs2_phy == unsigned'(21)) else $finish;

                for(j = 0;j < `PHY_REG_NUM;j++) begin
                    if(j == unsigned'(10 + i)) begin//new phy id
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == 'b1) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == 'b1) else $finish;
                    end
                    else if(j == rename_rob_data[i].old_phy_reg_id) begin//old phy id
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == 'b1) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == 'b0) else $finish;
                    end
                    else begin
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == rat_rename_map_table_valid[j]) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == rat_rename_map_table_visible[j]) else $finish;
                    end
                end
            end
            else begin
                assert(rename_rob_data[i].old_phy_reg_id == rename_readreg_port_data_in.op_info[i - 1].rd_phy) else $finish;
                assert(rename_readreg_port_data_in.op_info[i].rs1_phy == rename_readreg_port_data_in.op_info[i - 1].rd_phy) else $finish;
                assert(rename_readreg_port_data_in.op_info[i].rs2_phy == rename_readreg_port_data_in.op_info[i - 1].rd_phy) else $finish;

                for(j = 0;j < `PHY_REG_NUM;j++) begin
                    if(j == unsigned'(10 + i)) begin//new phy id
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == 'b1) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == 'b1) else $finish;
                    end
                    else if(j == rename_rob_data[i].old_phy_reg_id) begin//old phy id
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == 'b1) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == 'b0) else $finish;
                    end
                    else begin
                        assert(rename_cpbuf_data[i].rat_phy_map_table_valid[j] == rename_cpbuf_data[i - 1].rat_phy_map_table_valid[j]) else $finish;
                        assert(rename_cpbuf_data[i].rat_phy_map_table_visible[j] == rename_cpbuf_data[i - 1].rat_phy_map_table_visible[j]) else $finish;
                    end
                end
            end
        end

        issue_feedback_pack.stall = 'b1;
        eval();
        assert(rename_readreg_port_we == 'b0) else $finish;
        assert(rename_cpbuf_we == 'b0) else $finish;
        assert(rename_rat_map == 'b0) else $finish;
        assert(rename_rob_push == 'b0) else $finish;
        assert(decode_rename_fifo_pop == 'b0) else $finish;
        assert(rename_readreg_port_flush == 'b0) else $finish;
        issue_feedback_pack.stall = 'b0;
        commit_feedback_pack.enable = 'b1;
        commit_feedback_pack.flush = 'b1;
        eval();
        assert(rename_readreg_port_we == 'b1) else $finish;
        assert(rename_readreg_port_flush == 'b1) else $finish;
        assert(rename_cpbuf_we == 'b0) else $finish;
        assert(rename_rat_map == 'b0) else $finish;
        assert(rename_rob_push == 'b0) else $finish;
        assert(decode_rename_fifo_pop == 'b0) else $finish;
        assert(rename_readreg_port_flush == 'b1) else $finish;
        issue_feedback_pack.stall = 'b1;
        eval();
        assert(rename_readreg_port_we == 'b0) else $finish;
        assert(rename_readreg_port_flush == 'b1) else $finish;
        assert(rename_cpbuf_we == 'b0) else $finish;
        assert(rename_rat_map == 'b0) else $finish;
        assert(rename_rob_push == 'b0) else $finish;
        assert(decode_rename_fifo_pop == 'b0) else $finish;
        assert(rename_readreg_port_flush == 'b1) else $finish;
        assert(rename_feedback_pack.idle == 'b0) else $finish;
        decode_rename_fifo_data_out_valid = 'b0;
        eval();
        assert(rename_feedback_pack.idle == 'b1) else $finish;
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