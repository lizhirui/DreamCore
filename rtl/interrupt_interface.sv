`include "config.svh"
`include "common.svh"

module interrupt_interface(
        input logic clk,
        input logic rst,
        
        input logic all_intif_int_ext_req,
        input logic all_intif_int_software_req,
        input logic all_intif_int_timer_req,
        
        output logic intif_all_int_ext_ack,
        output logic intif_all_int_software_ack,
        output logic intif_all_int_timer_ack,
        
        input logic[`REG_DATA_WIDTH - 1:0] csrf_all_mie_data,
        input logic[`REG_DATA_WIDTH - 1:0] csrf_all_mstatus_data,
        input logic[`REG_DATA_WIDTH - 1:0] csrf_all_mip_data,
        output logic[`REG_DATA_WIDTH - 1:0] intif_csrf_mip_data,
        
        output logic intif_commit_has_interrupt,
        output logic[`REG_DATA_WIDTH - 1:0] intif_commit_mcause_data,
        output logic[`REG_DATA_WIDTH - 1:0] intif_commit_ack_data,
        input logic[`REG_DATA_WIDTH - 1:0] commit_intif_ack_data
    );

    logic meip;
    logic msip;
    logic mtip;
    logic mei_ack;
    logic msi_ack;
    logic mti_ack;
    logic[2:0] new_ack;

    logic mei_has_interrupt;
    logic msi_has_interrupt;
    logic mti_has_interrupt;

    always_comb begin
        new_ack = 'b0;

        case('b1)
            commit_intif_ack_data[`MIP_MEIP]: new_ack[0] = 'b1;
            commit_intif_ack_data[`MIP_MSIP]: new_ack[1] = 'b1;
            commit_intif_ack_data[`MIP_MTIP]: new_ack[2] = 'b1;
        endcase
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            mei_ack <= 'b0;
            msi_ack <= 'b0;
            mti_ack <= 'b0;
        end
        else begin
            {mti_ack, msi_ack, mei_ack} <= new_ack;
        end
    end

    assign intif_all_int_ext_ack = new_ack[0];
    assign intif_all_int_software_ack = new_ack[1];
    assign intif_all_int_timer_ack = new_ack[2];

    always_comb begin
        intif_csrf_mip_data = 'b0;
        intif_csrf_mip_data[`MIP_MEIP] = all_intif_int_ext_req;
        intif_csrf_mip_data[`MIP_MSIP] = all_intif_int_software_req;
        intif_csrf_mip_data[`MIP_MTIP] = all_intif_int_timer_req;
    end

    assign mei_has_interrupt = all_intif_int_ext_req & csrf_all_mie_data[`MIP_MEIP];
    assign msi_has_interrupt = all_intif_int_software_req & csrf_all_mie_data[`MIP_MSIP];
    assign mti_has_interrupt = all_intif_int_timer_req & csrf_all_mie_data[`MIP_MTIP];

    assign intif_commit_has_interrupt = csrf_all_mstatus_data[`MSTATUS_MIE] & (mei_has_interrupt | msi_has_interrupt | mti_has_interrupt);

    always_comb begin
        intif_commit_mcause_data = 'b0;

        if(csrf_all_mstatus_data[`MSTATUS_MIE]) begin
            case('b1)
                mei_has_interrupt: intif_commit_mcause_data = riscv_interrupt_t::machine_external;
                msi_has_interrupt: intif_commit_mcause_data = riscv_interrupt_t::machine_software;
                mti_has_interrupt: intif_commit_mcause_data = riscv_interrupt_t::machine_timer;
            endcase
        end
    end

    always_comb begin
        intif_commit_ack_data = 'b0;

        if(csrf_all_mstatus_data[`MSTATUS_MIE]) begin
            case('b1)
                mei_has_interrupt: intif_commit_ack_data[`MIP_MEIP] = 'b1;
                msi_has_interrupt: intif_commit_ack_data[`MIP_MSIP] = 'b1;
                mti_has_interrupt: intif_commit_ack_data[`MIP_MTIP] = 'b1;
            endcase
        end
    end
endmodule