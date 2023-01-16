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
    input [ADDRESS_WIDTH -1:0] addr, // FFFFh
    input clock,
    input reset,
    output reg [ADDRESS_WIDTH -1:0] out// word
);


reg [(ADDRESS_WIDTH-1):0]ROM [(DATA_WIDTH-1):0] ;

initial $readmemb("init_rom.mem", ROM);

//reads 3 in one clock cycle
always @(posedge clock)
begin
      
        out = ROM[addr];

end
endmodule
