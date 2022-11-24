;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 10
;* -- Description : Search Max
;* -- 
;* -- $Id: search_max.s 879 2014-10-24 09:00:00Z muln $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
                AREA myCode, CODE, READONLY
                THUMB
                    
; STUDENTS: To be programmed




; END: To be programmed
; -------------------------------------------------------------------                    
; Searchmax
; - tableaddress in R0
; - table length in R1
; - result returned in R0
; -------------------------------------------------------------------   
search_max      PROC
                EXPORT search_max

                ; STUDENTS: To be programmed
				
		;test the length of table
		LDR R7, =0x00
		CMP R1, R7 
		BEQ table_is_zero
		
		;table is not zero
		LDR R2, [R0] ;first value of table
		B cond
loop    
		ADDS R4, R0, #4 ; Wert von index in R4
		CMP R2, R4  ; ist R2 grösser als aktueller Wert vom index
		
		
cond    
		LDR R3, [R0, #4]  ;second value of table to R3
		CMP R2, R3
		BGT loop ; not bigger
		
		
table_is_zero		
		LDR R0, =0x80000000
		




                ; END: To be programmed
                ALIGN
                ENDP
; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

