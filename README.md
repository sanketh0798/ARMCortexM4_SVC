# ARMCortexM4_SVC
 ARM Cortex M3/4 to handle  Supervisor Call (SVC) exception

Q2:
An assembly language program for ARM7TDMI to count the number of 0's and 1's in the last 5 digits of a fixed number (number must be given in decimal number format). Store the number of 0's in register R0 and the number of 1's in register R1. Verify your result by performing manual calculation. (Consider Number either 32 bit or 16 bit)  


Q3:
The program should meet the following requirements:  
1. The SVC should be called from an application task running at Thread unprivileged mode. [SVC number must be a fixed number's either last 3 digits or last 2 digits, depending on whether it's less than (or equal to) or greater than 255 (number must be given in decimal number format)]  
2. Two parameters [each parameter is the last 5 digits of the fixed number (number must be given in decimal format)] should be passed to the SVC handler.  
3. The SVC number should be determined dynamically by examining the actual SVC instruction in memory.  
4. The SVC exception handler should set up a stack pointer in SVC mode before handling the exception.
5. 5. If the SVC number matches the fixed number  (either the last 3 digits or the last 2 digits, depending on whether it's less than or equal to 255), the handler should perform the addition of the two passed parameters.  
6. If the SVC number does not match the fixed number, the handler should perform subtraction of the two passed parameters. Ensure that the program properly handles stack usage and resumes the application task after performing the required operation. 
