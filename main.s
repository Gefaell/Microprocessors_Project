
#include <xc.inc>

psect	udata_acs
old_data: ds 1
threshold: ds 1

psect	code, abs

extrn int_Setup, int_resp, mag_Setup, mag_read, xl_data, xh_data, yl_data, yh_data, zl_data, zh_data, SPI_MasterInit, SPI2_MasterInit, cont_Setup
main:
	org	0x00
	goto	setup
	
int_hi:	org	0x0008	; high vector, no low vector
	goto	int_resp
	
setup:	org	0x100	; Main code starts here at address 0x100
	movlw	0xf0	
	movwf	TRISF, A    ; set first four PortF pins to 1 (set them as inputs) and the other four to 0 (outputs)
	movlw	0x02	    ;set to 0x01 to turn on LED
	movwf	LATF, A
	call	int_Setup
	call	SPI_MasterInit ; SPI 1 call
	call	mag_Setup
	call	SPI2_MasterInit ; SPI 2 call
	call	cont_Setup
	movlw	0b00000001 ;setting threshold value of xh 
	movwf	threshold, A
	
read:	call	mag_read
	movlw	0x00 ; sets PORTH as output
	movwf	TRISH, A
	movff	xh_data, PORTH
	movff	xh_data, old_data
	
	call	mag_read
	movlw	0x00 ; sets PORTJ as output
	movwf	TRISJ, A
	movff	xh_data, PORTJ
	movf	xh_data, W, A
	subwf	old_data, 1 ; subtracted value stored in xl_data
	movf	threshold, W, A
	cpfsgt	xh_data ;subtracted value compared with WREG (threshold value)
	bra	turn_off
	goto	read

turn_off:
	movlw	0x00		;set to 0x00 to turn off LED
	movwf	PORTF, A	

start:  
	goto	$

;delay:	decfsz	0x20, F, A
	;bra delay
	;return 0




