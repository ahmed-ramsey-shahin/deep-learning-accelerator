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
    // General parameters
    parameter  integer DATA_WIDTH=8;
    localparam integer AccumulatorDataWidth = 16+$clog2(SA_LENGTH);

    bit                                            CLK;
    logic                                          ASYNC_RST;
    logic                                          SYNC_RST;
    logic                                          EN;
    logic [InstructionSize-1:0]                    instruction;
    logic                                          UB_brden;
    logic [7:0]                                    UB_rddata;
    logic [7:0]                                    UB_brddata [SA_LENGTH];
    logic                                          UB_wren;
    logic                                          UB_bwren;
    logic [UbAddrWidth-1:0]                        UB_wraddr;
    logic [UbAddrWidth-$clog2(UbBytesPerWord)-1:0] UB_bwraddr;
    logic [7:0]                                    UB_wrdata;
    logic [7:0]                                    UB_bwrdata [SA_LENGTH];
    logic [UbAddrWidth-1:0]                        UB_rdaddr;
    logic [UbAddrWidth-$clog2(UbBytesPerWord)-1:0] UB_brdaddr;
    logic [7:0]                                    DRAM_rddata;
    logic [DramAddrWidth-1:0]                      DRAM_rdaddr;
    logic                                          DRAM_wren;
    logic [DramAddrWidth-1:0]                      DRAM_wraddr;
    logic [7:0]                                    DRAM_wrdata;
    logic                                          DRAM_en;
    logic                                          UB_en;
    logic [IM_ADDR_WIDTH-1:0]                      pc;
    logic [7:0]                                    NORM_shift_ammount;
    logic [7:0]                                    NORM_z;
    logic                                          test;
    logic                                          test_en;
    logic [DramAddrWidth-1:0]                      test_rdaddr;
    logic                                          test_wren;
    logic [DramAddrWidth-1:0]                      test_wraddr;
    logic [7:0]                                    test_wrdata;
    logic                                          SA_load;
    logic                                          SA_en;

    always #5 CLK = ~CLK;

    wire signed [DATA_WIDTH-1:0]           data_setup_outputs [SA_LENGTH];
    wire signed [AccumulatorDataWidth-1:0] mmu_outputs        [SA_LENGTH];
    wire signed [DATA_WIDTH-1:0]           norm_outputs       [SA_LENGTH];

    typedef enum logic [OpcodeWidth-1:0] {
        nop,
        mvin,
        mvout,
        quantize,
        load,
        matmul
    } opcode_e;

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
        .rddata(UB_rddata),
        .bwren(UB_bwren),
        .brden(UB_brden),
        .bwraddr(UB_bwraddr),
        .brdaddr(UB_brdaddr),
        .bwrdata(UB_bwrdata),
        .brddata(UB_brddata)
    );

    Matrix_Multiply_Unit #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACCUMULATOR_DATA_WIDTH(AccumulatorDataWidth),
        .SA_LENGTH(SA_LENGTH)
    ) mmu (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(SA_en),
        .LOAD(SA_load),
        .Inputs(UB_brddata),
        .Result(mmu_outputs)
    );

    Systolic_Data_Setup #(
        .DATA_WIDTH(DATA_WIDTH),
        .SA_LENGTH(SA_LENGTH)
    ) data_setup (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(SA_en),
        .Inputs(UB_brddata),
        .Outputs(data_setup_outputs)
    );

    Normalization #(
        .IN_WIDTH(AccumulatorDataWidth),
        .OUT_WIDTH(DATA_WIDTH),
        .SA_LENGTH(SA_LENGTH)
    ) norm (
        .ShiftAmmount(NORM_shift_ammount),
        .Z(NORM_z),
        .In(mmu_outputs),
        .Out(norm_outputs)
    );

    initial begin
        ASYNC_RST = 1'b0;
        SYNC_RST  = 1'b0;
        EN        = 1'b0;
        #2;
        ASYNC_RST = 1'b1;
        @(negedge CLK);
        instruction  = {29'd0};
        for (integer i = 0; i < (1 << DramAddrWidth) + 1; i++) begin
            test        = 1'b1;
            test_en     = 1'b1;
            test_wren   = 1'b1;
            test_wraddr = i;
            test_wrdata = i;
            @(negedge CLK);
        end
        test = 1'b0;
        EN   = 1'b1;
        $display("test started");
        instruction  = {mvin, 8'b0010_0011, 10'b0000_10_0000, 4'd10, 4'd12};
        @(pc) $display("mvin finished");
        instruction  = {mvout, 8'b0010_0011, 10'b0011_10_0000, 4'd3, 4'd3};
        @(pc) $display("mvout finished");
        instruction  = {quantize, 6'd0, 10'b0011_10_0000, 10'b0011_10_0001};
        @(pc) $display("quantize finished");
        instruction  = {load, 20'd0, 6'b0001_10};
        @(pc) $display("load finished");
        repeat(2) @(negedge CLK);
        $stop;
    end
endmodule
