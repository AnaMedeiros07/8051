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
    input [(ADDRESS_WIDTH-1):0] addr, // FFFFh
    input rd, //read
    input wr, //write
    input in_data,// write in an address
    input in_bit, // write in a bit
    input is_bit_addr, // address of a bit
    input p0_in, // ports
    input p1_in,
    input p2_in,
    input p3_in,
    output [(ADDRESS_WIDTH -1):0] out,// word
    output out_bit
);
// -------------Auxiliar variables---------------
integer i;
//----------------------------------------------
reg [(ADDRESS_WIDTH -1):0] out;
reg out_bit;
reg [7:0] mem_word;
reg bit_to_change;
reg [7:0] addr_bit;
reg [127:0] iRAM [(ADDRESS_WIDTH-1):0];

reg [(DATA_WIDTH-1):128] IRAM[ (ADDRESS_WIDTH-1):0];

initial if (INIT_FILE) begin

    $readmemh(INIT_FILE,RAM);  
     
end 
// -----------------Reset------------------------
always @(posedge reset)
begin
    for (i=0; i<=127;i=i+1) begin
      iRAM[i]=16'b0000000000000000;
    end
    for (i=0; i<=128;i=i+1) begin
      IRAM[i]=16'b0000000000000000;
    end  
end

// ========================Write and Read bit=======================000
always @(posedge clock)
begin
    if (is_bit_addr ==1'b1)begin // bit addressable 
        bit_to_change =addr[2:0];
        if(rd ==1'b1)begin
            if( addr >= 128 && addr<=255)begin // SFR  / direct acess
                mem_word = IRAM [addr];
                out_bit=mem_word[bit_to_change];
            end
            else begin // bit addressable area 20h to 2Fh
                assign addr_bit ={3'b001,addr[4:0]};
                mem_word = iRAM [addr];
                out_bit=mem_word[bit_to_change];
            end
        end 
       if(wr==1'b1)begin
          if( addr >= 128 && addr<=255)begin // SFR  / direct acess
            mem_word = IRAM [addr];
            mem_word [bit_to_change] = in_bit;
            IRAM[addr] = mem_word;
          end
          else begin
            assign addr_bit ={3'b001,addr[4:0]};
            mem_word = iRAM [addr];
            mem_word[bit_to_change] = in_bit;
            iRAM[addr] = mem_word;
          end 
       end
    end
        
end
//============================================================================
// ========================Write and Read byte=======================000
always @(posedge clock)
begin
    if (is_bit_addr ==0'b1)begin // byte addressable
        if(rd ==1'b1)begin
            if( addr >= 128 && addr<=255)begin // SFR  / direct acess
               out = IRAM[addr];
            end
            else begin 
               out = iRAM[addr];
            end
        end 
       if(wr==1'b1)begin
          if( addr >= 128 && addr<=255)begin // SFR  / direct acess
            IRAM[addr] = in_data;
          end
          else begin
            iRAM[addr] = in_data;
          end 
       end
    end
        
end
//============================================================================
endmodule
