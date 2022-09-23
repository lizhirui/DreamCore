`include "config.svh"
`include "common.svh"

module csr_access_check #(
        parameter WRITE_PREMISSION = 0
    )(
        input logic[`CSR_ADDR_WIDTH - 1:0] csr_addr,
        output logic valid
    );

    always_comb begin
        case(csr_addr)
            `CSR_MVENDORID,
            `CSR_MARCHID,
            `CSR_MIMPID,
            `CSR_MHARTID,
            `CSR_MCONFIGPTR: valid = !WRITE_PREMISSION;
            `CSR_MSTATUS,
            `CSR_MISA,
            `CSR_MIE,
            `CSR_MTVEC,
            `CSR_MCOUNTEREN,
            `CSR_MSTATUSH,
            `CSR_MSCRATCH,
            `CSR_MEPC,
            `CSR_MCAUSE,
            `CSR_MTVAL,
            `CSR_MIP,
            `CSR_CHARFIFO,
            `CSR_FINISH,
            `ifndef SIMULATOR
            `CSR_UARTFIFO,
            `endif
            `ifdef SIMULATOR_UARTFIFO
            `CSR_UARTFIFO,
            `endif
            `CSR_MCYCLE,
            `CSR_MINSTRET,
            `CSR_MCYCLEH,
            `CSR_MINSTRETH: valid = 'b1;
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
            `CSR_FNFH: valid = !WRITE_PREMISSION;
            default: valid = 'b0;
        endcase
    end
endmodule