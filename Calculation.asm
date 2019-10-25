; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START
acs1    udata_acs   ; named variables in access ram
k0  res 1                           ; reserve one byte for A0 variable
k1  res 1
A0  res 1
A1  res 1
A2  res 1
A3  res 1
A4  res 1
bit1 res 1

    movlw high(0x418A)              ; store k value in A0 and A1
    movwf k1
    movlw low(0x418A)
    movwf k0
    
    movff ADRESH, A1                ; move the most significant of ADC measurement bit in A1 (?)
    movff ADRESL, A0                ; ~ least ~ in A0
    
    movf  k0, w
    mulwf A0                        ; k0 * A0 ->
                                    ; PRODH:PRODL
    movff PRODL, A2
    movff PRODH, A3
    
    mulwf A1                        ; k0 * A1
    movff PRODH, A5
    movff PRODL, A4
    
    movf k1, w     
    mulwf A0                        ; k1 * A0
    movff PRODH, A7
    movff PRODL, A6
    
    mulwf A1                        ; k1 * A1
    movff PRODH, A9
    movff PRODL, A8
    
    movf A3, w                      ; move A3 to w
    addwfc A4, 0, 0                 ; A3 + A4
    movwf A4                        ; move the rusult to A4
    
    movf A5, w                      ; move A5 to w
    addwfc A7, 0, 0                 ; A5 + A7
    movwf A7                        ; move the result to A7
    
    movf A4, w                      ; move A4 to w
    addwfc A6, 0, 0                 ; A4 + A6
    movwf A6                        ; move the result to A6
    
    movf A7, w                      ; move A7 to w
    addwfc A8, 0, 0                 ; A7 + A8
    movwf A8                        ; move the result to A8
    
    movf A9, w                      ; move A9 to w
    addlw 0x00                      ; A9 add nothing
    movwf bit1                      ; first decimal result 
    

    
    GOTO $                          ; loop forever

    end