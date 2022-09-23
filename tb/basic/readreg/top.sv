`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] readreg_phyf_id[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] phyf_readreg_data[0:`READREG_WIDTH - 1][0:1];
    logic phyf_readreg_data_valid[0:`READREG_WIDTH - 1][0:1];
    
    rename_readreg_pack_t rename_readreg_port_data_out;
    
    readreg_issue_pack_t readreg_issue_port_data_in;
    logic readreg_issue_port_we;
    logic readreg_issue_port_flush;
    
    issue_feedback_pack_t issue_feedback_pack;
    execute_feedback_pack_t execute_feedback_pack;
    wb_feedback_pack_t wb_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    rename_readreg_op_info_t t_pack;

    integer i, j, k;

    readreg readreg_inst(.*);

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
                phyf_readreg_data[i][j] = 'b0;
                phyf_readreg_data_valid[i][j] = 'b0;
            end
        end

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
        t_pack.rs2 = 'b0;
        t_pack.arg2_src = arg_src_t::_reg;
        t_pack.rs2_need_map = 'b0;
        t_pack.rs2_phy = 'b0;
        t_pack.rd = 'b0;
        t_pack.rd_enable = 'b0;
        t_pack.need_rename = 'b0;
        t_pack.rd_phy = 'b0;
        t_pack.op = op_t::add;
        t_pack.op_unit = op_unit_t::alu;
        t_pack.sub_op.alu_op = alu_op_t::add;
        rename_readreg_port_data_out.op_info[i] = t_pack;
        issue_feedback_pack.stall = 'b0;
        
        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            execute_feedback_pack.channel[i].enable = 'b0;
            execute_feedback_pack.channel[i].phy_id = 'b0;
            execute_feedback_pack.channel[i].value = 'b0;
        end

        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
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
        wait_clk();

        for(i = 0;i < `READREG_WIDTH;i++) begin
            t_pack.enable = 'b1;
            t_pack.valid = 'b1;
            t_pack.rs1_need_map = 'b1;
            t_pack.arg1_src = arg_src_t::_reg;
            t_pack.rs1_phy = unsigned'(i);
            t_pack.rs2_need_map = 'b1;
            t_pack.arg2_src = arg_src_t::_reg;
            t_pack.rs2_phy = unsigned'(i + `READREG_WIDTH);
            rename_readreg_port_data_out.op_info[i] = t_pack;
        end

        eval();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                assert(readreg_phyf_id[i][j] == unsigned'(i + j * `RENAME_WIDTH)) else $finish;
            end
        end
        
        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            execute_feedback_pack.channel[i].enable = 'b1;
            execute_feedback_pack.channel[i].phy_id = unsigned'(i);
            execute_feedback_pack.channel[i].value = 'hacde1285 + unsigned'(i);
            wb_feedback_pack.channel[i].enable = 'b1;
            wb_feedback_pack.channel[i].phy_id = unsigned'(`EXECUTE_UNIT_NUM + i);
            wb_feedback_pack.channel[i].value = 'h4a5cddef + unsigned'(`EXECUTE_UNIT_NUM + i);
        end

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                phyf_readreg_data[i][j] = readreg_phyf_id[i][j] + 'hcdea1574;
                phyf_readreg_data_valid[i][j] = 'b1;
            end
        end

        eval();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(readreg_issue_port_data_in.op_info[i].src1_loaded == 'b1) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src1_value == 'hcdea1574 + readreg_issue_port_data_in.op_info[i].rs1_phy) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src2_loaded == 'b1) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src2_value == 'hcdea1574 + readreg_issue_port_data_in.op_info[i].rs2_phy) else $finish;
        end

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                phyf_readreg_data_valid[i][j] = 'b0;
            end
        end

        eval();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(readreg_issue_port_data_in.op_info[i].src1_loaded == 'b1) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src1_value == 'hacde1285 + readreg_issue_port_data_in.op_info[i].rs1_phy) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src2_loaded == 'b1) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src2_value == 'hacde1285 + readreg_issue_port_data_in.op_info[i].rs2_phy) else $finish;
        end

        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            execute_feedback_pack.channel[i].enable = 'b0;
        end

        eval();
        
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(readreg_issue_port_data_in.op_info[i].src1_loaded == 'b0) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src2_loaded == 'b0) else $finish;
        end

        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            wb_feedback_pack.channel[i].enable = 'b1;
            wb_feedback_pack.channel[i].phy_id = unsigned'(i);
            wb_feedback_pack.channel[i].value = 'h4a5cddef + unsigned'(i);
        end

        eval();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(readreg_issue_port_data_in.op_info[i].src1_loaded == 'b1) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src1_value == 'h4a5cddef + readreg_issue_port_data_in.op_info[i].rs1_phy) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src2_loaded == 'b1) else $finish;
            assert(readreg_issue_port_data_in.op_info[i].src2_value == 'h4a5cddef + readreg_issue_port_data_in.op_info[i].rs2_phy) else $finish;
        end

        assert(readreg_issue_port_flush == 'b0) else $finish;
        assert(readreg_issue_port_we == 'b1) else $finish;
        commit_feedback_pack.enable = 'b1;
        eval();
        assert(readreg_issue_port_flush == 'b0) else $finish;
        assert(readreg_issue_port_we == 'b1) else $finish;
        commit_feedback_pack.flush = 'b1;
        eval();
        assert(readreg_issue_port_flush == 'b1) else $finish;
        assert(readreg_issue_port_we == 'b1) else $finish;
        issue_feedback_pack.stall = 'b1;
        eval();
        assert(readreg_issue_port_flush == 'b1) else $finish;
        assert(readreg_issue_port_we == 'b0) else $finish;
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