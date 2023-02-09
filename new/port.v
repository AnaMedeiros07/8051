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


module port #(parameter SFR_ADDR = `SFR_P2,SFR_B_ADDR = `SFR_B_P2)(

    input clock, reset,
    input [7:0] data_in,
    input [7:0] addr,
    
    input write_en,
    input write_bit_en,
    input bit_in,
    
    output reg [6:0] data_out
    );
    
reg [6:0] port_data;

assign wr_port = (write_en & !write_bit_en & addr == SFR_ADDR);
assign wr_bit_port = (write_en & write_bit_en & addr[7:3] == SFR_B_ADDR);

always @(data_in or addr or write_en or write_bit_en or bit_in)
begin
    if (wr_port)
        port_data = data_in;
    else if (wr_bit_port)
        port_data[addr[2:0]] = bit_in;
end

always @(posedge reset)
begin
     port_data = 8'h00;
        
end  
   
always@(posedge clock)
begin
    data_out = port_data;
end 

endmodule