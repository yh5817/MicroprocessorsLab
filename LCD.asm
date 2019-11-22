#include p18f87k22.inc

    global  LCD_Setup, LCD_Write_Message, LCD_Write_Hex
    global  LCD_Clear_Message	    
    global  LCD_Display_digits, LCD_Display_Questions, LCD_Display_Question2, LCD_wakeup

acs0    udata_acs   ; named variables in access ram
LCD_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms  res 1   ; reserve 1 byte for ms counter
LCD_tmp	    res 1   ; reserve 1 byte for temporary use
LCD_counter res 1   ; reserve 1 byte for counting through nessage
 
acs_ovr	access_ovr
LCD_hex_tmp res 1   ; reserve 1 byte for variable LCD_hex_tmp	

 
	constant    LCD_E=5	; LCD enable bit
    	constant    LCD_RS=4	; LCD register select bit

LCD	code
    
LCD_Setup
	clrf    LATB
	movlw   b'11000000'	    ; RB0:5 all outputs
	movwf	TRISB
	movlw   .40
	call	LCD_delay_ms	; wait 40ms for LCD to start up properly
	movlw	b'00110000'	; Function set 4-bit
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00101000'	; 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00101000'	; repeat, 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00001111'	; display on, cursor on, blinking on
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00000001'	; display clear
	call	LCD_Send_Byte_I
	movlw	.2		; wait 2ms
	call	LCD_delay_ms
	movlw	b'00000110'	; entry mode incr by 1 no shift
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	return

LCD_Write_Hex	    ; Writes byte stored in W as hex
	movwf	LCD_hex_tmp
	swapf	LCD_hex_tmp,W	; high nibble first
	call	LCD_Hex_Nib
	movf	LCD_hex_tmp,W	; then low nibble
LCD_Hex_Nib	    ; writes low nibble as hex character
	andlw	0x0F
	movwf	LCD_tmp
	movlw	0x0A
	cpfslt	LCD_tmp
	addlw	0x07	; number is greater than 9 
	addlw	0x26
	addwf	LCD_tmp,W
	call	LCD_Send_Byte_D ; write out ascii
	return
	
LCD_Clear_Message
	movlw	b'00000001'	; display clear
	call	LCD_Send_Byte_I
	movlw	.2		; wait 2ms
	call	LCD_delay_ms
	return

LCD_Write_Message	    ; Message stored at FSR2, length stored in W
	movwf   LCD_counter
	
LCD_Loop_message
	movf    POSTINC2, W
	call    LCD_Send_Byte_D
	decfsz  LCD_counter
	bra	LCD_Loop_message
	return
	
LCD_Display_digits
	call	LCD_Line1
	bsf     RTCCFG, RTCPTR1
        bsf     RTCCFG, RTCPTR0 
	movf    RTCVALL, w	    ; year
	call    LCD_Write_Hex

	movlw	'/'
	call	LCD_Send_Byte_D
	movf    RTCVALH, w	    
	movf    RTCVALL, w	    ; day
	call    LCD_Write_Hex

	movlw	'/'
	call	LCD_Send_Byte_D
	movf    RTCVALH, w	    ; month
	call    LCD_Write_Hex

	call	LCD_Line2	    ; move to line 2
	movf    RTCVALL, w	    ; hours
	call    LCD_Write_Hex
	movlw	':'
	call	LCD_Send_Byte_D
	call    LCD_Line_WDY        ; move to line 1 rear
	movf    RTCVALH, w	    ; weekday
	call    LCD_Write_Hex	    
	call    LCD_Line_sec
	movf    RTCVALL, w	    ; seconds
	call    LCD_Write_Hex
	call    LCD_Line_min
	movf    RTCVALH, w	    ; minutes
	call    LCD_Write_Hex
	movlw	':'
	call	LCD_Send_Byte_D
	return
	
LCD_Line1
	movlw	b'10000000'	; Move to the first line - 00H
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	return
	
LCD_Line_WDY
	movlw	b'10001011'	; Move to the first line - 00H
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	return
	
LCD_Line_min
	movlw	b'11000011'	; Move to the first line - 00H
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	return
	
LCD_Line_sec
	movlw	b'11000110'	; Move to the first line - 00H
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	return
	
LCD_Line2
	movlw	b'11000000'	; Move to the second line - 40H
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	return
	
LCD_Display_Questions
	call    LCD_Line1
	movlw   0x10
	call    LCD_Write_Hex
	movlw   '+'
	call	LCD_Send_Byte_D
	movlw   0x20
	call    LCD_Write_Hex
	movlw   '*'
	call	LCD_Send_Byte_D
	movlw   0x3
	call    LCD_Write_Hex
	movlw   '='
	call	LCD_Send_Byte_D
	
	call    LCD_Line2
	movlw   'A'
	call	LCD_Send_Byte_D
	movlw   '.'
	call	LCD_Send_Byte_D
	movlw   0x70
	call    LCD_Write_Hex
	call    LCD_Line_B
	movlw   'B'
	call	LCD_Send_Byte_D
	movlw   '.'
	call	LCD_Send_Byte_D
	movlw   0x80
	call    LCD_Write_Hex
	call    LCD_Line_C
	movlw   'C'
	call	LCD_Send_Byte_D
	movlw   '.'
	call	LCD_Send_Byte_D
	movlw   0x60
	call    LCD_Write_Hex
	
	return
	
LCD_Line_B
	movlw	b'11000101'	; Move to the first line - 45H
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	return
	
LCD_Line_C
	movlw	b'11001010'	; Move to the first line - 45H
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	return
	
LCD_Display_Question2
	movlw   'W'
	call	LCD_Send_Byte_D
	movlw   'h'
	call	LCD_Send_Byte_D
	movlw   'a'
	call	LCD_Send_Byte_D
	movlw   't'
	call	LCD_Send_Byte_D
	movlw   ' '
	call	LCD_Send_Byte_D
	movlw   'd'
	call	LCD_Send_Byte_D
	movlw   'a'
	call	LCD_Send_Byte_D
	movlw   'y'
	call	LCD_Send_Byte_D
	movlw   '?'
	call	LCD_Send_Byte_D
	return
	
LCD_wakeup
        call  LCD_Line1
	movlw   'M'
	call	LCD_Send_Byte_D
	movlw   'o'
	call	LCD_Send_Byte_D
        movlw   'r'
	call	LCD_Send_Byte_D
	movlw   'n'
	call	LCD_Send_Byte_D
	movlw   'i'
	call	LCD_Send_Byte_D
	movlw   'n'
	call	LCD_Send_Byte_D
	movlw   'g'
	call	LCD_Send_Byte_D
	movlw   '!'
	call	LCD_Send_Byte_D
       return
       
	
LCD_Send_Byte_I		    ; Transmits byte stored in W to instruction reg
	bcf	INTCON,GIE
	movwf   LCD_tmp
	movlw	0xf0
	andwf	LATB, F
	swapf   LCD_tmp,W   ; swap nibbles, high nibble goes first
	andlw   0x0f	    ; select just low nibble
	iorwf	LATB, F
	;movwf   LATB	    ; output data bits to LCD
	bcf	LATB, LCD_RS	; Instruction write clear RS bit
	call    LCD_Enable  ; Pulse enable Bit 
	movlw	0xf0
	andwf	LATB, F
	movf	LCD_tmp,W   ; swap nibbles, now do low nibble
	andlw   0x0f	    ; select just low nibble
	iorwf	LATB, F
	;movwf   LATB	    ; output data bits to LCD
	bcf	LATB, LCD_RS    ; Instruction write clear RS bit
        call    LCD_Enable  ; Pulse enable Bit 
	bsf	INTCON,GIE
	return

LCD_Send_Byte_D		    ; Transmits byte stored in W to data reg
	bcf	INTCON,GIE  ;disable interrupt
	movwf   LCD_tmp
	movlw	0xf0
	andwf	LATB, F
	swapf   LCD_tmp,W   ; swap nibbles, high nibble goes first
	andlw   0x0f	    ; select just low nibble
	iorwf	LATB, F
	;movwf   LATB	    ; output data bits to LCD
	bsf	LATB, LCD_RS	; Data write set RS bit
	call    LCD_Enable  ; Pulse enable Bit 
	movlw	0xf0
	andwf	LATB, F
	movf	LCD_tmp,W   ; swap nibbles, now do low nibble
	andlw   0x0f	    ; select just low nibble
	iorwf	LATB, F
	;movwf   LATB	    ; output data bits to LCD
	bsf	LATB, LCD_RS    ; Data write set RS bit	    
        call    LCD_Enable  ; Pulse enable Bit 
	movlw	.10	    ; delay 40us
	bsf	INTCON,GIE  ;enable interrupt
	call	LCD_delay_x4us
	return

LCD_Enable	    ; pulse enable bit LCD_E for 500ns
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bsf	    LATB, LCD_E	    ; Take enable high
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bcf	    LATB, LCD_E	    ; Writes data to LCD
	return
    
; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms		    ; delay given in ms in W
	movwf	LCD_cnt_ms
lcdlp2	movlw	.250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms
	bra	lcdlp2
	return
    
LCD_delay_x4us		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l   ; now need to multiply by 16
	swapf   LCD_cnt_l,F ; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l,W ; move low nibble to W
	movwf	LCD_cnt_h   ; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l,F ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1	decf 	LCD_cnt_l,F	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h,F	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return
    end


