/*
	Snake

	avrdude -C "C:\WinAVR-20100110\bin\avrdude.conf" -patmega328p -Pcom4 -carduino -b115200 -Uflash:w:Snake.hex 
 */ 
	
	// Register definitions
	.DEF	rTMP		= r0
	.DEF	rZero		= r1

	.DEF	rTemp		= r16
	.DEF	rRow		= r17
	.DEF	rMatrix		= r18

	.DEF	rPortB		= r19
	.DEF	rPortC		= r20
	.DEF	rPortD		= r21

	// Constant definitions
	.EQU	NUM_COLUMNS = 8
	.EQU	NUM_ROWS = 8

	// Data Segment
	.DSEG
	matrix:	.BYTE 8			// LED matrix - 1 bit per "pixel"
	//jumptable: .BYTE 16
	
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

	

	st Y+, rMatrix

	/*
	out 0b00000000
	out 0b00100100
	out 0b00100100
	out 0b00000000
	out 0b10000010
	out 0b01000100
	out 0b00111000
	out 0b00000000
*/
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


/*
	// set bit row table

	sbi PORTC, 0		// row 0
	sbi PORTC, 1		// row 1
	sbi PORTC, 2		// row 2
	sbi PORTC, 3		// row 3
	sbi PORTD, 2		// row 4
	sbi PORTD, 3		// row 5
	sbi PORTD, 4		// row 6
	sbi PORTD, 5		// row 7

	// set bit column table

	sbi PORTD, 6		// column 0
	sbi PORTD, 7		// column 1
	sbi PORTB, 0		// column 2
	sbi PORTB, 1		// column 3
	sbi PORTB, 2		// column 4
	sbi PORTB, 3		// column 5
	sbi PORTB, 4		// column 6
	sbi PORTB, 5		// column 7
*/
	// Load
	ldi YH, HIGH(matrix)
	ldi YL, LOW(matrix)
	ld rMatrix, Y

render:
	ldi rRow, 1

renderloop:

	// Delay
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	// clear all input
	out PORTB, rZero
	out PORTC, rZero
	out PORTD, rZero

	ldi rTemp,	0b10101111

	bst rTemp, 7	//
	bld rPortD, 6

	bst rTemp, 6
	bld rPortD, 7

	bst rTemp, 5
	bld rPortB, 0

	bst rTemp, 4
	bld rPortB, 1

	bst rTemp, 3
	bld rPortB, 2

	bst rTemp, 2
	bld rPortB, 3

	bst rTemp, 1
	bld rPortB, 4

	bst rTemp, 0
	bld rPortB, 5

	// row mapping
	bst rRow, 0
	bld rPortC, 0

	bst rRow, 1
	bld rPortC, 1

	bst rRow, 2
	bld rPortC, 2

	bst rRow, 3
	bld rPortC, 3

	bst rRow, 4
	bld rPortD, 2

	bst rRow, 5
	bld rPortD, 3

	bst rRow, 6
	bld rPortD, 4

	bst rRow, 7
	bld rPortD, 5

	out PORTB, rPortB
	out PORTC, rPortC
	out PORTD, rPortD

	cpi rRow, 0x80
	breq gotologic
	lsl rRow
	jmp renderloop

gotologic:
	jmp render			// TODO branch to game logic

/*
	subi rCounter, -1

	cpi rCounter, 1
	breq case1

	cpi rCounter, 2
	breq case2
	
	cpi rCounter, 3
	breq case3
	
	cpi rCounter, 4
	breq case4
	
	cpi rCounter, 5
	breq case5
	
	cpi rCounter, 6
	breq case6
	
	cpi rCounter, 7
	breq case7
	
	cpi rCounter, 8
	breq case8

case1:
	sbi PORTC, 0		// row 0
	sbi PORTB, 5		// column 7
	jmp render
case2:
	sbi PORTC, 1		// row 1
	sbi PORTB, 2		// column 4
	jmp render
case3:
	sbi PORTC, 2		// row 2
	sbi PORTB, 4		// column 6
	jmp render
case4:
	sbi PORTC, 3		// row 3
	sbi PORTD, 6		// column 0
	jmp render
case5:
	sbi PORTD, 2		// row 4
	sbi PORTD, 7		// column 1
	jmp render
case6:
	sbi PORTD, 3		// row 5
	sbi PORTB, 1		// column 3
	jmp render
case7:
	sbi PORTD, 4		// row 6
	sbi PORTB, 3		// column 5
	jmp render
case8:
	sbi PORTD, 5		// row 7
	sbi PORTB, 0		// column 2
	ldi rCounter, 0*/
