;*******************************************************************************
; XMODEM TRANSFER PROGRAM
; EDM-80 w/ RS232  UART INTERFACE REQUIRED
; This program is intended for communication at 1200 baud, no parity, eight
; bits per word, and one stop bit for serial communication.
;
;
;*******************************************************************************
;
;*** SYSTEM LOCATIONS ***
txport      .equ        $01       
rxport      .equ        $02     
status      .equ        $03
vidram      .equ        $4000
ramstart    .equ        $6250
xlen        .equ        $20

;*** ASCII and XMODEM PARAMETERS ****
ack         .equ        $06         ;affirmed acknowledge flag
nak         .equ        $15         ;negative acknowledge flag
eot         .equ        $04         ;end of transmission flag
return      .equ        $0d
maxtries    .equ        10          ;maximum tries before giving up
timeout     .equ        2           ;time in seconds for a "catch up"
blocklen    .equ

;*** EDM SUBROUTINES ***
#define     CHRIN       RST         18H         ;macro for EDM keyboard input
#define     CHROUT      RST         10H         ;macro for EDM chr video output
#define     CLS         CALL        $BC         ;macro for EDM clear screen
prtstg      .equ        $d1


;*******************************************************************************
; MAIN:
; Registers Used:
; Stack Used:
; This routine impliments a XMODEM protocall download from a UART interface.
; Among the XMODEM features are automatic error detection and correcting, binary
; download, and retries during unexpected inactive transmission periods.
; Full on-screen progress messages and prompts are provided to the user.
;
;*******************************************************************************
;
main        .org        ramstart    ;program start
            call        setparms    ;setup 1200
            call        about       ;display name, rank, and serial number
            call        initialize  ;set up the first run for block reception

;no_ack  -- this routine initiates the first handshake to the transmitter and
;           expects an answer.  If the transmitter spits something back, the
;           next routine, "byteone", is run.  If it takes forever for this to
;           happen, the "oops" routine will go into effect, saving an endless
;           loop.

no_ack      call        outnak      ;handshake transmitter that we're here
            call        rx          ;see what's going on with the data stream
            jr          nz,byteone  ;must be the first byte of a block...
            ld          a,'x'
            CHROUT
retryone    call        timeupdate  ;evaluate alloted time for a retry
            jr          z,no_ack    ;keep trying to get ahold of something
            ld          hl,0        ;reset the time-out clock
            ld          (timeclock),hl
            jr          no_ack
            jp          oops        ;waited too long --gethelloutahere

;byteone -- this routine checks the block number syntax for validity and updates
;           if the blocks are synced.
byteone     ld          a,1         ;soh compare
                                    ;it should be "1" for the first block here!
            jr          z,readin    ;start reading in if this is the right one.
            cp          eot         ;check for end of transmission
            jr          z,eotdone
            jr          retryone    ;garbage?!! Retry on first block

;readin  -- this routine reads in a block and performs necessary checks to
;           ensure the block is valid.  The second character in the block which
;           this routine reads, is a one's compliment of the block number --a
;           simple double check that this really is a valid block.  After a
;           block of 128 characters are read in, the BCC is checked against the
;           transmitted BCC for possible errors.
buffercrp   .ds         2           ;current pointer for ram write buffer
bufferstp   .ds         2           ;beginning pointer for ram write buffer
                                    ;--used if there was a mess-up

readin      ld          hl,bufferstp;initialize beginning of block
            ld          a,'y'
            CHROUT

            call        dispblock   ;display block status

            call        rx          ;get the next character
            call        compareblk  ;check for current block number
            jr          z,blockok   ;block allright, continue on...

                                    ;reset to beginning of block again and try
            ld          a,'z'
            CHROUT
                                    ;over.
            ld          hl,(bufferstp)
            ld          (buffercrp),hl
            jp          no_ack      ;send the "bad-handshake" and start decoding
                                    ;another block.

blockok     call        rx
            call        compones    ;check for one's compliment
            jp          nz,no_ack    ;redo if we are strolling through garbage

;The beginning of the block has now sucessfully passed the syntax requirments,
;so read it on in to the memory:
                                    ;current buffer pointer
            ld          hl,(buffercrp)
            ld          b,blocklen  ;get the length of the block
nextbyte    ld          c,(checksum);get the current running checksum
            call        rx          ;fetch incoming byte
            ld          (hl),a      ;put it into the buffer

            add         a,c         ;sophisticated BCC checksum calculation

            ld          (checksum),a;update BCC checksum
            inc         hl          ;increment current working buffer
            djnz        nextbyte    ;finish off current block

;OK, so the block got read.  Now pull off the checksum out of the serial line
;and compare it to what we got.  If they ain't equal, we'ed been had!
            ld          c,a        ;mov BCC into C-Reg for comparison
            call        rx          ;get that BCC checksum
            cp          c           ;equal?
            jr          z,nextblock ;OK? Go for another!

                                    ;reset to the beginning of the buffer
                                    ;and start over!
            ld          hl,(bufferstp)
            ld          (buffercrp),hl
            jp          no_ack      ;send bad-handshake and do block over

;Increment the block number, reset the checksum, and go for a full set of
;retries, since a block got read in sucessfully.
nextblock   ld          a,(block)   ;increment the block number.
            inc         a
            ld          (block),a
            xor         a           ;clear the checksum.
            ld          (checksum),a
            ld          a,maxtries  ;reset the maximum number of tries
            ld          (triesc),a
                                    ;update the buffer start pointer.
            ld          (bufferstp),hl
            call        outack
            jp          retryone    ;go for another one.

eotdone     call        nak
            ld          hl,donemsg
            call        prtstg
            jp          main_exit

donemsg     .text       "TRANSMISSION RECEIVED\000"

main_exit   ret                     ;RETURN TO MONITOR HERE

block       .ds         1
prhex       .equ        $f2


;*******************************************************************************
; compareblk Subroutine:
; Registers Used:
; Stack Used:
;
;
;
;*******************************************************************************
;            
compareblk  push        hl
            ld          hl,block
            cp          (hl)
            pop         hl
            ret

;*******************************************************************************
; dispblock Subroutine:
; Registers Used:
; Stack Used:
; This subroutine displays the current block number to the screen.
;
;*******************************************************************************
;


dispblock   push        af
            push        hl
            ld          hl,blockmsg
            call        prtstg
            ld          a,(block)
            call        prhex
            ld          a,return
            CHROUT
            pop         hl
            pop         af
            ret

blockmsg    .text       "Reading block \000"

;*******************************************************************************
; compare Subroutine:
; Registers Used:
; Stack Used:
; This subroutine compares the current running checksum in the A-Register
; to the checksum coming in through the serial port.
;
;
;*******************************************************************************
;
compare     push        hl
            ld          hl,checksum
            cp          (hl)
            pop         hl
            ret
;*******************************************************************************
; setparms Subroutine:
; Registers Used:
; Stack Used:
;
;
;
;*******************************************************************************
;
setparms    push        af
            ld          e,2
            ld          d,8
            ld          a,3
            RST         08H
            pop         af
            ret



;*******************************************************************************
; compones Subroutine:
; Registers Used:
; Stack Used:
; This subroutine compars the current running checksum compliment in the A-Reg
; to the checksum coming in through the serial port.
;
;*******************************************************************************
;
compones    cpl
            push        hl
            ld          hl,checksum
            cp          (hl)
            pop         hl
            ret

;*******************************************************************************
; timeupdate Subroutine:
; Registers Used:
; Stack Used:
; This subroutine updates the time counter and returns a carry flag if no time
; is left.
;
;*******************************************************************************
;
timeclock   .ds         2

timeupdate  push        hl          ;fetch time
            ld          hl,(timeclock)
            inc         l           ;incrment time remaining
            ld          a,0
            adc         a,h
            ld          h,a

            ld          a,h         ;check to see if HL wrapped around to zero
            or          l           ;if time ran out
            pop         hl
            ret

;*******************************************************************************
; oops Subroutine:
; Registers Used:
; Stack Used:
; This subroutine alerts the user that a time out has occured.
;
;*******************************************************************************
;
oops        push        af
            push        hl
            ld          hl,oopsmsg
            call        prtstg
            pop         hl
            pop         af
            ret

oopsmsg     .text       "\rTIME OUT\r\000"



;*******************************************************************************
; outnak Subroutine
; Registers Used:
; Stack Used:
; This subroutine places the NAK flag out to the serial port.
;
;*******************************************************************************
;
outnak      push        af
            ld          a,nak
            call        tx
            pop         af
            ret

;*******************************************************************************
; outack Subroutine
; Registers Used:
; Stack Used:
; This subroutine places the ACK flag out to the serial port.
;
;*******************************************************************************
;
outack      push        af
            ld          a,ack
            call        tx
            pop         af
            ret

;*******************************************************************************
; tx Subroutine
; Registers Used:
; Stack Used:
; This subroutine waits and places the A-Register character out to the UART when
; it can.
;
;*******************************************************************************
;
tx          push        af
            ld          a,2
            RST         30H
            pop         af
            CHROUT
            ld          a,0
            RST         30H
            ret

;*******************************************************************************
; rx Subroutine
; Registers Used:
; Stack Used:
; This subroutine fetches a character from the UART if available.  If no
; character is found, the zero-flag will be set.
;
;*******************************************************************************
;
rx          ld          a,2
            RST         30H
            CHRIN
            push        af
            ld          a,0
            RST         30H
            pop         af
            ret


;*******************************************************************************
; about Subroutine
; Registers Used:
; Stack Used:
;
;
;*******************************************************************************
;
about       CLS
            ld          hl,aboutmsg
            call        prtstg
            ld          a,return
            CHROUT
            CHROUT
            ret

aboutmsg    .text       "\rDUANE ATTAWAY\r"
            .text       "8DA-EET462L\r"
            .text       "XMODEM TRANSFER DEMO\000"

;*******************************************************************************
; initialize Subroutine
; Registers Used:
; Stack Used:
;
;
;*******************************************************************************
;
blockone    .equ        1

initialize  ld          a,blockone  ;first XMODEM block number tag
            ld          (block),a
            ld          hl,buffer   ;initial destination for first block
            ld          (buffercrp),hl
                                    ;pointer for the current buffer writes
            ld          (bufferstp),hl
                                    ;pointer for the current block starting byte
            ld          hl,0        ;initialize block check to null
            ld          (checksum),hl
            ld          a,maxtries  ;maximum number of tries allowed
            ld          (triesc),a
            ret

;*******************************************************************************
; delay Subroutine
; Registers Used:
; Stack Used:
; This subroutine pauses for A-Register number of seconds.
;
;*******************************************************************************
;
delay       inc         a
delayloop   dec         a           ;return if no more seconds are left
            ret         z
            call        delay2      ;delay module
            jr          delayloop

;*******************************************************************************
; delay2 Subroutine
; Registers Used:
; Stack Used:
; This subroutine waits for approximately one second of time to pass.
;
;*******************************************************************************
;
delay2      push        af          ;destroy no registers or flags on this one
            push        hl
            ld          hl,0        ;start out initial delay

delay2l     dec         hl          ;actual delay loop
            ld          a,l
            or          h           ;16 bit zero check
            jr          nz,delay2l  ;time left?

            pop         hl          ;restore those flags and registers
            pop         af
            ret

triesc      .ds         1
checksum    .ds         1
buffer      .ds         $1000       ;download place in RAM
            .end
