#include p18f87k22.inc
    
	global RTCC_Setup
	
        org  0x00
	goto start
start
	
acs0    udata_acs   ; named variables in access ram
year        res 1             ; reserve 1 byte for variable year
month_date  res 1             ; reserve 1 byte for variable month_date 
wday_hour   res 1             ; reserve 1 bype for variable wday_hour
min_sec     res 1             ; reserve 1 byte for variable min_sec

RTCC    code   
RTCC_Setup
         bcf   ALRMCFG, ALRMEN   ; Disable alarm
    
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
    bsf     RTCCFG, RTCPTR1
    bsf     RTCCFG, RTCPTR0
    movlw   0x7
    movwf   RTCVALH       
    movlw   0xE3 
    movwf   RTCVALL          ; Set year to 2019
    movff   RTCVAL, year    ; move 2019 to variable year
    bcf     RTCCFG, RTCPTR0
    movlw   0xB
    movwf   RTCVALH          ; Set month to November
    movlw   0x1       
    movwf   RTCVALL          ; Set day to 1st
    movff   RTCVAL, month_date; move month and day to variable 
    btg     RTCCFG, RTCPTR1
    btg     RTCCFG, RTCPTR0
    movlw   0x5
    movwf   RTCVALH          ; Set Weekday to Fri
    movlw   0xA
    movwf   RTCVALL          ; Set hour to 10
    movff   RTCVAL, wday_hour; met weekday and hour to variable
    bcf     RTCCFG, RTCPTR1
    bcf     RTCCFG, RTCPTR0
    movlw   0x34
    movwf   RTCVALH          ; Set minute to 52
    movlw   0x00
    movwf   RTCVALL          ; Set second to 00
    movff   RTCVAL, min_sec  ; move minute and second to variable
    
    ;**********************************
    ; Enable RTCC module
    ;**********************************
    bsf     RTCCFG, RTCEN    ; Enable RTCEN
    
    ;**********************************
    ; Disable RTCC timer access
    ;**********************************
    bcf     RTCCFG, RTCWREN   ; Clear RTCWREN bit 
    


    end