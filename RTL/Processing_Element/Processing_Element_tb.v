`timescale 1ns/1ps

module Processing_Element_tb ();
    localparam int DATA_WIDTH             = 8;
    localparam int ACCUMULATOR_DATA_WIDTH = 32;
    reg                                      CLK;
    reg                                      ASYNC_RST;
    reg                                      SYNC_RST;
    reg                                      EN;
    reg                                      LOAD;
    reg  signed [DATA_WIDTH-1:0]             Input;
    reg  signed [ACCUMULATOR_DATA_WIDTH-1:0] PsumIn;
    wire signed [DATA_WIDTH-1:0]             ToRight;
    wire signed [ACCUMULATOR_DATA_WIDTH-1:0] PsumOut;

    Processing_Element #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACCUMULATOR_DATA_WIDTH(ACCUMULATOR_DATA_WIDTH)
    ) DUT (
        .CLK       (CLK),
        .ASYNC_RST (ASYNC_RST),
        .SYNC_RST  (SYNC_RST),
        .EN        (EN),
        .LOAD      (LOAD),
        .Input     (Input),
        .ToRight   (ToRight),
        .PsumIn    (PsumIn),
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
        SYNC_RST  = 1'b0;
        LOAD      = 1'b0;
        EN        = 1'b0;
        PsumIn    = 'd0;
        Input     = 'b0;
        #2;
        ASYNC_RST = 1'b1;
        @(negedge CLK);
        LOAD      = 1'b1;
        Input     = 'd50;
        @(negedge CLK);
        LOAD      = 1'b0;
        EN        = 1'b1;
        Input     = 'd4;
        PsumIn    = 'd1;
        repeat(2) @(negedge CLK);
        $stop;
    end
endmodule

