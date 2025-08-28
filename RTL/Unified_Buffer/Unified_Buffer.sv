module Unified_Buffer #(
    parameter integer DATA_WIDTH=8,
    parameter integer NUM_BANKS=16,
    parameter integer BANK_DEPTH=4096,
    localparam integer ROW_BITS   = $clog2(BANK_DEPTH)
) (
    input  wire                         CLK,
    input  wire                         ASYNC_RST,
    input  wire                         SYNC_RST,
    input  wire                         EN,
    input  wire                         PortOneReadValid    [NUM_BANKS],
    input  wire                         PortTwoReadValid    [NUM_BANKS],
    input  wire                         PortOneWriteValid   [NUM_BANKS],
    input  wire                         PortTwoWriteValid   [NUM_BANKS],
    input  wire        [ROW_BITS-1:0]   PortOneReadAddress  [NUM_BANKS],
    input  wire        [ROW_BITS-1:0]   PortTwoReadAddress  [NUM_BANKS],
    input  wire        [ROW_BITS-1:0]   PortOneWriteAddress [NUM_BANKS],
    input  wire        [ROW_BITS-1:0]   PortTwoWriteAddress [NUM_BANKS],
    input  wire signed [DATA_WIDTH-1:0] PortOneWriteData    [NUM_BANKS],
    input  wire signed [DATA_WIDTH-1:0] PortTwoWriteData    [NUM_BANKS],
    output reg  signed [DATA_WIDTH-1:0] PortOneReadData     [NUM_BANKS],
    output reg  signed [DATA_WIDTH-1:0] PortTwoReadData     [NUM_BANKS]
);
    genvar bank;
    generate
        for (bank = 0; bank < NUM_BANKS; bank++) begin : gen_bank
            reg [DATA_WIDTH-1:0] mem [BANK_DEPTH];

            // Read block
            always @(posedge CLK or negedge ASYNC_RST) begin
                if (~ASYNC_RST) begin
                    PortOneReadData[bank] <= 'd0;
                    PortTwoReadData[bank] <= 'd0;
                end
                else if (SYNC_RST) begin
                    PortOneReadData[bank] <= 'd0;
                    PortTwoReadData[bank] <= 'd0;
                end
                else if (EN) begin
                    if (PortOneReadValid[bank]) begin
                        PortOneReadData[bank] <= mem[PortOneReadAddress[bank]];
                    end
                    if (PortTwoReadValid[bank]) begin
                        PortTwoReadData[bank] <= mem[PortTwoReadAddress[bank]];
                    end
                end
            end

            // Write block
            always @(posedge CLK or negedge ASYNC_RST) begin
                if (EN) begin
                    if (PortOneWriteValid[bank]) begin
                        mem[PortOneWriteAddress[bank]] <= PortOneWriteData[bank];
                    end
                    if (PortTwoWriteValid[bank]) begin
                        mem[PortTwoWriteAddress[bank]] <= PortTwoWriteData[bank];
                    end
                end
            end
        end
    endgenerate
endmodule

