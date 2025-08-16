module Processing_Element #(
    parameter int DATA_WIDTH=8,
    parameter int ACCUMULATOR_DATA_WIDTH=32
) (
    input  wire                                     CLK,
    input  wire                                     ASYNC_RST,
    input  wire                                     SYNC_RST,
    input  wire                                     EN,
    input  wire                                     LOAD,
    input  wire signed [DATA_WIDTH-1:0]             Input,
    input  wire signed [ACCUMULATOR_DATA_WIDTH-1:0] PsumIn,
    output reg  signed [DATA_WIDTH-1:0]             ToRight,
    output reg  signed [ACCUMULATOR_DATA_WIDTH-1:0] PsumOut
);
    wire signed [2*DATA_WIDTH-1:0] mult_out;
    reg  signed [DATA_WIDTH-1:0]   registered_weight;

    Carry_Save_Multiplier #(DATA_WIDTH) mult (
        .A(Input),
        .B(registered_weight),
        .P(mult_out)
    );

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST) begin
            registered_weight <= 'd0;
            ToRight           <= 'd0;
            PsumOut           <= 'd0;
        end
        else if (SYNC_RST) begin
            registered_weight <= 'd0;
            ToRight           <= 'd0;
            PsumOut           <= 'd0;
        end
        else if (LOAD) begin
            registered_weight <= Input;
        end
        else if (EN) begin
            PsumOut <= mult_out + PsumIn;
            ToRight <= Input;
        end
    end
endmodule

