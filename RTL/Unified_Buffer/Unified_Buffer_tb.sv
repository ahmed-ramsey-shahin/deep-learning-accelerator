`timescale 1ns/1ps

module Unified_Buffer_tb ();
    localparam integer DATA_WIDTH=8;
    localparam integer NUM_BANKS=16;
    localparam integer BANK_DEPTH=16;
    localparam integer ROW_BITS   = $clog2(BANK_DEPTH);
    integer bank;

    reg                          CLK;
    reg                          ASYNC_RST;
    reg                          SYNC_RST;
    reg                          EN;
    reg                          PortOneReadValid    [NUM_BANKS];
    reg                          PortTwoReadValid    [NUM_BANKS];
    reg                          PortOneWriteValid   [NUM_BANKS];
    reg                          PortTwoWriteValid   [NUM_BANKS];
    reg         [ROW_BITS-1:0]   PortOneReadAddress  [NUM_BANKS];
    reg         [ROW_BITS-1:0]   PortTwoReadAddress  [NUM_BANKS];
    reg         [ROW_BITS-1:0]   PortOneWriteAddress [NUM_BANKS];
    reg         [ROW_BITS-1:0]   PortTwoWriteAddress [NUM_BANKS];
    reg  signed [DATA_WIDTH-1:0] PortOneWriteData    [NUM_BANKS];
    reg  signed [DATA_WIDTH-1:0] PortTwoWriteData    [NUM_BANKS];
    wire signed [DATA_WIDTH-1:0] PortOneReadData     [NUM_BANKS];
    wire signed [DATA_WIDTH-1:0] PortTwoReadData     [NUM_BANKS];

    always begin
        CLK = 1'b0;
        #5;
        CLK = 1'b1;
        #5;
    end

    Unified_Buffer #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_BANKS(NUM_BANKS),
        .BANK_DEPTH(BANK_DEPTH)
    ) DUT (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(EN),
        .PortOneWriteData(PortOneWriteData),
        .PortOneWriteAddress(PortOneWriteAddress),
        .PortOneWriteValid(PortOneWriteValid),
        .PortOneReadAddress(PortOneReadAddress),
        .PortOneReadData(PortOneReadData),
        .PortOneReadValid(PortOneReadValid),
        .PortTwoWriteData(PortTwoWriteData),
        .PortTwoWriteAddress(PortTwoWriteAddress),
        .PortTwoWriteValid(PortTwoWriteValid),
        .PortTwoReadAddress(PortTwoReadAddress),
        .PortTwoReadData(PortTwoReadData),
        .PortTwoReadValid(PortTwoReadValid)
    );

    initial begin
        // reset
        ASYNC_RST = 1'b0;
        SYNC_RST  = 1'b0;
        EN        = 1'b1;
        for (bank = 0; bank < NUM_BANKS; bank++) begin
            PortOneWriteValid[bank]   = 1'b0;
            PortOneWriteAddress[bank] = 1'b0;
            PortOneWriteData[bank]    = 1'b0;
            PortTwoWriteValid[bank]   = 1'b0;
            PortTwoWriteAddress[bank] = 1'b0;
            PortTwoWriteData[bank]    = 1'b0;
            PortOneReadValid[bank]    = 1'b0;
            PortOneReadAddress[bank]  = 1'b0;
            PortTwoReadValid[bank]    = 1'b0;
            PortTwoReadAddress[bank]  = 1'b0;
        end
        #2;
        ASYNC_RST = 1'b1;
        // test case 1
        @(negedge CLK);
        PortOneWriteValid[5]   = 1'b1;
        PortOneWriteData[5]    = 'd120;
        PortOneWriteAddress[5] = 'b0010;
        // test case 2
        @(negedge CLK);
        PortOneWriteValid[5]   = 1'b0;
        PortTwoWriteValid[3]   = 1'b1;
        PortTwoWriteData[3]    = 'd101;
        PortTwoWriteAddress[3] = 'b1001;
        // test case 3
        @(negedge CLK);
        PortOneWriteValid[3]   = 1'b1;
        PortOneWriteData[3]    = 'd120;
        PortOneWriteAddress[3] = 'b0010;
        PortTwoWriteAddress[3] = 'b1010;
        PortTwoWriteData[3]    = 'd95;
        // test case 4
        @(negedge CLK);
        PortOneWriteValid[3]   = 1'b0;
        PortTwoWriteValid[3]   = 1'b0;
        PortOneReadValid[3]    = 1'b1;
        PortTwoReadValid[5]    = 1'b1;
        PortOneReadAddress[3]  = 'b1010;
        PortTwoReadAddress[5]  = 'b0010;
        @(negedge CLK);
        $stop;
    end
endmodule

