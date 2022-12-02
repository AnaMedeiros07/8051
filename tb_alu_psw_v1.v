`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 02:21:03 PM
// Design Name: 
// Module Name: tb_alu_psw_v1
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


module tb_alu_psw_v1;
    
    //Inputs
    reg clock, reset;
    
    //Alu inputs
    reg [3:0] alu_code;
    reg [7:0] src_1, src_2;
    
    //Psw Inputs
    reg [7:1] data_in;
    reg [7:0] acc;
    reg write_en, write_bit_en;
    reg [2:0] bit_addr;
    reg [1:0] flag_set;
    
    //Outputs
    
    wire [7:0] des_1, des_2;
    wire cy_new, ac_new, ov_new;
    wire [7:0] psw_data;
    
    assign cy = psw_data[7];
    assign aux_cy = psw_data[6];
    
    alu_core alu_core_module(
        .clock(clock),
        .reset(reset),
        .alu_opcode(alu_code),
        .op_in_1(src_1), // first operand
        .op_in_2(src_2), // second operand
        .carry_in(cy),
        .aux_carry_in(aux_cy),
        .overflow_out(ov_new),
        .aux_carry_out(ac_new),
        .carry_out(cy_new),
        .op_out_1(des_1),
        .op_out_2(des_2) 
        );
            
    psw psw_module(
        .clock(clock),
        .reset(reset),
        .carry_in(cy_new),
        .aux_carry_in(ac_new),
        .overflow_in(ov_new), 
        .data_in(data_in),
        .acc_in(acc),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_addr(bit_addr),
        .flag_set(flag_set),
        .psw_data(psw_data) 
        );
   
    initial begin
		// Initialize Inputs
		clock =1'b0;
		reset = 1'b1;
	    // Initialize Alu inputs
	    alu_code = 4'b0000;
	    src_1 = 8'h00;
	    src_2 = 8'h00;
	    // Initialize Psw Inputs
	    data_in = 7'b0000000;
	    acc = 8'h00;
	    write_en = 1'b0;
	    write_bit_en = 1'b0;
	    bit_addr = 3'b000;
	    flag_set = 2'b00;
		#5;
		reset = 1'b0;
		#10;
		// ADD A, #40
		/*
		alu_code = `ALU_ADD;
        src_1 = 8'h60;
        src_2 = 8'h40;
        flag_set = `CY_OV_AC_SET;
        acc = des_1;
        #20
        */
        // ADD A 
        /*
        src_1 = 8'h80;
        src_2 = 8'h88;
        alu_code = `ALU_ADD;
        flag_set = `CY_OV_AC_SET;
        assign acc = des_1;
        #20;
        */
        //RRC A
        
        src_1 = 8'h88;
        alu_code = `ALU_RRC;
        flag_set = `CY_SET;
        assign acc = des_1;
        //alu_code <= #10 `ALU_NOP;
        //#10;
        
	end      
always #5 clock = ~clock;
endmodule
