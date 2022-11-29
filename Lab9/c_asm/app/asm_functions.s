
	AREA myCode, CODE, READONLY
    THUMB

;---------------------------------------------
;  to be programmed ..

out_word 	PROC
			EXPORT out_word
	
			STR R1, [R0]
	
			BX LR
			ALIGN
			ENDP

in_word		PROC
			EXPORT in_word
			
			LDR R0, [R0]
			
			BX LR
			ALIGN
			ENDP
			END
				
;  .. end to be programmed
;---------------------------------------------

	ALIGN
	END

