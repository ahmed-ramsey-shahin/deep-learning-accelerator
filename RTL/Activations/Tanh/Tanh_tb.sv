module Tanh_tb ();
    parameter IN_WIDTH = 15;
    parameter OUT_WIDTH = 13;
    reg signed [IN_WIDTH-1:0] in;
    reg en;
    wire signed [OUT_WIDTH-1:0] out;

    reg signed [IN_WIDTH-1:0] test_inputs [0:12] = '{
        0,
        97,
        2125,
        5194,
        7194,
        10000,
        13127,
        -97,
        -2125,
        -5194,
        -7194,
        -10000,
        -13127
    };
    
    reg [OUT_WIDTH-1:0] expected_outputs [0:12] = '{
        0,
        97,
        2085,
        3345,
        3714,
        3952,
        4095,
        -97,
        -2085,
        -3345,
        -3714,
        -3952,
        -4095
    };

    Tanh #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH)) dut (.in(in), .en(en), .out(out));

    integer i;
    initial begin
        en = 1;
        for (i = 0; i < 13; i = i + 1) begin
            in = test_inputs[i];
            #10; // Wait for propagation
            
            // Check output
            if (out !== expected_outputs[i]) begin
                $display("Error [Test %0d]: Input = %0d, Expected = %0d, Got = %0d", i, in, expected_outputs[i], out);
            end
        end

        en = 0;
        in = 35;
        #10;

        in = 198;
        #10;

        en = 1;
        #10;
    end
endmodule