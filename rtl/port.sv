`include "config.svh"
`include "common.svh"

module port #(
        parameter WIDTH = 1
    )(
        input logic clk,
        input logic rst,
        
        input logic[WIDTH - 1:0] data_in,
        input logic we,
        input logic flush,
        
        output logic[WIDTH - 1:0] data_out
    );

    always_ff @(posedge clk) begin
        if(rst | flush) begin
            data_out <= 'b0;
        end
        else if(we) begin
            data_out <= data_in;
        end
    end
endmodule