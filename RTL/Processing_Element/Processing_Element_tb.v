`timescale 1ns/1ps

module Processing_Element_tb ();
    localparam WIDTH = 8;
    reg                CLK;
    reg                ASYNC_RST;
    reg                SYNC_RST;
    reg                EN;
    reg  [WIDTH-1:0]   InputIn;
    reg  [WIDTH-1:0]   WeightIn;
    wire [WIDTH-1:0]   InputOut;
    wire [WIDTH-1:0]   WeightOut;
    wire [2*WIDTH-1:0] Result;

    Processing_Element DUT (
        .CLK       (CLK),
        .ASYNC_RST (ASYNC_RST),
        .SYNC_RST  (SYNC_RST),
        .EN        (EN),
        .InputIn   (InputIn),
        .WeightIn  (WeightIn),
        .InputOut  (InputOut),
        .WeightOut (WeightOut),
        .Result    (Result)
    );

    always begin
        CLK = 1'b1;
        #10;
        CLK = 1'b0;
        #10;
    end

    initial begin
        ASYNC_RST = 1'b0;
        InputIn     = 8'd0;
        WeightIn    = 8'd0;
        #2;
        ASYNC_RST = 1'b1;
        @(negedge CLK);
        InputIn  = 8'd5;
        WeightIn = 8'd3;
        EN     = 1'b1;
        @(negedge CLK);
        InputIn  = 8'd7;
        WeightIn = 8'd2;
        EN     = 1'b1;
        repeat(2) @(negedge CLK);
        $stop;
    end
endmodule

