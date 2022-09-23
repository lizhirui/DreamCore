module mem_dual_port_rw#(
        parameter WIDTH = 1,
        parameter DEPTH = 1,
        parameter WRITE_FIRST = 1,
        parameter INIT_FILE = "",
        parameter INIT = 0
    )(
        input logic clk,
        input logic rst,
        input logic[$clog2(DEPTH) - 1:0] read_addr,
        input logic rd,
        output logic[WIDTH - 1:0] read_data,
        input logic[$clog2(DEPTH) - 1:0] write_addr,
        input logic[WIDTH - 1:0] write_data,
        input logic we
    );

    logic[WIDTH - 1:0] mem[0:DEPTH - 1];
    logic[WIDTH - 1:0] out_data;

    logic[$clog2(DEPTH) - 1:0] read_addr_r;
    logic rd_r;
    logic[$clog2(DEPTH) - 1:0] write_addr_r;
    logic[WIDTH - 1:0] write_data_r;
    logic we_r;

    `ifdef SIMULATOR
        logic[WIDTH - 1:0] mem_copy[0:DEPTH - 1];

        generate
            if(INIT) begin
                initial begin
                    $readmemh(INIT_FILE, mem_copy, 0, DEPTH - 1);
                end
            end
        endgenerate
    `else
        generate
            if(INIT) begin
                initial begin
                    $readmemh(INIT_FILE, mem, 0, DEPTH - 1);
                end
            end
        endgenerate
    `endif

    always_ff @(posedge clk) begin
        if(rd) begin
            out_data <= mem[read_addr];
        end
    end

    generate
        if(WRITE_FIRST) begin
            always_ff @(posedge clk) begin
                if(rst) begin
                    read_addr_r <= 'b0;
                    rd_r <= 'b0;
                    write_addr_r <= 'b0;
                    write_data_r <= 'b0;
                    we_r <= 'b0;
                end
                else begin
                    read_addr_r <= read_addr;
                    rd_r <= rd;
                    write_addr_r <= write_addr;
                    write_data_r <= write_data;
                    we_r <= we;
                end
            end

            assign read_data = (rd_r && we_r && (write_addr_r == read_addr_r)) ? write_data_r : out_data;
        end
        else begin
            assign read_data = out_data;
        end
    endgenerate

    `ifdef SIMULATOR
        always_ff @(posedge clk) begin
            if(rst) begin
                mem <= mem_copy;
            end    
            else if(we) begin
                mem[write_addr] <= write_data; 
            end
        end
    `else
        always_ff @(posedge clk) begin
            if(we) begin
                mem[write_addr] <= write_data; 
            end
        end
    `endif
endmodule