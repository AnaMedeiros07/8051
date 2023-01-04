`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2023 17:19:59
// Design Name: 
// Module Name: acc
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

module acc_sfr(
        
        input clock, reset,
        
        input [7:0] data_in,
        input [7:0] addr,
        
        input wr_en,
        input wr_bit_en,
        input bit_in,
        
        output acc_data,
        output p
    );
    
reg [7:0] acc_data;

wire wr_acc, wr_bit_acc;

assign p = ^acc_data;

assign wr_acc = (wr_en & !wr_bit_en & addr == `SFR_ACC);
assign wr_bit_acc = (wr_en & wr_bit_en & addr == `SFR_B_ACC);

always @(posedge reset or posedge clock)
begin
    if(reset)
        acc_data = 0;
    else if (wr_acc)
        acc_data = data_in;
    else if (wr_bit_acc)
        acc_data[addr[2:0]] = bit_in;
end
        
endmodule
