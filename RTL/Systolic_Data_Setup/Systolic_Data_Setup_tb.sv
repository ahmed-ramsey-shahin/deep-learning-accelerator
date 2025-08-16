`timescale 1ns/1ps

module Systolic_Data_Setup_tb();
    localparam       DATA_WIDTH=8;
    localparam       SA_LENGTH=5;
    reg              CLK;
    reg              ASYNC_RST;
    reg              SYNC_RST;
    reg              EN;
    reg  [DATA_WIDTH-1:0] Inputs  [0:SA_LENGTH-1];
    wire [DATA_WIDTH-1:0] Outputs [0:SA_LENGTH-1];
    int i;
    int j;

    Systolic_Data_Setup #(
        .DATA_WIDTH(WIDTH),
        .SA_LENGTH(SA_LENGTH)
    ) DUT (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(EN),
        .Inputs(Inputs),
        .Outputs(Outputs)
    );

    always begin
        CLK = 1'b0;
        #5;
        CLK = 1'b1;
        #5;
    end

    task static reset;
    begin
        ASYNC_RST = 1'b0;
        SYNC_RST  = 1'b0;
        EN        = 1'b0;
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            Inputs[i] = {DATA_WIDTH{1'b0}};
        end
        #2;
        ASYNC_RST = 1'b1;
        EN        = 1'b1;
    end
    endtask

    task static load_input;
    begin
        @(posedge CLK);
        for (j = 0; j < SA_LENGTH; j = j + 1) begin
            for (i = 0; i < SA_LENGTH; i = i + 1) begin
                Inputs[i] = $urandom_range(0, 10);
            end
            @(posedge CLK);
        end
    end
    endtask

    initial begin
        reset();
        load_input();
        repeat(SA_LENGTH) @(posedge CLK);
        $stop;
    end
endmodule

