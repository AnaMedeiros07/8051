`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2022 11:00:52 AM
// Design Name: 
// Module Name: tb_top
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


module top(
    input clock,
    input reset
    );

wire [7:0] Opcode ;
wire IRload,PCload,JMPload,Aload,NotRload;
wire [4:0] ALU_Opcode;
wire [4:0] RAM_access;

control_unit ctrlunit(
	  .clock(clock),
      .reset(reset),
      .Aload(Aload),
      .IRload(IRload),
      .PCload(PCload),
      .NotRload(NotRload),
      .JMPload(JMPload),
      .Opcode(Opcode),
      .RAM_access(RAM_access),
      .ALU_Opcode(ALU_Opcode)
);

datapath data_path(
	 .clock(clock),
     .reset(reset),
     .Aload(Aload),
     .IRload(IRload),
     .NotRload(NotRload),
     .PCload(PCload),
     .JMPload(JMPload),
     .Opcode(Opcode),
     .RAM_access(RAM_access),
     .ALU_Opcode(ALU_Opcode)
     
);

endmodule

