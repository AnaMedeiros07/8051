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
        output NotRload, // to indicate if in a operation with a register
        output MOVload,
        output reg [3:0] RAM_access,
        output reg [3:0] ALU_Opcode
        
    );

//================States=========================
parameter s_start  = 3'b000, s_fetch1 =3'b001,s_wait1 = 3'b010,
     s_fetch2 = 3'b011, s_wait2= 3'b100,s_decode =3'b101,s_execute = 3'b110;
//=============Internal Variables======================
reg   [2:0]          state        ;// Seq part of the FSM
reg [1:0] cycles;
//====== Check the type of Operations===========
assign IRload = (state == s_fetch1 || state == s_fetch2) 	? 1'b1:1'b0;

assign PCload = (state == s_fetch1 || state == s_fetch2)  	? 1'b1:1'b0;

assign NotRload = ( state == s_fetch2)                         ? 1'b1:1'b0;

assign Aload = ( state == s_execute)                         ? 1'b1:1'b0;

assign JMPload = ( (Opcode ==`JZ || Opcode ==`JNZ || Opcode ==`JNC ||
                 Opcode[4:0] == `ACALL ||  Opcode[4:0] == `AJMP) && state == s_decode) ? 1'b1:1'b0;

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
			          state <= s_decode;
			         end
                    `MOV_AI :begin // Mov @Ri,A
                     RAM_access = `WR_RAM_REG_IND;
			         state <= s_decode;
			         end
			         default:begin
			         state <= s_fetch2;
			         end
                 endcase
             end
			
			begin: Decoder2
			     case (Opcode[7:3])
			     `MOV_R:begin // mov A = Rn
			      RAM_access = `RD_RAM_REG;
			      state <= s_decode;
			     end
			     `MOV_AR: begin  // mov Rn=A
			       RAM_access = `WR_RAM_REG; 
			       state <= s_decode;
			     end
			     `ADD_R:begin
			       ALU_Opcode = `ALU_ADD;
			      RAM_access = `RD_RAM_REG;
			      state <= s_decode;
			     end
			     `SUBB_R:begin
			       ALU_Opcode = `ALU_SUBB;
			      RAM_access = `RD_RAM_REG;
			      state <= s_decode;
			     end
			     `ANL_R:begin
			      ALU_Opcode = `ALU_ANL;
			     RAM_access = `RD_RAM_REG;
			     state <= s_decode;
			     end
			     `ORL_R:begin
			      ALU_Opcode = `ALU_ORL;
			     RAM_access = `RD_RAM_REG;
			     state <= s_decode;
			     end
			     `XRL_R:begin
			      ALU_Opcode = `ALU_XRL;
			     RAM_access = `RD_RAM_REG;
			     state <= s_decode;
			     end
			     default:begin
			     state <= s_fetch2;
			     end
			     endcase
			  end 
			end
			s_fetch2 : 
			   state <= s_wait2;
			s_wait2: begin
			begin :Decoder3
			     case (Opcode)
			     //--------Arithemetric and logical instructions-------------
			        `ADD_C:begin
			             ALU_Opcode = `ALU_ADD;
			             RAM_access = `RD_RAM_IM;
			         end
			        `ADD_D:begin
			             ALU_Opcode = `ALU_ADD;
			             RAM_access = `RD_RAM_DIRECT;
			         end
			         `SUBB_C:begin
			             ALU_Opcode = `ALU_SUBB;
			             RAM_access = `RD_RAM_IM;
			         end
			        `SUBB_D:begin
			             ALU_Opcode = `ALU_SUBB;
			             RAM_access = `RD_RAM_DIRECT;
			         end
			         `ANL_C:begin
			             ALU_Opcode = `ALU_ANL;
			             RAM_access = `RD_RAM_IM;
			         end
			        `ANL_D:begin
			             ALU_Opcode = `ALU_ANL;
			             RAM_access = `RD_RAM_DIRECT;
			         end
			        `ORL_C:begin
			             ALU_Opcode = `ALU_ORL;
			             RAM_access = `RD_RAM_IM;
			         end
			        `ORL_D:begin
			             ALU_Opcode = `ALU_ORL;
			             RAM_access = `RD_RAM_DIRECT;
			         end
			         `DEC_A:begin
			             ALU_Opcode = `ALU_DEC;
			             RAM_access = `RD_RAM_DIRECT;
			         end
			         `INC_A : begin
			             ALU_Opcode = `ALU_INC;
			             RAM_access = `RD_RAM_DIRECT;
			         end
			     //-------------------Transfer------------------------------
			         `MOV_D:begin
			          RAM_access = `RD_RAM_DIRECT;
			          end
			         `MOV_C:begin
			          RAM_access = `RD_RAM_IM;
			          end
			     default: begin
			     end
			     endcase
			  end
			   state <= s_decode;
			end
			s_decode:begin
			  state <= s_execute;         
			end 
			s_execute:begin
                 state <= s_start;
			end  
			default : state <= s_start;
		endcase
	end	

endmodule
