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
	movwf PORTD, ACCESS         ; Set OE1, 2 and CP1, 2 high
	
	clrf TRISE                  ; Clear PORTE
		 
	movlw  0x20                 ; initial value
	movwf  LATE, ACCESS
	
	movlw 0x0b                  ; lower CP1
	movwf PORTD, ACCESS
	
	movlw high(0x10)
	movwf 0x10
	movlw low(0x10)
	movwf 0x11
	call bigdelay
	
	movlw 0x0f
	movwf PORTD, ACCESS        ; high CP1
	
	setf TRISE        ; set TRISE high
	
	movlw 0x0e
	movwf PORTD, ACCESS         ; lower OE1

	; setup Port C ;
	movlw  0x00
	movwf TRISC, ACCESS
	movff PORTE, PORTC
	
	; second memory chip ;
	movlw 0x00                  
	movwf TRISD, ACCESS         ; Port D all outputs
	movlw 0x0f
	movwf PORTD, ACCESS         ; Set OE2 and CP2 high
	
	clrf TRISE                  ; Clear PORTE
		 
	movlw  0x20                 ; initial value
	movwf  LATE, ACCESS
	
	movlw 0x07                  ; lower CP2
	movwf PORTD, ACCESS
	
	movlw high(0x10)
	movwf 0x10
	movlw low(0x10)
	movwf 0x11
	call bigdelay
	
	movlw 0x0f
	movwf PORTD, ACCESS        ; high CP2
	
	setf TRISE        ; set TRISE high
	
	movlw 0x0d
	movwf PORTD, ACCESS    ; lower OE2   

	; setup Port F ;
	movlw  0x00
	movwf TRISF, ACCESS
	movff PORTE, PORTF
	
	movlw 0x0f
	movwf PORTD, ACCESS
	
	goto  0x0                   

bigdelay   
	movlw 0x00
dloop	decf  0x11, f
	subwfb 0x10, f
	bc dloop
        return 
	
	end
