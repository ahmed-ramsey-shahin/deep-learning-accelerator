module Tanh_tb ();
    parameter DATA_WIDTH = 12;
    parameter SA_LENGTH = 8;
    parameter S = 7;
    reg signed [DATA_WIDTH-1:0] in [SA_LENGTH];
    reg en;
    wire signed [DATA_WIDTH-1:0] out [SA_LENGTH];

    Tanh #(.DATA_WIDTH(DATA_WIDTH), .SA_LENGTH(SA_LENGTH), .S(S)) dut (.in(in), .en(en), .out(out));

    initial begin
        en = 1;
        in = {0, 400, 517, -512, -1, -2048, 2047, 52};
        #10;

        en = 0;
        #10;

        en = 1;
        #10;
    end
endmodule