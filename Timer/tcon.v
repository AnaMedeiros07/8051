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

module tcon(
        
        input clock, reset,
        
        input [7:0] data_in,
        input [7:0] addr,
        
        input wr_en,
        input wr_bit_en,
        input bit_in,
        
        output reg [7:0] tcon_data
    );
    

wire wr_tcon, wr_bit_tcon;


assign wr_tcon = (wr_en & !wr_bit_en & addr == `SFR_TCON);
assign wr_bit_tcon = (wr_en & wr_bit_en & addr[7:3] == `SFR_B_TCON);

always @(posedge reset or posedge clock)
begin
    if(reset)
        tcon_data = 8'h00;
    else if (wr_tcon)
        tcon_data = data_in;
    else if (wr_bit_tcon)
        tcon_data[addr[2:0]] = bit_in;
end
        
endmodule
