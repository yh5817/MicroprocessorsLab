#include p18f87k22.inc

    global pwm0, pwm1
    extern wait_press, question

acs0    udata_acs	    ; named variables in access ram

PWM    code
    
pwm0 ; routine when press within 10s 
    call wait_press
    return
    
pwm1 ; routine when no press after 10s
    call question
    return 
    end


