	AREA RESET, CODE, READONLY
	ENTRY
START
	ADR R4,SRC
	LDR R5,=DST
	BL SUB1
STOP B STOP
SUB1 LDR R0,[R4],#4
	LDR R1,[R4],#4
	CMP R0,R1
	LDR R0,[R4],#4
	LDR R1,[R4]
	MOVLT R2,#5
	STRLT R2,[R5]
	ADDLT R0, R0, R1
	SUBGE R0, R0, R1
	STR R0,[R5,#4]
AFT MOV PC,LR
SRC DCD 0x40, 0x40, 0x30, 0x10
	AREA RESULT, DATA, READWRITE
DST DCD 0, 0
END
