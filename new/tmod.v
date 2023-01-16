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

module tmod(
        
        input clock, reset,
        
        input [7:0] data_in,
        input [7:0] addr,
        
        input wr_en,
        input wr_bit_en,
        input bit_in,
        
        output reg [7:0] tmod_data
    );
    

wire wr_tmod, wr_bit_tmod;


assign wr_tmod = (wr_en & !wr_bit_en & addr == `SFR_TMOD);

always @(posedge reset)
begin
        tmod_data = 8'h00;
end

always@(posedge clock)begin
    if (wr_tmod)
        tmod_data = data_in;
end
        
endmodule