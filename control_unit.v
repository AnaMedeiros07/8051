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


module control_unit(
        input clock,
        input reset,
        input [7:0] Opcode,
        output Fetch,
        output Decode
        
    );

//================States=========================
parameter s_start  = 3'b000, s_int =3'b001,s_fetch = 3'b010,
     s_decode = 3'b011, s_execute =3'b100;
//=============Internal Variables======================
reg   [2:0]          state        ;// Seq part of the FSM

//====== Check the type of Operations===========


always @ (posedge clock)
begin : FSM
	if (reset == 1'b1) begin // reset
		state <=  s_start;   
	end 
	else begin
		case(state)
			s_start :
				state <= s_int;
			s_int :
			     state <= s_fetch;
			s_fetch :
				state <= s_decode;
			s_decode : 
			   state <= s_execute;
			s_execute:
			     state<=s_fetch;
			default : state <= s_start;
		endcase
	end	
end
endmodule