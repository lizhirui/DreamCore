`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] cpbuf_fetch_new_id;
    logic cpbuf_fetch_new_id_valid;
    checkpoint_t fetch_cpbuf_data;
    logic fetch_cpbuf_push;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] rename_cpbuf_id[0:`RENAME_WIDTH - 1];
    checkpoint_t rename_cpbuf_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_cpbuf_we;
    checkpoint_t cpbuf_rename_data[0:`RENAME_WIDTH - 1];
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] exbru_cpbuf_id;
    checkpoint_t cpbuf_exbru_data;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] commit_cpbuf_id[0:`COMMIT_WIDTH - 1];
    checkpoint_t cpbuf_commit_data[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_cpbuf_pop;
    logic commit_cpbuf_flush;

    integer i, j;
    
    checkpoint_t cp_test;

    checkpoint_buffer checkpoint_buffer_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        cp_test.rat_phy_map_table_valid = 'b0;
        cp_test.rat_phy_map_table_visible = 'b0;
        cp_test.global_history = 'b0;
        cp_test.local_history = 'b0;
        fetch_cpbuf_data = cp_test;
        fetch_cpbuf_push = 'b0;
        
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_cpbuf_id[i] = 'b0;
            rename_cpbuf_data[i] = 'b0;
            rename_cpbuf_we[i] = 'b0;
        end

        exbru_cpbuf_id = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_cpbuf_id[i] = 'b0;
            commit_cpbuf_pop = 'b0;
        end

        commit_cpbuf_flush = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(cpbuf_fetch_new_id == 'b0) else $finish;
        assert(cpbuf_fetch_new_id_valid == 'b1) else $finish;
        cp_test.global_history = 'b1;
        fetch_cpbuf_data = cp_test;
        fetch_cpbuf_push = 'b1;
        wait_clk();
        assert(cpbuf_fetch_new_id == 'b1) else $finish;
        assert(cpbuf_fetch_new_id_valid == 'b1) else $finish;
        cp_test.global_history = 'b11;
        fetch_cpbuf_data = cp_test;
        wait_clk();
        assert(cpbuf_fetch_new_id == 'b10) else $finish;
        assert(cpbuf_fetch_new_id_valid == 'b1) else $finish;
        fetch_cpbuf_push = 'b0;
        
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_cpbuf_id[i] = 'b1;
        end

        exbru_cpbuf_id = 'b1;
        wait_clk();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_cpbuf_id[i] = 'b0;
            eval();

            for(j = 0;j < `RENAME_WIDTH;j++) begin
                if(i == j) begin
                    assert(cpbuf_rename_data[j].global_history == 'b1) else $finish;
                end
                else begin
                    assert(cpbuf_rename_data[j].global_history == 'b11) else $finish;
                end
            end
            
            rename_cpbuf_id[i] = 'b1;
            wait_clk();
        end

        wait_clk();
        assert(cpbuf_exbru_data.global_history == 'b11) else $finish;
        exbru_cpbuf_id = 'b0;
        eval();
        assert(cpbuf_exbru_data.global_history == 'b1) else $finish;
        wait_clk();
        
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_cpbuf_id[i] = 'b1;
            eval();

            for(j = 0;j < `COMMIT_WIDTH;j++) begin
                if(i == j) begin
                    assert(cpbuf_commit_data[j].global_history == 'b11) else $finish;
                end
                else begin
                    assert(cpbuf_commit_data[j].global_history == 'b1) else $finish;
                end
            end
            
            commit_cpbuf_id[i] = 'b0;
            wait_clk();
        end

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_cpbuf_id[i] = 'b0;
            cp_test.global_history = 'b111;
            rename_cpbuf_data[i] = cp_test;
            rename_cpbuf_we[i] = 'b1;
            wait_clk();
            rename_cpbuf_we[i] = 'b0;
            assert(cpbuf_rename_data[i].global_history == 'b111) else $finish;
        end

        commit_cpbuf_flush = 'b1;
        wait_clk();
        assert(cpbuf_fetch_new_id == 'b0) else $finish;
        assert(cpbuf_fetch_new_id_valid == 'b1) else $finish;
        commit_cpbuf_flush = 'b0;
        wait_clk();

        for(i = 0;i < `CHECKPOINT_BUFFER_SIZE;i++) begin
            assert(cpbuf_fetch_new_id == unsigned'(i)) else $finish;
            assert(cpbuf_fetch_new_id_valid == 'b1) else $finish;
            fetch_cpbuf_push = 'b1;
            wait_clk();
            fetch_cpbuf_push = 'b0;
        end
        
        assert(cpbuf_fetch_new_id == 'b0) else $finish;
        assert(cpbuf_fetch_new_id_valid == 'b0) else $finish;

        for(i = 0;i < `CHECKPOINT_BUFFER_SIZE;i++) begin
            commit_cpbuf_pop[0] = 'b1;
            wait_clk();
            assert(cpbuf_fetch_new_id == 'b0) else $finish;
            assert(cpbuf_fetch_new_id_valid == 'b1) else $finish;
        end
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