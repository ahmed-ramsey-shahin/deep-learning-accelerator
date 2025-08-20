`timescale 1ns/1ps

module Counter_tb();
    localparam integer COUNTER_WIDTH = 4;

    reg                      CLK;
    reg                      ASYNC_RST;
    reg                      SYNC_RST;
    reg                      EN;
    reg  [COUNTER_WIDTH-1:0] MaxNumber;
    wire [COUNTER_WIDTH-1:0] Value;
    wire                     Done;

    Counter #(COUNTER_WIDTH) cnt (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(EN),
        .MaxNumber(MaxNumber),
        .Value(Value),
        .Done(Done)
    );

    always begin
        CLK = 1'b0;
        #5;
        CLK = 1'b1;
        #5;
    end

    initial begin
        ASYNC_RST = 1'b0;
        SYNC_RST  = 1'b0;
        EN        = 1'b0;
        MaxNumber = 'd0;
        #2;
        ASYNC_RST = 1'b1;
        EN        = 1'b1;
        MaxNumber = 'd10;
        repeat(32) @(negedge CLK);
        $stop;
    end
endmodule

