#include p18f87k22.inc
      
global  wait_press

acs0	    udata_acs  
row   res 1
col   res 1
zero  res 1
v_row res 1
v_col res 1
	    
keypad      code
wait_press
	movlw 0x0
	movwf zero    ;store 0x0 in file register zero 

	call keypad_decode

	cpfslt zero, 0      ;compare zero to what is inside w, if no press happened --> loop inside the wait_press
	bra wait_press
	return
	
keypad_decode
      call decode_setup
      
decode_setup     
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
	BZ col_2
	
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
