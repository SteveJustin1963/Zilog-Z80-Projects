#include grout.exp


;嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;�Compiled for Zilog Z80-C using standard Zilog peripherals.                   �
;�All values are in HEX unless otherwise noted.                                �
;�Requires include file "grout.exp" screen driver.                             �
;�                                                                             �
;�                                                                             �
;塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;

;嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;�main                                                                         �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This program provides support for a Microsoft Serial Mouse through a serial  �
;�port.                                                                        �
;塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;


;嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;�mousetest Subroutine:                                                        �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This subroutine provides a diagnostic procedure to determine reliable        �
;�mouse operation.                                                             �
;塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;
mousetest
            ret


;嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;�mouseset Subroutine:                                                         �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This subroutine changes the mouse speed parameters with the value determined �
;�in Register-A.  Register-A determines speed: 0-Slowest, FF-Fastest           �
;塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;
mouseset
            ret

;嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;�mousesetg Subroutine:                                                        �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This subroutine graphically adjusts the mouse speed through a temporary      �
;�window.                                                                      �
;塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;


;嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;�pushwin Subroutine:                                                          �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�                                                                             �
;塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;
;嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;�mouseinit                                                                    �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This subroutine initializes this mouse driver and the serial port for        �
;�1200 baud necessary for its proper communication.                            �
;塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
;
;                        12345678901234567890123456789012
mousebanner .text       "Microsoft Mouse Driver Installed\r\000"
mouseerr    .text       "Please plug in Microsoft mouse\r\r\000"

mouseinit
            ld          hl,mousebanner
            call        prtstg
            ret

            .end
