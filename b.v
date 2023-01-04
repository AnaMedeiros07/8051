`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2023 17:19:59
// Design Name: 
// Module Name: b
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

module b_sfr(
        
        input clock, reset,
        
        input [7:0] data_in,
        input [7:0] addr,
        
        input wr_en,
        input wr_bit_en,
        input bit_in,
        
        output b_data
    );
    
reg [7:0] b_data;

wire wr_b, wr_bit_b;

assign wr_b = (wr_en & !wr_bit_en & addr == `SFR_B);
assign wr_bit_b = (wr_en & wr_bit_en & addr == `SFR_B_B);

always @(posedge reset or posedge clock)
begin
    if(reset)
        b_data = 0;
    else if (wr_b)
        b_data = data_in;
    else if (wr_bit_b)
        b_data[addr[2:0]] = bit_in;
end
        
endmodule
