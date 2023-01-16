`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2023 04:03:30 PM
// Design Name: 
// Module Name: control_unit
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

module control_unit(
        input clock,
        input reset,
        input [7:0] Opcode,
        output Aload,
        output IRload,
        output PCload,
        output JMPload,
        output Decodeload,
        output RAMload,
        output NotRload, // to indicate if in a operation with a register
        output reg [3:0] RAM_access,
        output reg [4:0] ALU_Opcode
        
    );
initial begin
    RAM_access = 8'h00;
    ALU_Opcode = 8'h00;
end
//================States=========================
parameter s_start  = 4'b0000, s_fetch1 =4'b0001,s_wait1 = 4'b0010,
     s_fetch2 = 4'b0011, s_wait2= 4'b0100,s_fetch3= 4'b0101,s_wait3 = 4'b0111,s_decode =4'b1000,s_execute = 4'b1001;
//=============Internal Variables======================
reg   [3:0]          state        ;// Seq part of the FSM
//====== Check the type of Operations===========
assign IRload = (state == s_fetch1 || state == s_fetch2 ) 	? 1'b1:1'b0;

assign PCload = (state == s_fetch1 || state == s_fetch2 )  	? 1'b1:1'b0;

assign NotRload = (state == s_fetch2)                       ? 1'b1:1'b0;

assign RAMload = (state == s_wait2)                         ? 1'b1:1'b0;

assign Decodeload = (state == s_decode)                     ? 1'b1:1'b0;

assign Aload = ( state == s_execute)                         ? 1'b1:1'b0;

assign JMPload = ( (Opcode ==`JZ || Opcode ==`JNZ || Opcode ==`JNC || Opcode == `RETI ||
                   Opcode [4:0] == `ACALL || Opcode[4:0] == `AJMP) && state == s_execute) ? 1'b1:1'b0;

always @ (posedge clock)
begin : FSM
		case(state)
			s_start :
				state <= s_fetch1;
			s_fetch1 :
			     state <= s_wait1;
			s_wait1:begin
			begin: Decoder1
			     case(Opcode [7:1])
                    `MOV_I: begin // Mov A, @Ri
                      RAM_access = `RD_RAM_REG_IND;
			          state <= s_wait2;
			         end
                    `MOV_AI :begin // Mov @Ri,A
                     RAM_access = `WR_RAM_REG_IND;
			         state <= s_wait2;
			         end
			         default:begin
			         end
                 endcase
             end
			
			begin: Decoder2
			     case (Opcode[7:3])
			     `MOV_R:begin // mov A = Rn
			      RAM_access = `RD_RAM_REG;
			      state <= s_wait2;
			     end
			     `MOV_CR:begin // mov Rn = immediate
			      RAM_access = `WR_RAM_REG_IM;
			      state <= s_fetch2;
			     end
			     `MOV_AR: begin  // mov Rn=A
			       RAM_access = `WR_RAM_REG; 
			       state <= s_wait2;
			     end
			     `ADD_R:begin
			       ALU_Opcode = `ALU_ADD;
			      RAM_access = `RD_RAM_REG;
			      state <= s_wait2;
			     end
			     `SUBB_R:begin
			       ALU_Opcode = `ALU_SUBB;
			      RAM_access = `RD_RAM_REG;
			      state <= s_wait2;
			     end
			     `ANL_R:begin
			      ALU_Opcode = `ALU_ANL;
			     RAM_access = `RD_RAM_REG;
			     state <= s_wait2;
			     end
			     `ORL_R:begin
			      ALU_Opcode = `ALU_ORL;
			     RAM_access = `RD_RAM_REG;
			     state <= s_wait2;
			     end
			     `XRL_R:begin
			      ALU_Opcode = `ALU_XRL;
			     RAM_access = `RD_RAM_REG;
			     state <= s_wait2;
			     end
			     default:begin
			     end
			     endcase
			  end 
			  begin: Decoder3
			     case(Opcode [4:0])
                    `ACALL: begin 
                      RAM_access = `WR_RAM_STACK;
                      state <= s_fetch2;
			         end
			         `AJMP:begin
			           state <= s_fetch2;
			         end
			         default:begin
			         end
                 endcase
             end
			begin :Decoder4
			     case (Opcode)
			     //--------Arithemetric and logical instructions-------------
			        `ADD_C:begin
			             ALU_Opcode = `ALU_ADD;
			             RAM_access = `RD_RAM_IM;
			             state <= s_fetch2;
			         end
			        `ADD_D:begin
			             ALU_Opcode = `ALU_ADD;
			             RAM_access = `RD_RAM_DIRECT;
			             state <= s_fetch2;
			         end
			         `SUBB_C:begin
			             ALU_Opcode = `ALU_SUBB;
			             RAM_access = `RD_RAM_IM;
			             state <= s_fetch2;
			         end
			        `SUBB_D:begin
			             ALU_Opcode = `ALU_SUBB;
			             RAM_access = `RD_RAM_DIRECT;
			              state <= s_fetch2;
			         end
			         `ANL_C:begin
			             ALU_Opcode = `ALU_ANL;
			             RAM_access = `RD_RAM_IM;
			              state <= s_fetch2;
			         end
			        `ANL_D:begin
			             ALU_Opcode = `ALU_ANL;
			             RAM_access = `RD_RAM_DIRECT;
			              state <= s_fetch2;
			         end
			        `ORL_C:begin
			             ALU_Opcode = `ALU_ORL;
			             RAM_access = `RD_RAM_IM;
			              state <= s_fetch2;
			         end
			        `ORL_D:begin
			             ALU_Opcode = `ALU_ORL;
			             RAM_access = `RD_RAM_DIRECT;
			              state <= s_fetch2;
			         end
			         `DEC_A:begin
			             ALU_Opcode = `ALU_DEC;
			             RAM_access = `RD_RAM_IM;
			              state <= s_wait2;
			         end
			         `INC_A : begin
			             ALU_Opcode = `ALU_INC;
			             RAM_access = `RD_RAM_IM;
			              state <= s_wait2;
			         end
			     //-------------------Transfer------------------------------
			         `MOV_D:begin
			          RAM_access = `RD_RAM_DIRECT;
			           state <= s_fetch2;
			          end
			         `MOV_C:begin
			          RAM_access = `RD_RAM_IM;
			           state <= s_fetch2;
			          end
			          `MOV_AD: begin
			          RAM_access = `WR_RAM_DIRECT;
			           state <= s_fetch2;
			          end
			          `RETI: begin
			           RAM_access = `RD_RAM_STACK;
			           state <= s_wait2;
			          end
			          `RET: begin
			           RAM_access = `RD_RAM_STACK;
			           state <= s_wait2;
			          end
			          `SETB_B: begin
			           RAM_access = `WR_RAM_BIT;
			           state <= s_fetch2;
			          end
			          `CLR_B: begin
			           RAM_access = `WR_RAM_BIT;
			           state <= s_fetch2;
			          end
			          `CPL_B: begin
			           RAM_access = `WR_RAM_BIT;
			           state <= s_fetch2;
			          end
			          `JNZ: begin
			           state <= s_fetch2;
			          end
			          `JZ: begin
			           state <= s_fetch2;
			           end
			           `JNC: begin
			           state <= s_fetch2;
			           end
			     default: begin
			     end
			     endcase
			  end
			end
			s_fetch2 : 
			   state <= s_wait2;
			s_wait2: begin
			   state <= s_fetch3;
			end
			s_fetch3 : 
			   state <= s_wait3;
			s_wait3: begin
			   state <= s_decode;
			end
			s_decode:begin
			  state <= s_execute;         
			end 
			s_execute:begin
                state <= s_start;
                RAM_access = 8'h00;
                ALU_Opcode = 8'h00;
             end
			default : state <= s_start;
		endcase
	end	

endmodule