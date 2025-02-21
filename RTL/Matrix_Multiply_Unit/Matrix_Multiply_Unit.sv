module Matrix_Multiply_Unit #(parameter WIDTH=8, parameter LENGTH=256) (
    input  wire             CLK,
    input  wire             ASYNC_RST,
    input  wire             SYNC_RST,
    input  wire             EN,
    input  wire [WIDTH-1:0] Inputs  [0:LENGTH-1],
    input  wire [WIDTH-1:0] Weights [0:LENGTH-1],
    output wire [2*WIDTH:0] PsumOut [0:LENGTH-1][0:LENGTH-1]
);
    genvar row;
    genvar col;

    wire [WIDTH-1:0] ToRight [0:LENGTH-1][0:LENGTH-1];
    wire [WIDTH-1:0] ToDown  [0:LENGTH-1][0:LENGTH-1];

    generate
        for (row = 0; row < LENGTH; row = row + 1) begin : row_gen
            for (col = 0; col < LENGTH; col = col + 1) begin : col_gen
                if (row == 0 & col == 0) begin
                    Processing_Element #(WIDTH) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .Input(Inputs[0]),
                        .Weight(Weights[0]),
                        .PsumIn('d0),
                        .ToRight(ToRight[row][col]),
                        .ToDown(ToDown[row][col]),
                        .PsumOut(PsumOut[row][col])
                    );
                end
                else if (row == 0 & col != 0) begin
                    Processing_Element #(WIDTH) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .Input(ToRight[row][column-1]),
                        .Weight(Weights[col]),
                        .PsumIn('d0),
                        .ToRight(ToRight[row][col]),
                        .ToDown(ToDown[row][col]),
                        .PsumOut(PsumOut[row][col])
                    );
                end
                else if (row != 0 & col == 0) begin
                    Processing_Element #(WIDTH) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .Input(Inputs[row]),
                        .Weight(ToDown[row-1][col]),
                        .PsumIn('d0),
                        .ToRight(ToRight[row][col]),
                        .ToDown(ToDown[row][col]),
                        .PsumOut(PsumOut[row][col])
                    );
                end
                else begin
                    Processing_Element #(WIDTH) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .Input(ToRight[row][column-1]),
                        .Weight(ToDown[row-1][col]),
                        .PsumIn('d0),
                        .ToRight(ToRight[row][col]),
                        .ToDown(ToDown[row][col]),
                        .PsumOut(PsumOut[row][col])
                    );
                end
            end
        end
    endgenerate
endmodule
