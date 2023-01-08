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

#(parameter DATA_WIDTH = 65536, parameter ADDRESS_WIDTH = 8, parameter INIT_FILE = "init_rom.mem")
(
    input [(10-1):0] addr, // FFFFh
    input rd_rom,
    input clock,
    input reset,
    output reg [23:0] out// word
);


reg [(ADDRESS_WIDTH-1):0]ROM [(DATA_WIDTH-1):0] ;

initial $readmemb("init_rom.mem", ROM);

//reads 3 in one clock cycle
always @(posedge clock)
begin
      //out<=ROM[addr];
      out[23:16] <= ROM[addr];
      out[15:8] <= ROM[addr+1];
      out[7:0] <= ROM[addr+2];
end
endmodule
