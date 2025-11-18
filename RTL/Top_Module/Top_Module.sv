module Top_Module;
    // DRAM parameters
    parameter  integer DRAM_DATA_WIDTH=128;
    localparam integer DramBytesPerWord=DRAM_DATA_WIDTH/8;
    parameter  integer DRAM_ADDR_WIDTH=4;
    localparam integer DramAddrWidth=DRAM_ADDR_WIDTH+$clog2(DramBytesPerWord);
    // Unified Buffer Parameters
    parameter  integer SA_LENGTH=10;
    parameter  integer UB_ADDR_WIDTH=4;
    parameter  integer UB_NO_BANKS=4;
    localparam integer UbDataWidth=8*SA_LENGTH;
    localparam integer UbBytesPerWord=UbDataWidth/8;
    localparam integer UbAddrWidth=UB_ADDR_WIDTH+$clog2(UB_NO_BANKS)+$clog2(UbBytesPerWord);
    // Controller Parameters
    localparam integer OpcodeWidth=3;
    localparam integer ColWidth=$clog2(DramBytesPerWord);
    localparam integer RowWidth=DRAM_ADDR_WIDTH;
    localparam integer InstructionSize=OpcodeWidth+DramAddrWidth+UbAddrWidth+ColWidth+RowWidth;
    // Instruction memory parameters
    parameter  integer IM_ADDR_WIDTH=32;

    bit                         CLK;
    logic                       ASYNC_RST;
    logic                       SYNC_RST;
    logic                       EN;
    logic [InstructionSize-1:0] instruction;
    logic [7:0]                 UB_rddata;
    logic                       UB_wren;
    logic [UbAddrWidth-1:0]     UB_wraddr;
    logic [7:0]                 UB_wrdata;
    logic [UbAddrWidth-1:0]     UB_rdaddr;
    logic [7:0]                 DRAM_rddata;
    logic [DramAddrWidth-1:0]   DRAM_rdaddr;
    logic                       DRAM_wren;
    logic [DramAddrWidth-1:0]   DRAM_wraddr;
    logic [7:0]                 DRAM_wrdata;
    logic                       DRAM_en;
    logic                       UB_en;
    logic [IM_ADDR_WIDTH-1:0]   pc;
    logic                       test;
    logic                       test_en;
    logic [DramAddrWidth-1:0]   test_rdaddr;
    logic                       test_wren;
    logic [DramAddrWidth-1:0]   test_wraddr;
    logic [7:0]                 test_wrdata;
    logic [7:0]                 NORM_shift_ammount;
    logic [7:0]                 NORM_z;

    always #5 CLK = ~CLK;

    Control_Unit #(
        .DRAM_DATA_WIDTH(DRAM_DATA_WIDTH),
        .DRAM_ADDR_WIDTH(DRAM_ADDR_WIDTH),
        .SA_LENGTH(SA_LENGTH),
        .UB_ADDR_WIDTH(UB_ADDR_WIDTH),
        .UB_NO_BANKS(UB_NO_BANKS),
        .IM_ADDR_WIDTH(IM_ADDR_WIDTH)
    ) control (.*);

    DRAM #(
        .DATA_WIDTH(DRAM_DATA_WIDTH),
        .ADDR_WIDTH(DRAM_ADDR_WIDTH)
    ) ram (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(test ? test_en : DRAM_en),
        .wren(test ? test_wren : DRAM_wren),
        .wraddr(test ? test_wraddr : DRAM_wraddr),
        .wrdata(test ? test_wrdata : DRAM_wrdata),
        .rdaddr(test ? test_rdaddr : DRAM_rdaddr),
        .rddata(DRAM_rddata)
    );

    Unified_Buffer #(
        .SA_LENGTH(SA_LENGTH),
        .ADDR_WIDTH(UB_ADDR_WIDTH),
        .NO_BANKS(UB_NO_BANKS)
    ) ub (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(UB_en),
        .wren(UB_wren),
        .wraddr(UB_wraddr),
        .wrdata(UB_wrdata),
        .rdaddr(UB_rdaddr),
        .rddata(UB_rddata)
    );

    Normalization #(
        .IN_WIDTH(),
        .OUT_WIDTH(16+$clog2(SA_LENGTH)),
        .SA_LENGTH(SA_LENGTH)
    ) norm (
        .ShiftAmmount(NORM_shift_ammount),
        .Z(NORM_z)
        // .In(),
        // .Out()
    );

    initial begin
        ASYNC_RST = 1'b0;
        SYNC_RST  = 1'b0;
        EN        = 1'b0;
        #2;
        ASYNC_RST = 1'b1;
        @(negedge CLK);
        instruction  = {2'b00, 8'b0010_0011, 10'b0011100000, 4'd3, 4'd3};
        for (integer i = 0; i < (1 << DramAddrWidth) + 1; i++) begin
            test        = 1'b1;
            test_en     = 1'b1;
            test_wren   = 1'b1;
            test_wraddr = i;
            test_wrdata = i[DramAddrWidth-1:$clog2(DramBytesPerWord)] +
                i[$clog2(DramBytesPerWord)-1:0];
            @(negedge CLK);
        end
        test = 1'b0;
        EN   = 1'b1;
        $display("test started");
        instruction  = {3'b001, 8'b0010_0011, 10'b0011_10_0000, 4'd3, 4'd3};
        @(pc) $display("mvin finished");
        instruction  = {3'b010, 8'b0010_0011, 10'b0011_10_0000, 4'd3, 4'd3};
        @(pc) $display("mvout finished");
        instruction  = {3'b011, 6'd0, 10'b0011_10_0000, 10'b0011_10_0001};
        @(pc) $display("quantize finished");
        $stop;
    end
endmodule
