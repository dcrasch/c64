	;; (C) 2015 by David Rasch (david@hacklab.nl)
	;; Some rights reserved. See COPYING.
	
	.processor 6502 
	.org $0801
	.hex 0c08 0000 9e32 3036 3100 0000 ; basic start header

SCREEN_MEM  .equ $0400
SCREEN_COLOR	.equ $D800
SCREEN_WIDTH .equ $28

COLOR_BLACK .equ $00
COLOR_WHITE .equ $01
CHAR_CORNER .equ $4F
CHAR_TOP    .equ $77
CHAR_SIDE   .equ $74

ROW .byte $08
COL .byte $0A
POS .word $0000

 jmp initScreen
 ;;jmp drawChar
 rts
	
init
	;;  maze
	jsr initScreen
	rts

initScreen
	ldx #$00
initScreenLoop
	lda #CHAR_CORNER
	sta SCREEN_MEM,x
	sta SCREEN_MEM+$0100,x
	sta SCREEN_MEM+$0200,x
	sta SCREEN_MEM+$0300,x
	lda #COLOR_WHITE
	sta SCREEN_COLOR,x
	sta SCREEN_COLOR+$0100,x
	sta SCREEN_COLOR+$0200,x
	sta SCREEN_COLOR+$0300,x
	inx
	bne initScreenLoop
	rts	

drawChar ; at row and col
;; (4xROW + ROW) x 8 = 40 x ROW
 CLC
 LDY #$00
; multiply 5
 LDA ROW
 ASL
 ASL
 ADC ROW
; multiply 8
 CLC
 ASL
 ROL >POS
 ASL
 ROL >POS
; add column
 CLC
 ADC COL
 BCC rr
 INC >POS
rr
 STA <POS
 LDA >POS
 ADC $04
 STA >POS
 LDA #$77
 STA POS
 RTS

get_random_number ; reg a ()
    lda $d012 ; load current screen raster value
    eor $dc04 ; xor against value in $dc04
    sbc $dc05 ; then subtract value in $dc05
    rts