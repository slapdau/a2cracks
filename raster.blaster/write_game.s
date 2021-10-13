!cpu 6502
*=$1000

; Patch the game so that it will run without pages $89, $8A
; being moved to $02,$03. Don't patch if the pages will be
; moved. See entry.
        patch = 1

!addr {
        rwts =  $03D9
        count = $FF
        physect = $FE
}

        pagestart = $40
        pages = $62

!if patch {
!addr   patchptr = $FE

        clc
        ldx     #$00
        ldy     #$00
-       lda     patchlst,x
        sta     patchptr
        inx
        lda     patchlst,x
        sta     patchptr + 1
        inx
        lda     (patchptr),y
        adc     #$87
        sta     (patchptr),y
        cpx     #(lstend - patchlst)
        bne     -
}

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
track   !byte   $01
sector  !byte   $00
        !byte   <dct, >dct
        !byte   $00
page    !byte   pagestart
        !byte   0, 0, 2, 0, 0, $60, 1
dct     !byte   1, $ef, $d8, 0

!if patch {
patchlst
        !word $1013 + 2 + $8100
        !word $101A + 2 + $8100
        !word $1029 + 2 + $8100
        !word $1031 + 2 + $8100
        !word $1038 + 2 + $8100
        !word $1059 + 2 + $8100
        !word $1068 + 2 + $8100
        !word $106F + 2 + $8100
        !word $107C + 2 + $8100
        !word $108B + 2 + $8100
        !word $1092 + 2 + $8100
        !word $109F + 2 + $8100
        !word $1183 + 2 + $8100
        !word $118C + 2 + $8100
        !word $11A0 + 2 + $8100
        !word $11E3 + 2 + $8100
        !word $11EC + 2 + $8100
        !word $1200 + 2 + $8100
        !word $1664 + 2 + $8100
        !word $166B + 2 + $8100
        !word $1674 + 2 + $8100
        !word $1727 + 2 + $8100
        !word $172E + 2 + $8100
        !word $173F + 2 + $8100
        !word $179D + 2 + $8100
        !word $17A5 + 2 + $8100
        !word $17C4 + 2 + $8100
        !word $17D5 + 2 + $8100
        !word $17DD + 2 + $8100
        !word $17F3 + 2 + $8100
        !word $1EF7 + 2 + $8100
        !word $1EFD + 2 + $8100
        !word $1F0E + 2 + $8100
        !word $1FD0 + 2 + $8100
        !word $4444 + 2
        !word $4449 + 2
        !word $4460 + 2
        !word $446A + 2
        !word $483D + 2
        !word $4843 + 2
        !word $485A + 2
        !word $4BB3 + 2
        !word $4BB8 + 2
        !word $4BCC + 2
        !word $69BC + 2
        !word $69C1 + 2
        !word $69D2 + 2
        !word $69D7 + 2
        !word $69DC + 2
        !word $69F1 + 2
        !word $7F64 + 2
        !word $7F77 + 2
        !word $7F86 + 2
        !word $7F91 + 2
        !word $7FA0 + 2
        !word $7FC6 + 2
        !word $81AE + 2
        !word $820D + 2
        !word $8212 + 2
        !word $821D + 2
        !word $8227 + 2
        !word $822C + 2
        !word $8235 + 2
        !word $824D + 2
        !word $8253 + 2
        !word $825E + 2
        !word $827A + 2
        !word $827F + 2
        !word $8290 + 2
        !word $8295 + 2
        !word $829A + 2
        !word $82B4 + 2
        !word $82C8 + 2
        !word $82CD + 2
        !word $82DE + 2
        !word $88A7 + 2
        !word $88AE + 2
        !word $88C2 + 2
        !word $88E4 + 2
        !word $88F8 + 2
        !word $8902 + 2
        !word $890A + 2
        !word $8A02 + 2
        !word $8A0A + 2
lstend
}
