`timescale 1ns/1ps

module Matrix_Multiply_Unit_tb ();
    localparam         WIDTH  = 8;
    localparam         LENGTH = 3;
    reg                CLK;
    reg                ASYNC_RST;
    reg                SYNC_RST;
    reg                EN;
    reg  [WIDTH-1:0]   Inputs  [0:LENGTH-1];
    reg  [WIDTH-1:0]   Weights [0:LENGTH-1];
    wire [2*WIDTH-1:0] Result  [0:LENGTH-1][0:LENGTH-1];
    int row;
    int col;
    int counter = 0;
    int MatrixA[LENGTH][LENGTH] = '{
        '{4, 3, 7},
        '{4, 4, 7},
        '{6, 8, 2}
    };

    int MatrixB[LENGTH][LENGTH] = '{
        '{9, 4, 5},
        '{10, 4, 5},
        '{7, 4, 7}
    };

    always begin
        CLK = 1'b1;
        #5;
        CLK = 1'b0;
        #5;
    end

    Matrix_Multiply_Unit #(.WIDTH(WIDTH), .LENGTH(LENGTH)) DUT (
        .CLK(CLK),
        .ASYNC_RST(ASYNC_RST),
        .SYNC_RST(SYNC_RST),
        .EN(EN),
        .Inputs(Inputs),
        .Weights(Weights),
        .Result(Result)
    );

    initial begin
        ASYNC_RST = 1'b0;
        EN        = 1'b0;
        SYNC_RST  = 1'b0;
        row       = 0;
        col       = 0;
        for (row = 0; row < LENGTH; row = row + 1) begin
            Inputs[row]  = 0;
            Weights[row] = 0;
        end
        #2;
        ASYNC_RST = 1'b1;

        @(negedge CLK);
        EN = 1'b1;
        $display(MatrixA);
        for (col = 1; col < 2 * LENGTH; col = col + 1) begin
            for (row = 0; row < LENGTH; row = row + 1) begin
                if (col < LENGTH) begin
                    if (row < col) begin
                        Inputs[row]  = MatrixA[row][col-row-1];
                        Weights[row] = MatrixB[col-row-1][row];
                    end
                    else begin
                        Inputs[row]  = {WIDTH{1'b0}};
                        Weights[row] = {WIDTH{1'b0}};
                    end
                end
                else if (col == LENGTH) begin
                    Inputs[row]  = MatrixA[row][col-row-1];
                    Weights[row] = MatrixB[col-row-1][row];
                end
                else if (col > LENGTH) begin
                    if (row < col - LENGTH) begin
                        Inputs[row]  = {WIDTH{1'b0}};
                        Weights[row] = {WIDTH{1'b0}};
                    end
                    else begin
                        Inputs[row]  = MatrixA[row][col-row-1];
                        Weights[row] = MatrixB[col-row-1][row];
                    end
                end
            end
            @(negedge CLK);
        end
        for (row = 0; row < LENGTH; row = row + 1) begin
            Inputs[row]  = 0;
            Weights[row] = 0;
        end
    end

    initial begin
        repeat(3*LENGTH-2) @(negedge CLK) counter = counter + 1;
        repeat(2) @(negedge CLK);
        $stop;
    end
endmodule
