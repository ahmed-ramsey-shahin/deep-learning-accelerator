module wallace_tree_multiplier_8x8_tb();
	// Inputs and Outputs
    	reg [7:0] a, b;
    	wire [15:0] product;

    	// Expected result
    	reg [15:0] expected_product;

    	// Error count
    	integer errors;
    	integer i, j;

    	// Instantiate the 8-bit multiplier module
    	wallace_tree_multiplier_8x8 uut (
        	.A(a),
        	.B(b),
        	.P(product)
    	);

    	initial begin
        // Initialize variables
        errors = 0;
        a = 0;
        b = 0;

        // Brute-force test all combinations of 8-bit inputs
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                a = i;
                b = j;
                expected_product = a * b;

                // Wait for one time unit for the product to stabilize
                #1;

                // Check if the product matches the expected result
                if (product !== expected_product) begin
                    $display("Mismatch: a=%d, b=%d, Expected=%d, Got=%d", a, b, expected_product, product);
                    errors = errors + 1;
                end
            end
        end

        // Display the test result
        if (errors == 0) begin
            $display("All tests passed!");
        end else begin
            $display("Test failed with %d errors.", errors);
        end

        // End simulation
        $stop;
    end
endmodule