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

module tl0(
        
        input clock, reset,
        
        input [7:0] data_in,
        input [7:0] addr,
        
        input wr_en,
        input wr_bit_en,
        input bit_in,
        
        output reg [7:0] tl0_data
    );
    

wire wr_tl0, wr_bit_tl0;


assign wr_tl0 = (wr_en & !wr_bit_en & addr == `SFR_TL0);

always @(posedge reset)
begin
    tl0_data= 8'h00;
end
always@(posedge clock)begin
    if (wr_tl0) begin
        tl0_data = data_in;
    end
end
        
endmodule
