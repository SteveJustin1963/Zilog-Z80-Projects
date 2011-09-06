;math subroutines -- Duane Attaway
;Ref: The Z80 Microcomputer Handbook, SAMS
; <*** Revision: Sun  08-04-1991  at 20:33:40 ***>   ;

;�����������������������������������������������������������������������������͸
;�mult16 Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine takes DE and BC to form a 32 bit product in DEHL             �
;�                                                                             �
;�����������������������������������������������������������������������������;
;
mult16      ld          a,16
            ld          hl,0
loop        ex          de,hl
            add         hl,hl
            push        af
            ex          de,hl
            add         hl,hl
            jp          nc,jump1
            inc         de
jump1       pop         af
            jp          nc,jump3
            add         hl,bc
jump2       jp          nc,jump3
            inc         de
jump3       dec         a
            ret         z
            jp          loop


;�����������������������������������������������������������������������������͸
;�dvde16 Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine takes HLDE devides by BC and returns the result in DE with   �
;�any remainder in HL.                                                         �
;�����������������������������������������������������������������������������;
;
dvde16      ld          a,16
loop        add         hl,hl
            ex          de,hl
            add         hl,hl
            ex          de,hl
            jp          nc,jump2
            inc         hl
jump1       or          a
            sbc         hl,bc
            inc         de
            jp          nc,jump2
            add         hl,bc
            res         0,e
jump2       dec         a
            jp          nz,loop
            ret


;�����������������������������������������������������������������������������͸
;�mpadd Subroutine:                                                            �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine provides n-precision adds.                                   �
;�                                                                             �
;�����������������������������������������������������������������������������;
;
mpadd       ld          b,0
            add         hl,bc
            dec         hl
            ex          de,hl
            add         hl,bc
            dec         hl
            ex          de,hl
            or          a
loop        ld          a,(de)
            adc         a,(hl)
            ld          (hl),a
            dec         hl
            dec         de
            dec         c
            jr          nz,loop
            ret

;�����������������������������������������������������������������������������͸
;�mpsub Subroutine:                                                            �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine provides n-precision adds.                                   �
;�                                                                             �
;�����������������������������������������������������������������������������;
;
mpadd       ld          b,0
            add         hl,bc
            dec         hl
            ex          de,hl
            add         hl,bc
            dec         hl
            ex          de,hl
            or          a
loop        ld          a,(de)
            sbc         a,(hl)
            ld          (hl),a
            dec         hl
            dec         de
            dec         c
            jr          nz,loop
            ret


;�����������������������������������������������������������������������������͸
;�asxbin Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts an ascii string of 0's and 1's to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
ascbin      ld          b,8
            ld          c,0
loop        sla         c
            ld          a,(hl)
            inc         hl
            sub         30h
            or          c
            ld          c,a
            djnz        loop
            ret

;�����������������������������������������������������������������������������͸
;�asxhex Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts two ascii hex characters into     a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
asxhex      ld          c,0
            ld          a,(hl)
            call        cvert
            inc         hl
            ld          a,(hl)
            call        cvert
            inc         hl
            ret
cvert       sla         c
            sla         c
            sla         c
            sla         c
            sub         30h
            cp          a,10
            jp          m,jump1
            sub         7
jump1       add         a,c
            ld          c,a
            ret

;�����������������������������������������������������������������������������͸
;�asxbcd Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts 2 ascii bcd values             to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
asxbcd      ld          a,(hl)
            inc         hl
            sub         30h
            rlca
            rlca
            rlca
            rlca
            ld          c,a
            ld          a,(hl)
            sub         30h
            add         a,c
            inc         hl
            ret

;�����������������������������������������������������������������������������͸
;�asxdec Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts 2 ascii bcd values             to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
asxdec      ld          b,5
            ld          hl,0
loop        add         hl,hl
            push        hl
            add         hl,hl
            add         hl,hl
            pop         de
            add         hl,de
            ld          a,(ix)
            sub         30h
            ld          e,a
            ld          d,0
            add         hl,de
            inc         ix
            djnz        loop
            ret

;�����������������������������������������������������������������������������͸
;�bxasb  Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts 2 ascii bcd values             to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
bxasb       ld          b,8
loop        ld          a,30h
            bit         7,c
            jp          z,jump1
            inc         a
jump1       ld          (hl),a
            sla         c
            inc         hl
            djnz        loop
            ret

;�����������������������������������������������������������������������������͸
;�bxash  Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts 2 ascii bcd values             to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
bxash       ld          a,$f0
            and         a,c
            rrca
            rrca
            rrca
            rrca
            call        cvert
            ld          a,$f0
            and         c
            call        cvert
            ret
cvert       add         a,30h
            cp          3ah
            jp          m,jump1
            add         a,7
jump1       ld          (hl),a
            inc         hl
            ret

;�����������������������������������������������������������������������������͸
;�bxbcd  Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts 2 ascii bcd values             to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
bxbcd       ld          a,$f0
            and         c
            rrca
            rrca
            rrca
            rrca
            add         a,30h
            ld          (hl),a
            inc         hl
            ld          a,$0f
            and         c
            add         a,30h
            ld          (hl),a
            inc         hl
            ret

;�����������������������������������������������������������������������������͸
;�bxdec  Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts 2 ascii bcd values             to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
bxdec       ld          iy,p10tab
loop0       xor         a
            ld          d,(iy+1)
            ld          e,(iy+0)
loop1       or          a
            sbc         hl,de
            jp          c,jump1
            inc         a
            jp          loop1
jump1       add         hl,de
            add         a,30h
            ld          (ix+0),a
            inc         ix
            inc         iy
            inc         iy
            ld          a,e
            cp          1
            jp          nz,loop0
            ret
p10tab      .dw         10000
            .dw         1000
            .dw         100
            .dw         10
            .dw         1

;�����������������������������������������������������������������������������͸
;�divide Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts 2 ascii bcd values             to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
divide      ld          hl,(divdnd)
            ld          a,(dvisor)
            neg
            ld          c,a
            ld          b,$ff
            ld          de,0
loop        add         hl,bc
            jr          nc,done
            inc         de
            jp          loop
done        ret

;�����������������������������������������������������������������������������͸
;�mult   Subroutine:                                                           �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts 2 ascii bcd values             to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
mult        ld          l,0
            ld          h,a
            ld          c,b
            ld          b,0
            ld          a,8
loop        add         hl,hl
            jr          nc,jump1
            add         hl,bc
jump1       dec         a
            jr          nz,loop
done        ret

;�����������������������������������������������������������������������������͸
;�divide8 Subroutine:                                                          �
;�Registers Used:                                                              �
;�Stack Used:                                                                  �
;�                                                                             �
;�This subroutine converts 2 ascii bcd values             to a binary number   �
;�into the A-Register.                                                         �
;�����������������������������������������������������������������������������;
;
devide8     ld          c,0
            ld          d,8
loop        add         hl,hl
            xor         a
            sbc         hl,bc
            inc         hl
            jp          nc,jump1
            add         hl,bc
            res         0,l
jump1       dec         d
            jr          nz,loop
done        ret