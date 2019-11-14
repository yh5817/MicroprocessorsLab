#include p18f87k22.inc

    global pwm0, pwm_stop
    extern wait_press_1, LCD_Clear_Message, LCD_Display_Questions
    extern start
    global timer0_setup, count2
    
acs0    udata_acs	    ; named variables in access ram
count1  res  1              ; reserve one byte for count1
count2  res  1              ; reserve one byte for count2
  
PWM    code    
int_hi  code 0x0008             ; setting up interrupt 
        btfss  INTCON, TMR0IF   ;bit test file, skip if set, check the timer0 interrupt 
	retfie FAST  
	btg    LATB, RB6
	decf   count1
	movlw  0x00
	cpfsgt  count1          ; when count1 decrements to 00       
	incf    count2          ; count2 increments 1
	bcf    INTCON,TMR0IF     ;clear interrupt flag
	retfie FAST              ;fast return from interrupt 
	
timer0	code
timer0_setup	
	clrf TRISB
	clrf LATB
	
	bsf  T0CON,T08BIT    ;congifured as an 8-bit counter/timer
	bcf  T0CON,T0CS      ;internal clock FOSC/4
	bcf  T0CON,PSA       ;prescaler is assigned
	
	bsf  T0CON,T0PS0     ; choose prescale value of 4    b'001
	bsf  T0CON,T0PS1 
	bcf  T0CON,T0PS2
	bsf  T0CON,TMR0ON    ;enable timer0
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
	
pwm_stop ; stop buzzer
    bcf   PIR3, RTCCIF
    call  LCD_Clear_Message 
    call  buzzer_off
    goto  start
    
    
pwm0 ; alarm event routinw 
    call buzzer_on
    call LCD_Clear_Message
    call wait_press_1
    return

    end


