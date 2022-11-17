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
	
BITMASK_KEY_T0            EQU        0x00000001	

; ------------------------------------------------------------------
; -- myConstants
; ------------------------------------------------------------------
        AREA myConstants, DATA, READONLY
; display defines for hex / dec
DISPLAY_BIT               DCB        "Bit "
DISPLAY_2_BIT             DCB        "2"
DISPLAY_4_BIT             DCB        "4"
DISPLAY_8_BIT             DCB        "8"
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

; die Beleuchtungen müssen noch ausgeschaltet werden

		BL adc_get_value

        LDR     R1, =ADDR_BUTTONS             ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0           ; load key mask T0
        LDRB    R0, [R1]                      ; load key values
        TST     R0, R2                        ; check, if key T0 is pressed
		 
		LDR  R0, =ADDR_LCD_COLOUR
		LDR  R2, =0x0000
		STRH R2, [R0, #DISPLAY_COLOUR_GREEN]  ; All LCD Diplay off
		STRH R2, [R0, #DISPLAY_COLOUR_RED]
		STRH R2, [R0, #DISPLAY_COLOUR_BLUE]

        BEQ     T0_not_pressed   ; Z=1

T0_pressed ;Green case
		
		LDR  R0, =ADDR_LCD_COLOUR 
		LDR  R1, =0xFFFF
		STRH R1, [R0, #DISPLAY_COLOUR_GREEN]  ; LCD green on
		
		BL adc_get_value                      ; get ADC value to R0
		LDR  R2, =ADDR_7_SEG_BIN_DS3_0
		STRH R0, [R2]	                      ; store ADC value to DS1 and DS0
		
		
T0_not_pressed	
		
		BL adc_get_value                      ; get ADC value to R0
		LDR  R1, =ADDR_LCD_COLOUR 
		LDR  R2, =0xFFFF
		STRH R2, [R1, #DISPLAY_COLOUR_RED]    ; LCD red on
		
		LDR  R3, =ADDR_DIP_SWITCH_7_0         
		LDR  R3, [R3]	                    
		SUBS R4, R0, R3                       ; diff of value(S7..S0) - ADC value
		LDR  R5, =ADDR_7_SEG_BIN_DS3_0
		STR  R4, [R5]                         ; store diff to 7-segment
		
		MOVS  R6, #0x00000000
		CMP   R4, R6                          ; compare R4, R6                                          ab hier gibt es fehler. LCD erscheint violet statt blau
		BGE case_blue                         ; signed greater than or equal N==V
		
case_blue

		LDR  R0, =ADDR_LCD_COLOUR
		LDR  R2, =0x0000
		STRH R2, [R0, #DISPLAY_COLOUR_GREEN]  ; green and red LCD Diplay off
		STRH R2, [R0, #DISPLAY_COLOUR_RED]
		LDR  R3, =0xFFFF
		STRH R3, [R1, #DISPLAY_COLOUR_BLUE]   ; blue LCD on
		

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
