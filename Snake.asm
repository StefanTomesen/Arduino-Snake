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
	.DEF	rMulResL	= r0
	.DEF	rMulResH	= r1

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

	// Joystick
	.EQU	JOYSTICK_X_AXIS		= 1
	.EQU	JOYSTICK_Y_AXIS		= 0

	.EQU	JOYSTICK_THRESHOLD	= 128 - 16
	.EQU	JOYSTICK_NONE		= 0
	.EQU	JOYSTICK_UP			= 1
	.EQU	JOYSTICK_DOWN		= 2
	.EQU	JOYSTICK_LEFT		= 3
	.EQU	JOYSTICK_RIGHT		= 4

	// Timer
	.EQU	TIMER2_PRE_1024		= ((1 << CS22) | (1 << CS21) | (1 << CS20))

	// Ledjoy
	.EQU	NUM_COLUMNS			= 8
	.EQU	NUM_ROWS			= 8

	// Snake
	.EQU	SNAKE_MAX_LENGTH	= 64
/*	.EQU	SNAKE_SPEED_0		= 4096
	.EQU	SNAKE_SPEED_1		= 2048
	.EQU	SNAKE_SPEED_2		= 1024*/

	// Timer test
	// static twsted time			timer value 4096 = 67 seconds

	.EQU	TIMER_TEST_TARGET_TIME = 512			// 0.5


	// Macro definitions
	
	// logical shift left
	.MACRO	lsl2				// 2x left
		lsl		@0
		lsl		@0
	.ENDMACRO
	.MACRO	lsl3				// 3x left
		lsl2	@0
		lsl		@0
	.ENDMACRO
	.MACRO	lsl4				// 4x left
		lsl2	@0
		lsl2	@0
	.ENDMACRO
	.MACRO	lsl5				// 5x left
		lsl4	@0
		lsl 	@0
	.ENDMACRO
	.MACRO	lsl6				// 6x left
		lsl4	@0
		lsl2	@0
	.ENDMACRO
	.MACRO	lsl7				// 7x left
		lsl4	@0
		lsl3	@0
	.ENDMACRO
	
	// logical shift right					
	.MACRO	lsr2				// 2x right
		lsr		@0
		lsr		@0
	.ENDMACRO
	.MACRO	lsr3				// 3x right
		lsr2	@0
		lsr 	@0
	.ENDMACRO
	.MACRO	lsr4				// 4x right
		lsr2	@0
		lsr2	@0
	.ENDMACRO
	.MACRO	lsr5				// 5x right
		lsr4	@0
		lsr 	@0
	.ENDMACRO
	.MACRO	lsr6				// 6x right
		lsr4	@0
		lsr2	@0
	.ENDMACRO
	.MACRO	lsr7				// 7x right
		lsr4	@0
		lsr3	@0
	.ENDMACRO
	
	.MACRO	setPixelr			// SetPixel subroutine call from register
		mov		rArgument0L, @0
		mov		rArgument1L, @1
		call	setPixel
	.ENDMACRO

	.MACRO	setPixeli			// SetPixel subroutine call from constant
		ldi		rArgument0L, @0
		ldi		rArgument1L, @1
		call	setPixel
	.ENDMACRO
	
	.MACRO beqi				// branch if equal
		cpi		@0, @1
		breq	@2
	.ENDMACRO
	.MACRO beq
		cp		@0, @1
		breq	@2
	.ENDMACRO
	
	.MACRO bnei				// branch if not equal
		cpi		@0, @1
		brne	@2
	.ENDMACRO
	.MACRO bne
		cp		@0, @1
		brne	@2
	.ENDMACRO

	/**
	 * Add constant to a 16 bit composite virtual register outside of X, Y and Z
	 * param @0 - Low register
	 * param @1 - High register
	 * param @2 - 16 bit constant
	 */
	.MACRO addiw 
		subi	@0, LOW(-@2)
		sbci	@1, HIGH(-@2)
	.ENDMACRO

	/**
	 * Increment a timer data structure. 
	 * @param @0 - The label to a timer
	 */
	.MACRO incrementTimer
		// load timer value
		ldi		YH, HIGH(@0)
		ldi		YL, LOW(@0)
		ldd		rTimerValueL, Y + TimerCurrentTimeL
		ldd		rTimerValueH, Y + TimerCurrentTimeH

		// increase time by 1
		addiw rTimerValueL, rTimerValueH, 1

		// store time
		ldi		YH, HIGH(@0)	// Set Y to matrix address
		ldi		YL, LOW(@0)
		st		Y+, rTimerValueL
		st		Y+, rTimerValueH
	.ENDMACRO

	// timer data structure
	.EQU	TimerSize			= 6
	.EQU	TimerCurrentTimeL	= 0x00
	.EQU	TimerCurrentTimeH	= 0x01
	.EQU	TimerTargetTimeL	= 0x02
	.EQU	TimerTargetTimeH	= 0x03
	.EQU	TimerScalarL		= 0x04
	.EQU	TimerScalarH		= 0x05

	// Vector2 data structure
	.EQU	Vector2Size			= 2
	.EQU	Vector2X			= 0x00
	.EQU	Vector2Y			= 0x01

	/**							
	 * Data Segment
	 */
	.DSEG

matrix:			.BYTE	NUM_ROWS					// LED matrix - 1 bit per "pixel"
renderTimer:	.BYTE	TimerSize
updateTimer:	.BYTE	TimerSize
snakeVector:	.BYTE	SNAKE_MAX_LENGTH * Vector2Size

	/**							
	 * Code segment
	 */
	.CSEG

	// Initialization / reset interupt
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
 * Handle overflow interupts from timer 0
 */
timer0OverflowInterupt:

	reti
/* timer0OverflowInterupt end */



/**
 * Handle overflow interupts from timer 1
 */
timer2OverflowInterupt:
	
		.DEF	rStatus		= r18

	// save status
	push	rStatus						// save register
	in		rStatus, SREG				
	push	rStatus
		
		.UNDEF	rStatus

		/* The timercounter value  */
		.DEF	rTimerValueL	= r18
		.DEF	rTimerValueH	= r19
		.DEF	rTimerTargetL	= r20
		.DEF	rTimerTargetH	= r21

	// Push used registers
	push	rTimerValueL
	push	rTimerValueH
	push	rTimerTargetL
	push	rTimerTargetH
	push	YL
	push	YH
	
	incrementTimer renderTimer
	incrementTimer updateTimer

	// post stack stuff
	pop		YH
	pop		YL
	pop		rTimerTargetH
	pop		rTimerTargetL
	pop		rTimerValueH
	pop		rTimerValueL				

		.UNDEF	rTimerValueL
		.UNDEF	rTimerValueH
		.UNDEF	rTimerTargetL
		.UNDEF	rTimerTargetH

		.DEF	rStatus		= r18

	// restore status
	pop		rStatus
	out		SREG, rStatus
	pop		rStatus						// restore register
		
		.UNDEF	rStatus

	reti
/* timer2OverflowInterupt end */


/**
 * Start runing the timer test
 */
timerTest:
	
		.DEF	rTimerValueL	= r18
		.DEF	rTimerValueH	= r19
		.DEF	rTimerTargetL	= r20
		.DEF	rTimerTargetH	= r21
	
	// Set target time
	ldi rTimerTargetH, HIGH(TIMER_TEST_TARGET_TIME)
	ldi rTimerTargetL, LOW(TIMER_TEST_TARGET_TIME)

	// Reset current time
	clr		rTimerValueL
	clr		rTimerValueH

	// reset renderTimer
	ldi		YH, HIGH(renderTimer)	// Set Y to matrix address
	ldi		YL, LOW(renderTimer)
	std		Y + TimerCurrentTimeL, rTimerValueL
	std		Y + TimerCurrentTimeH, rTimerValueH
	std		Y + TimerTargetTimeL, rTimerTargetL
	std		Y + TimerTargetTimeH, rTimerTargetH

	ldi rTimerTargetH, HIGH(250)
	ldi rTimerTargetL, LOW(250)

	// reset updateTimer
	ldi		YH, HIGH(updateTimer)	// Set Y to matrix address
	ldi		YL, LOW(updateTimer)
	std		Y + TimerCurrentTimeL, rTimerValueL
	std		Y + TimerCurrentTimeH, rTimerValueH
	std		Y + TimerTargetTimeL, rTimerTargetL
	std		Y + TimerTargetTimeH, rTimerTargetH

		.UNDEF	rTimerValueL
		.UNDEF	rTimerValueH
		.UNDEF	rTimerTargetL
		.UNDEF	rTimerTargetH

	// Timer initializiton
	ldi rArgument0L, TIMER2_PRE_1024
	call initializeTimer2


	// timer mystery debug code
	/*
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
	*/

	sei
timerTestLoop:
	call	clearMatrix

		/* rCounterL, rCounterH */
		.DEF	rCounterL	= r18
		.DEF	rCounterH	= r19

	ldi		YH, HIGH(renderTimer)	// Set Y to matrix address
	ldi		YL, LOW(renderTimer)
	ld		rCounterL, Y+ 
	ld		rCounterH, Y+

	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	st		Y+, rCounterL
	st		Y+, rCounterH
	
	ldi		YH, HIGH(updateTimer)	// Set Y to matrix address
	ldi		YL, LOW(updateTimer)
	ld		rCounterL, Y+ 
	ld		rCounterH, Y+
	
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	addiw	YL, YH, 2
	st		Y+, rCounterL
	st		Y+, rCounterH

		.UNDEF	rCounterL
		.UNDEF	rCounterH


		/* The timercounter value  */
		.DEF	rTimerValueL	= r18
		.DEF	rTimerValueH	= r19
		.DEF	rTimerTargetL	= r20
		.DEF	rTimerTargetH	= r21

	// load timer value
	ldi		YH, HIGH(renderTimer)
	ldi		YL, LOW(renderTimer)
	ldd		rTimerValueL, Y + TimerCurrentTimeL
	ldd		rTimerValueH, Y + TimerCurrentTimeH

	// Load target time
	ldd		rTimerTargetL, Y + TimerTargetTimeL
	ldd		rTimerTargetH, Y + TimerTargetTimeH

	// If time is at target time, skip reset
	//bne		rTimerValueL, rTimerTargetL, resetTimeEnd
	cp		rTimerValueL, rTimerTargetL

	//brlo	resetTimeEnd
	//bne		rTimerValueH, rTimerTargetH, resetTimeEnd
	cpc		rTimerValueH, rTimerTargetH
	brlo	resetTimeEnd1
	// Reset 
	clr		rTimerValueL
	clr		rTimerValueH
	jmp		ughosierughose
resetTimeEnd1:

	// store time
	ldi		YH, HIGH(renderTimer)	// Set Y to matrix address
	ldi		YL, LOW(renderTimer)
	std		Y + TimerCurrentTimeL, rTimerValueL
	std		Y + TimerCurrentTimeH, rTimerValueH

	// load timer value
	ldi		YH, HIGH(updateTimer)
	ldi		YL, LOW(updateTimer)
	ldd		rTimerValueL, Y + TimerCurrentTimeL
	ldd		rTimerValueH, Y + TimerCurrentTimeH

	// Load target time
	ldd		rTimerTargetL, Y + TimerTargetTimeL
	ldd		rTimerTargetH, Y + TimerTargetTimeH

	// If time is at target time, skip reset
	//bne		rTimerValueL, rTimerTargetL, resetTimeEnd
	cp		rTimerValueL, rTimerTargetL

	//brlo	resetTimeEnd
	//bne		rTimerValueH, rTimerTargetH, resetTimeEnd
	cpc		rTimerValueH, rTimerTargetH
	brlo	resetTimeEnd2
	// Reset 
	clr		rTimerValueL
	clr		rTimerValueH
resetTimeEnd2:

	// store time
	ldi		YH, HIGH(updateTimer)	// Set Y to matrix address
	ldi		YL, LOW(updateTimer)
	std		Y + TimerCurrentTimeL, rTimerValueL
	std		Y + TimerCurrentTimeH, rTimerValueH

		.UNDEF	rTimerValueL
		.UNDEF	rTimerValueH
		.UNDEF	rTimerTargetL
		.UNDEF	rTimerTargetH

	call	render
	jmp		timerTestLoop
	ret
/* timerTest end */



/**
 * Program: Snake
 * Start runing the snake game
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
	lsr5	rTemp
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
	lsr5	rTemp
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
 * 
 * Fill the board and show it
 */
fillBoard:
	call setMatrix

fillBoardLoop:
	// Simply show the filled board 'til the end of time
	call	render
	jmp		fillBoardLoop
/* fillBoard end */


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
	lsr5	rTemp
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
	lsr5	rTemp
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
		.DEF	rStatus		= r18

	// save status register and clear global interupts
	in		rStatus, SREG
	push	rStatus
	cli	

		.UNDEF	rStatus

		.DEF	rRow		= r18
		.DEF	rColumn		= r19
		.DEF	rRowCount	= r20

	ldi		rRowCount, 0		// Reset row count
	ldi		rRow, 1				// Reset row bits
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
/*	ldi		rCounter, 16 // temp
	mul		rRowCount, rCounter
	lds		rCounter, TCNT2
	cp		rCounter, rMulResL
	brlo	delayLoop*/
	inc		rCounter
	cpi		rCounter, 255
	brne	delayLoop

		.UNDEF	rCounter

	// clear all input
	clr rPortB
	clr rPortC
	clr rPortD

	// clear row
	out		PORTB, rPortB
	out		PORTC, rPortC
	out		PORTD, rPortD

		.UNDEF	rPortB
		.UNDEF	rPortC
		.UNDEF	rPortD

	cpi		rRow, 0x80
	breq	exitRenderloop
	lsl		rRow
	subi	rRowCount, -1
	jmp		renderloop
exitRenderloop:

		.UNDEF	rRowCount
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
 * Clear the matrix
 */
clearMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// clear the entire matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)
	clr		rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* clearMatrix end */



/**
 * Set all the bits in the matrix
 */
setMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Initialize the matrix with a full set
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ser		rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* setMatrix end */



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
 * @param rArgument0H + rArgument0L - 10 bit value from the joystick input
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
	ldi		rReturnH, 0

		.UNDEF	rHighByte
		.UNDEF	rLowByte

	ret
/* joystickValueTo8Bit end */



/**
 * return the direction  depending on the joystick values
 * @param rArgument0L - X (0 - 255)
 * @param rArgument1L - Y (0 - 255)
 * @return rReturnL - Returns the joystick direction (UP, DOWN, LEFT, RIGHT)
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
 * Initialize timer 2 with a specific presscaling. The prescaling argument is in the 
 * range 0 - 7 using the bits (CS22, CS21, CS20), and represents timer scaling values 
 * of 1 - 1024 as defined by the hardware.
 * @param rArgument0L - Prescaling to be used
 */
 initializeTimer2:
		.DEF rControlBits = r18
		.DEF rPrescaling = r19
	mov rPrescaling, rArgument0L
	andi rPrescaling, ((1 << CS22) | (1 << CS21) | (1 << CS20))
												
	lds		rControlBits, TCCR2B										// Load timer control register B
	or		rControlBits, rPrescaling									// Set prescaling bits
	ori		rPrescaling, ~((1 << CS22) | (1 << CS21) | (1 << CS20))		// Inverted prescale bit mask
	and		rControlBits, rPrescaling									// Clear prescaling bits
	sts		TCCR2B, rControlBits										// Store timer control register B

	// Set timer enabled bit - enable interrupts
	lds		rControlBits, TIMSK2										
	sbr		rControlBits, (1 << TOIE2)
	sts		TIMSK2, rControlBits

		.UNDEF rPrescaling
		.UNDEF rControlBits
/* initializeTimer2 end */

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
		.DEF	rZero		= r21

	ldi rZero, 0

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
	adc		YH, rZero
	ld		rRow, Y
	or		rRow, rRowMask
	st		Y, rRow

		.UNDEF	rRow
		.UNDEF	rColumn
		.UNDEF	rRowMask

	ret
/* setPixel end */



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

		/* Temporary value for modifying the ADMUX state */
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
	call initializeTimer2//, 0b111

		/* Joystick input registers */
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

	// right shift some more to make the value 3 bits (row 0-7)
	lsr5	rColumn

	// rverse order rColumn (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rColumn
	mov		rColumn, rTempI

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
	lsr5	rRow

	// Reverse row order (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rRow
	mov		rRow, rTempI

	setPixelr	rRow, rColumn

		/* Joystick input registries */
		.DEF	rRowi		= r16
		.DEF	rColumni	= r17

	mov		rRowi,		rRow
	mov		rColumni,	rColumn

	// Program at (0,0) - Timer test
	setPixeli	0, 0
	bnei	rRowi, 0, skipProgram00
	bnei	rColumni, 0, skipProgram00
	call	timerTest
	jmp		mainLoopEnd
skipProgram00:

	// Program at (0,7) - Render Joystick
	setPixeli	0, 7
	bnei	rRowi, 0, skipProgram07
	bnei	rColumni, 7, skipProgram07
	call	renderJoystick
	jmp		mainLoopEnd
skipProgram07:

	// Program at (7,0) - Snake Game
	setPixeli	7, 0
	bnei	rRowi, 7, skipProgram70
	bnei	rColumni, 0, skipProgram70
	call	snakeGame
	jmp		mainLoopEnd
skipProgram70:

	// Program at (7,7) - Snake Game
	setPixeli	7, 7
	bnei	rRowi, 7, skipProgram77
	bnei	rColumni, 7, skipProgram77
	call	fillBoard
	jmp		mainLoopEnd
skipProgram77:

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
 * Terminate the program
 */
terminate:
	cli								// no more interupts after termination

		/* The  */
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
