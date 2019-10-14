	#include p18f87k22.inc
	
	code
	org 0x0
	goto start 
	org 0x100		    ; Main code starts here at address 0x100

start
        ; External memory code ;
	movlw 0x00                  
	movwf TRISD, ACCESS         ; Port D all outputs
	
	movlw 0x0f
	movwf PORTD, ACCESS         ; Port D all outputs
        
	goto  0x0                   
	
	end
