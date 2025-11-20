module Unified_Buffer #(
    parameter  integer SA_LENGTH=256,
    parameter  integer ADDR_WIDTH=10,
    parameter  integer NO_BANKS=8,
    localparam integer DataWidth=SA_LENGTH*8,
    localparam integer BytesPerWord=DataWidth/8,
    localparam integer AddrWidth=ADDR_WIDTH+$clog2(NO_BANKS)+$clog2(BytesPerWord)
) (
    input  wire                                      CLK,
    input  wire                                      ASYNC_RST,
    input  wire                                      SYNC_RST,
    input  wire                                      EN,
    input  wire                                      wren,
    input  wire                                      bwren,
    input  wire [AddrWidth-1:0]                      wraddr,
    input  wire [AddrWidth-$clog2(BytesPerWord)-1:0] bwraddr,
    input  wire [7:0]                                wrdata,
    input  wire [7:0]                                bwrdata [SA_LENGTH],
    input  wire                                      brden,
    input  wire [AddrWidth-1:0]                      rdaddr,
    input  wire [AddrWidth-$clog2(BytesPerWord)-1:0] brdaddr,
    output reg  [7:0]                                rddata,
    output reg  [7:0]                                brddata [SA_LENGTH]
);
    reg  [7:0]                      mem [NO_BANKS][(1 << ADDR_WIDTH)][BytesPerWord];
    wire [ADDR_WIDTH-1:0]           wr_word_addr;
    wire [ADDR_WIDTH-1:0]           bwr_word_addr;
    wire [ADDR_WIDTH-1:0]           rd_word_addr;
    wire [ADDR_WIDTH-1:0]           brd_word_addr;
    wire [$clog2(NO_BANKS)-1:0]     wr_bank;
    wire [$clog2(NO_BANKS)-1:0]     bwr_bank;
    wire [$clog2(NO_BANKS)-1:0]     rd_bank;
    wire [$clog2(NO_BANKS)-1:0]     brd_bank;
    wire [$clog2(BytesPerWord)-1:0] wr_byte_addr;
    wire [$clog2(BytesPerWord)-1:0] rd_byte_addr;

    assign wr_word_addr  = wraddr[AddrWidth-1:AddrWidth-ADDR_WIDTH];
    assign bwr_word_addr = bwraddr[AddrWidth-$clog2(BytesPerWord)-1:AddrWidth-$clog2(BytesPerWord)-ADDR_WIDTH];
    assign rd_word_addr  = rdaddr[AddrWidth-1:AddrWidth-ADDR_WIDTH];
    assign brd_word_addr = brdaddr[AddrWidth-$clog2(BytesPerWord)-1:AddrWidth-$clog2(BytesPerWord)-ADDR_WIDTH];
    assign wr_bank       = wraddr[$clog2(BytesPerWord)+$clog2(NO_BANKS)-1:$clog2(BytesPerWord)];
    assign bwr_bank      = bwraddr[$clog2(NO_BANKS)-1:0];
    assign rd_bank       = rdaddr[$clog2(BytesPerWord)+$clog2(NO_BANKS)-1:$clog2(BytesPerWord)];
    assign brd_bank      = brdaddr[$clog2(NO_BANKS)-1:0];
    assign wr_byte_addr  = wraddr[$clog2(BytesPerWord)-1:0];
    assign rd_byte_addr  = rdaddr[$clog2(BytesPerWord)-1:0];

    always @(posedge CLK) begin
        if (EN & !SYNC_RST) begin
            if (wren) begin
                for (integer i = 0; i < BytesPerWord; i++) begin
                    if (i == wr_byte_addr) begin
                        mem[wr_bank][wr_word_addr][i] <= wrdata;
                    end
                end
            end
            else if (bwren) begin
                for (integer i = 0; i < BytesPerWord; i++) begin
                    mem[bwr_bank][bwr_word_addr][i] <= bwrdata[i];
                end
            end
        end
    end

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST) begin
            rddata  <= 0;
        end
        else if (EN) begin
            if (SYNC_RST) begin
                rddata  <= 0;
            end
            else begin
                if (brden) begin
                    for (integer i = 0; i < BytesPerWord; i++) begin
                        brddata[i] <= mem[brd_bank][brd_word_addr][i];
                    end
                end
                for (integer i = 0; i < BytesPerWord; i++) begin
                    if (i == rd_byte_addr) begin
                        rddata <= mem[rd_bank][rd_word_addr][i];
                    end
                end
            end
        end
    end
endmodule
