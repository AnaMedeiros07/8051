`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 03:00:35 PM
// Design Name: 
// Module Name: sp
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

`include "define_opcodes.v"

module sp (
    input clock,
    input reset, 
    input wr, 
    input wr_bit,
    input [3:0] ram_sel,
    input [7:0] wr_addr,
    output reg [7:0] sp_out
);

reg pop;
wire write;
wire [7:0] sp_t;

reg [7:0] sp;


assign write = ((wr_addr==`SFR_SP) & (wr) & !(wr_bit)); // check if we need to write in the stack address


initial begin
    sp_out = `RST_SP; // #07h
end
always @(posedge clock or posedge reset)
begin
  if (reset)
    sp =  `RST_SP;
  else
    sp =  sp_out;
end
//write
always @(ram_sel or write)
begin
//
// push
  if (write)begin
    sp_out = sp;
  end
  else if (ram_sel==`WR_RAM_STACK) begin
    sp_out = sp + 8'h01;
  end
  else if (ram_sel==`RD_RAM_STACK && sp > `RST_SP)begin 
    sp_out = sp - 8'h01;
  end

end

endmodule