#include <xc.inc>
	
global	int_Setup, int_resp
    
psect	interrupt_code, class=CODE
	

int_Setup:
    bsf	TRISB, 1, A ; set pin 1 of PORTB as input
    bcf	INT1IF ; clear interrupt flag for pin 1 in PORTB
    bsf	INT1IE; rising edge interrupt
    bsf	INTEDG1
    bsf	GIE ; start global interrupts
    return
    
int_resp:
    btfss       INT1IF
    retfie      f
    movlw	0x00		;set to 0x00 to turn off LED
    movwf	PORTF, A
    bcf	        INT1IF		; clear interrupt flag for pin 1 in PORTB
    retfie	f		; fast return from interrupt


