`include "config.svh"
`include "common.svh"

module handshake_dff #(
        parameter WIDTH = 1
    )(
        input logic clk,
        input logic rst,
        
        input logic[WIDTH - 1:0] data_in,
        input logic push,
        output logic full,
        input logic flush,
        
        output logic[WIDTH - 1:0] data_out,
        output logic data_out_valid,
        input logic pop,
        output logic empty
    );

    logic has_data;
    logic[WIDTH - 1:0] data;

    always_ff @(posedge clk) begin
        if(rst | flush) begin
            has_data <= 'b0;
            data <= 'b0;
        end
        else if(push && !full) begin
            has_data <= 'b1;
            data <= data_in;
        end
        else if(pop && !empty) begin
            has_data <= 'b0;
        end
    end

    assign full = has_data & !pop;
    assign empty = !has_data;
    assign data_out_valid = has_data;
    assign data_out = data;
endmodule