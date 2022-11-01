; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- main.s
; --
; -- CT1 P06 "ALU und Sprungbefehle" mit MUL
; --
; -- $Id: main.s 4857 2019-09-10 17:30:17Z akdi $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address Defines
; ------------------------------------------------------------------

ADDR_LED_31_0           EQU     0x60000100
ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_7_SEG_BIN_DS3_0    EQU     0x60000114
ADDR_BUTTONS            EQU     0x60000210

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF      EQU     0x0000

BCD_MASK				EQU		0x0000000F
T0_MASK					EQU		0x00000001
MULS_VALUE				EQU 	0x0000000A


; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
            
; STUDENTS: To be programmed

; STUDENTS: To be programmed
			LDR R4, =BCD_MASK
			LDR R0, =ADDR_DIP_SWITCH_7_0
			LDR R0 , [R0]
			ANDS R0, R0, R4
			MOVS R7, R0
			LDR R1, =ADDR_DIP_SWITCH_15_8
			LDR R1, [R1]
			ANDS R1, R1, R4
			
			;copy of R1 for MULS instruction
			MOVS R5, R1
			;shift R1 4 to the left
			LSLS R1, #4
			
			;combine both values with OR oparation
			ORRS R1, R1, R0
			
			;display BCD on HEX
			LDR R0, =ADDR_7_SEG_BIN_DS3_0
			;display BCD on 7 Seg 0,1
			STRB R1, [R0, #0]
			
			;load led address
			LDR R0, =ADDR_LED_31_0
			
			STRB R1, [R0, #0]
			
			;if T0 is pressed
			LDR R0, =T0_MASK
			LDR R1, =ADDR_BUTTONS
			LDRB R1, [R1]
			ANDS R1, R0
			
			BNE T0_pressed
			
			;binary code
			LDR R6, =MULS_VALUE
			MULS R5, R6, R5
			;ORRS R7, R7, R5
			ADD R7, R7, R5
			LDR R0, =ADDR_LCD_RED
			LDR R1, =0x0000
			LDR R2, =0xffff
			STRH	R1, [r0, #0] 
			STRH    R2, [r0, #4]

			B T0_unpressed
			
T0_pressed	MOVS R6, R5
			LSLS R5, #1
			LSLS R6, #3
			ADDS R5, R5, R6
			ADD R7, R7, R5
			LDR R0, =ADDR_LCD_RED
			LDR R1, =0xffff
			LDR R2, =0x0000
			STRH	R1, [r0, #0] 
			STRH    R2, [r0, #4] 
			
T0_unpressed
			;load led address
			LDR R0, =ADDR_LED_31_0
			STRB R7, [R0, #1]
			
			;display HEX on 7SEG
			LDR R0, =ADDR_7_SEG_BIN_DS3_0
			;display BCD on 7 Seg 0,1
			STRB R7, [R0, #1]
			
			
			;Task 3.2
			; Create width of rotation bar
			MOVS R0, #0
			MOVS R1, #7
barloop 	LSRS R7, R7, #1		;move R7 1 to the left
			BCC endbar			;"if" C==0 move straight no BNE barloop
			LSLS R0, #1
			ADDS R0, R0, #1      
endbar  	SUBS R1, #1
			BNE	barloop
			LDR R3, =ADDR_LED_31_16
			STR	R0, [R3, #0]
			
			;rotate bar left to right
			MOVS R7, R0				;clone R7 into R6
			MOVS R6, R0				;clone R6 into R6
			LSLS R6, #16			;shift R6 16 to the left
			ORRS R7, R7, R6			;OR with R7
			
			MOVS R0, #0				;counter variable
			MOVS R1, #16			
rot_loop	CMP R0, R1		
			BHI go_on				;after 16 rotations break out
			ADDS R0, R0, #1  		;+1
			MOVS R4, #1
			RORS R7, R7, R4			;Rotate R7 1 to the right
			LDR R4, =ADDR_LED_31_16
			STR	R7, [R4, #0]
			BL pause				;call delay function
			BL rot_loop
go_on		

; END: To be programmed

        B       main
        ENDP
            
;----------------------------------------------------
; Subroutines
;----------------------------------------------------

;----------------------------------------------------
; pause for disco_lights
pause           PROC
        PUSH    {R0, R1}
        LDR     R1, =1
        LDR     R0, =0x000FFFFF
        
loop        
        SUBS    R0, R0, R1
        BCS     loop
    
        POP     {R0, R1}
        BX      LR
        ALIGN
        ENDP
			
count_bits

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
