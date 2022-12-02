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

`define NO_SET          2'b00
`define CY_SET          2'b01
`define CY_OV_SET       2'b10
`define CY_OV_AC_SET    2'b11

module psw(
    input clock,
    input reset,
    
    input carry_in,
    input aux_carry_in,
    input overflow_in,
    input [7:1] data_in,
    input [7:0] acc_in,
    
    input write_en,
    input write_bit_en,
    input [2:0] bit_addr,
    
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
    
always @(posedge reset)
begin
    data = 8'h00;
end

always @(posedge clock)
begin
    if(write_en & !write_bit_en)
        data [7:1] = data_in [7:1];
    else if(write_en & write_bit_en)
        data[bit_addr[2:0]]= carry_in;
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


endmodule
