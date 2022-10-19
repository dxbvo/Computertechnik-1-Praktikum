; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- table.s
; --
; -- CT1 P04 Ein- und Ausgabe von Tabellenwerten
; --
; -- $Id: table.s 800 2014-10-06 13:19:25Z ruan $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB
; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0         EQU     0x60000200
ADDR_DIP_SWITCH_15_8        EQU     0x60000201
ADDR_DIP_SWITCH_31_24       EQU     0x60000203
ADDR_LED_7_0                EQU     0x60000100
ADDR_LED_15_8               EQU     0x60000101
ADDR_LED_23_16              EQU     0x60000102
ADDR_LED_31_24              EQU     0x60000103
ADDR_BUTTONS                EQU     0x60000210

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F
	
; For 7seg
ADDR_SEG7_BIN				EQU		0x60000114
ADDR_SEG7_BIN_2				EQU		0x60000115

; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed

; Allocate memory (32 byte)
byte_array	SPACE	32 

; END: To be programmed
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

main    PROC
        EXPORT main

readInput
        BL    waitForKey                    ; wait for key to be pressed and released
; STUDENTS: To be programmed

		; read switch 0-7 and 8-15 and store in r0,r1
		LDR		R0, =ADDR_DIP_SWITCH_7_0
		LDR		R0, [R0]
		LDR		R1, =ADDR_DIP_SWITCH_15_8
		LDR		R1, [R1]
		
		; apply mask to switch 8-15 
		LDR		R2, =BITMASK_LOWER_NIBBLE
		ANDS	R1, R2
		
		; load led 0-7 addr and write switch value to led
		LDR		R6, =ADDR_LED_7_0
		STRB	R0, [R6]
		
		; load led 8-15 and write masked switch value to led
		LDR		R7, =ADDR_LED_15_8
		STRB	R1, [R7] ; save SWITCH 8-11 to LED 8-15
		
		; load addr of our byte array
		LDR		R3, =byte_array
		
		; copy value and store it correctly
		MOV	R4, R1
		LSLS	R4, R4, #1
		STRB	R0, [R3, R4] ;store it in the array
		ADDS	R4, #1
		STRB	R0, [R3, R4]

		
		; load addr from dip switch 24-31 and display on led 24-31
		LDR		R4, =ADDR_DIP_SWITCH_31_24;
		LDR		R4, [R4];
		ANDS	R4, R4, R2;apply mask to R4
		LDR		R0, =ADDR_LED_31_24 ;write value to led
		STRB	R4, [R0]
		
		
		; write data to 7 seg 
		LSLS	R4, R4, #1
		LDR		R5, [R3, R4]
		LDR		R6, =ADDR_SEG7_BIN
		STRH	R5, [R6]
		LDR		R6, =ADDR_SEG7_BIN_2
		LSRS	R4, R4, #1
		STRH	R4, [R6]
		LSLS	R4, R4, #1
		
		LDR		R0, =ADDR_LED_23_16
		LDR		R1, [R4, R3]
		STRB	R1, [R0]

; END: To be programmed
        B       readInput
        ALIGN

; ------------------------------------------------------------------
; Subroutines
; ------------------------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS           ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0         ; load key mask T0

waitForPress
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is released
        BNE     waitForRelease
                
        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
