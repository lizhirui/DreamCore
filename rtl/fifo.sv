`include "config.svh"
`include "common.svh"

module fifo #(
        parameter WIDTH = 1,
        parameter DEPTH = 1
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

    localparam DEPTH_WIDTH = $clog2(DEPTH);

    logic[DEPTH_WIDTH:0] rptr;
    logic[DEPTH_WIDTH:0] wptr;
    logic[WIDTH - 1:0] buffer[0:DEPTH - 1];

    generate
        if(DEPTH_WIDTH == 0) begin
            assign full = wptr != rptr;
        end
        else begin
            assign full = (rptr[DEPTH_WIDTH - 1:0] == wptr[DEPTH_WIDTH - 1:0]) && (rptr[DEPTH_WIDTH] != wptr[DEPTH_WIDTH]);
        end
    endgenerate
    
    assign empty = (rptr == wptr) ? 'b1 : 'b0;

    always_ff @(posedge clk) begin
        if(rst | flush) begin
            wptr <= 'b0;
        end
        else if(!full && push) begin
            wptr <= wptr + 'b1;
        end
    end

    always_ff @(posedge clk) begin
        if(rst | flush) begin
            rptr <= 'b0;
        end
        else if(!empty && pop) begin
            rptr <= rptr + 'b1;
        end
    end

    generate
        if(DEPTH_WIDTH == 0) begin
            always_ff @(posedge clk) begin
                if(!rst && !full) begin
                    buffer[0] <= data_in;
                end
            end
        end
        else begin
            always_ff @(posedge clk) begin
                if(!rst && !full) begin
                    buffer[wptr[DEPTH_WIDTH - 1:0]] <= data_in;
                end
            end
        end
    endgenerate

    generate
        if(DEPTH_WIDTH == 0) begin
            assign data_out = buffer[0];
        end
        else begin
            assign data_out = buffer[rptr[DEPTH_WIDTH - 1:0]];
        end
    endgenerate
    
    assign data_out_valid = !empty;

endmodule