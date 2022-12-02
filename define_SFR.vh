
// SFR's address

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