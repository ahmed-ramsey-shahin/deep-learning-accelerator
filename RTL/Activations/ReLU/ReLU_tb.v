module ReLU_tb ();    
    reg signed [23:0] in;
    wire signed [7:0]out;

    ReLU dut(in, out);

    initial begin
        in = 5;
        #10;
        
        in = 200;
        #10;
        
        in = 65535;
        #10;
        
        in = 65536;
        #10;

        in = 6553600;
        #10;
        
        in = 8388607;
        #10;
        
        in = -5;
        #10;

        in = -8388608;
        #10;
    end

endmodule