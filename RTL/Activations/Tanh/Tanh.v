module Tanh (in, en, out);
    parameter IN_WIDTH = 8;
    parameter OUT_WIDTH = 8;
    input signed [IN_WIDTH-1:0] in;
    input en;
    output reg signed [OUT_WIDTH-1:0] out;

    reg [IN_WIDTH-1:0] abs_in;
    reg [OUT_WIDTH-1:0] out_temp;

    // Define the ranges.
    localparam R1 = 3 * (2 ** (OUT_WIDTH-1));
    localparam R2 = 2 * (2 ** (OUT_WIDTH-1));
    localparam R3 = 1.5 * (2 ** (OUT_WIDTH-1));
    localparam R4 = (2 ** (OUT_WIDTH-1));
    localparam R5 = 0.5 * (2 ** (OUT_WIDTH-1));

    // Define the bias.
    localparam B1 = 0.8125 * (2 ** (OUT_WIDTH-1)) -1;
    localparam B2 = 0.6875 * (2 ** (OUT_WIDTH-1)) -1;
    localparam B3 = 0.5 * (2 ** (OUT_WIDTH-1)) -1;
    localparam B4 = 0.25 * (2 ** (OUT_WIDTH-1)) -1;

    always @(*) begin
        if(en) begin
            if (in[IN_WIDTH-1] == 1'b1) begin
                abs_in = -in;
            end else begin
                abs_in = in;
            end

            if (abs_in >= R1) begin
                out_temp = (2 ** (OUT_WIDTH-1)) -1;
            end else if(abs_in >= R2) begin
                out_temp = (abs_in >> 4) + B1;
            end else if(abs_in >= R3) begin
                out_temp = (abs_in >> 3) + B2;
            end else if(abs_in >= R4) begin
                out_temp = (abs_in >> 2) + B3;
            end else if(abs_in >= R5) begin
                out_temp = (abs_in >> 1) + B4;
            end else begin
                out_temp = abs_in;
            end

            if (in[IN_WIDTH-1] == 1'b1) begin
                out = -out_temp;
            end else begin
                out = out_temp;
            end
        end else begin
            out = 0;
        end
    end
endmodule