#include p18f87k22.inc
	 
	  global question
	  global day

acs1    udata_acs   ; named variables in access ram
 
day     res 1
 
Calculation code                    ; let linker place main program
 
question
     
    bsf     RTCCFG, RTCPTR1
    bcf     RTCCFG, RTCPTR0 
    movf    RTCVALL, w
    movwf   day                      ; store current day value
    return
    
 
