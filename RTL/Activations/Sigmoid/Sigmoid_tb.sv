module Sigmoid_tb ();
    parameter IN_WIDTH = 15;
    parameter OUT_WIDTH = 11;
    reg signed [IN_WIDTH-1:0] in;
    reg en;
    wire signed [OUT_WIDTH-1:0] out;

    reg signed [IN_WIDTH-1:0] test_inputs [0:10] = '{
        0,
        5,
        300,
        1600,
        2433,
        8000,
        -5,
        -300,
        -1600,
        -2433,
        -8000
    };
    
    reg [OUT_WIDTH-1:0] expected_outputs [0:10] = '{
        511,        // 0
        512,        // 5
        586,        // 300
        839,        // 1600
        939,        // 2433
        1023,       // 8000
        511,        // -5
        437,        // -300
        184,        // -1600
        84,         // -2433
        0           // -8000
    };

    Sigmoid #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH)) dut (.in(in), .en(en), .out(out));

    integer i;
    initial begin
        en = 1;
        for (i = 0; i < 11; i = i + 1) begin
            in = test_inputs[i];
            #10; // Wait for propagation
            
            // Check output
            if (out !== expected_outputs[i]) begin
                $display("Error [Test %0d]: Input = %0d, Expected = %0d, Got = %0d", i, in, expected_outputs[i], out);
            end
        end

        en = 0;
        in = 5;
        #10;

        in = 15;
        #10;

        en = 1;
        in = 0;
        #10;
    end
endmodule