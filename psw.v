`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2022 02:12:44 PM
// Design Name: 
// Module Name: psw
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

`include "define_opcodes.v"

module psw(
    input clock,
    input reset,
    
    input carry_in,
    input aux_carry_in,
    input overflow_in,
    input [7:0] data_in,
    input [7:0] acc_in,
    input [7:0]addr,
    input write_en,
    input write_bit_en,
    
    input [1:0] flag_set,
     
    output [7:0] psw_data
    );
    
    reg [7:0] data;
    /* 
    Data [0] - Parity
    Data [1] - User Flag 1
    Data [2] - Overflow FLag 
    Data [4:3] - Register Bank Select
    Data [5] - User Flag 0
    Data [6] - Auxiliary Carry Flag
    Data [7] - Carry Flag
    */
    
    assign psw_data = data;

always @(posedge clock or posedge reset)
begin
    if(reset)
        data= 8'h00;
    else begin 
        if(write_en & !write_bit_en & (addr == `SFR_PSW))
            data [7:1] = data_in [7:1];
            
        else if(write_en & write_bit_en & (addr[7:3] == `SFR_B_PSW))
            data[addr[2:0]]= carry_in;
            
        else begin
            case (flag_set)
                
                `CY_SET:
                    begin
                        data[7] = carry_in;
                    end
                
                `CY_OV_SET:
                    begin
                        data[7] = carry_in;
                        data[2] = overflow_in;
                    end
                
                `CY_OV_AC_SET:  
                    begin
                        data[7] = carry_in;
                        data[2] = overflow_in;
                        data[6] = aux_carry_in;
                    end
            endcase
        end
    
    data[0]= ^acc_in; //parity update
    end
    
    
end


endmodule