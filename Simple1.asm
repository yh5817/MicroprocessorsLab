	#include p18f87k22.inc
        
	code
	org 0x0
	goto start 
	org 0x100
start
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
	
	goto   $

bigdelay
	movlw 0x00
dloop   decf 0x11, f
	subwfb 0x10, f
	bc dloop 
	return
	
	end
	
