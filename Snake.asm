/*
	Snake

	avrdude -C "C:\WinAVR-20100110\bin\avrdude.conf" -patmega328p -Pcom4 -carduino -b115200 -Uflash:w:Snake.hex 
 */ 
	
	// Register definitions
	.DEF	rTMP		= r0
	.DEF	rZero		= r1

	.DEF	rTemp		= r16
	.DEF	rRow		= r17

	.DEF	rPortB		= r19
	.DEF	rPortC		= r20
	.DEF	rPortD		= r21

	.DEF	rCount1		= r22
	.DEF	rCount2		= r23
	.DEF	rCount3		= r24
	.DEF	rCount4		= r25

	// Constant definitions
	.EQU	NUM_COLUMNS = 8
	.EQU	NUM_ROWS = 8

	// Data Segment
	.DSEG
	matrix:	.BYTE 8			// LED matrix - 1 bit per "pixel"
	
	// Code segment
	.CSEG
	.ORG 0x0000
		jmp init			// Reset vector
		nop
//	.ORG 0x0020
//		jmp isr_timerOF		// Timer 0 overflow vector
//		nop
	.ORG INT_VECTORS_SIZE

init:
	// Initialize stack pointer
	ldi rTemp, HIGH(RAMEND)
	out SPH, rTemp
	ldi rTemp, LOW(RAMEND)
	out SPL, rTemp

	ldi YH, HIGH(matrix)	// Set Y to matrix address
	ldi YL, LOW(matrix)
	
	ldi rTemp, 0b10000001
	st	Y+, rTemp
	ldi rTemp, 0b00100100
	st	Y+, rTemp
	ldi rTemp, 0b00100100
	st	Y+, rTemp
	ldi rTemp, 0b00011000
	st	Y+, rTemp
	ldi rTemp, 0b01000010
	st	Y+, rTemp
	ldi rTemp, 0b01000010
	st	Y+, rTemp
	ldi rTemp, 0b00111100
	st	Y+, rTemp
	ldi rTemp, 0b10000001
	st	Y+, rTemp
	
	// Set row bits as output bits
	sbi DDRC, 0	
	sbi DDRC, 1	
	sbi DDRC, 2	
	sbi DDRC, 3	
	sbi DDRD, 2	
	sbi DDRD, 3	
	sbi DDRD, 4	
	sbi DDRD, 5	

	// Set column bits as output bits
	sbi DDRD, 6	
	sbi DDRD, 7	
	sbi DDRB, 0	
	sbi DDRB, 1	
	sbi DDRB, 2	
	sbi DDRB, 3	
	sbi DDRB, 4	
	sbi DDRB, 5

gameLogic:

	jmp render

render:
	ldi rRow, 1				// Reset row count
	ldi YH, HIGH(matrix)	// Set Y to matrix address
	ldi YL, LOW(matrix)

renderloop:
	
	ld rTemp, Y+			// Load byte from matrix

	ldi rCount1, 0
delayLoop:

	nop
	nop
	nop
	nop

	nop
	subi rCount1, -1
	cpi rCount1, 255
	brne delayLoop
	
	// clear all input
	out PORTB, rZero
	out PORTC, rZero
	out PORTD, rZero

	// set columns from loaded byte
	bst rTemp, 7	// column 7
	bld rPortD, 6
	bst rTemp, 6	// column 6
	bld rPortD, 7
	bst rTemp, 5	// column 5
	bld rPortB, 0
	bst rTemp, 4	// column 4
	bld rPortB, 1
	bst rTemp, 3	// column 3
	bld rPortB, 2
	bst rTemp, 2	// column 2
	bld rPortB, 3
	bst rTemp, 1	// column 1
	bld rPortB, 4
	bst rTemp, 0	// column 0
	bld rPortB, 5

	// set row from rRow
	bst rRow, 0		// column 0
	bld rPortC, 0
	bst rRow, 1		// column 1
	bld rPortC, 1
	bst rRow, 2		// column 2
	bld rPortC, 2
	bst rRow, 3		// column 3
	bld rPortC, 3
	bst rRow, 4		// column 4
	bld rPortD, 2
	bst rRow, 5		// column 5
	bld rPortD, 3
	bst rRow, 6		// column 6
	bld rPortD, 4
	bst rRow, 7		// column 7
	bld rPortD, 5

	out PORTB, rPortB
	out PORTC, rPortC
	out PORTD, rPortD

	cpi rRow, 0x80
	breq gotologic
	lsl rRow
	lsl rTemp
	jmp renderloop

gotologic:
	jmp gameLogic