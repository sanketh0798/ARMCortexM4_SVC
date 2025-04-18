	AREA RESET, CODE, READONLY
	ENTRY
;START	
; Vector table
    DCD 0x20001000   ; Stack pointer initial value
    DCD Reset_Handler+1 ; Reset handler
    DCD NMI_Handler+1    ; NMI handler
    DCD HardFault_Handler+1  ; Hard fault handler
    DCD 0             ; Reserved
    DCD 0             ; Reserved
    DCD 0             ; Reserved
    DCD 0             ; Reserved
    DCD SVC_Handler+1    ; SVC handler
    
Reset_Handler   
	 
    LDR R0, =0x2
    MOV SP, R0 ; Initialize stack pointers again since error was comming
	
	MOV R0, #1 ; Initialize stack pointers if needed
    MSR CONTROL, R0   ; Switch to unprivileged mode

	; Load parameters into registers
    LDR R0, =1603      ; Parameter 1
    LDR R1, =1603      ; Parameter 2
	
    ; Call SVC with number derived from 01603
    SVC #3  ; Assuming last 3 digits of 01603. Reason behind the condition in Q3.1 is 
	;because immediate value 0x0000025B (603 in decimal) is out of range for the SVC 
	;instruction, which only permits values in the range 0x00 to 0xFF (0 to 255 in decimal)
STOP B STOP

; NMI handler (example)
NMI_Handler
    B NMI_Handler  ; Loop indefinitely

; Hard fault handler (example)
HardFault_Handler
    B HardFault_Handler  ; Loop indefinitely


SVC_Handler
    ; Determine which stack was used
    TST LR, #4 ;Test bit 2 of EXC_RETURN
    ITE EQ ;if bit is active. If EQ condition is true, use MSP; otherwise, use PSP
    MRSEQ R0, MSP ;Moves the value of the MSP into R0 if the condition is true (EQ)
    MRSNE R0, PSP ;Moves the value of the PSP into R0 if the condition is false (NE)

    LDR R1, [R0, #24]; Get the stacked PC value. Load stacked PC into R0. the value 24 
	;is used because it corresponds to the offset in the stack frame where the Program 
	;Counter (PC) value is stored during exception handling
    
    LDRB R2, [R1, #-2]; Get the SVC number from the instruction. ; Load SVC number into R1

    ; Extract parameters from the stack
    LDR R2, [R0]  ; First parameter
    LDR R3, [R0, #4]  ; Second parameter

    ; Check if SVC number matches 603
    CMP R2, #3
    BEQ ADDITION
    B SUBTRACTION

ADDITION
    ADD R2, R2, R3 ; R2 = R2 + R3
    STR R2, [R0, #0]   ; Save result to stack
    B RETURN

SUBTRACTION
    SUB R2, R2, R3     ; R2 = R2 - R3
    STR R2, [R0, #0]   ; Save result to stack
    
RETURN
    ; Restore registers and return
    MOV PC, LR

	AREA RESULT, DATA, READWRITE
	END
