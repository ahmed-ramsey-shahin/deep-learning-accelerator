`timescale 1ns/1ps

module Matrix_Multiply_Unit_tb();
    parameter                    WIDTH=8;
    parameter                    ACCUMULATOR_WIDTH=32;
    parameter                    LENGTH=10;
    reg                          CLK;
    reg                          ASYNC_RST;
    reg                          SYNC_RST;
    reg                          EN;
    reg                          LOAD;
    reg  [WIDTH-1:0]             Inputs  [0:LENGTH-1];
    reg  [WIDTH-1:0]             Weights [0:LENGTH-1];
    wire [ACCUMULATOR_WIDTH-1:0] Result  [0:LENGTH-1];

    reg  [WIDTH-1:0]             MatrixA      [0:LENGTH-1][0:LENGTH-1];
    reg  [WIDTH-1:0]             MatrixW      [0:LENGTH-1][0:LENGTH-1];
    reg  [ACCUMULATOR_WIDTH-1:0] ActualResult [0:LENGTH-1][0:LENGTH-1];
    reg  [ACCUMULATOR_WIDTH-1:0] ExpectedResult [0:LENGTH-1][0:LENGTH-1];

    always begin
        CLK = 1'b0;
        #5;
        CLK = 1'b1;
        #5;
    end

    Matrix_Multiply_Unit #(
        .WIDTH(WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .LENGTH(LENGTH)
    ) DUT (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(EN),
        .LOAD(LOAD),
        .Inputs(Inputs),
        .Weights(Weights),
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
        for (i = 0; i < LENGTH; i = i + 1) begin
            Inputs[i]  = {WIDTH{1'b0}};
            Weights[i]  = {WIDTH{1'b0}};
        end
        for (i = 0; i < LENGTH; i = i + 1) begin
            for (j = 0; j < LENGTH; j = j + 1) begin
                ActualResult[i][j] = {ACCUMULATOR_WIDTH{1'b0}};
                ExpectedResult[i][j] = {ACCUMULATOR_WIDTH{1'b0}};
            end
        end
        #2;
        ASYNC_RST = 1'b1;
    end
    endtask

    task static print_small_matrix;
        input [WIDTH-1:0] Matrix [0:LENGTH-1][0:LENGTH-1];
        int i, j;
    begin
        for (i = 0; i < LENGTH; i = i + 1) begin
            for (j = 0; j < LENGTH; j = j + 1) begin
                $write("%d ", Matrix[i][j]);
            end
            $display("");
        end
    end
    endtask

    task static print_large_matrix;
        input [ACCUMULATOR_WIDTH-1:0] Matrix [0:LENGTH-1][0:LENGTH-1];
        int i, j;
    begin
        for (i = 0; i < LENGTH; i = i + 1) begin
            for (j = 0; j < LENGTH; j = j + 1) begin
                $write("%d ", Matrix[i][j]);
            end
            $display("");
        end
    end
    endtask

    // Generate random matrix
    task static generate_random_matrix;
        int i, j;
        output [WIDTH-1:0] Matrix [0:LENGTH-1][0:LENGTH-1];
    begin
        for (i = 0; i < LENGTH; i = i + 1) begin
            for (j = 0; j < LENGTH; j = j + 1) begin
                Matrix[i][j]  = $urandom_range(0, 10);
            end
        end
    end
    endtask

    task static load_weights;
        input [WIDTH-1:0] Matrix [0:LENGTH-1][0:LENGTH-1];
        int i, j;
    begin
        EN   = 1'b1;
        LOAD = 1'b1;
        @(negedge CLK);
        for (i = LENGTH-1; i >= 0; i = i - 1) begin
            for (j = 0; j < LENGTH; j = j + 1) begin
                Weights[j] = Matrix[j][i];
            end
            @(negedge CLK);
        end
        LOAD = 1'b0;
    end
    endtask

    task static load_inputs;
        input [WIDTH-1:0] Matrix [0:LENGTH-1][0:LENGTH-1];
        int row;
        int col;
        begin
            EN = 1'b1;
            @(negedge CLK);
            for (col = 1; col < 2 * LENGTH; col = col + 1) begin
                for (row = 0; row < LENGTH; row = row + 1) begin
                    if (col < LENGTH) begin
                        if (row < col) begin
                            Inputs[row] = Matrix[row][col - row - 1];
                        end
                        else begin
                            Inputs[row] = {WIDTH{1'b0}};
                        end
                    end
                    else if (col == LENGTH) begin
                        Inputs[row]  = Matrix[row][col-row-1];
                    end
                    else if (col > LENGTH) begin
                        if (row < col - LENGTH) begin
                            Inputs[row] = {WIDTH{1'b0}};
                        end
                        else begin
                            Inputs[row] = Matrix[row][col - row - 1];
                        end
                    end
                end
                @(negedge CLK);
            end
            for (row = 0; row < LENGTH; row = row + 1) begin
                Inputs[row] = {WIDTH{1'b0}};
            end
        end
    endtask

    task static collect_outputs;
        int x, y;
        output [ACCUMULATOR_WIDTH-1:0] ActualOutput [0:LENGTH-1][0:LENGTH-1];
    begin
        @(negedge CLK);
        for (x = 0; x < 2 * LENGTH - 1; x = x + 1) begin
            for (y = 0; y < LENGTH; y = y + 1) begin
                if (x >= y && x < y + LENGTH) begin
                    ActualOutput[y][x-y] = Result[y];
                end
            end
            @(negedge CLK);
        end
    end
    endtask

    task static calculate_expected_result;
        input  [WIDTH-1:0] Matrix1 [0:LENGTH-1][0:LENGTH-1];
        input  [WIDTH-1:0] Matrix2 [0:LENGTH-1][0:LENGTH-1];
        output [ACCUMULATOR_WIDTH-1:0] Result [0:LENGTH-1][0:LENGTH-1];
        int i, j, k;
    begin
        for (i = 0; i < LENGTH; i = i + 1) begin
            for (j = 0; j < LENGTH; j = j + 1) begin
                Result[i][j] = {ACCUMULATOR_WIDTH{1'b0}};
            end
        end
        for (i = 0; i < LENGTH; i = i + 1) begin
            for (j = 0; j < LENGTH; j = j + 1) begin
                for (k = 0; k < LENGTH; k = k + 1) begin
                    Result[i][j] = Result[i][j] + (Matrix1[i][k] * Matrix2[k][j]);
                end
            end
        end
    end
    endtask

    task static validate_results;
        input [ACCUMULATOR_WIDTH-1:0] Expected [0:LENGTH-1][0:LENGTH-1];
        input [ACCUMULATOR_WIDTH-1:0] Actual [0:LENGTH-1][0:LENGTH-1];
        input int test_case_number;
        reg test_case_passed;
        int i, j;
    begin
        test_case_passed = 1'b1;
        for (i = 0; i < LENGTH; i = i + 1) begin
            for (j = 0; j < LENGTH; j = j + 1) begin
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
        repeat(2 * LENGTH + 1) @(negedge CLK);
        collect_outputs(ActualResult);
        validate_results(ExpectedResult, ActualResult, 1);
        @(negedge CLK) $stop;
    end
endmodule

