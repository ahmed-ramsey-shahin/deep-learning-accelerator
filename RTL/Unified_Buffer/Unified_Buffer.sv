module Unified_Buffer #(
    parameter integer DATA_WIDTH=8,
    parameter integer NUM_BANKS=16,
    parameter integer BANK_DEPTH=4096,
    localparam integer BANK_BITS  = $clog2(NUM_BANKS),
    localparam integer ROW_BITS   = $clog2(BANK_DEPTH),
    localparam integer ADDR_WIDTH = BANK_BITS + ROW_BITS
) (
    input  wire                         CLK,
    input  wire                         ASYNC_RST,
    input  wire                         SYNC_RST,
    input  wire                         EN,
    input  wire                         ActivationReadValid,
    input  wire                         WeightReadValid,
    input  wire                         DmaWriteValid,
    input  wire                         WbWriteValid,
    input  wire        [ADDR_WIDTH-1:0] ActivationReadAddress,
    input  wire        [ADDR_WIDTH-1:0] WeightReadAddress,
    input  wire        [ADDR_WIDTH-1:0] DmaWriteAddress,
    input  wire        [ADDR_WIDTH-1:0] WbWriteAddress,
    input  wire signed [DATA_WIDTH-1:0] DmaWriteData,
    input  wire signed [DATA_WIDTH-1:0] WbWriteData,
    output reg  signed [DATA_WIDTH-1:0] ActivationReadData,
    output reg  signed [DATA_WIDTH-1:0] WeightReadData
);
    wire [BANK_BITS-1:0] activation_bank = ActivationReadAddress[BANK_BITS-1:0];
    wire [ROW_BITS-1:0]  activation_row  = ActivationReadAddress[ADDR_WIDTH-1:BANK_BITS];

    wire [BANK_BITS-1:0] weight_bank     = WeightReadAddress[BANK_BITS-1:0];
    wire [ROW_BITS-1:0]  weight_row      = WeightReadAddress[ADDR_WIDTH-1:BANK_BITS];

    wire [BANK_BITS-1:0] dma_bank        = DmaWriteAddress[BANK_BITS-1:0];
    wire [ROW_BITS-1:0]  dma_row         = DmaWriteAddress[ADDR_WIDTH-1:BANK_BITS];

    wire [BANK_BITS-1:0] wb_bank         = WbWriteAddress[BANK_BITS-1:0];
    wire [ROW_BITS-1:0]  wb_row          = WbWriteAddress[ADDR_WIDTH-1:BANK_BITS];

    genvar b;
    generate
        for (b = 0; b < NUM_BANKS; b = b + 1) begin : gen_bank
            reg [DATA_WIDTH-1:0] mem [BANK_DEPTH];

            always @(posedge CLK or negedge ASYNC_RST) begin
                if (~ASYNC_RST) begin
                    ActivationReadData      <= 'd0;
                    WeightReadData          <= 'd0;
                end
                else if (SYNC_RST) begin
                    ActivationReadData      <= 'd0;
                    WeightReadData          <= 'd0;
                end
                else if (EN) begin
                    if (ActivationReadValid && (activation_bank == b[BANK_BITS-1:0])) begin
                        ActivationReadData <= mem[activation_row];
                    end
                    if (WeightReadValid && (weight_bank == b[BANK_BITS-1:0])) begin
                        WeightReadData <= mem[weight_row];
                    end
                end
            end

            always @(posedge CLK) begin
                if (EN) begin
                    if (WbWriteValid && (wb_bank == b[BANK_BITS-1:0])) begin
                        mem[wb_row]  <= WbWriteData;
                    end
                    else if (DmaWriteValid && (dma_bank == b[BANK_BITS-1:0])) begin
                        mem[dma_row] <= DmaWriteData;
                    end
                end
            end
        end
    endgenerate
endmodule

