	#include p18f87k22.inc
	
	code
	org 0x0
        goto   start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	; ******* Port D Setup Code ****
	movlw	0xff ; all bits in
	movwf	TRISD, A ; Port D Direction Register
	bsf	PADCFG1,RDPU, A ; Turn on pull-ups for Port D
	movlw 	0x0
	movwf	TRISE, ACCESS  ; Port E all outputs
	bra 	test
loop	movff 	0x06, PORTE
	movlw   high(0xFFFF)   ; load 16bit number into
	movwf   0x10           ; FR 0x10
	movlw   low(0xFFFF)    
	movwf   0x11           ; and FR 0x11
	movlw   0xFF
	movwf   0x12
	
	
	movlw   0xFF
	lfsr fsr0,0x12
	movwf  POSTINC0

loop:
	movlw   0x5
	movwf  POSTINC0
	decfsz 0x08,f,access
	bra loop
	
        call    bigdelay
	incf 	0x06, W, ACCESS
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	movf    PORTD,W
	cpfsgt 	0x06, ACCESS
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

bigdelay
	movlw   0x00           ; w = 0
dloop   decf    0x11, f        ; no carry when 0x00 -> 0xff
	subwfb  0x10, f        ; no carry whe 0x00 -> 0xff
	subwfb  0x12, f
	bc dloop               ; if carry. then loop again
	return                 ; carry not set so return
	end
