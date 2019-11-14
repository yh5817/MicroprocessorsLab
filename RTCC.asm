#include p18f87k22.inc
    
    global RTCC_Setup, RTCC_Alarm
	
    org  0x10

acs0	    udata_acs  
var1  res 1 
var2  res 1
    
RTCC    code   
RTCC_Setup
    
    ;**********************************
    ; Enable RTCC Timer Access
    ;**********************************
    bcf     ALRMCFG, ALRMEN               ; disable alarm
    
    movlb   0x0F                       
    bcf     INTCON, GIE                   ; enable access the BSR is used to select the GPR bank (example: bsf with a=1
    movlw   0x55                          ;erase flash programme memory 
    movwf   EECON2
    movlw   0xAA
    movwf   EECON2
    bsf     RTCCFG, RTCWREN               ; enable writing
    bsf	    RTCCFG, RTCEN                 ; enable RTCC module
	 
    clrf    ANCON2
    bcf	    TRISG, TRISG4
    bcf     PADCFG1, RTSECSEL1            ;RTCC alarm pulse is selected for RTCC  pin
    bcf     PADCFG1, RTSECSEL0
    bsf	    RTCCFG, RTCOE                 ; set RTCC output enable 

    ;**********************************
    ; write to the Clock Value Resgister 
    ;**********************************
    
    bsf     RTCCFG, RTCPTR1
    bsf     RTCCFG, RTCPTR0
       
    movlw   0x19                           ; set year to 2019
    movwf   RTCVALL
     
    bsf     RTCCFG, RTCPTR1
    bcf     RTCCFG, RTCPTR0 
    movlw   0x07                          ; set day to 4
    movwf   RTCVALL
     
    movlw   0x11                           ; set month to November
    movwf   RTCVALH
     
    bcf     RTCCFG, RTCPTR1
    bsf     RTCCFG, RTCPTR0 
    movlw   0x14                           ; initial hour
    movwf   RTCVALL
     
    movlw   0x4                            ; set weekday 
    movwf   RTCVALH
     
    bcf     RTCCFG, RTCPTR1
    bcf     RTCCFG, RTCPTR0 
    movlw   0x30                            ; set second
    movwf   RTCVALL
     
    movlw   0x04                            ; set minute 
    movwf   RTCVALH
    ;**********************************
    ; Disable RTCC timer access
    ;**********************************
    movlw   0x55
    movwf   EECON2
    movlw   0xAA
    movwf   EECON2
    bcf     RTCCFG, RTCWREN                 ; Clear RTCWREN bit 
    return
    
RTCC_Alarm
    bcf   RTCCFG, RTCSYNC                   
    
    bsf   ALRMCFG, ALRMEN                   ; Enable alarm
    bsf   ALRMCFG, CHIME                    ; Enable chime 
    
    bsf   ALRMCFG, AMASK0
    bsf   ALRMCFG, AMASK1
    bcf   ALRMCFG, AMASK2
    bcf   ALRMCFG, AMASK3                   ; set to once a day
    
     ;**********************************
    ; write to the Alarm Value Register 
    ;**********************************
    
    bsf   ALRMCFG, ALRMPTR1
    bcf   ALRMCFG, ALRMPTR0
    
    movlw  0x07
    movwf  ALRMVALL                          ; set alarm day to 5
    
    movlw  0x11
    movwf  ALRMVALH                          ; set alarm month to November
    
    movlw  0x14
    movwf  ALRMVALL                          ; set alarm hour to 2
    
    movlw  0x4                               
    movwf  ALRMVALH                          ; set alarm weekday to Tuesday
    
    movlw  0x00
    movwf  ALRMVALL                          ; set alarm second to 30
    
    movlw  0x05
    movwf  ALRMVALH                          ; set alarm minute to 05
    
      
    movlw  b'11111111'  
    movwf  ALRMRPT                            ;REPEAT ALARM for 255 more times 
   
    clrf  TRISD                               ; set PORTD as all outputs
    bcf	  LATD, ACCESS
    bsf   PIE3, RTCCIE                       ; enable RTCC interrupt
    bsf   INTCON, GIE                        ; enable all interrupt
    return

    end