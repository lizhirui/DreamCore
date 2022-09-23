`include "config.svh"
`include "common.svh"

module count_one #(
        parameter CONTINUOUS = 1,
        parameter WIDTH = 5
    )(
        input logic[WIDTH - 1:0] data_in,
        output logic[$clog2(WIDTH):0] sum
    );

    logic[$clog2(WIDTH):0] sum_temp[0:WIDTH - 1];
    logic[WIDTH - 1:0] found_blank;

    genvar i;

    generate
        if(CONTINUOUS) begin
            assign found_blank[0] = !data_in[0];
        end
        else begin
            assign found_blank[0] = 'b0;
        end

        assign sum_temp[0] = data_in[0];

        for(i = 1;i < WIDTH;i++) begin
            if(CONTINUOUS) begin
                assign found_blank[i] = found_blank[i - 1] | !data_in[i];
            end
            else begin
                assign found_blank[i] = 'b0;
            end

            assign sum_temp[i] = sum_temp[i - 1] + (found_blank[i - 1] ? 'b0 : data_in[i]);
        end
    endgenerate

    assign sum = sum_temp[WIDTH - 1];
endmodule