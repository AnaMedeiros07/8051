`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2022 12:29:49 AM
// Design Name: 
// Module Name: tb_top_v1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_alu_v1;
    // Inputs
	reg clock;
	reg reset;
    reg [3:0] alu_code;
    reg [7:0] src_1, src_2;
    reg cy, aux_cy;
    
    //Outputs
    wire [7:0] des_1, des_2;
    wire cy_out, ac_out, ov_out;
        
    alu_core alu_core_module(
        .clock(clock),
        .reset(reset),
        .alu_opcode(alu_code),
        .op_in_1(src_1), // first operand
        .op_in_2(src_2), // second operand
        .carry_in(cy),
        .aux_carry_in(aux_cy),
        .overflow_out(ov_out),
        .aux_carry_out(ac_out),
        .carry_out(cy_out),
        .op_out_1(des_1),
        .op_out_2(des_2) 
        );    
        
	initial begin
		// Initialize Inputs
		clock =1'b0;
		reset = 1'b1;
		cy = 1'b0;
		aux_cy = 1'b0;
	    alu_code = 4'b0001;
	    src_1 = 8'h20;
	    src_2 = 8'h40;
		// Wait 20 ns for global reset to finish
		#10;
		reset = 1'b0;
		#20
		alu_code = 4'b0010;
		#20;
		alu_code = 4'b0100;
		#20;
		alu_code = 4'b0101;
		#20;
		alu_code = 4'b0111;
		#20;

	end
always #5 clock = ~clock;
endmodule