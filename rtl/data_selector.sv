`include "config.svh"
`include "common.svh"

module data_selector #(
        parameter SEL_WIDTH = 5,
        parameter DATA_WIDTH = 5
    )(
        input logic[SEL_WIDTH - 1:0] sel_in,
        input logic[DATA_WIDTH - 1:0] data_in[0:SEL_WIDTH - 1],
        output logic[DATA_WIDTH - 1:0] data_out,
        output data_out_valid
    );

    logic[DATA_WIDTH - 1:0] data_in_filter[0:SEL_WIDTH - 1];
    logic[DATA_WIDTH - 1:0] data_out_temp[0:SEL_WIDTH - 1];

    genvar i;

    generate
        for(i = 0;i < SEL_WIDTH;i++) begin
            assign data_in_filter[i] = sel_in[i] ? data_in[i] : 'b0;

            if(i == 0) begin
                assign data_out_temp[i] = data_in_filter[i];
            end
            else begin
                assign data_out_temp[i] = data_out_temp[i - 1] | data_in_filter[i];
            end
        end
    endgenerate

    assign data_out = data_out_temp[SEL_WIDTH - 1];
    assign data_out_valid = |sel_in;
endmodule