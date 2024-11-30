module Math_Multiplier (
    input  wire A,
    input  wire B,
    input  wire C,
    input  wire Cin,
    output wire S,
    output wire Cout
);
    Full_Adder fa (
        .S(S),
        .Cout(Cout),
        .A(A & B),
        .B(C),
        .Cin(Cin)
    );
endmodule
