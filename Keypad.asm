#include p18f87k22.inc
      
    global  wait_press_1, wait_press_2
    extern  buz_stop, count2, LCD_Display_Questions, LCD_Clear_Message, LCD_wakeup, LCD_Display_Question2

acs0	    udata_acs  
row   res 1                    ; reserve one byte for row value for decoding 
col   res 1                    ; reserve one byte for column value for decoding 
zero  res 1                    ; reserve one byte for 0
v_row res 1                    ; reserve one byte for value of decoded row
v_col res 1                    ; reserve one byte for value of decoded column
day   res 1                    ; reserve one byte for weekday
	    
keypad      code
	
wait_press_1                   ; 5s after alarm event 
        call  LCD_wakeup       ; wake up message 
	movlw 0x00
	movwf zero           
	
	call keypad_decode

	cpfseq zero, 0         ; test if any key is pressed, if pressed, w /= 0
	bra  buz_stop          ; key pressed within 5s
	movlw 0x50             ; wait for 5s
	cpfseq count2
	bra wait_press_1
	call LCD_Clear_Message
	bra wait_press_2       ; no key pressed in the first 5s
	return
	
wait_press_2                   ; calculation question routine 
	call LCD_Display_Questions
	call  keypad_decode
	cpfseq zero, 0   
	bra  keypad_check_row
	bra  wait_press_2
	
keypad_check_row
	movlw    0x04
	cpfseq   v_row         ; check if the correct row is pressed
	bra wait_press_2
	bra keypad_check_col

	
keypad_check_col
	movlw    0x01
	cpfseq   v_col         ; check if the correct column is pressed 
        bra wait_press_2
	call LCD_Clear_Message
	call LCD_Display_Question2
	bra wait_press_3
	
	
wait_press_3
	call  check_sunday      
	call  keypad_decode 
	cpfseq zero, 0
	bra   check_weekday_13
	bra   wait_press_3

check_sunday                    ; check if today is sunday, if sunday, alarm stop 
	movlb   0x0f            ; move 0x0f to bank select register
	bcf     RTCCFG, RTCPTR1
        bsf     RTCCFG, RTCPTR0 
	movff   RTCVALH, day    ; weekday
	movlw   0x00
	cpfsgt  day
	bra     buz_stop
	nop
	return
		 
check_weekday_13
	movlw   0x01
	cpfseq  v_row
	bra     check_weekday_46
	bra     check_WKD_13col
	

check_weekday_46
	movlw   0x02
	cpfseq  v_row
	bra     wait_press_3
	bra     check_WKD_46col
	
check_WKD_13col
	 movf   day, w
	 cpfseq  v_col
	 bra  wait_press_3
         bra     buz_stop
	 
check_WKD_46col
	 movlw  0x01
	 addwf  v_row, 0
	 addwf  v_col, 1            ; v_col updated
	 
	 movf    day, w
	 
	 cpfseq  v_col
	 bra  wait_press_3
	 bra  buz_stop
	

keypad_decode 
      ;set up to decode column 
        movlw 0x0f
	movwf TRISE, ACCESS
	banksel PADCFG1
	bsf PADCFG1, REPU, BANKED ; Turn on pull-ups for port E
	
	clrf LATE  ; Write 0s to the LATE register
	movlw 0x0f  ; set RE0-3 high, RE4-7 low 00001111
	movwf LATE, ACCESS
	
	movlw high(0xff)
	movwf 0x10
	movlw low (0xff)
	movwf 0x11
	call bigdelay	
	
	movff PORTE, col   ;store the latch value in col 
	
	;set up to decode row	
	movlw 0xf0          
	movwf TRISE, ACCESS
	banksel PADCFG1
	bsf PADCFG1, REPU, BANKED ; Turn on pull-ups for port E
	
	clrf LATE  ; Write 0s to the LATE register
	movlw 0xf0     ; set RE0-3 low, RE4-7 high 11110000
	movwf LATE, ACCESS
	
	movlw high(0xff)
	movwf 0x10
	movlw low (0xff)
	movwf 0x11
	call bigdelay	
	
	movff PORTE, row   ; store latch value in row
	
;	;decode column 
	movlw 0xE    ;00001110
	subwf col, ACCESS ; subtract 0xE from col value value store in w 
	BZ col_1     ;if 0th bit is 1 excecute next line
	              ;if 0th bit is 0 branch to col_1, meaning the press value agree and now check the row)
	
	movlw 0xD     ;00001101
	subwf col, ACCESS 
	BZ col_2
	
	movlw 0xB             ;00000111
	subwf col, ACCESS 
	BZ col_3
	
	movlw 0x7            ;00001111
	subwf col, ACCESS 
	BZ col_4
	
	movlw 0x0        ;if no key pressed, store 0x0 in w register
	return
	;store the decode value of column in v_col
col_1   movlw 0x1
	movwf v_col
        bra decode_r
	
col_2   movlw 0x2
	movwf v_col
	bra decode_r
	
col_3   movlw 0x3
	movwf v_col
	bra decode_r
	
col_4   movlw 0x4
	movwf v_col
	bra decode_r
		
	;decode row
decode_r	
	movlw 0xE0       ;11100000
	subwf row, ACCESS
	BZ op_1
	
	movlw 0xD0      ;11010000
	subwf row, ACCESS
	BZ op_2

	movlw 0xB0      ;10110000
	subwf row, ACCESS
	BZ op_3

	movlw 0x70      ;01110000
	subwf row, ACCESS
	BZ op_4
	
	movlw 0x0
	return

op_1    movlw 0x1       ;store decode row value in v_row
	movwf v_row
	return
       
op_2    movlw 0x2
	movwf v_row
	return
       
op_3    movlw 0x3
	movwf v_row
	return
       
op_4    movlw 0x4
	movwf v_row
	return	
	
bigdelay
	movlw 0x00
dloop   decf 0x11, f
	subwfb 0x10, f
	bc dloop 
	return
	
	

	
	end
