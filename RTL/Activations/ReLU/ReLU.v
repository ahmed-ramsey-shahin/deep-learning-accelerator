module ReLU (in, out);    
    input signed [23:0] in;
    output reg signed [7:0] out;

    always @(*) begin
        if (in[23] == 1'b1) begin
            out = 0;
        end else begin
            out = (in >> 16);
        end
    end

endmodule