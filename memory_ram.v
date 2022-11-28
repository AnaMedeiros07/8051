`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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
    input in_data,// data to write in an address
    input in_bit, // data to write in the bit 
    input bit_addr,
    input is_bit, // flag to indicate that is bit addressable
    input indirect_flag, // flag 
    output reg [(ADDRESS_WIDTH -1):0] out,// word
    output reg out_bit
);
// -------------Auxiliar variables---------------
integer i;
//----------------------------------------------
reg [7:0] mem_word;
reg bit_to_change;
reg [7:0] aux_addr_bit; // auxiliar variable to find the address of the bit to change
reg [127:0] LRAM [(ADDRESS_WIDTH-1):0]; // 0-127 

reg [(DATA_WIDTH-1):128] HRAM[ (ADDRESS_WIDTH-1):0]; //SFR's

reg [(DATA_WIDTH-1):128] IRAM[ (ADDRESS_WIDTH-1):0]; //127-256 inderect acess


// -----------------Reset------------------------
always @(posedge reset)
begin
    for (i=0; i<=127;i=i+1) begin
      LRAM[i]=16'b0000000000000000;
    end
    for (i=0; i<=128;i=i+1) begin
      HRAM[i]=16'b0000000000000000;
      IRAM[i]=16'b0000000000000000;
    end  
end

//=====================================================================
// notes : see better SFR bit addressable

// ========================Write and Read bit===========================
always @(posedge clock)
begin
    if (is_bit ==1'b1)begin // bit addressable 
        if(rd ==1'b1)begin
            if( (addr >= 128 && addr<=255) && addr[3:0] == 4'b1000 || addr[3:0] == 4'b0000 )begin // SFR  / direct acess
                mem_word = HRAM [addr];
                out_bit=mem_word[bit_to_change];
            end
            else if(addr>=8'b00100000 && addr<=8'b00101111) begin // bit addressable area 20h to 2Fh
                aux_addr_bit = bit_addr/8;
                bit_to_change =  bit_addr%8;
                mem_word = LRAM [aux_addr_bit+ 8'b00100000]; // aux_addr_bit(line) + 20h (first address of bit addressable memory)
                out_bit=mem_word[bit_to_change];
            end
        end 
       if(wr==1'b1)begin
          if( (addr >= 128 && addr<=255) && (addr[3:0] == 4'b1000  || addr[3:0] == 4'b0000))begin // SFR  finishing in 0 or 8 are 
            mem_word = HRAM [addr];                                                              // bit addressable
            mem_word [bit_to_change] = in_bit;
            HRAM[addr] = mem_word;
          end
          else if(addr>=8'b00100000 && addr<=8'b00101111)begin // bit addressable area 20h to 2Fh
            aux_addr_bit = bit_addr/8; // example : 9/8 = 1 so is the line 1; 9%8=1 it meaans that is the bit one of the line 1
            bit_to_change =  bit_addr%8;
            mem_word = LRAM [aux_addr_bit + 8'b00100000];// aux_addr_bit(line) + 20h (first address of bit addressable memory)
            mem_word[bit_to_change] = in_bit;
            LRAM[addr] = mem_word;
          end 
       end
    end
        
end
//============================================================================
// ========================Write and Read byte================================
always @(posedge clock)
begin
    if (is_bit ==1'b1)begin // byte addressable
        if(rd ==1'b1)begin
            if( addr >= 128 && addr<=255)begin // SFR  / direct acess
               out = HRAM[addr];
            end
            else if(addr <128 && addr >=0) begin 
               out = LRAM[addr];
            end
            else if (indirect_flag==1 && addr >= 128 && addr<=255 )
                out = IRAM[addr];
            end
        end 
       if(wr==1'b1)begin
          if( addr >= 128 && addr<=255)begin // SFR  / direct acess
            HRAM[addr] = in_data;
          end
          else if(addr <128 && addr >=0) begin
            LRAM[addr] = in_data;
          end 
          else if (indirect_flag==1 && addr >= 128 && addr<=255 ) begin  
            out = IRAM[addr];
          end
        end     
end
//============================================================================
endmodule
