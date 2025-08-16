module Systolic_Data_Setup #(
    parameter DATA_WIDTH=8,
    parameter SA_LENGTH=256
) (
    input  wire             CLK,
    input  wire             ASYNC_RST,
    input  wire             SYNC_RST,
    input  wire             EN,
    input  wire [DATA_WIDTH-1:0] Inputs  [0:SA_LENGTH-1],
    output wire [DATA_WIDTH-1:0] Outputs [0:SA_LENGTH-1]
);
    genvar row;
    genvar col;
    genvar i;
    reg [DATA_WIDTH-1:0] delays [0:((SA_LENGTH*(SA_LENGTH-1))/2)-1];

    generate
        for (row = 0; row < SA_LENGTH; row = row + 1) begin : gen_row
            for (col = 0; col < row; col = col + 1) begin  : gen_col
                always @(posedge CLK or negedge ASYNC_RST) begin
                    if(~ASYNC_RST | SYNC_RST) begin
                        delays[((row*(row-1))/2)+col] <= {DATA_WIDTH{1'b0}};
                    end
                    else if (EN) begin
                        if (col != row - 1) begin
                            delays[((row*(row-1))/2)+col] <= delays[((row*(row-1))/2)+col+1];
                        end
                        else begin
                            delays[((row*(row-1))/2)+col] <= Inputs[row];
                        end
                    end
                end
            end
        end
    endgenerate

    generate
        for (i = 0; i < SA_LENGTH; i = i + 1) begin : gen_output
            if (i == 0) begin : gen_not_registered
                assign Outputs[i] = Inputs[i];
            end
            else begin : gen_registered
                assign Outputs[i] = delays[((i*(i-1))/2)];
            end
        end
    endgenerate
endmodule

