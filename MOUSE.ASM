#include grout.exp


;�����������������������������������������������������������������������������͸
;�Compiled for Zilog Z80-C using standard Zilog peripherals.                   �
;�All values are in HEX unless otherwise noted.                                �
;�Requires include file "grout.exp" screen driver.                             �
;�                                                                             �
;�                                                                             �
;�����������������������������������������������������������������������������;
;

;�����������������������������������������������������������������������������͸
;�main                                                                         �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This program provides support for a Microsoft Serial Mouse through a serial  �
;�port.                                                                        �
;�����������������������������������������������������������������������������;
;


;�����������������������������������������������������������������������������͸
;�mousetest Subroutine:                                                        �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This subroutine provides a diagnostic procedure to determine reliable        �
;�mouse operation.                                                             �
;�����������������������������������������������������������������������������;
;
mousetest
            ret


;�����������������������������������������������������������������������������͸
;�mouseset Subroutine:                                                         �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This subroutine changes the mouse speed parameters with the value determined �
;�in Register-A.  Register-A determines speed: 0-Slowest, FF-Fastest           �
;�����������������������������������������������������������������������������;
;
mouseset
            ret

;�����������������������������������������������������������������������������͸
;�mousesetg Subroutine:                                                        �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This subroutine graphically adjusts the mouse speed through a temporary      �
;�window.                                                                      �
;�����������������������������������������������������������������������������;
;


;�����������������������������������������������������������������������������͸
;�pushwin Subroutine:                                                          �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�                                                                             �
;�����������������������������������������������������������������������������;
;
;�����������������������������������������������������������������������������͸
;�mouseinit                                                                    �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�This subroutine initializes this mouse driver and the serial port for        �
;�1200 baud necessary for its proper communication.                            �
;�����������������������������������������������������������������������������;
;
;                        12345678901234567890123456789012
mousebanner .text       "Microsoft Mouse Driver Installed\r\000"
mouseerr    .text       "Please plug in Microsoft mouse\r\r\000"

mouseinit
            ld          hl,mousebanner
            call        prtstg
            ret

            .end