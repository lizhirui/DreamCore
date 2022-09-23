`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_new_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rat_rename_new_phy_id_valid;
    logic[`PHY_REG_ID_WIDTH - 1:0] rename_rat_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rat_phy_id_valid;
    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_arch_id[0:`RENAME_WIDTH - 1];
    logic rename_rat_map;
    
    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_read_arch_id[0:`RENAME_WIDTH - 1][0:2];
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_read_phy_id[0:`RENAME_WIDTH - 1][0:2];
    
    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_valid;
    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_visible;
    
    logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_valid;
    logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_visible;
    logic commit_rat_map_table_restore;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_release_phy_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_rat_release_phy_id_valid;
    logic commit_rat_release_map;
    
    logic[`PHY_REG_ID_WIDTH- 1:0] commit_rat_commit_phy_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_rat_commit_phy_id_valid;
    logic commit_rat_commit_map;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_new_phy_id;
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_old_phy_id;
    logic commit_rat_restore_map;

    integer i, j, k;

    rat rat_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task check_consistency;
        integer cnt;
        logic[`ARCH_REG_NUM - 1:0] arch_found;

        cnt = 0;
        arch_found = 'b0;

        for(i = 0;i < `PHY_REG_NUM;i++) begin
            if(rat_rename_map_table_valid[i] && rat_rename_map_table_visible[i]) begin
                cnt++;
                arch_found[rat_inst.map_table[i]] = 'b1;
            end
        end

        assert(cnt == (`ARCH_REG_NUM - 1)) else $finish;
        assert(arch_found == ~`ARCH_REG_NUM'b1) else $finish;

        cnt = 0;
        arch_found = 'b0;

        for(i = 0;i < `PHY_REG_NUM;i++) begin
            if(rat_rename_map_table_valid[i] && rat_inst.map_commit[i]) begin
                cnt++;
                arch_found[rat_inst.map_table[i]] = 'b1;
            end
        end

        assert(cnt == (`ARCH_REG_NUM - 1)) else $finish;
        assert(arch_found == ~`ARCH_REG_NUM'b1) else $finish;
    endtask

    task test;
        rst = 1;
        rename_rat_phy_id_valid = 'b0;
        rename_rat_map = 'b0;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_rat_phy_id[i] = 'b0;
            rename_rat_arch_id[i] = 'b0;

            for(j = 0;j < 3;j++) begin
                rename_rat_read_arch_id[i][j] = 'b0;
            end
        end

        commit_rat_map_table_valid = 'b0;
        commit_rat_map_table_visible = 'b0;
        commit_rat_map_table_restore = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_rat_release_phy_id[i] = 'b0;
            commit_rat_commit_phy_id[i] = 'b0;
        end

        commit_rat_release_phy_id_valid = 'b0;
        commit_rat_release_map = 'b0;
        commit_rat_commit_phy_id_valid = 'b0;
        commit_rat_commit_map = 'b0;
        commit_rat_restore_new_phy_id = 'b0;
        commit_rat_restore_old_phy_id = 'b0;
        commit_rat_restore_map = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        
        assert(rat_rename_map_table_valid[0] == 'b0) else $finish;
        assert(rat_rename_map_table_visible[0] == 'b0) else $finish;
        assert(rat_inst.map_commit[0] == 'b0) else $finish;

        for(i = 1;i < `ARCH_REG_NUM;i++) begin
            assert(rat_rename_map_table_valid[i] == 'b1) else $finish;
            assert(rat_rename_map_table_visible[i] == 'b1) else $finish;
            assert(rat_inst.map_commit[i] == 'b1) else $finish;
        end

        for(i = `ARCH_REG_NUM;i < `PHY_REG_NUM;i++) begin
            assert(rat_rename_map_table_valid[i] == 'b0) else $finish;
            assert(rat_rename_map_table_visible[i] == 'b0) else $finish;
            assert(rat_inst.map_commit[i] == 'b0) else $finish;
        end

        check_consistency();

        assert(rat_rename_new_phy_id[0] == 'b0) else $finish;
        
        for(i = 1;i < `RENAME_WIDTH;i++) begin
            assert(rat_rename_new_phy_id[i] == unsigned'(`ARCH_REG_NUM + i - 1)) else $finish;
        end

        assert(rat_rename_new_phy_id_valid == ~`RENAME_WIDTH'b0) else $finish;

        wait_clk();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_rat_phy_id[i] = rat_rename_new_phy_id[i];
            rename_rat_phy_id_valid = rat_rename_new_phy_id_valid;
            rename_rat_arch_id[i] = unsigned'(i + 1);
        end

        rename_rat_map = 'b1;
        wait_clk();
        rename_rat_map = 'b0;
        check_consistency();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assert(rat_rename_map_table_valid[rename_rat_phy_id[i]] == 'b1) else $finish;
            assert(rat_rename_map_table_visible[rename_rat_phy_id[i]] == 'b1) else $finish;
            assert(rat_inst.map_table[rename_rat_phy_id[i]] == unsigned'(i + 1)) else $finish;
            assert(rat_inst.map_commit[rename_rat_phy_id[i]] == 'b0) else $finish;
        end

        //assume `RENAME_WIDTH == `COMMIT_WIDTH
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_rat_commit_phy_id[i] = rename_rat_phy_id[i];
            commit_rat_commit_phy_id_valid[i] = 'b1;
        end

        commit_rat_commit_map = 'b1;
        wait_clk();
        commit_rat_commit_map = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assert(rat_inst.map_commit[rename_rat_phy_id[i]] == 'b1) else $finish;
        end

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            for(j = 0;j < 3;j++) begin
                rename_rat_read_arch_id[i][j] = unsigned'(i * 3 + j + 1);
            end
        end

        eval();

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            for(j = 0;j < 3;j++) begin
                assert(rat_inst.map_table[rat_rename_read_phy_id[i][j]] == rename_rat_read_arch_id[i][j]) else $finish;
                assert(rat_rename_map_table_valid[rat_rename_read_phy_id[i][j]] == 'b1) else $finish;
                assert(rat_rename_map_table_visible[rat_rename_read_phy_id[i][j]] == 'b1) else $finish;
            end
        end

        wait_clk();
        commit_rat_map_table_valid = `PHY_REG_NUM'habdc71259acd1587;
        commit_rat_map_table_visible = `PHY_REG_NUM'habdc71259acd1587;
        commit_rat_map_table_restore = 'b1;
        wait_clk();
        commit_rat_map_table_restore = 'b0;
        assert(rat_rename_map_table_valid == commit_rat_map_table_valid) else $finish;
        assert(rat_rename_map_table_visible == commit_rat_map_table_visible) else $finish;
        rst = 1;
        wait_clk();
        rst = 0;
        wait_clk();
        
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_rat_release_phy_id[i] = unsigned'(i + 1);
            commit_rat_release_phy_id_valid[i] = 'b1;
        end

        commit_rat_release_map = 'b1;
        wait_clk();
        commit_rat_release_map = 'b0;

        for(i = 1;i <= `COMMIT_WIDTH;i++) begin
            assert(rat_rename_map_table_valid[i] == 'b0) else $finish;
        end

        for(i = `COMMIT_WIDTH + 1;i < `ARCH_REG_NUM;i++) begin
            assert(rat_rename_map_table_valid[i] == 'b1) else $finish;
        end

        rst = 1;
        wait_clk();
        rst = 0;
        wait_clk();
        commit_rat_restore_new_phy_id = 'b1;
        commit_rat_restore_old_phy_id = 'b0;
        commit_rat_restore_map = 'b1;
        wait_clk();
        commit_rat_restore_map = 'b0;
        assert(rat_rename_map_table_valid[1:0] == 'b01) else $finish;
        assert(rat_rename_map_table_visible[1:0] == 'b01) else $finish;
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