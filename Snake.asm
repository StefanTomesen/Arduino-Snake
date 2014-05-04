/**
 *	Snake
 *
 *	// skola assemble setting
 *	avrdude -C "C:\WinAVR-20100110\bin\avrdude.conf" -patmega328p -Pcom4 -carduino -b115200 -Uflash:w:Snake.hex 
 *
 *	// Thism2 assemble setting
 *	avrdude -C "E:\Övrigt\WinAVR-20100110\bin\avrdude.conf" -p atmega328p -P com3 -c arduino -b 115200 -U flash:w:Snake.hex 
 *
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

	//.DEF	rArgument2L	= r20
	//.DEF	rArgument2H	= r21

	//.DEF	rArgument3L	= r18
	//.DEF	rArgument3H	= r19

	// Constant definitions
	.EQU	RESETaddr			= 0x0000
	//ledjoj
	.EQU	NUM_COLUMNS			= 8
	.EQU	NUM_ROWS			= 8
	// snake
	.EQU	SNAKE_MAX_LENGTH	= 64
	// joystick
	.EQU	JOYSTICK_X_AXIS		= 1
	.EQU	JOYSTICK_Y_AXIS		= 0
	.EQU	JOYSTICK_THRESHOLD	= 128 - 16
	.EQU	JOYSTICK_UP			= 0
	.EQU	JOYSTICK_DOWN		= 1
	.EQU	JOYSTICK_LEFT		= 2
	.EQU	JOYSTICK_RIGHT		= 3
	// Macro definitions

	// logical shift left
	.MACRO	lsl2
		lsl		@0
		lsl		@0
	.ENDMACRO
	.MACRO	lsl4
		lsl2	@0
		lsl2	@0
	.ENDMACRO
	.MACRO	lsl8
		lsl4	@0
		lsl4	@0
	.ENDMACRO
	// logical shift right
	.MACRO	lsr2
		lsr		@0
		lsr		@0
	.ENDMACRO
	.MACRO	lsr4
		lsr2	@0
		lsr2	@0
	.ENDMACRO
	.MACRO	lsr8
		lsr4	@0
		lsr4	@0
	.ENDMACRO
	// setPixel subroutine call
	.MACRO	setPixelr
		mov		rArgument0L, @0
		mov		rArgument1L, @1
		call	setPixel
	.ENDMACRO
	.MACRO	setPixeli
		ldi		rArgument0L, @0
		ldi		rArgument1L, @1
		call	setPixel
	.ENDMACRO
	// branch if equal
	.MACRO ifeqi
		cpi		@0, @1
		breq	@2
	.ENDMACRO
	.MACRO ifeq
		cp		@0, @1
		breq	@2
	.ENDMACRO
	// branch if not equal
	.MACRO ifnei
		cpi		@0, @1
		brne	@2
	.ENDMACRO
	.MACRO ifne
		cp		@0, @1
		brne	@2
	.ENDMACRO

	// timer data structure
	.EQU	TimerSize			= 4
	.EQU	TimerCurrentTimeL	= 0x00
	.EQU	TimerCurrentTimeH	= 0x01
	.EQU	TimerTargetTimeL	= 0x02
	.EQU	TimerTargetTimeH	= 0x03

	// Vector2 data structure
	.EQU	Vector2Size			= 2
	.EQU	Vector2X			= 0x00
	.EQU	Vector2Y			= 0x01

	/**							
	 * Data Segment
	 */
	.DSEG

matrix:	
	.BYTE	NUM_ROWS					// LED matrix - 1 bit per "pixel"

renderTimer:	
	.BYTE	TimerSize

snakeVector:	
	.BYTE	SNAKE_MAX_LENGTH * Vector2Size

	/**							
	 * Code segment
	 */
	.CSEG

	// reset button interupt
	.ORG	RESETaddr
		jmp		init			// Reset vector
		nop

	// timer0 overflow interupt
	.ORG	OVF0addr 
		//jmp		timer0OverflowInterupt		// Timer 0 overflow vector
		jmp		timer2OverflowInterupt		// Timer 2 overflow vector	
		nop

	// timer2 overflow interupt
	.ORG	OVF2addr 
		jmp		timer2OverflowInterupt		// Timer 2 overflow vector
		nop

	// rest code
	.ORG	INT_VECTORS_SIZE
/**
 * timer0OverflowInterupt
 */
timer0OverflowInterupt:

	reti
/* timer0OverflowInterupt end */



/**
 * timer2OverflowInterupt
 */
timer2OverflowInterupt:
		/* temporary registers */
		.DEF	rStatus		= r18

	// save status
	push	rStatus						// save register
	in		rStatus, SREG				
	push	rStatus
		
		.UNDEF	rStatus

		/* temporay registers */
		.DEF	rCounterL	= r18
		.DEF	rCounterH	= r19

	// pre stack stuff
	push	rCounterL
	push	rCounterH
	push	YL
	push	YH

	// load time
	ldi		YH, HIGH(renderTimer)
	ldi		YL, LOW(renderTimer)
	ld		rCounterL, Y+
	ld		rCounterH, Y+
	
	// increase time by 1
	subi	rCounterL, LOW(-1)
	sbci	rCounterH, HIGH(-1)

	// reset if time is at targer time
	ifnei	rCounterL, 0xFF, resetTimeEnd
	ifnei	rCounterH, 0x03, resetTimeEnd
	clr		rCounterL
	clr		rCounterH
resetTimeEnd:

	// store time
	ldi		YH, HIGH(renderTimer)	// Set Y to matrix address
	ldi		YL, LOW(renderTimer)
	st		Y+, rCounterL
	st		Y+, rCounterH

	// post stack stuff
	pop		YH
	pop		YL
	pop		rCounterH
	pop		rCounterL					

		.UNDEF	rCounterL
		.UNDEF	rCounterH

		/* temporary registers */
		.DEF	rStatus		= r18

	// restore status
	pop		rStatus
	out		SREG, rStatus
	pop		rStatus						// restore register
		
		.UNDEF	rStatus

	reti
/* timer2OverflowInterupt end */



/**
 * Entry point
 */
main:
		/* rColumn, rRow */
		.DEF	rColumn		= r8
		.DEF	rRow		= r9

	// stack
	push	rColumn
	push	rRow
	
mainLoop:
	call	clearMatrix

		/* Joystick input registries */
		.DEF	rJoystickL	= r18
		.DEF	rJoystickH	= r19

	// Read X axis
	ldi		rArgument0L, JOYSTICK_X_AXIS	// 1 represents X
	call	readJoystick
	mov		rJoystickL, rReturnL			// Store joystick input value
	mov		rJoystickH, rReturnH

	// Convert 10 bit value to 8 bit, discarding lowest 2 bits
	mov		rArgument0L, rJoystickL
	mov		rArgument0H, rJoystickH
	call	joystickValueTo8Bit
	mov		rColumn, rReturnL

		.UNDEF	rJoystickL
		.UNDEF	rJoystickH

	// right shift some more to make the value 3 bits (row 0-7)
	lsr4	rColumn
	lsr		rColumn

	// rverse order rColumn (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rColumn
	mov		rColumn, rTempI

		/* Joystick input registries */
		.DEF	rJoystickL	= r18
		.DEF	rJoystickH	= r19

	// Read Y axis
	ldi		rArgument0L, JOYSTICK_Y_AXIS
	call	readJoystick
	mov		rJoystickL, rReturnL	// Store joystick input value
	mov		rJoystickH, rReturnH

	// Convert 10 bit value to 8 bit, discarding lowest 2 bits
	mov		rArgument0L, rJoystickL
	mov		rArgument0H, rJoystickH
	call	joystickValueTo8Bit
	mov		rRow, rReturnL

		.UNDEF	rJoystickL
		.UNDEF	rJoystickH

	// Right shift joystick input until it's 3 bits (row 0-7)
	lsr4	rRow
	lsr		rRow

	// rverse order rRow (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rRow
	mov		rRow, rTempI

	setPixelr	rRow, rColumn

		/* Joystick input registries */
		.DEF	rRowi		= r16
		.DEF	rColumni	= r17

	mov		rRowi,		rRow
	mov		rColumni,	rColumn

	// if at pixel(X,Y) (0,0) run timerTest program
	setPixeli	0, 0
	ifnei	rRowi, 0, runProgram00End
	ifnei	rColumni, 0, runProgram00End
	call	timerTest
	jmp		mainLoopEnd
runProgram00End:

	// if at pixel(X,Y) (0,7) run renderJoystick program
	setPixeli	0, 7
	ifnei	rRowi, 0, runProgram07End
	ifnei	rColumni, 7, runProgram07End
	call	renderJoystick
	jmp		mainLoopEnd
runProgram07End:

	// if at pixel(X,Y) (7,0) run snakeGame program
	setPixeli	7, 0
	ifnei	rRowi, 7, runProgram70End
	ifnei	rColumni, 0, runProgram70End
	call	snakeGame
	jmp		mainLoopEnd
runProgram70End:

	// if at pixel(X,Y) (7,7) run fillBoard program
	setPixeli	7, 7
	ifnei	rRowi, 7, runProgram77End
	ifnei	rColumni, 7, runProgram77End
	call	fillBoard
	jmp		mainLoopEnd
runProgram77End:

		.UNDEF	rRowi
		.UNDEF	rColumni

	call	render
	jmp		mainLoop
mainLoopEnd:

	// stack
	pop		rRow
	pop		rColumn

		.UNDEF	rRow
		.UNDEF	rColumn

	ret							// if program returned, exit main
/* main end */



/**
 * start runing the timer test
 */
timerTest:
		/* rCounterL, rCounterH */
		.DEF	rCounterL	= r18
		.DEF	rCounterH	= r19

	// reset renderTimer
	ldi		YH, HIGH(renderTimer)	// Set Y to matrix address
	ldi		YL, LOW(renderTimer)
	clr		rCounterL
	clr		rCounterH
	st		Y+, rCounterL
	st		Y+, rCounterH

		.UNDEF	rCounterL
		.UNDEF	rCounterH

	// Timer intialziton
		/* timer0, timer2 */
		.DEF	timerValue	= r18



	// Initalize Timer0
	lds		timerValue, TCCR0B					// timer prescaling
	sbr		timerValue, ((1 << CS02) | (0 << CS01) | (1 << CS00))
	cbr		timerValue, (1 << CS01)
	sts		TCCR0B, timerValue
	lds		timerValue, TIMSK0					// start timer
	sbr		timerValue, (1 << TOIE0)
	sts		TIMSK0, timerValue

	//					TCCR0A -> TCCR0A_0 == DDRB -> DDB0
	//					TCCR0A -> TCCR0A_1 == DDRB -> DDB1
	//					TCCR0A -> TCCR0A_2 == DDRB -> DDB2
	//					TCCR0A -> TCCR0A_3 == DDRB -> DDB3
	//					TCCR0A -> TCCR0A_4 == DDRB -> DDB4
	//					TCCR0A -> TCCR0A_5 == DDRB -> DDB5
	//					OCR0A -> OCR0A_0 == DDRC -> DDC0
	//					OCR0A -> OCR0A_1 == DDRC -> DDC1
	//					OCR0A -> OCR0A_2 == DDRC -> DDC2
	//					OCR0A -> OCR0A_3 == DDRC -> DDC3
	//					TCNT0 -> TCNT0_4 == DDRC -> DDC4 (joy y)
	//					TCNT0 -> TCNT0_5 == DDRC -> DDC5 (joy x)

	// Initalize Timer2
	lds		timerValue, TCCR2B					// timer prescaling
	sbr		timerValue, ((1 << CS22) | (1 << CS21) | (1 << CS20))
	cbr		timerValue,	((0 << CS22) | (0 << CS21) | (0 << CS20))
	sts		TCCR2B, timerValue
	lds		timerValue, TIMSK2					// start timer
	sbr		timerValue, (1 << TOIE2)
	sts		TIMSK2, timerValue

	//sei											// start interuptions
		.UNDEF	timerValue

	//call	fillBoard
timerTestLoop:
	call	clearMatrix

		/* rCounterL, rCounterH */
		.DEF	rCounterL	= r18
		.DEF	rCounterH	= r19

	ldi		YH, HIGH(renderTimer)	// Set Y to matrix address
	ldi		YL, LOW(renderTimer)
	//ld		rCounterL, Y+ 
	//ld		rCounterH, Y+

	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)

	lds		rCounterL, TIMSK0
	lds		rCounterH, TCCR0A
	st		Y+, rCounterL
	st		Y+, rCounterH
	lds		rCounterL, TCNT0
	lds		rCounterH, OCR0A
	st		Y+, rCounterL
	st		Y+, rCounterH
	lds		rCounterL, TIMSK2
	lds		rCounterH, TCCR2A
	st		Y+, rCounterL
	st		Y+, rCounterH
	lds		rCounterL, TCNT2
	lds		rCounterH, OCR2A
	st		Y+, rCounterL
	st		Y+, rCounterH

		.UNDEF	rCounterL
		.UNDEF	rCounterH

	call	render
	jmp		timerTestLoop
	ret
/* timerTest end */



/**
 * start runing the snake game
 */
snakeGame:
	// Initialize the matrix with a smiley
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

	// Initialize the matrix with a templar cross symbol
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

gameLoop:
	call clearMatrix

		/* The joystick X axis 8 bit value */
		.DEF	rJoystickX	= r6

		/* The joystick Y axis 8 bit value */
		.DEF	rJoystickY	= r7
	
		/* Joystick input registries */
		.DEF	rJoystickL	= r4
		.DEF	rJoystickH	= r5

		/* rColumn */
		.DEF rColumn		= r8

		/* rRow */
		.DEF rRow			= r9

	// Read X axis
	ldi		rArgument0L, 1			// 1 represents X
	call	readJoystick
	mov		rJoystickL, rReturnL	// Store joystick input value
	mov		rJoystickH, rReturnH

	// Convert 10 bit value to 8 bit, discarding lowest 2 bits
	mov		rArgument0L, rJoystickL
	mov		rArgument0H, rJoystickH
	call	joystickValueTo8Bit
	mov		rJoystickX, rReturnL

// TODO Replace temporary code
	// right shift some more to make the value 3 bits (row 0-7)
	mov		rTemp, rJoystickX
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	mov		rTempI, rTemp
	mov		rColumn, rTempI

	// rverse order rColumn (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rColumn
	mov		rColumn, rTempI

	// Read Y axis
	ldi		rArgument0L, 0
	call	readJoystick
	mov		rJoystickL, rReturnL	// Store joystick input value
	mov		rJoystickH, rReturnH

	// Convert 10 bit value to 8 bit, discarding lowest 2 bits
	mov		rArgument0L, rReturnL
	mov		rArgument0H, rReturnH
	call	joystickValueTo8Bit
	mov		rJoystickY, rReturnL

		.UNDEF	rJoystickL
		.UNDEF	rJoystickH

	// Right shift joystick input until it's 3 bits (row 0-7)
	mov		rTemp, rJoystickY
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	mov		rRow, rTemp

	// rverse order rRow (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rRow
	mov		rRow, rTempI

		/* rDirection */
		.DEF rDirection			= r18
		.DEF rDirection2		= r19

	mov		rArgument0L, rJoystickX
	mov		rArgument1L, rJoystickY
	call	joystickValuesToDirection
	mov		rDirection, rReturnL
	mov		rDirection2, rReturnH
	setPixelr	rDirection2, rDirection

		.UNDEF	rDirection
		.UNDEF	rJoystickY
		.UNDEF	rJoystickX
		.UNDEF	rDirection2

	// set joystick pixel
	//setPixelr	rRow, rColumn

		.UNDEF	rRow
		.UNDEF	rColumn

	call	render
	jmp		gameLoop
/* gameLoop */

/**
 * return the direction  depending on the joystick values
 * @param rArgument0L X (0 - 255)
 * @param rArgument1L Y (0 - 255)
 * @return rReturnL	returns the joystick direction (UP, DOWN, LEFT, RIGHT)
 */
joystickValuesToDirection:
		/* rDirection */
		.DEF	rDirectionX		= r20
		.DEF	rDirectionY		= r21

		/* The joystick X/Y axis 8 bit value */
		.DEF	rJoystickX		= r18
		.DEF	rJoystickY		= r19

	mov		rJoystickX, rArgument0L
	mov		rJoystickY, rArgument1L

	ldi		rDirectionY, 3
	ldi		rDirectionX, 3

compareUp:
	cpi		rJoystickY, 128 + JOYSTICK_THRESHOLD - 1
	brlo	compareUpEnd
	ldi		rDirectionY, 0
compareUpEnd:
	
compareDown:
	cpi		rJoystickY, 128 - JOYSTICK_THRESHOLD - 1
	brsh	compareDownEnd
	ldi		rDirectionY, 7
compareDownEnd:

compareLeft:
	cpi		rJoystickX, 128 + JOYSTICK_THRESHOLD - 1
	brlo	compareLeftEnd
	ldi		rDirectionX, 0
compareLeftEnd:

compareRight:
	cpi		rJoystickX, 128 - JOYSTICK_THRESHOLD - 1
	brsh	compareRightEnd
	ldi		rDirectionX, 7
compareRightEnd:

	mov		rReturnL, rDirectionX
	mov		rReturnH, rDirectionY

		.UNDEF	rJoystickX
		.UNDEF	rJoystickY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY

	ret
/* joystickValuesToDirection */



/**
 * renders the positon of the joystick
 */
renderJoystick:

renderJoystickLoop:
	call clearMatrix

		/* The joystick X/Y axis 8 bit value */
		.DEF	rJoystickX	= r6
		.DEF	rJoystickY	= r7

		/* rRow, rColumn */
		.DEF	rRow		= r8
		.DEF	rColumn		= r9
			
		/* Joystick input registries */
		.DEF	rJoystickL	= r4
		.DEF	rJoystickH	= r5

	// Read X axis
	ldi		rArgument0L, 1			// 1 represents X
	call	readJoystick
	mov		rJoystickL, rReturnL	// Store joystick input value
	mov		rJoystickH, rReturnH

	// Convert 10 bit value to 8 bit, discarding lowest 2 bits
	mov		rArgument0L, rJoystickL
	mov		rArgument0H, rJoystickH
	call	joystickValueTo8Bit
	mov		rJoystickX, rReturnL

	// right shift some more to make the value 3 bits (row 0-7)
	mov		rTemp, rJoystickX
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	mov		rColumn, rTemp

	// rverse order rColumn (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rColumn
	mov		rColumn, rTempI

	// Read Y axis
	ldi		rArgument0L, 0			// 0 represents Y
	call	readJoystick
	mov		rJoystickL, rReturnL	// Store joystick input value
	mov		rJoystickH, rReturnH

	// Convert 10 bit value to 8 bit, discarding lowest 2 bits
	mov		rArgument0L, rJoystickL
	mov		rArgument0H, rJoystickH
	call	joystickValueTo8Bit
	mov		rJoystickY, rReturnL

		.UNDEF	rJoystickL
		.UNDEF	rJoystickH

	// Right shift joystick input until it's 3 bits (row 0-7)
	mov		rTemp, rJoystickY
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	lsr		rTemp
	mov		rRow, rTemp

	// rverse order rRow (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rRow
	mov		rRow, rTempI

	// set joystick pixel
	setPixelr rRow, rColumn

		.UNDEF	rJoystickX
		.UNDEF	rJoystickY
		.UNDEF	rRow
		.UNDEF	rColumn

	// Show the joystick position
	call	render
	jmp		renderJoystickLoop
/* renderJoystick end */



/**
 * Renders the matrix to the screen
 */
render:
		/* temporay varabls */
		.DEF	rStatus		= r18

	// save status register and clear global interupts
	in		rStatus, SREG
	push	rStatus
	cli	
			.UNDEF	rStatus

		/* temporay varabls */
		.DEF	rRow		= r18
		.DEF	rColumn		= r19

	ldi		rRow, 1				// Reset row count
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)

renderloop:
	ld		rColumn, Y+			// Load byte from matrix

		/* Output port temp registries */
		.DEF	rPortB		= r20
		.DEF	rPortC		= r21
		.DEF	rPortD		= r22

	// set columns from loaded byte
	bst		rColumn, 7			// column 7
	bld		rPortD, 6
	bst		rColumn, 6			// column 6
	bld		rPortD, 7
	bst		rColumn, 5			// column 5
	bld		rPortB, 0
	bst		rColumn, 4			// column 4
	bld		rPortB, 1
	bst		rColumn, 3			// column 3
	bld		rPortB, 2
	bst		rColumn, 2			// column 2
	bld		rPortB, 3
	bst		rColumn, 1			// column 1
	bld		rPortB, 4
	bst		rColumn, 0			// column 0
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

	// draw row
	out		PORTB, rPortB
	out		PORTC, rPortC
	out		PORTD, rPortD
		
		/* rCounter */
		.DEF	rCounter	= r23

	// show row delay (this is how long the row will be lit up)
	ldi		rCounter, 0
delayLoop:
	nop
	inc		rCounter
	cpi		rCounter, 255
	brne	delayLoop

		.UNDEF	rCounter

	// clear all input
	out		PORTB, ZERO
	out		PORTC, ZERO
	out		PORTD, ZERO

		.UNDEF	rPortB
		.UNDEF	rPortC
		.UNDEF	rPortD

	cpi		rRow, 0x80
	breq	exitRenderloop
	lsl		rRow
	jmp		renderloop
exitRenderloop:

		.UNDEF	rRow
		.UNDEF	rColumn

		/* temporay varabls */
		.DEF	rStatus		= r18

	// restore status register
	pop		rStatus
	out		SREG, rStatus

			.UNDEF	rStatus
	 
	ret
/* render end */



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
		/* rHighByte, rLowByte */
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
	mov		rReturnH, ZERO

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
		/* rRow, rColumn, rRowMask */
		.DEF	rRow		= r18
		.DEF	rColumn		= r19
		.DEF	rRowMask	= r20

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
	add		YL,	rRow
	adc		YH, ZERO
	ld		rRow, Y
	or		rRow, rRowMask
	st		Y, rRow

		.UNDEF	rRow
		.UNDEF	rColumn
		.UNDEF	rRowMask

	ret
/* setPixel end */



/**
 * Clear the matrix
 */
clearMatrix:
		/* rRowMask */
		.DEF	rRowMask	= r18

	// clear the entire matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)
	clr		rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask

		.UNDEF	rRowMask

	ret
/* clearMatrix end */



/**
 * fill the board and show it
 */
fillBoard:
		/* rColumnMask */
		.DEF	rRowMask	= r18

	// Initialize the matrix with a full set
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ser		rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask
	st		Y+, rRowMask

		.UNDEF	rRowMask

fillBoardLoop:
	// simply show the filled board 'til the end of time
	call	render
	jmp		fillBoardLoop
/* fillBoard end */



/**
 * Initialize the hardware
 */
init:
		/* rAddressH/L */
		.DEF	rAddressL	= r18
		.DEF	rAddressH	= r19

	// Initialize stack pointer
	ldi		rAddressH, HIGH(RAMEND)
	out		SPH, rAddressH
	ldi		rAddressL, LOW(RAMEND)
	out		SPL, rAddressL
		
		.UNDEF	rAddressL
		.UNDEF	rAddressH

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

		/* rTempValue */
		.DEF	rTempValue	= r18

	// Initialize analog / digital converter
	lds		rTempValue, ADMUX
	sbr		rTempValue, 0b01000000
	cbr		rTempValue, 0b10000000
	sts		ADMUX, rTempValue

	lds		rTempValue, ADCSRA
	sbr		rTempValue, 0b10000111
	sts		ADCSRA, rTempValue

		.UNDEF	rTempValue

	call	main				// call main (entry point)
	call	terminate			// if returned from main, terminate
/* init end */



/**
 * terminate the program
 */
terminate:
	cli								// no more interupts after termination

		/* rRowMask */
		.DEF	rRowMask	= r18

	// Initialize the matrix with a skull
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)
	ldi		rRowMask, 0b01111110 
	st		Y+, rRowMask
	ldi		rRowMask, 0b11111111
	st		Y+, rRowMask
	ldi		rRowMask, 0b10011001
	st		Y+, rRowMask
	ldi		rRowMask, 0b11111111
	st		Y+, rRowMask
	ldi		rRowMask, 0b11111111
	st		Y+, rRowMask
	ldi		rRowMask, 0b01111110 
	st		Y+, rRowMask
	ldi		rRowMask, 0b01011010
	st		Y+, rRowMask
	ldi		rRowMask, 0b00000000
	st		Y+, rRowMask

		.UNDEF	rRowMask
	
terminateLoop:
	call	render
	jmp		terminateLoop
/* terminate end */
