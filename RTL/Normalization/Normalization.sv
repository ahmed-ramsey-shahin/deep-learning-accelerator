module Normalization #(
    parameter integer IN_WIDTH=32,
    parameter integer OUT_WIDTH=8,
    parameter integer SA_LENGTH=256
) (
    input  wire signed [7:0]           ShiftAmmount,
    input  wire signed [IN_WIDTH-1:0]  In  [SA_LENGTH],
    output reg  signed [OUT_WIDTH-1:0] Out [SA_LENGTH]
);
    localparam signed [IN_WIDTH-1:0] MAX_VALUE = (1 <<< (OUT_WIDTH-1)) - 1;
    localparam signed [IN_WIDTH-1:0] MIN_VALUE = -(1 <<< (OUT_WIDTH-1));

    integer i;
    reg signed [IN_WIDTH-1:0] shifted_value;

    always_comb begin
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            if (ShiftAmmount > 0) begin
                shifted_value = In[i] <<< ShiftAmmount;
            end
            else begin
                shifted_value = In[i] >>> (-ShiftAmmount);
            end

            if (shifted_value > MAX_VALUE) begin
                Out[i] = MAX_VALUE[OUT_WIDTH-1:0];
            end
            else if (shifted_value < MIN_VALUE) begin
                Out[i] = MIN_VALUE[OUT_WIDTH-1:0];
            end
            else begin
                Out[i] = shifted_value[OUT_WIDTH-1:0];
            end
        end
    end
endmodule

