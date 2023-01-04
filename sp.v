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
`define Stack_addr 8'h81
`define Stack_init 8'h07

module sp(
    input clock,
    input reset,
    
    input push, 
    input pop,
    
    input ram_read, 
    input ram_write,
    
    input [7:0] data_in, // data to write in the stack
    
    output reg [7:0] sp_out, // value of the stack
    output reg [7:0] sp_w   // write in the stack memory
    
    );

reg [7:0] sp;

initial begin
    sp = `Stack_init;
end

always @(posedge reset or posedge clock)
begin
    if (reset)begin
        sp = `Stack_init; // initial position of stackpointer
    end
    

end
always @(posedge push)
begin
    sp = sp + 8'h01;
    sp_out = sp;
    sp_w = data_in;
end
always @(posedge pop && sp!= `Stack_init)
begin
    sp = sp - 8'h01;
    sp_out = sp;
end

endmodule
