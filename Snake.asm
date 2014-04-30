/*
	Snake

	// skola assemble setting
	avrdude -C "C:\WinAVR-20100110\bin\avrdude.conf" -patmega328p -Pcom4 -carduino -b115200 -Uflash:w:Snake.hex 

	// Thism2 assemble setting
	avrdude -C "E:\Övrigt\WinAVR-20100110\bin\avrdude.conf" -patmega328p -Pcom4 -carduino -b115200 -Uflash:w:Snake.hex 

 */ 
	
	// Global Register Definitions
	.DEF	TMP			= r0
	.DEF	ZERO		= r1

	.DEF	rTemp		= r2
	.DEF	rTemp2		= r3

	.DEF	rTempI		= r16
	.DEF	rTempI2		= r17

	.DEF	rReturnL	= r24
	.DEF	rReturnH	= r25

	.DEF	rArgument0L	= r24
	.DEF	rArgument0H	= r25

	.DEF	rArgument1L	= r22
	.DEF	rArgument1H	= r23

	// Constant definitions
	.EQU	NUM_COLUMNS = 8
	.EQU	NUM_ROWS = 8

	// Data Segment
	.DSEG
matrix:	
	.BYTE 8						// LED matrix - 1 bit per "pixel"
								
	// Code segment
	.CSEG
	.ORG	0x0000
		jmp		main			// Reset vector
		nop

//	.ORG	0x0020
//		jmp		isr_timerOF		// Timer 0 overflow vector
//		nop

	.ORG	INT_VECTORS_SIZE

/**
 * Entry point
 */
main:
	// Initialize stack pointer
	ldi		rTempI, HIGH(RAMEND)
	out		SPH, rTempI
	ldi		rTempI, LOW(RAMEND)
	out		SPL, rTempI

	call init
	call gameLoop
/* main end */

/**
 * Initialize the hardware
 */
init:
	// smiley
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rTempI, 0b10000001
	st		Y+, rTempI
	ldi		rTempI, 0b00100100
	st		Y+, rTempI
	ldi		rTempI, 0b00100100
	st		Y+, rTempI
	ldi		rTempI, 0b00011000
	st		Y+, rTempI
	ldi		rTempI, 0b01000010
	st		Y+, rTempI
	ldi		rTempI, 0b01000010
	st		Y+, rTempI
	ldi		rTempI, 0b00111100
	st		Y+, rTempI
	ldi		rTempI, 0b10000001
	st		Y+, rTempI

	// templar cross
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rTempI, 0b11011111
	st		Y+, rTempI
	ldi		rTempI, 0b11011111
	st		Y+, rTempI
	ldi		rTempI, 0b11011111
	st		Y+, rTempI
	ldi		rTempI, 0b11011111
	st		Y+, rTempI
	ldi		rTempI, 0b00000000
	st		Y+, rTempI
	ldi		rTempI, 0b11011111
	st		Y+, rTempI
	ldi		rTempI, 0b00000000
	st		Y+, rTempI
	ldi		rTempI, 0b11011111
	st		Y+, rTempI
		
	// Set row bits as output bits
	sbi		DDRC, 0	
	sbi		DDRC, 1	
	sbi		DDRC, 2	
	sbi		DDRC, 3	
	sbi		DDRD, 2	
	sbi		DDRD, 3	
	sbi		DDRD, 4	
	sbi		DDRD, 5	

	// Set column bits as output bits
	sbi		DDRD, 6	
	sbi		DDRD, 7	
	sbi		DDRB, 0	
	sbi		DDRB, 1	
	sbi		DDRB, 2	
	sbi		DDRB, 3	
	sbi		DDRB, 4	
	sbi		DDRB, 5
	
	// Set X/Y joystick as input bit
	cbi		DDRC, 4				// PORTC4 aka Y axis
	cbi		DDRC, 5				// PORTC5 aka X axis

	// Initialize analog / digital converter
	lds		rTempI, ADMUX
	sbr		rTempI, 0b01000000
	cbr		rTempI, 0b10000000
	sts		ADMUX, rTempI

	lds		rTempI, ADCSRA
	sbr		rTempI, 0b10000111
	sts		ADCSRA, rTempI

	ret
/* init end */

/**
 * Game loop
 */
gameLoop:
	call clearMatrix
	
		/* Joystick input registries */
		.DEF	rJoystickL	= r4
		.DEF	rJoystickH	= r5

	// Read X axis
	ldi		rArgument0L, 1			// 1 represents X
	call	readJoystick
	mov		rJoystickL, rReturnL	// Store joystick input value
	mov		rJoystickH, rReturnH

		/* The joystick X axis 8 bit value */
		.DEF	rJoystickX	= r6

	// Convert 10 bit value to 8 bit, discarding lowest 2 bits
	mov		rArgument0L, rJoystickL
	mov		rArgument0H, rJoystickH
	call	joystickValueTo8Bit
	mov		rJoystickX, rReturnL

		
		.UNDEF	rJoystickL
		.UNDEF	rJoystickH

// TODO Replace temporary code
	// right shift some more to make the value 3 bits (row 0-7)
	mov		rTemp, rJoystickX
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	mov		rTempI, rTemp

		.UNDEF	rJoystickX

		/* rColumn */
		.DEF rColumn		= r6
		.DEF rColumnMask	= r8

	mov		rColumn, rTempI

	// convert value to row mask
	clr		rColumnMask
	inc		rColumnMask
shiftLoop:
	cpi		rTempI, 0
	breq	shiftEnd
	subi	rTempI, 1
	lsl		rColumnMask
	jmp		shiftLoop
shiftEnd:

		/* Joystick input registries */
		.DEF	rJoystickL	= r4
		.DEF	rJoystickH	= r5

	// Read Y axis
	ldi		rArgument0L, 0
	call	readJoystick
	mov		rJoystickL, rReturnL	// Store joystick input value
	mov		rJoystickH, rReturnH

		/* The joystick Y axis 8 bit value */
		.DEF	rJoystickY	= r7

	// Convert 10 bit value to 8 bit, discarding lowest 2 bits
	mov		rArgument0L, rReturnL
	mov		rArgument0H, rReturnH
	call	joystickValueTo8Bit
	mov		rJoystickY, rReturnL

		.UNDEF	rJoystickL
		.UNDEF	rJoystickH

	// Right shift joystick input until it's 3 bits (row 0-7)
	mov		rTemp, rJoystickY

		.UNDEF	rJoystickY

	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp

		/* rRow */
		.DEF rRow		= r18

	mov		rRow, rTemp

	// rverse order rRow and rColumn (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rRow
	mov		rRow, rTempI
	ldi		rTempI, 7
	sub		rTempI, rColumn
	mov		rColumn, rTempI

	// set joystick pixel
	mov		rArgument0L, rRow
	mov		rArgument1L, rColumn
	call	setPixel

	// sets the first 3 bits over the diagonal aka (x,y)
	ldi		rArgument0L, 0
	ldi		rArgument1L, 0
	call	setPixel
	ldi		rArgument0L, 1
	ldi		rArgument1L, 1
	call	setPixel
	ldi		rArgument0L, 2
	ldi		rArgument1L, 2
	call	setPixel
		
/*
	// Load the matrix adress into 16 bit register Y (LOW + HIGH)
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)
	subi	YL, -7
	sub		YL, rRow
	st		Y, rColumnMask
*/
		.UNDEF rRow
		.UNDEF rColumn
		.UNDEF rColumnMask

	call	render
	jmp		gameLoop

/**
 * Renders the matrix to the screen
 */
render:
	// Push registers used onto stack	
	push	rTemp
	push	rTempI
	
		/* rRow */
		.DEF rRow		= r18

	ldi		rRow, 1				// Reset row count
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)

renderloop:
	
	ld		rTemp, Y+			// Load byte from matrix

	ldi		rTempI, 0
delayLoop:
	nop
	nop
	nop
	nop
	nop
	subi	rTempI, -1
	cpi		rTempI, 255
	brne	delayLoop

		/* Output port temp registries */
		.DEF	rPortB		= r4
		.DEF	rPortC		= r5
		.DEF	rPortD		= r6

	// clear all input
	out		PORTB, ZERO
	out		PORTC, ZERO
	out		PORTD, ZERO

	// set columns from loaded byte
	bst		rTemp, 7			// column 7
	bld		rPortD, 6
	bst		rTemp, 6			// column 6
	bld		rPortD, 7
	bst		rTemp, 5			// column 5
	bld		rPortB, 0
	bst		rTemp, 4			// column 4
	bld		rPortB, 1
	bst		rTemp, 3			// column 3
	bld		rPortB, 2
	bst		rTemp, 2			// column 2
	bld		rPortB, 3
	bst		rTemp, 1			// column 1
	bld		rPortB, 4
	bst		rTemp, 0			// column 0
	bld		rPortB, 5

	// set row from rRow
	bst		rRow, 0				// column 0
	bld		rPortC, 0
	bst		rRow, 1				// column 1
	bld		rPortC, 1
	bst		rRow, 2				// column 2
	bld		rPortC, 2
	bst		rRow, 3				// column 3
	bld		rPortC, 3
	bst		rRow, 4				// column 4
	bld		rPortD, 2
	bst		rRow, 5				// column 5
	bld		rPortD, 3
	bst		rRow, 6				// column 6
	bld		rPortD, 4
	bst		rRow, 7				// column 7
	bld		rPortD, 5

	out		PORTB, rPortB
	out		PORTC, rPortC
	out		PORTD, rPortD

		.UNDEF	rPortB
		.UNDEF	rPortC
		.UNDEF	rPortD

	cpi		rRow, 0x80
	breq	gotologic
	lsl		rRow
	lsl		rTemp
	jmp		renderloop

gotologic:
	// Pop registers used from stack
	pop		rTemp
	pop		rTempI
	
		.UNDEF rRow

	ret

/**
 * Load x/y value from joystick
 * @param rArgument0L - 1 for X, 0 for Y
 * @return rReturnL + rReturnH (16 bit) - value between 0 1023
 */
readJoystick:
	// Push registers used onto stack	
	push	rTempI
	push	rTempI2
	
	andi	rArgument0L, 1			// Mask out LSB
	mov		rTempI, rArgument0L		
	ori		rTempI,	0b00000100		// choose joystick axis (port 4=Y / 5=X) 

	lds		rTempI2, ADMUX			// Load ADMUX byte
	or		rTempI2, rTempI			// set bit that should be set
	ori		rTempI, 0b11110000		// mask out preserved bits
	and		rTempI2, rTempI			// clear bits that should be cleared
	sts		ADMUX, rTempI2			// Write ADMUX byte back
	
	// start convertion

	lds		rTempI, ADCSRA
	ori		rTempI, 0b01000000		
	sts		ADCSRA, rTempI

	// load loop - wait until value loaded
readLoop:
	lds		rTempI, ADCSRA
	sbrc	rTempI, 6
	jmp		readLoop

	// return value
	lds		rReturnL, ADCL
	lds		rReturnH, ADCH

	// Pop registers used from stack
	pop		rTempI2
	pop		rTempI

	ret
/* loadJoystick end */

/**
 * Converts the 10 bit joystick value to an 8 bit value,
 * discarding the two least significant bits
 * @param rArgument0H + rArgument0L, 10 bit value from the joystick input
 * @return rReturnL - value between 0 255
 */
joystickValueTo8Bit:
		.DEF	rHighByte	= r18
		.DEF	rLowByte	= r19

	mov		rHighByte, rArgument0H
	mov		rLowByte, rArgument0L
	lsr		rLowByte
	lsr		rLowByte
	lsl		rHighByte
	lsl		rHighByte
	lsl		rHighByte
	lsl		rHighByte
	lsl		rHighByte
	lsl		rHighByte
	or		rLowByte, rHighByte
	mov		rReturnL, rLowByte
	ldi		rReturnH, 0

		.UNDEF	rHighByte
		.UNDEF	rLowByte

	ret
/* joystickValueTo8Bit end */



/**
 * Draws a pixel in the matrix at the sepcified location
 * @param rArgument0L The row of the pixel
 * @param rArgument1L The column of the pixel
 */
setPixel:
		.DEF rRow		= r18
		.DEF rColumn	= r19
		.DEF rRowMask	= r20

	push rTemp

	// Load the matrix adress into 16 bit register Y (LOW + HIGH)
	mov		rRow, rArgument0L
	mov		rColumn, rArgument1L

	// convert value to mask
	ldi		rRowMask, 0x80
columnShiftLoop:
	cpi		rColumn, 0
	breq	columnShiftEnd
	subi	rColumn, 1
	lsr		rRowMask
	jmp		columnShiftLoop
columnShiftEnd:

	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)
	add		YL, rRow
	ld		rTemp, Y
	or		rTemp, rRowMask
	st		Y, rTemp
	
	pop rTemp

		.UNDEF rRow
		.UNDEF rColumn

	ret
/* setPixel end */



/**
 * Clear the matrix
 */
clearMatrix:
	push	rTemp

	// clear the entire matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)
	clr		rTemp
	st		Y+, rTemp
	st		Y+, rTemp
	st		Y+, rTemp
	st		Y+, rTemp
	st		Y+, rTemp
	st		Y+, rTemp
	st		Y+, rTemp
	st		Y+, rTemp

	pop		rTemp

	ret
/* clearMatrix end */