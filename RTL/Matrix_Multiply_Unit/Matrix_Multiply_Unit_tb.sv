`timescale 1ns/1ps

module Matrix_Multiply_Unit_tb();
    localparam integer                       DATA_WIDTH=8;
    localparam integer                       ACCUMULATOR_DATA_WIDTH=32;
    localparam integer                       SA_LENGTH=3;
    reg                                      CLK;
    reg                                      ASYNC_RST;
    reg                                      SYNC_RST;
    reg                                      EN;
    reg                                      LOAD;
    reg  signed [DATA_WIDTH-1:0]             Inputs         [SA_LENGTH];
    wire signed [ACCUMULATOR_DATA_WIDTH-1:0] Result         [SA_LENGTH];

    reg  signed [DATA_WIDTH-1:0]             MatrixA        [SA_LENGTH][SA_LENGTH];
    reg  signed [DATA_WIDTH-1:0]             MatrixW        [SA_LENGTH][SA_LENGTH];
    reg  signed [ACCUMULATOR_DATA_WIDTH-1:0] ActualResult   [SA_LENGTH][SA_LENGTH];
    reg  signed [ACCUMULATOR_DATA_WIDTH-1:0] ExpectedResult [SA_LENGTH][SA_LENGTH];

    always begin
        CLK = 1'b0;
        #5;
        CLK = 1'b1;
        #5;
    end

    Matrix_Multiply_Unit #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACCUMULATOR_DATA_WIDTH(ACCUMULATOR_DATA_WIDTH),
        .SA_LENGTH(SA_LENGTH)
    ) DUT (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(EN),
        .LOAD(LOAD),
        .Inputs(Inputs),
        .Result(Result)
    );

    // Reset the DUT
    task static reset;
        int i, j;
    begin
        ASYNC_RST = 1'b0;
        SYNC_RST  = 1'b0;
        EN        = 1'b0;
        LOAD      = 1'b0;
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            Inputs[i]  = {DATA_WIDTH{1'b0}};
        end
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            for (j = 0; j < SA_LENGTH; j = j + 1) begin
                MatrixA[i][j]        = {DATA_WIDTH{1'b0}};
                MatrixW[i][j]        = {DATA_WIDTH{1'b0}};
                ActualResult[i][j]   = {ACCUMULATOR_DATA_WIDTH{1'b0}};
                ExpectedResult[i][j] = {ACCUMULATOR_DATA_WIDTH{1'b0}};
            end
        end
        #2;
        ASYNC_RST = 1'b1;
    end
    endtask

    task static print_small_matrix;
        input signed [DATA_WIDTH-1:0] Matrix [SA_LENGTH][SA_LENGTH];
        int i, j;
    begin
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            for (j = 0; j < SA_LENGTH; j = j + 1) begin
                $write("%d ", Matrix[i][j]);
            end
            $display("");
        end
    end
    endtask

    task static print_large_matrix;
        input signed [ACCUMULATOR_DATA_WIDTH-1:0] Matrix [SA_LENGTH][SA_LENGTH];
        int i, j;
    begin
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            for (j = 0; j < SA_LENGTH; j = j + 1) begin
                $write("%d ", Matrix[i][j]);
            end
            $display("");
        end
    end
    endtask

    // Generate random matrix
    task static generate_random_matrix;
        int i, j;
        output signed [DATA_WIDTH-1:0] Matrix [SA_LENGTH][SA_LENGTH];
    begin
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            for (j = 0; j < SA_LENGTH; j = j + 1) begin
                Matrix[i][j]  = $urandom_range(0, 10);
            end
        end
    end
    endtask

    task static load_weights;
        input signed [DATA_WIDTH-1:0] Matrix [SA_LENGTH][SA_LENGTH];
        int i, j;
    begin
        EN   = 1'b0;
        LOAD = 1'b1;
        @(negedge CLK);
        for (i = SA_LENGTH-1; i >= 0; i = i - 1) begin
            for (j = 0; j < SA_LENGTH; j = j + 1) begin
                Inputs[j] = Matrix[j][i];
            end
            @(negedge CLK);
        end
        LOAD = 1'b0;
    end
    endtask

    task static load_inputs;
        input signed [DATA_WIDTH-1:0] Matrix [SA_LENGTH][SA_LENGTH];
        int row;
        int col;
        begin
            EN = 1'b1;
            for (col = 1; col < 2 * SA_LENGTH; col = col + 1) begin
                for (row = 0; row < SA_LENGTH; row = row + 1) begin
                    if (col < SA_LENGTH) begin
                        if (row < col) begin
                            Inputs[row] = Matrix[row][col - row - 1];
                        end
                        else begin
                            Inputs[row] = {DATA_WIDTH{1'b0}};
                        end
                    end
                    else if (col == SA_LENGTH) begin
                        Inputs[row]  = Matrix[row][col-row-1];
                    end
                    else if (col > SA_LENGTH) begin
                        if (row < col - SA_LENGTH) begin
                            Inputs[row] = {DATA_WIDTH{1'b0}};
                        end
                        else begin
                            Inputs[row] = Matrix[row][col - row - 1];
                        end
                    end
                end
                @(negedge CLK);
            end
            for (row = 0; row < SA_LENGTH; row = row + 1) begin
                Inputs[row] = {DATA_WIDTH{1'b0}};
            end
        end
    endtask

    task static collect_outputs;
        int x, y;
        output signed [ACCUMULATOR_DATA_WIDTH-1:0] ActualOutput [SA_LENGTH][SA_LENGTH];
    begin
        for (x = 0; x < 2 * SA_LENGTH - 1; x = x + 1) begin
            for (y = 0; y < SA_LENGTH; y = y + 1) begin
                if (x >= y && x < y + SA_LENGTH) begin
                    ActualOutput[y][x-y] = Result[y];
                end
            end
            @(negedge CLK);
        end
    end
    endtask

    task static calculate_expected_result;
        input  signed [DATA_WIDTH-1:0] Matrix1 [SA_LENGTH][SA_LENGTH];
        input  signed [DATA_WIDTH-1:0] Matrix2 [SA_LENGTH][SA_LENGTH];
        output signed [ACCUMULATOR_DATA_WIDTH-1:0] Result [SA_LENGTH][SA_LENGTH];
        int i, j, k;
    begin
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            for (j = 0; j < SA_LENGTH; j = j + 1) begin
                Result[i][j] = {ACCUMULATOR_DATA_WIDTH{1'b0}};
            end
        end
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            for (j = 0; j < SA_LENGTH; j = j + 1) begin
                for (k = 0; k < SA_LENGTH; k = k + 1) begin
                    Result[i][j] = Result[i][j] + (Matrix1[k][i] * Matrix2[k][j]);
                end
            end
        end
    end
    endtask

    task static validate_results;
        input signed [ACCUMULATOR_DATA_WIDTH-1:0] Expected [SA_LENGTH][SA_LENGTH];
        input signed [ACCUMULATOR_DATA_WIDTH-1:0] Actual [SA_LENGTH][SA_LENGTH];
        input int test_case_number;
        reg test_case_passed;
        int i, j;
    begin
        test_case_passed = 1'b1;
        for (i = 0; i < SA_LENGTH; i = i + 1) begin
            for (j = 0; j < SA_LENGTH; j = j + 1) begin
                if (Expected[i][j] != Actual[i][j]) begin
                    test_case_passed = 1'b0;
                    $display(
                        "Error at test case %0d: Expected[%0d][%0d] = %0d, Actual[%0d][%0d] = %0d",
                        test_case_number,
                        i, j, Expected[i][j],
                        i, j, Actual[i][j]
                    );
                end
            end
        end

        if (test_case_passed) begin
            $display("Test case %0d passed!", test_case_number);
        end
        else begin
            $display("Test case %0d failed!", test_case_number);
        end
    end
    endtask

    initial begin
        reset();
        generate_random_matrix(MatrixA);
        generate_random_matrix(MatrixW);
        $display("Matrix W equals: ");
        print_small_matrix(MatrixW);
        $display("Matrix A equals: ");
        print_small_matrix(MatrixA);
        calculate_expected_result(MatrixW, MatrixA, ExpectedResult);
        $display("MatrixW*MatrixA equals: ");
        print_large_matrix(ExpectedResult);
        load_weights(MatrixW);
        load_inputs(MatrixA);
    end

    initial begin
        repeat(2 * SA_LENGTH + 1) @(negedge CLK);
        collect_outputs(ActualResult);
        validate_results(ExpectedResult, ActualResult, 1);
        @(negedge CLK);
        $stop;
    end
endmodule

