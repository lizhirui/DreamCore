`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`ADDR_WIDTH -1:0] fetch_bp_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_instruction;
    logic fetch_bp_valid;
    logic bp_fetch_jump;
    logic[`ADDR_WIDTH - 1:0] bp_fetch_next_pc;
    logic bp_fetch_valid;
    logic[`GSHARE_GLOBAL_HISTORY_WIDTH - 1:0] bp_fetch_global_history;
    logic[`LOCAL_BHT_WIDTH - 1:0] bp_fetch_local_history; 
    
    logic[`ADDR_WIDTH - 1:0] fetch_bp_update_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_update_instruction;
    logic fetch_bp_update_jump;
    logic[`ADDR_WIDTH - 1:0] fetch_bp_update_next_pc;
    logic fetch_bp_update_valid;
    
    logic[`ADDR_WIDTH - 1:0] bp_ras_addr;
    logic bp_ras_push;
    logic[`ADDR_WIDTH - 1:0] ras_bp_addr;
    logic bp_ras_pop;
    
    checkpoint_t exbru_bp_cp;
    logic[`ADDR_WIDTH -1:0] exbru_bp_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] exbru_bp_instruction;
    logic exbru_bp_jump;
    logic[`ADDR_WIDTH - 1:0] exbru_bp_next_pc;
    logic exbru_bp_hit;
    logic exbru_bp_valid;
    
    logic[`ADDR_WIDTH -1:0] commit_bp_pc[0:`COMMIT_WIDTH - 1];
    logic[`INSTRUCTION_WIDTH - 1:0] commit_bp_instruction[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_jump;
    logic[`ADDR_WIDTH - 1:0] commit_bp_next_pc[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_hit;
    logic[`COMMIT_WIDTH - 1:0] commit_bp_valid;

    checkpoint_t cp;

    integer i, j;

    branch_predictor branch_predictor_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        fetch_bp_pc = 'b0;
        fetch_bp_instruction = 'b0;
        fetch_bp_valid = 'b0;
        fetch_bp_update_pc = 'b0;
        fetch_bp_update_instruction = 'b0;
        fetch_bp_update_jump = 'b0;
        fetch_bp_update_next_pc = 'b0;
        fetch_bp_update_valid = 'b0;
        ras_bp_addr = 'b0;
        cp.rat_phy_map_table_valid = 'b0;
        cp.rat_phy_map_table_visible = 'b0;
        cp.global_history = 'b0;
        cp.local_history = 'b0;
        exbru_bp_cp = cp;
        exbru_bp_pc = 'b0;
        exbru_bp_instruction = 'b0;
        exbru_bp_jump = 'b0;
        exbru_bp_next_pc = 'b0;
        exbru_bp_hit = 'b0;
        exbru_bp_valid = 'b0;
        
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_bp_pc[i] = 'b0;
            commit_bp_instruction[i] = 'b0;
            commit_bp_jump[i] = 'b0;
            commit_bp_next_pc[i] = 'b0;
            commit_bp_hit[i] = 'b0;
            commit_bp_valid[i] = 'b0;    
        end

        wait_clk();
        rst = 0;
        assert(bp_fetch_valid == 'b0) else $finish;
        assert(bp_ras_push == 'b0) else $finish;
        assert(bp_ras_pop == 'b0) else $finish;
        fetch_bp_pc = 'h80100020;
        fetch_bp_instruction = 'h0040006f;//jal x0, 4
        fetch_bp_valid = 'b1;
        eval();
        assert(bp_fetch_jump == 'b1) else $finish;
        assert(bp_fetch_next_pc == 'h80100024) else $finish;
        assert(bp_fetch_valid == 'b1) else $finish;
        fetch_bp_instruction = 'h000080e7;//jalr ra, 0(ra) call
        eval();
        assert(bp_fetch_jump == 'b1) else $finish;
        assert(bp_fetch_valid == 'b1) else $finish;
        assert(bp_ras_addr == 'h80100024) else $finish;
        assert(bp_ras_push == 'b1) else $finish;
        assert(bp_ras_pop == 'b0) else $finish;
        eval();
        fetch_bp_instruction = 'h004000e7;//jalr ra, 4(x0) call
        eval();
        assert(bp_fetch_jump == 'b1) else $finish;
        assert(bp_fetch_valid == 'b1) else $finish;
        assert(bp_ras_addr == 'h80100024) else $finish;
        assert(bp_ras_push == 'b1) else $finish;
        assert(bp_ras_pop == 'b0) else $finish;
        fetch_bp_instruction = 'h004280e7;//jalr ra, 4(x5) context switch
        ras_bp_addr = 'h80aabbc0;
        eval();
        assert(bp_fetch_jump == 'b1) else $finish;
        assert(bp_fetch_next_pc == ras_bp_addr) else $finish;
        assert(bp_fetch_valid == 'b1) else $finish;
        assert(bp_ras_addr == 'h80100024) else $finish;
        assert(bp_ras_push == 'b1) else $finish;
        assert(bp_ras_pop == 'b1) else $finish;
        fetch_bp_instruction = 'h00008067;//jalr x0, 0(ra) return
        eval();
        assert(bp_fetch_jump == 'b1) else $finish;
        assert(bp_fetch_next_pc == ras_bp_addr) else $finish;
        assert(bp_fetch_valid == 'b1) else $finish;
        assert(bp_ras_push == 'b0) else $finish;
        assert(bp_ras_pop == 'b1) else $finish;
        fetch_bp_instruction = 'h00028067;//jalr x0, 0(x5) return
        eval();
        assert(bp_fetch_jump == 'b1) else $finish;
        assert(bp_fetch_next_pc == ras_bp_addr) else $finish;
        assert(bp_fetch_valid == 'b1) else $finish;
        assert(bp_ras_push == 'b0) else $finish;
        assert(bp_ras_pop == 'b1) else $finish;
        fetch_bp_instruction = 'h00000067;//jalr x0, 0(x0) normal
        eval();
        assert(bp_fetch_jump == 'b1) else $finish;
        assert(bp_fetch_valid == 'b1) else $finish;
        assert(bp_ras_push == 'b0) else $finish;
        assert(bp_ras_pop == 'b0) else $finish;
        fetch_bp_instruction = 'h00000463;//beq x0, x0, 8
        eval();

        if(bp_fetch_jump) begin
            assert(bp_fetch_next_pc == 'h80100028) else $finish;
        end
        else begin
            assert(bp_fetch_next_pc == 'h80100024) else $finish;
        end
        
        assert(bp_fetch_valid == 'b1) else $finish;
        assert(bp_ras_push == 'b0) else $finish;
        assert(bp_ras_pop == 'b0) else $finish;
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