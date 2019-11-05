#include p18f87k22.inc
    
    global RTCC_Setup
	
    org  0x10
;	goto start
;start

acs0    udata_acs  
var1  res 1 
var2  res 1
    
RTCC    code   
RTCC_Setup
    
    ;**********************************
    ; Enable RTCC Timer Access
    ;**********************************
    bcf     ALRMCFG, ALRMEN               ; disable alarm
    
    movlb   0x0F
    bcf     INTCON, GIE
    movlw   0x55
    movwf   EECON2
    movlw   0xAA
    movwf   EECON2
    bsf     RTCCFG, RTCWREN               ; enable writing
    bsf	    RTCCFG, RTCEN                 ; enable RTCC module
	 
    clrf    ANCON2
    bcf	    TRISG, TRISG4
    bsf     PADCFG1, RTSECSEL1
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
    movlw   0x04                           ; set day to 4
    movwf   RTCVALL
     
    movlw   0x11                           ; set month to November
    movwf   RTCVALH
     
    bcf     RTCCFG, RTCPTR1
    bsf     RTCCFG, RTCPTR0 
    movlw   0x00                           ; initial hour
    movwf   RTCVALL
     
    movlw   0x1                            ; set weekday 
    movwf   RTCVALH
     
    bcf     RTCCFG, RTCPTR1
    bcf     RTCCFG, RTCPTR0 
    movlw   0x20                            ; set second
    movwf   RTCVALL
     
    movlw   0x30                            ; set minute 
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
    
    bcf   ALRMCFG, AMASK0
    bsf   ALRMCFG, AMASK1
    bsf   ALRMCFG, AMASK2
    bcf   ALRMCFG, AMASK3                   ; set to once a day
    
     ;**********************************
    ; write to the Alarm Value Register 
    ;**********************************
    
    bsf   ALRMCFG, ALRMPTR1
    bcf   ALRMCFG, ALRMPTR0
    movlw  0x11
    movwf  ALRMVALH                          ; set alarm month to November
    
    movlw  0x05
    movwf  ALRMVALL                          ; set alarm day to 5
    
    bcf   ALRMCFG, ALRMPTR1
    bsf   ALRMCFG, ALRMPTR0
    movlw  0x2                               
    movwf  ALRMVALH                          ; set alarm weekday to Tuesday
    
    movlw  0x02
    movwf  ALRMVALL                          ; set alarm hour to 2
    
    bcf   ALRMCFG, ALRMPTR1
    bcf   ALRMCFG, ALRMPTR0    
    movlw  0x20
    movwf  ALRMVALH                          ; set alarm minute to 20
    
    movlw  0x30
    movwf  ALRMVALL                          ; set alarm second to 30
    end