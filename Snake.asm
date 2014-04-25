/*
 * Snake
 */ 
	
	// Register definitions
	.DEF rTemp = r16

	// Constant definitions
	.EQU NUM_COLUMNS = 8
	.EQU NUM_ROWS = 8

	// Data Segment
	.DSEG
	matrix:	.BYTE 8

	// Code Segment
	.CSEG

	// Interupt Vectors
	.ORG 0x0000
		jmp		init_routine	// Reset vector
	...

	.ORG INIT_VECTORS_SIZE	// End of vector table
	
	init_routine:
	...