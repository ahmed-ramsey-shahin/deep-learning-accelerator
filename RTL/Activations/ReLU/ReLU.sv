module ReLU (in, en, out);
    parameter DATA_WIDTH = 8;
    parameter SA_LENGTH = 256;
    input signed [DATA_WIDTH-1:0] in [SA_LENGTH];
    input en;
    output reg signed [DATA_WIDTH-1:0] out [SA_LENGTH];

    integer i;
    always @(*) begin
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            if (en) begin
                if (in[i][DATA_WIDTH-1] == 1'b1) begin
                    out[i] = 0;
                end else begin
                    out[i] = in[i];
                end
            end else begin
                out[i] = 0;
            end    
        end
    end

endmodule