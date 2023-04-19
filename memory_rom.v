`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2022 10:24:00 AM
// Design Name: 
// Module Name: memory_rom
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


module memory_rom

#(parameter DATA_WIDTH = 65535, parameter ADDRESS_WIDTH = 8, parameter INIT_FILE = "init_rom.mem")
(
    input [15:0] addr, // FFFFh
    input clock,
    input reset,
    output reg [7:0] out// word
);


reg [7:0]ROM [0:(DATA_WIDTH-1)] ;

initial $readmemh("init_rom.mem", ROM);

//reads 3 in one clock cycle
always @(posedge clock)
begin
        out = ROM[addr];
en
endmodule
