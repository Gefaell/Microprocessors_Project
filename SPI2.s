
#include <xc.inc>
	
global	SPI2_MasterInit, SPI2_MasterTransmit
    
psect	SPI2_code, class=CODE  
    
SPI2_MasterInit:	; Set Clock edge to negative	
    bcf	CKE1	; CKE bit in SSP2STAT,	
    ; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)	
    movlw 	(SSP1CON1_SSPEN_MASK)|(SSP1CON1_CKP_MASK)|(SSP1CON1_SSPM1_MASK)	
    movwf 	SSP1CON1, A	; SDO2 output; SCK2 output	
    bcf	TRISC, PORTC_SDO1_POSN, A ; MOSI	
    bsf	TRISC, 4, A	; MISO
    bcf	TRISC, PORTC_SCK1_POSN, A ; SCK
    bcf	TRISE, 0, A	; CS
    return 

SPI2_MasterTransmit:  ; Start transmission of data (held in W)	
    movwf 	SSP1BUF, A 	;SSP2 buffer used in other SPI so should be able to use SSP1BUF write data to output buffer 
Wait2_Transmit:	; Wait for transmission to complete
    btfss 	SSP1IF		;SSP2IF interrupt flag used by other SPI check interrupt flag to see if data has been sent	
    bra 	Wait2_Transmit	
    bcf 	SSP1IF		; clear interrupt flag
    return 

 





