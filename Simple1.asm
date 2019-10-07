	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	; ******* Port D Setup Code ****
	movlw 0xff ; all bits in
	movwf TRISD, A ; Port D Direction Register
	bsf PADCFG1,RDPU, A ; Turn on pull-ups for Port D
	
	movlw 	0x0
	movwf	TRISE, ACCESS	    ; Port C all outputs
	bra 	test
loop	movff 	0x06, PORTE
	incf 	0x06, W, ACCESS
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	movf    PORTE,W,ACCESS
	cpfsgt 	0x06, ACCESS
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start
	
	end
