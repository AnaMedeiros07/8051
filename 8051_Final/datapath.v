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
        input wire [3:0] RAM_access,
        input wire [4:0] ALU_Opcode,
        input IRload,
        input PCload,
        input ALUload,
        input JMPload,
        input RAMload,
        output wire [6:0] port2_data,
        output wire [7:0] Opcode 
    );
//___________________________________________________________________________
//_______________________-intanciate variables_______________________________

//==== ALU ====
reg [4:0] alu_code;
reg [7:0] src_1, src_2;
reg cy, aux_cy,bit;

//Outputs
wire [7:0] des_1, des_2;
wire cy_out, ac_out, ov_out;

//====RAM==
reg Memrd,Memwr,in_bit,is_bit;
reg [7:0] addr_ram;
wire [7:0] addr;
reg [7:0] in_data;

//Outputs
wire out_bit;
wire [7:0] out_ram;
//===ROM===
reg [15:0] addr_rom;
//Output
wire [7:0] out_rom;

//=== PSW=====

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
  wire [7:0] acc_data;
  wire [7:0] b_data;
  //=====timer SFR's====
  wire [7:0] tmod_data;
  wire [7:0] tcon_data;
  wire [7:0] th0_data;
  wire [7:0] tl0_data;
  wire [7:0] IE_data;
  //======ports=====
  // ===timer aux variavels===
  wire tf0;
  // === Stack pointer ==
  reg [3:0] ram_sel;
  wire [7:0] sp_out;
 // === Aux_Variables===
 reg [1:0] Bank;
 reg [7:0] offset;
 reg [7:0] addr1;
 reg old_bit;
 wire int_en;
 reg int_request;
 reg timer_request;
 reg int_pend;
 
 
//== Registers ==
reg [15:0] PC;
reg [7:0] IR;
//__________________________________________________________________________________
//-------------------------------------------------------------------------------                 
// -------------- intanciate RAM--------------------------------

memory_ram RAM(
    .clock(clock),
    .reset(reset),
    .addr(addr_ram),
    .rd(Memrd), //read
    .wr(Memwr), //write
    .in_data(in_data),// data to write in an address
    .in_bit(in_bit), // data to write in the bit 
    .is_bit(is_bit), // flag to indicate that is bit addressable
    .out(out_ram),// word
    .out_bit (out_bit)
); 

//-------------------------------------------------------------------------------
//---------------------- intanciate the ALU -------------------------------------
alu_core alu_core_module(
        .clock(clock),
        .reset(reset),
        .alu_opcode(ALU_Opcode),
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
        .carry_in(cy_out),
        .aux_carry_in(aux_cy),
        .overflow_in(ov_out), 
        .data_in(in_data),
        .acc_in(acc_data),
        .write_en(Memwr),
        .write_bit_en(is_bit),
        .addr(addr_ram),
        .flag_set(flag_set),
        .psw_data(psw_data) 
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

//------------------------------------------------------------------------------
////-------------------------instanciate SP-------------------------------------
sp sp_module(
        .clock(clock),
        .reset(reset),
        .wr(Memwr),
        .wr_bit(in_bit),
        .ram_sel(ram_sel),
        .wr_addr(addr_ram),
        .sp_out(sp_out)
        );

//-----------------------------instanciate tcon---------------------------------
//-------------------------------------------------------------------------------
tcon tcon_module(
     .clock(clock),
     .reset(reset),
     .data_in(in_data),
     .addr(addr_ram),
     .wr_en(Memwr),
     .wr_bit_en(is_bit),
     .bit_in(in_bit),
     .tcon_data(tcon_data)
    );
//-----------------------------instanciate IE---------------------------------
//-------------------------------------------------------------------------------
IE IE_module(
     .clock(clock),
     .reset(reset),
     .data_in(in_data),
     .addr(addr_ram),
     .wr_en(Memwr),
     .wr_bit_en(is_bit),
     .bit_in(in_bit),
     .IE_data(IE_data)
    );
//-------------------------instanciate timer------------------------------------
timer timer_module(
     .clock(clock),
     .reset(reset),
     .wr_addr(addr_ram),
     .data_in(in_data),
     .wr(Memwr),
     .wr_bit(is_bit),         
     .tcon(tcon_data),
	 .tmod(tmod_data),
	 .tl0(tl0_data),
	 .th0(th0_data),
     .tf0(tf0)
 
    );
//-------------------------------------------------------------------------------
//-----------------------------instaciate port2----------------------------------        
port port2(
        .clock(clock), 
        .reset(reset),
        .data_in(in_data),
        .addr(addr_ram),
        .write_en(Memwr),
        .write_bit_en(is_bit),
        .bit_in(in_bit),
        .data_out(port2_data)
    );
//---------------------------------------------------------------------------------
//---------------------Variables to do the decode ------------------------------ 

initial begin
    addr_ram= 8'h00;
    PC = 16'h0000;
    IR = 8'h00;
    alu_code = 5'h00;
    src_1 = 8'h00;
    src_2 = 8'h00;
    cy = 1'b0;
    aux_cy = 1'b0;
    in_data = 8'h00;
    Bank = 2'h00;
    offset = 8'h00;
    Memwr = 1'b0;
    Memrd = 1'b0;
    in_bit = 1'b0;
    is_bit =1'b0;
    old_bit = 1'b0;
    addr_rom= 16'h0000;
    timer_request= 1'b0;
    int_request= 1'b0;
    int_pend = 1'b0;
end
    // --------------Reset --------------------------


assign int_en = (IRload == 1'b1) ? 1'b1:1'b0; // check if is happing an intruction


//-------------------Update PC-----------------------
always @ (posedge clock)
begin 
       if(PCload == 1'b1 ) begin // increment PC
                PC = PC + 1;
       end
       else if (JMPload == 1'b1 && RAMload == 1'b1 && Aload == 1'b1) begin  // for jmp instructions
          begin : FindJMP1
            case (Opcode)
                `JNZ:begin
                    if(acc_data!= 8'h00)begin
                       PC ={8'h00,addr1};
                    end  
                  end
                 `JZ:begin
                    if(acc_data== 8'h00)begin
                        PC = {8'h00,addr1};
                     end
                 end
                 `JNC:begin
                    if(psw_data[7] != 8'h00)begin
                        PC ={8'h00,addr1};
                    end
                   end
                  `RETI: begin
                    PC[7:0] = out_ram;
                  end
                  default:begin
                  end
               endcase
            end
            begin : FindJMP2
            case (Opcode[4:0])
                 `AJMP:begin
                      PC[10:0] = { IR[7:5],addr1};
                 end
                 `ACALL: begin
                     PC[10:0] = { IR[7:5],addr1};
                 end
            default:begin
            end
            endcase  
        end
       end  
    end
  

//-----------------Update IR and addr1----------------------
always @(posedge clock)
begin
     if((tf0 == 1'b1 || int_pend==1'b1) && int_en && IE_data[7] == 1'b1 && IE_data[1] == 1'b1) begin 
        int_request = 1'b1;
        int_pend = 1'b0;
    end
    else if (tf0 == 1'b1 && IE_data[7] == 1'b1 && IE_data[1] == 1'b1) begin
        int_pend = 1'b1;
    end
    else if ( tf0 == 1'b1 && int_en== 1'b1)begin
         timer_request = 1'b1;
    end
    else if(int_en == 1'b1 ) begin
       timer_request= 1'b0;
    end
    
    if(int_request == 1'b0) begin
        if(PCload == 1'b1 && IRload == 1'b1 ) begin
            IR = out_rom;
        end
        else if ( PCload == 1'b1 )begin
            addr1 = out_rom;
        end
    end
    else begin
        if(PCload == 1'b1 && IRload == 1'b1 ) begin
            IR = 8'b00010001; // ACALL
        end
        else if ( PCload == 1'b1 )begin
            addr1 = 8'b00001011;  // timer 0 interrupt vetor 0b
            int_request= 1'b0;
        end
    end
end
    
    //-----------------Assign the opcode -----------------------------
assign Opcode = IR[7:0];


//----------------Access RAM------------------      
always @ (posedge clock)
begin 
    if ( Aload == 1'b1 && RAMload == 1'b1 && JMPload == 1'b1)begin // update tf0
         Memwr = 1'b1;
         Memrd = 1'b0;
         is_bit = 1'b1;
         in_bit = timer_request;
         addr_ram = 8'h8d;
    end
    else if(Aload == 1'b1 && RAMload ==1'b1) begin // Update A
         if ( ALU_Opcode != 5'h00) begin
                  in_data = des_1; 
                  Memwr = 1'b1;
                  Memrd = 1'b0;
                  addr_ram = `SFR_ACC;
                  is_bit = 1'b0;
         end
         else if ( Opcode == `MOV_D || Opcode == `MOV_C || Opcode[7:3] == `MOV_R || Opcode == `MOV_I) begin
            if(RAM_access == `RD_RAM_IM) begin
                in_data =addr1;
            end
            else begin
                in_data = out_ram;
            end
            Memwr = 1'b1;
            addr_ram =`SFR_ACC;
            is_bit = 1'b0;
    
      end
   end
   else if(JMPload == 1'b1)begin
         if(Opcode[4:0]== `ACALL) begin
        ram_sel = `WR_RAM_STACK;
        Memwr =1'b1;
        Memrd =1'b0;
        is_bit =1'b0;
        in_data = PC[15:8];
        addr_ram = sp_out;
    end
    if(Opcode == `RETI) begin
        Memwr=1'b0;
        ram_sel = `RD_RAM_STACK;
        Memrd=1'b1;
        is_bit =1'b0;
        addr_ram = sp_out;
        
    end
   end
    else if( RAMload ==1'b1 && Aload == 1'b0 && JMPload == 1'b0) begin // Read form RAM
            begin: Decode_RAM
            case(RAM_access)
                `RD_RAM_IM:begin // 
                    //src_1 = acc_data; 
                 end
                 `RD_RAM_DIRECT:begin
                    Memwr=1'b0;
                    Memrd=1'b1;
                    is_bit =1'b0;
                    addr_ram =addr1; 
                 end
                 `RD_RAM_REG:begin
                  if (psw_data[4:3] == 2'b00 )begin
                    offset = `BanK_0_offset;
                  end
                  if (psw_data[4:3]== 2'b01 )begin
                    offset = `BanK_1_offset;
                  end
                  if (psw_data[4:3] == 2'b10 )begin
                    offset = `BanK_2_offset;
                  end
                  if (psw_data[4:3] == 2'b11 )begin
                    offset = `BanK_3_offset;
                  end
                    Memwr=1'b0;
                    Memrd=1'b1;
                    is_bit =1'b0;
                    addr_ram =IR[2:0] + offset;  
                  end
                  `RD_RAM_REG_IND:begin
                    Memwr=1'b0;
                    Memrd=1'b1;
                    is_bit =1'b0; 
                    addr_ram =IR[0] + offset;  
                  end
                  `RD_RAM_STACK:begin
                    Memwr=1'b0;
                    Memrd=1'b1;
                    ram_sel = `RD_RAM_STACK;
                    Memrd=1'b1;
                    is_bit =1'b0;
                    addr_ram = sp_out;
                  end   
                  `WR_RAM_DIRECT:begin 
                  Memwr = 1'b1;
                  Memrd = 1'b0;
                  is_bit = 1'b0;
                  addr_ram = addr1;
                  in_data = acc_data;
                  end
                  `WR_RAM_REG_IM:begin
                  if (psw_data[4:3] == 2'b00 )begin
                    offset <= `BanK_0_offset;
                  end
                  if (psw_data[4:3] == 2'b01 )begin
                    offset <= `BanK_1_offset;
                  end
                  if (psw_data[4:3] == 2'b10 )begin
                    offset <= `BanK_2_offset;
                  end
                  if (psw_data[4:3] == 2'b11 )begin
                    offset <= `BanK_3_offset;
                  end
                  Memwr = 1'b1;
                  Memrd = 1'b0;
                  is_bit = 1'b0;
                  in_data = addr1;
                  addr_ram = IR[2:0] +offset;
                  end
                 `WR_RAM_REG:begin // mov r,A
                  if (psw_data[4:3] == 2'b00 )begin
                    offset = `BanK_0_offset;
                  end
                  if (psw_data[4:3] == 2'b01 )begin
                    offset = `BanK_1_offset;
                  end
                  if (psw_data[4:3] == 2'b10 )begin
                    offset = `BanK_2_offset;
                  end
                  if (psw_data[4:3] == 2'b11 )begin
                    offset = `BanK_3_offset;
                  end
                  Memwr = 1'b1;
                  Memrd = 1'b0;
                  is_bit = 1'b0;
                  in_data = acc_data;
                  addr_ram = IR[2:0] +offset;
                 end  
                 `WR_RAM_REG_IND:begin
                    Memwr=1'b1;
                    Memrd=1'b0;
                    is_bit =1'b0; 
                    in_data = acc_data;
                    addr_ram =IR[0] + offset;  
                  end 
                  `WR_RAM_STACK:begin
                    ram_sel = `WR_RAM_STACK;
                    Memwr =1'b1;
                    Memrd =1'b0;
                    is_bit =1'b0;
                    in_data = PC[7:0];
                    addr_ram =sp_out;
                   end
                  `WR_RAM_BIT:begin
                    Memwr =1'b1;
                    Memrd =1'b0;
                    is_bit =1'b1; 
                    if(Opcode == `SETB_B)begin
                        in_bit = 1'b1;
                    end
                    else if ( Opcode == `CLR_B)begin
                        in_bit = 1'b0;
                    end
                     else if ( Opcode == `CPL_B)begin
                        in_bit = !old_bit;
                        old_bit = in_bit;
                    end
                    addr_ram = addr1;
                  end  
                  `RD_RAM_BIT:begin // testar
                    Memwr =1'b0;
                    Memrd =1'b1;
                    is_bit =1'b1;
                    addr_ram = addr1;
                  end  
                 default:begin
                    Memwr=1'b0;
                    Memrd=1'b0;
                 end
            endcase
          end
        end
end
//----------------- ALU instructions---------------------------
always @ (posedge clock)
begin
if(ALUload== 1'b1)begin
        begin: Decode_ALU
        case(ALU_Opcode)
            `ALU_ADD:begin
             src_1 = acc_data;
                if ( RAM_access == `RD_RAM_IM)begin
                    src_2 = addr1;
                end
                else begin
                    src_2 = out_ram;
                end
             flag_set =`CY_OV_AC_SET ;
             end
             `ALU_SUBB:begin
              src_1 = acc_data;
              if ( RAM_access == `RD_RAM_IM)begin
                    src_2 = addr1;
                end
                else begin
                    src_2 = out_ram;
                end
             flag_set =`CY_OV_AC_SET ;
             end
             `ALU_ANL:begin
             src_1 = acc_data;
              if ( RAM_access == `RD_RAM_IM)begin
                    src_2 = addr1;
                end
                else begin
                    src_2 = out_ram;
                end
              flag_set =`NO_SET ;
             end
             `ALU_ORL:begin
             src_1 = acc_data;
              if ( RAM_access == `RD_RAM_IM)begin
                    src_2 = addr1;
                end
                else begin
                    src_2 = out_ram;
                end
              flag_set =`NO_SET ;
             end
             `ALU_INC:begin
              src_1 = acc_data;
              flag_set =`NO_SET ;
             end
             `ALU_DEC:begin
              src_1 = acc_data;
              flag_set =`NO_SET ;
             end
             `ALU_XRL:begin
               src_1 = acc_data;
                if ( RAM_access == `RD_RAM_IM)begin
                    src_2 = addr1;
                end
                else begin
                    src_2 = out_ram;
                end
              flag_set =`NO_SET ;
             end
             default:begin
             end
        endcase
      end
    end
end


//---------------------------------------------------


endmodule