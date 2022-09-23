`include "config.svh"
`include "common.svh"

module bus(
        input logic clk,
        input logic rst,
        
        input logic[`ADDR_WIDTH - 1:0] fetch_bus_addr,
        input logic fetch_bus_read_req,
        output logic[`INSTRUCTION_WIDTH * `FETCH_WIDTH - 1:0] bus_fetch_data,
        output logic bus_fetch_read_ack,
        
        input logic[`ADDR_WIDTH - 1:0] stbuf_bus_read_addr,
        input logic[`ADDR_WIDTH - 1:0] stbuf_bus_write_addr,
        input logic[`SIZE_WIDTH - 1:0] stbuf_bus_read_size,
        input logic[`SIZE_WIDTH - 1:0] stbuf_bus_write_size,
        input logic[`REG_DATA_WIDTH - 1:0] stbuf_bus_data,
        input logic stbuf_bus_read_req,
        input logic stbuf_bus_write_req,
        output logic[`REG_DATA_WIDTH - 1:0] bus_stbuf_data,
        output logic bus_stbuf_read_ack,
        output logic bus_stbuf_write_ack,
        
        output logic[`ADDR_WIDTH - 1:0] bus_tcm_fetch_addr,
        output logic bus_tcm_fetch_rd,
        input logic[`BUS_DATA_WIDTH - 1:0] tcm_bus_fetch_data,

        output logic[`ADDR_WIDTH - 1:0] bus_tcm_stbuf_read_addr,
        output logic[`ADDR_WIDTH - 1:0] bus_tcm_stbuf_write_addr,
        output logic[`SIZE_WIDTH - 1:0] bus_tcm_stbuf_read_size,
        output logic[`SIZE_WIDTH - 1:0] bus_tcm_stbuf_write_size,
        output logic[`REG_DATA_WIDTH - 1:0] bus_tcm_stbuf_data,
        output logic bus_tcm_stbuf_rd,
        output logic bus_tcm_stbuf_wr,
        input logic[`BUS_DATA_WIDTH - 1:0] tcm_bus_stbuf_data,
        
        output logic[`ADDR_WIDTH - 1:0] bus_clint_read_addr,
        output logic[`ADDR_WIDTH - 1:0] bus_clint_write_addr,
        output logic[`SIZE_WIDTH - 1:0] bus_clint_read_size,
        output logic[`SIZE_WIDTH - 1:0] bus_clint_write_size,
        output logic[`REG_DATA_WIDTH - 1:0] bus_clint_data,
        output logic bus_clint_rd,
        output logic bus_clint_wr,
        input logic[`BUS_DATA_WIDTH - 1:0] clint_bus_data
    );
    
    logic bus_tcm_fetch_rd_r;
    logic bus_tcm_stbuf_rd_r;
    logic bus_clint_rd_r;

    assign bus_tcm_fetch_addr = fetch_bus_addr - `TCM_ADDR;
    assign bus_tcm_fetch_rd = fetch_bus_read_req && (fetch_bus_addr >= `TCM_ADDR) && (fetch_bus_addr < (`TCM_ADDR + `TCM_SIZE));

    always_ff @(posedge clk) begin
        if(rst) begin
            bus_tcm_fetch_rd_r <= 'b0;
        end
        else begin
            bus_tcm_fetch_rd_r <= bus_tcm_fetch_rd;
        end
    end

    assign bus_fetch_data = bus_tcm_fetch_rd_r ? tcm_bus_fetch_data : 'b0;

    always_ff @(posedge clk) begin
        if(rst) begin
            bus_fetch_read_ack <= 'b0;
        end
        else begin
            bus_fetch_read_ack <= fetch_bus_read_req;
        end
    end

    assign bus_tcm_stbuf_read_addr = stbuf_bus_read_addr - `TCM_ADDR;
    assign bus_tcm_stbuf_write_addr = stbuf_bus_write_addr - `TCM_ADDR;
    assign bus_tcm_stbuf_read_size = stbuf_bus_read_size;
    assign bus_tcm_stbuf_write_size = stbuf_bus_write_size;
    assign bus_tcm_stbuf_data = stbuf_bus_data;
    assign bus_tcm_stbuf_rd = stbuf_bus_read_req && (stbuf_bus_read_addr >= `TCM_ADDR) && (stbuf_bus_read_addr < (`TCM_ADDR + `TCM_SIZE));
    assign bus_tcm_stbuf_wr = stbuf_bus_write_req && (stbuf_bus_write_addr >= `TCM_ADDR) && (stbuf_bus_write_addr < (`TCM_ADDR + `TCM_SIZE));

    assign bus_clint_read_addr = stbuf_bus_read_addr - `CLINT_ADDR;
    assign bus_clint_write_addr = stbuf_bus_write_addr - `CLINT_ADDR;
    assign bus_clint_read_size = stbuf_bus_read_size;
    assign bus_clint_write_size = stbuf_bus_write_size;
    assign bus_clint_data = stbuf_bus_data;
    assign bus_clint_rd = stbuf_bus_read_req && (stbuf_bus_read_addr >= `CLINT_ADDR) && (stbuf_bus_read_addr < (`CLINT_ADDR + `CLINT_SIZE));
    assign bus_clint_wr = stbuf_bus_write_req && (stbuf_bus_write_addr >= `CLINT_ADDR) && (stbuf_bus_write_addr < (`CLINT_ADDR + `CLINT_SIZE));

    always_ff @(posedge clk) begin
        if(rst) begin
            bus_tcm_stbuf_rd_r <= 'b0;
            bus_clint_rd_r <= 'b0;
        end
        else begin
            bus_tcm_stbuf_rd_r <= bus_tcm_stbuf_rd;
            bus_clint_rd_r <= bus_clint_rd;
        end
    end

    assign bus_stbuf_data = bus_tcm_stbuf_rd_r ? tcm_bus_stbuf_data : 
                            bus_clint_rd_r ? clint_bus_data : 'b0;

    always_ff @(posedge clk) begin
        if(rst) begin
            bus_stbuf_read_ack <= 'b0;
        end
        else begin
            bus_stbuf_read_ack <= stbuf_bus_read_req;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            bus_stbuf_write_ack <= 'b0;
        end
        else begin
            bus_stbuf_write_ack <= stbuf_bus_write_req;
        end
    end
endmodule