module Sigmoid (in, out);
    input signed [23:0] in;
    output reg signed [7:0] out;

    reg [23:0] abs_in;
    reg [7:0] out_temp;

    always @(*) begin
        if (in[23] == 1'b1) begin
            abs_in = (in == -8388608) ? 1281 : -in;
        end else begin
            abs_in = in;
        end

        if (abs_in > 640) begin
            out_temp = 127;
        end else if(abs_in >= 304) begin
            out_temp = (abs_in >> 5) + 108;
        end else if(abs_in >= 128) begin
            out_temp = (abs_in >> 3) + 80;
        end else begin
            out_temp = (abs_in >> 2) + 64;
        end

        if (in[23] == 1'b1) begin
            out = 127 - out_temp;
        end else begin
            out = out_temp;
        end
    end
endmodule