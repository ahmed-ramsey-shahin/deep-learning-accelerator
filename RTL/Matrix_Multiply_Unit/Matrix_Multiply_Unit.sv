module Matrix_Multiply_Unit #(parameter WIDTH=8, parameter LENGTH=256) (
    input  wire               CLK,
    input  wire               ASYNC_RST,
    input  wire               SYNC_RST,
    input  wire               EN,
    input  wire [WIDTH-1:0]   Inputs  [0:LENGTH-1],
    input  wire [WIDTH-1:0]   Weights [0:LENGTH-1],
    output wire [2*WIDTH-1:0] Result  [0:LENGTH-1]
);
    genvar row;
    genvar col;

    wire [WIDTH-1:0]   InputOut   [0:LENGTH-1][0:LENGTH-1];
    wire [WIDTH-1:0]   WeightOut  [0:LENGTH-1][0:LENGTH-1];
    wire [2*WIDTH-1:0] Results    [0:LENGTH-1][0:LENGTH-1];

    assign Result = Results[LENGTH-1][LENGTH-1];

    generate
        for (row = 0; row < LENGTH; row = row + 1) begin : gen_row
            for (col = 0; col < LENGTH; col = col + 1) begin : gen_col
                if (row == 0 & col == 0) begin : gen_first_PE
                    Processing_Element #(.WIDTH(WIDTH)) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .InputIn(Inputs[0]),
                        .WeightIn(Weights[0]),
                        .InputOut(InputOut[row][col]),
                        .WeightOut(WeightOut[row][col]),
                        .Result(Results[row][col])
                    );
                end
                else if (row == 0 & col != 0) begin : gen_first_row_PE
                    Processing_Element #(.WIDTH(WIDTH)) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .InputIn(InputOut[row][col-1]),
                        .WeightIn(Weights[col]),
                        .InputOut(InputOut[row][col]),
                        .WeightOut(WeightOut[row][col]),
                        .Result(Results[row][col])
                    );
                end
                else if (row != 0 & col == 0) begin : gen_first_col_PE
                    Processing_Element #(.WIDTH(WIDTH)) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .InputIn(Inputs[row]),
                        .WeightIn(WeightOut[row-1][col]),
                        .InputOut(InputOut[row][col]),
                        .WeightOut(WeightOut[row][col]),
                        .Result(Results[row][col])
                    );
                end
                else begin : gen_PE
                    Processing_Element #(.WIDTH(WIDTH)) PE (
                        .CLK(CLK),
                        .ASYNC_RST(ASYNC_RST),
                        .SYNC_RST(SYNC_RST),
                        .EN(EN),
                        .InputIn(InputOut[row][col-1]),
                        .WeightIn(WeightOut[row-1][col]),
                        .InputOut(InputOut[row][col]),
                        .WeightOut(WeightOut[row][col]),
                        .Result(Results[row][col])
                    );
                end
            end
        end
    endgenerate
endmodule
