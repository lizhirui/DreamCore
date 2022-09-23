`include "config.svh"
`include "common.svh"

module csrfile(
        input logic clk,
        input logic rst,
        
        input logic[`CSR_ADDR_WIDTH - 1:0] excsr_csrf_addr,
        output logic[`REG_DATA_WIDTH - 1:0] csrf_excsr_data,
        
        input logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_read_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1],
        output logic[`REG_DATA_WIDTH - 1:0] csrf_commit_read_data[0:`COMMIT_CSR_CHANNEL_NUM - 1],
        input logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_write_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1],
        input logic[`REG_DATA_WIDTH - 1:0] commit_csrf_write_data[0:`COMMIT_CSR_CHANNEL_NUM - 1],
        input logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] commit_csrf_we,
        
        input logic[`REG_DATA_WIDTH - 1:0] intif_csrf_mip_data,
        
        output logic[`REG_DATA_WIDTH - 1:0] csrf_all_mie_data,
        output logic[`REG_DATA_WIDTH - 1:0] csrf_all_mstatus_data,
        output logic[`REG_DATA_WIDTH - 1:0] csrf_all_mip_data,
        output logic[`REG_DATA_WIDTH - 1:0] csrf_all_mepc_data,
        
        input logic fetch_csrf_checkpoint_buffer_full_add,
        input logic fetch_csrf_fetch_not_full_add,
        input logic fetch_csrf_fetch_decode_fifo_full_add,
        input logic decode_csrf_decode_rename_fifo_full_add,
        input logic rename_csrf_phy_regfile_full_add,
        input logic rename_csrf_rob_full_add,
        input logic issue_csrf_issue_execute_fifo_full_add,
        input logic issue_csrf_issue_queue_full_add,
        input logic commit_csrf_branch_num_add,
        input logic commit_csrf_branch_predicted_add,
        input logic commit_csrf_branch_hit_add,
        input logic commit_csrf_branch_miss_add,
        input logic[$clog2(`COMMIT_WIDTH):0] commit_csrf_commit_num_add,
        input logic ras_csrf_ras_full_add,

        output logic[7:0] uart_send_data,
        output logic uart_send,
        input logic uart_send_busy,

        input logic[7:0] uart_rev_data,
        input logic uart_rev_data_valid,
        output logic uart_rev_data_invalid
    );

    localparam CSR_NUM = 1 << `CSR_ADDR_WIDTH;

    logic[`REG_DATA_WIDTH - 1:0] csr_write_data[0:CSR_NUM - 1];
    logic[CSR_NUM - 1:0] csr_write_enable;

    logic[`REG_DATA_WIDTH - 1:0] csr_read_data[0:CSR_NUM - 1];

    logic[`REG_DATA_WIDTH - 1:0] csr_file[0:CSR_NUM - 1];

    logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] csr_write_channel_cmp[0:CSR_NUM - 1];
    //logic[$clog2(`COMMIT_CSR_CHANNEL_NUM) - 1:0] csr_write_channel_index;

    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_mcycle_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_minstret_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_branchnum_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_branchpredicted_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_branchhit_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_branchmiss_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_fd_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_dr_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_iq_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_ie_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_cb_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_rob_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_phy_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_ras_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] csr_fnf_next;

    genvar i, j;

    generate
        for(i = 0;i < CSR_NUM;i++) begin: csr_write_channel_generate
            for(j = 0;j < `COMMIT_CSR_CHANNEL_NUM;j++) begin
                assign csr_write_channel_cmp[i][j] = (commit_csrf_write_addr[j] == unsigned'(i)) && commit_csrf_we[j];
            end
            
            data_selector #(
                .SEL_WIDTH(`COMMIT_CSR_CHANNEL_NUM),
                .DATA_WIDTH(`REG_DATA_WIDTH)
            )data_selector_csr_write_data_inst(
                .sel_in(csr_write_channel_cmp[i]),
                .data_in(commit_csrf_write_data),
                .data_out(csr_write_data[i]),
                .data_out_valid(csr_write_enable[i])
            );
        end
    endgenerate
    
    assign csrf_excsr_data = csr_read_data[excsr_csrf_addr];

    generate
        for(i = 0;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
            assign csrf_commit_read_data[i] = csr_read_data[commit_csrf_read_addr[i]];
        end
    endgenerate

    assign csr_mcycle_next = {csr_file[`CSR_MCYCLEH], csr_file[`CSR_MCYCLE]} + 'b1;
    assign csr_minstret_next = {csr_file[`CSR_MINSTRETH], csr_file[`CSR_MINSTRET]} + commit_csrf_commit_num_add;
    assign csr_branchnum_next = {csr_file[`CSR_BRANCHNUMH], csr_file[`CSR_BRANCHNUM]} + commit_csrf_branch_num_add;
    assign csr_branchpredicted_next = {csr_file[`CSR_BRANCHPREDICTEDH], csr_file[`CSR_BRANCHPREDICTED]} + commit_csrf_branch_predicted_add;
    assign csr_branchhit_next = {csr_file[`CSR_BRANCHHITH], csr_file[`CSR_BRANCHHIT]} + commit_csrf_branch_hit_add;
    assign csr_branchmiss_next = {csr_file[`CSR_BRANCHMISSH], csr_file[`CSR_BRANCHMISS]} + commit_csrf_branch_miss_add;
    assign csr_fd_next = {csr_file[`CSR_FDH], csr_file[`CSR_FD]} + fetch_csrf_fetch_decode_fifo_full_add;
    assign csr_dr_next = {csr_file[`CSR_DRH], csr_file[`CSR_DR]} + decode_csrf_decode_rename_fifo_full_add;
    assign csr_iq_next = {csr_file[`CSR_IQH], csr_file[`CSR_IQ]} + issue_csrf_issue_queue_full_add;
    assign csr_ie_next = {csr_file[`CSR_IEH], csr_file[`CSR_IE]} + issue_csrf_issue_execute_fifo_full_add;
    assign csr_cb_next = {csr_file[`CSR_CBH], csr_file[`CSR_CB]} + fetch_csrf_checkpoint_buffer_full_add;
    assign csr_rob_next = {csr_file[`CSR_ROBH], csr_file[`CSR_ROB]} + rename_csrf_rob_full_add;
    assign csr_phy_next = {csr_file[`CSR_PHYH], csr_file[`CSR_PHY]} + rename_csrf_phy_regfile_full_add;
    assign csr_ras_next = {csr_file[`CSR_RASH], csr_file[`CSR_RAS]} + ras_csrf_ras_full_add;
    assign csr_fnf_next = {csr_file[`CSR_FNFH], csr_file[`CSR_FNF]} + fetch_csrf_fetch_not_full_add;

    generate
        for(i = 0;i < CSR_NUM;i++) begin
            always_ff @(posedge clk) begin
                if(rst) begin
                    case(i)
                        `CSR_MVENDORID: csr_file[i] <= 'b0;
                        `CSR_MARCHID: csr_file[i] <= 'h19981001;
                        `CSR_MIMPID: csr_file[i] <=  'h20220201;
                        `CSR_MHARTID,
                        `CSR_MCONFIGPTR,
                        `CSR_MSTATUS: csr_file[i] <= 'b0;
                        `CSR_MISA: csr_file[i] <= 'h40001100;
                        `CSR_MIE,
                        `CSR_MTVEC,
                        `CSR_MCOUNTEREN,
                        `CSR_MSTATUSH,
                        `CSR_MSCRATCH,
                        `CSR_MEPC,
                        `CSR_MCAUSE,
                        `CSR_MTVAL,
                        `CSR_MIP,
                        `CSR_CHARFIFO: csr_file[i] <= 'b0;
                        `CSR_FINISH: csr_file[i] <= 'hffffffff;
                        `CSR_UARTFIFO: csr_file[i] <= 'b0;
                        `CSR_MCYCLE,
                        `CSR_MINSTRET,
                        `CSR_MCYCLEH,
                        `CSR_MINSTRETH: csr_file[i] <= 'b0;
                        `CSR_BRANCHNUM,
                        `CSR_BRANCHNUMH,
                        `CSR_BRANCHPREDICTED,
                        `CSR_BRANCHPREDICTEDH,
                        `CSR_BRANCHHIT,
                        `CSR_BRANCHHITH,
                        `CSR_BRANCHMISS,
                        `CSR_BRANCHMISSH,
                        `CSR_FD,
                        `CSR_FDH,
                        `CSR_DR,
                        `CSR_DRH,
                        `CSR_IQ,
                        `CSR_IQH,
                        `CSR_IE,
                        `CSR_IEH,
                        `CSR_CB,
                        `CSR_CBH,
                        `CSR_ROB,
                        `CSR_ROBH,
                        `CSR_PHY,
                        `CSR_PHYH,
                        `CSR_RAS,
                        `CSR_RASH,
                        `CSR_FNF,
                        `CSR_FNFH: csr_file[i] <= 'b0;
                        default: csr_file[i] <= 'b0;
                    endcase
                end
                else begin
                    if(csr_write_enable[i]) begin
                        case(i)
                            `CSR_MVENDORID,
                            `CSR_MARCHID,
                            `CSR_MIMPID,
                            `CSR_MHARTID,
                            `CSR_MCONFIGPTR: csr_file[i] <= csr_file[i];
                            `CSR_MSTATUS: csr_file[i] <= csr_write_data[i] & 'h88;
                            `CSR_MISA: csr_file[i] <= csr_file[i];
                            `CSR_MIE: csr_file[i] <= csr_write_data[i] & 'h888;
                            `CSR_MTVEC: csr_file[i] <= {csr_write_data[i][`REG_DATA_WIDTH - 1:2], 2'b00};
                            `CSR_MCOUNTEREN: csr_file[i] <= csr_write_data[i] & 'h7;
                            `CSR_MSTATUSH: csr_file[i] <= csr_file[i];
                            `CSR_MSCRATCH: csr_file[i] <= csr_write_data[i];
                            `CSR_MEPC: csr_file[i] <= {csr_write_data[i][`REG_DATA_WIDTH - 1:2], 2'b00};
                            `CSR_MCAUSE: csr_file[i] <= csr_write_data[i];
                            `CSR_MTVAL: csr_file[i] <= csr_write_data[i];
                            `CSR_MIP: csr_file[i] <= intif_csrf_mip_data;
                            `CSR_CHARFIFO: csr_file[i] <= 'b0;
                            `CSR_FINISH: csr_file[i] <= csr_write_data[i];
                            `CSR_UARTFIFO: csr_file[i] <= {uart_send ? 1'b1 : uart_send_busy, uart_rev_data_invalid ? 1'b0 : uart_rev_data_valid ? 1'b1 : csr_file[i][30], 22'b0, uart_rev_data_valid ? uart_rev_data : csr_file[i][7:0]};
                            `CSR_MCYCLE,
                            `CSR_MINSTRET,
                            `CSR_MCYCLEH,
                            `CSR_MINSTRETH: csr_file[i] <= csr_write_data[i];
                            `CSR_BRANCHNUM: csr_file[i] <= csr_branchnum_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_BRANCHNUMH: csr_file[i] <= csr_branchnum_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_BRANCHPREDICTED: csr_file[i] <= csr_branchpredicted_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_BRANCHPREDICTEDH: csr_file[i] <= csr_branchpredicted_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_BRANCHHIT: csr_file[i] <= csr_branchhit_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_BRANCHHITH: csr_file[i] <= csr_branchhit_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_BRANCHMISS: csr_file[i] <= csr_branchmiss_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_BRANCHMISSH: csr_file[i] <= csr_branchmiss_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_FD: csr_file[i] <= csr_fd_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_FDH: csr_file[i] <= csr_fd_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_DR: csr_file[i] <= csr_dr_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_DRH: csr_file[i] <= csr_dr_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_IQ: csr_file[i] <= csr_iq_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_IQH: csr_file[i] <= csr_iq_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_IE: csr_file[i] <= csr_ie_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_IEH: csr_file[i] <= csr_ie_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_CB: csr_file[i] <= csr_cb_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_CBH: csr_file[i] <= csr_cb_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_ROB: csr_file[i] <= csr_rob_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_ROBH: csr_file[i] <= csr_rob_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_PHY: csr_file[i] <= csr_phy_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_PHYH: csr_file[i] <= csr_phy_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_RAS: csr_file[i] <= csr_ras_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_RASH: csr_file[i] <= csr_ras_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_FNF: csr_file[i] <= csr_fnf_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_FNFH: csr_file[i] <= csr_fnf_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            default: csr_file[i] <= csr_file[i];
                        endcase
                    end
                    else begin
                        case(i)
                            `CSR_MVENDORID,
                            `CSR_MARCHID,
                            `CSR_MIMPID,
                            `CSR_MHARTID,
                            `CSR_MCONFIGPTR,
                            `CSR_MSTATUS,
                            `CSR_MISA,
                            `CSR_MIE,
                            `CSR_MTVEC,
                            `CSR_MCOUNTEREN,
                            `CSR_MSTATUSH,
                            `CSR_MSCRATCH,
                            `CSR_MEPC,
                            `CSR_MCAUSE,
                            `CSR_MTVAL: csr_file[i] <= csr_file[i];
                            `CSR_MIP: csr_file[i] <= intif_csrf_mip_data;
                            `CSR_CHARFIFO,
                            `CSR_FINISH: csr_file[i] <= csr_file[i];
                            `CSR_UARTFIFO: csr_file[i] <= {uart_send ? 1'b1 : uart_send_busy, uart_rev_data_valid ? 1'b1 : uart_rev_data_invalid ? 1'b0 : csr_file[i][30], 22'b0, uart_rev_data_valid ? uart_rev_data : csr_file[i][7:0]};
                            `CSR_MCYCLE: csr_file[i] = csr_mcycle_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_MINSTRET: csr_file[i] <= csr_minstret_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_MCYCLEH: csr_file[i] <= csr_mcycle_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_MINSTRETH: csr_file[i] <= csr_minstret_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_BRANCHNUM: csr_file[i] <= csr_branchnum_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_BRANCHNUMH: csr_file[i] <= csr_branchnum_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_BRANCHPREDICTED: csr_file[i] <= csr_branchpredicted_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_BRANCHPREDICTEDH: csr_file[i] <= csr_branchpredicted_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_BRANCHHIT: csr_file[i] <= csr_branchhit_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_BRANCHHITH: csr_file[i] <= csr_branchhit_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_BRANCHMISS: csr_file[i] <= csr_branchmiss_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_BRANCHMISSH: csr_file[i] <= csr_branchmiss_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_FD: csr_file[i] <= csr_fd_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_FDH: csr_file[i] <= csr_fd_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_DR: csr_file[i] <= csr_dr_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_DRH: csr_file[i] <= csr_dr_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_IQ: csr_file[i] <= csr_iq_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_IQH: csr_file[i] <= csr_iq_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_IE: csr_file[i] <= csr_ie_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_IEH: csr_file[i] <= csr_ie_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_CB: csr_file[i] <= csr_cb_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_CBH: csr_file[i] <= csr_cb_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_ROB: csr_file[i] <= csr_rob_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_ROBH: csr_file[i] <= csr_rob_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_PHY: csr_file[i] <= csr_phy_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_PHYH: csr_file[i] <= csr_phy_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_RAS: csr_file[i] <= csr_ras_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_RASH: csr_file[i] <= csr_ras_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            `CSR_FNF: csr_file[i] <= csr_fnf_next[`REG_DATA_WIDTH - 1:0];
                            `CSR_FNFH: csr_file[i] <= csr_fnf_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                            default: csr_file[i] <= csr_file[i];
                        endcase
                    end
                end
            end
        end
    endgenerate

    generate
        for(i = 0;i < CSR_NUM;i++) begin
            assign csr_read_data[i] = csr_file[i];
        end
    endgenerate

    assign csrf_all_mie_data = csr_read_data[`CSR_MIE];
    assign csrf_all_mstatus_data = csr_read_data[`CSR_MSTATUS];
    assign csrf_all_mip_data = csr_read_data[`CSR_MIP];
    assign csrf_all_mepc_data = csr_read_data[`CSR_MEPC];

    assign uart_send_data = csr_write_data[`CSR_UARTFIFO][7:0];
    assign uart_send = csr_write_enable[`CSR_UARTFIFO] && !csr_write_data[`CSR_UARTFIFO][31];
    assign uart_rev_data_invalid = csr_write_enable[`CSR_UARTFIFO] && csr_write_data[`CSR_UARTFIFO][31];
endmodule