module Sigmoid_tb ();
    reg signed [23:0] in;
    wire signed [7:0] out;

    reg signed [23:0] test_inputs [0:9] = '{
        0,
        5,
        300,
        600,
        1500,
        -5,
        -300,
        -608,
        -1500,
        -8388608
    };
    
    reg [7:0] expected_outputs [0:9] = '{
        64,         // 0
        65,         // 5
        117,        // 300
        126,        // 600
        127,        // 1500
        62,         // -5
        10,         // -300
        0,          // -600
        0,          // -1500
        0           // -8388608
    };

    Sigmoid dut (in, out);

    integer i;
    initial begin
        for (i = 0; i < 10; i = i + 1) begin
            in = test_inputs[i];
            #10; // Wait for propagation
            
            // Check output
            if (out !== expected_outputs[i]) begin
                $display("Error [Test %0d]: Input = %0d, Expected = %0d, Got = %0d", i, in, expected_outputs[i], out);
            end
        end
    end
endmodule