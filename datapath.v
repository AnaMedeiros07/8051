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
        output ready,
        input Execute,
        input Fetch,
        input Decode,
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
reg Memrd,Memwr,in_bit,bit_addr,is_bit,indirect_flag;
reg [7:0] addr_ram;
reg [7:0] in_data;

//Outputs
wire [7:0] out_data;
wire out_bit;

//===ROM===
reg rd_rom;
reg [9:0]addr_rom;

//Output
wire [23:0] out_rom;

//=== PSW=====
reg [7:1] data_in;
reg [7:0] acc;
reg write_en, write_bit_en;
reg [2:0] bit_addr_psw;
reg [1:0] flag_set;

//Output
 wire [7:0] psw_data;
 
 //=== DPTR===
 reg [7:0] data_in1;
 reg[7:0] data_in2;
 
 //Output
 wire [7:0] data_h;
 wire [7:0] data_l;
 
 // ==== Acc and b ====
 reg wr_en_acc,wr_en_b;
  
  wire [7:0] acc_data;
  wire [7:0] b_data;
 // === Aux_Variables===
 reg [1:0] Bank;
 reg [23:0] instruction;
 reg [7:0] offset;
 reg [7:0] addr1;
 reg [7:0] addr2; 
 reg [2:0] cycles;
 reg ready;
 reg [2:0] count_clock;
 
//== Registers ==
reg [15:0] PC;
reg [7:0] IR;
reg [7:0] PSW;
reg [7:0] A;


//-------------------------------------------------------------------------------                 
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
//---------------------------------------------------------------------------------
//----------------------------intanciate PSW------------------------------------------
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
        .addr(bit_addr_psw),
        .flag_set(flag_set),
        .psw_data(psw_data) 
        );
//---------------------------------------------------------------------------------------
//---------------------------intanciate DPTR--------------------------------------------
dptr dptr_module(
        .clock(clock),
        .reset(reset),
        .wr_bit(wr_bit),
        .wr(Memwr),
        .addr(addr_ram),
        .data_in(in_data),
        .data_h(data_h),
        .data_l(data_l)
    );
//---------------------------------------------------------------------------------------
//--------------------------------intanciate Acc-----------------------------------------
acc_sfr acc_module(
     .clock(clock),
     .reset(reset),
     .data_in(in_data),
     .addr(addr_ram),
     .wr_en(wr_en_acc),
     .wr_bit_en(is_bit),
     .bit_in(in_bit),
     .acc_data(acc_data),
     .parity(a_parity)
    );
//-------------------------------------------------------------------------------------------
//-------------------------------intanciate B----------------------------------------------
b_sfr b_module(
     .clock(clock),
     .reset(reset),
     .data_in(in_data),
     .addr(addr_ram),
     .wr_en(wr_en_b),
     .wr_bit_en(is_bit),
     .bit_in(bit_in),
     .b_data(b_data)
    );
//---------------------------------------------------------------------------------
//---------------------Variables to do the decode ------------------------------ 

initial begin
   addr_rom = 8'h00;
    addr_ram= 8'h00;
    PC = 16'h0000;
    count_clock = 3'b000; 
    end
    // --------------Reset / Start--------------------------
always @ (posedge reset)
begin 
    addr_rom = 8'h00;
    addr_ram= 8'h00;
    PC = 16'h0000;
    count_clock = 3'b000;
end

//-------------------Fetch-----------------------
always @ (posedge clock)
begin 
    if(Fetch == 1'b1) begin
        addr_rom = PC;
        instruction = out_rom;
        IR= instruction[23:16];
        addr1= instruction[15:8];
        addr2= instruction[7:0];
        PC = PC + 3;
        PSW = psw_data;
        A = acc_data;
        ready = 1'b0;
    end  
end
//----------------------------------------------
assign Opcode = IR[7:0];
//-------------Decode------------------------------
always @ (posedge clock)
begin 
    if (Decode == 1'b1 ) begin
            Bank = PSW[4:3];
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
    begin : Decocer1
            case(Opcode[4:0])
                `ACALL:begin
                 end
                 `AJMP:begin
                 end
                 default: begin
                 end
            endcase
    end
    begin : Decoder2
            case(Opcode[7:3])
                `ADD_R:begin                          // ADD A,R0 A=A+Rn
                    alu_code = `ALU_ADD;
                    Memwr =1'b0;
                    Memrd= 1'b1; 
                    indirect_flag = 1'b0;
                    is_bit = 1'b0;
                    addr_ram = Opcode[2:0] + offset;
                    src_2 = out_data;
                    src_1 = acc_data;
                    flag_set = `CY_OV_AC_SET;
                 end
                `ADDC_R: begin                      // ADD A,Rn A=A+Rx+c
                   alu_code = `ALU_ADDC;
                   flag_set = `CY_OV_AC_SET;
                 end
                 `INC_R:begin                            // increment accumulator
                     alu_code = `ALU_INC;
                    
                     flag_set = `NO_SET;
                 end
                `SUBB_R: begin                                     // SUBB A,Rn  
                    alu_code = `ALU_SUBB;
                 
                    flag_set = `CY_OV_AC_SET;
                end
                `DEC_R:begin                          // decrement reg
                     alu_code = `ALU_DEC;
                     flag_set = `NO_SET;
                 end
                 `XRL_R:begin                            
                     alu_code = `ALU_XRL;
                     flag_set = `NO_SET;
                 end
                 default: begin
                 end
            endcase 
        end
    begin : Decoder3
        case (Opcode[7:0])
              `MOV_C: begin                    //Mov A, #immediate
                    cycles= 3'b001;
                    Memwr = 1'b1;
                    Memrd = 1'b0;
                    is_bit = 1'b0;
                    indirect_flag = 1'b0;
                    wr_en_acc = 1'b1; 
                    addr_ram = `SFR_ACC;
                    in_data = addr1;
                    end
                    default: begin
                    end
                endcase   
       end
    end
end

always @(posedge clock)
begin
    if (Execute == 1'b1) begin
        count_clock =  count_clock +1'b1;
        if (count_clock == cycles ) begin
            ready = 1'b1;
            count_clock = 3'b000;
        end
        else if (cycles == 3'b010 ) begin
                    
            end
        else if (cycles == 3'b100) begin
        end
    end
end
endmodule
