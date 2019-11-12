	#include p18f87k22.inc

	extern  LCD_Setup, LCD_Write_Message, LCD_Clear_Message 
	extern  LCD_Display_digits, LCD_Write_Hex
	extern  RTCC_Setup, RTCC_Alarm
	extern  pwm0, pwm_stop
	
acs0	udata_acs   ; reserve data space in access ram
acs1    udata_acs
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
interrupt   res 1   ; reserve one byte for interrupt flag
tens        res 1
	
tables	udata	0x400   ; reserve data anywhere in RAM (here at 0x400)
myArray res     0x80    ; reserve 128 bytes for message data
 
rst	code	0       ; reset vector
	goto	setup

;pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
;myTable data	 ""    	; message, plus carriage return
	;constant    myTable_l=.26	; length of data

	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	call    RTCC_Setup      ; setup Clock
	call    RTCC_Alarm   
	goto	start
        
	
	; ******* Main programme ****************************************
start	
	btfsc   PIR3, RTCCIF 
	; check RTCC flag bit, skip the next instruction if bit is 0
	call    pwm0
	call    pwm_stop  ; no operation in this subroutine 
        call    LCD_Display_digits

	; a delay subroutine if you need one, times around loop in delay_count
	;movlw	0xFF
	;movwf	delay_count
	
	NOP
	
delay	decfsz	delay_count	; decrement until zero
	bra delay
	
	bra start

	end
