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
        
        input write_en,
        input write_bit_en,
        input bit_in,
        
        output data_out,
        output parity
    );
    
reg [7:0] acc_data;
reg [7:0] data_out;

wire wr_acc, wr_bit_acc;

assign p = ^acc_data;

assign wr_acc = (write_en & !write_bit_en & addr == `SFR_ACC);
assign wr_bit_acc = (write_en & write_bit_en & addr == `SFR_B_ACC);

always @(data_in or addr or write_en or write_bit_en or bit_in)
begin
    if (wr_acc)
        acc_data = data_in;
    else if (wr_bit_acc)
        acc_data[addr[2:0]] = bit_in;
end

always @(posedge clock or posedge reset)
begin
    if(reset)
        acc_data = 8'h00;
    else
        data_out = acc_data;
end
        
endmodule
