`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2023 09:29:59 PM
// Design Name: 
// Module Name: datapath
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

//---------------------------------------------------------------------
module datapath(
        input clock,
        input reset,
        input [7:0] A,
        output [7:0] Opcode
        
        
    );

//-----------------------intanciate variables--------------------------------

//==== ALU ====
reg [4:0] alu_code;
reg [7:0] src_1, src_2;
reg cy, aux_cy,bit;

//Outputs
wire [7:0] des_1, des_2;
wire cy_out, ac_out, ov_out;

//====RAM==
reg Memrd,Memwr,in_data,in_bit,bit_addr,is_bit,indirect_flag,addr_ram;

//Outputs
reg out_data,out_bit;

//===ROM===
reg addr_rom,rom_r;

//Output
reg out_rom;

//=== PSW=====
reg [7:1] data_in;
reg [7:0] acc;
reg write_en, write_bit_en;
reg [2:0] bit_addr_psw;
reg [1:0] flag_set;

//Output
 reg [7:0] psw_data;
 
 //=== DPTR===
 reg [7:0] data_in1;
 reg[7:0] data_in2;
 
 //Output
 reg [7:0] data_h;
  reg [7:0] data_l;
  
 // === Aux_Variables===
 reg [1:0] Bank;
 reg [7:0] offset;
 reg [7:0] addr1;
 reg [7:0] addr2; 
 
//== Registers ==
reg [15:0] PC;
reg [7:0] IR;


                 
// -------------- intanciate the memory_ram --------------------------------
memory_ram RAM(
    .clock(clock),
    .reset(reset),
    .addr(addr_ram), 
    .rd(Memrd), //read
    .wr(Memwr), //write
    .in_data(in_data),// data to write in an address
    .in_bit(in_bit), // data to write in the bit 
    .bit_addr(bit_addr),
    .is_bit(is_bit), // flag to indicate that is bit addressable
    .indirect_flag (indirect_flag), // flag 
    .out(out_data),// word
    .out_bit (out_bit)
); 
//-------------------------------------------------------------------------------
//---------------------- intanciate the ALU -------------------------------------
alu_core alu_core_module(
        .clock(clock),
        .reset(reset),
        .alu_opcode(alu_code),
        .op_in_1(src_1), // first operand
        .op_in_2(src_2), // second operand
        .carry_in(cy),
        .aux_carry_in(aux_cy),
        .bit_in(bit),
        .overflow_out(ov_out),
        .aux_carry_out(ac_out),
        .carry_out(cy_out),
        .op_out_1(des_1),
        .op_out_2(des_2) 
);    
//--------------------------------------------------------------------------------
//--------------------------intanciate the ROM-------------------------------------
memory_rom ROM(
    .clock(clock),
    .reset(reset),
    .addr(addr_rom),
    .out(out_rom)
);
//------------------------intanciate PSW------------------------------------------
 psw psw_module(
        .clock(clock),
        .reset(reset),
        .carry_in(cy_new),
        .aux_carry_in(ac_new),
        .overflow_in(ov_new), 
        .data_in(data_in),
        .acc_in(acc),
        .write_en(write_en),
        .write_bit_en(write_bit_en),
        .bit_addr(bit_addr_psw),
        .flag_set(flag_set),
        .psw_data(psw_data) 
        );
dptr dptr_module(
        .clock(clock),
        .reset(reset),
        .wr(Memwr),
        .addr(addr_ram),
        .data_in(in_data),
        .data_h(data_h),
        .data_l(data_l)
    );
//---------------------------------------------------------------------------------
//---------------------Variables to do the decode ------------------------------ 

// --------------Reset / Start--------------------------
always @ (posedge clock)
begin 
    addr_rom = 8'h00;
    addr_ram= 8'h00;
    PC = 16'h0000;
end

//-------------------Fetch-----------------------
always @ (posedge clock)
begin 
    addr_rom = PC;
    IR = out_rom;
    PC = PC + 1;
    addr1= out_rom;
    PC = PC + 1;
    addr2 = out_rom;
    PC = PC + 1;
    // PSW and A
end
//----------------------------------------------
assign Opcode = IR[7:0];
//-------------Decode------------------------------
always @ (posedge clock)
begin 
        Bank = psw_data[3:4];
        if (Bank == 2'b00 )begin
            offset = `BanK_0_offset;
        end
         if (Bank == 2'b01 )begin
            offset = `BanK_1_offset;
        end
         if (Bank == 2'b10 )begin
            offset = `BanK_2_offset;
        end
         if (Bank == 2'b11 )begin
            offset = `BanK_3_offset;
        end
begin : Decode
        case(Opcode)
            `ADD_R:begin                          // ADD A,R0 A=A+Rn
                alu_code = `ALU_ADD;
                Memwr=1'b0;
                Memrd= 1'b1;
                is_bit=1'b0;
                indirect_flag=1'b0;
                addr_ram = addr1;
                src_1= out_data;
                addr_ram =  addr2 + offset;
                src_2 = out_data;
                flag_set = `CY_OV_AC_SET;
             end
            `ADDC_R: begin                      // ADD A,Rn A=A+Rx+c
               alu_code = `ALU_ADDC;
               Memwr=1'b0;
               Memrd= 1'b1;
               is_bit=1'b0;
               indirect_flag=1'b0;
               addr_ram = addr1;
               src_1= out_data;
               addr_ram =  addr2+ offset;
               src_2 = out_data;
               flag_set = `CY_OV_AC_SET;
             end
             `ADD_I: begin                        //ADD A,@Ri A= A+ Ri
                alu_code = `ALU_ADD;
                Memwr=1'b0;
                Memrd= 1'b1;
                is_bit=1'b0;
                indirect_flag=1'b0;
                addr_ram = addr1;
                src_1= out_data;
                addr_ram =  addr2 + offset;
                // Read the indirect memory of the addr
                addr_ram = out_data;
                indirect_flag=1'b1;
                src_2 = out_data;
                flag_set = `CY_OV_AC_SET;
             end
            `ADDC_I: begin                      // ADDC A,@Ri A=A+Ri+c
                Memwr=1'b0;
                Memrd= 1'b1;
                is_bit=1'b0;
                indirect_flag=1'b0;
                alu_code = `ALU_ADDC;
                addr_ram = addr1;
                src_1= out_data;
                addr_ram =  addr2 + offset;
                // Read the indirect memory of the addr
                addr_ram = out_data;
                indirect_flag=1'b1;
                src_2 = out_data;
                flag_set = `CY_OV_AC_SET;
             end
            `ADD_D: begin                            //ADD A,direct A= A+direct
                 alu_code = `ALU_ADD;
                 Memwr=1'b0;
                 Memrd= 1'b1;
                 is_bit=1'b0;
                 indirect_flag=1'b0;
                 addr_ram = addr1;
                 src_1= out_data;
                 addr_ram =  addr2;
                 src_2=out_data;
                 flag_set = `CY_OV_AC_SET;
            end
            `ADDC_D:begin                        // ADDC A,direct A=A+(direct)+c
                 alu_code = `ALU_ADDC;
                 Memwr=1'b0;
                 Memrd= 1'b1;
                 is_bit=1'b0;
                 indirect_flag=1'b0;
                 addr_ram = addr1;
                 src_1= out_data;
                 addr_ram =  addr2;
                 src_2=out_data;
                 flag_set = `CY_OV_AC_SET;
             end
            `ADD_C: begin                     // ADD A,#immediate A=A+immediate
                 alu_code = `ALU_ADD;
                 Memwr=1'b0;
                 Memrd= 1'b1;
                 is_bit=1'b0;
                 indirect_flag=1'b0;
                 addr_ram = addr1;
                 src_1= out_data;
                 addr_ram =  addr2;
                 src_2=out_data;
                 flag_set = `CY_OV_AC_SET;
             end
            `ADDC_C:begin                            // ADDC A,#immediate 
                 alu_code = `ALU_ADDC;
                 Memwr=1'b0;
                 Memrd= 1'b1;
                 is_bit=1'b0;
                 indirect_flag=1'b0;
                 addr_ram = addr1;
                 src_1= out_data;
                 src_2=addr2;
                 flag_set = `CY_OV_AC_SET;
             end
             `INC_A:begin                            // increment accumulator
                 alu_code = `ALU_INC;
                 Memwr=1'b0;
                 Memrd= 1'b1;
                 is_bit=1'b0;
                 indirect_flag=1'b0;
                 addr_ram = addr1;
                 src_1= out_data;
                 flag_set = `NO_SET;
             end
             `INC_D:begin                            // increment direct 
                 alu_code = `ALU_INC;
                 Memwr=1'b0;
                 Memrd= 1'b1;
                 is_bit=1'b0;
                 indirect_flag=1'b0;
                 addr_ram = addr1;
                 src_1 = out_data;
                 flag_set = `NO_SET;
             end
             `INC_DP:begin                            // increment data pointer
                 alu_code = `ALU_INC;
                 flag_set = `NO_SET;
                 src_1=data_l;
                 src_2 = data_h;
                 Memwr = 1'b1;
                 Memrd= 1'b0;
                 is_bit=1'b0;
                 indirect_flag=1'b0;
                 addr_ram = `SFR_DPTR_LO;
                 in_data =des_1;
                 addr_ram = `SFR_DPTR_HI;
                 in_data = des_2;
             end
            `SUBB_R: begin                                     // SUBB A,Rn  
                alu_code = `ALU_SUBB;
                Memwr=1'b0;
                Memrd= 1'b1;
                is_bit=1'b0;
                indirect_flag=1'b0;
                addr_ram = addr1;
                src_1= out_data;
                addr_ram =  addr2 + offset;
                src_2 = out_data;
                flag_set = `CY_OV_AC_SET;
            end
            `SUBB_I: begin                                    // SUBB A,@Ri
                alu_code = `ALU_SUBB;
                Memwr=1'b0;
                Memrd= 1'b1;
                is_bit=1'b0;
                indirect_flag=1'b0;
                addr_ram = addr1;
                src_1= out_data;
                addr_ram =  addr2 + offset;
                // Read the indirect memory of the addr
                addr_ram = out_data;
                indirect_flag=1'b1;
                src_2 = out_data;
                flag_set = `CY_OV_AC_SET;
            end
            `SUBB_D: begin                                     // SUBB A,direct
                alu_code = `ALU_SUBB;
                Memwr=1'b0;
                Memrd= 1'b1;
                is_bit=1'b0;
                indirect_flag=1'b0;
                addr_ram = addr1;
                src_1= out_data;
                addr_ram =  addr2;
                src_2=out_data;
                flag_set = `CY_OV_AC_SET;
             end
            `SUBB_C: begin                                   //SUBB A, #immediate
                alu_code = `ALU_SUBB;
                flag_set = `CY_OV_AC_SET;
             end
              `DEC_A:begin                          // decrement A
                 alu_code = `ALU_DEC;
                 flag_set = `NO_SET;
             end
             `DEC_D:begin                            // decrement direct
                 alu_code = `ALU_DEC;
                 flag_set = `NO_SET;
             end
             `DIV: begin                                   
                alu_code = `ALU_DIV;
                flag_set = `CY_OV_SET;
             end
             `MUL: begin                                   
                alu_code = `ALU_MUL;
                flag_set = `CY_OV_SET;
             end
             `RL: begin                                   
                alu_code = `ALU_RL;
                flag_set = `NO_SET;
             end
             `RLC: begin                                   
                alu_code = `ALU_RLC;
                flag_set = `NO_SET;
             end
             `RR: begin                                   
                alu_code = `ALU_RR;
                flag_set = `NO_SET;
             end
             `RRC: begin                                   
                alu_code = `ALU_RRC;
                flag_set = `NO_SET;
             end
             `DA: begin                                  
                alu_code = `ALU_DA;
                flag_set = `CY_SET;
             end
             `XRL_D:begin                            // XOR A=A XOR (direct)
                 alu_code = `ALU_XRL;
                 flag_set = `NO_SET;
             end
              `XRL_C:begin                            // XOR A=A XOR constant
                 alu_code = `ALU_XRL;
                 flag_set = `NO_SET;
             end
              `XRL_AD:begin                           // XOR (direct)=(direct) XOR A
                 alu_code = `ALU_XRL;
                 flag_set = `NO_SET;
             end
              `XRL_CD:begin                           // XOR (direct)=(direct) XOR constant
                 alu_code = `ALU_XRL;
                 flag_set = `NO_SET;
             end
              `XRL_I:begin                             // XOR A=A XOR @Ri
                 alu_code = `ALU_XRL;
                 flag_set = `NO_SET;
             end
              `ANL_D:begin                          // ANL A, direct and A=A^(direct)   
                 alu_code = `ALU_ANL;
                 flag_set = `NO_SET;
             end
              `ANL_C:begin                         // ANL A, immediate and A=A^constant
                 alu_code = `ALU_ANL;
                 flag_set = `NO_SET;
             end
              `ANL_AD:begin                        // ANL direct, A and (direct)=(direct)^A    
                 alu_code = `ALU_ANL;
                 flag_set = `NO_SET;
             end
              `ANL_DC:begin                      // ANL direct, #immediate and (direct)=(direct)^constant 
                 alu_code = `ALU_ANL;
                 flag_set = `NO_SET;
             end
              `ANL_B:begin                       // ANL C, bit and c=c^bit
                 alu_code = `ALU_ANL;
                 flag_set = `NO_SET;
             end
              `ANL_NB:begin                      // ANL C, /bit and c=c^!bit       
                 alu_code = `ALU_ANL;
                 flag_set = `NO_SET;
             end
             `ORL_D:begin                          // ANL A, direct and A=A^(direct)   
                 alu_code = `ALU_ORL;
                 flag_set = `NO_SET;
             end
              `ORL_C:begin                         // ANL A, immediate and A=A^constant
                 alu_code = `ALU_ORL;
                 flag_set = `NO_SET;
             end
              `ORL_AD:begin                        // ANL direct, A and (direct)=(direct)^A    
                 alu_code = `ALU_ORL;
                 flag_set = `NO_SET;
             end
              `ORL_CD:begin                      // ANL direct, #immediate and (direct)=(direct)^constant 
                 alu_code = `ALU_ORL;
                 flag_set = `NO_SET;
             end
              `ORL_B:begin                       // ANL C, bit and c=c^bit
                 alu_code = `ALU_ORL;
                 flag_set = `NO_SET;
             end
              `ORL_NB:begin                      // ANL C, /bit and c=c^!bit       
                 alu_code = `ALU_ORL;
                 flag_set = `NO_SET;
             end
             default: begin
             end
        endcase 
    end
end
endmodule
