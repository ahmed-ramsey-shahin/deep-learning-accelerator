`timescale 1ns/1ps

module Accumulators_tb();
    localparam                       VECTOR_WIDTH=3;
    localparam                       NO_VECTORS=10;
    localparam                       DATA_WIDTH=32;
    localparam                       VECTOR_SELECTOR_WIDTH=6;
    reg                              CLK;
    reg                              ASYNC_RST;
    reg                              SYNC_RST;
    reg                              EN;
    reg  [DATA_WIDTH-1:0]            Inputs  [0:VECTOR_WIDTH-1];
    reg  [VECTOR_SELECTOR_WIDTH-1:0] InputVectorSelector;
    reg  [VECTOR_SELECTOR_WIDTH-1:0] OutputVectorSelector;
    wire [DATA_WIDTH-1:0]            Result  [0:VECTOR_WIDTH-1];
    int i;

    always begin
        CLK = 1'b0;
        #5;
        CLK = 1'b1;
        #5;
    end

    Accumulators #(
        .VECTOR_WIDTH(VECTOR_WIDTH),
        .NO_VECTORS(NO_VECTORS),
        .DATA_WIDTH(DATA_WIDTH),
        .VECTOR_SELECTOR_WIDTH(VECTOR_SELECTOR_WIDTH)
    ) DUT (
        .CLK(CLK),
        .SYNC_RST(SYNC_RST),
        .ASYNC_RST(ASYNC_RST),
        .EN(EN),
        .Inputs(Inputs),
        .InputVectorSelector(InputVectorSelector),
        .OutputVectorSelector(OutputVectorSelector),
        .Result(Result)
    );

    task static reset;
        int i;
    begin
        ASYNC_RST            = 1'b0;
        SYNC_RST             = 1'b0;
        EN                   = 1'b0;
        InputVectorSelector  = {VECTOR_SELECTOR_WIDTH{1'b0}};
        OutputVectorSelector = {VECTOR_SELECTOR_WIDTH{1'b0}};
        for (i = 0; i < VECTOR_WIDTH; i = i + 1) begin
            Inputs[i] = {VECTOR_WIDTH{1'b0}};
        end
        #2;
        ASYNC_RST = 1'b1;
    end
    endtask

    task static generate_random_inputs;
        int i;
    begin
        for (i = 0; i < VECTOR_WIDTH;  i = i + 1) begin
            Inputs[i] = $urandom_range(0, 10);
        end
    end
    endtask

    task static generate_random_selector;
    begin
        InputVectorSelector = $urandom_range(0, NO_VECTORS-1);
        @(negedge CLK);
        OutputVectorSelector = InputVectorSelector;
    end
    endtask

    task static validate_output;
        input int test_case;
        int i;
        reg test_case_passed;
    begin
        test_case_passed = 1'b1;
        for (i = 0; i < VECTOR_WIDTH; i = i + 1) begin
            if (Inputs[i] != Result[i]) begin
                $display("%d %d", Inputs[i], Result[i]);
                test_case_passed = 1'b0;
            end
        end
        if (test_case_passed) begin
            $display("Test %d Case Passed", test_case);
        end
        else begin
            $display("Test %d Case Did not Passed", test_case);
        end
    end
    endtask

    initial begin
        reset();
        @(negedge CLK);
        EN = 1'b1;
        generate_random_inputs();
        generate_random_selector();
        @(negedge CLK);
        validate_output(1);
        generate_random_inputs();
        generate_random_selector();
        @(negedge CLK);
        validate_output(2);
        @(negedge CLK) $stop;
    end
endmodule

