module ReLU_tb ();
    localparam IN_WIDTH = 8;
    localparam OUT_WIDTH = 8;
    reg signed [IN_WIDTH-1:0] in;
    reg en;
    wire signed [OUT_WIDTH-1:0]out;

    ReLU #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH)) dut(.in(in), .en(en), .out(out));

    initial begin
        en = 1;
        in = 5;
        #10;
        
        in = 100;
        #10;
        
        in = 127;
        #10;
        
        in = -5;
        #10;
        
        in = -100;
        #10;
        
        in = -128;
        #10;

        en = 0;
        in = 5;
        #10;

        en = 1;
        in = 15;
        #10;
    end

endmodule