#include <xc.inc>
	
extrn SPI2_MasterInit, SPI2_MasterTransmit

global cont_Setup

psect	cont_code, class=CODE
    
;_REGISTER_LIST
        ;# CONFIG
        ;"HB_ACT_1_CTRL"    : 0b00000,
        ;"HB_ACT_2_CTRL"    : 0b10000,
        ;"HB_ACT_3_CTRL"    : 0b01000,
        ;"HB_MODE_1_CTRL"   : 0b11000,
        ;"HB_MODE_2_CTRL"   : 0b00100,
        ;"HB_MODE_3_CTRL"   : 0b10100,
        ;"PWM_CH_FREQ_CTRL" : 0b01100,
        ;"PWM1_DC_CTRL"     : 0b11100,
        ;"PWM2_DC_CTRL"     : 0b00010,
        ;"PWM3_DC_CTRL"     : 0b10010,
        ;"FW_OL_CTRL"       : 0b01010,
        ;"FW_CTRL"          : 0b11010,
        ;"CONFIG_CTRL"      : 0b11001,
        ;# STATUS
        ;"SYS_DIAG_1"       : 0b00110,
        ;"SYS_DIAG_2"       : 0b10110,
        ;"SYS_DIAG_3"       : 0b01110,
        ;"SYS_DIAG_4"       : 0b11110,
        ;"SYS_DIAG_5"       : 0b00001,
        ;"SYS_DIAG_6"       : 0b10001,
        ;"SYS_DIAG_7"       : 0b01001

cont_Setup:
    
    bcf	    LATE0   ; CS enable
    
    ;Configuring HB_MODE_1_CTRL
    movlw   0b11100001 ; first bit is R/W. Set to write. Second to last bit is the Last Address Bit Token (LABT). In Daisy Chain operation, the LABT bit of the last address byte must be 1.
    call    SPI2_MasterTransmit
    movlw   0b00001001    ;Assign PWM channel 1 to half-bridge 1 and channel 2 to half-bridge 2
    call    SPI2_MasterTransmit
    
    bsf	    LATE0   ; CS disable
    nop
    nop
    nop
    bcf	    LATE0   ; CS enable
    
    ;Configuring HB_ACT_1_CTRL
    movlw   0b10000001 ; first bit is R/W. Set to write. Second to last bit is the Last Address Bit Token (LABT). In Daisy Chain operation, the LABT bit of the last address byte must be 1.
    call    SPI2_MasterTransmit
    movlw   0b00001010    ;Enable the high sides of half-bridges 1, 2
    call    SPI2_MasterTransmit
    
    bsf	    LATE0   ; CS disable
    nop
    nop
    nop
    bcf	    LATE0   ; CS enable
    
    ;Configuring PWM_CH_FREQ_CTRL
    movlw   0b10110001 ; first bit is R/W. Set to write. Second to last bit is the Last Address Bit Token (LABT). In Daisy Chain operation, the LABT bit of the last address byte must be 1.
    call    SPI2_MasterTransmit
    movlw   0b00000101    ;Set the frequency of PWM channel 1 and 2 to 80 Hz
    call    SPI2_MasterTransmit
    
    bsf	    LATE0   ; CS disable
    nop
    nop
    nop
    bcf	    LATE0   ; CS enable
    
    ;Configuring PWM1_DC_CTRL
    movlw   0b11110001 ; first bit is R/W. Set to write. Second to last bit is the Last Address Bit Token (LABT). In Daisy Chain operation, the LABT bit of the last address byte must be 1.
    call    SPI2_MasterTransmit
    movlw   0b11111111    ;Duty cycle of channel 1 set to 100%
    call    SPI2_MasterTransmit
    
    bsf	    LATE0   ; CS disable
    nop
    nop
    nop
    bcf	    LATE0   ; CS enable
    
    ;Configuring FW_OL_CTRL 
    movlw   0b10101001 ; first bit is R/W. Set to write. Second to last bit is the Last Address Bit Token (LABT). In Daisy Chain operation, the LABT bit of the last address byte must be 1.
    call    SPI2_MasterTransmit
    movlw   0b00000011    ;Set LED mode
    call    SPI2_MasterTransmit
    
    bsf	    LATE0    ; CS disable
    
    return



