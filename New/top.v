`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2023 13:05:45
// Design Name: 
// Module Name: top
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

module top(
    
    input clock, reset,
    input write_en,
    input write_bit_en,
    input [7:0] data_addr,
    input [7:0] data_in,
    output [7:0] data_out,
    input en_data_in,
    input en_data_out,
    input [23:0] instruction
    );
    
    //data and addr bus
    
    wire [7:0] data_addr_bus;
    wire [7:0] data_bus;
    
    assign data_addr_bus = data_addr;
    assign data_bus = en_data_in ? data_in : en_data_out ? data_out : data_bus;
    
    wire [7:0] psw_data;
    
    //instrcution register
    
    assign op_code = instruction[23:16];
    assign op_1 = instruction[15:8];
    assign op_2 = instruction[7:0];
    
    assign cy = psw_data[7];
    assign aux_cy = psw_data[6];
    
    reg [7:0] alu_code;
    reg [7:0] src_1; 
    reg [7:0] src_2;
    
    alu_core alu_core_module(
        .clock(clock),
        .reset(reset),
        .alu_opcode(alu_code),
        .op_in_1(src_1), 
        .op_in_2(src_2), 
        .carry_in(cy),
        .aux_carry_in(aux_cy),
        .bit_in(bit_in),
        .overflow_out(ov_new),
        .aux_carry_out(ac_new),
        .carry_out(cy_new),
        .op_out_1(des_1),
        .op_out_2(des_2) 
        );
    
    psw psw_module(
        .clock(clock),
        .reset(reset),
        .carry_in(cy_new),
        .aux_carry_in(ac_new),
        .overflow_in(ov_new), 
        .parity(parity),
        .data_in(data_bus),
        .addr(data_addr_bus),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .flag_set(flag_set),
        .psw_data(psw_data) 
        );   
        
    acc_sfr acc_sfr_module(
        .clock(clock), 
        .reset(reset),
        .data_in(data_bus),
        .addr(data_addr_bus),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_in(bit_in),
        .acc_data(acc),
        .parity(parity)
    );
    
    b_sfr b_sfr_module(
        .clock(clock), 
        .reset(reset),
        .data_in(data_bus),
        .addr(addr_bus),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_in(bit_in),
        .b_data(b)
    );       

     
endmodule
