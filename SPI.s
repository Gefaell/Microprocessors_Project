
#include <xc.inc>
	
global	SPI_MasterInit, SPI_MasterTransmit
    
psect	SPI_code, class=CODE 
    
SPI_MasterInit:	; Set Clock edge to negative	
    bcf	CKE2	; CKE bit in SSP2STAT,	
    ; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)	
    movlw 	(SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)	
    movwf 	SSP2CON1, A	; SDO2 output; SCK2 output	
    bcf	TRISD, PORTD_SDO2_POSN, A	; SDO2 output of microcontroller/input of magnetometer (RD4)
    bsf	TRISD, 5, A	; SDI2 input of microcontroller/output of magnetometer (RD5)
    bcf	TRISD, PORTD_SCK2_POSN, A	; SCK2 output of microcontroller (RD6)
    bcf	TRISD, 7, A	; SS2 output of microcontroller/input of magnetometer(RD7)
    return 

SPI_MasterTransmit:  ; Start transmission of data (held in W)	
    movwf 	SSP2BUF, A 	; write data to output buffer
Wait_Transmit:	; Wait for transmission to complete
    btfss 	SSP2IF		; check interrupt flag to see if data has been sent	
    bra 	Wait_Transmit	
    bcf 	SSP2IF		; clear interrupt flag
    return 

 


