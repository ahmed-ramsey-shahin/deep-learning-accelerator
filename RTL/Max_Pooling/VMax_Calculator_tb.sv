`timescale 1ns/1ps

module VMax_Calculator_tb();
    localparam integer DATA_WIDTH=32;
    localparam integer SA_LENGTH=10;
    localparam integer MAX_FILTER_SIZE=7;

    reg  signed [DATA_WIDTH-1:0] HMax  [SA_LENGTH];
    wire signed [DATA_WIDTH-1:0] VMaxs [MAX_FILTER_SIZE][SA_LENGTH];

    VMax_Calculator #(
        .DATA_WIDTH(DATA_WIDTH),
        .SA_LENGTH(SA_LENGTH),
        .MAX_FILTER_SIZE(MAX_FILTER_SIZE)
    ) calc (
        .HMax(HMax),
        .VMaxs(VMaxs)
    );

    initial begin
        HMax = '{
            24'd642,
            24'd905,
            24'd248,
            24'd834,
            24'd419,
            24'd978,
            24'd710,
            24'd105,
            24'd372,
            24'd587
        };
        #10;
        $stop;
    end
endmodule

