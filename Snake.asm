/*
 * Snake
 */ 
	
	// Register definitions
	.DEF	rTemp = r16

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

	

render:
	sbi PORTC, 0		// row 0
	sbi PORTC, 1		// row 1
	sbi PORTC, 2		// row 2
	sbi PORTC, 3		// row 3
	sbi PORTD, 2		// row 4
	sbi PORTD, 3		// row 5
	sbi PORTD, 4		// row 6
	sbi PORTD, 5		// row 7

	sbi PORTD, 6		// column 0
	sbi PORTD, 7		// column 1
	sbi PORTB, 0		// column 2
	sbi PORTB, 1		// column 3
	sbi PORTB, 2		// column 4
	sbi PORTB, 3		// column 5
	sbi PORTB, 4		// column 6
	sbi PORTB, 5		// column 7

	jmp render