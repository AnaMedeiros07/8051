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

`define ALU_INC     3'b000
`define ALU_DEC     3'b001
`define ALU_ADD     3'b010
`define ALU_ADDC    3'b011
`define ALU_SUBB    3'b100
`define ALU_ORL     3'b101
`define ALU_XRL     3'b110
`define ALU_ANL     3'b111

module alu_core(
    input clock,
    input reset,
    
    input [2:0] alu_opcode,
    
    input [7:0] op_in_1, // first operand
    input [7:0] op_in_2, // second operand
    
    input carry_in,        
    
    output reg overflow_out,
    output reg aux_carry_out,
    output reg carry_out,
    
    output reg [7:0] op_out_1
    );
    
initial begin
    overflow_out = 1'b0;
    aux_carry_out = 1'b0;
    carry_out = 1'b0;
    
    op_out_1=8'h00;

end 

always @(posedge reset)
begin
    overflow_out = 0;
    aux_carry_out = 0;
    carry_out = 0;
    
    op_out_1=8'h00;
end

always @(alu_opcode) //to only execute the alu operations once
begin     
    case (alu_opcode)
        
        `ALU_INC: begin
        
            op_out_1 = op_in_1+1;
            
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
              
        `ALU_ORL: begin
            
            op_out_1 = op_in_1 | op_in_2;
            
        end
        
        `ALU_XRL: begin
            
            op_out_1 = op_in_1 ^ op_in_2;
        
        end
        
        `ALU_ANL: begin
            
            op_out_1 = op_in_1 & op_in_2;
            
        end
    endcase
end
 
endmodule

