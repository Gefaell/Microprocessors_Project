
#include <xc.inc>
	
global	mag_Setup, mag_read, xl_data, xh_data, yl_data, yh_data, zl_data, zh_data
extrn SPI_MasterInit, SPI_MasterTransmit

psect	udata_acs
xl_data: ds 1
xh_data: ds 1
    
yl_data: ds 1
yh_data: ds 1
    
zl_data: ds 1
zh_data: ds 1

psect	mag_code, class=CODE

mag_Setup:
    
    bcf	    LATD7   ; CS enable
    
    ;Configuring CTRL_REG1_M
    movlw   0b00100000    ;00 100000. First 2 are R/W (read or write) and MS (fixed address or autoincrement) --> write and fixed
		    ; The rest is the address of the CTRL_REG1_M register (it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit first 8 bits of our SPI write instruction (which includes the address of the CTRL_REG1_M register)
    movlw   0b10011100    ; 10011100 (binary) to set TEMP_COMP on, output data rate to 80 Hz (other values are default)
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    nop
    nop
    nop
    bcf	    LATD7   ; CS enable
   
    ;Configuring CTRL_REG2_M
    movlw   0b00100001    ; 00 100001. First 2 are R/W (read or write) and MS (fixed address or autoincrement) --> write and fixed
		    ; The rest is the address of the CTRL_REG2_M register (it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit first 8 bits of our SPI write instruction (which includes the address of the CTRL_REG2_M register)
    movlw   0b01100000    ; 01100000 (binary) to set full-scale configuration to +/- 16 gauss (other values are default)
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    nop
    nop
    nop
    bcf	    LATD7   ; CS enable
    
    ;Configuring CTRL_REG3_M
    movlw   0b00100010    ; 00 100010. First 2 are R/W (read or write) and MS (fixed address or autoincrement) --> write and fixed
		    ; The rest is the address of the CTRL_REG3_M register (it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit first 8 bits of our SPI write instruction (which includes the address of the CTRL_REG3_M register)
    movlw   0b10000000    ; 10000111 (binary) to disable I2C interface and enable the SPI read operations (other values are default)
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    nop
    nop
    nop
    bcf	    LATD7   ; CS enable
    
    ;Configuring CTRL_REG5_M
    movlw   0b00100100    ; 00 100100. First 2 are R/W (read or write) and MS (fixed address or autoincrement) --> write and fixed
		    ; The rest is the address of the CTRL_REG5_M register (it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit first 8 bits of our SPI write instruction (which includes the address of the CTRL_REG5_M register)
    movlw   0b10000000    ; 10000000 (binary) to enable FAST_READ (other values are default)
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    
    return
    
    
mag_read:
    ; OUT_X_L_M, OUT_X_H_M are the registers where we can read the x-axis data output
    ; OUT_Y_L_M, OUT_Y_H_M are the registers where we can read the y-axis data output
    ; OUT_Z_L_M, OUT_Z_H_M are the registers where we can read the z-axis data output
    
    bcf	    LATD7   ; CS enable
    
    ;Configuring OUT_X_L_M, OUT_X_H_M
    movlw   0b10101000    ; 10 101000. First 2 are R/W (read or write) and MS (fixed address or autoincrement)--> read and fixed
		    ; The rest is the address of the OUT_X_L_M register(it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit first 8 bits of our SPI read instruction
    movlw   0x00    ; send 0x00 because I am reading
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    nop
    movff   SSP2BUF, xl_data
    nop
    bcf	    LATD7   ; CS enable
    
    movlw   0b10101001    ; 10 101001. First 2 are R/W (read or write) and MS (fixed address or autoincrement)--> read and fixed
		    ; The rest is the address of the OUT_X_H_M register(it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit remaining 8 bits of our SPI read instruction
    movlw   0x00    ; send 0x00 because I am reading
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    nop
    movff   SSP2BUF, xh_data
    nop
    bcf	    LATD7   ; CS enable
    
    ;Configuring OUT_Y_L_M, OUT_Y_H_M
    movlw   0b10101010    ; hexadecimal of 10 101010. First 2 are R/W (read or write) and MS (fixed address or autoincrement)--> read and fixed
		    ; The rest is the address of the OUT_Y_L_M register(it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit first 8 bits of our SPI read instruction
    movlw   0x00    ; send 0x00 because I am reading
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    nop
    movff   SSP2BUF, yl_data
    nop
    bcf	    LATD7   ; CS enable
    
    movlw   0b10101011    ; hexadecimal of 10 101011. First 2 are R/W (read or write) and MS (fixed address or autoincrement)--> read and fixed
		    ; The rest is the address of the OUT_Y_H_M register(it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit remaining 8 bits of our SPI read instruction
    movlw   0x00    ; send 0x00 because I am reading
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    nop
    movff   SSP2BUF, yh_data
    nop
    bcf	    LATD7   ; CS enable
    
    ;Configuring OUT_Z_L_M, OUT_Z_H_M
    movlw   0b10101100    ; hexadecimal of 10 101100. First 2 are R/W (read or write) and MS (fixed address or autoincrement)--> read and fixed
		    ; The rest is the address of the OUT_Z_L_M register(it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit first 8 bits of our SPI read instruction
    movlw   0x00    ; send 0x00 because I am reading
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    nop
    movff   SSP2BUF, zl_data
    nop
    bcf	    LATD7   ; CS enable
    
    movlw   0b10101101    ; hexadecimal of 10 101101. First 2 are R/W (read or write) and MS (fixed address or autoincrement)--> read and fixed
		    ; The rest is the address of the OUT_Z_H_M register(it is just 6 bits because the first 2 are always zero)
    call    SPI_MasterTransmit	; transmit remaining 8 bits of our SPI read instruction
    movlw   0x00    ; send 0x00 because I am reading
    call    SPI_MasterTransmit
    
    bsf	    LATD7   ; CS disable
    movff   SSP2BUF, zh_data
    
    return


