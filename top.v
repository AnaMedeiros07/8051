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
wire Fetch,Decode,Execute;
wire ready;

control_unit ctrlunit(
	  .clock(clock),
      .reset(reset),
      .ready(ready),
      .Opcode(Opcode),
      .Fetch(Fetch),
      .Execute(Execute),
      .Decode(Decode)
);

datapath data_path(
	 .clock(clock),
     .reset(reset),
     .ready(ready),
     .Fetch(Fetch),
     .Execute(Execute),
     .Decode(Decode),
     .Opcode(Opcode)
);

endmodule

