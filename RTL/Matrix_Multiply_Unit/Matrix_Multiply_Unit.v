module Matrix_Multiply_Unit #(parameter WIDTH=8, parameter LENGTH=256) (
    input wire                      CLK,
    input wire                      ASYNC_RST,
    input wire                      SYNC_RST,
    input wire                      EN,
    input wire [(WIDTH*LENGTH)-1:0] INPUTS,
    input wire [(WIDTH*LENGTH)-1:0] WEIGHTS
);
    genvar row;
    genvar col;

    wire [WIDTH-1:0] ToRight [0:LENGTH-1][0:LENGTH-1];
    wire [WIDTH-1:0] ToDown  [0:LENGTH-1][0:LENGTH-1];
    wire [2*WIDTH:0] PsumOut [0:LENGTH-1][0:LENGTH-1];

    generate
        for (row = 0; row < LENGTH; row = row + 1) begin : row_gen
            for (col = 0; col < LENGTH; col = col + 1) begin : col_gen
                if (row == 0 & col == 0) begin
                    Processing_Element #(WIDTH) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .Input(Inputs[WIDTH*LENGTH-(row*WIDTH+1):WIDTH*LENGTH-(row+1)*WIDTH]),
                        .Weight(Weights[WIDTH*LENGTH-(column*WIDTH+1):WIDTH*LENGTH-(column+1)*WIDTH]),
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
                        .Weight(Weights[WIDTH*LENGTH-(column*WIDTH+1):WIDTH*LENGTH-(column+1)*WIDTH]),
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
                        .Input(Inputs[WIDTH*LENGTH-(row*WIDTH+1):WIDTH*LENGTH-(row+1)*WIDTH]),
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
