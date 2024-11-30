module Full_Adder (
    input  wire A,
    input  wire B,
    input  wire Cin,
    output reg  S,
    output reg  Cout
);
    always @(*) begin
        {Cout, S} = A + B + Cin;
    end
endmodule
