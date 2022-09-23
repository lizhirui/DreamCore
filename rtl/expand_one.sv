`include "config.svh"
`include "common.svh"

module expand_one #(
        parameter WIDTH = 4
    )(
        input logic[$clog2(WIDTH):0] data_in,
        output logic[WIDTH - 1:0] data_out
    );

    genvar i;

    generate
        for(i = 0;i < WIDTH;i++) begin
            assign data_out[i] = unsigned'(i) < data_in;
        end
    endgenerate
endmodule