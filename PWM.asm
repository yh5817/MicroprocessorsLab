#include p18f87k22.inc

    global buz0, buz_stop
    extern wait_press_1, LCD_Clear_Message, LCD_Display_Questions
    extern start, count1, count2
    global timer0_setup
    
acs0    udata_acs	    ; named variables in access ram
  
buz    code    
	
timer0	code
timer0_setup	
	clrf TRISB            ;clear
	clrf LATB
	
	bsf  T0CON,T08BIT    ;congifured as an 8-bit counter/timer
	bcf  T0CON,T0CS      ;internal clock FOSC/4, 64 MHz
	bcf  T0CON,PSA       ;prescaler is assigned
	
	bsf  T0CON,T0PS0     ; choose prescale value of 16    b'011
	bsf  T0CON,T0PS1 
	bcf  T0CON,T0PS2
	bsf  T0CON,TMR0ON     ;enable timer0
	bsf  INTCON,GIE        ;enable all interrupts 
	
	movlw 0xff             
        movwf count1
	movlw 0x00
	movwf count2
	return 
	
buzzer_off
	bcf INTCON,TMR0IE     ;disable timer_0 interrupt
        return
buzzer_on
	bsf INTCON,TMR0IE     ;enable timer_0 interrupt
        return
	
buz_stop ; stop buzzer
    call  LCD_Clear_Message 
    call  buzzer_off
    ;goto  start
    return
    
buz0 ; alarm event routinw 
    call buzzer_on
    call LCD_Clear_Message
    call wait_press_1
    call buz_stop
    return

    end


