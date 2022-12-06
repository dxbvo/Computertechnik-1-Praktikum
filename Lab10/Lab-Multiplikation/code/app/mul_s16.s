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
;* -- Description : Multiplication 16 bit unsigned
;* -- 
;* -- $Id: $
;* ------------------------------------------------------------------


NR_OF_TESTS     EQU     8
BITMASK_1		EQU		0x01   
; -------------------------------------------------------------------
; -- Code
; -------------------------------------------------------------------
                AREA myCode, CODE, READONLY
                THUMB

mul_s16         PROC
                EXPORT mul_s16
                IMPORT display_title
				IMPORT tests_16x16

                PUSH {R1-R3,LR}

				LDR  R0,=title
				BL   display_title

				LDR  R3,=result_table
				LDR  R2,=values
				LDR  R1,=NR_OF_TESTS
				LDR  R0,=operation
				BL   tests_16x16

				POP  {R1-R3,PC}
				ENDP
                    
; -------------------------------------------------------------------
; 16 bit multiplication
; - multiplier in R0
; - multiplicand in R1
; - 32 bit result in R0
; -------------------------------------------------------------------
operation       PROC
				PUSH {R4-R7,LR}

				; Instruction: do not use high registers in your code, 
				; or make sure they contain thier original values
				; when the function returns

                ; STUDENTS: To be programmed  
				
				SXTH R0, R0 ; extends OP1 to signed
				SXTH R1, R1 ; extends OP2 to signed
				
				LDR R2, =0	; loopcounter R2 to zero
				LDR R4, =0	; temp. result
				LDR R6, =BITMASK_1
				
				MOVS R3, R0
				
while			
				CMP R3, #0	; Compare R3 with zero
				BEQ endWhile
				
				; Mask
				MOVS R5, R3
				ANDS R5, R5, R6  ; filtering last bit

				CMP R5, #0       ; checks last bit
				BEQ end_if       ; if last bit = 0 than end_if
				
				MOVS R7, R1
				LSLS R7, R7, R2  ; shift operand 2 ever loop
				ADDS R4, R4, R7  ; adds operand 2 every loop
end_if			
				LDR R7, =1
				ADDS R2, R2, R7  ; R2 counts +1 every loop
				LSRS R3, R3, #1 
				B while
				
endWhile
				MOVS R0, R4	     ; result to R0

                ; END: To be programmed

                POP  {R4-R7,PC}            ; return R0
                ENDP
					
				ALIGN

; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
                AREA myConstants, DATA, READONLY

values          DCW         0x0001
				DCW         0xffff
				DCD     0xffffffff
					
				DCW         0x0017
				DCW         0x004a
				DCD     0x000006a6
					
				DCW         0xffff
				DCW         0xffff
				DCD     0x00000001
					
				DCW         0x73a4
				DCW         0x4c28
				DCD     0x2266c1a0
					
				DCW         0x43cc
				DCW         0xc3bf
				DCD     0xf00af934
					
				DCW         0xe372
				DCW         0x0234
				DCD     0xffc11728
					
				DCW         0xdd22
				DCW         0xbcde
				DCD     0x0924bb7c
					
				DCW         0x7fff
				DCW         0x7fff
				DCD     0x3fff0001

title           DCB "mul_s16", 0

				ALIGN

; -------------------------------------------------------------------
; -- Variables
; -------------------------------------------------------------------
                AREA myVars, DATA, READWRITE
                    
result_table    SPACE   NR_OF_TESTS*4
	
				ALIGN

; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END
