	;; (C) 2015 by David Rasch (david@hacklab.nl)
	;; Some rights reserved. See COPYING.
	
	.processor 6502 
	.org $0801
; basic start header
	.hex 0c08 0000 9e32 3036 3100 0000 

SCREEN_MEM    .equ $0400
SCREEN_COLOR  .equ $D800
SCREEN_WIDTH  .equ 40
SCREEN_HEIGHT .equ 25

COLOR_BLACK .equ $00
COLOR_WHITE .equ $01
CHAR_CORNER .equ $ec
CHAR_TOP    .equ $77
CHAR_SIDE   .equ $74

; keyboard
GETIN  .equ $FFE4
SCNKEY .equ $FF9F

; zeropage vectors
POS .equ $BA
ROW .equ $BD
COL .equ $BE

 jsr init
 rts
	
init
 jsr initScreen
 jsr moveAround	
 rts

fillScreen	
 lda #0
 sta COL
loopcol:	
 lda COL
 lsr
 sta ROW
 INC ROW
looprow:
	jsr drawChar
	INC ROW
	LDA ROW
	CMP #SCREEN_HEIGHT
	bne looprow
	INC COL
	LDA COL
	CMP #SCREEN_WIDTH
	bne loopcol
	rts
		
sineScreen	
 lda #$0
 sta COL		
loopcol2:
	ldx COL
	lda sine,x
	sta ROW
	jsr drawChar
	INC COL
	LDA COL
	CMP #40
	bne loopcol2
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

moveAround
 lda #0
 sta ROW
 sta COL
SCAN:
 JSR SCNKEY	;get key
 JSR GETIN	;put key in A
 CMP #87 ;W - UP
 BEQ UP
 CMP #83		;S - down
		BEQ DOWN
 CMP #65		;A - left
		BEQ LEFT
		CMP #68		;D - right
		BEQ RIGHT
 CMP #13 ;Enter - quit
 beq END
 jsr drawChar
 JMP SCAN
DOWN:
 INC ROW
 JMP SCAN
UP:
 DEC ROW
 JMP SCAN
LEFT:
 DEC COL
 JMP SCAN
RIGHT:
 INC COL
 JMP SCAN
END:
 RTS

drawChar ; at row and col
	;; (4xROW + ROW) x 8 = 40 x ROW
 LDA #$00
 STA POS+1
; multiply 5
 LDA ROW
 ASL
 ASL
 ADC ROW
 ; multiply 8
 ASL
 ASL	
 ROL POS+1
 ASL
 ROL POS+1
	; add column
 ADC COL
 BCC rr
 INC POS+1
rr
 STA POS
 ; add video base
 LDA POS+1
 CLC
 ADC #>SCREEN_MEM 
 STA POS+1

 lda #$51
 ldy #$00
 sta (POS),y
 RTS

get_random_number ; reg a ()
    lda $d012 ; load current screen raster value
    eor $dc04 ; xor against value in $dc04
    sbc $dc05 ; then subtract value in $dc05
    rts
	
sine hex 18 17 15 12 0e 0a 07 03 01 00 00 01 04 07 0b 0f 12 15 17 17 17 15 11 0e 0a 06 03 01 00 00 01 04 08 0c 0f 13 16 17 17 16