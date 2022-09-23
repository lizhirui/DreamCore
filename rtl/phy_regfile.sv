`include "config.svh"
`include "common.svh"

module phy_regfile(
        input logic clk,
        input logic rst,
        
        input logic[`PHY_REG_ID_WIDTH - 1:0] readreg_phyf_id[0:`READREG_WIDTH - 1][0:1],
        output logic[`REG_DATA_WIDTH - 1:0] phyf_readreg_data[0:`READREG_WIDTH - 1][0:1],
        output logic phyf_readreg_data_valid[0:`READREG_WIDTH - 1][0:1],
        
        input logic[`PHY_REG_ID_WIDTH - 1:0] issue_phyf_id[0:`READREG_WIDTH - 1][0:1],
        output logic[`REG_DATA_WIDTH - 1:0] phyf_issue_data[0:`READREG_WIDTH - 1][0:1],
        output logic phyf_issue_data_valid[0:`READREG_WIDTH - 1][0:1],
        
        input logic[`PHY_REG_ID_WIDTH - 1:0] wb_phyf_id[0:`WB_WIDTH - 1],
        input logic[`REG_DATA_WIDTH - 1:0] wb_phyf_data[0:`WB_WIDTH - 1],
        input logic[`WB_WIDTH - 1:0] wb_phyf_we,
        
        input logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_id[0:`COMMIT_WIDTH - 1],
        input logic[`COMMIT_WIDTH - 1:0] commit_phyf_invalid,

        input logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_flush_id,
        input logic commit_phyf_flush_invalid,
        
        input logic[`PHY_REG_NUM - 1:0] commit_phyf_data_valid,
        input logic commit_phyf_data_valid_restore
    );

    logic[`PHY_REG_NUM - 1:0] data_valid;
    logic[`PHY_REG_NUM - 1:0][`REG_DATA_WIDTH - 1:0] data;

    logic[`WB_WIDTH - 1:0] wb_phyf_id_cmp[0:`PHY_REG_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] wb_phyf_id_cmp_data_out[0:`PHY_REG_NUM - 1];
    logic[`PHY_REG_NUM - 1:0] wb_phyf_id_cmp_data_out_valid;
    logic[`COMMIT_WIDTH - 1:0] commit_phyf_id_cmp[0:`PHY_REG_NUM - 1];
    logic[`PHY_REG_NUM - 1:0] commit_phyf_id_cmp_data_out_valid;

    genvar i, j;
    integer k;

    generate
        for(i = 0;i < `READREG_WIDTH;i++) begin
            for(j = 0;j < 2;j++) begin
                assign phyf_readreg_data[i][j] = data[readreg_phyf_id[i][j]];
                assign phyf_readreg_data_valid[i][j] = data_valid[readreg_phyf_id[i][j]];

                assign phyf_issue_data[i][j] = data[issue_phyf_id[i][j]];
                assign phyf_issue_data_valid[i][j] = data_valid[issue_phyf_id[i][j]];
            end
        end
    endgenerate

    generate
        for(i = 0;i < `PHY_REG_NUM;i++) begin: write_signal_generate
            for(j = 0;j < `WB_WIDTH;j++) begin
                assign wb_phyf_id_cmp[i][j] = (unsigned'(i) == wb_phyf_id[j]) && wb_phyf_we[j];
            end

            for(j = 0;j < `COMMIT_WIDTH;j++) begin
                assign commit_phyf_id_cmp[i][j] = (unsigned'(i) == commit_phyf_id[j]) && commit_phyf_invalid[j];
            end

            data_selector #(
                .SEL_WIDTH(`WB_WIDTH),
                .DATA_WIDTH(`REG_DATA_WIDTH)
            )data_selector_wb_phyf_inst(
                .sel_in(wb_phyf_id_cmp[i]),
                .data_in(wb_phyf_data),
                .data_out(wb_phyf_id_cmp_data_out[i]),
                .data_out_valid(wb_phyf_id_cmp_data_out_valid[i])
            );

            parallel_finder #(
                .WIDTH(`COMMIT_WIDTH)
            )parallel_finder_commit_phyf_inst(
                .data_in(commit_phyf_id_cmp[i]),
                .index_valid(commit_phyf_id_cmp_data_out_valid[i])
            );

            always_ff @(posedge clk) begin
                if(rst) begin
                    data_valid[i] <= ((i >= 1) && (i < `ARCH_REG_NUM)) ? 'b1 : 'b0;
                    data[i] <= 'b0;
                end
                else if(commit_phyf_data_valid_restore) begin
                    data_valid[i] <= commit_phyf_data_valid[i];
                end
                else if(wb_phyf_id_cmp_data_out_valid[i]) begin
                    data_valid[i] <= 'b1;
                    data[i] <= wb_phyf_id_cmp_data_out[i];
                end
                else if(commit_phyf_id_cmp_data_out_valid[i]) begin
                    data_valid[i] <= 'b0;
                end
                else if(commit_phyf_flush_invalid) begin
                    if(unsigned'(i) == commit_phyf_flush_id) begin
                        data_valid[i] <= 'b0;
                    end
                end
            end
        end
    endgenerate
endmodule