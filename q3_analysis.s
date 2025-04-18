	AREA  RESET, CODE, READONLY 
	EXPORT  __Vectors ;making the vector table __Vectors visible to linker
__Vectors 
	DCD 0x20001000     ;SP Address. When the processor resets, it loads the SP from this location (1st location of vector)
	DCD Reset_Handler+1
	DCD 0   ; NMI handler
    DCD 0  ; Hard fault handler
    DCD 0, 0, 0, 0, 0, 0, 0
    DCD SVC_Handler    ; SVC Handler
	
	AREA mycode,CODE,READONLY   
	ENTRY 
	EXPORT  Reset_Handler ;Makes the Reset_Handler label visible to the linker.

Reset_Handler  
	LDR R0, =0x20001000
    MOV SP, R0 		;Initialise stack
	
	MOV R0, #1 			;Initialize stack pointers if needed
    MSR CONTROL, R0   ; Switch to unprivileged mode

	; Load parameters into registers
    LDR R0, =1603      ; Parameter 1
    LDR R1, =1603      ; Parameter 2
	
    ; Call SVC with number derived from 01603
    
	SVC #3 			; Assuming last 3 digits of 01603. Reason behind the condition in Q3.1 is 
						;because immediate value 0x0000025B (603 in decimal) is out of range for the SVC 
						;instruction, which only permits values in the range 0x00 to 0xFF (0 to 255 in decimal)
STOP B STOP


SVC_Handler
    ; Determine which stack was used
    TST LR, #4 			;Test bit 2 of EXC_RETURN
    ITE EQ				;if bit is active. If EQ condition is true, use MSP; otherwise, use PSP
    MRSEQ R0, MSP      ; MSP if EQ
    MRSNE R0, PSP      ; PSP if NE

	MOV R5, R0 			;Save SP

    LDR R1, [R0, #24]	; Get the stacked PC value. Load stacked PC into R0. the value 24 
						;is used because it corresponds to the offset in the stack frame where the Program 
						;Counter (PC) value is stored during exception handling
    
    LDRB R2, [R1, #-2]	; Get the SVC number from the instruction. ; Load SVC number into R1

	; Extract parameters from the stack
    LDR R3, [R5, #0]   ; First parameter (saved R0)
    LDR R4, [R5, #4]   ; Second parameter (saved R1)

    ; Check if SVC number matches 603
    CMP R2, #3
    BEQ ADDITION
    B SUBTRACTION

ADDITION
    ADD R3, R3, R4     ; R3 = R3 + R4
    STR R3, [R5, #0]   ; Save result to stack frame's R0
    B RETURN

SUBTRACTION
    SUB R3, R3, R4     ; R3 = R3 - R4
    STR R3, [R5, #0]   ; Save result to stack frame's R0
    
RETURN
    ; Restore registers and return
    BX LR
	
	AREA RESULT, DATA, READWRITE
	END
