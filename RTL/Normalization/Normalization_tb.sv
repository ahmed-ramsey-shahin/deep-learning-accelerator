`timescale 1ns/1ps

module Normalization_tb();
    localparam integer IN_WIDTH=32;
    localparam integer OUT_WIDTH=8;
    localparam integer SA_LENGTH=1;

    reg         [7:0]           ShiftAmmount;
    reg  signed [IN_WIDTH-1:0]  In  [SA_LENGTH];
    wire signed [OUT_WIDTH-1:0] Out [SA_LENGTH];

    Normalization #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .SA_LENGTH(SA_LENGTH)
    ) DUT (
        .ShiftAmmount(ShiftAmmount),
        .In(In),
        .Out(Out)
    );

    initial begin
        In           = {'d25600};
        ShiftAmmount = 'd8;
        #5;
        In           = {'d1000000};
        ShiftAmmount = 'd8;
        #5;
        In           = {-'d40000};
        ShiftAmmount = 'd6;
        #5;
        $stop;
    end
endmodule

