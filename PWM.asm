#include p18f87k22.inc

    global pwm0, pwm1, pwm_stop
    extern wait_press, wait_10, question, LCD_Clear_Message, LCD_Display_Questions
    extern start
    global timer0_setup
    
acs0    udata_acs	    ; named variables in access ram
ntoggle res  1  
PWM    code    

int_hi  code 0x0008
        btfss  INTCON, TMR0IF   ;bit test file, skip if set, check the timer0 interrupt 
	retfie FAST  
	movlw  0x03
        movwf  ntoggle; if not then return
	decf ntoggle   ;every interrupt, decrements value by 1
	cpfseq ntoggle  ;if ntoggle=4 skip the clearing port b
	clrf LATB        ;clearing port b
	movlw b'01000000'   ;set up RB6
	movwf TRISB         ;set RB6 as output
	bcf    INTCON,TMR0IF     ;clear interrupt flag
	retfie FAST              ;fast return from interrupt 
	
timer0	code
timer0_setup	
	clrf TRISB
	clrf LATB
	bsf  T0CON,TMR0ON    ;enable timer0
	bsf  T0CON,T08BIT    ;congifured as an 8-bit counter/timer
	bcf  T0CON,T0CS      ;internal clock FOSC/4
	bcf  T0CON,PSA       ;prescaler is assigned
	
	bsf  T0CON,T0PS0     ; choose prescale value of 4    b'001
	bcf  T0CON,T0PS1 
	bcf  T0CON,T0PS2
	bsf  INTCON,TMR0IE     ;enable timer0 interrupts
	bsf  INTCON,GIE        ;enable all interrupts 
	return 

pwm_stop ; stop pwm
    bcf   PIR3, RTCCIF
    call  LCD_Clear_Message 
    goto  start
    
    
pwm0 ; routine when press within 10s 
    call LCD_Clear_Message
    call LCD_Display_Questions
    ;bra  pwm0
    call wait_press
    return
    
pwm1 ; routine when no press after 10s
    call question
    return 
    end


