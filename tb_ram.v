`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2022 09:57:59 AM
// Design Name: 
// Module Name: tb_ram
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


module tb_ram;
    //inputs
    reg clock;
    reg reset;
    reg [7:0] Memaddr;
    reg Memrd;
    reg Memwr;
    reg [7:0] Memin_data;
    reg Memin_bit;
    reg Memis_bit;
    reg [7:0] Membit_addr;
    reg Memindirect_flag;
    
    //outputs
    wire [7:0] out;
    wire out_bit;

memory_ram ram_module(
    .clock(clock),
    .reset(reset),
    .addr(Memaddr),
    .rd(Memrd),
    .wr(Memwr),
    .in_data(Memin_data),
    .in_bit(Memin_bit),
    .is_bit (Memis_bit),
    .bit_addr(Membit_addr),
    .indirect_flag(Memindirect_flag),
    .out(out),
    .out_bit(out_bit)
);
    initial begin
        clock = 1'b0;
        reset = 1'b1;
        // write and read byte test
        Memwr=1'b1;
        Memrd=1'b0;
        Memaddr = 8'h88;
        Memin_bit=1'b0;
        Memin_data = 8'h18;
        Memis_bit = 1'b0;
        Memindirect_flag = 1'b0;
        #10
        reset = 1'b0;
        #10;
        Memwr=1'b1; // write byte
        Memrd=1'b0;
        #30;
        Memwr=1'b0; //read byte
        Memrd=1'b1;
        #10;
        // read and write bit
        Memis_bit=1'b1;
        Memwr=1'b1; // write bit
        Memrd=1'b0;
        Memin_bit=1'b1;
        Membit_addr = 8'h05; // write is 7 bit
        #20;
        Memis_bit=1'b1;
        Memwr=1'b0; // read bit
        Memrd=1'b1;
        Memin_bit=1'b1;
        Membit_addr = 8'h05; // write is 7 bit
        
    end
always #5 clock = ~clock;  
endmodule
