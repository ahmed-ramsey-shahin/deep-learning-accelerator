module Carry_Save_Multiplier #(parameter WIDTH=8) (
    input  signed wire [WIDTH-1:0]   A,
    input  signed wire [WIDTH-1:0]   B,
    output signed wire [2*WIDTH-1:0] P
);
    wire [WIDTH+1:0] sum   [WIDTH:0];
    wire [WIDTH+1:0] carry [WIDTH:0];

    genvar i, j;
    generate
        for (i = 0; i <= WIDTH; i = i + 1) begin : gen_i
            for (j = 0; j <= WIDTH - 1; j = j + 1) begin : gen_j
                if (i == 0) begin
                    Math_Multiplier ma (
                        .A(A[j]),
                        .B(B[i]),
                        .C(1'b0),
                        .Cin(1'b0),
                        .S(sum[i][j]),
                        .Cout(carry[i][j])
                    );
                end
                else if (i == WIDTH) begin
                    Math_Multiplier ma (
                        .A(1'b1),
                        .B((j == 0) ? 1'b0 : carry[i][j-1]),
                        .C((j == WIDTH-1) ? 1'b0 : sum[i-1][j+1]),
                        .Cin(carry[i-1][j]),
                        .S(sum[i][j]),
                        .Cout(carry[i][j])
                    );
                end
                else begin
                    Math_Multiplier ma (
                        .A(A[j]),
                        .B(B[i]),
                        .C((j == WIDTH-1) ? 1'b0 : sum[i-1][j+1]),
                        .Cin(carry[i-1][j]),
                        .S(sum[i][j]),
                        .Cout(carry[i][j])
                    );
                end

                if (i == WIDTH) begin
                    assign P[i+j] = sum[i][j];
                end
            end
            if (i != WIDTH) begin
                assign P[i] = sum[i][0];
            end
        end
    endgenerate
endmodule

