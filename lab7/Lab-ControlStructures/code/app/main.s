;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 7
;* -- Description : Control structures
;* -- 
;* -- $Id: main.s 3748 2016-10-31 13:26:44Z kesr $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
    
                AREA myCode, CODE, READONLY
                    
                THUMB

ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_7_SEG_BIN_DS1_0    EQU     0x60000114
ADDR_DIP_SWITCH_15_0    EQU     0x60000200
ADDR_HEX_SWITCH         EQU     0x60000211

NR_CASES        		EQU     0xB

; MASKS for Operands
OP1_MASK				EQU		0x00FF
OP2_MASK				EQU		0xFF00

;MASK for rotary Switch
MASK_ROT_SW             EQU     0xF
	
jump_table      ; ordered table containing the labels of all cases

 ; STUDENTS: To be programmed 

	DCD case_DARK    ; +0  (R2*4)
	DCD case_ADD     ; +4
	DCD case_SUB     ; +8
	DCD case_MUL	 ; +12
	DCD case_AND	 ; +16
	DCD case_OR	     ; +20
	DCD case_XOR     ; +24
	DCD case_NOT     ; +28
	DCD case_NAND    ; +32
	DCD case_NOR	 ; +36
	DCD case_XNOR    ; +40
	DCD case_default ; +44	
		
 ; END: To be programmed
    

; -------------------------------------------------------------------
; -- Main
; -------------------------------------------------------------------   
                        
main            PROC
                EXPORT main
                
read_dipsw      ; Read operands into R0 and R1 and display on LEDs
    
	; STUDENTS: To be programmed
				
    LDR R0, =OP1_MASK
	LDR R1, =OP2_MASK
	LDR R7, =ADDR_DIP_SWITCH_15_0
	LDR R7, [R7]
	
	ANDS R0, R0, R7  ; SW_7_0 to R0 OP1
	ANDS R1, R1, R7  ; SW_15_0 to R1 OP2
	
	LDR R3, =ADDR_LED_15_0
	
	STR R0, [R3]
	STR R1, [R3]
	
	

    ; END: To be programmed
                    
read_hexsw      ; Read operation into R2 and display on 7seg.
   
   ; STUDENTS: To be programmed
	
	LDR R2, =ADDR_HEX_SWITCH
	LDR R5, =MASK_ROT_SW
	LDR R2, [R2]
	ANDS R2, R2, R5

	LDR R4, =ADDR_7_SEG_BIN_DS1_0
	STR R2, [R4]                      ; ROT_SW to DS0

    ; END: To be programmed
                
case_switch     ; Implement switch statement as shown on lecture slide
    
	; STUDENTS: To be programmed
				
	CMP R2, #NR_CASES 
	BHS case_default
	LSLS R2, #2 ; (*4 jump to case)
	LDR R6, =jump_table
	LDR R6, [R6, R2]
	BX R6
	
    ; END: To be programmed


; Add the code for the individual cases below
; - operand 1 in R0
; - operand 2 in R1
; - result in R0

case_DARK       
                LDR  R0, =0
                B    display_result  

case_ADD        
                ADDS R0, R0, R1
                B    display_result
				
case_SUB
				SUBS R0, R0, R1
				B	 display_result
				
case_MUL
				MULS R0, R1, R0
				B	 display_result
				
case_AND
				LSRS R1, #8
				ANDS R0, R0, R1
				B	 display_result
				
case_OR
				LSRS R1, #8
				ORRS R0, R0, R1
				B	 display_result
				
case_XOR
				LSRS R1, #8
				EORS R0, R0, R1
				B	 display_result
				
case_NOT
				MVNS R0, R0
				B    display_result
				
case_NAND
				LSRS R1, #8
				ANDS R0, R0, R1
				MVNS R0, R0
				B    display_result
				
case_NOR
				LSRS R1, #8
				ORRS R0, R0, R1
				MVNS R0, R0
				B    display_result
				
case_XNOR
				LSRS R1, #8
				EORS R0, R0, R1
				MVNS R0, R0
				B    display_result
				
case_default
				LDR R0, =0xFFFF
				B   display_result
				
; STUDENTS: To be programmed


; END: To be programmed


display_result  ; Display result on LEDs
              
    ; STUDENTS: To be programmed

	LDR R1, =ADDR_LED_31_16
	STRH R0, [R1]

    ; END: To be programmed

                B    read_dipsw
                
                ALIGN
                ENDP

; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

