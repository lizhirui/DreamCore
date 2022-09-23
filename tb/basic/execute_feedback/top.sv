`include "config.svh"
`include "common.svh"

module top;
    execute_feedback_channel_t alu_execute_channel_feedback_pack[0:`ALU_UNIT_NUM - 1];
    execute_feedback_channel_t bru_execute_channel_feedback_pack[0:`BRU_UNIT_NUM - 1];
    execute_feedback_channel_t csr_execute_channel_feedback_pack[0:`CSR_UNIT_NUM - 1];
    execute_feedback_channel_t div_execute_channel_feedback_pack[0:`DIV_UNIT_NUM - 1];
    execute_feedback_channel_t lsu_execute_channel_feedback_pack[0:`LSU_UNIT_NUM - 1];
    execute_feedback_channel_t mul_execute_channel_feedback_pack[0:`MUL_UNIT_NUM - 1];
    execute_feedback_pack_t execute_feedback_pack;

    integer i;

    execute_feedback execute_feedback_inst(.*);

    task test;
        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            alu_execute_channel_feedback_pack[i].value = i;
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            bru_execute_channel_feedback_pack[i].value = `ALU_UNIT_NUM + i;
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            csr_execute_channel_feedback_pack[i].value = `ALU_UNIT_NUM + `BRU_UNIT_NUM + i;
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            div_execute_channel_feedback_pack[i].value = `ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + i;
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            lsu_execute_channel_feedback_pack[i].value = `ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + i;
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            mul_execute_channel_feedback_pack[i].value = `ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + `LSU_UNIT_NUM + i;
        end

        #10;

        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            assert(execute_feedback_pack.channel[i].value == i) else begin $display(execute_feedback_pack.channel[i].value, " - ", i); $finish; end
        end
    endtask

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