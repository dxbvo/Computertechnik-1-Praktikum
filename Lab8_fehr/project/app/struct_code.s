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
; -- CT1 P08 "Strukturierte Codierung" mit Assembler
; --
; -- $Id: struct_code.s 3787 2016-11-17 09:41:48Z kesr $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address-Defines
; ------------------------------------------------------------------
; input
ADDR_DIP_SWITCH_7_0       EQU        0x60000200
ADDR_BUTTONS              EQU        0x60000210

; output
ADDR_LED_31_0             EQU        0x60000100
ADDR_7_SEG_BIN_DS3_0      EQU        0x60000114
ADDR_LCD_COLOUR           EQU        0x60000340
ADDR_LCD_ASCII            EQU        0x60000300
ADDR_LCD_ASCII_BIT_POS    EQU        0x60000302
ADDR_LCD_ASCII_2ND_LINE   EQU        0x60000314


; ------------------------------------------------------------------
; -- Program-Defines
; ------------------------------------------------------------------
; value for clearing lcd
ASCII_DIGIT_CLEAR        EQU         0x00000000
LCD_LAST_OFFSET          EQU         0x00000028

; offset for showing the digit in the lcd
ASCII_DIGIT_OFFSET        EQU        0x00000030

; lcd background colors to be written
DISPLAY_COLOUR_RED        EQU        0
DISPLAY_COLOUR_GREEN      EQU        2
DISPLAY_COLOUR_BLUE       EQU        4

; ------------------------------------------------------------------
; -- myConstants
; ------------------------------------------------------------------
        AREA myConstants, DATA, READONLY
; display defines for hex / dec
DISPLAY_BIT               DCB        "Bit "
DISPLAY_2_BIT             DCB        "2"
DISPLAY_4_BIT             DCB        "4"
DISPLAY_8_BIT             DCB        "8"
DISPLAY_ARR_BIT           DCB        "012345678"
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY
        ENTRY

        ; imports for calls
        import adc_init
        import adc_get_value

main    PROC
        export main
        ; 8 bit resolution, cont. sampling
        BL         adc_init 
        BL         clear_lcd

main_loop
; STUDENTS: To be programmed
		
		;load ADC value
		BL	adc_get_value
		
		;reset LCD every loop
		;BL clear_lcd
		
		;reset LCD every Loop
		LDR	R3, =ADDR_LCD_COLOUR
		LDR R2, =0x0000
		STRH R2, [R3, #DISPLAY_COLOUR_RED]
		STRH R2, [R3, #DISPLAY_COLOUR_GREEN]
		STRH R2, [R3, #DISPLAY_COLOUR_BLUE]
		
		;check if Button T0 is pressed
		LDR R1, =ADDR_BUTTONS
		LDR R1, [R1]
		MOVS R2, #0x01
		ANDS R1,R2
		
		;if NOT pressed
		BEQ released
		;set color to green
		LDR R3, =ADDR_LCD_COLOUR
		LDR R4, =0xFFFF							;max brightness
		STRH R4, [R3, #DISPLAY_COLOUR_GREEN]
		MOVS R1, R0
		;Aufgabe 3b
		LSRS R2, R0, #3	;divide by 8
		ADDS R2, #1
		MOVS R3, #0		;bar counter variable
		MOVS R5, #0		;loop counter variable
cnt		LSLS R5, #1
		ADDS R5, #1
		ADDS R3, #1
		CMP R2, R3
		BHI cnt
		
		;display the bar
		LDR R4, =ADDR_LED_31_0
		STR R5, [R4]
		
		B finished
		
released
		;read Dip switch 0-7
		LDR R1, =ADDR_DIP_SWITCH_7_0
		LDRB R1, [R1]
		
		;if Diff < 0
		;set color to RED
		LDR R3, =ADDR_LCD_COLOUR
		LDR R4, =0xFFFF		
		MOVS R2, R1				;copy of R1
		SUBS R1, R1, R0	;DIP - ADC
		BMI less
		;set color to blue
		STRH R4, [R3, #DISPLAY_COLOUR_BLUE]
		
		;Aufgabe 3c
		CMP R1, #16
		BGE Bits_8
		CMP R1, #4
		BGE Bits_4
		LDR R5, =DISPLAY_2_BIT
		B display
Bits_8
		LDR R5, =DISPLAY_8_BIT
		B display
Bits_4
		LDR R5, =DISPLAY_4_BIT
display	LDRB R5, [R5]
		LDR R6, =ADDR_LCD_ASCII
		STR R5, [R6]
		BL write_bit_ascii	;display "Bit" on LCD
		B finished
		
less	;set color to red
		STRH R4, [R3, #DISPLAY_COLOUR_RED]
		;Aufgabe 3d
		MOVS R0, #0		;counter variable
		;MOVS R3, #0		;for carry operation
s_cnt	SUBS R3, R2, #0
		BEQ end_cnt			;if 0
		LSRS R2, #1		;left shift 1
		BCC s_cnt		;if carry == 0 add 1 to counter
		ADDS R0, #1
		;SBCS R0, R0, R1	
		B s_cnt
end_cnt	
		MOVS R1, #8
		SUBS R0, R1, R0
		LDR R6, =ADDR_LCD_ASCII_2ND_LINE
		LDR R5, =DISPLAY_ARR_BIT
		LDR R4, [R5, R0]
		
		STRB R4 , [R6]
		
		

finished
		;display ADC value to 7SEG
		LDR R2, =ADDR_7_SEG_BIN_DS3_0
		STR R1, [R2]
		

; END: To be programmed
        B          main_loop
        
clear_lcd
        PUSH       {R0, R1, R2}
        LDR        R2, =0x0
clear_lcd_loop
        LDR        R0, =ADDR_LCD_ASCII
        ADDS       R0, R0, R2                       ; add index to lcd offset
        LDR        R1, =ASCII_DIGIT_CLEAR
        STR        R1, [R0]
        ADDS       R2, R2, #4                       ; increas index by 4 (word step)
        CMP        R2, #LCD_LAST_OFFSET             ; until index reached last lcd point
        BMI        clear_lcd_loop
        POP        {R0, R1, R2}
        BX         LR

write_bit_ascii
        PUSH       {R0, R1}
        LDR        R0, =ADDR_LCD_ASCII_BIT_POS 
        LDR        R1, =DISPLAY_BIT
        LDR        R1, [R1]
        STR        R1, [R0]
        POP        {R0, R1}
        BX         LR	

        ENDP
        ALIGN


; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
