module Processing_Element #(
    parameter integer DATA_WIDTH=8,
    parameter integer ACCUMULATOR_DATA_WIDTH=32
) (
    input  wire                                     CLK,
    input  wire                                     ASYNC_RST,
    input  wire                                     SYNC_RST,
    input  wire                                     EN,
    input  wire                                     LOAD,
    input  wire signed [DATA_WIDTH-1:0]             Input,
    input  wire signed [ACCUMULATOR_DATA_WIDTH-1:0] PsumIn,
    output reg  signed [DATA_WIDTH-1:0]             ToRight,
    output reg  signed [ACCUMULATOR_DATA_WIDTH-1:0] PsumOut
);
    reg signed [DATA_WIDTH-1:0] registered_weight;
    reg signed [DATA_WIDTH-1:0] WeightToRight;
    reg signed [DATA_WIDTH-1:0] InputToRight;

    always @(*) begin
        if (LOAD) begin
            ToRight = WeightToRight;
        end
        else begin
            ToRight = InputToRight;
        end
    end

    always @(posedge CLK or negedge ASYNC_RST) begin
        if (~ASYNC_RST) begin
            registered_weight <= 'd0;
            WeightToRight     <= 'd0;
            InputToRight      <= 'd0;
            PsumOut           <= 'd0;
        end
        else if (EN) begin
            if (SYNC_RST) begin
                registered_weight <= 'd0;
                WeightToRight     <= 'd0;
                InputToRight      <= 'd0;
                PsumOut           <= 'd0;
            end
            else if (LOAD) begin
                registered_weight <= Input;
                WeightToRight     <= Input;
            end
            else begin
                PsumOut      <= (Input * registered_weight) + PsumIn;
                InputToRight <= Input;
            end
        end
    end
endmodule

