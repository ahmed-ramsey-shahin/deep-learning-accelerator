`timescale 1ns/1ps

module Matrix_Multiply_Unit_tb ();
    localparam         WIDTH  = 8;
    localparam         LENGTH = 5;
    reg                CLK;
    reg                ASYNC_RST;
    reg                SYNC_RST;
    reg                EN;
    reg  [WIDTH-1:0]   Inputs  [0:LENGTH-1];
    reg  [WIDTH-1:0]   Weights [0:LENGTH-1];
    wire [2*WIDTH-1:0] PsumOut [0:LENGTH-1][0:LENGTH-1];
    integer i;
    integer j;

    always begin
        CLK = 1'b1;
        #5;
        CLK = 1'b0;
        #5;
    end

    Matrix_Multiply_Unit #(.WIDTH(WIDTH), .LENGTH(LENGTH)) DUT (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(EN),
        .Inputs(Inputs),
        .Weights(Weights),
        .PsumOut(PsumOut)
    );

    initial begin
        ASYNC_RST = 1'b0;
        EN        = 1'b0;
        SYNC_RST  = 1'b0;
        for (i = 0; i < LENGTH; i = i + 1) begin
            Inputs[i]  = 0;
            Weights[i] = 0;
        end
        #2;
        ASYNC_RST = 1'b1;
        @(negedge CLK);
        EN         = 1'b1;
        Inputs[0]  = 8'd1;
        Inputs[1]  = 8'd2;
        Inputs[2]  = 8'd3;
        Inputs[3]  = 8'd0;
        Inputs[4]  = 8'd0;
        Weights[0] = 8'd1;
        Weights[1] = 8'd2;
        Weights[2] = 8'd7;
        Weights[3] = 8'd0;
        Weights[4] = 8'd0;
        @(negedge CLK);
        Inputs[0]  = 8'd0;
        Inputs[1]  = 8'd4;
        Inputs[2]  = 8'd5;
        Inputs[3]  = 8'd6;
        Inputs[4]  = 8'd0;
        Weights[0] = 8'd0;
        Weights[1] = 8'd2;
        Weights[2] = 8'd4;
        Weights[3] = 8'd2;
        Weights[4] = 8'd0;
        @(negedge CLK);
        Inputs[0]  = 8'd0;
        Inputs[1]  = 8'd0;
        Inputs[2]  = 8'd7;
        Inputs[3]  = 8'd8;
        Inputs[4]  = 8'd9;
        Weights[0] = 8'd0;
        Weights[1] = 8'd0;
        Weights[2] = 8'd1;
        Weights[3] = 8'd6;
        Weights[4] = 8'd5;
        @(negedge CLK);
        Inputs[0]  = 8'd0;
        Inputs[1]  = 8'd0;
        Inputs[2]  = 8'd0;
        Inputs[3]  = 8'd0;
        Inputs[4]  = 8'd0;
        Weights[0] = 8'd0;
        Weights[1] = 8'd0;
        Weights[2] = 8'd0;
        Weights[3] = 8'd0;
        Weights[4] = 8'd0;
        repeat(9) @(negedge CLK);
        $stop;
    end
endmodule
