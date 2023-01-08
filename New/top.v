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
    input [7:0] data_in,
    output [7:0] data_out
    );
    
    
    
    wire [4:0] alu_code;
    reg [7:0] src_1; 
    reg [7:0] src_2;
    
    wire [7:0] addr_ram;
    wire [16:0] addr_rom;
    
    alu_core alu_core_module(
        .clock(clock),
        .reset(reset),
        .alu_opcode(alu_code),
        .op_in_1(src_1), 
        .op_in_2(src_2), 
        .carry_in(cy),
        .aux_carry_in(ac),
        .bit_in(bit_in),
        .overflow_out(ov_new),
        .aux_carry_out(ac_new),
        .carry_out(cy_new),
        .op_out_1(des_1),
        .op_out_2(des_2) 
        );
        
    sfr_regfile sfr(
        .clock(clock),
        .reset(reset),
        .data_in(data_in),
        .addr(addr_ram),
        .bit_in(bit_in),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .cy_in(cy_new),
        .ac_in(ac_new),
        .ov_in(ov_new),
        .psw_set(psw_set),
        .data_out(data_out),
        .acc(acc),
        .cy(cy),
        .ac(ac),
        .bank_sel(bank_sel),
        .dptr_low(dptr_low),
        .dptr_high(dptr_high)
        );

    memory_rom ROM(
    .clock(clock), 
    .reset(reset),
    .addr(addr_rom),
    .out(instruction)
    );
    
    memory_ram RAM(
    .clock(clock),
    .reset(reset),
    .addr(addr_ram), 
    .rd(Memrd), //read
    .wr(Memwr), //write
    .in_data(data_in),// data to write in an address
    .in_bit(bit_in), // data to write in the bit 
    .bit_addr(bit_addr),
    .is_bit(is_bit), // flag to indicate that is bit addressable
    .indirect_flag (indirect_flag), // flag 
    .out(out_data),// word
    .out_bit (out_bit)
    ); 
    
    
endmodule
