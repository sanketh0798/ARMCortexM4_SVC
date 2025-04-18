	AREA RESET, CODE, READONLY
	ENTRY
START
	ADR R4,SRC ; Point R4 to the source data
	MOV R5,#0 ; loading value 0 to R5
	MOV R6,#1 ; Loadig value 1 to R6
	MOV R0,#0 ; Initialize count of 0's
	MOV R1,#0 ; Initialize count of 1's
	MOV R2,#5 ; Loop counter, to count 5 digits
	BL SUB1 ; Branch to subroutine SUB1
STOP B STOP 

SUB1 LDR R3,[R4],#4 ; Load first value from SRC into R0, increment R4 by 4 i.e., next byte
	CMP R3,R5 ; Compare R3 and R5
	BEQ FB1 ; Branch to FB1 if R3 == R5
	CMP R3,R6 ; Compare R3 and R6
	BEQ FB2 ; Branch to FB2 if R3 == R6
	SUBS R2, R2, #1 ; Decrement loop counter
    BNE SUB1
	B AFT
FB1 ADD R0, #1
	SUBS R2, R2, #1
    BNE SUB1
	B AFT
FB2 ADD R1, #1
	SUBS R2, R2, #1
    BNE SUB1
	B AFT
AFT MOV PC,LR  ; Return from subroutine, LINE 6
SRC DCD 0, 1, 6, 0, 3
	AREA RESULT, DATA, READWRITE
END