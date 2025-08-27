module Sigmoid (in, en, out);
    parameter DATA_WIDTH = 8;
    parameter SA_LENGTH = 256;
    parameter S = 7;
    input signed [DATA_WIDTH-1:0] in [SA_LENGTH];
    input en;
    output reg signed [DATA_WIDTH-1:0] out [SA_LENGTH];

    // Define internal signals.
    reg [DATA_WIDTH-1:0] abs_in [SA_LENGTH];
    reg signed [DATA_WIDTH-1:0] out_temp [SA_LENGTH];
    integer i;

    // Define the input range to calculate the output.
    localparam R1 = 4 * (2 ** S);

    // Define the bias.
    localparam B1 = (2 ** (S-1));

    always @(*) begin
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            if (en) begin
                if (in[i][DATA_WIDTH-1] == 1'b1) begin
                    abs_in[i] = (in[i] == -(2**DATA_WIDTH)) ? (2**DATA_WIDTH)-1 : -in[i];
                end else begin
                    abs_in[i] = in[i];
                end

                if (abs_in[i] >= R1) begin
                    out_temp[i] = (2 ** S) -1;
                end else begin
                    out_temp[i] = -((abs_in[i] ** 2) >> (5+S)) + (abs_in[i] >> 2) + B1;
                end

                if(in[i][DATA_WIDTH-1] == 1'b1) begin
                    out_temp[i] = (2 ** S) - out_temp[i] -1;
                end else begin
                    out_temp[i] = out_temp[i];
                end
            end else begin
                out_temp[i] = 0;
            end
        end
    end

    assign out = out_temp;

endmodule