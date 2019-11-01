#include p18f87k22.inc

    global  
    
RTCC    code
    
RTCC_Setup
    bcf     ALRMCFG, ALRMEN   ; Disable alarm
    
    ;**********************************
    ; Enable RTCC Timer Access
    ;**********************************
    movlw   0x55
    movwf   EECON2
    movlw   0xAA
    movwf   EECON2
    bsf     RTCCFG, RTCWREN  ; Set bit to 1, enable wrting
    
    ;**********************************
    ; write to the RTCC timer
    ;**********************************
    bsf     RTCCFG, RTCPTR<1:0>
    movlw   0x07E3
    movwf   RTCVALL          ; Set year to 2019
    bcf     RTCCFG, RTCPTR0
    movlw   0xB
    movwf   RTCVALH          ; Set month to November
    movlw   0x1       
    movwf   RTCVALL          ; Set day to 1st
    btg     RTCCFG, RTCPTR<1:0>
    movlw   0x5
    movwf   RTCVALH          ; Set Weekday to Fri
    movlw   0xA
    movwf   RTCVALL          ; Set hour to 10
    bcf     RTCCFG, RTCPTR<1:0>
    movlw   0x34
    movwf   RTCVALH          ; Set minute to 52
    movlw   0x00
    movwf   RTCVALL          ; Set second to 00
    
    ;**********************************
    ; Enable RTCC module
    ;**********************************
    bsf     RTCCFG, RTCEN    ; Enable RTCEN
    
    ;**********************************
    ; Disable RTCC timer access
    ;**********************************
    bcf     RTCCFG, RTCWREN   ; Clear RTCWREN bit 
    


    end