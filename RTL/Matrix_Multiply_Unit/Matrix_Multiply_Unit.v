module Matrix_Multiply_Unit #(parameter WIDTH=8, parameter LENGTH=256) (
    input  wire                      CLK,
    input  wire                      SYNC_RST,
    input  wire                      ASYNC_RST,
    input  wire                      EN,
    input  wire                      Load,
    input  wire [(WIDTH*LENGTH)-1:0] Inputs,
    input  wire [(WIDTH*LENGTH)-1:0] Weights
);
    genvar row;
    genvar column;

    wire [WIDTH-1:0] ToRight [0:LENGTH-1][0:LENGTH-1];
    wire [WIDTH-1:0] ToDown  [0:LENGTH-1][0:LENGTH-1];
    wire [WIDTH-1:0] PsumOut [0:LENGTH-1][0:LENGTH-1];

    generate
        for (row = 0; row < LENGTH; row = row + 1) begin : gen_row
            for (column = 0; column < LENGTH; column = column + 1) begin : gen_column
                if (row == 0 & column == 0) begin
                    Processing_Element #(WIDTH) PE (
                        .CLK(CLK),
                        .SYNC_RST(SYNC_RST),
                        .ASYNC_RST(ASYNC_RST),
                        .Load(Load),
                        .EN(EN),
                        .Input(Inputs[WIDTH*LENGTH-(row*WIDTH+1):WIDTH*LENGTH-(row+1)*WIDTH]),
                        .Weight(Weights[WIDTH*LENGTH-(column*WIDTH+1):WIDTH*LENGTH-(column+1)*WIDTH]),
                        .PsumIn('b0),
                        .ToRight(ToRight[row][column]),
                        .ToDown(ToDown[row][column]),
                        .PsumOut(PsumOut[row][column])
                    );
                end
                else if (row == 0 & column != 0) begin
                    Processing_Element #(WIDTH) PE (
                        .CLK(CLK),
                        .SYNC_RST(SYNC_RST),
                        .ASYNC_RST(ASYNC_RST),
                        .Load(Load),
                        .EN(EN),
                        .Input(ToRight[row][column-1]),
                        .Weight(Weights[WIDTH*LENGTH-(column*WIDTH+1):WIDTH*LENGTH-(column+1)*WIDTH]),
                        .PsumIn('b0),
                        .ToRight(ToRight[row][column]),
                        .ToDown(ToDown[row][column]),
                        .PsumOut(PsumOut[row][column])
                    );
                end
                else if (row != 0 & column == 0) begin
                    Processing_Element #(WIDTH) PE (
                        .CLK(CLK),
                        .SYNC_RST(SYNC_RST),
                        .ASYNC_RST(ASYNC_RST),
                        .Load(Load),
                        .EN(EN),
                        .Input(Inputs[WIDTH*LENGTH-(row*WIDTH+1):WIDTH*LENGTH-(row+1)*WIDTH]),
                        .Weight(ToDown[row-1][column]),
                        .PsumIn('b0),
                        .ToRight(ToRight[row][column]),
                        .ToDown(ToDown[row][column]),
                        .PsumOut(PsumOut[row][column])
                    );
                end
                else begin
                    Processing_Element #(WIDTH) PE (
                        .CLK(CLK),
                        .SYNC_RST(SYNC_RST),
                        .ASYNC_RST(ASYNC_RST),
                        .Load(Load),
                        .EN(EN),
                        .Input(ToRight[row][column-1]),
                        .Weight(ToDown[row-1][column]),
                        .PsumIn('b0),
                        .ToRight(ToRight[row][column]),
                        .ToDown(ToDown[row][column]),
                        .PsumOut(PsumOut[row][column])
                    );
                end
            end
        end
    endgenerate
endmodule
