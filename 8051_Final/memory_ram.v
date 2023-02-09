`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 889
// 
// Create Date: 11/24/2022 10:22:21 AM
// Design Name: 
// Module Name: memory_ram
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


module memory_ram
#(parameter DATA_WIDTH =256 , parameter ADDRESS_WIDTH = 8, parameter INIT_FILE = "init_ram")
(
    input clock,
    input reset,
    input [(ADDRESS_WIDTH-1):0] addr, 
    input rd, //read
    input wr, //write
    input [7:0] in_data,// data to write in an address
    input in_bit, // data to write in the bit 
    input is_bit, // flag to indicate that is bit addressable
    output reg [7:0] out,// word
    output reg out_bit
);
// -------------Auxiliar variables---------------
integer i;
//----------------------------------------------
reg [7:0] mem_word;
reg [7:0] aux_addr_bit; // auxiliar variable to find the address of the bit to change
reg  [(ADDRESS_WIDTH-1):0] Memory [0:256]; // 0-256

wire write,writebitSFR,writebit,read,readbitSFR, readbit;


assign write = ( wr &&  !rd && !is_bit )                                        ?1'b1:1'b0; // write

assign writebitSFR = ( wr && !rd && is_bit&&(addr >= 8'h80 && addr<=8'hFF) && 
        ((addr[3:0]- addr[2:0]) == 8'h8 || addr[3:0] <= 8'h07) )       ?1'b1:1'b0; // write bit SFR
        
assign writebit = ( wr && !rd && is_bit && (addr>=8'h20 && addr<=8'h2F))      ?1'b1:1'b0; // write bit addressable

assign read = (rd && !wr && !is_bit )                                          ?1'b1:1'b0; // read

assign readbitSFR  = (rd && !wr && is_bit && ((addr >= 8'h80 && addr<=8'hFF) && 
        ((addr[3:0]- addr[2:0]) == 8'h8 || addr[3:0] <= 8'h07) ))      ?1'b1:1'b0; // read bit SFR
        
assign readbit  = (rd && !wr && is_bit && addr>=8'h20 && addr<=8'h2F)        ?1'b1:3'b0; // read bit addressable

initial begin
    for ( i = 0; i<=256;i= i+1) 
        Memory[i] = 8'h00;
end
always @( posedge clock )
begin
// Full Case
        if (write)begin // write
            Memory[addr] = in_data;
        end
        else if(writebit)begin // write bit SFR
            mem_word = Memory [ addr/8 + 8'h20];// aux_addr_bit(line) + 20h (first address of bit addressable memory)
            mem_word[addr[2:0]] = in_bit;
            Memory[addr/8 + 8'h20] = mem_word;
        end
        else if(writebitSFR)begin // write bit addressable
            aux_addr_bit ={addr[7:3],3'b000};
            mem_word = Memory[aux_addr_bit];    
            mem_word [addr[2:0]] = in_bit;
            Memory[{addr[7:3],3'b000}] = mem_word;
        end
        else if (read )begin
            out = Memory[addr];
        end
        else if (readbit) begin // read bit SFR
            mem_word = Memory [addr/8+ 8'h20]; // aux_addr_bit(line) + 20h (first address of bit addressable memory)
            out_bit = mem_word[addr%8];
        end
        else if( readbitSFR)begin // read bit addressable
             aux_addr_bit ={addr[7:3],3'b000};
             mem_word = Memory [aux_addr_bit];
             out_bit = mem_word[addr[2:0]];
        end
end
endmodule