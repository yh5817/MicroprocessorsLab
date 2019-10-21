	#include p18f87k22.inc

start
	movlw 0x00
	movwf TRISE, ACCESS
	bsf PADCFG1, REPU, banked

	end