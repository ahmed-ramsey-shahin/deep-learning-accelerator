module Processing_Element #(parameter WIDTH=8) (
    input  wire               CLK,
    input  wire               ASYNC_RST,
    input  wire               SYNC_RST,
    input  wire               EN,
    input  wire [WIDTH-1:0]   InputIn,
    input  wire [WIDTH-1:0]   WeightIn,
    output reg  [WIDTH-1:0]   InputOut,
    output reg  [WIDTH-1:0]   WeightOut,
    output reg  [2*WIDTH-1:0] Result
);
    wire [2*WIDTH-1:0] mult_out;

    Carry_Save_Multiplier #(WIDTH) mult (
        .A(InputIn),
        .B(WeightIn),
        .P(mult_out)
    );

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST | SYNC_RST) begin
            InputOut  <= 'd0;
            WeightOut <= 'd0;
            Result    <= 'd0;
        end
        else if (EN) begin
            InputOut  <= InputIn;
            WeightOut <= WeightIn;
            Result    <= mult_out;
        end
    end
endmodule
