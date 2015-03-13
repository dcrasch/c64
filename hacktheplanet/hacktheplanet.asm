	.processor 6502 
	.org $801
	.hex 0c08 0000 9e32 3036 3100 0000

	jsr $e544	;clear the screen
	ldx #$00;
loop	lda message,x
	jsr $ffd2 ;print the character
	inx
	cpx #$12
	bne loop
	rts ;return from subroutine


message	.byte "HACK THE PLANET!"
