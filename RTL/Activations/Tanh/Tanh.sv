module Tanh (in, en, out);
    parameter DATA_WIDTH = 11;
    parameter SA_LENGTH = 256;
    parameter S = 7;
    input signed [DATA_WIDTH-1:0] in [SA_LENGTH];
    input en;
    output reg signed [DATA_WIDTH-1:0] out [SA_LENGTH];

    localparam CONSTANT = (2 ** S);

    // Define internal signals.
    reg signed [DATA_WIDTH+1:0] sigmoid_in [SA_LENGTH];
    reg signed [DATA_WIDTH+1:0] sigmoid_out [SA_LENGTH];
    reg signed [DATA_WIDTH-1:0] out_temp [SA_LENGTH];
    integer i, j;

    always @(*) begin
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            if (en) begin
                if (in[i][DATA_WIDTH-1] == 1'b1) begin
                    sigmoid_in[i] = (in[i] == -(2**DATA_WIDTH)) ? (((2**DATA_WIDTH)-1) << 1) : ((-in[i]) << 1);
                end else begin
                    sigmoid_in[i] = in[i] << 1;
                end

                if(in[i][DATA_WIDTH-1] == 1'b1) begin
                    out_temp[i] = (2 ** S) - (sigmoid_out[i] << 1);
                end else begin
                    out_temp[i] = (sigmoid_out[i] << 1) - (2 ** S);
                end
            end else begin
                out_temp[i] = 0;
            end
        end
    end

    Sigmoid #(.DATA_WIDTH(DATA_WIDTH+2), .SA_LENGTH(SA_LENGTH), .S(S)) dut (.in(sigmoid_in), .en(en), .out(sigmoid_out));

    assign out = out_temp;
endmodule