module ReLU_tb ();
    localparam DATA_WIDTH = 8;
    localparam SA_LENGTH = 3;
    reg signed [DATA_WIDTH-1:0] in [SA_LENGTH];
    reg en;
    wire signed [DATA_WIDTH-1:0] out [SA_LENGTH];

    ReLU #(.DATA_WIDTH(DATA_WIDTH), .SA_LENGTH(SA_LENGTH)) dut (.in(in), .en(en), .out(out));

    initial begin
        en = 1;
        in = {5, -100, 127};
        #10;

        en = 0;
        in = {-10, 15, 120};
        #10;

        en = 1;
        #10;
    end

endmodule