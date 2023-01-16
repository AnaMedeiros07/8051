//
// instruction set
//-------SFR Addresses
// SFR addresses
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

//---------SFR default values ------------------
`define RST_SP 8'h07 // stack pointer

//------------RAM address types----------------
`define RD_RAM_IM 4'b0000    // immediate
`define RD_RAM_DIRECT 4'b0001  // direct
`define RD_RAM_REG 4'b0010     //register
`define RD_RAM_REG_IND 4'b0011  // indirect memory with r0 and r1
`define RD_RAM_STACK 4'b0100      // pop and push
`define RD_RAM_BIT 4'b0101 
`define WR_RAM_IM 4'b0110    // immediate
`define WR_RAM_DIRECT 4'b0111  // direct
`define WR_RAM_REG 4'b1000     //register
`define WR_RAM_REG_IND 4'b1001  // indirect memory with r0 and r1
`define WR_RAM_STACK 4'b1010      // pop and push
`define WR_RAM_BIT 4'b1011 // instruction like acall 
`define WR_RAM_REG_IM 4'b1111
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
`define ACALL 	8'b10001 // absolute call
`define AJMP 	8'b00001 // absolute jump

//op_code [7:3]
`define INC_R 	8'b00001 // increment Rn
`define DEC_R 	8'b00011 // decrement reg Rn=Rn-1
`define ADD_R 	8'b00101 // ADD A,R0 A=A+Rn
`define ADDC_R 	8'b00111 // ADD A,Rn A=A+Rx+c
`define ORL_R 	8'b01001 // or A=A or Rn
`define ANL_R 	8'b01011 // ANL A, Rn and A=A^Rx
`define XRL_R 	8'b01101 // XOR A=A XOR Rn
`define MOV_CR 	8'b01111 // move Rn=constant
`define MOV_RD 	8'b10001 // move (direct)=Rn
`define SUBB_R 	8'b10011 // SUBB A,Rn A=A-c-Rn
`define MOV_DR 	8'b10101 // move Rn=(direct)
`define CJNE_R 	8'b10111 // compare and jump if not equal; Rx<>constant
`define XCH_R 	8'b11001 // exchange A<->Rn
`define DJNZ_R 	8'b11011 // decrement and jump if not zero
`define MOV_R 	8'b11101 // move A=Rn
`define MOV_AR 	8'b11111 // move Rn=A

//op_code [7:1]
`define ADD_I 	8'b0010011 // ADD A,@Ri A= A+ Ri
`define ADDC_I 	8'b0011011 // ADDC A,@Ri A=A+Ri+c
`define ANL_I 	8'b0101011 //  ANL A,@R0 and A=A^@Ri
`define CJNE_I 	8'b1011011 // compare and jump if not equal; @Ri<>constant
`define DEC_I 	8'b0001011 // decrement indirect @Ri=@Ri-1
`define INC_I 	8'b0000011 // increment @Ri
`define MOV_I 	8'b1110011 // move A=@Ri
`define MOV_ID 	8'b1000011 // move (direct)=@Ri
`define MOV_AI 	8'b1111011 // move @Ri=A
`define MOV_DI 	8'b1010011 // move @Ri=(direct)
`define MOV_CI 	8'b0111011 // move @Ri=constant
`define MOVX_IA 8'b1110001 // move A=(@Ri)
`define MOVX_AI 8'b1111001 // move (@Ri)=A
`define ORL_I 	8'b0100011 // or A=A or @Ri
`define SUBB_I 	8'b1001011 // SUBB A,@Ri A=A-c-@Ri
`define XCH_I 	8'b1100011 // exchange A<->@Ri
`define XCHD 	8'b1101011 // exchange digit A<->Ri
`define XRL_I 	8'b0110011 // XOR A=A XOR @Ri

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
`define CJNE_D 	8'b10110101 // compare and jump if not equal; a<>(direct)
`define CJNE_C 	8'b10110100 // compare and jump if not equal; a<>constant
`define CLR_A 	8'b11100100 // clear accumulator
`define CLR_C 	8'b11000011 // clear carry
`define CLR_B 	8'b11000010 // clear bit
`define CPL_A 	8'b11110100 // complement accumulator
`define CPL_C 	8'b10110011 // complement carry
`define CPL_B 	8'b10110010 // complement bit
`define DA 	    8'b11010100 // decimal adjust (A)
`define DEC_A 	8'b00010100 // decrement accumulator a=a-1
`define DEC_D 	8'b00010101 // decrement direct (direct)=(direct)-1
`define DIV 	8'b10000100 // divide
`define DJNZ_D 	8'b11010101 // decrement and jump if not zero (direct)
`define INC_A 	8'b00000100 // increment accumulator
`define INC_D 	8'b00000101 // increment (direct)
`define INC_DP 	8'b10100011 // increment data pointer
`define JB 		8'b00100000 // jump if bit set
`define JBC	 	8'b00010000 // jump if bit set and clear bit
`define JC 		8'b01000000 // jump if carry is set
`define JMP_D 	8'b01110011 // jump indirect
`define JNB 	8'b00110000 // jump if bit not set
`define JNC 	8'b01010000 // jump if carry not set
`define JNZ 	8'b01110000 // jump if accumulator not zero
`define JZ 		8'b01100000 // jump if accumulator zero
`define LCALL 	8'b00010010 // long call
`define LCALL 	8'b00010010 // long call
`define LJMP 	8'b00000010 // long jump
`define MOV_D 	8'b11100101 // move A=(direct)
`define MOV_C 	8'b01110100 // move A=constant
`define MOV_AD 	8'b11110101 // move (direct)=A
`define MOV_DD 	8'b10000101 // move (direct)=(direct)
`define MOV_CD 	8'b01110101 // move (direct)=constant
`define MOV_BC 	8'b10100010 // move c=bit
`define MOV_CB 	8'b10010010 // move bit=c
`define MOV_DP 	8'b10010000 // move dptr=constant(16 bit)
`define MOVC_DP 8'b10010011 // move A=dptr+A
`define MOVC_PC 8'b10000011 // move A=pc+A
`define MOVX_PA 8'b11100000 // move A=(dptr)
`define MOVX_AP 8'b11110000 // move (dptr)=A
`define MUL 	8'b10100100 // multiply a*b
`define NOP 	8'b00000000 // no operation
`define ORL_D 	8'b01000101 // or A=A or (direct)
`define ORL_C 	8'b01000100 // or A=A or constant
`define ORL_AD 	8'b01000010 // or (direct)=(direct) or A
`define ORL_CD 	8'b01000011 // or (direct)=(direct) or constant
`define ORL_B 	8'b01110010 // or c = c or bit
`define ORL_NB 	8'b10100000 // or c = c or !bit
`define POP 	8'b11010000 // stack pop
`define PUSH 	8'b11000000 // stack push
`define RET 	8'b00100010 // return from subrutine
`define RETI 	8'b00110010 // return from interrupt
`define RL 	    8'b00100011 // rotate left
`define RLC 	8'b00110011 // rotate left thrugh carry
`define RR 	    8'b00000011 // rotate right
`define RRC 	8'b00010011 // rotate right thrugh carry
`define SETB_C 	8'b11010011 // set carry
`define SETB_B 	8'b11010010 // set bit
`define SJMP 	8'b10000000 // short jump
`define SUBB_D 	8'b10010101 // SUBB A,direct A=A-c-(direct)
`define SUBB_C 	8'b10010100 // SUBB A, #immediate A=A-c-constant
`define SWAP 	8'b11000100 // swap A(0-3) <-> A(4-7)
`define XCH_D 	8'b11000101 // exchange A<->(direct)
`define XRL_D 	8'b01100101 // XOR A=A XOR (direct)
`define XRL_C 	8'b01100100 // XOR A=A XOR constant
`define XRL_AD 	8'b01100010 // XOR (direct)=(direct) XOR A
`define XRL_CD 	8'b01100011 // XOR (direct)=(direct) XOR constant
