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
    input indirect_flag, // flag 
    output reg [(ADDRESS_WIDTH -1):0] out,// word
    output reg out_bit
);
// -------------Auxiliar variables---------------
integer i;
//----------------------------------------------
reg [7:0] mem_word;
reg [7:0] bit_addr;
reg [3:0] bit_to_change;
reg [7:0] aux_addr_bit; // auxiliar variable to find the address of the bit to change
reg  [(ADDRESS_WIDTH-1):0] LRAM [127:0]; // 0-127 

reg [ (ADDRESS_WIDTH-1):0]HRAM[(DATA_WIDTH-1):128] ; //SFR's

reg [ (ADDRESS_WIDTH-1):0] IRAM [(DATA_WIDTH-1):128]; //127-256 inderect acess


// -----------------Reset------------------------
always @(posedge reset)
begin
    for (i=0; i<=127;i=i+1) begin
      LRAM[i]=8'h00;
    end
    for (i=128; i<=255;i=i+1) begin
      HRAM[i]=8'h00;
      IRAM[i]=8'h00;
    end  
   
end

//=====================================================================
// ========================Write and Read bit===========================
always @(rd or addr)
begin
if(rd==1'b1) begin
    if (is_bit ==1'b1)begin // bit addressable 
        if( (addr >= 8'h80 && addr<=8'hFF) && ((addr[3:0]- addr[2:0]) == 8'h8 || addr[3:0] <= 8'h07) )begin // SFR  / direct acess
            mem_word = HRAM [addr];
            bit_addr = addr[2:0];
            out_bit = mem_word[bit_addr];
        end
        else if(addr>=8'h20 && addr<=8'h2F) begin // bit addressable area 20h to 2Fh
            aux_addr_bit = addr/8;
            bit_to_change =  addr%8;
            mem_word = LRAM [aux_addr_bit+ 8'h20]; // aux_addr_bit(line) + 20h (first address of bit addressable memory)
            out_bit=mem_word[bit_to_change];
        end
    end
    if (is_bit ==1'b0)begin 
          if( addr >= 8'h80 && addr<=8'hFF && indirect_flag == 1'b0)begin // SFR  / direct acess
               out = HRAM[addr];
            end
            else if(addr <8'h80 && addr >=8'h0) begin 
               out = LRAM[addr];
            end
            else if (indirect_flag==1'b1 && addr >= 8'h80 && addr<=8'hFF )begin
                out = IRAM[addr];
            end
        end
    end
end
//============================================================================
// ========================Write and Read byte================================
always @(wr or addr)
begin
if( wr == 1'b1) begin
    if (is_bit ==1'b0)begin // byte addressable
          if( addr >= 8'h80 && addr<=8'hFF && indirect_flag ==1'b0)begin // SFR  / direct acess
            HRAM[addr] = in_data;
          end
          else if(addr <8'h80 && addr >=8'h00) begin
            LRAM[addr] = in_data;
          end 
          else if (indirect_flag==1'b1 && addr >= 8'h80 && addr<=8'hFF ) begin  
            IRAM[addr]= in_data;
          end
    end   
     if (is_bit ==1'b1)begin 
        if( (addr >= 8'h80 && addr<=8'hFF) && ((addr[3:0]- addr[2:0]) == 8'h8 || addr[3:0] <= 8'h07) )begin // SFR  finishing in 0 or 8 are 
            mem_word = HRAM [addr];    
            bit_addr = addr[2:0];                                                          // bit addressable
            mem_word [bit_addr] = in_bit;
            HRAM[addr] = mem_word;
          end
          else if(addr>=8'h20 && addr<=8'h2F)begin // bit addressable area 20h to 2Fh
            aux_addr_bit = bit_addr/8; // example : 9/8 = 1 so is the line 1; 9%8=1 it meaans that is the bit one of the line 1
            bit_to_change =  bit_addr % 8;
            aux_addr_bit = aux_addr_bit + 8'h20;
            mem_word = LRAM [aux_addr_bit];// aux_addr_bit(line) + 20h (first address of bit addressable memory)
            mem_word[bit_to_change] = in_bit;
            LRAM[aux_addr_bit] = mem_word;
          end   
   end
   end
end
//============================================================================
endmodule