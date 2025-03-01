module Accumulator #(parameter NO_VECTORS=4096, parameter SELECTOR_WIDTH=12, parameter NO_ACC_PER_VECTOR=256, parameter ACC_WIDTH=32) (
    input  wire                      CLK,
    input  wire                      ASYNC_RST,
    input  wire                      SYNC_RST,
    input  wire                      EN,
    input  wire [ACC_WIDTH-1:0]      Psum [0:NO_ACC_PER_VECTOR-1],
    input  wire [SELECTOR_WIDTH-1:0] WriteVectorSelector,
    input  wire [SELECTOR_WIDTH-1:0] ReadVectorSelector,
    output reg  [ACC_WIDTH-1:0]      ReadVector [0:NO_ACC_PER_VECTOR-1]
);
    // TODO: CODE THE MODULE HERE
endmodule
