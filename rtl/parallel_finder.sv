`include "config.svh"
`include "common.svh"

module parallel_finder #(
        parameter WIDTH = 1//must be the power of 2
    )(
        input logic[WIDTH - 1:0] data_in,
        output logic[$clog2(WIDTH) - 1:0] index,
        output logic index_valid
    );

    genvar i;

    logic[$clog2(WIDTH) - 1:0] index_temp[0:WIDTH - 1];

    assign index_temp[0] = 'b0;

    generate
        for(i = 1;i < WIDTH;i++) begin
            assign index_temp[i] = index_temp[i - 1] | (data_in[i] ? i : 'b0);
        end
    endgenerate

    assign index = index_temp[WIDTH - 1];
    assign index_valid = |data_in;
endmodule