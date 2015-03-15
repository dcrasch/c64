	;; (C) 2015 by David Rasch (david@hacklab.nl)
	;; Some rights reserved. See COPYING.
	
	.processor 6502 
	.org $0801
	.hex 0c08 0000 9e32 3036 3100 0000 ; basic start header

SCREEN_MEM 	.equ $0400
SCREEN_COLOR	.equ $D800

COLOR_BLACK	.equ $00
COLOR_WHITE     .equ $01
	
	;;  maze
	jsr $e544	;clear the screen

	;; $4F, $77 $74 |-, --, |  
	ldx #$00
initscreenloop
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
	bne initscreenloop
	rts	
