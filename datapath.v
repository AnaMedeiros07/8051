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
        input Aload,
        input NotRload,
        input wire [3:0] RAM_access,
        input wire [3:0] ALU_Opcode,
        input IRload,
        input PCload,
        input JMPload,
        output wire [7:0] Opcode
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
wire [7:0] out_ram;
wire out_bit;

//===ROM===
reg rd_rom;
reg [9:0]addr_rom;

//Output
wire [7:0] out_rom;

//=== PSW=====
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
 reg [7:0] offset;
 reg [7:0] addr1;
 reg [7:0] addr2; 
 
//== Registers ==
reg [15:0] PC;
reg [7:0] IR;



//-------------------------------------------------------------------------------                 
// -------------- intanciate the ram_controller --------------------------------
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
    .out(out_ram),// word
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
    .addr(PC),
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
        .data_in(in_data),
        .acc_in(acc),
        .write_en(Memwr),
        .write_bit_en(is_bit),
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
     .wr_en(Memwr),
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
     .wr_en(Memwr),
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
    IR = 8'h00;
    alu_code = 5'h00;
    src_1 = 8'h00;
    src_2 = 8'h00;
    cy = 1'b0;
    aux_cy = 1'b0;
    bit = 1'b0;
    in_data = 8'h00;
    Bank = 2'h00;
    offset = 8'h00;
end
    // --------------Reset --------------------------
always @ (posedge reset)
begin 
    addr_rom = 8'h00;
    addr_ram= 8'h00;
    PC = 16'h0000;

end

//-------------------For Fetch1 and Fetch2-----------------------
always @ (posedge clock)
begin 
    if(IRload == 1'b1 && PCload == 1'b1 && NotRload == 1'b1) begin // 2 fetch
        addr1= out_rom;
        PC = PC + 1;
   end
   else if(IRload == 1'b1 && PCload == 1'b1 ) begin // 1 fetch
        IR= out_rom;
        PC = PC + 1;
   end

end
    //-----------------Assign the opcode -----------------------------
assign Opcode = IR[7:0];


//----------------Decode RAM------------------      
always @ (posedge clock)
begin 
        begin: Decode_RAM
        case(RAM_access)
            `RD_RAM_IM:begin // 
                src_1 = acc_data; 
             end
             `RD_RAM_DIRECT:begin
                src_1 = acc_data;
                Memwr=1'b0;
                Memrd=1'b1;
                indirect_flag=1'b0;
                is_bit =1'b0;
                addr_ram =addr1;  
             end
             `RD_RAM_REG:begin
              Bank = psw_data[4:3];
              if (Bank == 2'b00 )begin
                offset <= `BanK_0_offset;
              end
              if (Bank == 2'b01 )begin
                offset <= `BanK_1_offset;
              end
              if (Bank == 2'b10 )begin
                offset <= `BanK_2_offset;
              end
              if (Bank == 2'b11 )begin
                offset <= `BanK_3_offset;
              end
                src_1 = acc_data;
                Memwr=1'b0;
                Memrd=1'b1;
                indirect_flag=1'b0;
                is_bit =1'b0;
                addr_ram =IR[2:0] + offset;  ;
              end
              `RD_RAM_REG_IND:begin
                src_1 = acc_data;
                Memwr=1'b0;
                Memrd=1'b1;
                indirect_flag=1'b1;
                is_bit =1'b0;
                addr_ram =IR[0] + offset;  
              end 
             `WR_RAM_REG:begin
              Bank = psw_data[4:3];
              if (Bank == 2'b00 )begin
                offset <= `BanK_0_offset;
              end
              if (Bank == 2'b01 )begin
                offset <= `BanK_1_offset;
              end
              if (Bank == 2'b10 )begin
                offset <= `BanK_2_offset;
              end
              if (Bank == 2'b11 )begin
                offset <= `BanK_3_offset;
              end
              Memwr = 1'b1;
              Memrd = 1'b0;
              indirect_flag = 1'b0;
              is_bit = 1'b0;
              in_data = acc_data;
              addr_ram = IR[2:0] +offset;
             end  
             `WR_RAM_REG_IND:begin
                Memwr=1'b0;
                Memrd=1'b1;
                indirect_flag=1'b1;
                is_bit =1'b0;
                in_data = acc_data;
                addr_ram =IR[0] + offset;  
              end    
             default:begin
             end
        endcase
      end

end
always @ (posedge clock)
begin
   if( Aload == 1'b1)begin
        begin: Decode_ALU
        case(ALU_Opcode)
            `ALU_ADD:begin
             src_2 = out_ram;
             flag_set =`CY_OV_AC_SET ;
             alu_code = `ALU_ADD;
             end
             `ALU_SUBB:begin
             src_2 = out_ram;
             flag_set =`CY_OV_AC_SET ;
              alu_code = `ALU_SUBB;
             end
             `ALU_ANL:begin
              src_2 = out_ram;
              flag_set =`NO_SET ;
               alu_code = `ALU_ANL;
             end
             `ALU_ORL:begin
              src_2 = out_ram;
              flag_set =`NO_SET ;
               alu_code = `ALU_ORL;
             end
             `ALU_INC:begin
              src_2 = out_ram;
              flag_set =`NO_SET ;
               alu_code = `ALU_INC;
             end
             `ALU_DEC:begin
              src_2 = out_ram;
              flag_set =`NO_SET ;
               alu_code = `ALU_DEC;
             end
             default:begin
             end
        endcase
      end
      if ( alu_code != 5'h00) begin
          in_data = des_1;
          Memwr = 1'b1;
          indirect_flag = 1'b0;
          addr_ram=`SFR_ACC;
          is_bit = 1'b0;
          alu_code = 5'h00;
      end
      else if ( Opcode == `MOV_D && Opcode == `MOV_C && Opcode[7:3] == `MOV_R && Opcode == `MOV_I) begin
        in_data = out_ram;
        Memwr = 1'b1;
        indirect_flag = 1'b0;
        addr_ram=`SFR_ACC;
        is_bit = 1'b0;
        alu_code = 5'h00;
      end 
   end
    
end

always @ (posedge clock)
begin
    if(JMPload == 1'b1)begin
        begin : FindJMP
            case (Opcode)
                `JNZ:begin
                    if(acc_data != 8'h00)begin
                       PC = PC + {8'h00,addr1};
                    end  
                  end
                 `JZ:begin
                    if(acc_data == 8'h00)begin
                        PC = PC + {8'h00,addr1};
                    end
                 end
                 `JNC:begin
                    if(psw_data[7] != 8'h00)begin
                        PC = PC + {8'h00,addr1};
                    end
                 end
                 `AJMP:begin
                      PC = { IR[7:5],addr1};
                 end
            default:begin
            end
            endcase  
        end
    end
   
    
end

endmodule
