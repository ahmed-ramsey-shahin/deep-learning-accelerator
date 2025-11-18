`timescale 1ns/1ps

module Unified_Buffer_tb();
    parameter  integer SA_LENGTH=2;
    parameter  integer ADDR_WIDTH=3;
    parameter  integer NO_BANKS=4;
    localparam integer DataWidth=8*SA_LENGTH;
    localparam integer AddrWidth=ADDR_WIDTH+$clog2(NO_BANKS);

    bit                   CLK;
    logic                 ASYNC_RST;
    logic                 SYNC_RST;
    logic                 EN;
    logic                 wren;
    logic [AddrWidth-1:0] wraddr;
    logic [DataWidth-1:0] wrdata;
    logic [AddrWidth-1:0] rdaddr;
    logic [DataWidth-1:0] rddata;

    always #5 CLK = ~CLK;

    Unified_Buffer #(
		.NO_BANKS(NO_BANKS),
		.SA_LENGTH(SA_LENGTH),
		.ADDR_WIDTH(ADDR_WIDTH)
    ) DUT (.*);

    initial begin
        ASYNC_RST = 1'b0;
        SYNC_RST  = 1'b0;
        EN        = 1'b0;
        wren      = 1'b0;
        wraddr    = 0;
        wrdata    = 0;
        rdaddr    = 0;
        #2;
        ASYNC_RST = 1'b1;
        EN        = 1'b1;
        @(negedge CLK);
        wren      = 1'b1;
        wraddr    = 5'b00000;
        wrdata    = 'd1;
        @(negedge CLK);
        wraddr    = 5'b00100;
        wrdata    = 'd2;
        @(negedge CLK);
        wraddr    = 5'b00001;
        wrdata    = 'd3;
        @(negedge CLK);
        wraddr    = 5'b00101;
        wrdata    = 'd4;
        @(negedge CLK);
        wren      = 1'b0;
        rdaddr    = 5'b00000;
        @(negedge CLK);
        rdaddr    = 5'b00100;
        @(negedge CLK);
        rdaddr    = 5'b00001;
        @(negedge CLK);
        rdaddr    = 'b000101;
        @(negedge CLK);
        $stop;
    end
endmodule

