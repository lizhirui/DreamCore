`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] wb_phyf_id[0:`WB_WIDTH - 1];
    logic[`REG_DATA_WIDTH - 1:0] wb_phyf_data[0:`WB_WIDTH - 1];
    logic[`WB_WIDTH - 1:0] wb_phyf_we;
    
    execute_wb_pack_t alu_wb_port_data_out[0:`ALU_UNIT_NUM - 1];
    execute_wb_pack_t bru_wb_port_data_out[0:`BRU_UNIT_NUM - 1];
    execute_wb_pack_t csr_wb_port_data_out[0:`CSR_UNIT_NUM - 1];
    execute_wb_pack_t div_wb_port_data_out[0:`DIV_UNIT_NUM - 1];
    execute_wb_pack_t lsu_wb_port_data_out[0:`LSU_UNIT_NUM - 1];
    execute_wb_pack_t mul_wb_port_data_out[0:`MUL_UNIT_NUM - 1];
    
    wb_commit_pack_t wb_commit_port_data_in;
    logic wb_commit_port_we;
    logic wb_commit_port_flush;
    
    wb_feedback_pack_t wb_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    integer i;

    wb wb_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task test;
        rst = 1;

        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            alu_wb_port_data_out[i].enable = 'b1;
            alu_wb_port_data_out[i].valid = 'b1;
            alu_wb_port_data_out[i].has_exception = 'b0;
            alu_wb_port_data_out[i].rd_enable = 'b1;
            alu_wb_port_data_out[i].need_rename = 'b1;
            alu_wb_port_data_out[i].rd_phy = unsigned'(i);
            alu_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(i);
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            bru_wb_port_data_out[i].enable = 'b1;
            bru_wb_port_data_out[i].valid = 'b1;
            bru_wb_port_data_out[i].has_exception = 'b0;
            bru_wb_port_data_out[i].rd_enable = 'b1;
            bru_wb_port_data_out[i].need_rename = 'b1;
            bru_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + i);
            bru_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + i);
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            csr_wb_port_data_out[i].enable = 'b1;
            csr_wb_port_data_out[i].valid = 'b1;
            csr_wb_port_data_out[i].has_exception = 'b0;
            csr_wb_port_data_out[i].rd_enable = 'b1;
            csr_wb_port_data_out[i].need_rename = 'b1;
            csr_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + i);
            csr_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + i);
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            div_wb_port_data_out[i].enable = 'b1;
            div_wb_port_data_out[i].valid = 'b1;
            div_wb_port_data_out[i].has_exception = 'b0;
            div_wb_port_data_out[i].rd_enable = 'b1;
            div_wb_port_data_out[i].need_rename = 'b1;
            div_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + i);
            div_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + i);
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            lsu_wb_port_data_out[i].enable = 'b1;
            lsu_wb_port_data_out[i].valid = 'b1;
            lsu_wb_port_data_out[i].has_exception = 'b0;
            lsu_wb_port_data_out[i].rd_enable = 'b1;
            lsu_wb_port_data_out[i].need_rename = 'b1;
            lsu_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + i);
            lsu_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + i);
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            mul_wb_port_data_out[i].enable = 'b1;
            mul_wb_port_data_out[i].valid = 'b1;
            mul_wb_port_data_out[i].has_exception = 'b0;
            mul_wb_port_data_out[i].rd_enable = 'b1;
            mul_wb_port_data_out[i].need_rename = 'b1;
            mul_wb_port_data_out[i].rd_phy = unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + `LSU_UNIT_NUM + i);
            mul_wb_port_data_out[i].rd_value = 'h15263317 + unsigned'(`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + `LSU_UNIT_NUM + i);
        end

        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.flush = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();

        for(i = 0;i < `WB_WIDTH;i++) begin
            assert(wb_feedback_pack.channel[i].enable == 'b1) else $finish;
            assert(wb_feedback_pack.channel[i].phy_id == unsigned'(i)) else $finish;
            assert(wb_feedback_pack.channel[i].value == 'h15263317 + unsigned'(i)) else $finish;
            assert(wb_commit_port_data_in.op_info[i].enable == 'b1) else $finish;
            assert(wb_commit_port_data_in.op_info[i].valid == 'b1) else $finish;
            assert(wb_commit_port_data_in.op_info[i].has_exception == 'b0) else $finish;
            assert(wb_commit_port_data_in.op_info[i].rd_enable == 'b1) else $finish;
            assert(wb_commit_port_data_in.op_info[i].need_rename == 'b1) else $finish;
            assert(wb_commit_port_data_in.op_info[i].rd_phy == unsigned'(i)) else $finish;
            assert(wb_commit_port_data_in.op_info[i].rd_value == 'h15263317 + unsigned'(i)) else $finish;
            assert(wb_phyf_id[i] == unsigned'(i)) else $finish;
            assert(wb_phyf_data[i] == 'h15263317 + unsigned'(i)) else $finish;
            assert(wb_phyf_we[i] == 'b1) else $finish;
        end

        assert(wb_commit_port_we == 'b1);
        assert(wb_commit_port_flush == 'b0);
        commit_feedback_pack.enable = 'b1;
        wait_clk();
        assert(wb_commit_port_we == 'b1);
        assert(wb_commit_port_flush == 'b0);
        commit_feedback_pack.flush = 'b1;
        wait_clk();
        assert(wb_commit_port_we == 'b1);
        assert(wb_commit_port_flush == 'b1);
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