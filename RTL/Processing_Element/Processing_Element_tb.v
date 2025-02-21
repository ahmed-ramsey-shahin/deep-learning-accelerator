`timescale 1ns/1ps

module Processing_Element_tb ();
    localparam WIDTH = 8;
    reg                CLK;
    reg                ASYNC_RST;
    reg                SYNC_RST;
    reg                EN;
    reg  [WIDTH-1:0]   Input;
    reg  [WIDTH-1:0]   Weight;
    reg  [2*WIDTH-1:0] PsumIn;
    wire [WIDTH-1:0]   ToRight;
    wire [WIDTH-1:0]   ToDown;
    wire [2*WIDTH:0]   PsumOut;

    Processing_Element DUT (
        .CLK       (CLK),
        .ASYNC_RST (ASYNC_RST),
        .SYNC_RST  (SYNC_RST),
        .EN        (EN),
        .Input     (Input),
        .Weight    (Weight),
        .PsumIn    (PsumIn),
        .ToRight   (ToRight),
        .ToDown    (ToDown),
        .PsumOut   (PsumOut)
    );

    always begin
        CLK = 1'b1;
        #10;
        CLK = 1'b0;
        #10;
    end

    initial begin
        ASYNC_RST = 1'b0;
        PsumIn    = 16'd0;
        Input     = 8'd0;
        Weight    = 8'd0;
        #2;
        ASYNC_RST = 1'b1;
        @(negedge CLK);
        Input  = 8'd5;
        Weight = 8'd3;
        EN     = 1'b1;
        @(negedge CLK);
        PsumIn = 16'd15;
        Input  = 8'd7;
        Weight = 8'd2;
        EN     = 1'b1;
        repeat(2) @(negedge CLK);
        $stop;
    end

endmodule
