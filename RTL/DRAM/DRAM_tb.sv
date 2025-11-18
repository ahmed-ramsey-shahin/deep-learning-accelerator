module DRAM_tb;
    localparam integer ADDR_WIDTH=4;
    localparam integer DATA_WIDTH=16;

    bit                    CLK;
    logic                  ASYNC_RST;
    logic                  SYNC_RST;
    logic                  EN;
    logic                  wren;
    logic [ADDR_WIDTH-1:0] wraddr;
    logic [7:0]            wrdata;
    logic [ADDR_WIDTH-1:0] rdaddr;
    logic [7:0]            rddata;

    DRAM #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (.*);

    always #5 CLK = ~CLK;

    initial begin
        ASYNC_RST = 1'b0;
        SYNC_RST  = 1'b0;
        EN        = 1'b0;
        wren      = 1'b0;
        wraddr    = 0;
        wrdata    = 0;
        rdaddr    = 0;
        #2;
        ASYNC_RST = 1'b1;
        EN        = 1'b1;
        @(negedge CLK);
        wren      = 1'b1;
        wraddr    = 3'b000;
        wrdata    = 8'd1;
        @(negedge CLK);
        wraddr    = 3'b001;
        wrdata    = 8'd2;
        @(negedge CLK);
        wraddr    = 3'b010;
        wrdata    = 8'd3;
        @(negedge CLK);
        wraddr    = 3'b011;
        wrdata    = 8'd4;
        @(negedge CLK);
        wren      = 1'b0;
        rdaddr    = 3'b000;
        @(negedge CLK);
        rdaddr    = 3'b001;
        @(negedge CLK);
        rdaddr    = 3'b010;
        @(negedge CLK);
        rdaddr    = 3'b011;
        @(negedge CLK);
        $stop;
    end
endmodule
