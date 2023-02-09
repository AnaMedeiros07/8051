`timescale 1ns / 1ps

module tb_top;

	// Inputs
	reg clock;
	reg reset;

	// Outputs
    wire [6:0] port2_data;
	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clock(clock), 
		.port2_data(port2_data),
		.reset(reset)
		);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 1;
		// Wait 100 ns for global reset to finish
		#30;
		reset = 0;
		
		
        
		// Add stimulus here
        //#7570 $finish;
	end

always #5 clock = ~clock;

endmodule
