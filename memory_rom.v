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

#(parameter DATA_WIDTH = 65536, parameter ADDRESS_WIDTH = 8, parameter INIT_FILE = "init_rom")
(
    input [(ADDRESS_WIDTH-1):0] addr, // FFFFh
    input clock,
    input reset,
    output [(DATA_WIDTH-1):0] out// word
);

reg [8:0] out;
reg [(DATA_WIDTH-1):0] ROM [(ADDRESS_WIDTH-1):0];

initial if (INIT_FILE) begin

    $readmemh(INIT_FILE,ROM);  
     
end 

always @(posedge reset)
begin
    for (integer i=0; i<=DATA_WIDTH;i=i+1) begin
        ROM[i] = 8'h00;
    end  
end
always @(posedge clock)
begin
      out<= ROM[addr];
end
endmodule
