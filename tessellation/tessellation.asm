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
CHAR_SPACE  .equ $20

 jsr TextClearScreen
 jsr HiresOn
 jsr HiresClearScreen
 ;jsr HiresOff
 rts

; enable standard hires bitmapmode
HiresOn: 
 LDA $D018
 ORA #$08 ; enable videobase $2000 mask p104
 STA $D018
 LDA $D011
 ORA #$20 ; enable bitmapmode mask p122
 STA $D011
 RTS

HiresClearScreen
 LDX #$00
 ldy #$00
 lda #$ff
loop:
 sta $2000,x
 dex
 bne loop
 iny
 inc *-5 ; modify sta $2000 abs address instruction
 cpy #$20
 bne loop
 rts

TextClearScreen
 ldx #$00
loop2:
 lda #CHAR_SPACE
 sta SCREEN_MEM,x
 sta SCREEN_MEM+$0100,x
 sta SCREEN_MEM+$0200,x
 sta SCREEN_MEM+$0300,x
 lda #COLOR_BLACK
 sta SCREEN_COLOR,x
 sta SCREEN_COLOR+$0100,x
 sta SCREEN_COLOR+$0200,x
 sta SCREEN_COLOR+$0300,x
 inx
 bne loop2
 rts	