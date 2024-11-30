module Processing_Element #(parameter WIDTH=8) (
    input  wire CLK,
    input  wire RST,
    input  wire Load,
    input  wire [WIDTH-1:0]   Input,
    input  wire [WIDTH-1:0]   Weight,
    input  wire [2*WIDTH-1:0] PsumIn,
    output wire [WIDTH-1:0]   ToRight,
    output wire [WIDTH-1:0]   ToDown,
    output wire [2*WIDTH-1:0] PsumOut
);
    wire [2*WIDTH-1:0] mult_out;
    reg  [WIDTH-1:0] Weight_DFF;
    
    Carry_Save_Multiplier #(WIDTH) mult (
        .A(Input),
        .B(Weight_DFF),
        .P(mult_out)
    );

    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            Weight_DFF <= 'd0;
        end
        else if (Load) begin
            Weight_DFF <= Weight;
        end
    end

    assign ToRight = Input;
    assign ToDown  = Weight_DFF;
    assign PsumOut = mult_out + PsumIn;
endmodule
