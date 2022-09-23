`include "config.svh"
`include "common.svh"

module list_enabled_item_id #(
        parameter ITEM_NUM = 8//must be the power of 2
    )(
        input logic[ITEM_NUM - 1:0] seq,
        input logic[`max($clog2(ITEM_NUM) - 1, 0):0] start_pos,
        output logic[`max($clog2(ITEM_NUM) - 1, 0):0] enabled_item_id[0:ITEM_NUM - 1]
    );

    logic[ITEM_NUM - 1:0] seq_shifted;
    logic[`max($clog2(ITEM_NUM) - 1, 0):0] seq_out_pos[0:ITEM_NUM - 1];
    logic[ITEM_NUM - 1:0] seq_out_pos_cmp[0:ITEM_NUM - 1];
    logic[`max($clog2(ITEM_NUM) - 1, 0):0] seq_out_pos_index[0:ITEM_NUM - 1];
    logic[`max($clog2(ITEM_NUM) - 1, 0):0] seq_out[0:ITEM_NUM - 1];
    logic[`max($clog2(ITEM_NUM) - 1, 0):0] seq_out_fix[0:ITEM_NUM - 1];

    genvar i, j;

    assign seq_shifted = ITEM_NUM'((seq >> start_pos) | (seq << (ITEM_NUM - start_pos)));
    
    generate
        assign seq_out_pos[0] = 'b0;

        for(i = 1;i < ITEM_NUM;i++) begin
            assign seq_out_pos[i] = seq_out_pos[i - 1] + seq_shifted[i - 1];
        end
    endgenerate

    generate
        for(i = 0;i < ITEM_NUM;i++) begin
            for(j = 0;j < ITEM_NUM;j++) begin
                assign seq_out_pos_cmp[i][j] = unsigned'(i) == seq_out_pos[j];
            end

            priority_finder #(
                .FIRST_PRIORITY(0),
                .WIDTH(ITEM_NUM)
            )priority_finder_seq_out_pos_inst(
                .data_in(seq_out_pos_cmp[i]),
                .index(seq_out_pos_index[i])
            );

            assign seq_out[i] = seq_out_pos_index[i];
            assign seq_out_fix[i] = `max($clog2(ITEM_NUM), 1)'(seq_out[i] + start_pos);
        end
    endgenerate

    assign enabled_item_id = seq_out_fix;
endmodule