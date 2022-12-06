;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 9
;* -- Description : Multiplication 32 bit unsigned
;* -- 
;* -- $Id: $
;* ------------------------------------------------------------------



NR_OF_TESTS     EQU     8
BITMASK_LSB		EQU		0x01
BITMASK_MSB		EQU		0x80000000
    
; -------------------------------------------------------------------
; -- Code
; -------------------------------------------------------------------
    
                AREA myCode, CODE, READONLY
                    
                THUMB

; -------------------------------------------------------------------
; -- Test
; -------------------------------------------------------------------   
                        
mul_u32         PROC
                EXPORT mul_u32
                IMPORT display_title
                IMPORT tests_32x32
                PUSH {R1-R3,LR}

				LDR  R0,=title
				BL   display_title

				LDR  R3,=result_table
				LDR  R2,=values
				LDR  R1,=NR_OF_TESTS
				LDR  R0,=operation
				BL   tests_32x32

				POP  {R1-R3,PC}
				ENDP
                    
; -------------------------------------------------------------------
; 32 bit multiplication
; - multiplier in R0
; - multiplicand in R1
; - 64 bit result in R1:R0 (upper:lower)
; -------------------------------------------------------------------
operation       PROC
				PUSH {R4-R7,LR}

				; Instruction: do not use high registers in your code, 
				; or make sure they contain thier original values
				; when the function returns

                ; STUDENTS: To be programmed     
				
				; R0 input: multiplier / temp. result lower word / output: result lower word
				; R1 input: multiplicand / temp. result upper word / output: result upper word
				; R2 temp. multiplicand lower word
				; R3 temp. multiplicand upper word
				; R4 temp. multiplier
				; R5 counter
				; R6 working register
				; R7 working register

				
				MOVS R2, R1 ; temp. multiplicand lower word = input: multiplicand
				MOVS R3, #0 ; temp. multiplicand upper word = 0
				MOVS R4, R0 ; temp. multiplier = input: multiplier
				MOVS R0, #0 ; temp. result lower word = 0
				MOVS R1, #0 ; temp. result upper word = 0
				MOVS R5, #0 ; counter = 0
while
				; while(temp. multiplier != 0)
				CMP R4, #0 ; Compare the temp. multiplier with zero
				BEQ break ; When the temp. multiplier is zero, break the while loop
				
				; check for overflow of the multiplicand bevor shifting
				LDR R6, =BITMASK_MSB ; R6 = Bitmask for MSB
				ANDS R6, R6, R2 ; mask the MSB
				
				; if(MSB temp. multiplicand lower word == 1)
				CMP R5, #0 ; compare the counter with zero
				BEQ skipShift ; skip overflow procedure when counter is zero
				
				LSLS R3, R3, #1 ; shift temp. multiplicand upper word left by 1
				
				CMP R6, #0 ; compare the MSB of the temp. multiplicand lower word with zero
				BEQ skipOverflow ; skip overflow procedure when MSB is zero
				
				; overflow procedure
				MOVS R6, #1 ; R6 = 1
				ADDS R3, R3, R6 ; Add 1 to the LSB of temp. multiplicant upper word
skipOverflow	
				LSLS R2, R2, #1 ; shift temp. multiplicand lower word left by 1
skipShift				
				; mask LSB of temp. multiplier
				LDR R6, =BITMASK_LSB ; R6 = Bitmask for LSB
				ANDS R6, R6, R4 ; Mask the LSB
				
				; check LSB of multiplier
				CMP R6, #0 ; compare the LSB of multiplier with zero
				BEQ skipAdd ; Skip addition whenn the MSB of the lower word is zero
				
				ADDS R0, R0, R2 ; Add the lower word of temp. result and temp. multiplicand
				ADCS R1, R1, R3 ; Add with carry the upper word of temp. result and temp. multiplicand		
skipAdd
				; count up
				MOVS R6, #1 ; R6 = 1
				ADDS R5, R5, R6	; counter ++
				
				LSRS R4, R4, #1 ; shift the temp. multiplier right by 1
				B while ; Goto while
break		

                ; END: To be programmed

                POP  {R4-R7,PC}            ; return R0
				ENDP

				ALIGN

; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
                AREA myConstants, DATA, READONLY

values          DCD             0x00000001
				DCD             0xffffffff
				DCQ     0x00000000ffffffff

				DCD             0x00001717
				DCD             0x00004a4a
				DCQ     0x0000000006b352a6

				DCD             0x00001717
				DCD             0xffffffff
				DCQ     0x00001716FFFFE8E9

				DCD             0x73a473a4
				DCD             0x4c284c28
				DCQ     0x2267066da5a6c1a0

				DCD             0x43f887cc
				DCD             0xc33e6abf
				DCQ     0x33d6e1f8e60fc934

				DCD             0xe372e372
				DCD             0x00340234
				DCQ     0x002e354b4c451728

				DCD             0x22dddd22
				DCD             0xbcccddde
				DCQ     0x19b6d568f3641d7c

				DCD             0x7fffffff
				DCD             0x7fffffff
				DCQ     0x3fffffff00000001

title           DCB "mul_u32", 0

				ALIGN
; -------------------------------------------------------------------
; -- Variables
; -------------------------------------------------------------------
                AREA myVars, DATA, READWRITE
                    
result_table    SPACE   NR_OF_TESTS*8


; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

