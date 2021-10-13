!cpu 6502
*=$a100

; Relocate if the game isn't patched to run with
; pages $89, $8A left where they are. See the
; write_game program for the patch option.
        reloclow = 0

!addr {
        title   = $8200
        start   = $6300
}

        ldx     #$ff
        txs

        ldy     #$00
        sty     $50
        sty     $52

!if reloclow {
; Copy pages $89:$8A -> $02:$03
        lda     #$89
        sta     $51
        lda     #$02
        sta     $53
        sta     $54
        jsr     moveram
}

; Copy pages $8B:$A0 -> $0A:$1F
        lda     #$8B
        sta     $51
        lda     #$0a
        sta     $53
        lda     #$a1 - $8b
        sta     $54
        jsr     moveram

        jsr     title
        jmp     start

moveram
-       lda     ($50),y
        sta     ($52),y
        iny
        bne     -
        inc     $51
        inc     $53
        dec     $54
        bne     -
        rts
