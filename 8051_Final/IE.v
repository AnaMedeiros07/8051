`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2023 08:06:26 PM
// Design Name: 
// Module Name: tcon
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

module IE(
        
        input clock, reset,
        
        input [7:0] data_in,
        input [7:0] addr,
        
        input wr_en,
        input wr_bit_en,
        input bit_in,
        
        output reg [7:0] IE_data
    );
    

wire wr_IE, wr_bit_IE;

assign wr_IE = (wr_en & !wr_bit_en & addr == `SFR_IE);
assign wr_bit_IE = (wr_en & wr_bit_en & addr[7:3] == `SFR_B_IE);

always @(posedge reset or posedge clock)
begin
    if(reset)
        IE_data = 8'h00;
    else if (wr_IE)
        IE_data = data_in;
    else if (wr_bit_IE)
        IE_data[addr[2:0]] = bit_in;
end
        
endmodule