`include "config.svh"
`include "common.svh"

module execute_feedback(
        input execute_feedback_channel_t alu_execute_channel_feedback_pack[0:`ALU_UNIT_NUM - 1],
        input execute_feedback_channel_t bru_execute_channel_feedback_pack[0:`BRU_UNIT_NUM - 1],
        input execute_feedback_channel_t csr_execute_channel_feedback_pack[0:`CSR_UNIT_NUM - 1],
        input execute_feedback_channel_t div_execute_channel_feedback_pack[0:`DIV_UNIT_NUM - 1],
        input execute_feedback_channel_t lsu_execute_channel_feedback_pack[0:`LSU_UNIT_NUM - 1],
        input execute_feedback_channel_t mul_execute_channel_feedback_pack[0:`MUL_UNIT_NUM - 1],
        output execute_feedback_pack_t execute_feedback_pack
    );

    genvar i;

    generate
        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            assign execute_feedback_pack.channel[i] = alu_execute_channel_feedback_pack[i];
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            assign execute_feedback_pack.channel[`ALU_UNIT_NUM + i] = bru_execute_channel_feedback_pack[i];
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            assign execute_feedback_pack.channel[`ALU_UNIT_NUM + `BRU_UNIT_NUM + i] = csr_execute_channel_feedback_pack[i];
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            assign execute_feedback_pack.channel[`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + i] = div_execute_channel_feedback_pack[i];
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            assign execute_feedback_pack.channel[`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + i] = lsu_execute_channel_feedback_pack[i];
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            assign execute_feedback_pack.channel[`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + `LSU_UNIT_NUM + i] = mul_execute_channel_feedback_pack[i];
        end
    endgenerate

endmodule