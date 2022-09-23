`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] readreg_phyf_id[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] phyf_readreg_data[0:`READREG_WIDTH - 1][0:1];
    logic phyf_readreg_data_valid[0:`READREG_WIDTH - 1][0:1];
    
    logic[`PHY_REG_ID_WIDTH - 1:0] issue_phyf_id[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] phyf_issue_data[0:`READREG_WIDTH - 1][0:1];
    logic phyf_issue_data_valid[0:`READREG_WIDTH - 1][0:1];
    
    logic[`PHY_REG_ID_WIDTH - 1:0] wb_phyf_id[0:`WB_WIDTH - 1];
    logic[`REG_DATA_WIDTH - 1:0] wb_phyf_data[0:`WB_WIDTH - 1];
    logic[`WB_WIDTH - 1:0] wb_phyf_we;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_phyf_invalid;

    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_flush_id;
    logic commit_phyf_flush_invalid;
    
    logic[`PHY_REG_NUM - 1:0] commit_phyf_data_valid;
    logic commit_phyf_data_valid_restore;

    integer i, j, k;
    integer i2, j2;

    phy_regfile phy_regfile_inst(.*);

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
                readreg_phyf_id[i][j] = 'b0;
                issue_phyf_id[i][j] = 'b0;
            end
        end

        for(i = 0;i < `WB_WIDTH;i++) begin
            wb_phyf_id[i] = 'b0;
            wb_phyf_data[i] = 'b0;
            wb_phyf_we[i] = 'b0;
        end

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_phyf_id[i] = 'b0;
            commit_phyf_invalid[i] = 'b0;
        end

        commit_phyf_flush_id = 'b0;
        commit_phyf_flush_invalid = 'b0;
        commit_phyf_data_valid = 'b0;
        commit_phyf_data_valid_restore = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        
        for(i = 0;i < `READREG_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                assert(phyf_readreg_data_valid[i][j] == 'b0) else $finish;
                assert(phyf_issue_data_valid[i][j] == 'b0) else $finish;
            end
        end

        wait_clk();

        for(i = 0;i < `READREG_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                for(k = 1;k < `ARCH_REG_NUM;k++) begin
                    readreg_phyf_id[i][j] = unsigned'(k);
                    eval();

                    for(i2 = 0;i2 < `READREG_WIDTH;i2++) begin
                        for(j2 = 0;j2 < 2;j2++) begin
                            if((i != i2) || (j != j2)) begin
                                assert(phyf_readreg_data_valid[i2][j2] == 'b0) else $finish;
                            end
                        end
                    end

                    for(i2 = 0;i2 < `READREG_WIDTH;i2++) begin
                        for(j2 = 0;j2 < 2;j2++) begin
                            assert(phyf_issue_data_valid[i2][j2] == 'b0) else $finish;
                        end
                    end

                    assert(phyf_readreg_data_valid[i][j] == 'b1) else $finish;
                    assert(phyf_readreg_data[i][j] == 'b0) else $finish;
                    readreg_phyf_id[i][j] = 'b0;
                end
            end
        end

        for(i = 0;i < `READREG_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                for(k = 1;k < `ARCH_REG_NUM;k++) begin
                    issue_phyf_id[i][j] = unsigned'(k);
                    eval();

                    for(i2 = 0;i2 < `READREG_WIDTH;i2++) begin
                        for(j2 = 0;j2 < 2;j2++) begin
                            if((i != i2) || (j != j2)) begin
                                assert(phyf_issue_data_valid[i2][j2] == 'b0) else $finish;
                            end
                        end
                    end

                    for(i2 = 0;i2 < `READREG_WIDTH;i2++) begin
                        for(j2 = 0;j2 < 2;j2++) begin
                            assert(phyf_readreg_data_valid[i2][j2] == 'b0) else $finish;
                        end
                    end

                    assert(phyf_issue_data_valid[i][j] == 'b1) else $finish;
                    assert(phyf_issue_data[i][j] == 'b0) else $finish;
                    issue_phyf_id[i][j] = 'b0;
                end
            end
        end

        for(i = `ARCH_REG_NUM;i < `PHY_REG_NUM;i++) begin
            readreg_phyf_id[0][0] = unsigned'(i);
            eval();
            assert(phyf_readreg_data_valid[0][0] == 'b0) else $finish;
        end

        for(i = 0;i < `WB_WIDTH;i++) begin
            wb_phyf_id[i] = unsigned'(i);
            wb_phyf_data[i] = 'h1acdef89 + unsigned'(i);
            wb_phyf_we[i] = 'b1;
            wait_clk();
            wb_phyf_we[i] = 'b0;
        end

        for(i = 0;i < `WB_WIDTH;i++) begin
            readreg_phyf_id[0][0] = unsigned'(i);
            eval();
            assert(phyf_readreg_data_valid[0][0] == 'b1) else $finish;
            assert(phyf_readreg_data[0][0] == ('h1acdef89 + unsigned'(i))) else $finish;
        end

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_phyf_id[i] = unsigned'(i);
            commit_phyf_invalid[i] = 'b1;
            wait_clk();
            commit_phyf_invalid[i] = 'b0;
            
            for(j = 0;j <= i;j++) begin
                readreg_phyf_id[0][0] = unsigned'(j);
                eval();
                assert(phyf_readreg_data_valid[0][0] == 'b0) else $finish;
            end

            for(j = i + 1;j < `ARCH_REG_NUM;j++) begin
                readreg_phyf_id[0][0] = unsigned'(j);
                eval();
                assert(phyf_readreg_data_valid[0][0] == 'b1) else $finish;
            end

            for(j = `ARCH_REG_NUM;j < `PHY_REG_NUM;j++) begin
                readreg_phyf_id[0][0] = unsigned'(j);
                eval();
                assert(phyf_readreg_data_valid[0][0] == 'b0) else $finish;
            end
        end

        commit_phyf_flush_id = 'd10;
        commit_phyf_flush_invalid = 'b1;
        wait_clk();
        readreg_phyf_id[0][0] = 'd10;
        eval();
        assert(phyf_readreg_data_valid[0][0] == 'b0) else $finish;

        for(i = 0;i < `PHY_REG_NUM;i++) begin
            commit_phyf_data_valid[i] = 'b1;
        end

        commit_phyf_data_valid_restore = 'b1;
        wait_clk();
        commit_phyf_data_valid_restore = 'b0;

        for(i = 0;i < `PHY_REG_NUM;i++) begin
            readreg_phyf_id[0][0] = unsigned'(i);
            eval();
            assert(phyf_readreg_data_valid[0][0] == 'b1) else $finish;
        end

        for(i = 0;i < `PHY_REG_NUM;i++) begin
            commit_phyf_data_valid[i] = 'b0;
        end

        commit_phyf_data_valid_restore = 'b1;
        wait_clk();
        commit_phyf_data_valid_restore = 'b0;

        for(i = 0;i < `PHY_REG_NUM;i++) begin
            readreg_phyf_id[0][0] = unsigned'(i);
            eval();
            assert(phyf_readreg_data_valid[0][0] == 'b0) else $finish;
        end

        for(i = 1;i < `ARCH_REG_NUM;i++) begin
            commit_phyf_data_valid[i] = 'b1;
        end

        commit_phyf_data_valid_restore = 'b1;
        wait_clk();
        commit_phyf_data_valid_restore = 'b0;

        readreg_phyf_id[0][0] = 'b0;
        eval();
        assert(phyf_readreg_data_valid[0][0] == 'b0) else $finish;

        for(i = 1;i < `ARCH_REG_NUM;i++) begin
            readreg_phyf_id[0][0] = unsigned'(i);
            eval();
            assert(phyf_readreg_data_valid[0][0] == 'b1) else $finish;
        end

        for(i = `ARCH_REG_NUM;i < `PHY_REG_NUM;i++) begin
            readreg_phyf_id[0][0] = unsigned'(i);
            eval();
            assert(phyf_readreg_data_valid[0][0] == 'b0) else $finish;
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