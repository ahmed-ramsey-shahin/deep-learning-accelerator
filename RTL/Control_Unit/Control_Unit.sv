module Control_Unit #(
    // DRAM parameters
    parameter  integer DRAM_DATA_WIDTH=128,
    localparam integer DramBytesPerWord=DRAM_DATA_WIDTH/8,
    parameter  integer DRAM_ADDR_WIDTH=10,
    localparam integer DramAddrWidth=DRAM_ADDR_WIDTH+$clog2(DramBytesPerWord),
    // Unified Buffer Parameters
    parameter  integer SA_LENGTH=256,
    parameter  integer UB_ADDR_WIDTH=10,
    parameter  integer UB_NO_BANKS=8,
    localparam integer UbDataWidth=8*SA_LENGTH,
    localparam integer UbBytesPerWord=UbDataWidth/8,
    localparam integer UbAddrWidth=UB_ADDR_WIDTH+$clog2(UB_NO_BANKS)+$clog2(UbBytesPerWord),
    // Controller Parameters
    localparam integer OpcodeWidth=3,
    localparam integer ColWidth=$clog2(DramBytesPerWord),
    localparam integer RowWidth=DRAM_ADDR_WIDTH,
    localparam integer InstructionSize=OpcodeWidth+DramAddrWidth+UbAddrWidth+ColWidth+RowWidth,
    // Instruction memory parameters
    parameter  integer IM_ADDR_WIDTH=32
) (
    input  wire                                          CLK,
    input  wire                                          ASYNC_RST,
    input  wire                                          SYNC_RST,
    input  wire                                          EN,
    input  wire [InstructionSize-1:0]                    instruction,
    output reg                                           UB_brden,
    input  wire [7:0]                                    UB_rddata,
    output reg                                           UB_wren,
    output reg                                           UB_bwren,
    output reg  [UbAddrWidth-1:0]                        UB_wraddr,
    output reg  [UbAddrWidth-$clog2(UbBytesPerWord)-1:0] UB_bwraddr,
    output reg  [7:0]                                    UB_wrdata,
    output reg  [UbAddrWidth-1:0]                        UB_rdaddr,
    output reg  [UbAddrWidth-$clog2(UbBytesPerWord)-1:0] UB_brdaddr,
    input  wire [7:0]                                    DRAM_rddata,
    output reg  [DramAddrWidth-1:0]                      DRAM_rdaddr,
    output reg                                           DRAM_wren,
    output reg  [DramAddrWidth-1:0]                      DRAM_wraddr,
    output reg  [7:0]                                    DRAM_wrdata,
    output reg                                           DRAM_en,
    output reg                                           UB_en,
    output reg  [IM_ADDR_WIDTH-1:0]                      pc,
    output reg  [7:0]                                    NORM_shift_ammount,
    output reg  [7:0]                                    NORM_z,
    output reg                                           SA_load,
    output reg                                           SA_en
);
    typedef enum logic [1:0] {prepare, execute, finalize} state_e;
    typedef enum logic [OpcodeWidth-1:0] {
        nop,
        mvin,
        mvout,
        quantize,
        load,
        matmul
    } opcode_e;

    state_e cs, ns;
    opcode_e opcode;
    logic [DramAddrWidth-1:0] dram_addr;
    logic [UbAddrWidth-1:0]   ub_addr;
    logic [ColWidth-1:0]      no_cols;
    logic [RowWidth-1:0]      no_rows;
    logic [UbAddrWidth-1:0]   shift_ammount_addr;
    logic [UbAddrWidth-1:0]   zero_point_addr;
    logic [UbAddrWidth-1:0]   initial_weight_addr;

    assign opcode              = opcode_e'(instruction[InstructionSize-1:InstructionSize-OpcodeWidth]);
    assign dram_addr           = instruction[InstructionSize-OpcodeWidth-1-:DramAddrWidth];
    assign ub_addr             = instruction[InstructionSize-OpcodeWidth-DramAddrWidth-1-:UbAddrWidth];
    assign no_cols             = instruction[ColWidth+RowWidth-1:RowWidth];
    assign no_rows             = instruction[RowWidth-1:0];
    assign shift_ammount_addr  = instruction[2*UbAddrWidth-1:UbAddrWidth];
    assign zero_point_addr     = instruction[UbAddrWidth-1:0];
    assign initial_weight_addr = instruction[UbAddrWidth-$clog2(UbBytesPerWord)-1:0];

    logic [ColWidth-1:0]            col_counter;
    logic [ColWidth-1:0]            col_counter_prev;
    logic [ColWidth-1:0]            col_counter_prev2;
    logic [RowWidth-1:0]            row_counter;
    logic [RowWidth-1:0]            row_counter_prev;
    logic [RowWidth-1:0]            row_counter_prev2;
    logic [$clog2(SA_LENGTH+1)-1:0] load_counter;

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST) begin
            cs                <= prepare;
            col_counter_prev  <= 0;
            col_counter_prev2 <= 0;
            row_counter_prev  <= 0;
            row_counter_prev2 <= 0;
        end
        else if (EN) begin
            if (SYNC_RST) begin
                cs                <= prepare;
                col_counter_prev  <= 0;
                col_counter_prev2 <= 0;
                row_counter_prev  <= 0;
                row_counter_prev2 <= 0;
            end
            else begin
                cs                <= ns;
                col_counter_prev  <= col_counter;
                row_counter_prev  <= row_counter;
                col_counter_prev2 <= col_counter_prev;
                row_counter_prev2 <= row_counter_prev;
            end
        end
    end

    always_comb begin
        ns = cs;
        case (cs)
            prepare: begin
                ns = execute;
            end
            execute: begin
                case (opcode)
                    mvin, mvout: begin
                        if (row_counter_prev == no_rows) begin
                            ns = finalize;
                        end
                    end
                    quantize: begin
                        if (row_counter == 1) begin
                            ns = finalize;
                        end
                    end
                    load: begin
                        if (load_counter == SA_LENGTH) begin
                            ns = finalize;
                        end
                    end
                    default: begin
                        ns = finalize;
                    end
                endcase
            end
            finalize: begin
                ns = prepare;
            end
            default: begin
                ns = prepare;
            end
        endcase
    end

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST) begin
            pc           <= 0;
            UB_en        <= 0;
            DRAM_en      <= 0;
            row_counter  <= 0;
            col_counter  <= 0;
            load_counter <= 0;
            DRAM_wren    <= 0;
            DRAM_rdaddr  <= 0;
            DRAM_wraddr  <= 0;
            UB_wren      <= 0;
            UB_wrdata    <= 0;
            UB_wraddr    <= 0;
            UB_rdaddr    <= 0;
            UB_bwren     <= 0;
            UB_brden     <= 0;
            UB_bwraddr   <= 0;
            UB_brdaddr   <= 0;
            SA_en        <= 0;
            SA_load      <= 0;
        end
        else if (EN) begin
            if (SYNC_RST) begin
                pc           <= 0;
                UB_en        <= 0;
                DRAM_en      <= 0;
                row_counter  <= 0;
                col_counter  <= 0;
                load_counter <= 0;
                DRAM_wren    <= 0;
                DRAM_rdaddr  <= 0;
                DRAM_wraddr  <= 0;
                UB_wren      <= 0;
                UB_wrdata    <= 0;
                UB_wraddr    <= 0;
                UB_rdaddr    <= 0;
                UB_bwren     <= 0;
                UB_brden     <= 0;
                UB_bwraddr   <= 0;
                UB_brdaddr   <= 0;
                SA_en        <= 0;
                SA_load      <= 0;
            end
            else begin
                case (cs)
                    prepare: begin
                        case (opcode)
                            mvin, mvout: begin
                                UB_en   <= 1'b1;
                                DRAM_en <= 1'b1;
                            end
                            quantize: begin
                                UB_en     <= 1'b1;
                                UB_rdaddr <= shift_ammount_addr;
                            end
                            load: begin
                                UB_en        <= 1'b1;
                                SA_load      <= 1'b1;
                                SA_en        <= 1'b1;
                                UB_brden     <= 1'b1;
                                UB_brdaddr   <= initial_weight_addr;
                                load_counter <= load_counter + 1;
                            end
                            default: begin
                            end
                        endcase
                    end
                    execute: begin
                        case (opcode)
                            mvin: begin
                                DRAM_rdaddr <= dram_addr +
                                    {row_counter[RowWidth-1:0], col_counter[ColWidth-1:0]};
                                UB_wraddr   <= ub_addr +
                                    {
                                        row_counter_prev2[RowWidth-1:0],
                                        {$clog2(UB_NO_BANKS){1'b0}},
                                        col_counter_prev2[ColWidth-1:0]
                                    };
                                UB_wrdata   <= DRAM_rddata;
                                col_counter <= col_counter + 1;
                                if (col_counter == no_cols - 1) begin
                                    col_counter <= 0;
                                    row_counter <= row_counter + 1;
                                end
                                if (col_counter_prev != 0 || row_counter_prev != 0) begin
                                    UB_wren <= 1;
                                end
                            end
                            mvout: begin
                                DRAM_wraddr <= dram_addr +
                                    {
                                        row_counter_prev2[RowWidth-1:0],
                                        col_counter_prev2[ColWidth-1:0]
                                    };
                                UB_rdaddr <= ub_addr +
                                    {
                                        row_counter[RowWidth-1:0],
                                        {$clog2(UB_NO_BANKS){1'b0}},
                                        col_counter[ColWidth-1:0]
                                    };
                                DRAM_wrdata <= UB_rddata;
                                col_counter <= col_counter + 1;
                                if (col_counter == no_cols - 1) begin
                                    col_counter <= 0;
                                    row_counter <= row_counter + 1;
                                end
                                if (col_counter_prev != 0 || row_counter_prev != 0) begin
                                    DRAM_wren <= 1;
                                end
                            end
                            quantize: begin
                                if (row_counter == 0) begin
                                    UB_rdaddr <= zero_point_addr;
                                end
                                else if (row_counter == 1) begin
                                    NORM_shift_ammount <= UB_rddata;
                                end
                                row_counter <= row_counter + 1;
                            end
                            load: begin
                                UB_brdaddr <= initial_weight_addr + {
                                    load_counter,
                                    {$clog2(UB_NO_BANKS){1'b0}}
                                };
                                load_counter <= load_counter + 1;
                            end
                            default: begin
                            end
                        endcase
                    end
                    finalize: begin
                        pc           <= pc + 1;
                        UB_en        <= 0;
                        DRAM_en      <= 0;
                        row_counter  <= 0;
                        col_counter  <= 0;
                        load_counter <= 0;
                        DRAM_wren    <= 0;
                        DRAM_rdaddr  <= 0;
                        DRAM_wraddr  <= 0;
                        UB_wren      <= 0;
                        UB_wraddr    <= 0;
                        UB_wrdata    <= 0;
                        UB_rdaddr    <= 0;
                        UB_bwren     <= 0;
                        UB_brden     <= 0;
                        UB_bwraddr   <= 0;
                        UB_brdaddr   <= 0;
                        SA_load      <= 0;
                        SA_en        <= 0;
                        case (opcode)
                            quantize: begin
                                NORM_z <= UB_rddata;
                            end
                            default: begin
                            end
                        endcase
                    end
                    default: begin
                    end
                endcase
            end
        end
    end
endmodule
