module Sigmoid (in, en, out);
    parameter IN_WIDTH = 8;
    parameter OUT_WIDTH = 8;
    input signed [IN_WIDTH-1:0] in;
    input en;
    output reg signed [OUT_WIDTH-1:0] out;

    // Define internal signals.
    reg [IN_WIDTH-1:0] abs_in;
    reg [OUT_WIDTH-1:0] out_temp;

    // Define the input range to calculate the output.
    localparam R1 = 5 * (2 ** (OUT_WIDTH-1));
    localparam R2 = 2.375 * (2 ** (OUT_WIDTH-1));
    localparam R3 = (2 ** (OUT_WIDTH-1));

    // Define the bias.
    localparam B1 = 0.84375 * (2 ** (OUT_WIDTH-1));
    localparam B2 = 0.625 * (2 ** (OUT_WIDTH-1));
    localparam B3 = 0.5 * (2 ** (OUT_WIDTH-1));

    always @(*) begin
        if (en) begin
            if (in[IN_WIDTH-1] == 1'b1) begin
                abs_in = -in;
            end else begin
                abs_in = in;
            end

            if (abs_in > R1) begin
                out_temp = (2 ** (OUT_WIDTH-1));
            end else if(abs_in >= R2) begin
                out_temp = (abs_in >> 5) + B1;
            end else if(abs_in >= R3) begin
                out_temp = (abs_in >> 3) + B2;
            end else begin
                out_temp = (abs_in >> 2) + B3;
            end

            if (in[IN_WIDTH-1] == 1'b1) begin
                out = (2 ** (OUT_WIDTH-1) -1) - (out_temp -1);
            end else begin
                out = out_temp -1;
            end
        end else begin
            out = 0;
        end
    end
endmodule