/**
 *	Snake
 *
 *	Skola assemble setting
 *	avrdude -C "C:\WinAVR-20100110\bin\avrdude.conf" -patmega328p -Pcom4 -carduino -b115200 -Uflash:w:Snake.hex 
 *
 *	Thism2 assemble setting
 *	avrdude -C "E:\Övrigt\WinAVR-20100110\bin\avrdude.conf" -p atmega328p -P com3 -c arduino -b 115200 -U flash:w:Snake.hex 
 *
 */ 

	/** 
	 * Global Register Definitions
	 */
	.DEF	rMulResL	= r0
	.DEF	rMulResH	= r1

	.DEF	rReturnL	= r24
	.DEF	rReturnH	= r25

	.DEF	rArgument0L	= r24
	.DEF	rArgument0H	= r25

	.DEF	rArgument1L	= r22
	.DEF	rArgument1H	= r23

	/*
	.DEF	rArgument2L	= r20
	.DEF	rArgument2H	= r21

	.DEF	rArgument3L	= r18
	.DEF	rArgument3H	= r19
	*/

	/**
	 * Global constant definitions
	 */ 
	.EQU	RESETaddr			= 0x0000

	/* Joystick */
	.EQU	JOYSTICK_X_AXIS		= 1
	.EQU	JOYSTICK_Y_AXIS		= 0

	.EQU	JOYSTICK_THRESHOLD	= 128 - 64
	.EQU	JOYSTICK_NONE		= 0
	.EQU	JOYSTICK_UP			= 1
	.EQU	JOYSTICK_DOWN		= 2
	.EQU	JOYSTICK_LEFT		= 3
	.EQU	JOYSTICK_RIGHT		= 4

	/* Ledjoy */
	.EQU	NUM_COLUMNS			= 8
	.EQU	NUM_ROWS			= 8
	
	/* Timer2 */
	.EQU	TIMER2_PRE_1024		= ((1 << CS22) | (1 << CS21) | (1 << CS20))
	// A timer value of 4096 roughly represents 67 seconds with 1024 prescaling

	/**
	 * Struct definitions. Each struct consists of a number of constants, one of which 
	 * being the size of instances of the struct. Data is accessed by using a label as
	 * a pointer to the instance and applying an offset defined in the data structure
	 * section to access individual variables
	 */

	/* Timer */
	// Constants
	.EQU	TIMER_DATA_SIZE		= 6
	// Data structure
	.EQU	oTimerCurrentTimeL	= 0x00
	.EQU	oTimerCurrentTimeH	= 0x01
	.EQU	oTimerTargetTimeL	= 0x02
	.EQU	oTimerTargetTimeH	= 0x03
	.EQU	oTimerCallbackL		= 0x04
	.EQU	oTimerCallbackH		= 0x05

/*
	* Vector2 *
	// Constants
	.EQU	VECTOR2_DATA_SIZE	= 2
	// Data structure
	.EQU	oVector2X			= 0x00
	.EQU	oVector2Y			= 0x01	
*/

	/* Snake */
	// Constants
	.EQU	SNAKE_MAX_LENGTH	= 64
	.EQU	SNAKE_DATA_SIZE		= 5 + (SNAKE_MAX_LENGTH * 2)
	// Data structure
	.EQU	oSnakeDirectionX		= 0x00
	.EQU	oSnakeDirectionY		= 0x01
	.EQU	oSnakeNextDirectionX	= 0x02
	.EQU	oSnakeNextDirectionY	= 0x03
	.EQU	oSnakeLength			= 0x04


	/* FlashFood */
	// Constants
	.EQU	FLASH_FOOD_DATA_SIZE	= 3
	// Data structure
	.EQU	oFlashFoodPositionX		= 0x00
	.EQU	oFlashFoodPositionY		= 0x01
	.EQU	oIsLitUp				= 0x02


	/**
	 * Program constant definitions
	 */

	/* Snake Game */
	.EQU	SNAKE_UPDATE_TIME		= 16
	.EQU	SNAKE_FOOD_UPDATE_TIME	= 13

	/* Timer test */
	.EQU	TIMER_TEST_TARGET_TIME	= 512			// 0.5
	

	/**							
	 * Data Segment
	 */
	.DSEG

matrix:			.BYTE	NUM_ROWS					// LED matrix - 1 bit per "pixel" = one byte per row
renderTimer:	.BYTE	TIMER_DATA_SIZE
updateTimer:	.BYTE	TIMER_DATA_SIZE
flashFoodTimer:	.BYTE	TIMER_DATA_SIZE

// Snake data
snake:			.BYTE	SNAKE_DATA_SIZE
snakeX:			.BYTE	SNAKE_MAX_LENGTH
snakeY:			.BYTE	SNAKE_MAX_LENGTH
flashFood:		.BYTE	FLASH_FOOD_DATA_SIZE


	/** 
	 * Macro definitions
	 */
	
	/* logical shift left */
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
	
	/* logical shift right */
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

	/* Branch macros */

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
	 * Sets a pixel based on register input
	 * @param @0 - Y value of the pixel to be set
	 * @param @1 - Y value of the pixel to be set
	 */
	.MACRO	setPixelr			// SetPixel subroutine call from register
		mov		rArgument0L, @0
		mov		rArgument1L, @1
		call	setPixel
	.ENDMACRO

	/**
	 * Clears a pixel based on register input
	 * @param @0 - Y value of the pixel to be cleared
	 * @param @1 - Y value of the pixel to be cleared
	 */
	.MACRO	clearPixelr			// SetPixel subroutine call from register
		mov		rArgument0L, @0
		mov		rArgument1L, @1
		call	clearPixel
	.ENDMACRO

	/**
	 * Sets a pixel based on a constant value
	 * @param @0 - Y value of the pixel to be set
	 * @param @1 - Y value of the pixel to be set
	 */
	.MACRO	setPixeli			// SetPixel subroutine call from constant
		ldi		rArgument0L, @0
		ldi		rArgument1L, @1
		call	setPixel
	.ENDMACRO

	/**
	 * Clears a pixel based on a constant value
	 * @param @0 - Y value of the pixel to be cleared
	 * @param @1 - Y value of the pixel to be cleared
	 */
	.MACRO	clearPixeli			// SetPixel subroutine call from constant
		ldi		rArgument0L, @0
		ldi		rArgument1L, @1
		call	clearPixel
	.ENDMACRO

	/**
	 * Increment a timer data structure. 
	 * @param @0 - The label to a timer
	 */
	.MACRO incrementTimer
			/* The timercounter value  */
			.DEF	rTimerValueL	= r18
			.DEF	rTimerValueH	= r19

		// Push used registers
		push	rTimerValueL
		push	rTimerValueH
		push	YL
		push	YH

		// load timer value
		ldi		YH, HIGH(@0)
		ldi		YL, LOW(@0)
		ldd		rTimerValueL, Y + oTimerCurrentTimeL
		ldd		rTimerValueH, Y + oTimerCurrentTimeH

		// increase time by 1
		addiw rTimerValueL, rTimerValueH, 1

		// store time
		ldi		YH, HIGH(@0)	// Set Y to matrix address
		ldi		YL, LOW(@0)
		std		Y + oTimerCurrentTimeL, rTimerValueL
		std		Y + oTimerCurrentTimeH, rTimerValueH

		// post stack stuff
		pop		YH
		pop		YL
		pop		rTimerValueH
		pop		rTimerValueL				

			.UNDEF	rTimerValueL
			.UNDEF	rTimerValueH
	.ENDMACRO

	/**
	 * Set the callback for a timer data structure. 
	 * @param @0 - The label to the timer
	 * @param @1 - Target time constant 
	 * @param @2 - The label to the timer's callback 
	 */
	.MACRO initializeTimer
			.DEF	tempL = r18
			.DEF	tempH = r19
		push	tempL
		push	tempH
		push	YH
		push	YL

		// load timer value
		ldi		YH, HIGH(@0)
		ldi		YL, LOW(@0)
		ldi		tempL, 0
		ldi		tempH, 0
		std		Y + oTimerCurrentTimeL, tempL
		std		Y + oTimerCurrentTimeH, tempH
		ldi		tempL, LOW(@1)
		ldi		tempH, HIGH(@1)
		std		Y + oTimerTargetTimeL, tempL
		std		Y + oTimerTargetTimeH, tempH
		ldi		tempL, LOW(@2)
		ldi		tempH, HIGH(@2)
		std		Y + oTimerCallbackL, tempL
		std		Y + oTimerCallbackH, tempH

		pop		YL
		pop		YH
		pop		tempH
		pop		tempL
			.UNDEF	tempL
			.UNDEF	tempH
	.ENDMACRO


	
	/**
	 * Checks whether a timer has reached its target value and resets the timer if it has
	 * @param @0 - the timer label
	 * @rReturnL - boolean whether or not the timer has reached its target
	 */
	.MACRO checkTimer
			.DEF	rValueL = r18
			.DEF	rValueH = r19
			.DEF	rCompareL = r20
			.DEF	rCompareH = r21

		push	YL
		push	YH
		push	rValueL
		push	rValueH
		push	rCompareL
		push	rCompareH

		ldi		YH, HIGH(@0)						// Load timer adress
		ldi		YL, LOW(@0)
		ldd		rValueL, Y + oTimerCurrentTimeL		// Load timer value	
		ldd		rValueH, Y + oTimerCurrentTimeH
		ldd		rCompareL, Y + oTimerTargetTimeL	// Load timer target value
		ldd		rCompareH, Y + oTimerTargetTimeH
	
		ldi		rReturnL, 0

		cp		rValueL, rCompareL					// Compare current value with target
		cpc		rValueH, rCompareH
		brlo	checkTimerSkipReset					// Skip reset if less than

		// Reset the timer and return true
		ldi		rValueL, 0
		ldi		rValueH, 0
		std		Y + oTimerCurrentTimeL, rValueL
		std		Y + oTimerCurrentTimeH, rValueH
		ldi		rReturnL, 1
	checkTimerSkipReset:
	
		pop		YH
		pop		YL
		pop		rCompareH
		pop		rCompareL
		pop		rValueH
		pop		rValueL

			.UNDEF	rValueL
			.UNDEF	rValueH
			.UNDEF	rCompareL 
			.UNDEF	rCompareH

	.ENDMACRO



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
	
	incrementTimer renderTimer
	incrementTimer updateTimer
	incrementTimer flashFoodTimer

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

	initializeTimer renderTimer, TIMER_TEST_TARGET_TIME, 0 /*TODO Add callback*/
	initializeTimer updateTimer, 250, 0 /* TODO Add callback */

	// Timer initializiton
	ldi rArgument0L, TIMER2_PRE_1024
	call initializeHardwareTimer2


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
	adiw	Y, 2
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
	ldd		rTimerValueL, Y + oTimerCurrentTimeL
	ldd		rTimerValueH, Y + oTimerCurrentTimeH

	// Load target time
	ldd		rTimerTargetL, Y + oTimerTargetTimeL
	ldd		rTimerTargetH, Y + oTimerTargetTimeH

	// If current time is lowe
	cp		rTimerValueL, rTimerTargetL
	cpc		rTimerValueH, rTimerTargetH
	brlo	resetTimeEnd1
	// Reset 
	clr		rTimerValueL
	clr		rTimerValueH
resetTimeEnd1:

	// store time
	ldi		YH, HIGH(renderTimer)	// Set Y to matrix address
	ldi		YL, LOW(renderTimer)
	std		Y + oTimerCurrentTimeL, rTimerValueL
	std		Y + oTimerCurrentTimeH, rTimerValueH

	// load timer value
	ldi		YH, HIGH(updateTimer)
	ldi		YL, LOW(updateTimer)
	ldd		rTimerValueL, Y + oTimerCurrentTimeL
	ldd		rTimerValueH, Y + oTimerCurrentTimeH

	// Load target time
	ldd		rTimerTargetL, Y + oTimerTargetTimeL
	ldd		rTimerTargetH, Y + oTimerTargetTimeH

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
	std		Y + oTimerCurrentTimeL, rTimerValueL
	std		Y + oTimerCurrentTimeH, rTimerValueH

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
	// Timer initializiton
	ldi rArgument0L, TIMER2_PRE_1024
	call initializeHardwareTimer2

	initializeTimer updateTimer, SNAKE_UPDATE_TIME, 0 // TODO remove callback (0)
	initializeTimer flashFoodTimer, SNAKE_FOOD_UPDATE_TIME, 0 // TODO remove callback (0)
	
		.DEF	rFlashFoodX	= r18
		.DEF	rFlashFoodY	= r19
		.DEF	rIsLit		= r20

	// Initalize flashFood
	ldi		YH, HIGH(flashFood)		// Set Y to snakeX address
	ldi		YL, LOW(flashFood)
	ldi		rFlashFoodX, 5
	ldi		rFlashFoodY, 5
	ldi		rIsLit, 0
	std		Y + oFlashFoodPositionX, rFlashFoodX
	std		Y + oFlashFoodPositionY, rFlashFoodY
	std		Y + oIsLitUp, rIsLit

		.UNDEF	rFlashFoodX
		.UNDEF	rFlashFoodY
		.UNDEF	rIsLit
snakeGameLoop:

		/* The directions the joystick is pointed */
		.DEF rDirectionX		= r16
		.DEF rDirectionY		= r17
		.DEF rPreviousDirectionX	= r18
		.DEF rPreviousDirectionY	= r19

	call	readJoystickDirection
	mov		rDirectionX, rReturnL
	mov		rDirectionY, rReturnH

	// If the current direction is neutral, don't change the direction
	cpi		rDirectionX, 0
	brne	snakeGameChangeDirection
	cpi		rDirectionY, 0
	brne	snakeGameChangeDirection
	jmp		snakeGameSkipChangeDirection 

snakeGameChangeDirection:
	// Load the previous snake direction
	ldi		YH, HIGH(snake)	// Set Y to matrix address
	ldi		YL, LOW(snake)
	ldd		rPreviousDirectionX, Y + oSnakeDirectionX
	ldd		rPreviousDirectionY, Y + oSnakeDirectionY

	// If the current direction is opposite to the previous, skip chanign the direction, in order to prevent colliding with yourself
	neg		rPreviousDirectionX
	neg		rPreviousDirectionY
	cp		rDirectionX, rPreviousDirectionX
	brne	snakeGameChangeDirection2
	cp		rDirectionY, rPreviousDirectionY
	brne	snakeGameChangeDirection2
	jmp		snakeGameSkipChangeDirection 

snakeGameChangeDirection2:
	// store snake direction
	ldi		YH, HIGH(snake)	// Set Y to matrix address
	ldi		YL, LOW(snake)
	std		Y + oSnakeNextDirectionX, rDirectionX
	std		Y + oSnakeNextDirectionY, rDirectionY

		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
		.UNDEF rPreviousDirectionX
		.UNDEF rPreviousDirectionY

snakeGameSkipChangeDirection:

	checkTimer updateTimer	// returns boolean whether the timer has reached it's target time and reset	
	cpi		rReturnL, 1
	breq	snakeGameUpdate


	// check if it should make the food flash 
	checkTimer flashFoodTimer	// returns boolean whether the timer has reached it's target time and reset	
	cpi		rReturnL, 0
	breq	snakeGameUpdateFlashFoodEnd

		.DEF	rIsLit = r18

	// load flashFood
	ldi		YH, HIGH(flashFood)					// Set Y to snakeX address
	ldi		YL, LOW(flashFood)
	ldd		rIsLit, Y + oIsLitUp
	com		rIsLit							
	std		Y + oIsLitUp, rIsLit

		.UNDEF	rIsLit

snakeGameUpdateFlashFoodEnd:	

		.DEF	rFlashFoodX	= r2
		.DEF	rFlashFoodY	= r3
		.DEF	rIsLit	= r16

	// load flashFood
	ldi		YH, HIGH(flashFood)		// Set Y to snakeX address
	ldi		YL, LOW(flashFood)
	ldd		rFlashFoodX, Y + oFlashFoodPositionX
	ldd		rFlashFoodY, Y + oFlashFoodPositionY
	ldd		rIsLit, Y + oIsLitUp


	clearPixelr	rFlashFoodY, rFlashFoodX
	cpi		rIsLit, 0
	breq	snakeGameSkipDrawFood
	setPixelr	rFlashFoodY, rFlashFoodX

snakeGameSkipDrawFood:

		.UNDEF	rFlashFoodX
		.UNDEF	rFlashFoodY
		.UNDEF	rIsLit



snakeGameLoopEnd:

	call	render
	jmp		snakeGameLoop



snakeGameUpdate:
	call clearMatrix				// Start with clear
		
		.DEF rSnakeDirectionX	= r18
		.DEF rSnakeDirectionY	= r19
		.DEF rSnakeHeadX		= r16
		.DEF rSnakeHeadY		= r17

	// Load the previous snake direction
	ldi		YH, HIGH(snake)	// Set Y to matrix address
	ldi		YL, LOW(snake)

	ldd		rSnakeDirectionX, Y + oSnakeNextDirectionX
	ldd		rSnakeDirectionY, Y + oSnakeNextDirectionY
	std		Y + oSnakeDirectionX, rSnakeDirectionX
	std		Y + oSnakeDirectionY, rSnakeDirectionY

	// laod head x
	ldi		YH, HIGH(snakeX)		// Set Y to snakeX address
	ldi		YL, LOW(snakeX)
	ldd		rSnakeHeadX, Y + 0		// X at index n = 0
	// laod head y
	ldi		YH, HIGH(snakeY)		// Set Y to snakeY address
	ldi		YL, LOW(snakeY)
	ldd		rSnakeHeadY, Y + 0		// y at index n = 0

	// add direction
	add		rSnakeHeadX, rSnakeDirectionX
	add		rSnakeHeadY, rSnakeDirectionY

	// wrap snake head
	andi	rSnakeHeadX, 0b0000111
	andi	rSnakeHeadY, 0b0000111

	// store the head posotion x
	ldi		YH, HIGH(snakeX)		// Set Y to snakeX address
	ldi		YL, LOW(snakeX)
	std		Y + 0, rSnakeHeadX
	// store the head posotion y
	ldi		YH, HIGH(snakeY)		// Set Y to snakeY address
	ldi		YL, LOW(snakeY)
	std		Y + 0, rSnakeHeadY		

	subi	rSnakeDirectionX, - 3
	subi	rSnakeDirectionY, - 3

	setPixelr	rSnakeDirectionY, rSnakeDirectionX
	setPixelr	rSnakeHeadY, rSnakeHeadX
		
		.UNDEF	rSnakeDirectionX
		.UNDEF	rSnakeDirectionY
		.UNDEF	rSnakeHeadX
		.UNDEF	rSnakeHeadY

	jmp snakeGameLoopEnd
snakeGameUpdateEnd:

	ret			// end or...?
/* gameLoop */

/**
 * Program: FillBoard
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
 * Program: Render Joystick
 * renders the positon of the joystick
 */
renderJoystick:

renderJoystickLoop:
	call clearMatrix
		
		/* Temp registers */
		.DEF	rTemp = r2
		.DEF	rTempI = r16

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

	// Reverse order rRow (7-0 -> 0-7)
	ldi		rTempI, 7
	sub		rTempI, rRow
	mov		rRow, rTempI

	// Set joystick pixel
	setPixelr rRow, rColumn

		.UNDEF	rJoystickX
		.UNDEF	rJoystickY
		.UNDEF	rRow
		.UNDEF	rColumn
		.UNDEF	rTemp
		.UNDEF	rTempI

	// Show the joystick position
	call	render
	jmp		renderJoystickLoop
/* renderJoystick end */


/**
 * Renders the matrix to the screen
 */
render:
		/* Free up the argument registers during the subroutine */
		.UNDEF	rArgument1L		// r22
		.UNDEF	rArgument1H		// r23

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
		.DEF	rPortB		= r21
		.DEF	rPortC		= r22
		.DEF	rPortD		= r23

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
		
		.UNDEF	rPortB
		.UNDEF	rPortC
		.UNDEF	rPortD

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

		.DEF	rPortB		= r21
		.DEF	rPortC		= r22
		.DEF	rPortD		= r23

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

	// Restore the status register to the state it was in prior to the subroutine call
		.DEF	rStatus		= r18
	pop		rStatus
	out		SREG, rStatus
		.UNDEF	rStatus
	 
		/* Restore the argument register definitions */
		.DEF	rArgument1L	= r22
		.DEF	rArgument1H	= r23

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
		.DEF	rMaskBits = r18
		.DEF	rADMUX = r19
	
	andi	rArgument0L, 1			// Mask out LSB
	mov		rMaskBits, rArgument0L		
	ori		rMaskBits, 0b00000100	// choose joystick axis (port 4=Y / 5=X) 

	lds		rADMUX, ADMUX			// Load ADMUX byte
	or		rADMUX, rMaskBits		// set bit that should be set
	ori		rMaskBits, 0b11110000	// mask out preserved bits
	and		rADMUX, rMaskBits		// clear bits that should be cleared
	sts		ADMUX, rADMUX			// Write ADMUX byte back
		
		.UNDEF	rADMUX
		.UNDEF	rMaskBits

		.DEF	rADCSRA = r18

	// start convertion

	lds		rADCSRA, ADCSRA
	ori		rADCSRA, 0b01000000		
	sts		ADCSRA, rADCSRA

	// load loop - wait until value loaded
readLoop:
	lds		rADCSRA, ADCSRA
	sbrc	rADCSRA, 6
	jmp		readLoop

	// return value
	lds		rReturnL, ADCL
	lds		rReturnH, ADCH

		.UNDEF	rADCSRA

	ret
/* loadJoystick end */




/**
 * Reads the X / Y values from the joystick and based on the global threshold
 * decides which direction it's pointed.
 * @return rReturnL - Returns the joystick X direction (-1 is left, 0 is neutral, 1 is right)
 * @return rReturnH - Returns the joystick Y direction (-1 is up, 0 is neutral, 1 is down)
 */
 readJoystickDirection:
		/* The joystick X axis 8 bit value */
		.DEF	rJoystickX	= r6

		/* The joystick Y axis 8 bit value */
		.DEF	rJoystickY	= r7

		/* Joystick input registries */
		.DEF	rJoystickL	= r18
		.DEF	rJoystickH	= r19

	push	rJoystickX
	push	rJoystickY

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

	// Read Y axis
	ldi		rArgument0L, 0
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

		/* rDirection */
		.DEF rDirectionX		= r18
		.DEF rDirectionY		= r19

	mov		rArgument0L, rJoystickX
	mov		rArgument1L, rJoystickY
	call	joystickValuesToDirection

	pop		rJoystickY
	pop		rJoystickX

		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
		.UNDEF	rJoystickY
		.UNDEF	rJoystickX

	ret
/* joystickValueTo8Bit end */


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
 * @return rReturnL - Returns the joystick X direction (-1 is left, 0 is neutral, 1 is right)
 * @return rReturnH - Returns the joystick Y direction (-1 is up, 0 is neutral, 1 is down)
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

	ldi		rDirectionY, 0
	ldi		rDirectionX, 0

compareUp:
	cpi		rJoystickY, 128 + JOYSTICK_THRESHOLD - 1
	brlo	compareUpEnd
	ldi		rDirectionY, -1
compareUpEnd:
	
compareDown:
	cpi		rJoystickY, 128 - JOYSTICK_THRESHOLD - 1
	brsh	compareDownEnd
	ldi		rDirectionY, 1
compareDownEnd:

compareLeft:
	cpi		rJoystickX, 128 + JOYSTICK_THRESHOLD - 1
	brlo	compareLeftEnd
	ldi		rDirectionX, -1
compareLeftEnd:

compareRight:
	cpi		rJoystickX, 128 - JOYSTICK_THRESHOLD - 1
	brsh	compareRightEnd
	ldi		rDirectionX, 1
compareRightEnd:
	
	cpi		rDirectionX, 0
	breq	notCorner
	cpi		rDirectionY, 0
	breq	notCorner
	ldi		rDirectionX, 0
	ldi		rDirectionY, 0
notCorner:

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
 initializeHardwareTimer2:
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

	sei																	// start global interupts
		.UNDEF rPrescaling
		.UNDEF rControlBits

/* initializeTimer2 end */

/**
 * Draws a pixel in the matrix at the sepcified location
 * @param rArgument0L The row (Y) of the pixel
 * @param rArgument1L The column (X) of the pixel
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
	ldi		rRowMask, 0b10000000
setPixelColumnShiftLoop:
	cpi		rColumn, 0
	breq	setPixelColumnShiftEnd
	subi	rColumn, 1
	lsr		rRowMask
	jmp		setPixelColumnShiftLoop
setPixelColumnShiftEnd:

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
		.UNDEF	rZero

	ret
/* setPixel end */



/**
 * Clears a pixel in the matrix at the sepcified location
 * @param rArgument0L The row (Y) of the pixel
 * @param rArgument1L The column (X) of the pixel
 */
clearPixel:
		.DEF	rRow		= r18
		.DEF	rColumn		= r19
		.DEF	rRowMask	= r20
		.DEF	rLocalTemp	= r21

	// Load the matrix adress into 16 bit register Y (LOW + HIGH)
	mov		rRow, rArgument0L
	mov		rColumn, rArgument1L

	// convert value to mask
	ldi		rRowMask, 0b10000000
clearPixelcolumnShiftLoop:
	cpi		rColumn, 0
	breq	clearPixelcolumnShiftEnd
	subi	rColumn, 1
	lsr		rRowMask
	jmp		clearPixelcolumnShiftLoop
clearPixelcolumnShiftEnd:
	
	// Invert row mask in order to clear
	ldi		rLocalTemp, 0xff
	eor		rRowMask, rLocalTemp

	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)
	ldi		rLocalTemp, 0
	add		YL,	rRow
	adc		YH, rLocalTemp
	ld		rRow, Y
	and		rRow, rRowMask
	st		Y, rRow

		.UNDEF	rRow
		.UNDEF	rColumn
		.UNDEF	rRowMask

	ret
/* setPixel end */




/**
 * Set the bits in the matrix with a smiley
 */
drawSmileyMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Initialize the matrix with a smiley set
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b00100100
	st		Y+, rRowBits
	ldi		rRowBits, 0b00100100
	st		Y+, rRowBits
	ldi		rRowBits, 0b00011000
	st		Y+, rRowBits
	ldi		rRowBits, 0b01000010
	st		Y+, rRowBits
	ldi		rRowBits, 0b01000010
	st		Y+, rRowBits
	ldi		rRowBits, 0b00111100
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* smileyMatrix end */	



/**
 * Set the bits in the matrix with a templarMatrix
 */
drawTemplarMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Initialize the matrix with a templar cross symbol
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rRowBits, 0b11011111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11011111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11011111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11011111
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b11011111
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b11011111
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* smileyMatrix end */	

/**
 * Set the bits in the matrix with a skull
 */
drawSkullMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowMask	= r18

	// Initialize the matrix with a skull
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
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

	ret
/* smileyMatrix end */	
	

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

		/* Temp registers */
		.DEF	rTemp = r2
		.DEF	rTempI = r16

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

		.UNDEF	rTemp
		.UNDEF	rTempI

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
	call drawSkullMatrix
terminateLoop:
	call	render
	jmp		terminateLoop
/* terminate end */
