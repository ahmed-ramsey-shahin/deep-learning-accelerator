module Unified_Buffer #(
    parameter  integer SA_LENGTH=256,
    parameter  integer ADDR_WIDTH=10,
    parameter  integer NO_BANKS=8,
    localparam integer DataWidth=8*SA_LENGTH,
    localparam integer BytesPerWord=DataWidth/8,
    localparam integer AddrWidth=ADDR_WIDTH+$clog2(NO_BANKS)+$clog2(BytesPerWord)
) (
    input  wire                 CLK,
    input  wire                 ASYNC_RST,
    input  wire                 SYNC_RST,
    input  wire                 EN,
    input  wire                 wren,
    input  wire [AddrWidth-1:0] wraddr,
    input  wire [7:0]           wrdata,
    input  wire [AddrWidth-1:0] rdaddr,
    output reg  [7:0]           rddata
);
    reg  [DataWidth-1:0]            mem [(1 << ADDR_WIDTH)][NO_BANKS];
    wire [ADDR_WIDTH-1:0]           wr_word_addr;
    wire [ADDR_WIDTH-1:0]           rd_word_addr;
    wire [$clog2(NO_BANKS)-1:0]     wr_bank;
    wire [$clog2(NO_BANKS)-1:0]     rd_bank;
    wire [$clog2(BytesPerWord)-1:0] wr_byte_addr;
    wire [$clog2(BytesPerWord)-1:0] rd_byte_addr;

    assign wr_word_addr = wraddr[AddrWidth-1:AddrWidth-ADDR_WIDTH];
    assign rd_word_addr = rdaddr[AddrWidth-1:AddrWidth-ADDR_WIDTH];
    assign wr_bank      = wraddr[$clog2(BytesPerWord)+$clog2(NO_BANKS)-1:$clog2(BytesPerWord)];
    assign rd_bank      = rdaddr[$clog2(BytesPerWord)+$clog2(NO_BANKS)-1:$clog2(BytesPerWord)];
    assign wr_byte_addr = wraddr[$clog2(BytesPerWord)-1:0];
    assign rd_byte_addr = rdaddr[$clog2(BytesPerWord)-1:0];

    always @(posedge CLK) begin
        if (EN & !SYNC_RST) begin
            if (wren) begin
                for (integer i = 0; i < BytesPerWord; i++) begin
                    if (i == wr_byte_addr) begin
                        mem[wr_word_addr][wr_bank][8*i+:8] <= wrdata;
                    end
                end
            end
        end
    end

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST) begin
            rddata <= 0;
        end
        else if (EN) begin
            if (SYNC_RST) begin
                rddata <= 0;
            end
            else begin
                for (integer i = 0; i < BytesPerWord; i++) begin
                    if (i == rd_byte_addr) begin
                        rddata <= mem[rd_word_addr][rd_bank][8*i+:8];
                    end
                end
            end
        end
    end
endmodule
