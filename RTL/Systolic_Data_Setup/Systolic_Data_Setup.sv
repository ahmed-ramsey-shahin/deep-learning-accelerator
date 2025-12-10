module Systolic_Data_Setup #(
    parameter integer DATA_WIDTH=8,
    parameter integer SA_LENGTH=256,
    parameter bit     REVERSE=1'b0
) (
    input  wire                         CLK,
    input  wire                         ASYNC_RST,
    input  wire                         SYNC_RST,
    input  wire                         EN,
    input  wire signed [DATA_WIDTH-1:0] Inputs  [SA_LENGTH],
    output wire signed [DATA_WIDTH-1:0] Outputs [SA_LENGTH]
);
    genvar i;
    generate
        for (i = 0; i < SA_LENGTH; i = i + 1) begin : gen_shift_register
            Shift_Register #(
                .LENGTH(i + 1),
                .DATA_WIDTH(DATA_WIDTH)
            ) shift_reg (
                .CLK(CLK),
                .SYNC_RST(SYNC_RST),
                .ASYNC_RST(ASYNC_RST),
                .EN(EN),
                .In(Inputs[REVERSE ? SA_LENGTH - 1 - i : i]),
                .Out(Outputs[REVERSE ? SA_LENGTH - 1 - i : i])
            );
        end
    endgenerate
endmodule

