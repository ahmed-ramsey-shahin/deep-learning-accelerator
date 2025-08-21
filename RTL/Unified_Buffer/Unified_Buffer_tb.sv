`timescale 1ns/1ps

module Unified_Buffer_tb ();
    localparam integer DATA_WIDTH=8;
    localparam integer NUM_BANKS=16;
    localparam integer BANK_DEPTH=16;
    localparam integer BANK_BITS  = $clog2(NUM_BANKS);
    localparam integer ROW_BITS   = $clog2(BANK_DEPTH);
    localparam integer ADDR_WIDTH = BANK_BITS + ROW_BITS;

    reg                          CLK;
    reg                          ASYNC_RST;
    reg                          SYNC_RST;
    reg                          EN;
    reg                          ActivationReadValid;
    reg                          WeightReadValid;
    reg                          DmaWriteValid;
    reg                          WbWriteValid;
    reg         [ADDR_WIDTH-1:0] ActivationReadAddress;
    reg         [ADDR_WIDTH-1:0] WeightReadAddress;
    reg         [ADDR_WIDTH-1:0] DmaWriteAddress;
    reg         [ADDR_WIDTH-1:0] WbWriteAddress;
    reg  signed [DATA_WIDTH-1:0] DmaWriteData;
    reg  signed [DATA_WIDTH-1:0] WbWriteData;
    wire signed [DATA_WIDTH-1:0] ActivationReadData;
    wire signed [DATA_WIDTH-1:0] WeightReadData;

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
        .ActivationReadValid(ActivationReadValid),
        .WeightReadValid(WeightReadValid),
        .DmaWriteValid(DmaWriteValid),
        .WbWriteValid(WbWriteValid),
        .ActivationReadAddress(ActivationReadAddress),
        .WeightReadAddress(WeightReadAddress),
        .DmaWriteAddress(DmaWriteAddress),
        .WbWriteAddress(WbWriteAddress),
        .DmaWriteData(DmaWriteData),
        .WbWriteData(WbWriteData),
        .ActivationReadData(ActivationReadData),
        .WeightReadData(WeightReadData)
    );

    initial begin
        ASYNC_RST = 1'b0;
        SYNC_RST  = 1'b0;
        EN        = 1'b1;
        ActivationReadValid   = 1'b0;
        WeightReadValid       = 1'b0;
        DmaWriteValid         = 1'b0;
        WbWriteValid          = 1'b0;
        ActivationReadAddress = 'b0;
        WeightReadAddress     = 'b0;
        DmaWriteAddress       = 'b0;
        WbWriteAddress        = 'b0;
        DmaWriteData          = 'b0;
        WbWriteData           = 'b0;
        #2;
        ASYNC_RST             = 1'b1;
        @(negedge CLK);
        DmaWriteValid         = 1'b1;
        DmaWriteAddress       = 'b0010_0101;
        DmaWriteData          = 'd120;
        @(negedge CLK);
        DmaWriteValid         = 1'b0;
        WbWriteValid          = 1'b1;
        WbWriteAddress        = 'b1001_0011;
        WbWriteData           = 'd101;
        @(negedge CLK);
        DmaWriteValid         = 1'b1;
        WbWriteAddress        = 'b1010_0011;
        WbWriteData           = 'd95;
        DmaWriteAddress       = 'b0010_0011;
        DmaWriteData          = 'd120;
        @(negedge CLK);
        WbWriteAddress        = 'b0001_0011;
        WbWriteData           = 'd101;
        DmaWriteAddress       = 'b0010_0100;
        DmaWriteData          = 'd120;
        @(negedge CLK);
        DmaWriteValid         = 1'b0;
        WbWriteValid          = 1'b0;
        WeightReadValid       = 1'b1;
        ActivationReadValid   = 1'b1;
        WeightReadAddress     = 'b1001_0011;
        ActivationReadAddress = 'b1010_0011;
        @(negedge CLK);
        $stop;
    end
endmodule

