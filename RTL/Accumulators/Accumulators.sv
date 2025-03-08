module Accumulators #(
    parameter VECTOR_WIDTH=256,
    parameter NO_VECTORS=4096,
    parameter DATA_WIDTH=32,
    parameter VECTOR_SELECTOR_WIDTH=12
) (
    input  wire                             CLK,
    input  wire                             ASYNC_RST,
    input  wire                             SYNC_RST,
    input  wire                             EN,
    input  wire [DATA_WIDTH-1:0]            Inputs  [0:VECTOR_WIDTH-1],
    input  wire [VECTOR_SELECTOR_WIDTH-1:0] InputVectorSelector,
    input  wire [VECTOR_SELECTOR_WIDTH-1:0] OutputVectorSelector,
    output reg  [DATA_WIDTH-1:0]            Result  [0:VECTOR_WIDTH-1]
);

    int i, j;
    reg [DATA_WIDTH-1:0] Vectors [0:NO_VECTORS-1][0:VECTOR_WIDTH-1];

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST | SYNC_RST) begin
            // Reset all accumulators
            for (i = 0; i < NO_VECTORS; i = i + 1) begin
                for (j = 0; j < VECTOR_WIDTH; j = j + 1) begin
                    Vectors[i][j] <= 0;
                end
            end
            for (i = 0; i < VECTOR_WIDTH; i = i + 1) begin
                Result[i] <= 0;
            end
        end
        else if (EN) begin
            for (i = 0; i < VECTOR_WIDTH; i = i + 1) begin
                Result[i] <= Vectors[OutputVectorSelector][i];
                Vectors[InputVectorSelector][i] <= Inputs[i];
            end
        end
    end
endmodule

