`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2023 09:44:28 AM
// Design Name: 
// Module Name: sfr_regfile
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


module sfr_regfile(
    input clock,
    input reset,
    
    input [7:0] data_in,
    input [7:0] addr,
    input bit_in,
    input write_en,
    input write_bit_en,
    //psw inputs
    
    input cy_in,
    input ac_in,
    input ov_in,
    input [1:0] psw_set,
    //general output
    output [7:0] data_out,
    
    //acc output
    output [7:0] acc,
    //psw outputs
    output cy,
    output ac,
    output [1:0] bank_sel
    
    );
    
    wire [7:0] psw_data;
    wire [1:0] bank_sel;
    
    reg [7:0] data_out;
    
    assign bank_sel = psw_data[4:3];
    assign cy = psw_data[7];
    assign ac = psw_data[6];
    
    psw psw_module(
        .clock(clock),
        .reset(reset),
        .carry_in(cy_in),               
        .aux_carry_in(ac_in),           
        .overflow_in(ov_in),           
        .parity(parity),                
        .data_in(data_in),
        .addr(addr),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .psw_set(psw_set),              
        .psw_data(psw_data) 
        );   
        
    acc_sfr acc_sfr_module(
        .clock(clock), 
        .reset(reset),
        .data_in(data_in),
        .addr(addr),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_in(bit_in),
        .data_out(acc_data),
        .parity(parity)
    );
    
    b_sfr b_sfr_module(
        .clock(clock), 
        .reset(reset),
        .data_in(data_in),
        .addr(addr),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_in(bit_in),
        .data_out(b_data)
    ); 
    
    port #(.SFR_ADDR(`SFR_P0), .SFR_B_ADDR(`SFR_B_P0)) port0(
        .clock(clock), 
        .reset(reset),
        .data_in(data_in),
        .addr(addr),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_in(bit_in),
        .data_out(port0_data)
    );
    
    port #(.SFR_ADDR(`SFR_P1), .SFR_B_ADDR(`SFR_B_P1)) port1(
        .clock(clock), 
        .reset(reset),
        .data_in(data_in),
        .addr(addr),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_in(bit_in),
        .data_out(port1_data)
    );
    
    port #(.SFR_ADDR(`SFR_P2), .SFR_B_ADDR(`SFR_B_P2)) port2(
        .clock(clock), 
        .reset(reset),
        .data_in(data_in),
        .addr(addr),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_in(bit_in),
        .data_out(port2_data)
    );
    
    port #(.SFR_ADDR(`SFR_P3), .SFR_B_ADDR(`SFR_B_P3)) port3(
        .clock(clock), 
        .reset(reset),
        .data_in(data_in),
        .addr(addr),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_in(bit_in),
        .data_out(port3_data)
    );
    
always @(posedge clock or posedge reset)
if(reset)
    data_out = 0;
else
    begin
        case (addr)
            `SFR_ACC:   data_out = acc_data;
            `SFR_B:     data_out = b_data;
            `SFR_PSW:   data_out = psw_data;
            `SFR_P0:    data_out = port0_data;
            `SFR_P1:    data_out = port1_data;
            `SFR_P2:    data_out = port2_data;
            `SFR_P3:    data_out = port3_data;
        endcase
    end
    
    
    
endmodule
