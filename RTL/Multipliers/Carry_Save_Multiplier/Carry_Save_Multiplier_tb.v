`timescale 1ns/1ps

module Carry_Save_Multiplier_tb ();
    localparam WIDTH = 9;
    reg  [WIDTH-1:0] A, B;
    wire [2*WIDTH-1:0] C;

    Carry_Save_Multiplier #(WIDTH) DUT (
        .A(A),
        .B(B),
        .P(C)
    );

    initial begin
        for (A = 0; A <= 8'hFF; A = A + 1) begin
            for (B = 0; B <= 8'hFF; B = B + 1) begin
                #1;
                if (C != A * B) begin
                    $display("%d x %d = %d Failed", A, B, C);
                end
            end
        end
        $display("Verification completed");
        $stop;
    end
endmodule
