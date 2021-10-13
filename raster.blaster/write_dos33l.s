!cpu 6502
*=$1000

!addr   rwts =  $03D9

        pagestart = $20

; Write sector
write
        ldy     #<iocb
        lda     #>iocb
        jsr     rwts

        rts

iocb    !byte   1, $60, 1, 0
track   !byte   $00
sector  !byte   $01
        !byte   <dct, >dct
        !byte   $00
page    !byte   pagestart
        !byte   0, 0, 2, 0, 0, $60, 1
dct     !byte   1, $ef, $d8, 0
