`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2023 09:45:05 PM
// Design Name: 
// Module Name: timer
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

module timer(
   
    input clock,
    input reset,
    
    input [7:0]  wr_addr,
    input [7:0]  data_in,
    input wr,
    input wr_bit,         
    input [7:0] tcon,
	    
    output reg [7:0] tmod,
    output reg [7:0] tl0,
	output reg [7:0] th0,
    output reg tf0
 
    );

wire tc0_add;

assign tc0_add = (tcon[4] & (!tcon[1])); // tr & ! ie

//
// TIMER COUNTER 0
//
always @(posedge clock)
begin
 if (reset) begin
   tf0 = 1'b0;
   th0= 8'h00;
   tl0 = 8'h00;
   tmod = 8'h00;
 end
 else if ((wr) & !(wr_bit) & (wr_addr==`SFR_TMOD))begin
    tmod =data_in; // configure timer
 end
 else if ((wr) & !(wr_bit) & (wr_addr==`SFR_TL0)) begin
   tl0 =  data_in;
   tf0 = 1'b0;
 end else if ((wr) & !(wr_bit) & (wr_addr==`SFR_TH0)) begin
   th0 =  data_in;
   tf0 =  1'b0;
 end else begin
     case (tmod[1:0]) 
        2'b00: begin                       // mode 0
        if (tc0_add)
          {tf0, th0,tl0[4:0]} = {1'b0, th0, tl0[4:0]}+ 1'b1;
      end
        2'b01: begin                       // mode 1

        if (tc0_add)
          {tf0, th0,tl0} = {1'b0, th0, tl0}+ 1'b1;
      end
      2'b10: begin                       // mode 2 - 8 bits counter
        if (tc0_add) begin
	    if (tl0 == 8'b11111111) begin
            tf0 = 1'b1;
            tl0 =th0;
           end
          else begin    
            tl0 =tl0 + 8'h1;
            tf0 = 1'b0;
          end
	end
      end
       2'b11: begin                       // mode 3
        if (tc0_add)
           {tf0, tl0} =  {1'b0, tl0} +1'b1;
       end
       default:begin
        tf0 = 1'b0;
       end
    endcase
 end
end


endmodule
