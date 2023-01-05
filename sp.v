`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 03:00:35 PM
// Design Name: 
// Module Name: sp
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

`include"define_opcodes.v"

module sp (
    input clock,
    input reset,
    
    input [7:0] wr_addr, // Addr where we need to write
    
    input ram_rd,// rd from memory
    input ram_wr, // wr from memory
    
    input wr_bit,
    
    input push,
    input pop,
    
    input [7:0] data_in,
    
    output [7:0] sp_out, //value of the stack pointer
    output [7:0] sp_w   // value to write in the memory
 );



reg [7:0] sp_out, sp_w;
wire write;
wire [7:0] sp_t;

reg [7:0] sp;


assign write = ((wr_addr==`SFR_SP) & (ram_wr) & !(wr_bit));

assign sp_t= write ? data_in : sp;


always @(posedge clock or posedge reset)
begin
  if (reset)
    sp <= `RST_SP; // reset to 07h
  else if (write)
    sp <= data_in; // value to write in the push 
  else
    sp <= sp_out; // current stackpointer value
end


always @(push & write)
begin

    sp_w = sp_t;  // data to write in the stack
    sp_out = sp_t + 8'h01; // increase the stack

end

always @(pop & ram_rd & sp_out > `RST_SP) // if is possible read, pop is ative and the value os the spatck_pointer in greater than 07h
begin

    sp_w = 8'h00; // clean the data
    sp_out = sp_t - 8'h01; // decrease the stack

end

endmodule
