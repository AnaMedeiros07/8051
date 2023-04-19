`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2023 17:17:36
// Design Name: 
// Module Name: ports
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


module port(

    input clock, reset,
    input [7:0] data_in,
    input [7:0] addr,
    
    input write_en,
    input write_bit_en,
    input bit_in,
    
    output reg [6:0] data_out
    );

assign wr_port = (write_en & !write_bit_en & addr == `SFR_P2);
assign wr_bit_port = (write_en & write_bit_en & addr[7:3] == `SFR_B_P2);

always @(posedge clock)
begin
    if (reset)
        data_out = 8'h00;
    if (wr_port)
        data_out = data_in;
    else if (wr_bit_port)
        data_out[addr[2:0]] = bit_in;
end


endmodule