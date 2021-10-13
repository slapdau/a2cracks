!cpu 6502
*=$1000

!addr   rwts =  $03D9
!addr   count = $FF
!addr   physect = $FE

        pagestart = $20
        pages = $03

; Initialise variables
        lda     #pages
        sta     count
        lda     #$00
        sta     physect

; Write sector
write
        ldy     #<iocb
        lda     #>iocb
        jsr     rwts

; Increment sector/track
        inc     physect
        inc     physect
        ldy     physect
        cpy     #$10
        bne     setsect
        ldy     #$00
        sty     physect
        inc     track

setsect
; Convert physical to logical sector
        lda     xlattab,Y
        sta     sector

; Next page
        inc page
        dec count
        bne  write

        rts




xlattab
        !byte $00, $07, $0E, $06, $0D, $05, $0C, $04
        !byte $0B, $03, $0A, $02, $09, $01, $08, $0F

iocb    !byte   1, $60, 1, 0
track   !byte   $00
sector  !byte   $00
        !byte   <dct, >dct
        !byte   $00
page    !byte   pagestart
        !byte   0, 0, 2, 0, 0, $60, 1
dct     !byte   1, $ef, $d8, 0
