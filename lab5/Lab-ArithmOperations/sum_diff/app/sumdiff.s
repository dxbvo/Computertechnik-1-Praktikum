; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- sumdiff.s
; --
; -- CT1 P05 Summe und Differenz
; --
; -- $Id: sumdiff.s 705 2014-09-16 11:44:22Z muln $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_LED_7_0            EQU     0x60000100
ADDR_LED_15_8           EQU     0x60000101
ADDR_LED_23_16          EQU     0x60000102
ADDR_LED_31_24          EQU     0x60000103

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA MyCode, CODE, READONLY

main    PROC
        EXPORT main

user_prog
        ; STUDENTS: To be programmed
		
		; read value from switches 0-7 and 8-13
		LDR R7, =ADDR_DIP_SWITCH_7_0
		LDRB R0, [R7] 			; Operand B
		LDRB R1, [R7, #1] 	; Operand A
		
		; expand 8 bit value to 32 bit value
		LSLS R0, R0, #24
		LSLS R1, R1, #24
		
		; Add A and B
		ADDS R2, R1, R0
		
			; read processor flags
			MRS R4, APSR
		
			; Display flags
			LSRS R4, R4, #24
			LDR R7, = ADDR_LED_15_8
			STRB R4, [R7] 		; von links nach rechts
		
			; store sum to led
			LSRS R2, R2, #24 
			LDR R7, =ADDR_LED_7_0
			STRB R2, [R7] 
		
		; Subtract B from A (A-B)
		SUBS R3, R1, R0
		
			; read processor flags
			MRS R4, APSR
		
			; Display flags
			LSRS R4, R4, #24
			LDR R7, = ADDR_LED_31_24
			STRB R4, [R7]
		
			; store difference  to led
			LSRS R3, R3, #24
			LDR R7, =ADDR_LED_7_0
			STRB R3, [R7, #2]

        ; END: To be programmed
        B       user_prog
        ALIGN
; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
