`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2022 09:04:25 AM
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "define_opcodes.v"

module alu_core(
    input clock,
    input reset,
    
    input [4:0] alu_opcode,
    
    input [7:0] op_in_1, // first operand
    input [7:0] op_in_2, // second operand
    
    input carry_in,     
    input aux_carry_in, 
    input bit_in,          
    
    output reg overflow_out,
    output reg aux_carry_out,
    output reg carry_out,
 
    output reg [7:0] op_out_1,
    output reg [7:0] op_out_2   
    );
    
initial begin
    overflow_out = 1'b0;
    aux_carry_out = 1'b0;
    carry_out = 1'b0;
    
    op_out_1=8'h00;
    op_out_2=8'h00;

end 

always @(alu_opcode or op_in_1 or op_in_2)
begin 
    if(reset) begin
        overflow_out = 1'b0;
        aux_carry_out = 1'b0;
        carry_out = 1'b0;
        op_out_1=8'h00;
        op_out_2=8'h00;
    end
    else if (alu_opcode ==`ALU_INC) begin
    
        {op_out_2,op_out_1} = {op_in_2,op_in_1} + 1;
        
    end
   else if(alu_opcode == `ALU_DEC) begin
        
            op_out_1 = op_in_1 - 8'h01;
        
   end
   else if (alu_opcode ==  `ALU_ADD) begin
        
        {aux_carry_out,op_out_1[3:0]} = op_in_1[3:0] + op_in_2[3:0];
        {carry_out,op_out_1[7:4]}= op_in_1[7:4] + op_in_2[7:4] + aux_carry_out;
        overflow_out = op_out_1[7]^op_out_1[6];
        
   end  
   else if (alu_opcode == `ALU_ADDC) begin    
   
        {aux_carry_out,op_out_1[3:0]} = op_in_1[3:0] + op_in_2[3:0] + carry_in;
        {carry_out,op_out_1[7:4]}= op_in_1[7:4] + op_in_2[7:4] + aux_carry_out;
        overflow_out = op_out_1[7]^op_out_1[6];
        
   end 
   else if (alu_opcode ==`ALU_SUBB) begin
   
        {aux_carry_out, op_out_1[3:0]} = op_in_1[3:0] - op_in_2[3:0];
        {carry_out, op_out_1[7:4]}= op_in_1[7:4] - op_in_2[7:4] - aux_carry_out;
        overflow_out = op_out_1[7]^op_out_1[6];         
        
   end
    else if(alu_opcode == `ALU_ORL) begin
            
            op_out_1 = op_in_1 | op_in_2;
            carry_out = carry_in | bit_in;
            
    end
    else if(alu_opcode == `ALU_XRL) begin
            
            op_out_1 = op_in_1^op_in_2;
        
    end
    else if( alu_opcode == `ALU_ANL) begin
            
            op_out_1 = op_in_1 & op_in_2;
            carry_out = carry_in | bit_in;
            
    end
    else begin
        op_out_1 = 8'h00;
        op_out_2 = 8'h00;
    end
end


 
endmodule