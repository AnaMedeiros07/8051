`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2023 02:23:49 PM
// Design Name: 
// Module Name: dptr
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

module dptr(
    input clock,
    input reset,
    
    input wr,
    input wr_bit,
    input addr,
    
    input [7:0] data_in,
 
    output reg [7:0] data_h,
    output reg [7:0] data_l

    );
    
always @(posedge clock or posedge reset)
begin
    if(reset) begin
        data_h = 8'h00;
        data_l = 8'h00;
    end
    else if (addr==`SFR_DPTR_HI && wr && !(wr_bit))begin
        data_l=data_in;
    end
    else if (addr==`SFR_DPTR_LO && wr && !(wr_bit))begin
        data_h=data_in;
    end
    
end
endmodule
