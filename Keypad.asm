#include p18f87k22.inc
      
global     keypad_decode

acs0	    udata_acs  
row   res 1
col   res 1
zero  res 1
	    
keypad      code
keypad_decode
      
      ;set up to decode column 
       movlw 0x0f
	movwf TRISE, ACCESS
	banksel PADCFG1
	bsf PADCFG1, REPU, BANKED ; Turn on pull-ups for port E
	
	clrf LATE  ; Write 0s to the LATE register
	movlw 0x0f
	movwf LATE, ACCESS
	
	movlw high(0xff)
	movwf 0x10
	movlw low (0xff)
	movwf 0x11
	call bigdelay	
	
	movff PORTE, col
	
	;set up to decode row
	
	movlw 0xf0
	movwf TRISE, ACCESS
	banksel PADCFG1
	bsf PADCFG1, REPU, BANKED ; Turn on pull-ups for port E
	
	clrf LATE  ; Write 0s to the LATE register
	movlw 0xf0
	movwf LATE, ACCESS
	
	movlw high(0xff)
	movwf 0x10
	movlw low (0xff)
	movwf 0x11
	call bigdelay	
	
	movff PORTE, row
	
;	;decode column 
	movlw 0xE
	subwf col, ACCESS 
	BZ col_1
	
	movlw 0xD
	subwf col, ACCESS 
	BZ col_2
	
	movlw 0xB
	subwf col, ACCESS 
	BZ col_3
	
	movlw 0x7
	subwf col, ACCESS 
	BZ col_4
	
	;decode row
	
col_1	movlw 0xE0
	subwf row, ACCESS
	BZ op_1
	
	
	
	
	return

;wait_press
	movlw 0x0
	movwf zero

	call keypad_decode

	cpfslt zero, 0
	bra wait_press
	return



	
	
	
	

bigdelay
	movlw 0x00
dloop   decf 0x11, f
	subwfb 0x10, f
	bc dloop 
	return
	
	end
