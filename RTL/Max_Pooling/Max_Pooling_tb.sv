`timescale 1ns/1ps

module Max_Pooling_tb();
    localparam integer DATA_WIDTH=24;
    localparam integer SA_LENGTH=10;
    localparam integer MAX_FILTER_SIZE=7;

    reg                                 CLK;
    reg                                 ASYNC_RST;
    reg                                 SYNC_RST;
    reg                                 EN;
    reg         [$clog2(SA_LENGTH)-1:0] ImageHeight;
    reg         [$clog2(SA_LENGTH)-1:0] ImageWidth;
    reg         [2:0]                   FilterSize;
    reg  signed [DATA_WIDTH-1:0]        InputColumn  [SA_LENGTH];
    wire signed [DATA_WIDTH-1:0]        OutputColumn [SA_LENGTH];

    Max_Pooling #(
        .DATA_WIDTH(DATA_WIDTH),
        .SA_LENGTH(SA_LENGTH),
        .MAX_FILTER_SIZE(MAX_FILTER_SIZE)
    ) max_pooling (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(EN),
        .ImageWidth(ImageWidth),
        .ImageHeight(ImageHeight),
        .FilterSize(FilterSize),
        .InputColumn(InputColumn),
        .OutputColumn(OutputColumn)
    );

    always begin
        CLK = 1'b1;
        #5;
        CLK = 1'b0;
        #5;
    end

    initial begin
        ASYNC_RST   = 1'b0;
        SYNC_RST    = 1'b0;
        EN          = 1'b1;
        ImageHeight = 'd10;
        ImageWidth  = 'd10;
        FilterSize  = 'd4;
        #2;
        ASYNC_RST   = 1'b1;
        @(negedge CLK);
        InputColumn = {'d123, 'd45,  'd200, 'd89,  'd176, 'd54,  'd210, 'd32,  'd99,  'd7};
        @(negedge CLK);
        InputColumn = {'d88,  'd255, 'd12,  'd67,  'd190, 'd23,  'd56,  'd141, 'd77,  'd18};
        @(negedge CLK);
        InputColumn = {'d34,  'd222, 'd111, 'd90,  'd3,   'd144, 'd175, 'd200, 'd8,   'd65};
        @(negedge CLK);
        InputColumn = {'d250, 'd199, 'd73,  'd166, 'd120, 'd87,  'd54,  'd36,  'd178, 'd14};
        @(negedge CLK);
        InputColumn = {'d45,  'd92,  'd63,  'd239, 'd107, 'd12,  'd18,  'd255, 'd133, 'd201};
        @(negedge CLK);
        InputColumn = {'d210, 'd47,  'd80,  'd101, 'd177, 'd205, 'd34,  'd65,  'd222, 'd99};
        @(negedge CLK);
        InputColumn = {'d9,   'd150, 'd34,  'd76,  'd33,  'd11,  'd145, 'd198, 'd55,  'd220};
        @(negedge CLK);
        InputColumn = {'d67,  'd24,  'd101, 'd188, 'd47,  'd62,  'd130, 'd74,  'd190, 'd28};
        @(negedge CLK);
        InputColumn = {'d111, 'd39,  'd82,  'd255, 'd19,  'd64,  'd146, 'd88,  'd31,  'd176};
        @(negedge CLK);
        InputColumn = {'d208, 'd140, 'd72,  'd27,  'd192, 'd80,  'd36,  'd117, 'd59,  'd5};
        @(negedge CLK);
        ImageHeight = 'd4;
        ImageWidth  = 'd4;
        FilterSize  = 'd3;
        InputColumn = {'d34,  'd178, 'd92,  'd210, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        InputColumn = {'d255, 'd63,  'd11,  'd87, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        InputColumn = {'d140, 'd222, 'd76,  'd5, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        InputColumn = {'d19,  'd101, 'd200, 'd67, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        ImageHeight = 'd10;
        ImageWidth  = 'd10;
        FilterSize  = 'd4;
        InputColumn = {'d123, 'd45,  'd200, 'd89,  'd176, 'd54,  'd210, 'd32,  'd99,  'd7};
        @(negedge CLK);
        InputColumn = {'d88,  'd255, 'd12,  'd67,  'd190, 'd23,  'd56,  'd141, 'd77,  'd18};
        @(negedge CLK);
        InputColumn = {'d34,  'd222, 'd111, 'd90,  'd3,   'd144, 'd175, 'd200, 'd8,   'd65};
        @(negedge CLK);
        InputColumn = {'d250, 'd199, 'd73,  'd166, 'd120, 'd87,  'd54,  'd36,  'd178, 'd14};
        @(negedge CLK);
        InputColumn = {'d45,  'd92,  'd63,  'd239, 'd107, 'd12,  'd18,  'd255, 'd133, 'd201};
        @(negedge CLK);
        InputColumn = {'d210, 'd47,  'd80,  'd101, 'd177, 'd205, 'd34,  'd65,  'd222, 'd99};
        @(negedge CLK);
        InputColumn = {'d9,   'd150, 'd34,  'd76,  'd33,  'd11,  'd145, 'd198, 'd55,  'd220};
        @(negedge CLK);
        InputColumn = {'d67,  'd24,  'd101, 'd188, 'd47,  'd62,  'd130, 'd74,  'd190, 'd28};
        @(negedge CLK);
        InputColumn = {'d111, 'd39,  'd82,  'd255, 'd19,  'd64,  'd146, 'd88,  'd31,  'd176};
        @(negedge CLK);
        InputColumn = {'d208, 'd140, 'd72,  'd27,  'd192, 'd80,  'd36,  'd117, 'd59,  'd5};
        @(negedge CLK);
        ImageHeight = 'd6;
        ImageWidth  = 'd6;
        FilterSize  = 'd3;
        InputColumn = {'d45,  'd178, 'd92,  'd210, 'd33,  'd67, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        InputColumn = {'d255, 'd63,  'd11,  'd87,  'd140, 'd199, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        InputColumn = {'d34,  'd222, 'd76,  'd5,   'd201, 'd88, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        InputColumn = {'d19,  'd101, 'd200, 'd67,  'd142, 'd55, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        InputColumn = {'d123, 'd44,  'd167, 'd9,   'd230, 'd72, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        InputColumn = {'d211, 'd90,  'd38,  'd154, 'd64,  'd12, 'd0, 'd0, 'd0, 'd0};
        @(negedge CLK);
        $stop;
    end
endmodule

