	#include p18f87k22.inc

	extern  LCD_Setup, LCD_Write_Message, LCD_Clear_Message 
	extern  LCD_Display_digits, LCD_Write_Hex
	extern  RTCC_Setup, RTCC_Alarm
	extern  buz0, buz_stop, timer0_setup
	global  start, count1, count2

	
acs0	udata_acs   ; reserve data space in access ram
;acs1    udata_acs
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
interrupt   res 1   ; reserve one byte for interrupt flag
tens        res 1
count1      res 1
count2      res 1
tmpw        res 1

rst	code	0       ; reset vector

goto	setup
	
int_hi  code 0x0008             ; setting up interrupt 
        btfss  INTCON, TMR0IF   ;bit test file, skip if set, check the timer0 interrupt 
	retfie FAST  
	call update_counts

	bcf    INTCON,TMR0IF     ;clear interrupt flag
	retfie FAST              ;fast return from interrupt 
	
int_low	code   0x0018
	btfsc   PIR3, RTCCIF 
	; check RTCC flag bit, skip the next instruction if bit is 0
	call    buz0
	bcf   PIR3, RTCCIF         ;clear interrupt flag for alarm
	retfie FAST

main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	call    RTCC_Setup      ; setup Clock
	call    RTCC_Alarm   
	bcf     PIR3, RTCCIF 
	goto	start
        
	
	; ******* Main programme ****************************************
start	
	
	call    timer0_setup    ; setup timer 0
	call   LCD_Display_digits

	btfsc   PIR3, RTCCIF 
	; check RTCC flag bit, skip the next instruction if bit is 0
	call    buz0
	bcf   PIR3, RTCCIF         ;clear interrupt flag for alarm	
	
	NOP
	
	bra start

update_counts
	btg    LATB, RB6        ;bit toggle f
	decf   count1           ;every interrupt event decrements count 1, 
	movwf  tmpw
	movlw  0x00
	cpfsgt  count1          ; when count1 decrements to 00       
	incf    count2          ; count2 increments 1
	movf   tmpw, w
	return
	
	goto  $
	end
