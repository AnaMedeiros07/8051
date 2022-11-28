`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2022 04:34:29 PM
// Design Name: 
// Module Name: decoder
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
//--------------Definition of opcodes offset  to choose the register bank------------
`define BanK_3_offset 8'h1FH
`define BanK_2_offset 8'h17H
`define BanK_1_offset 8'h0FH
`define BanK_0_offset 8'h0H
//----------------------------------------------------------------------------------
module decoder(
    input clock,
    input reset,
    input A,
    input [24:0] instruction 
    );
    
// --------------intanciate the memory_ram --------------------
 memory_ram RAM(
    .clock(clock),
    .reset(reset),
    .addr(addr), 
    .Memrd(rd), //read
    .Memwr(wr), //write
    .in_data(in_data),// data to write in an address
    .in_bit(in_bit), // data to write in the bit 
    .bit_addr(bit_addr),
    .is_bit(is_bit), // flag to indicate that is bit addressable
    .indirect_flag (indirect_flag), // flag 
    .out_data (out),// word
    .out_bit (out_bit)
    ); 
  //---------------------Variables to do the decode ---------------------------- 
  assign opcodes = instruction[24:16];
  assign op_1 = instruction[16:8];
  assign op_2 = instruction [7:0];
  //----------------------------------------------------------------------------

 //-===================================================================
 //==============================ADD instruction========================
  always @ (posedge clock)
  begin : Decode_ADD
        case(opcodes)
            `ADD_R:begin                          // ADD A,R0 A=A+Rn
             // op_1 = A;
            // op_2 = 
            // alu_opcode = ALU_ADD
             end
            `ADDC_R: begin                      // ADD A,Rn A=A+Rx+c
             // alu_opcode = ALU_ADD
             end
            `ADD_I: begin                        //ADD A,@Ri A= A+ Ri
             // alu_opcode = ALU_ADD
             end
            `ADDC_I: begin                      // ADDC A,@Ri A=A+Ri+c
             // alu_opcode = ALU_ADD
             end
            `ADD_D: begin                            //ADD A,direct A= A+direct
             // alu_opcode = ALU_ADD
            end
            `ADDC_D:begin                        // ADD A,#immediate A=A+immediate
             // alu_opcode = ALU_ADD
             end
            `ADD_C: begin                      // ADDC A,direct A=A+(direct)+c
             // alu_opcode = ALU_ADD
             end
            `ADDC_C:begin                            // ADDC A,#immediate 
             // alu_opcode = ALU_ADD
             end
             default: begin
             end
        endcase 
 end

 //==================================================================
 //=====================SUB instruction =============================
  always @ (posedge clock)
  begin : Decode_SUBB
        case(opcodes)
            `SUBB_R: begin                                     // SUBB A,Rn 
             // op_1 = A;
            // op_2 = 
            // alu_opcode = ALU_SUBB
            end
            `SUBB_I: begin                                    // SUBB A,@Ri
             // alu_opcode = ALU_SUBB
            end
            `SUBB_D: begin                                     // SUBB A,direct
             // alu_opcode = ALU_SUBB
             end
            `SUBB_C: begin                                   //SUBB A, #immediate
             // alu_opcode = ALU_SUBB
             end
             default: begin
             end
        endcase 
 end
 //==================================================================
 //=====================DIV instruction =============================
  always @ (posedge clock)
 begin
    if(opcodes == `DIV) begin
        
    end
 end
 //==================================================================
 //=====================MUX instruction =============================
  always @ (posedge clock)
 begin
    if(opcodes == `MUL) begin
        
    end
 end
  //==================================================================
 //=====================RL instruction =============================
  always @ (posedge clock)
 begin
    if(opcodes == `RL) begin // Rotate Left
        
    end
 end
  //==================================================================
 //=====================RLC instruction =============================
  always @ (posedge clock)
 begin
    if(opcodes == `RLC) begin // Rotate Left through carry
        
    end
 end
   //==================================================================
 //=====================RR instruction =============================
  always @ (posedge clock)
 begin
    if(opcodes == `RR) begin //Rotate Right
        
    end
 end
    //==================================================================
 //=====================RRC instruction =============================
  always @ (posedge clock)
 begin
    if(opcodes == `RRC) begin //Rotate Right  through carry
        
    end
 end   
  //==================================================================
 //=====================DA instruction =============================
  always @ (posedge clock)
 begin
    if(opcodes == `DA) begin //decimal adjust (A)
        
    end
 end
 
endmodule
