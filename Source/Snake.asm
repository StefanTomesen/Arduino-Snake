/**
 *	Snake
 *
 *	Skola assemble setting
 *	avrdude -C "C:\WinAVR-20100110\bin\avrdude.conf" -patmega328p -Pcom4 -carduino -b115200 -Uflash:w:Snake.hex 
 *
 *	Thism2 assemble setting
 *	avrdude -C "E:\Other\WinAVR-20100110\bin\avrdude.conf" -p atmega328p -P com3 -c arduino -b 115200 -U flash:w:Snake.hex 
 *
 *	Dayanto asseble setting
 *  "C:\WinAVR-20100110\bin\avrdude.exe" -C "C:\WinAVR-20100110\bin\avrdude.conf" -patmega328p -Pcom4 -carduino -b115200 -Uflash:w:Snake.hex 
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
	.EQU	RESETaddr					= 0x0000

	/* Joystick */
	.EQU	JOYSTICK_X_AXIS				= 1
	.EQU	JOYSTICK_Y_AXIS				= 0
	.EQU	JOYSTICK_THRESHOLD			= 128 - 64
	.EQU	JOYSTICK_DIAGONAL_THRESHOLD	= JOYSTICK_THRESHOLD / 2

	/* Ledjoy */
	.EQU	NUM_COLUMNS					= 8
	.EQU	NUM_ROWS					= 8
	
	/* Timer2 */
	.EQU	TIMER2_PRE_1024				= ((1 << CS22) | (1 << CS21) | (1 << CS20))
	// A timer value of 4096 roughly represents 67 seconds with 1024 prescaling (tested)



	/**
	 * Struct definitions. Each struct consists of a number of constants, one of which 
	 * being the size of instances of the struct. Data is accessed by using a label as
	 * a pointer to the instance and applying an offset defined in the data structure
	 * section to access individual variables
	 */

	/* Timer */
	// Constants
	.EQU	TIMER_DATA_SIZE				= 4
	// Data structure
	.EQU	oTimerCurrentTimeL			= 0x00
	.EQU	oTimerCurrentTimeH			= 0x01
	.EQU	oTimerTargetTimeL			= 0x02
	.EQU	oTimerTargetTimeH			= 0x03

	/* Snake */
	// Constants
	.EQU	SNAKE_MAX_LENGTH			= 64
	.EQU	SNAKE_DATA_SIZE				= 5
	// Data structure
	.EQU	oSnakeDirectionX			= 0x00
	.EQU	oSnakeDirectionY			= 0x01
	.EQU	oSnakeNextDirectionX		= 0x02
	.EQU	oSnakeNextDirectionY		= 0x03
	.EQU	oSnakeLength				= 0x04

	/* FlashFood */
	// Constants
	.EQU	FLASH_FOOD_DATA_SIZE		= 3
	// Data structure
	.EQU	oFlashFoodPositionX			= 0x00
	.EQU	oFlashFoodPositionY			= 0x01
	.EQU	oIsLitUp					= 0x02


	/**
	 * Program constant definitions
	 */


	/* Snake Game */
	.EQU	SNAKE_UPDATE_TIME			= 16
	.EQU	SNAKE_FOOD_UPDATE_TIME		= 13
	.EQU	SNAKE_DIE_UPDATE_TIME		= SNAKE_UPDATE_TIME / 2
	.EQU	SNAKE_BOARD_FLASH_TIME		= 32
	.EQU	SNAKE_BOARD_BLINKS			= 5


	/**							
	 * Data Segment
	 */
	.DSEG

// Ledjoy matrix
matrix:				.BYTE	NUM_ROWS					// LED matrix - 1 bit per "pixel" = one byte per row

// Timer instances
renderTimer:		.BYTE	TIMER_DATA_SIZE
updateTimer:		.BYTE	TIMER_DATA_SIZE
flashTimer:			.BYTE	TIMER_DATA_SIZE
boardFlashTimer:	.BYTE	TIMER_DATA_SIZE

// Snake data
snake:				.BYTE	SNAKE_DATA_SIZE
snakeArrayX:		.BYTE	SNAKE_MAX_LENGTH
snakeArrayY:		.BYTE	SNAKE_MAX_LENGTH
flashFood:			.BYTE	FLASH_FOOD_DATA_SIZE


	/**							
	 * Code segment
	 */
	.CSEG


	/**
	 * Interupt declarations
	 */

	// Initialization / reset interupt
	.ORG	RESETaddr
		jmp		init			// Reset vector
		nop

	// timer0 overflow interupt
	.ORG	OVF0addr 
		jmp		timer0OverflowInterupt		// Timer 0 overflow vector
		nop

	// timer2 overflow interupt
	.ORG	OVF2addr 
		jmp		timer2OverflowInterupt		// Timer 2 overflow vector
		nop

	// rest code
	.ORG	INT_VECTORS_SIZE


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

	/**
	 * Add constant to a 16 bit composite virtual register outside of X, Y and Z
	 * @param @0 - Low register
	 * @param @1 - High register
	 * @param @2 - 16 bit constant
	 */
	.MACRO addiw 
		subi	@0, LOW(-@2)
		sbci	@1, HIGH(-@2)
	.ENDMACRO


	/**
	 * Subtract constant from a 16 bit composite virtual register outside of X, Y and Z
	 * @param @0 - Low register
	 * @param @1 - High register
	 * @param @2 - 16 bit constant
	 */
	.MACRO subiw
		subi	@0, LOW(@2)
		sbci	@1, HIGH(@2)
	.ENDMACRO



	/**
	 * Replicate the normal add with immediate behaviour instead of having to use reverse subtraction.
	 * @param @0 - Register to add to
	 * @param @1 - 8 bit constant
	 */
	.MACRO	addi
		subi	@0, -@1
	.ENDMACRO

	/**
	 * Loads a constant to any register, regardless if they normally can't load constants
	 * @param @0 - the register the constant is loaded to
	 * @param @1 - the constant that is being loaded
	 */
	.MACRO loadConstant
			.DEF	rTemp = r18
		push	rTemp
		ldi		rTemp, @1
		mov		@0, rTemp
		pop		rTemp
			.UNDEF	rTemp
	.ENDMACRO
	
	/**
	 * Sets a pixel based on register input
	 * @param @0 - X value of the pixel to be set
	 * @param @1 - Y value of the pixel to be set
	 */
	.MACRO	setPixelr			// SetPixel subroutine call from register
		mov		rArgument0L, @0
		mov		rArgument1L, @1
		call	setPixel
	.ENDMACRO

	/**
	 * Clears a pixel based on register input
	 * @param @0 - X value of the pixel to be cleared
	 * @param @1 - Y value of the pixel to be cleared
	 */
	.MACRO	clearPixelr			// clearPixel subroutine call from register
		mov		rArgument0L, @0
		mov		rArgument1L, @1
		call	clearPixel
	.ENDMACRO

	/**
	 * Sets a pixel based on a constant value
	 * @param @0 - X value of the pixel to be set
	 * @param @1 - Y value of the pixel to be set
	 */
	.MACRO	setPixeli			// SetPixel subroutine call from constant
		ldi		rArgument0L, @0
		ldi		rArgument1L, @1
		call	setPixel
	.ENDMACRO

	/**
	 * Clears a pixel based on a constant value
	 * @param @0 - X value of the pixel to be cleared
	 * @param @1 - Y value of the pixel to be cleared
	 */
	.MACRO	clearPixeli			// clearPixel subroutine call from constant
		ldi		rArgument0L, @0
		ldi		rArgument1L, @1
		call	clearPixel
	.ENDMACRO
	
	/**
	 * Increment a timer data structure. 
	 * @param @0 - The label to a timer
	 */
	.MACRO incrementTimeri
		ldi		rArgument0L, LOW(@0)
		ldi		rArgument0H, HIGH(@0)
		call	incrementTimer
	.ENDMACRO

	/**
	 * Set the callback for a timer data structure. 
	 * @param @0 - The label to the timer
	 * @param @1 - Target time constant 
	 */
	.MACRO initializeTimeri
		ldi		rArgument0L, LOW(@0)
		ldi		rArgument0H, HIGH(@0)
		ldi		rArgument1L, LOW(@1)
		ldi		rArgument1H, HIGH(@1)
		call	initializeTimer
	.ENDMACRO

	/**
	 * Checks whether a timer has reached its target value and resets the timer if it has
	 * @param @0 - the timer label
	 * @rReturnL - boolean whether or not the timer has reached its target
	 */
	.MACRO checkTimeri
		ldi		rArgument0L, LOW(@0)
		ldi		rArgument0H, HIGH(@0)
		call	checkTimer
	.ENDMACRO
	
	/**
	 * Determines whether two positions intersect
	 * @param @0 - The X coordinate of the first position
	 * @param @1 - The Y coordinate of the first position
	 * @param @2 - The X coordinate of the second position
	 * @param @3 - The Y coordinate of the second position
	 * @return rReturnL - Whether or not the points intersect (boolean)
	 */
	.MACRO	checkCollisionr
		mov		rArgument0L, @0			// X
		mov		rArgument0H, @1			// Y
		mov		rArgument1L, @2			// X2
		mov		rArgument1H, @3			// Y2
		call	checkCollision
	.ENDMACRO
	
	/**
	 * Determines whether two positions intersect
	 * @param @0 - The X coordinate of the first position
	 * @param @1 - The Y coordinate of the first position
	 * @param @2 - The X coordinate of the second position
	 * @param @3 - The Y coordinate of the second position
	 * @return rReturnL - Whether or not the points intersect (boolean)
	 */	
	.MACRO	checkCollisioni
		ldi		rArgument0L, @0			// X
		ldi		rArgument0H, @1			// Y
		ldi		rArgument1L, @2			// X2
		ldi		rArgument1H, @3			// Y2
		call	checkCollision
	.ENDMACRO

	/**
	 * Terminates the program with a custom image in order to identify different types of errors. 
	 * @param @0 - The label to the subroutine drawing the error image
	 */	
	.MACRO	terminateErrori
		ldi		rArgument0L, LOW(@0)
		ldi		rArgument0H, HIGH(@0)
		call	terminateError
	.ENDMACRO

	/**
	 * Quick macro to terminate with a fatal error. This displays a skull on the screen.
	 */
	.MACRO	crash
		terminateErrori	drawSkullMatrix
	.ENDMACRO



/**
 * Handle overflow interupts from timer 0
 */
timer0OverflowInterupt:

	reti
/* timer0OverflowInterupt end */



/**
 * Handle overflow interupts from timer 2
 */
timer2OverflowInterupt:
	
		.DEF	rStatus		= r18

	// Save the status
	push	rStatus						// push register r18
	in		rStatus, SREG				
	push	rStatus						// push status register
		
		.UNDEF	rStatus
		
		
		/* The timercounter value  */
		.DEF	rTimerValueL	= r18
		.DEF	rTimerValueH	= r19

	push	rTimerValueL
	push	rTimerValueH
	push	YL
	push	YH
	push	rArgument0L
	push	rArgument0H
	
	incrementTimeri renderTimer
	incrementTimeri updateTimer
	incrementTimeri flashTimer
	incrementTimeri boardFlashTimer

	pop		rArgument0H
	pop		rArgument0L
	pop		YH
	pop		YL
	pop		rTimerValueH
	pop		rTimerValueL
		
		.UNDEF	rTimerValueL
		.UNDEF	rTimerValueH
	
		.DEF	rStatus		= r18

	// Restore status
	pop		rStatus						
	out		SREG, rStatus				// Restore the status register
	pop		rStatus						// Restore register r18
		
		.UNDEF	rStatus

	reti
/* timer2OverflowInterupt end */



/******************************************************************************************
 * Program: Snake																		  *
 * Start runing the snake game															  *
 *****************************************************************************************/
snakeGame:
	// Timer initializiton
	ldi		rArgument0L, TIMER2_PRE_1024
	call	initializeHardwareTimer2

	call	snakeStartAnimation

	initializeTimeri updateTimer, SNAKE_UPDATE_TIME
	initializeTimeri flashTimer, SNAKE_FOOD_UPDATE_TIME
	
	call	initializeSnake

	call	initializeFlashFood
	call	randomizeFlashFood

	call	clearMatrix
	call	drawSnake

snake_GameLoop:

		/* The directions the joystick is pointed */
		.DEF	rDirectionX			= r16
		.DEF	rDirectionY			= r17
		.DEF	rPreviousDirectionX	= r18
		.DEF	rPreviousDirectionY	= r19

	call	readJoystickDirection5
	mov		rDirectionX, rReturnL
	mov		rDirectionY, rReturnH

	// If the current direction is neutral, don't change the direction
	cpi		rDirectionX, 0
	brne	snake_ChangeDirection
	cpi		rDirectionY, 0
	brne	snake_ChangeDirection
	jmp		snake_SkipChangeDirection 

snake_ChangeDirection:
	// Load the previous snake direction
	ldi		YH, HIGH(snake)	// Set Y to matrix address
	ldi		YL, LOW(snake)
	ldd		rPreviousDirectionX, Y + oSnakeDirectionX
	ldd		rPreviousDirectionY, Y + oSnakeDirectionY

	// If the current direction is opposite to the previous, skip chanign the direction, in order to prevent colliding with yourself
	neg		rPreviousDirectionX
	neg		rPreviousDirectionY
	cp		rDirectionX, rPreviousDirectionX
	brne	snake_ChangeDirection2
	cp		rDirectionY, rPreviousDirectionY
	brne	snake_ChangeDirection2
	jmp		snake_SkipChangeDirection 

snake_ChangeDirection2:
	// store snake direction
	ldi		YH, HIGH(snake)	// Set Y to matrix address
	ldi		YL, LOW(snake)
	std		Y + oSnakeNextDirectionX, rDirectionX
	std		Y + oSnakeNextDirectionY, rDirectionY

		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
		.UNDEF rPreviousDirectionX
		.UNDEF rPreviousDirectionY

snake_SkipChangeDirection:

	checkTimeri updateTimer	// returns boolean whether the timer has reached it's target time and reset	
	cpi		rReturnL, 1
	breq	snake_Update

	// check if it should make the food flash 
	checkTimeri flashTimer	// returns boolean whether the timer has reached it's target time and reset	
	cpi		rReturnL, 0
	breq	snake_UpdateFlashFoodEnd

		.DEF	rIsLit = r18

	// load flashFood
	ldi		YH, HIGH(flashFood)
	ldi		YL, LOW(flashFood)
	ldd		rIsLit, Y + oIsLitUp
	com		rIsLit							
	std		Y + oIsLitUp, rIsLit

		.UNDEF	rIsLit

snake_UpdateFlashFoodEnd:	

		.DEF	rFlashFoodX	= r2
		.DEF	rFlashFoodY	= r3
		.DEF	rIsLit		= r16

	// load flashFood
	ldi		YH, HIGH(flashFood)	
	ldi		YL, LOW(flashFood)
	ldd		rFlashFoodX, Y + oFlashFoodPositionX
	ldd		rFlashFoodY, Y + oFlashFoodPositionY
	ldd		rIsLit, Y + oIsLitUp


	clearPixelr	rFlashFoodX, rFlashFoodY
	cpi		rIsLit, 0
	breq	snake_SkipDrawFood
	setPixelr	rFlashFoodX, rFlashFoodY

		.UNDEF	rFlashFoodX
		.UNDEF	rFlashFoodY
		.UNDEF	rIsLit

snake_SkipDrawFood:


snake_GameLoopEnd:

	call	render
	jmp		snake_GameLoop

snake_Update:

		.DEF	rSnakeDirectionX	= r18
		.DEF	rSnakeDirectionY	= r19

	// Load the previous snake direction
	ldi		YH, HIGH(snake)	// Set Y to matrix address
	ldi		YL, LOW(snake)

	ldd		rSnakeDirectionX, Y + oSnakeNextDirectionX
	ldd		rSnakeDirectionY, Y + oSnakeNextDirectionY
	std		Y + oSnakeDirectionX, rSnakeDirectionX
	std		Y + oSnakeDirectionY, rSnakeDirectionY
			
		.UNDEF	rSnakeDirectionX
		.UNDEF	rSnakeDirectionY

	call	checkFoodCollision
	cpi		rReturnL, 1
	breq	snake_EatFood

	call	clearSnakeTail
	jmp		snake_MoveSnake

snake_EatFood:
		.DEF	rTemp = r4
	
	// Increment the snake length
	ldi		YH, HIGH(snake)
	ldi		YL, LOW(snake)
	ldd		rTemp, Y + oSnakeLength
	inc		rTemp
	std		Y + oSnakeLength, rTemp
		
		.UNDEF rTemp

		.DEF	rFlashFoodX	= r4
		.DEF	rFlashFoodY	= r5

	// Load the food position
	ldi		YH, HIGH(flashFood)						// Load pointer to the food instance
	ldi		YL, LOW(flashFood)
	ldd		rFlashFoodX, Y + oFlashFoodPositionX	// Load food X position
	ldd		rFlashFoodY, Y + oFlashFoodPositionY	// Load food Y position

	// Draw the food in case it clear a piece of the snake	
	setPixelr	rFlashFoodX, rFlashFoodY

		.UNDEF	rFlashFoodX
		.UNDEF	rFlashFoodY

	// Generate a new piece of food
	call	randomizeFlashFood

snake_MoveSnake:

	call	pushNewSnakeHead
	call	drawSnakeHead

	// Check whether the snake has collided with itself
	call	checkSelfCollision
	cpi		rReturnL, 1
	breq	snake_GameOver
	jmp		snake_GameLoopEnd

snake_GameOver:
	call	snakeGameEndAnimation
	jmp		snakeGame

	ret
/* snakeGame end */



/**
 * Draw a blinking snake head at the start of the game
 */
snakeStartAnimation:
		/** The counter that keeps track of how many blinks we have left */
		.DEF	rRemainingBlinks = r16
		.DEF	rTemp			 = r18
	push	rRemainingBlinks

	initializeTimeri boardFlashTimer, SNAKE_BOARD_FLASH_TIME

	call	drawSnakeHeadMatrix
	ldi		rRemainingBlinks, SNAKE_BOARD_BLINKS

snakeStartRender:
	call	render

	// Wait for an update and then blink
	checkTimeri boardFlashTimer			// returns boolean whether the timer has reached it's target time and reset	
	cpi		rReturnL, 1
	breq	snakeStartBlink			// If an update was recieved, blink
	jmp		snakeStartRender		// If an update didn't occur, render and wait some more

	// Blink, decrement the remaining blinks and wait for the next blink
snakeStartBlink:
	mov		rTemp, rRemainingBlinks	
	andi	rTemp, 0x01								// Mask out whether the remaining blinks are an odd or even number
	cpi		rTemp, (SNAKE_BOARD_BLINKS & 0x01)
	brne	snakeStartDrawSnake

	call	clearMatrix
	jmp		snakeStartBlinkEnd

snakeStartDrawSnake:
	call	drawSnakeHeadMatrix

snakeStartBlinkEnd:
	dec		rRemainingBlinks
	cpi		rRemainingBlinks, 0
	brne	snakeStartRender

	pop		rRemainingBlinks
		.UNDEF	rRemainingBlinks 
		.UNDEF	rTemp

	ret
/* snakeStartAnimation end */


/**
 * Draw the animation for when the snake dies at the end of the game.
 */
snakeGameEndAnimation:

	initializeTimeri updateTimer, SNAKE_DIE_UPDATE_TIME

snakeEndRender:
	call	render

	// Wait for an update and then shorten the snake length
	checkTimeri updateTimer			// Returns boolean whether the timer has reached it's target time and reset	
	cpi		rReturnL, 1
	breq	snakeEndUpdate			// If an update was recieved, blink
	jmp		snakeEndRender			// If an update didn't occur, render and wait some more

snakeEndUpdate:

	// Clear tail and redraw the head if it got cleared
	call	clearSnakeTail
	call	drawSnakeHead

		.DEF	rSnakeLength			 = r18

	// Decrease the length of the snake
	ldi		YL, LOW(snake)						// Get a pointer to the snake
	ldi		YH, HIGH(snake)
	ldd		rSnakeLength, Y + oSnakeLength			// Get a pointer to the snake nlegth
	dec		rSnakeLength							// Subtract one to set the iterator to last index (length - 1)
	std		Y + oSnakeLength, rSnakeLength
	cpi		rSnakeLength, 0
	brne	snakeEndRender

		.UNDEF	rSnakeLength

	ret
/* snakeGameEndAnimation end */	



/**
 * Checks whether the head of the snake intersects with any part of the body
 * @return rReturnL - returns wheather is collided with itself
 */
checkSelfCollision:
		.DEF	rSnakeHeadX		= r2
		.DEF	rSnakeHeadY		= r3
		.DEF	rSnakePartX		= r18
		.DEF	rSnakePartY		= r19
		.DEF	rIterator		= r4
		.DEF	rZero			= r20

	push	rSnakeHeadX
	push	rSnakeHeadY
	push	rIterator

	// Initiate iterator at the last index
	ldi		YL, LOW(snake)						// Get a pointer to the snake
	ldi		YH, HIGH(snake)
	ldd		rIterator, Y + oSnakeLength			// Get a pointer to the snake nlegth
	dec		rIterator							// Subtract one to set the iterator to last index (length - 1)

	// Load snake head position	
	ldi		ZL, LOW(snakeArrayX)				// Get a pointer to the snake X array
	ldi		ZH, HIGH(snakeArrayX)
	ldi		YL, LOW(snakeArrayY)				// Get a pointer to the snake Y array
	ldi		YH, HIGH(snakeArrayY)
	ld		rSnakeHeadX, Z						// Load the head positions
	ld		rSnakeHeadY, Y
	
	// Offset the array index to the tail index - 1
	ldi		rZero, 0				
	add		ZL, rIterator
	adc		ZH, rZero
	add		YL, rIterator
	adc		YH, rZero

	// Compare every part of the snake with the head
checkSnakeBodyCollisonLoop:
	ld		rSnakePartX, Z
	ld		rSnakePartY, Y

	// Do the comparison between the two
	checkCollisionr rSnakeHeadX, rSnakeHeadY, rSnakePartX, rSnakePartY
	
	// If a collision was detected, return true
	cpi		rReturnL, 1
	breq	checkSelfCollisionReturn

	sbiw	Z, 1
	sbiw	Y, 1
	dec		rIterator
	ldi		rZero, 0
	cp		rIterator, rZero
	brne	checkSnakeBodyCollisonLoop
	
	// Return false if no collision was detected
	ldi		rReturnL, 0	

checkSelfCollisionReturn:

	pop		rIterator
	pop		rSnakeHeadY
	pop		rSnakeHeadX
	
		.UNDEF	rZero
		.UNDEF	rIterator
		.UNDEF	rSnakeHeadX
		.UNDEF	rSnakeHeadY	
		.UNDEF	rSnakePartX
		.UNDEF	rSnakePartY

	ret
/* checkSelfCollision end */	



/**
 * Determines whether the head of the snake has collided with the piece of food.
 * @return rReturnL - returns whether is collided with the food or not (boolean)
 */
checkFoodCollision:
		.DEF	rSnakeHeadX		= r18
		.DEF	rSnakeHeadY		= r19
		.DEF	rFlashFoodX		= r20
		.DEF	rFlashFoodY		= r21

	// Load snake head position	
	ldi		XL, LOW(snakeArrayX)					// Get a pointer to the snake X array
	ldi		XH, HIGH(snakeArrayX)
	ldi		YL, LOW(snakeArrayY)					// Get a pointer to the snake Y array
	ldi		YH, HIGH(snakeArrayY)
	ld		rSnakeHeadX, X							// Load the positions
	ld		rSnakeHeadY, Y

	// Load food position
	ldi		YL, LOW(flashFood)						// Load food position pointer
	ldi		YH, HIGH(flashFood)
	ldd		rFlashFoodX, Y + oFlashFoodPositionX	// Load the position
	ldd		rFlashFoodY, Y + oFlashFoodPositionY
	
	// Do the comparison between the two
	// Returns the result to rReturnL, which is simply forwarded
	checkCollisionr		rFlashFoodX, rFlashFoodY, rSnakeHeadX, rSnakeHeadY	

		.UNDEF	rSnakeHeadX
		.UNDEF	rSnakeHeadY	
		.UNDEF	rFlashFoodX
		.UNDEF	rFlashFoodY

	ret
/* checkFoodCollision end */



/**
 * Initialize the snake at position (1,2) pointing down
 */
initializeSnake:
		.DEF	rDirectionX		= r18
		.DEF	rDirectionY		= r19
		.DEF	rSnakeLength	= r20

	// Get a pointer to the snake struct
	ldi		YH, HIGH(snake)
	ldi		YL, LOW(snake)

	// Set the current and next directions to down
	ldi		rDirectionX, 0
	ldi		rDirectionY, 1
	std		Y + oSnakeDirectionX, rDirectionX
	std		Y + oSnakeDirectionY, rDirectionY
	std		Y + oSnakeNextDirectionX, rDirectionX
	std		Y + oSnakeNextDirectionY, rDirectionY

	// Set length to 1
	ldi		rSnakeLength, 2
	std		Y + oSnakeLength, rSnakeLength

		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
		.UNDEF	rSnakeLength

		.DEF	rPositionX		= r18
		.DEF	rPositionY		= r19

	// Load snake position pointers
	ldi		ZH, HIGH(snakeArrayX)
	ldi		ZL, LOW(snakeArrayX)
	ldi		YH, HIGH(snakeArrayY)
	ldi		YL, LOW(snakeArrayY)

	// Set head position
	ldi		rPositionX, 1
	ldi		rPositionY, 5
	std		Z + 0, rPositionX
	std		Y + 0, rPositionY

	// Set tail position
	ldi		rPositionX, 1
	ldi		rPositionY, 6
	std		Z + 1, rPositionX
	std		Y + 1, rPositionY

		.UNDEF	rPositionX
		.UNDEF	rPositionY

	ret
/* initializeSnake end */	



/**
 * Draws the snake on the screen
 */ 
drawSnake:

		.DEF	rPositionX		= r18
		.DEF	rPositionY		= r19
		.DEF	rIterator		= r20
		.DEF	rSnakeLength	= r21
	
	
	// Load length from snake
	ldi		YH, HIGH(snake)			// Load a pointer to the snake struct
	ldi		YL, LOW(snake)
	ldd		rSnakeLength, Y + oSnakeLength

	// Set the iterator to 0
	ldi		rIterator, 0

	// Load snake position array pointers at head index
	ldi		ZH, HIGH(snakeArrayX)
	ldi		ZL, LOW(snakeArrayX)
	ldi		YH, HIGH(snakeArrayY)
	ldi		YL, LOW(snakeArrayY)	

drawSnakeLoop:
	ldd		rPositionX, Z + 0
	ldd		rPositionY, Y + 0
	
	// Oh the horror of push and pop
	push	rPositionX
	push	rPositionY
	push	rIterator
	push	rSnakeLength
	push	YL
	push	ZL
	push	YH
	push	ZH
	setPixelr rPositionX, rPositionY
	pop		ZH
	pop		YH
	pop		ZL
	pop		YL
	pop		rSnakeLength
	pop		rIterator
	pop		rPositionY
	pop		rPositionX

	adiw	Z, 1
	adiw	Y, 1
	inc		rIterator
	cp		rIterator, rSnakeLength
	brne	drawSnakeLoop

		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rIterator
		.UNDEF	rSnakeLength
	ret
/* drawSnake end */



/**
 * Push the snake backwards in the array and add a new head at the front.
 */
pushNewSnakeHead:
		.DEF	rPositionX			= r18
		.DEF	rPositionY			= r19
		.DEF	rIterator			= r20
		.DEF	rZero				= r21

	// Load the iterator based on snake length
	ldi		YH, HIGH(snake)					// Set pointer to snake struct	
	ldi		YL, LOW(snake)
	ldd		rIterator, Y + oSnakeLength		// Load snake length
	subi	rIterator, 2					// Subtract 2 to reach the first index to be moved forward

	// If the snake is less than 2 pixels don't 
	cpi		rIterator, 0
	brlt	insertHead

	// Load snake position array pointers at head index
	ldi		ZH, HIGH(snakeArrayX)
	ldi		ZL, LOW(snakeArrayX)
	ldi		YH, HIGH(snakeArrayY)
	ldi		YL, LOW(snakeArrayY)	
	// Offset the array index to the tail index - 1
	ldi		rZero, 0				
	add		ZL, rIterator
	adc		ZH, rZero
	add		YL, rIterator
	adc		YH, rZero

pushSnakeLoop:
	ldd		rPositionX, Z + 0
	ldd		rPositionY, Y + 0
	std		Z + 1, rPositionX
	std		Y + 1, rPositionY

	sbiw	Z, 1
	sbiw	Y, 1
	dec		rIterator
	cpi		rIterator, -1
	brne	pushSnakeLoop

		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rIterator
		.UNDEF	rZero
insertHead:

		.DEF	rSnakeHeadX			= r18
		.DEF	rSnakeHeadY			= r19
		.DEF	rSnakeDirectionX	= r20
		.DEF	rSnakeDirectionY	= r21
	
	// Set pointer to snake struct	
	ldi		YH, HIGH(snake)
	ldi		YL, LOW(snake)

	// Load the previous snake direction
	ldd		rSnakeDirectionX, Y + oSnakeDirectionX
	ldd		rSnakeDirectionY, Y + oSnakeDirectionY

	// Load the current snake head position
	ldi		ZH, HIGH(snakeArrayX)		// Set Y to snakeX address
	ldi		ZL, LOW(snakeArrayX)
	ldi		YH, HIGH(snakeArrayY)		// Set Y to snakeY address
	ldi		YL, LOW(snakeArrayY)
	ldd		rSnakeHeadX, Z + 0			// X at index n = 0
	ldd		rSnakeHeadY, Y + 0			// y at index n = 0

	// Add the direction offset to the snake head position to get the next head
	add		rSnakeHeadX, rSnakeDirectionX
	add		rSnakeHeadY, rSnakeDirectionY

	// Wrap the position around the grid
	andi	rSnakeHeadX, 0b0000111
	andi	rSnakeHeadY, 0b0000111

	// Store the head position
	std		Z + 0, rSnakeHeadX
	std		Y + 0, rSnakeHeadY		
			
		.UNDEF	rSnakeDirectionX
		.UNDEF	rSnakeDirectionY
		.UNDEF	rSnakeHeadX
		.UNDEF	rSnakeHeadY

	ret
/* pushNewSnakeHead end */



/**
 * Draw a pixel at the head position of the snake
 */
 drawSnakeHead:
		.DEF	rSnakeHeadX		= r18
		.DEF	rSnakeHeadY		= r19

	// Load the snake head position
	ldi		ZH, HIGH(snakeArrayX)		// Set Z to snakeX address
	ldi		ZL, LOW(snakeArrayX)
	ldi		YH, HIGH(snakeArrayY)		// Set Y to snakeY address
	ldi		YL, LOW(snakeArrayY)
	ldd		rSnakeHeadX, Z + 0			// X at index n = 0
	ldd		rSnakeHeadY, Y + 0			// y at index n = 0
	
	// Draw the new head
	setPixelr	rSnakeHeadX, rSnakeHeadY
			
		.UNDEF	rSnakeHeadX
		.UNDEF	rSnakeHeadY
	ret
/* drawSnakeHead end */



/**
 * Clear a pixel at the current tail position of the snake
 */
clearSnakeTail:
		.DEF	rSnakeTailX		= r18
		.DEF	rSnakeTailY		= r19
		.DEF	rTailOffset		= r20
		.DEF	rZero				= r21

	// Load the tail offset
	ldi		YH, HIGH(snake)					// Set pointer to snake struct	
	ldi		YL, LOW(snake)
	ldd		rTailOffset, Y + oSnakeLength
	subi	rTailOffset, 1

	// Load snake position array pointers at head index
	ldi		XH, HIGH(snakeArrayX)		// Load pointer to snake X position array
	ldi		XL, LOW(snakeArrayX)
	ldi		YH, HIGH(snakeArrayY)		// Load pointer to snake Y position array
	ldi		YL, LOW(snakeArrayY)

	// Offset the array index to the tail's index
	ldi		rZero, 0				
	add		XL, rTailOffset
	adc		XH, rZero
	add		YL, rTailOffset
	adc		YH, rZero

	// Load the tail position
	ld		rSnakeTailX, X 				// X at index n = 0
	ld		rSnakeTailY, Y				// y at index n = 0
	
	// Clear the tail pixel
	clearPixelr	rSnakeTailX, rSnakeTailY
			
		.UNDEF	rSnakeTailX
		.UNDEF	rSnakeTailY
		.UNDEF	rTailOffset
		.UNDEF	rZero	

	ret
/* clearSnakeTail end */



/**
 * Reads the jostick for noise and randomizes a position for the food to spawn
 */
randomizeFlashFood:

		.DEF	rFlashFoodX	= r18
		.DEF	rFlashFoodY	= r19
		.DEF	rIsLit		= r20

	// Generate a random value for the X axis based on the input noise of the X axis
	ldi		rArgument0L, JOYSTICK_X_AXIS
	call	generateRandom3BitValue
	mov		rFlashFoodX, rReturnL

	// Generate a random value for the Y axis based on the input noise of the Y axis
	push	rFlashFoodX								// Protect the X position from being overwritten in the subroutine
	ldi		rArgument0L, JOYSTICK_Y_AXIS
	call	generateRandom3BitValue
	pop		rFlashFoodX
	mov		rFlashFoodY, rReturnL
	
	// Set the new food as unlit
	ldi		rIsLit, 0								

	// Load food position
	ldi		YH, HIGH(flashFood)						// Load pointer to the food instance
	ldi		YL, LOW(flashFood)
	std		Y + oFlashFoodPositionX, rFlashFoodX
	std		Y + oFlashFoodPositionY, rFlashFoodY
	std		Y + oIsLitUp, rIsLit

		.UNDEF	rFlashFoodX
		.UNDEF	rFlashFoodY
		.UNDEF	rIsLit

	ret
/* randomizeFlashFood end */



/**
 * Initializes the variables for the food. This places the food at the top left corner, so 
 * a new position has to be generated before the game starts.
 */
initializeFlashFood:
		.DEF	rFlashFoodX	= r18
		.DEF	rFlashFoodY	= r19
		.DEF	rIsLit		= r20

	// Assign default values
	ldi		rFlashFoodX, 0							// Set X position to 0
	ldi		rFlashFoodY, 0							// Set Y position to 0
	ldi		rIsLit, 0								// Set the food to being unlit
	
	// Store the values into the instance
	ldi		YH, HIGH(flashFood)						// Load pointer to the food instance
	ldi		YL, LOW(flashFood)
	std		Y + oFlashFoodPositionX, rFlashFoodX	// Store the X position
	std		Y + oFlashFoodPositionY, rFlashFoodY	// Store the Y position
	std		Y + oIsLitUp, rIsLit					// Store the lit state

		.UNDEF	rFlashFoodX
		.UNDEF	rFlashFoodY
		.UNDEF	rIsLit

	ret
/* initializeFlashFood end */

/******************************************************************************************
 * End Snake Game																	  
 *****************************************************************************************/


/**
 * Determines whether two positions intersect
 * @param rArgument0L - The X coordinate of the first position
 * @param rArgument0H - The Y coordinate of the first position
 * @param rArgument1L - The X coordinate of the second position
 * @param rArgument1H - The Y coordinate of the second position
 * @return rReturnL - Whether or not the points intersect (boolean)
 */
checkCollision:
		.DEF	rHasCollided = r18

 	// Set collision to false by default
	ldi		rHasCollided, 0

	// Check whether a collision has occured
	cp		rArgument0L, rArgument1L				// If the x values are different, we haven't collided
	brne	skipCollidedWithFood
	cp		rArgument0H, rArgument1H				// If the y values are different, we haven't collided
	brne	skipCollidedWithFood
	ldi		rHasCollided, 1							// If we have collided, return true
skipCollidedWithFood:

	// Return whether we have collided or not
	mov		rReturnL, rHasCollided					
		
		.UNDEF	rHasCollided
	ret
/* checkCollision end */



/**
 * Set the bits in the matrix with a smiley
 */
drawSnakeHeadMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Initialize the matrix with a smiley set
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rRowBits, 0b11100111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111101
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100101
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000011
	st		Y+, rRowBits
	ldi		rRowBits, 0b01100110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00111100
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* drawSnakeHeadMatrix end */	



/**
 * Draw the out of bounds write error image
 */
drawOutOfBoundsWriteMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Draw the out of bounds write symbol
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rRowBits, 0b10100000 
	st		Y+, rRowBits
	ldi		rRowBits, 0b01000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00011111
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010010 
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010010
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* drawOutOfBoundsWriteMatrix end */	



/**
 * Draw the out of bounds read error image
 */
drawOutOfBoundsReadMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Draw the out of bounds read symbol
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rRowBits, 0b11100000 
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100000
	st		Y+, rRowBits
	ldi		rRowBits, 0b11100000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00011111
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010010 
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010010
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* drawOutOfBoundsReadMatrix end */	



/**
 * Set the bits in the matrix with a skull
 */
drawSkullMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Initialize the matrix with a skull
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rRowBits, 0b01111110 
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b01111110 
	st		Y+, rRowBits
	ldi		rRowBits, 0b01011010
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* drawSkullMatrix end */	



/**
 * Draws a pixel in the matrix at the sepcified location
 * @param rArgument0L - The column (X) of the pixel
 * @param rArgument1L - The row (Y) of the pixel
 */
setPixel:
		.DEF	rRow		= r18
		.DEF	rColumn		= r19
		.DEF	rRowMask	= r20
		.DEF	rZero		= r21

	mov		rColumn,	rArgument0L
	mov		rRow,		rArgument1L

	// Assert coordinates X & Y < 8 (unsigned)
	cpi		rRow, 8
	brlo	setValidPixel
	cpi		rColumn, 8
	brlo	setValidPixel
	terminateErrori drawOutOfBoundsWriteMatrix
setValidPixel:

	// convert value to mask
	ldi		rRowMask, 0b10000000

setPixelColumnShiftLoop:
	cpi		rColumn, 0
	breq	setPixelColumnShiftEnd
	subi	rColumn, 1
	lsr		rRowMask
	jmp		setPixelColumnShiftLoop

setPixelColumnShiftEnd:

	// Load the matrix adress into 16 bit register Y (LOW + HIGH)
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)
	ldi		rZero, 0
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
 * @param rArgument0L - The column (X) of the pixel
 * @param rArgument1L - The row (Y) of the pixel
 */
clearPixel:
		.DEF	rRow		= r18
		.DEF	rColumn		= r19
		.DEF	rRowMask	= r20
		.DEF	rLocalTemp	= r21

	// Load the matrix adress into 16 bit register Y (LOW + HIGH)
	mov		rColumn,	rArgument0L
	mov		rRow,		rArgument1L

	// Assert coordinates X & Y < 8 (unsigned)
	cpi		rRow, 8
	brlo	clearValidPixel
	cpi		rColumn, 8
	brlo	clearValidPixel
	terminateErrori drawOutOfBoundsWriteMatrix
clearValidPixel:

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
	com		rRowMask

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
		.UNDEF	rLocalTemp

	ret
/* clearPixel end */



/**
 * isPixelSet
 * @param rArgument0L - X
 * @param rArgument0H - Y
 * @return rReturnL - is set
 */
isPixelSet:
		.DEF	rRow		= r18
		.DEF	rColumn		= r19
		.DEF	rRowMask	= r20
		.DEF	rZero		= r21

	// Load the matrix adress into 16 bit register Y (LOW + HIGH)
	mov		rColumn,	rArgument0L
	mov		rRow,		rArgument0H

	// Assert coordinates X & Y < 8
	cpi		rRow, 8
	brlo	isValidPixelSet
	cpi		rColumn, 8
	brlo	isValidPixelSet
	terminateErrori drawOutOfBoundsReadMatrix
isValidPixelSet:

	// convert value to mask
	ldi		rRowMask, 0b10000000
isPixelSetColumnShiftLoop:
	cpi		rColumn, 0
	breq	isPixelSetColumnShiftEnd
	subi	rColumn, 1
	lsr		rRowMask
	jmp		isPixelSetColumnShiftLoop
isPixelSetColumnShiftEnd:

	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)
	ldi		rZero, 0
	add		YL,	rRow
	adc		YH, rZero
	ld		rRow, Y

	// sort out specified bit
	and		rRow, rRowMask

	// Default is pixel not set
	ldi		rReturnL, 0

	// Check if pixel is set
	cpi		rRow, 0
	breq	isPixelNotSet
	ldi		rReturnL, 1

isPixelNotSet:

		.UNDEF	rRow
		.UNDEF	rColumn
		.UNDEF	rRowMask
		.UNDEF	rZero

	ret
/* isPixelSet end */



/**
 * isPixelClear
 * @param rArgument0L - X
 * @param rArgument0H - Y
 * @return rReturnL - is clear
 */
isPixelClear:
	call	isPixelSet			

	com		rReturnL
	andi	rReturnL, 0x01		// return !isPixelSet

isPixelNotClearReturn:

	ret
/* isPixelClear end */



/**
 * Inverts all the bits in the matrix
 */
invertMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18
		.DEF	rIterator	= r19

	// Load a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Loop through all the 8 rows
	ldi		rIterator, 8
invertRowBits:
	// Invert one row byte
	ld		rRowBits, Y			// Load bits
	com		rRowBits			// Invert bits
	st		Y+, rRowBits		// Store bits and increment the pointer

	// Repeat for all the rows
	dec		rIterator			
	cpi		rIterator, 0
	brne	invertRowBits

		.UNDEF	rRowBits
		.UNDEF	rIterator

	ret
/* invertMatrix end */



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
	nop
	nop
	nop
	nop
	
	nop
	inc		rCounter
	cpi		rCounter, 255
	brne	delayLoop

		.UNDEF	rCounter

		.DEF	rPortB		= r21
		.DEF	rPortC		= r22
		.DEF	rPortD		= r23

	// clear all input
	clr		rPortB
	clr		rPortC
	clr		rPortD

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
 * Generate a random 3 bit value based on the noise in the joystick as well as the 
 * current timer value. It's possible to choose which axis the joystick noise is 
 * based on and subsequent calls to this function should use different axes to ensure
 * independent results. The higher the bit, the more random it is.
 * @param rArgument0L - Which joystick axis to base the randomization on (constants JOYSTICK_X_AXIS and JOYSTICK_Y_AXIS)
 * @return rReturnL - A random value in the range 0 - 7 (3bit)
 */
 generateRandom3BitValue:
	call	generateRandom4BitValue		// Generate a 4 bit value
	lsr		rReturnL					// Drop the last, least random bit
	
	ret
/* generateRandom3BitValue end */


/**
 * Generate a random 4 bit value based on the noise in the joystick as well as the 
 * current timer value. It's possible to choose which axis the joystick noise is 
 * based on and subsequent calls to this function should use different axes to ensure
 * independent results. The higher the bit, the more random it is.
 * @param rArgument0L - Which joystick axis to base the randomization on (constants JOYSTICK_X_AXIS and JOYSTICK_Y_AXIS)
 * @return rReturnL - A random value in the range 0 - 15 (4bit)
 */
generateRandom4BitValue:

		.DEF	rRandomNumber = r18
		.DEF	rTimerValueL  = r19
		.DEF	rOutputValue  = r20

	// Get a 10 bit value (2 bytes) from the joystick based on the argument to this subroutine
	call	readJoystick
	mov		rRandomNumber, rReturnL

	// Add the lower part of the timer value to the random number to give additional noise
	lds		rTimerValueL, TCNT2
	add		rRandomNumber, rTimerValueL
	lsr2	rTimerValueL					
	add		rRandomNumber, rTimerValueL
	lsr2	rTimerValueL
	add		rRandomNumber, rTimerValueL
	lsr2	rTimerValueL
	add		rRandomNumber, rTimerValueL

	// Reverses the order of the 4 lowest bits and discards the rest
	ldi		rOutputValue, 0

	bst		rRandomNumber, 0
	bld		rOutputValue, 3

	bst		rRandomNumber, 1
	bld		rOutputValue, 2

	bst		rRandomNumber, 2
	bld		rOutputValue, 1

	bst		rRandomNumber, 3
	bld		rOutputValue, 0

	mov rReturnL, rOutputValue
		
		.UNDEF	rRandomNumber
		.UNDEF	rTimerValueL
		.UNDEF	rOutputValue
	
	ret
/* generateRandom4BitValue end */




/**
 * Load either the current X or Y value from joystick.
 * @param rArgument0L - The axis that is being read (constants JOYSTICK_X_AXIS and JOYSTICK_Y_AXIS)
 * @return rReturnL + rReturnH (16 bit) - value between 0 1023 (10 bits used)
 */
readJoystick:
		.DEF	rMaskBits = r18
		.DEF	rADMUX = r19
	
	// Merge the axis bit with the number 4 to give either 4 or 5, representing either x or y in the hardware
	andi	rArgument0L, 1			// Mask out LSB
	mov		rMaskBits, rArgument0L		
	ori		rMaskBits, 0b00000100	// choose joystick axis (port 4=Y / 5=X) 

	// Write to the ADMUX which axis we want to read from
	lds		rADMUX, ADMUX			// Load ADMUX byte
	or		rADMUX, rMaskBits		// set bit that should be set
	ori		rMaskBits, 0b11110000	// mask out preserved bits
	and		rADMUX, rMaskBits		// clear bits that should be cleared
	sts		ADMUX, rADMUX			// Write ADMUX byte back
		
		.UNDEF	rADMUX
		.UNDEF	rMaskBits

		.DEF	rADCSRA = r18

	// Start the analog to digital convertion

	lds		rADCSRA, ADCSRA
	ori		rADCSRA, 0b01000000		
	sts		ADCSRA, rADCSRA

	// Wait until the value has been read
readLoop:
	lds		rADCSRA, ADCSRA
	sbrc	rADCSRA, 6
	jmp		readLoop

	// Return the value
	lds		rReturnL, ADCL
	lds		rReturnH, ADCH

		.UNDEF	rADCSRA

	ret
/* readJoystick end */



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
	lsr2	rLowByte
	lsl6	rHighByte
	or		rLowByte, rHighByte
	mov		rReturnL, rLowByte
	ldi		rReturnH, 0

		.UNDEF	rHighByte
		.UNDEF	rLowByte

	ret
/* joystickValueTo8Bit end */


/**
 * Reads and returns the current axis aligned joystick direction, (4 directions + neutral)
 * @return rReturnL - Returns the joystick X direction (-1 is left, 0 is neutral, 1 is right)
 * @return rReturnH - Returns the joystick Y direction (-1 is up, 0 is neutral, 1 is down)
 */
 readJoystickDirection5:
		/* The joystick X/Y axis 8 bit values */
		.DEF	rJoystickX	= r6
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

	// Translate the raw X/Y values into a direction vector
	mov		rArgument0L, rJoystickX
	mov		rArgument1L, rJoystickY
	call	joystickValuesToDirection5

	pop		rJoystickY
	pop		rJoystickX

		.UNDEF	rJoystickY
		.UNDEF	rJoystickX

	ret
/* readJoystickDirection5 end */




/**
 * Get the current direction based on the joystick position. Diagonals are not allowed and count as neutral.
 * @param rArgument0L - The 8 bit X position of the joystick (0 - 255)
 * @param rArgument1L - The 8 bit Y position of the joystick (0 - 255)
 * @return rReturnL - Returns the joystick X direction (-1 is left, 0 is neutral, 1 is right)
 * @return rReturnH - Returns the joystick Y direction (-1 is up, 0 is neutral, 1 is down)
 */
joystickValuesToDirection5:
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
	
	// See if the joystick points to a corner
	cpi		rDirectionX, 0
	breq	notCorner
	cpi		rDirectionY, 0
	breq	notCorner

	// If the joystick point to a corner, set it to neutral
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
/* joystickValuesToDirection5 */



/**
 * Increment a timer data structure. 
 * @param rArgument0L - The lower half of a timer adress
 * @param rArgument0H - The upper half of a timer adress
 */
incrementTimer:
		/* The timercounter value  */
		.DEF	rTimerValueL	= r18
		.DEF	rTimerValueH	= r19

	// laod pointer
	mov		YL, rArgument0L
	mov		YH, rArgument0H


	// load timer value
	ldd		rTimerValueL, Y + oTimerCurrentTimeL
	ldd		rTimerValueH, Y + oTimerCurrentTimeH

	// increase time by 1
	addiw rTimerValueL, rTimerValueH, 1

	// store time
	std		Y + oTimerCurrentTimeL, rTimerValueL
	std		Y + oTimerCurrentTimeH, rTimerValueH

		.UNDEF	rTimerValueL
		.UNDEF	rTimerValueH

	ret
/* incrementTimer end */



/**
 * Initialize the timer 
 * @param rArgument0L - The lower half of a timer adress
 * @param rArgument0H - The upper half of a timer adress
 * @param rArgument1L - The lower half of the target time constant
 * @param rArgument1H - The upper half of the target time constant
 */
initializeTimer:
		.DEF	tempL = r18
		.DEF	tempH = r19

	// Get pointer adress
	mov		YL, rArgument0L
	mov		YH, rArgument0H

	// Set the current time to 0
	ldi		tempL, 0
	ldi		tempH, 0
	std		Y + oTimerCurrentTimeL, tempL
	std		Y + oTimerCurrentTimeH, tempH

	// Set the target time
	mov		tempL, rArgument1L
	mov		tempH, rArgument1H
	std		Y + oTimerTargetTimeL, tempL
	std		Y + oTimerTargetTimeH, tempH

		.UNDEF	tempL
		.UNDEF	tempH

	ret
/* initializeTimer end */


	
/**
 * Checks whether a timer has reached its target value and resets the timer if it has
 * @param rArgument0L - The lower half of a timer adress
 * @param rArgument0H - The upper half of a timer adress
 * @rReturnL - boolean whether or not the timer has reached its target
 */
checkTimer:
		.DEF	rValueL = r18
		.DEF	rValueH = r19
		.DEF	rCompareL = r20
		.DEF	rCompareH = r21

	// Get the pointer to the timer
	mov		YL, rArgument0L
	mov		YH, rArgument0H

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

		.UNDEF	rValueL
		.UNDEF	rValueH
		.UNDEF	rCompareL 
		.UNDEF	rCompareH

	ret
/* checkTimer end */



/**
 * Initialize timer 2 with a specific presscaling. The prescaling argument is in the 
 * range 0 - 7 using the bits (CS22, CS21, CS20), and represents timer scaling values 
 * of 1 - 1024 as defined by the hardware.
 * @param rArgument0L - Prescaling to be used
 */
 initializeHardwareTimer2:
		.DEF	rControlBits	= r18
		.DEF	rPrescaling		= r19
	mov		rPrescaling, rArgument0L
	andi	rPrescaling, ((1 << CS22) | (1 << CS21) | (1 << CS20))
												
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
		.UNDEF	rPrescaling
		.UNDEF	rControlBits

	ret
/* initializeTimer2 end */



/**
 * Entry point after the hardware has been initialized. Runs the code for a menu
 * where you can select between different programs.
 */
main:
	call snakeGame
	ret							// if program returned, exit main
/* main end */



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
	
	// Set X / Y joystick as input bit
	cbi		DDRC, 4				// PORTC4 aka Y axis
	cbi		DDRC, 5				// PORTC5 aka X axis

		/* Temporary value for modifying the ADMUX and ADCSRA state */
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
	crash						// if returned from main, terminate

	ret							// WARNING! IT SHOULD NEVER REACH THIS
/* init end */


/**
 * Terminates the program with a custom image in order to identify different types of errors
 * @param argument0L - The lower address byte of the custom drawing subroutine
 * @param argument0H - The upper address byte of the custom drawing subroutine
 */
terminateError:
	cli								// no more interupts after termination
	mov		ZL, rArgument0L
	mov		ZH, rArgument0H
	icall

terminateErrorLoop:
	call	render
	jmp		terminateErrorLoop

	// no ret since the program was terminated
/* terminateError end */
