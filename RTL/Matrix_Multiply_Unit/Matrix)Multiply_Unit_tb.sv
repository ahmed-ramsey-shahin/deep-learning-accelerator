Module Matrix_Multiply_Unit_tb ();
    localparam       WIDTH  = 8;
    localparam       LENGTH = 5;
    reg              CLK;
    reg              ASYNC_RST;
    reg              SYNC_RST;
    reg              EN;
    reg  [WIDTH-1:0] Inputs  [0:LENGTH-1];
    reg  [WIDTH-1:0] Weights [0:LENGTH-1];
    wire [2*WIDTH:0] PsumOut [0:LENGTH-1][0:LENGTH-1];

    always begin
        CLK = 1'b1;
        #5;
        CLK = 1'b0;
        #5;
    end

    initial begin
        //
    end
endmodule
