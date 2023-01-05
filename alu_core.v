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
    
    input [3:0] alu_opcode,
    
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



always @(alu_opcode or posedge reset)
begin

if(reset) begin
    overflow_out = 0;
    aux_carry_out = 0;
    carry_out = 0;
    
    op_out_1=8'h00;
    op_out_2=8'h00;
end
else begin       
    case (alu_opcode)
        
        `ALU_INC: begin
        
            {op_out_2,op_out_1} = {op_in_2,op_in_1} + 1;
            
        end
        
        `ALU_DEC: begin
        
            op_out_1 = op_in_1 - 1;
        
        end
        
        `ALU_ADD: begin
            
            {aux_carry_out,op_out_1[3:0]} = op_in_1[3:0] + op_in_2[3:0];
            {carry_out,op_out_1[7:4]}= op_in_1[7:4] + op_in_2[7:4] + aux_carry_out;
            overflow_out = op_out_1[7]^op_out_1[6];
        end
        
        `ALU_ADDC: begin
            
            {aux_carry_out,op_out_1[3:0]} = op_in_1[3:0] + op_in_2[3:0] + carry_in;
            {carry_out,op_out_1[7:4]}= op_in_1[7:4] + op_in_2[7:4] + aux_carry_out;
            overflow_out = op_out_1[7]^op_out_1[6];
        end
        
        `ALU_SUBB: begin
            {aux_carry_out, op_out_1[3:0]} = op_in_1[3:0] - op_in_2[3:0];
            {carry_out, op_out_1[7:4]}= op_in_1[7:4] - op_in_2[7:4] - aux_carry_out;
            overflow_out = op_out_1[7]^op_out_1[6];         
            
        end
        
        `ALU_MUL: begin
            {op_out_2,op_out_1} = op_in_1 * op_in_2;
            carry_out = 0;
            overflow_out = (op_in_2 != 0) ? 1'b1 : 1'b0;
        end
        
        `ALU_DIV: begin
            op_out_1 = op_in_1 / op_in_2;
            op_out_2 = op_in_1 % op_in_2;
            carry_out = 0;
            overflow_out = (op_in_2 == 0) ? 1'b1 : 1'b0;
        
        end
        
        `ALU_RR: begin
            op_out_1 = {op_in_1[0],op_in_1[7:1]};
        
        end
        
        `ALU_RRC: begin
            carry_out = op_in_1[0];
            op_out_1 = {carry_in,op_in_1[7:1]}; 
        
        end
        
        `ALU_RL: begin
            op_out_1 = {op_in_1[6:0],op_in_1[7]};
        
        end
        
        `ALU_RLC: begin
            carry_out = op_in_1[7];
            op_out_1 = {op_in_1[6:0],carry_in}; 
        
        end
        
        `ALU_CPL: begin
            op_out_1=~op_in_1;
        
        end
        
        `ALU_DA: begin
           
            //op_1 = (aux_carry==1 || op_1[3:0]>9) op_1 + 8'h06 : op_1;
            if(aux_carry_in==1 || op_in_1[3:0]>4'd9) op_out_1 = op_in_1 + 8'h06;
            
            //op_1 = ((carry==1) || (op_1[7:4]>4'd9 )) op_1 + 8'h60 : op_1;
            if(carry_in==1 || op_in_1[7:4]>4'd9) op_out_1 = op_in_1 + 8'h60;
            
        end
        
        `ALU_SWAP: begin
        
            op_out_1 = {op_in_1[3:0],op_in_1[7:4]};
            
        end
        
        `ALU_ORL: begin
            
            op_out_1 = op_in_1 | op_in_2;
            carry_out = carry_in | bit_in;
            
        end
        
        `ALU_XRL: begin
            
            op_out_1 = op_in_1 | op_in_2;
        
        end
        
        `ALU_ANL: begin
            
            op_out_1 = op_in_1 | op_in_2;
            carry_out = carry_in | bit_in;
            
        end
        
    endcase
end
end

 
endmodule