//
// instruction set
//-------SFR Addresses
// sfr addresses
//
`define SFR_ACC 8'he0 //accumulator
`define SFR_B 8'hf0 //b register
`define SFR_PSW 8'hd0 //program status word
`define SFR_P0 8'h80 //port 0
`define SFR_P1 8'h90 //port 1
`define SFR_P2 8'ha0 //port 2
`define SFR_P3 8'hb0 //port 3
`define SFR_DPTR_LO 8'h82 // data pointer high bits
`define SFR_DPTR_HI 8'h83 // data pointer low bits
`define SFR_IP0 8'hb8 // interrupt priority
`define SFR_IEN0 8'ha8 // interrupt enable 0
`define SFR_TMOD 8'h89 // timer/counter mode
`define SFR_TCON 8'h88 // timer/counter control
`define SFR_TH0 8'h8c // timer/counter 0 high bits
`define SFR_TL0 8'h8a // timer/counter 0 low bits
`define SFR_TH1 8'h8d // timer/counter 1 high bits
`define SFR_TL1 8'h8b // timer/counter 1 low bits

`define SFR_SCON 8'h98 // serial control 0
`define SFR_SBUF 8'h99 // serial data buffer 0
`define SFR_SADDR 8'ha9 // serila address register 0
`define SFR_SADEN 8'hb9 // serila address enable 0

`define SFR_PCON 8'h87 // power control
`define SFR_SP 8'h81 // stack pointer


`define SFR_IE 8'ha8 // interrupt enable
`define SFR_IP 8'hb7 // interrupt priority

`define SFR_RCAP2H 8'hcb // timer 2 capture high
`define SFR_RCAP2L 8'hca // timer 2 capture low

`define SFR_T2CON 8'hc8 // timer 2 control register
`define SFR_TH2 8'hcd // timer 2 high
`define SFR_TL2 8'hcc // timer 2 low

// ----- SFR bit addressable ----------

`define SFR_B_ACC 5'b11100 //accumulator
`define SFR_B_PSW 5'b11010 //program status word
`define SFR_B_P0  5'b10000 //port 0
`define SFR_B_P1  5'b10010 //port 1
`define SFR_B_P2  5'b10100 //port 2
`define SFR_B_P3  5'b10110 //port 3
`define SFR_B_B   5'b11110 // b register
`define SFR_B_IP  5'b10111 // interrupt priority control 0
`define SFR_B_IE  5'b10101 // interrupt enable control 0
`define SFR_B_SCON 5'b10011 // serial control
`define SFR_B_TCON  5'b10001 // timer/counter control
`define SFR_B_T2CON 5'b11001 // timer/counter2 control

//---------PSW_aux-----------
`define NO_SET          2'b00
`define CY_SET          2'b01
`define CY_OV_SET       2'b10
`define CY_OV_AC_SET    2'b11

//----------Bank------------
`define BanK_3_offset 8'b10001111 // 1fh
`define BanK_2_offset 8'b00100111 //17h
`define BanK_1_offset 8'b00000111 //07h
`define BanK_0_offset 8'b00000000 //0h

// - Define codes for ALU

`define ALU_NOP     5'b00000
`define ALU_INC     5'b00001
`define ALU_DEC     5'b00010
`define ALU_ADD     5'b00011
`define ALU_ADDC    5'b00100
`define ALU_SUBB    5'b00101
`define ALU_MUL     5'b00110
`define ALU_DIV     5'b00111
`define ALU_RR      5'b01000
`define ALU_RRC     5'b01001
`define ALU_RL      5'b01010
`define ALU_RLC     5'b01011
`define ALU_CPL     5'b01100
`define ALU_DA      5'b01101
`define ALU_SWAP    5'b01110
`define ALU_ORL     5'b01111
`define ALU_XRL     5'b10000
`define ALU_ANL     5'b10001

//op_code [4:0]
`define ACALL 	8'bxxx10001 // absolute call
`define AJMP 	8'bxxx00001 // absolute jump

//op_code [7:3]
`define INC_R 	8'b0000_1xxx // increment Rn
`define DEC_R 	8'b0001_1xxx // decrement reg Rn=Rn-1
`define ADD_R 	8'b00101xxx // ADD A,R0 A=A+Rn
`define ADDC_R 	8'b00111xxx // ADD A,Rn A=A+Rx+c
`define ORL_R 	8'b0100_1xxx // or A=A or Rn
`define ANL_R 	8'b0101_1xxx // ANL A, Rn and A=A^Rx
`define XRL_R 	8'b0110_1xxx // XOR A=A XOR Rn
`define MOV_CR 	8'b0111_1xxx // move Rn=constant
`define MOV_RD 	8'b1000_1xxx // move (direct)=Rn
`define SUBB_R 	8'b10011xxx // SUBB A,Rn A=A-c-Rn
`define MOV_DR 	8'b1010_1xxx // move Rn=(direct)
`define CJNE_R 	8'b1011_1xxx // compare and jump if not equal; Rx<>constant
`define XCH_R 	8'b1100_1xxx // exchange A<->Rn
`define DJNZ_R 	8'b1101_1xxx // decrement and jump if not zero
`define MOV_R 	8'b1110_1xxx // move A=Rn
`define MOV_AR 	8'b1111_1xxx // move Rn=A

//op_code [7:1]
`define ADD_I 	8'b0010011x // ADD A,@Ri A= A+ Ri
`define ADDC_I 	8'b0011011x // ADDC A,@Ri A=A+Ri+c
`define ANL_I 	8'b0101011x //  ANL A,@R0 and A=A^@Ri
`define CJNE_I 	8'b1011_011x // compare and jump if not equal; @Ri<>constant
`define DEC_I 	8'b0001_011x // decrement indirect @Ri=@Ri-1
`define INC_I 	8'b0000_011x // increment @Ri
`define MOV_I 	8'b1110_011x // move A=@Ri
`define MOV_ID 	8'b1000_011x // move (direct)=@Ri
`define MOV_AI 	8'b1111_011x // move @Ri=A
`define MOV_DI 	8'b1010_011x // move @Ri=(direct)
`define MOV_CI 	8'b0111_011x // move @Ri=constant
`define MOVX_IA 8'b1110_001x // move A=(@Ri)
`define MOVX_AI 8'b1111_001x // move (@Ri)=A
`define ORL_I 	8'b0100_011x // or A=A or @Ri
`define SUBB_I 	8'b1001_011x // SUBB A,@Ri A=A-c-@Ri
`define XCH_I 	8'b1100_011x // exchange A<->@Ri
`define XCHD 	8'b1101_011x // exchange digit A<->Ri
`define XRL_I 	8'b0110_011x // XOR A=A XOR @Ri

//op_code [7:0]
`define ADD_D 	8'b00100101 // ADD A,direct A= A+direct
`define ADD_C 	8'b00100100 // ADD A,#immediate A=A+immediate
`define ADDC_D 	8'b00110101 // ADDC A,direct A=A+(direct)+c
`define ADDC_C 	8'b00110100 // ADDC A,#immediate  A=A+immediate+c
`define ANL_D 	8'b01010101 // ANL A, direct and A=A^(direct)
`define ANL_C 	8'b01010100 // ANL A, immediate and A=A^constant
`define ANL_AD 	8'b01010010 // ANL direct, A and (direct)=(direct)^A
`define ANL_DC 	8'b01010011 // ANL direct, #immediate and (direct)=(direct)^constant
`define ANL_B 	8'b10000010 // ANL C, bit and c=c^bit
`define ANL_NB 	8'b10110000 // ANL C, /bit and c=c^!bit
`define CJNE_D 	8'b1011_0101 // compare and jump if not equal; a<>(direct)
`define CJNE_C 	8'b1011_0100 // compare and jump if not equal; a<>constant
`define CLR_A 	8'b1110_0100 // clear accumulator
`define CLR_C 	8'b1100_0011 // clear carry
`define CLR_B 	8'b1100_0010 // clear bit
`define CPL_A 	8'b1111_0100 // complement accumulator
`define CPL_C 	8'b1011_0011 // complement carry
`define CPL_B 	8'b1011_0010 // complement bit
`define DA 	    8'b11010100 // decimal adjust (A)
`define DEC_A 	8'b0001_0100 // decrement accumulator a=a-1
`define DEC_D 	8'b0001_0101 // decrement direct (direct)=(direct)-1
`define DIV 	8'b1000_0100 // divide
`define DJNZ_D 	8'b1101_0101 // decrement and jump if not zero (direct)
`define INC_A 	8'b0000_0100 // increment accumulator
`define INC_D 	8'b0000_0101 // increment (direct)
`define INC_DP 	8'b1010_0011 // increment data pointer
`define JB 		8'b0010_0000 // jump if bit set
`define JBC	 	8'b0001_0000 // jump if bit set and clear bit
`define JC 		8'b0100_0000 // jump if carry is set
`define JMP_D 	8'b0111_0011 // jump indirect
`define JNB 	8'b0011_0000 // jump if bit not set
`define JNC 	8'b0101_0000 // jump if carry not set
`define JNZ 	8'b0111_0000 // jump if accumulator not zero
`define JZ 		8'b0110_0000 // jump if accumulator zero
`define LCALL 	8'b0001_0010 // long call
`define LCALL 	8'b0001_0010 // long call
`define LJMP 	8'b0000_0010 // long jump
`define MOV_D 	8'b1110_0101 // move A=(direct)
`define MOV_C 	8'b0111_0100 // move A=constant
`define MOV_AD 	8'b1111_0101 // move (direct)=A
`define MOV_DD 	8'b1000_0101 // move (direct)=(direct)
`define MOV_CD 	8'b0111_0101 // move (direct)=constant
`define MOV_BC 	8'b1010_0010 // move c=bit
`define MOV_CB 	8'b1001_0010 // move bit=c
`define MOV_DP 	8'b1001_0000 // move dptr=constant(16 bit)
`define MOVC_DP 8'b1001_0011 // move A=dptr+A
`define MOVC_PC 8'b1000_0011 // move A=pc+A
`define MOVX_PA 8'b1110_0000 // move A=(dptr)
`define MOVX_AP 8'b1111_0000 // move (dptr)=A
`define MUL 	8'b1010_0100 // multiply a*b
`define NOP 	8'b0000_0000 // no operation
`define ORL_D 	8'b0100_0101 // or A=A or (direct)
`define ORL_C 	8'b0100_0100 // or A=A or constant
`define ORL_AD 	8'b0100_0010 // or (direct)=(direct) or A
`define ORL_CD 	8'b0100_0011 // or (direct)=(direct) or constant
`define ORL_B 	8'b0111_0010 // or c = c or bit
`define ORL_NB 	8'b1010_0000 // or c = c or !bit
`define POP 	8'b1101_0000 // stack pop
`define PUSH 	8'b1100_0000 // stack push
`define RET 	8'b0010_0010 // return from subrutine
`define RETI 	8'b0011_0010 // return from interrupt
`define RL 	    8'b00100011 // rotate left
`define RLC 	8'b00110011 // rotate left thrugh carry
`define RR 	    8'b00000011 // rotate right
`define RRC 	8'b0001_0011 // rotate right thrugh carry
`define SETB_C 	8'b1101_0011 // set carry
`define SETB_B 	8'b1101_0010 // set bit
`define SJMP 	8'b1000_0000 // short jump
`define SUBB_D 	8'b10010101 // SUBB A,direct A=A-c-(direct)
`define SUBB_C 	8'b10010100 // SUBB A, #immediate A=A-c-constant
`define SWAP 	8'b1100_0100 // swap A(0-3) <-> A(4-7)
`define XCH_D 	8'b1100_0101 // exchange A<->(direct)
`define XRL_D 	8'b0110_0101 // XOR A=A XOR (direct)
`define XRL_C 	8'b0110_0100 // XOR A=A XOR constant
`define XRL_AD 	8'b0110_0010 // XOR (direct)=(direct) XOR A
`define XRL_CD 	8'b0110_0011 // XOR (direct)=(direct) XOR constant
