`include "config.svh"
`include "common.svh"

module clint(
        input logic clk,
        input logic rst,

        input logic[`ADDR_WIDTH - 1:0] bus_clint_read_addr,
        input logic[`ADDR_WIDTH - 1:0] bus_clint_write_addr,
        input logic[`SIZE_WIDTH - 1:0] bus_clint_read_size,
        input logic[`SIZE_WIDTH - 1:0] bus_clint_write_size,
        input logic[`REG_DATA_WIDTH - 1:0] bus_clint_data,
        input logic bus_clint_rd,
        input logic bus_clint_wr,
        output logic[`BUS_DATA_WIDTH - 1:0] clint_bus_data,

        output logic all_intif_int_software_req,
        output logic all_intif_int_timer_req
    );
    
    localparam logic[`ADDR_WIDTH - 1:0] MSIP_ADDR = 'b0;
    localparam logic[`ADDR_WIDTH - 1:0] MTIMECMP_ADDR = 'h4000;
    localparam logic[`ADDR_WIDTH - 1:0] MTIME_ADDR = 'hbff8;

    logic[`REG_DATA_WIDTH - 1:0] msip;
    logic[`REG_DATA_WIDTH - 1:0] msip_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] mtimecmp;
    logic[`REG_DATA_WIDTH * 2 - 1:0] mtimecmp_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] mtime;
    logic[`REG_DATA_WIDTH * 2 - 1:0] mtime_next;
    logic[`REG_DATA_WIDTH * 2 - 1:0] mtime_add_1;

    always_comb begin
        msip_next = msip;
        mtimecmp_next = mtimecmp;

        if(bus_clint_wr && (bus_clint_write_size == 'h4)) begin
            if(bus_clint_write_addr == MSIP_ADDR) begin
                msip_next = (bus_clint_data[0]) != 0;
            end
            else if(bus_clint_write_addr == MTIMECMP_ADDR) begin
                mtimecmp_next = {mtimecmp[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH], bus_clint_data};
            end
            else if(bus_clint_write_addr == (MTIMECMP_ADDR + 'h4)) begin
                mtimecmp_next = {bus_clint_data, mtimecmp[`REG_DATA_WIDTH - 1:0]};
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            msip <= 'b0;
            mtimecmp <= 'b0;
        end
        else if(bus_clint_wr && (bus_clint_write_size == 'h4)) begin
            if(bus_clint_write_addr == MSIP_ADDR) begin
                msip <= msip_next;
            end
            else if(bus_clint_write_addr == MTIMECMP_ADDR) begin
                mtimecmp <= mtimecmp_next;
            end
            else if(bus_clint_write_addr == (MTIMECMP_ADDR + 'h4)) begin
                mtimecmp <= mtimecmp_next;
            end
        end
    end

    assign mtime_add_1 = mtime + 1;

    always_comb begin
        mtime_next = mtime;

        if(bus_clint_wr && (bus_clint_write_size == 'h4)) begin 
            if(bus_clint_write_addr == MTIME_ADDR) begin
                mtime_next = {mtime_add_1[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH], bus_clint_data};
            end
            else if(bus_clint_write_addr == (MTIME_ADDR + 'h4)) begin
                mtime_next = {bus_clint_data, mtime_add_1[`REG_DATA_WIDTH - 1:0]};
            end
            else begin
                mtime_next = mtime_add_1;
            end
        end
        else begin
            mtime_next = mtime_add_1;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            mtime <= 'b0;
        end
        else begin
            mtime <= mtime_next;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            clint_bus_data <= 'b0;
        end
        else if(bus_clint_rd && (bus_clint_read_size == 'h4)) begin
            case(bus_clint_read_addr)
                MSIP_ADDR: clint_bus_data <= msip_next;
                MTIMECMP_ADDR: clint_bus_data <= mtimecmp_next[`REG_DATA_WIDTH - 1:0];
                (MTIMECMP_ADDR + 'h4): clint_bus_data <= mtimecmp_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                MTIME_ADDR: clint_bus_data <= mtime_next[`REG_DATA_WIDTH - 1:0];
                (MTIME_ADDR + 'h4): clint_bus_data <= mtime_next[`REG_DATA_WIDTH * 2 - 1:`REG_DATA_WIDTH];
                default: clint_bus_data = 'b0;
            endcase
        end
    end

    assign all_intif_int_timer_req = mtime >= mtimecmp;
    assign all_intif_int_software_req = msip[0];
endmodule