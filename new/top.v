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
    output [6:0] port2_data,
    input reset
    );

wire [7:0] Opcode ;
wire IRload,PCload,JMPload,RAMload,Aload,NotRload,Decodeload;
wire [4:0] ALU_Opcode;
wire [3:0] RAM_access;

control_unit ctrlunit(
	  .clock(clock),
      .reset(reset),
      .Aload(Aload),
      .IRload(IRload),
      .PCload(PCload),
      .NotRload(NotRload),
      .Decodeload(Decodeload),
      .RAMload(RAMload),
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
     .RAMload(RAMload),
     .Decodeload(Decodeload),
     .PCload(PCload),
     .JMPload(JMPload),
     .port2_data(port2_data),
     .Opcode(Opcode),
     .RAM_access(RAM_access),
     .ALU_Opcode(ALU_Opcode)
     
);

endmodule

