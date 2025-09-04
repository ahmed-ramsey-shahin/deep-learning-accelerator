module Activations_tb ();
    parameter DATA_WIDTH = 12;
    parameter SA_LENGTH = 8;
    parameter S = 7;
    reg signed [DATA_WIDTH-1:0] in [SA_LENGTH];
    reg clk, en, sync_rst, async_rst;
    reg [1:0] sel;
    wire signed [DATA_WIDTH-1:0] out [SA_LENGTH];

    Activations #(.DATA_WIDTH(DATA_WIDTH), .SA_LENGTH(SA_LENGTH), .S(S)) dut (.in(in), .clk(clk), .en(en), .sync_rst(sync_rst), .async_rst(async_rst), .sel(sel), .out(out));

    initial begin
        clk = 0;
        forever begin
            #1;
            clk = ~clk;
        end
    end

    initial begin
        in = {0, 400, 517, -512, -1, -2048, 2047, 52};
        en = 1;
        sel = 00;
        async_rst = 1;
        sync_rst = 0;
        
        @(negedge clk);
        async_rst = 0;

        @(negedge clk);
        async_rst = 1;

        @(negedge clk);
        sync_rst = 1;
        sel = 2'b01;

        @(negedge clk);
        sync_rst = 0;

        @(negedge clk);
        sync_rst = 0;
        sel = 2'b10;

        @(negedge clk);
        sel = 2'b11;

        @(negedge clk);
        sel = 2'b00;

        @(negedge clk);
        en = 0;
        sel = 2'b01;

        @(negedge clk);
        $stop;
    end
endmodule