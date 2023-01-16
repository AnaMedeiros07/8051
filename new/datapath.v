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
        input wire [4:0] ALU_Opcode,
        input IRload,
        input PCload,
        input Decodeload,
        input RAMload,
        input JMPload,
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
reg Memrd,Memwr,in_bit,is_bit,indirect_flag;
reg [7:0] addr_ram;
reg [7:0] in_data;

//Outputs
wire [7:0] out_ram;
wire out_bit;

//===ROM===
reg [9:0]addr_rom;

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
  wire [7:0] sp_w;
 // === Aux_Variables===
 reg [1:0] Bank;
 reg [7:0] offset;
 reg [7:0] addr1;
 reg [7:0] addr2; 
 reg old_bit;
 wire int_en;
 reg int_request;
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
        .acc_in(acc_data),
        .write_en(Memwr),
        .write_bit_en(is_bit),
        .addr(addr_ram),
        .flag_set(flag_set),
        .psw_data(psw_data) 
        );
//---------------------------------------------------------------------------------------
//---------------------------intanciate DPTR--------------------------------------------
dptr dptr_module(
        .clock(clock),
        .reset(reset),
        .wr_bit(is_bit),
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
     .bit_in(in_bit),
     .b_data(b_data)
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
//-----------------------------instanciate tmod---------------------------------
//-------------------------------------------------------------------------------
tmod tmod_module(
     .clock(clock),
     .reset(reset),
     .data_in(in_data),
     .addr(addr_ram),
     .wr_en(Memwr),
     .wr_bit_en(is_bit),
     .bit_in(in_bit),
     .tmod_data(tmod_data)
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
//-----------------------------instanciate th0---------------------------------
//-------------------------------------------------------------------------------
th0 th0_module(
     .clock(clock),
     .reset(reset),
     .data_in(in_data),
     .addr(addr_ram),
     .wr_en(Memwr),
     .wr_bit_en(is_bit),
     .bit_in(in_bit),
     .th0_data(th0_data)
    );
//-----------------------------instanciate tl0---------------------------------
//-------------------------------------------------------------------------------
tl0 tl0_module(
     .clock(clock),
     .reset(reset),
     .data_in(in_data),
     .addr(addr_ram),
     .wr_en(Memwr),
     .wr_bit_en(is_bit),
     .bit_in(in_bit),
     .tl0_data(tl0_data)
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
port #(.SFR_ADDR(`SFR_P2), .SFR_B_ADDR(`SFR_B_P2)) port2(
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
    Memwr = 1'b0;
    Memrd = 1'b0;
    in_bit = 1'b0;
    is_bit =1'b0;
    indirect_flag = 1'b0;
    ram_sel = 8'h00;
    old_bit = 1'b0;
    int_request= 1'b0;
    int_pend = 1'b0;
end
    // --------------Reset --------------------------
always @ (posedge reset)
begin 
    addr_rom = 8'h00;
    addr_ram= 8'h00;
    PC = 16'h0000;

end

assign int_en = (JMPload == 1'b0 && RAMload == 1'b0 && Decodeload == 1'b0 && Aload == 1'b0) ? 1'b1:1'b0; // check if is happing an intruction


always @ (clock)
begin
    if((tf0 == 1'b1 || int_pend==1'b1) && int_en) begin
        int_request = 1'b1;
        int_pend = 1'b0;
    end
    else if (tf0 == 1'b1) begin
        int_pend = 1'b1;
    end
    
end
//-------------------For Fetch1 and Fetch2-----------------------
always @ (posedge clock)
begin 
    if (int_request == 1'b0) begin
        if(PCload == 1'b1 && IRload == 1'b1 && NotRload == 1'b1) begin // 2 fetch
           addr1= out_rom;
            PC = PC + 1;
       end
       else if(PCload == 1'b1 && IRload ==1'b1 ) begin // 1 fetch
            IR= out_rom;
            PC = PC + 1;
       end
    end
    else begin
       if(PCload == 1'b1 && IRload == 1'b1 && NotRload == 1'b1) begin // 2 fetch
           addr1 = 8'b00001011;  // timer 0 interrupt vetor 0b
           int_request = 1'b0;
       end
       else if(PCload == 1'b1 && IRload ==1'b1 ) begin // 1 fetch
            IR = 8'b00010001;
       end        
    end
  
end
 //-----------------Assign the opcode -----------------------------
assign Opcode = IR[7:0];


//----------------Decode RAM------------------      
always @ (posedge clock)
begin 
if( RAMload ==1'b1) begin
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
                addr_ram =IR[2:0] + offset;  
              end
              `RD_RAM_REG_IND:begin
                src_1 = acc_data;
                Memwr=1'b0;
                Memrd=1'b1;
                indirect_flag=1'b1;
                is_bit =1'b0;
                addr_ram =IR[0] + offset;  
              end
              `RD_RAM_STACK:begin
                Memwr=1'b0;
                Memrd=1'b1;
                ram_sel = `RD_RAM_STACK;
                Memrd=1'b1;
                indirect_flag=1'b0;
                is_bit =1'b0;
                if ( sp_out == 8'h09)begin
                    addr_ram = sp_out-1;
                end
                else begin
                     addr_ram = sp_out;
                end
              end   
              `WR_RAM_DIRECT:begin 
              Memwr = 1'b1;
              Memrd = 1'b0;
              indirect_flag = 1'b0;
              is_bit = 1'b0;
              addr_ram = addr1;
              in_data = acc_data;
              end
              `WR_RAM_REG_IM:begin
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
              in_data = addr1;
              addr_ram = IR[2:0] +offset;
              end
             `WR_RAM_REG:begin // mov r,A
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
              `WR_RAM_STACK:begin
                ram_sel = `WR_RAM_STACK;
                Memwr =1'b1;
                Memrd =1'b0;
                indirect_flag =1'b0;
                is_bit =1'b0;
                in_data = PC[7:0];
                addr_ram = sp_out;
              end
              `WR_RAM_BIT:begin
                Memwr =1'b1;
                Memrd =1'b0;
                indirect_flag =1'b0;
                is_bit =1'b1;
                if(Opcode == `SETB_B)begin
                    in_bit = 1'b1;
                end
                else if ( Opcode == `CLR_B)begin
                    in_bit = 1'b0;
                end
                else begin
                    in_bit = !old_bit;
                    old_bit = in_bit;
                end
                addr_ram = addr1;
              end  
              `RD_RAM_BIT:begin // testar
                Memwr =1'b0;
                Memrd =1'b1;
                indirect_flag =1'b0;
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
always @ (posedge clock)
begin
if(Decodeload== 1'b1)begin
        begin: Decode_ALU
        case(ALU_Opcode)
            `ALU_ADD:begin
                if ( RAM_access == `RD_RAM_IM)begin
                    src_2 = addr1;
                end
                else begin
                    src_2 = out_ram;
                end
             flag_set =`CY_OV_AC_SET ;
             alu_code = `ALU_ADD;
             end
             `ALU_SUBB:begin
              if ( RAM_access == `RD_RAM_IM)begin
                    src_2 <= addr1;
                end
                else begin
                    src_2 <= out_ram;
                end
             flag_set <=`CY_OV_AC_SET ;
              alu_code <= `ALU_SUBB;
             end
             `ALU_ANL:begin
              if ( RAM_access == `RD_RAM_IM)begin
                    src_2 <= addr1;
                end
                else begin
                    src_2 <= out_ram;
                end
              flag_set <=`NO_SET ;
               alu_code <= `ALU_ANL;
             end
             `ALU_ORL:begin
              if ( RAM_access == `RD_RAM_IM)begin
                    src_2 <= addr1;
                end
                else begin
                    src_2 <= out_ram;
                end
              flag_set <=`NO_SET ;
               alu_code <= `ALU_ORL;
             end
             `ALU_INC:begin
              flag_set <=`NO_SET ;
               alu_code <= `ALU_INC;
             end
             `ALU_DEC:begin
              flag_set <=`NO_SET ;
               alu_code <= `ALU_DEC;
             end
             default:begin
             end
        endcase
      end
      if(Opcode[4:0]== `ACALL) begin
        ram_sel = `WR_RAM_STACK;
        Memwr =1'b1;
        Memrd =1'b0;
        indirect_flag =1'b0;
        is_bit =1'b0;
        in_data = PC[15:8];
        addr_ram = sp_out;
    end
    if(Opcode == `RETI) begin
        PC[15:8] = out_ram;
        Memwr=1'b0;
        ram_sel = `RD_RAM_STACK;
        Memrd=1'b1;
        indirect_flag=1'b0;
        is_bit =1'b0;
         if ( sp_out == 8'h08)begin
            addr_ram = sp_out-1;
        end
        else begin
             addr_ram = sp_out;
        end
    end
    end
end
always @ (posedge clock)
begin
if(Aload == 1'b1) begin
     if ( ALU_Opcode != 5'h00) begin
          in_data = des_1; 
          Memwr = 1'b1;
          indirect_flag = 1'b0;
          addr_ram = `SFR_ACC;
          is_bit = 1'b0;
          alu_code = 5'h00;
      end
     else if ( Opcode == `MOV_D || Opcode == `MOV_C || Opcode[7:3] == `MOV_R || Opcode == `MOV_I) begin
        if(RAM_access == `RD_RAM_IM) begin
            in_data =addr1;
        end
        else begin
            in_data = out_ram;
        end
        Memwr = 1'b1;
        indirect_flag = 1'b0;
        addr_ram =`SFR_ACC;
        is_bit = 1'b0;
        alu_code = 5'h00;

  end
  end
    
end

always @ (posedge clock)
begin
   if(JMPload == 1'b1)begin
            begin : FindJMP1
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
                 `RETI:begin
                    PC[7:0] <= out_ram;
                    addr_ram = `SFR_SP;
                    Memwr = 1'b1;
                    Memrd = 1'b0;
                    indirect_flag = 1'b0;
                    in_data = sp_out;
                    is_bit = 1'b0;        
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
                 `ACALL : begin
                    addr_ram = `SFR_SP;
                    Memwr = 1'b1;
                    Memrd = 1'b0;
                    indirect_flag = 1'b0;
                    in_data = sp_out;
                    is_bit = 1'b0;
                    ram_sel = `WR_RAM_STACK;
                    PC[10:0] = { IR[7:5],addr1};
                 end
            default:begin
            end
            endcase  
        end
    end
   
    
end

endmodule