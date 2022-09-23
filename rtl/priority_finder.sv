`include "config.svh"
`include "common.svh"

module priority_finder #(
        parameter FIRST_PRIORITY = 1,
        parameter WIDTH = 1//must be the power of 2
    )(
        input logic[WIDTH - 1:0] data_in,
        output logic[`max($clog2(WIDTH) - 1, 0):0] index,
        output logic index_valid
    );

    genvar i;

    logic[`max($clog2(WIDTH) - 1, 0):0] index_temp[0:WIDTH - 1];
    logic[WIDTH - 1:0] index_valid_temp;

    assign index_temp[0] = 'd0;
    assign index_valid_temp[0] = data_in[0];

    for(i = 1;i < WIDTH;i++) begin
        if(FIRST_PRIORITY) begin
            assign index_temp[i] = index_valid_temp[i - 1] ? index_temp[i - 1] : i;
            assign index_valid_temp[i] = index_valid_temp[i - 1] ? 'b1 : data_in[i]; 
        end
        else begin
            assign index_temp[i] = data_in[i] ? i : index_temp[i - 1];
            assign index_valid_temp[i] = data_in[i] ? 'b1 : index_valid_temp[i - 1];
        end
    end

    assign index = index_temp[WIDTH - 1];
    assign index_valid = index_valid_temp[WIDTH - 1];
endmodule