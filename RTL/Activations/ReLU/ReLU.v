module ReLU (in, out);
    parameter WIDTH = 32;
    
    input [WIDTH-1:0] in;
    output [WIDTH-1:0] out;

    assign out = (in[WIDTH-1] == 1'b1) ? {WIDTH{1'b0}} : in;

endmodule