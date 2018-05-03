; T_Rosner_HW4.s
; 04/28/18
; Prof. Lakhani
;  
; R0-File Handler 
; R1-I/O
; R2-Dividend/Sum
; R3-Divisor/Counter1
; R4-Quotient
; R5-Remainder
; R6-Table/Array
; R7-Save File Handler
; R8-Final Sum Placeholder
;

.equ PrChr, 0x00 ; Print character to stdout or outfile
.equ Exit, 0x11 ; Halt Execution
.equ Open, 0x66 ; Open File
.equ Close, 0x68 ; Close File
.equ RdInt, 0x6c ; Read Int From File
.equ InputMode, 0 ; Open File For Reading
.equ PrStr, 0x69 ; Write to stdout or outfile
.equ PrInt, 0x6b ; Write int to stdout or outfile

.data
InFile: .asciz "input(1).txt"
InFileError: .asciz "Unable to open file for input\n"
SumMessage: .asciz "Sum: "
QuotientMessage: .asciz "Mean: "
Period: .asciz "."


.text

OpenFile:

LDR R0, =InFile
Mov R1, #InputMode
SWI Open
BCS input_error ; Branch to error if carry flag is set
Mov R7, R0 ; Save file in R7


ReadFile:

Mov R3, #0 ; Counter/Divisor
Mov R2, #0 ; Sets Dividend to zero

Loop1:

Mov R0, R7 ; Move file to R0(File Handler)
SWI RdInt
BCS Done
Add R2, R2, R0 ;Adds input to the Dividend
Add R3, R3, #1
B Loop1

Done:

Mov R0, R7
SWI Close

Divider:

Mov R4, #0 ; Initialize Quotient to zero
Mov R5 , #0 ; Initialize Remainder to zero
CMP R3, #0 ; Branch if Divisor is zero
BEQ end

Mov R8, R2 ; Sets R8 to Sum to keep Original sum intact

Loop2: 

CMP R8, R3 ; Compare Divisor and Dividend
BLT EndLoop ; Branch if dividend is < Divisor
Sub R8, R8, R3 ;Subtract divisor from dividend
Add R4, R4, #1 ; Increment quotient
B Loop2 

EndLoop: 

Mov R5, R8 ; Move remainder to R5


PrintResults:

Mov R0, #1 ; File handler set to output
LDR R1, =SumMessage
SWI PrStr ;Prints to stdout
Mov R1, R2 
SWI PrInt ; Prints Sum to stdout
Mov R0, #'\n' 
SWI PrChr ; New Line 
mov R0, #1
LDR R1, =QuotientMessage
SWI PrStr ; Prints string to stdout
Mov R1, R4 
SWI PrInt ; Prints quotient to stdout
Mov R0, #1 
LDR R1, =Period
SWI PrStr
Mov R1, R5
SWI PrInt ; Prints remainder
B end


; Display error message if cannot open file for reading

input_error:

       
Mov R0, #1
       
LDR R1, =InFileError
       
SWI PrStr

end: SWI Exit

