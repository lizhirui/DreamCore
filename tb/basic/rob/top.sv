`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`ROB_ID_WIDTH - 1:0] rob_rename_new_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rob_rename_new_id_valid;
    
    rob_item_t rename_rob_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rob_data_valid;
    logic rename_rob_push;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_input_id[0:`WB_WIDTH - 1];
    rob_item_t rob_commit_input_data[0:`WB_WIDTH - 1];
    rob_item_t commit_rob_input_data[0:`WB_WIDTH - 1];
    logic[`WB_WIDTH - 1:0] commit_rob_input_data_we;
    
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_retire_head_id;
    logic rob_commit_retire_head_id_valid;

    logic[`ROB_ID_WIDTH - 1:0] commit_rob_retire_id[0:`COMMIT_WIDTH - 1];
    rob_item_t rob_commit_retire_data[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] rob_commit_retire_id_valid;
    logic[`COMMIT_WIDTH - 1:0] commit_rob_retire_pop;

    logic[`ROB_ID_WIDTH - 1:0] commit_rob_next_id;
    logic rob_commit_next_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_tail_id;
    logic rob_commit_flush_tail_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_flush_id;
    rob_item_t rob_commit_flush_data;
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_next_id;
    logic rob_commit_flush_next_id_valid;

    logic rob_commit_empty;
    logic rob_commit_full;
    logic commit_rob_flush;

    integer i, j;
    
    rob_item_t rob_test;

    rob rob_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        rob_test.new_phy_reg_id = 'b0;
        rob_test.old_phy_reg_id = 'b0;
        rob_test.old_phy_reg_id_valid = 'b0;
        rob_test.finish = 'b0;
        rob_test.pc = 'b0;
        rob_test.inst_value = 'b0;
        rob_test.has_exception = 'b0;
        rob_test.exception_id = riscv_exception_t::instruction_address_misaligned;
        rob_test.exception_value = 'b0;
        rob_test.predicted = 'b0;
        rob_test.predicted_jump = 'b0;
        rob_test.predicted_next_pc = 'b0;
        rob_test.checkpoint_id_valid = 'b0;
        rob_test.checkpoint_id = 'b0;
        rob_test.bru_op = 'b0;
        rob_test.bru_jump = 'b0;
        rob_test.bru_next_pc = 'b0;
        rob_test.is_mret = 'b0;
        rob_test.csr_addr = 'b0;
        rob_test.csr_newvalue = 'b0;
        rob_test.csr_newvalue_valid = 'b0;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_rob_data[i] = rob_test;
            rename_rob_data_valid[i] = 'b0;
        end

        rename_rob_push = 'b0;
        
        for(i = 0;i < `WB_WIDTH;i++) begin
            commit_rob_input_id[i] = 'b0;
            commit_rob_input_data[i] = rob_test;
            commit_rob_input_data_we[i] = 'b0;
        end

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_rob_retire_id[i] = 'b0;
            commit_rob_retire_pop[i] = 'b0;
        end

        commit_rob_next_id = 'b0;
        commit_rob_flush_id = 'b0;
        commit_rob_flush = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(rob_rename_new_id[i] == unsigned'(i)) else $finish;
            assert(rob_rename_new_id_valid[i] == 'b1) else $finish;
        end

        assert(rob_commit_empty == 'b1) else $finish;
        assert(rob_commit_full == 'b0) else $finish;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rob_test.pc = 'habcdefac + unsigned'(i);
            rename_rob_data[i] = rob_test;
            rename_rob_data_valid[i] = 'b1;
        end

        rename_rob_push = 'b1;
        wait_clk();
        
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(rob_rename_new_id[i] == 'd4 + unsigned'(i)) else $finish;
            assert(rob_rename_new_id_valid[i] == 'b1) else $finish;
        end

        assert(rob_commit_empty == 'b0) else $finish;
        assert(rob_commit_full == 'b0) else $finish;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rob_test.pc = 'habcdefac + 'd4 + unsigned'(i);
            rename_rob_data[i] = rob_test;
            rename_rob_data_valid[i] = 'b1;
        end

        rename_rob_push = 'b1;
        wait_clk();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(rob_rename_new_id[i] == 'd8 + unsigned'(i)) else $finish;
            assert(rob_rename_new_id_valid[i] == 'b1) else $finish;
        end

        assert(rob_commit_empty == 'b0) else $finish;
        assert(rob_commit_full == 'b0) else $finish;
        rename_rob_push = 'b0;

        wait_clk();

        for(i = 0;i < `WB_WIDTH;i++) begin
            commit_rob_input_id[i] = 'b0;
        end

        for(i = 0;i < `WB_WIDTH;i++) begin
            commit_rob_input_id[i] = i;
            eval();

            for(j = 0;j < `WB_WIDTH;j++) begin
                if(i != j) begin
                    assert(rob_commit_input_data[j].pc == 'habcdefac) else $finish;
                end
            end

            assert(rob_commit_input_data[i].pc == 'habcdefac + unsigned'(i)) else $finish;
            rob_test.pc = 'habcdefac + unsigned'(i);
            rob_test.exception_value = 'b1001 + unsigned'(i);
            commit_rob_input_data_we[i] = 'b1;
            commit_rob_input_data[i] = rob_test;
            wait_clk();
            assert(rob_commit_input_data[i].exception_value == ('b1001 + unsigned'(i))) else $finish;
            commit_rob_input_data_we[i] = 'b0;
            commit_rob_input_id[i] = 'b0;
        end

        assert(rob_commit_retire_head_id == 'b0);
        assert(rob_commit_retire_head_id_valid == 'b1);

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_rob_retire_id[i] = 'b0;
        end

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_rob_retire_id[i] = i;
            eval();

            for(j = 0;j < `COMMIT_WIDTH;j++) begin
                if(i != j) begin
                    assert(rob_commit_retire_data[j].pc == 'habcdefac) else $finish;
                    assert(rob_commit_retire_id_valid[j] == 'b1) else $finish;
                end
            end

            assert(rob_commit_retire_data[i].pc == 'habcdefac + unsigned'(i)) else $finish;
            assert(rob_commit_retire_id_valid[i] == 'b1) else $finish;
            commit_rob_retire_id[i] = 'b0;
        end

        assert(rob_commit_flush_tail_id == 'd7) else $finish;
        assert(rob_commit_flush_tail_id_valid == 'b1) else $finish;

        for(i = 7;i >= 0;i--) begin
            commit_rob_flush_id = i;
            eval();
            assert(rob_commit_flush_data.pc == ('habcdefac + unsigned'(i))) else $finish;

            if(i > 0) begin
                assert(rob_commit_flush_next_id == unsigned'(i - 1));
                assert(rob_commit_flush_next_id_valid == 'b1);
            end
            else begin
                assert(rob_commit_flush_next_id_valid == 'b0);
            end
        end

        commit_rob_next_id = 'b0;
        eval();
        assert(rob_commit_next_id_valid == 'b0) else $finish;
        commit_rob_next_id = 'd7;
        eval();
        assert(rob_commit_next_id_valid == 'b1) else $finish;
        commit_rob_next_id = 'd8;
        eval();
        assert(rob_commit_next_id_valid == 'b0) else $finish;

        for(i = 0;i < 8;i++) begin
            assert(rob_commit_retire_head_id == unsigned'(i));
            assert(rob_commit_retire_head_id_valid == 'b1);
            assert(rob_commit_empty == 'b0);
            assert(rob_commit_full == 'b0);
            commit_rob_retire_pop = 'b1;
            wait_clk();
        end

        assert(rob_commit_retire_head_id_valid == 'b0);
        assert(rob_commit_empty == 'b1);
        assert(rob_commit_full == 'b0);
        commit_rob_retire_pop = 'b0;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rob_test.pc = 'habcdefac + unsigned'(i);
            rename_rob_data[i] = rob_test;
            rename_rob_data_valid[i] = 'b1;
        end

        rename_rob_push = 'b1;
        wait_clk();
        assert(rob_commit_empty == 'b0);
        assert(rob_commit_full == 'b0);
        commit_rob_flush = 'b1;
        wait_clk();
        commit_rob_flush = 'b0;
        assert(rob_commit_empty == 'b1);
        assert(rob_commit_full == 'b0);

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_rob_data_valid[i] = 'b0;
        end

        for(i = 0;i < `ROB_SIZE;i++) begin
            assert(rob_commit_full == 'b0);
            rename_rob_data_valid[0] = 'b1;
            rename_rob_push = 'b1;
            wait_clk();
        end

        assert(rob_commit_full == 'b1) else $finish;
        assert(rob_commit_empty == 'b0) else $finish;
        rename_rob_push = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_rob_retire_pop[i] = 'b1;
        end

        for(i = 0;i < `ROB_SIZE / `COMMIT_WIDTH;i++) begin
            assert(rob_commit_empty == 'b0) else $finish;
            wait_clk();
        end

        assert(rob_commit_empty == 'b1) else $finish;
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