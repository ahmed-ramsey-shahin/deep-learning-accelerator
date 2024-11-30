`timescale 1ns/1ps

module Processing_Element_tb ();
    localparam WIDTH = 8;
    reg                CLK = 0;
    reg                RST;
    reg                Load;
    reg  [WIDTH-1:0]   Input;
    reg  [WIDTH-1:0]   Weight;
    reg  [2*WIDTH-1:0] PsumIn;
    wire [WIDTH-1:0]   ToRight;
    wire [WIDTH-1:0]   ToDown;
    wire [2*WIDTH-1:0] PsumOut;
    
    always #10 CLK = ~CLK;

    Processing_Element #(WIDTH) DUT (
        .CLK(CLK),
        .RST(RST),
        .Input(Input),
        .Weight(Weight),
        .PsumIn(PsumIn),
        .PsumOut(PsumOut),
        .ToRight(ToRight),
        .ToDown(ToDown),
        .Load(Load)
    );

    initial begin
        RST = 1'b0;
        #2;
        RST = 1'b1;
        Weight = 8'd5;
        @(negedge CLK) Load = 1'b1;
        @(negedge CLK) Load = 1'b0;
        Input = 8'd6;
        PsumIn = 8'd15;
        #10;
        $display("(%d x %d) + %d = %d", Weight, Input, PsumIn, PsumOut);
        $stop;
    end
endmodule
