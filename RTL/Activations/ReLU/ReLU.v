module ReLU (in, en, out);
    parameter IN_WIDTH = 8;
    parameter OUT_WIDTH = 8;
    input signed [IN_WIDTH-1:0] in;
    input en;
    output reg signed [OUT_WIDTH-1:0] out;

    always @(*) begin
        if (en) begin
            if (in[OUT_WIDTH-1] == 1'b1) begin
                out = 0;
            end else begin
                out = in;
            end
        end else begin
            out = 0;
        end
    end

endmodule