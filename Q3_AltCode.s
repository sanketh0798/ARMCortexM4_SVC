    AREA RESET, CODE, READONLY         ; Define a read-only code section for the reset vector
    ENTRY                             ; Set the entry point of the program

START
    ; Set up the application task in Thread unprivileged mode
    ; The main thread runs here before the SVC is triggered.

    ; Simulate an SVC call (with the appropriate SVC number)
    ; We choose the SVC number dynamically based on the last 3 digits of 1603 (i.e., SVC #603)
    ; Pass two parameters (the last 5 digits of 1603 are 603, hence parameters will be 00603 and 00603)
    MOV     R0, #603                 ; First parameter (last 5 digits of 1603)
    MOV     R1, #603                 ; Second parameter (last 5 digits of 1603)
    SVC     #603                     ; Trigger the SVC with SVC number 603

    ; Return to application task after handling the exception
    B       .                         ; Infinite loop to stop the program from exiting

    ; SVC exception handler
    AREA    SVC_HANDLER, CODE, READONLY  ; Define a section for the SVC handler
SVC_Handler
    MRS     R12, PSP                 ; Get the current stack pointer (PSP)
    TST     R12, #4                  ; Check the Stack Alignment
    MOVEQ   R12, SP                  ; If the stack is not aligned, use the MSP (main stack pointer)
    MSR     PSP, R12                 ; Set the PSP back to SVC mode

    ; Save context (since we're in exception mode, we need to preserve the registers)
    PUSH    {R0-R12, LR}             ; Save registers before handling SVC

    ; Extract the SVC number from the instruction
    LDR     R0, =0xE000ED08          ; Address of the interrupt control register (VECTACTIVE)
    LDR     R1, [R0]                 ; Read the current value
    LSR     R1, R1, #16              ; Shift to get the SVC number from the opcode

    ; Check if the SVC number matches 603
    CMP     R1, #603                 ; Compare SVC number with 603
    BEQ     SVC_Add                  ; If they match, go to addition handler

    ; If SVC number doesn't match, do subtraction
SVC_Sub:
    SUB     R0, R0, R1               ; Perform subtraction of parameters
    B       SVC_Exit                 ; Exit the handler

SVC_Add:
    ADD     R0, R0, R1               ; Perform addition of parameters

SVC_Exit:
    ; Restore context and return from exception
    POP     {R0-R12, PC}             ; Restore registers and return to the application task

    ; Define a weak handler for SVC if no other handler is provided
    AREA    RESET, CODE, READONLY      ; Ensure that the RESET area is available
    .weak   SVC_Handler
    .type   SVC_Handler, %function
