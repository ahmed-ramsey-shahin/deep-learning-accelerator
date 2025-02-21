module Processing_Element #(parameter WIDTH=8) (
    input  wire                 CLK,
    input  wire                 ASYNC_RST,
    input  wire                 SYNC_RST,
    input  wire                 EN,
    input  wire [WIDTH-1:0]     Input,
    input  wire [WIDTH-1:0]     Weight,
    output reg  [WIDTH-1:0]     ToRight,
    output reg  [WIDTH-1:0]     ToDown,
    output reg  [2*WIDTH-1:0]   Result
);
    wire [2*WIDTH-1:0] mult_out;
    
    Carry_Save_Multiplier #(WIDTH) mult (
        .A(Input),
        .B(Weight),
        .P(mult_out)
    );

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST | SYNC_RST) begin
            ToRight    <= 'd0;
            ToDown     <= 'd0;
            Result     <= 'd0;
        end
        else if (EN) begin
            ToRight    <= Input;
            ToDown     <= Weight;
            Result     <= Result + mult_out;
        end
    end
endmodule
