module Max_Pooling #(
    parameter integer DATA_WIDTH=32,
    parameter integer SA_LENGTH=256,
    parameter integer MAX_FILTER_SIZE=7
) (
    input  wire                                      CLK,
    input  wire                                      ASYNC_RST,
    input  wire                                      SYNC_RST,
    input  wire                                      EN,
    input  wire        [$clog2(SA_LENGTH)-1:0]       ImageHeight,
    input  wire        [$clog2(SA_LENGTH)-1:0]       ImageWidth,
    input  wire        [$clog2(MAX_FILTER_SIZE)-1:0] FilterSize,
    input  wire signed [DATA_WIDTH-1:0]              InputColumn  [SA_LENGTH],
    output reg  signed [DATA_WIDTH-1:0]              OutputColumn [SA_LENGTH]
);
    wire        [$clog2(MAX_FILTER_SIZE)-1:0] FinishedFiltersCounterValue;
    wire                                      ImageWidthCounterDone;
    wire                                      FilterSizeCounterDone;
    wire        [$clog2(SA_LENGTH)-1:0]       ImageWidthCounterValue;
    wire        [$clog2(MAX_FILTER_SIZE)-1:0] FilterSizeCounterValue;
    reg  signed [DATA_WIDTH-1:0]              HMaxs        [MAX_FILTER_SIZE][SA_LENGTH];
    reg  signed [DATA_WIDTH-1:0]              HMax         [SA_LENGTH];
    reg  signed [DATA_WIDTH-1:0]              VMaxs        [MAX_FILTER_SIZE][SA_LENGTH];
    reg  signed [DATA_WIDTH-1:0]              VMax         [SA_LENGTH];
    reg  signed [DATA_WIDTH-1:0]              cache_memory [MAX_FILTER_SIZE][SA_LENGTH];

    Counter #($clog2(SA_LENGTH)) ImageWidthCounter (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(EN),
        .MaxNumber(ImageWidth),
        .Value(ImageWidthCounterValue),
        .Done(ImageWidthCounterDone)
    );

    Counter #($clog2(MAX_FILTER_SIZE)) FilterSizeCounter (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST | ImageWidthCounterDone),
        .EN(EN),
        .MaxNumber(FilterSize),
        .Value(FilterSizeCounterValue),
        .Done(FilterSizeCounterDone)
    );

    Counter #($clog2(SA_LENGTH)) FinishedFiltersCounter (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(ImageWidthCounterDone | SYNC_RST),
        .EN(EN & FilterSizeCounterDone),
        .MaxNumber(SA_LENGTH),
        .Value(FinishedFiltersCounterValue)
    );

    VMax_Calculator #(
        .DATA_WIDTH(DATA_WIDTH),
        .SA_LENGTH(SA_LENGTH),
        .MAX_FILTER_SIZE(MAX_FILTER_SIZE)
    ) vmax_calc (
        .HMax(HMax),
        .VMaxs(VMaxs)
    );

    always_comb begin
        integer i, j;
        for (j = 0; j < SA_LENGTH; j = j + 1) begin
            HMaxs[0][j] = cache_memory[0][j];
            for (i = 1; i < MAX_FILTER_SIZE; i = i + 1) begin
                if (HMaxs[i-1][j] < cache_memory[i][j]) begin
                    HMaxs[i][j] = cache_memory[i][j];
                end
                else begin
                    HMaxs[i][j] = HMaxs[i-1][j];
                end
            end
        end
    end

    always_comb begin
        integer i;
        if (!FilterSizeCounterDone) begin
            if (ImageWidthCounterDone) begin
                if (ImageWidth - FinishedFiltersCounterValue * FilterSize == 1) begin
                    for (i = 0; i < SA_LENGTH; i = i + 1) begin
                        HMax[i] = InputColumn[i];
                    end
                end
                else begin
                    for (i = 0; i < SA_LENGTH; i = i + 1) begin
                        if (HMaxs[(ImageWidth - FinishedFiltersCounterValue * FilterSize)-2][i] > InputColumn[i]) begin
                            HMax[i] = HMaxs[(ImageWidth - FinishedFiltersCounterValue * FilterSize)-2][i];
                        end
                        else begin
                            HMax[i] = InputColumn[i];
                        end
                    end
                end
            end
        end
        else begin
            for (i = 0; i < SA_LENGTH; i = i + 1) begin
                if (HMaxs[FilterSize-2][i] > InputColumn[i]) begin
                    HMax[i] = HMaxs[FilterSize-2][i];
                end
                else begin
                    HMax[i] = InputColumn[i];
                end
            end
        end
    end

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST) begin
            integer i;
            for (i = 0; i < SA_LENGTH; i = i + 1) begin
                OutputColumn[i] <= 'd0;
            end
        end
        else if (SYNC_RST) begin
            integer i;
            for (i = 0; i < SA_LENGTH; i = i + 1) begin
                OutputColumn[i] <= 'd0;
            end
        end
        else if (EN) begin
            integer i;
            if (!FilterSizeCounterDone) begin
                if (!ImageWidthCounterDone) begin
                    cache_memory[FilterSizeCounterValue] <= InputColumn;
                end
                else begin
                    OutputColumn <= VMaxs[FilterSize-1];
                end
            end
            else begin
                OutputColumn <= VMaxs[FilterSize-1];
            end
        end
    end
endmodule

