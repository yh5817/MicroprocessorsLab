#include p18f87k22.inc

    global pwm0, pwm1, pwm_stop
    extern wait_press, wait_10, question, LCD_Clear_Message, LCD_Display_Questions
    extern start

acs0    udata_acs	    ; named variables in access ram

PWM    code

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


