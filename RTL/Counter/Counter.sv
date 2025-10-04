module Counter #(
    parameter integer COUNTER_WIDTH
) (
    input  wire                     CLK,
    input  wire                     ASYNC_RST,
    input  wire                     SYNC_RST,
    input  wire                     EN,
    input  wire [COUNTER_WIDTH-1:0] MaxNumber,
    output reg  [COUNTER_WIDTH-1:0] Value,
    output reg                      Done
);
    reg [COUNTER_WIDTH-1:0] new_value;

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST) begin
            Value <= 'd0;
        end
        else if (EN) begin
            if (SYNC_RST) begin
                Value <= 'd0;
            end
            else begin
                Value <= new_value;
            end
        end
    end

    always_comb begin
        new_value = Value + 'd1;
        Done      = 1'b0;
        if (new_value == MaxNumber) begin
            new_value = 'd0;
            Done      = 1'b1;
        end
    end
endmodule

