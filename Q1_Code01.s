	AREA RESET, CODE, READONLY
	ENTRY
START
	ADR R4,SRC
	LDR R5,=DST
	BL SUB1 ; Branch to subroutine SUB1
STOP B STOP ; while(1)
SUB1 LDR R0,[R4],#4 ; Load first value from SRC into R0, increment R4 by 4 i.e., next byte
	LDR R1,[R4],#4 ; Load second value from SRC into R1, increment R4 
	CMP R0,R1  ; Compare R0 and R1
	BGE FB1  ; Branch to FB1 if R0 >= R1
	LDR R0,[R4],#4 ; Load third value from SRC into R0, increment R4 by 4
	LDR R1,[R4],#4 ; Load fourth value from SRC into R1, increment R4 by 4
	ADD R0,R0,R1
	MOV R2,#5
	STR R2,[R5],#4 ; Store R2 at DST, increment R5 by 4
	STR R0,[R5]  ; Store R0 at DST (overwriting previous value)
	B AFT
FB1 LDR R0,[R4],#4 ; Load third value from SRC into R0, increment R4, bcs before BGE 2nd value was loaded 
	LDR R1,[R4] ; Load fourth value from SRC into R1 
	SUB R0,R0,R1 ; Subtract R1 from R0, stores at R0
	STR R0,[R5,#4] ; Store R0 at DST + 4
AFT MOV PC,LR  ; Return from subroutine, LINE 6
SRC DCD 0x40, 0x40, 0x30, 0x10
	AREA RESULT, DATA, READWRITE
DST DCD 0, 0
END