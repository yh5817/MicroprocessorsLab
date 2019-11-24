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
    bcf     INTCON, GIE                   
    movlw   0x55                          ;erase flash programme memory, sequence needed in order to change RTCWREN bit
    movwf   EECON2
    movlw   0xAA
    movwf   EECON2
    bsf     RTCCFG, RTCWREN               ; enable writing
    bsf	    RTCCFG, RTCEN                 ; enable RTCC module
	 
    clrf    ANCON2
    bcf	    TRISG, TRISG4
    bcf     PADCFG1, RTSECSEL1            ;RTCC second clock is selected for RTCC  pin
    bsf     PADCFG1, RTSECSEL0
    bsf	    RTCCFG, RTCOE                 ; set RTCC output enable 

    ;**********************************
    ; write to the Clock Value Resgister 
    ;**********************************
    
    bsf     RTCCFG, RTCPTR1
    bsf     RTCCFG, RTCPTR0
       
    movlb   0x0f                          ;move 0x0f to bank select register
    movlw   0x19                           ; set year to 2019
    movwf   RTCVALL,BANKED
     
    bsf     RTCCFG, RTCPTR1
    bcf     RTCCFG, RTCPTR0 
    movlw   0x15                          ; set day to 4
    movwf   RTCVALL,BANKED
     
    movlw   0x11                           ; set month to November
    movwf   RTCVALH,BANKED
     
    bcf     RTCCFG, RTCPTR1
    bsf     RTCCFG, RTCPTR0 
    movlw   0x12                           ; set hour to 12
    movwf   RTCVALL,BANKED
     
    movlw   0x05                           ; set weekday to Friday
    movwf   RTCVALH,BANKED
     
    bcf     RTCCFG, RTCPTR1
    bcf     RTCCFG, RTCPTR0 
    movlw   0x00                           ; set second to 0
    movwf   RTCVALL,BANKED
     
    movlw   0x53                          ; set minute tp 53
    movwf   RTCVALH,BANKED
    
    movlw   b'00000000'
    movwf   RTCCAL,BANKED                    ; RTCC calibration register do not use
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
    bcf   RTCCFG, RTCSYNC                   ;RTCVALH,RTCVALL and ALCFGRPT registers 
                                            ;can be read without concern over a rollover ripple
					    
    bsf   ALRMCFG, ALRMEN                   ; Enable alarm
    bsf   ALRMCFG, CHIME                    ; Enable chime 
    
    bcf   ALRMCFG, AMASK0                   ;set the alarm to once a day 0110
    bsf   ALRMCFG, AMASK1
    bsf   ALRMCFG, AMASK2
    bcf   ALRMCFG, AMASK3                  
    
     ;**********************************
    ; write to the Alarm Value Register 
    ;**********************************
    
    bsf   ALRMCFG, ALRMPTR1
    bcf   ALRMCFG, ALRMPTR0
    
    movlb  0x0f                                     ;select bank starting from address 0x0f
    movlw  0x15
    movwf  ALRMVALL,BANKED                          ; set alarm day to 15
    
    movlw  0x11
    movwf  ALRMVALH,BANKED                         ; set alarm month to November
    
    movlw  0x12
    movwf  ALRMVALL,BANKED                          ; set alarm hour to 12
    
    movlw  0x05                               
    movwf  ALRMVALH,BANKED                          ; set alarm weekday to Friday
    
    movlw  0x10
    movwf  ALRMVALL,BANKED                          ; set alarm second to 10
    
    movlw  0x53
    movwf  ALRMVALH,BANKED                          ; set alarm minute to 053
    
      
    movlw  b'00000000'  
    movwf  ALRMRPT,BANKED                           ;REPEAT ALARM for 0 more times 

    
    bsf   PIE3, RTCCIE                       ; enable RTCC interrupt
    bsf   INTCON, GIE                        ; enable all interrupt
    return

    end
