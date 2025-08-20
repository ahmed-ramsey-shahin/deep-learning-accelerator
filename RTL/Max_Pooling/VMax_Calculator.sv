module VMax_Calculator #(
    parameter integer DATA_WIDTH=32,
    parameter integer SA_LENGTH=256,
    parameter integer MAX_FILTER_SIZE=7
) (
    input  wire signed [DATA_WIDTH-1:0] HMax  [SA_LENGTH],
    output reg  signed [DATA_WIDTH-1:0] VMaxs [MAX_FILTER_SIZE][SA_LENGTH]
);
    always_comb begin
        integer i, j, k;
        VMaxs[0] = HMax;
        for (i = 1; i < MAX_FILTER_SIZE; i = i + 1) begin
            for (j = 0; j < SA_LENGTH; j = j + 1) begin
                VMaxs[i][j] = 0;
                for (k = (i+1)*j; k < ((i+1)*j)+(i+1); k = k + 1) begin
                    if (k < SA_LENGTH) begin
                        if (HMax[k] > VMaxs[i][j]) begin
                            VMaxs[i][j] = HMax[k];
                        end
                    end
                end
            end
        end
    end
endmodule

