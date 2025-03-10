`timescale 1ns/1ps

module Systolic_Data_Setup_tb();
    localparam       WIDTH=8;
    localparam       LENGTH=5;
    reg              CLK;
    reg              ASYNC_RST;
    reg              SYNC_RST;
    reg              EN;
    reg  [WIDTH-1:0] Inputs  [0:LENGTH-1];
    wire [WIDTH-1:0] Outputs [0:LENGTH-1];
    int i;
    int j;

    Systolic_Data_Setup #(
        .WIDTH(WIDTH),
        .LENGTH(LENGTH)
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
        for (i = 0; i < LENGTH; i = i + 1) begin
            Inputs[i] = {WIDTH{1'b0}};
        end
        #2;
        ASYNC_RST = 1'b1;
        EN        = 1'b1;
    end
    endtask

    task static load_input;
    begin
        @(posedge CLK);
        for (j = 0; j < LENGTH; j = j + 1) begin
            for (i = 0; i < LENGTH; i = i + 1) begin
                Inputs[i] = $urandom_range(0, 10);
            end
            @(posedge CLK);
        end
    end
    endtask

    initial begin
        reset();
        load_input();
        repeat(LENGTH) @(posedge CLK);
        $stop;
    end
endmodule

