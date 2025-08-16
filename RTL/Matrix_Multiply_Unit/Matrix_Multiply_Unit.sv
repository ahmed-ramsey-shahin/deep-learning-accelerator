module Matrix_Multiply_Unit #(
    parameter integer DATA_WIDTH=8,
    parameter integer ACCUMULATOR_DATA_WIDTH=32,
    parameter integer SA_LENGTH=256
) (
    input  wire                                     CLK,
    input  wire                                     ASYNC_RST,
    input  wire                                     SYNC_RST,
    input  wire                                     EN,
    input  wire                                     LOAD,
    input  wire signed [DATA_WIDTH-1:0]             Inputs  [SA_LENGTH],
    output wire signed [ACCUMULATOR_DATA_WIDTH-1:0] Result  [SA_LENGTH]
);
    genvar row;
    genvar col;
    genvar i;
    wire signed [DATA_WIDTH-1:0]             ToRight [SA_LENGTH][SA_LENGTH];
    wire signed [ACCUMULATOR_DATA_WIDTH-1:0] Psum    [SA_LENGTH][SA_LENGTH];

    generate
        for (i = 0; i < SA_LENGTH; i = i + 1) begin : gen_result
            assign Result[i] = Psum[SA_LENGTH-1][i];
        end
    endgenerate

    generate
        for (row = 0; row < SA_LENGTH; row = row + 1) begin : gen_row
            for (col = 0; col < SA_LENGTH; col = col + 1) begin : gen_col
                if (row == 0 & col == 0) begin : gen_first_PE
                    Processing_Element #(
                        .DATA_WIDTH(DATA_WIDTH),
                        .ACCUMULATOR_DATA_WIDTH(ACCUMULATOR_DATA_WIDTH)
                    ) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .LOAD(LOAD),
                        .Input(Inputs[row]),
                        .PsumIn('b0),
                        .ToRight(ToRight[row][col]),
                        .PsumOut(Psum[row][col])
                    );
                end
                else if (row == 0 & col != 0) begin : gen_first_row_PE
                    Processing_Element #(
                        .DATA_WIDTH(DATA_WIDTH),
                        .ACCUMULATOR_DATA_WIDTH(ACCUMULATOR_DATA_WIDTH)
                    ) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .LOAD(LOAD),
                        .Input(ToRight[row][col-1]),
                        .PsumIn('b0),
                        .ToRight(ToRight[row][col]),
                        .PsumOut(Psum[row][col])
                    );
                end
                else if (row != 0 & col == 0) begin : gen_first_col_PE
                    Processing_Element #(
                        .DATA_WIDTH(DATA_WIDTH),
                        .ACCUMULATOR_DATA_WIDTH(ACCUMULATOR_DATA_WIDTH)
                    ) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .LOAD(LOAD),
                        .Input(Inputs[row]),
                        .PsumIn(Psum[row-1][col]),
                        .ToRight(ToRight[row][col]),
                        .PsumOut(Psum[row][col])
                    );
                end
                else begin : gen_PE
                    Processing_Element #(
                        .DATA_WIDTH(DATA_WIDTH),
                        .ACCUMULATOR_DATA_WIDTH(ACCUMULATOR_DATA_WIDTH)
                    ) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .LOAD(LOAD),
                        .Input(ToRight[row][col-1]),
                        .PsumIn(Psum[row-1][col]),
                        .ToRight(ToRight[row][col]),
                        .PsumOut(Psum[row][col])
                    );
                end
            end
        end
    endgenerate
endmodule

