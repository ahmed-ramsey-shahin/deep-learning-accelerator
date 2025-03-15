module ReLU_tb ();
    parameter WIDTH = 8;
    
    reg [WIDTH-1:0] in;
    wire [WIDTH-1:0]out;

    ReLU #(WIDTH) dut(in, out);

    initial begin
        in = 8'b00000000;
        #10 in = 8'b01111111;
        #10 in = 8'b10000000;
        #10 in = 8'b10001100;
        #10 in = 8'b00001100;
    end

endmodule