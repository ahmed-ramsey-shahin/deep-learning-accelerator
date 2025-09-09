module Shift_Register #(
    parameter integer LENGTH=1,
    parameter integer DATA_WIDTH=32
) (
    input  wire                         CLK,
    input  wire                         ASYNC_RST,
    input  wire                         SYNC_RST,
    input  wire                         EN,
    input  wire signed [DATA_WIDTH-1:0] In,
    output wire signed [DATA_WIDTH-1:0] Out
);
    reg [DATA_WIDTH-1:0] regs [LENGTH];
    genvar i;

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST) begin
            regs[0] <= 'd0;
        end
        else if (SYNC_RST) begin
            regs[0] <= 'd0;
        end
        else if (EN) begin
            regs[0] <= In;
        end
    end

    generate
        for (i = 1; i < LENGTH; i = i + 1) begin : gen_reg
            always @(posedge CLK or negedge ASYNC_RST) begin
                if (~ASYNC_RST) begin
                    regs[i] <= 'd0;
                end
                else if (SYNC_RST) begin
                    regs[i] <= 'd0;
                end
                else if (EN) begin
                    regs[i] <= regs[i-1];
                end
            end
        end
    endgenerate

    assign Out = regs[LENGTH-1];
endmodule

