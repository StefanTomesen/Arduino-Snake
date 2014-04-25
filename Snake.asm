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
	.ORG 0x0020
		jmp isr_timerOF		// Timer 0 overflow vector
		nop
	.ORG INT_VECTORS_SIZE

	// Initialize stack pointer
	ldi rTemp, HIGH(RAMEND)
	out SPH, rTemp
	ldi rTemp, LOW(RAMEND)
	out SPL, rTemp