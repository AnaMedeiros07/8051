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

module th0(
        
        input clock, reset,
        
        input [7:0] data_in,
        input [7:0] addr,
        
        input wr_en,
        input wr_bit_en,
        input bit_in,
        
        output reg [7:0] th0_data

    );
    

wire wr_th0, wr_bit_th0;


assign wr_th0 = (wr_en & !wr_bit_en & addr == `SFR_TH0);

always @(posedge reset )
begin
        th0_data = 8'h00;
end
always@(posedge clock)begin
   if (wr_th0)
        th0_data = data_in;
end
        
endmodule