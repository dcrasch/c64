	;; (C) 2015 by David Rasch (david@hacklab.nl)
	;; Some rights reserved. See COPYING.
	
	.processor 6502 
	.org $0801
	.hex 0c08 0000 9e32 3036 3100 0000 ; basic start header

SCREEN_MEM 	.equ $0400
SCREEN_COLOR	.equ $D800

COLOR_BLACK	.equ $00
COLOR_WHITE     .equ $01

	jmp init
	rts
	
RETX	.byte $00
POS	.byte $00, $00

init
	;;  maze
	jsr $e544	;clear the screen
	;; 	jsr initScreen
	jsr depthFirstSearch
	rts

initScreen
	;; $4F, $77 $74 |-, --, |
	ldx #$00

initScreenLoop
	lda #$4F
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

;; @TODO CHECK FOR OVERFLOWS
moveDown
	clc
	lda #$28
	adc POS
	rts
moveUp
	clc
	lda #$28
	sbc POS
	sta POS
	rts
moveLeft
	clc
	lda #$01
	adc POS
	sta POS
	rts
moveRight
	clc
	lda #$01
	sbc POS
	sta POS
	rts
	
depthFirstSearch
	jsr moveLeft
	jsr moveLeft
	lda #$01
	ldx POS
	sta SCREEN_COLOR,x
	rts
	
get_random_number ; reg a ()
    lda $d012 ; load current screen raster value
    eor $dc04 ; xor against value in $dc04
    sbc $dc05 ; then subtract value in $dc05
    rts
