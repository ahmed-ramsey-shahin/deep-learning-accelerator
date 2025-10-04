module Activations (in, clk, en, sync_rst, async_rst, sel, out);
    parameter DATA_WIDTH = 11;
    parameter SA_LENGTH = 256;
    parameter S = 7;
    input signed [DATA_WIDTH-1:0] in [SA_LENGTH];
    input clk, en, sync_rst, async_rst;
    input [1:0] sel;
    output reg signed [DATA_WIDTH-1:0] out [SA_LENGTH];

    // Define internal signals.
    reg relu_en, sigmoid_en, tanh_en;
    wire signed [DATA_WIDTH-1:0] relu_out [SA_LENGTH];
    wire signed [DATA_WIDTH-1:0] sigmoid_out [SA_LENGTH];
    wire signed [DATA_WIDTH-1:0] tanh_out [SA_LENGTH];

    always @(*) begin
        if (en) begin
            if (sel == 0) begin
                relu_en = 1;
                sigmoid_en = 0;
                tanh_en = 0;
            end else if (sel == 1) begin
                relu_en = 0;
                sigmoid_en = 1;
                tanh_en = 0;
            end else if (sel == 2) begin
                relu_en = 0;
                sigmoid_en = 0;
                tanh_en = 1;
            end else begin
                relu_en = 0;
                sigmoid_en = 0;
                tanh_en = 0;
            end
        end else begin
            relu_en = 0;
            sigmoid_en = 0;
            tanh_en = 0;
        end
    end

    ReLU #(.DATA_WIDTH(DATA_WIDTH), .SA_LENGTH(SA_LENGTH)) relu (.in(in), .en(relu_en), .out(relu_out));
    Sigmoid #(.DATA_WIDTH(DATA_WIDTH), .SA_LENGTH(SA_LENGTH), .S(S)) sigmoid (.in(in), .en(sigmoid_en), .out(sigmoid_out));
    Tanh #(.DATA_WIDTH(DATA_WIDTH), .SA_LENGTH(SA_LENGTH), .S(S)) tanh (.in(in), .en(tanh_en), .out(tanh_out));

    integer i;
    always @(posedge clk or negedge async_rst) begin
        if (~async_rst) begin
            for (i = 0; i < SA_LENGTH; i = i + 1) begin
                out[i] <= 0;
            end
        end else if(en) begin
            if(sync_rst) begin
                for (i = 0; i < SA_LENGTH; i = i + 1) begin
                    out[i] <= 0;
                end
            end else begin
                case (sel)
                    2'b00: out <= relu_out;
                    2'b01: out <= sigmoid_out;
                    2'b10: out <= tanh_out;
                    2'b11: out <= in;
                endcase
            end
        end
    end
endmodule
