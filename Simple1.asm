	#include p18f87k22.inc
	
	code
	org 0x0
	goto start 
	org 0x100		    ; Main code starts here at address 0x100

start
	call SPI_MasterInit
	movlw  0xaa
	call SPI_Mastertransmit
		
loop 
 	bra  loop
	
SPI_MasterInit                      ; Set Clock edge to negative
	bcf    SSP2STAT, CKE
	;MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHZ)
	movlw  (1<<SSPEN) | (1<<CKP) | (0x02)
	movwf  SSP2CON1
	; SDO2 output : SCK2 output
	bcf    TRISD, SDO2
	bcf    TRISD, SCK2
	return
	
SPI_Mastertransmit                  ; Start transmission of data (held in W)
	movwf  SSP2BUF
wait_Transmit                       ;  Wait for transmission to complete
	btfss  PIR2, SSP2IF
	bra    wait_Transmit
	bcf    PIR2, SSP2IF         ; clear interrupt flag
	return
	
	end
