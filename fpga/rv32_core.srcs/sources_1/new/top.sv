module top(
        input logic sys_clk_p,
        input logic sys_clk_n,
        input logic rxd,
        output logic txd
    );

    logic clk;
    logic vio_clk;
    logic rst;
    logic vio_rst;
    logic int_ext;
    logic vio_int_ext;

    clk_wiz_0 clk_wiz_0_inst(
        .clk_out1(clk),
        .clk_out2(vio_clk),
        .reset('b0),
        .locked(),
        // Clock in ports
        .clk_in1_p(sys_clk_p),
        .clk_in1_n(sys_clk_n)
    );
    
    vio_rst vio_rst_inst(
      .clk(vio_clk),                // input wire clk
      .probe_out0(vio_rst)  // output wire [0 : 0] probe_out0
    );
    
    vio_int_ext vio_int_ext_inst(
      .clk(vio_clk),                // input wire clk
      .probe_out0(vio_int_ext)  // output wire [0 : 0] probe_out0
    );
    
    fifo_generator_0 fifo_vio_inst(
      .wr_clk(vio_clk),  // input wire wr_clk
      .rd_clk(clk),  // input wire rd_clk
      .din({vio_int_ext, vio_rst}),        // input wire [1 : 0] din
      .wr_en(1'b1),    // input wire wr_en
      .rd_en(1'b1),    // input wire rd_en
      .dout({int_ext, rst}),      // output wire [1 : 0] dout
      .full(),      // output wire full
      .empty()    // output wire empty
    );
    
    core_top #(
        .IMAGE_PATH("/home/lizhirui/hs_disk/privwork/rtl_part/image/bootloader.hex"),
        .IMAGE_INIT(1)
    )core_top_inst(
        .clk(clk),
        .rst(rst),
        .int_ext(int_ext),
        .rxd(rxd),
        .txd(txd)
    );
endmodule
