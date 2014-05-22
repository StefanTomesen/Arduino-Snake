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

	/* Program */
	// Constants
	.EQU	MAX_PROGRAMS				= 9
	.EQU	PROGRAM_DATA_SIZE			= 4
	// Data structure
	.EQU	oProgramIconL				= 0x00
	.EQU	oProgramIconH				= 0x01
	.EQU	oProgramAdressL				= 0x02
	.EQU	oProgramAdressH				= 0x03

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

	/* Tetris */
	// Constants
	.EQU	TETRIS_NONE_BLOCK			= 0
	.EQU	TETRIS_I_BLOCK				= 1
	.EQU	TETRIS_O_BLOCK				= 2
	.EQU	TETRIS_T_BLOCK				= 3		
	.EQU	TETRIS_L_BLOCK				= 4	
	.EQU	TETRIS_REVERSE_L_BLOCK		= 5			
	.EQU	TETRIS_S_BLOCK				= 6		
	.EQU	TETRIS_REVERSE_S_BLOCK		= 7
	.EQU	TETRIS_BLOCKS				= 8
	.EQU	TETRIS_DATA_SIZE			= 4
	// Data structure
	.EQU	oTetrisBlockType			= 0x00
	.EQU	oTetrisBlockRotation		= 0x01
	.EQU	oTetrisBlockX				= 0x02
	.EQU	oTetrisBlockY				= 0x03
	.EQU	oTetrisSpeedEnabled			= 0x04

	/* Asteroid */
	// Constants
	.EQU	MAX_ASTEROIDS			= 32
	.EQU	ASTEROID_DATA_SIZE		= 4
	// Data structure
	.EQU	oAsteroidPositionX			= 0x00
	.EQU	oAsteroidPositionY			= 0x01
	.EQU	oAsteroidDirectionX			= 0x02
	.EQU	oAsteroidDirectionY			= 0x03

	/* Bullet */
	// Constants
	.EQU	MAX_BULLETS				= 8
	.EQU	BULLET_DATA_SIZE		= 5
	// Data structure
	.EQU	oBulletPositionX		= 0x00
	.EQU	oBulletPositionY		= 0x01
	.EQU	oBulletDirectionX		= 0x02
	.EQU	oBulletDirectionY		= 0x03
	.EQU	oBulletIsLit			= 0x04

	/* Ship */
	// Constants
	.EQU	SHIP_DATA_SIZE		= 4
	// Data structure
	.EQU	oShipPositionX		= 0x00
	.EQU	oShipPositionY		= 0x01
	.EQU	oShipDirectionX		= 0x02
	.EQU	oShipDirectionY		= 0x03


	/**
	 * Program constant definitions
	 */

	/* Program select menu */
	.EQU	PROGRAM_SWAP_TIME			= 32
	.EQU	PROGRAM_FRAME_TIME			= 64

	/* Snake Game */
	.EQU	SNAKE_UPDATE_TIME			= 16
	.EQU	SNAKE_FOOD_UPDATE_TIME		= 13
	.EQU	SNAKE_DIE_UPDATE_TIME		= SNAKE_UPDATE_TIME / 2
	.EQU	SNAKE_BOARD_FLASH_TIME		= 32
	.EQU	SNAKE_BOARD_BLINKS			= 5

	/* Timer test */
	.EQU	TIMER_TEST_TIMER0_TIME		= 32 + 127
	.EQU	TIMER_TEST_TIMER1_TIME		= 128 + 84
	.EQU	TIMER_TEST_TIMER2_TIME		= 512 + 02
	.EQU	TIMER_TEST_TIMER3_TIME		= 2048 + 295

	/* Random test */
	.EQU	RANDOM_NUMBER_COUNT			= 16
	.EQU	RANDOM_DISPLAY_TIME			= 128

	/* Error test */
	.EQU	ERROR_DISPLAY_TIME			= 128

	/* Tetris Game */
	.EQU	TETRIS_UPDATE_TIME			= 64
	.EQU	TETRIS_START_UPDATE_TIME	= TETRIS_UPDATE_TIME / 2
	.EQU	TETRIS_END_UPDATE_TIME		= TETRIS_UPDATE_TIME / 6
	.EQU	TETRIS_SPEED_UPDATE_TIME	= TETRIS_UPDATE_TIME / 4
	.EQU	TETRIS_JOYSTICK_UPDATE_TIME	= 16

	/* Asteroids Game */
	.EQU	ASTEROIDS_SHIP_UPDATE_TIME		= 8
	.EQU	ASTEROIDS_ASTEROID_UPDATE_TIME	= 16
	.EQU	ASTEROIDS_BULLET_UPDATE_TIME	= 4
	.EQU	ASTEROIDS_SPAWN_TIME			= 320
	.EQU	ASTEROIDS_SHOOT_TIME			= 48
	.EQU	ASTEROIDS_BULLET_FLASH_TIME		= ASTEROIDS_BULLET_UPDATE_TIME / 2
	.EQU	ASTEROIDS_ANIMATION_FRAME_TIME	= 8
	.EQU	ASTEROIDS_BOARD_FLASH_TIME		= 32
	.EQU	ASTEROIDS_BOARD_BLINKS			= 5


	/**							
	 * Data Segment
	 */
	.DSEG

// Ledjoy matrix
matrix:				.BYTE	NUM_ROWS					// LED matrix - 1 bit per "pixel" = one byte per row

// Main menu
programs:			.BYTE	MAX_PROGRAMS * PROGRAM_DATA_SIZE
programCount:		.BYTE	1

// Timer instances
renderTimer:		.BYTE	TIMER_DATA_SIZE
updateTimer:		.BYTE	TIMER_DATA_SIZE
flashTimer:			.BYTE	TIMER_DATA_SIZE
boardFlashTimer:	.BYTE	TIMER_DATA_SIZE

bulletTimer:		.BYTE	TIMER_DATA_SIZE
asteroidTimer:		.BYTE	TIMER_DATA_SIZE
spawnTimer:			.BYTE	TIMER_DATA_SIZE
shootTimer:			.BYTE	TIMER_DATA_SIZE

// Snake data
snake:				.BYTE	SNAKE_DATA_SIZE
snakeArrayX:		.BYTE	SNAKE_MAX_LENGTH
snakeArrayY:		.BYTE	SNAKE_MAX_LENGTH
flashFood:			.BYTE	FLASH_FOOD_DATA_SIZE

// Tetris data			
tetris:				.BYTE	TETRIS_DATA_SIZE	
// Tetris block data
tetrisBlockArrayX:	.BYTE	4 * 4 * TETRIS_BLOCKS
tetrisBlockArrayY:	.BYTE	4 * 4 * TETRIS_BLOCKS
tetrisBlockBitMap:	.BYTE	4 * 4 * TETRIS_BLOCKS

// Asteroids data
ship:				.BYTE	SHIP_DATA_SIZE
asteroidArray:		.BYTE	MAX_ASTEROIDS * ASTEROID_DATA_SIZE
asteroidCount:		.BYTE	1
bulletArray:		.BYTE	MAX_BULLETS * BULLET_DATA_SIZE
bulletCount:		.BYTE	1


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
	 * Add programs to the main menu
	 * @param @0 - the label to the icon drawing subroutine
	 * @param @1 - the label of the program subroutine
	 */
	.MACRO	addProgrami
		ldi		rArgument0L, LOW(@0)
		ldi		rArgument0H, HIGH(@0)
		ldi		rArgument1L, LOW(@1)
		ldi		rArgument1H, HIGH(@1)
		call	addProgram
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

	incrementTimeri bulletTimer
	incrementTimeri asteroidTimer
	incrementTimeri spawnTimer
	incrementTimeri shootTimer

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
 * Program: Timer Test
 * Start runing the timer test
 *****************************************************************************************/
timerTest:

	// Hardware timer initializiton
	ldi		rArgument0L, TIMER2_PRE_1024
	call	initializeHardwareTimer2

	initializeTimeri renderTimer,		TIMER_TEST_TIMER0_TIME
	initializeTimeri updateTimer,		TIMER_TEST_TIMER1_TIME
	initializeTimeri flashTimer,		TIMER_TEST_TIMER2_TIME
	initializeTimeri boardFlashTimer,	TIMER_TEST_TIMER3_TIME

	// timer mystery debug code
	//SOLVED IT WAS A GOD DAMN MEMOR MISMATCH WITH STS/LDS ADN IN/OUT	

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
	
	ldi		YH, HIGH(flashTimer)	// Set Y to matrix address
	ldi		YL, LOW(flashTimer)
	ld		rCounterL, Y+ 
	ld		rCounterH, Y+
	
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	adiw	Y, 4
	st		Y+, rCounterL
	st		Y+, rCounterH
	
	ldi		YH, HIGH(boardFlashTimer)	// Set Y to matrix address
	ldi		YL, LOW(boardFlashTimer)
	ld		rCounterL, Y+ 
	ld		rCounterH, Y+
	
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	adiw	Y, 6
	st		Y+, rCounterL
	st		Y+, rCounterH

		.UNDEF	rCounterL
		.UNDEF	rCounterH  

	checkTimeri updateTimer
	checkTimeri renderTimer
	checkTimeri flashTimer
	checkTimeri boardFlashTimer

	call	render
	jmp		timerTestLoop

	ret
/* timerTest end */

/******************************************************************************************
 * End Timer Test
 *****************************************************************************************/



 /******************************************************************************************
 * Program: Random Pixel Test
 * Draws a number of random pixelels
 *****************************************************************************************/
randomPixelDraw:	

	// Timer initializiton
	ldi		rArgument0L, TIMER2_PRE_1024
	call	initializeHardwareTimer2

	initializeTimeri updateTimer, RANDOM_DISPLAY_TIME

		.DEF	rCounter	= r16
		.DEF	rRandomX	= r19
		.DEF	rRandomY	= r20

randomGenerateNumber:
	call	clearMatrix
	ldi		rCounter, RANDOM_NUMBER_COUNT

randomGenerateNumberLoop:

	// Generate a new piece of food
	// Generate a random value for the X axis based on the input noise of the X axis
	ldi		rArgument0L, JOYSTICK_X_AXIS
	call	generateRandom3BitValue
	mov		rRandomX, rReturnL

	// Generate a random value for the Y axis based on the input noise of the Y axis
	push	rRandomX								// Protect the X position from being overwritten in the subroutine
	ldi		rArgument0L, JOYSTICK_Y_AXIS
	call	generateRandom3BitValue
	pop		rRandomX
	mov		rRandomY, rReturnL

	// Draw the food in case it clear a piece of the snake	
	setPixelr	rRandomX, rRandomY

	dec		rCounter
	cpi		rCounter, 0
	brne	randomGenerateNumberLoop

		.UNDEF	rCounter
		.UNDEF	rRandomX
		.UNDEF	rRandomY

randomRender:
	checkTimeri updateTimer
	cpi		rReturnL, 1
	breq	randomGenerateNumber
	call	render
	jmp		randomRender

	ret
/* randomPixelDraw end */

/******************************************************************************************
 * End Random Pixel Draw
 *****************************************************************************************/



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



/******************************************************************************************
 * Program: Tetris Game
 * The classic game tetris
 *****************************************************************************************/
tetrisGame:
	call	clearMatrix

	// Hardware timer initializiton
	ldi		rArgument0L, TIMER2_PRE_1024
	call	initializeHardwareTimer2

	call	initializeTetrisBlocks

	// Run start animation, then clear
	call	tetrisStartAnimation
	call	clearMatrix

	initializeTimeri updateTimer, TETRIS_UPDATE_TIME
	initializeTimeri renderTimer, TETRIS_JOYSTICK_UPDATE_TIME

	call	initializeTetris
	call	tetrisNextBlock

	// Draw the next block
	call	drawTetrisBlock

tetrisLoop:
	checkTimeri		renderTimer
	cpi		rReturnL, 1
	brne	tetrisSkipJoyStickUpdate
	
	call	tetrisJoyStickUpdate
tetrisSkipJoyStickUpdate:

	checkTimeri		updateTimer
	cpi		rReturnL, 1
	brne	tetrisSkipUpdate

	call	tetrisUpdate
	call	tetrisClearFullRows
tetrisSkipUpdate:
	
	call	render
	jmp		tetrisLoop

	ret
/* tetrisGame end */



/**
 * initializeTetrisBlocks
 */
initializeTetrisBlocks:
		.DEF	rBlockX			= r18
		.DEF	rBlockY			= r19
		
	// INTERNAL MACRO, ONLY TO BE USED HERE
	.MACRO store 
		ldi		rBlockX, @0
		ldi		rBlockY, @1
		st		X+, rBlockX
		st		Y+, rBlockY	
	.ENDMACRO

	// Load block x/y array
	ldi		XL, LOW(tetrisBlockArrayX)
	ldi		XH, HIGH(tetrisBlockArrayX)
	ldi		YL, LOW(tetrisBlockArrayY)
	ldi		YH, HIGH(tetrisBlockArrayY)

	// Skip null block
	adiw	X, 4 * 4
	adiw	Y, 4 * 4

	// I Block
	// Rotation 0
	store	0, 1
	store	1, 1
	store	2, 1
	store	3, 1
	// Rotation 1
	store	1, 0
	store	1, 1
	store	1, 2
	store	1, 3
	// Rotation 2
	store	0, 1
	store	1, 1
	store	2, 1
	store	3, 1
	// Rotation 3
	store	1, 0
	store	1, 1
	store	1, 2
	store	1, 3

	// O Block
	// Rotation 0
	store	1, 1
	store	1, 2
	store	2, 1
	store	2, 2
	// Rotation 1
	store	1, 1
	store	1, 2
	store	2, 1
	store	2, 2
	// Rotation 2
	store	1, 1
	store	1, 2
	store	2, 1
	store	2, 2
	// Rotation 3
	store	1, 1
	store	1, 2
	store	2, 1
	store	2, 2

	// T Block
	// Rotation 0
	store	0, 1
	store	1, 0
	store	1, 1
	store	2, 1
	// Rotation 1
	store	1, 0
	store	1, 1
	store	1, 2
	store	2, 1
	// Rotation 2
	store	0, 0
	store	1, 1
	store	1, 0
	store	2, 0
	// Rotation 3
	store	1, 0
	store	1, 1
	store	1, 2
	store	0, 1

	// L Block
	// Rotation 0
	store	1, 0
	store	1, 1
	store	2, 1
	store	3, 1
	// Rotation 1
	store	1, 1
	store	1, 2
	store	1, 3
	store	2, 1
	// Rotation 2
	store	0, 0
	store	1, 0
	store	2, 0
	store	2, 1
	// Rotation 3
	store	1, 2
	store	2, 0
	store	2, 1
	store	2, 2

	// Reverse L Block
	// Rotation 0
	store	0, 1
	store	1, 1
	store	2, 1
	store	2, 0
	// Rotation 1
	store	1, 0
	store	1, 1
	store	1, 2
	store	2, 2
	// Rotation 2
	store	1, 2
	store	1, 1
	store	2, 1
	store	3, 1
	// Rotation 3
	store	1, 0
	store	2, 0
	store	2, 1
	store	2, 2

	// S Block
	// Rotation 0
	store	2, 1
	store	1, 1
	store	1, 0
	store	0, 0
	// Rotation 1
	store	1, 2
	store	1, 1
	store	2, 1
	store	2, 0
	// Rotation 2
	store	2, 1
	store	1, 1
	store	1, 0
	store	0, 0
	// Rotation 3
	store	1, 2
	store	1, 1
	store	2, 1
	store	2, 0

	// Reverse S Block
	// Rotation 0
	store	0, 1
	store	1, 1
	store	1, 0
	store	2, 0
	// Rotation 1
	store	1, 0
	store	1, 1
	store	2, 1
	store	2, 2
	// Rotation 2
	store	0, 1
	store	1, 1
	store	1, 0
	store	2, 0
	// Rotation 3
	store	1, 0
	store	1, 1
	store	2, 1
	store	2, 2

		.UNDEF	rBlockX
		.UNDEF	rBlockY

	ret
/* initializeTetrisBlocks end */



/**
 * initializeTetris
 */
initializeTetris:
		.DEF	rZero			= r18

	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldi		rZero, 0
	std		Y + oTetrisBlockType, rZero
	std		Y + oTetrisBlockRotation, rZero
	std		Y + oTetrisBlockX, rZero
	std		Y + oTetrisBlockY, rZero

		.UNDEF	rZero

	ret
/* initializeTetris end */



/**
 * tetrisStartAnimation
 */
tetrisStartAnimation:
		.DEF	rIterator = r16
	push	rIterator

	initializeTimeri updateTimer, TETRIS_START_UPDATE_TIME
	
	call	clearMatrix

	// there are 7 differend Blocks
	ldi		rIterator, 7

		.DEF	rBlockX	= r18
		.DEF	rBlockY	= r19
		.DEF	rZero	= r20

	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldi		rZero, 0
	ldi		rBlockX, 3
	ldi		rBlockY, 3
	std		Y + oTetrisBlockType, rIterator
	std		Y + oTetrisBlockRotation, rZero
	std		Y + oTetrisBlockX, rBlockX
	std		Y + oTetrisBlockY, rBlockY

		.UNDEF	rBlockX
		.UNDEF	rBlockY
		.UNDEF	rZero

tetrisStartLoop:

	// If shown all blocks (except 'null' block), end loop
	cpi		rIterator, 0
	breq	tetrisStartReturn

	// Clear and draw block
	call	clearMatrix
	call	drawTetrisBlock

	// Prepare for next block type
	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	dec		rIterator
	std		Y + oTetrisBlockType, rIterator

tetrisStartRender:
	// if time, show next block
	checkTimeri updateTimer
	cpi		rReturnL, 1
	breq	tetrisStartLoop

	call	render

	jmp		tetrisStartRender

tetrisStartReturn:

	pop		rIterator
		.UNDEF	rIterator
				
	ret
/* tetrisStartAnimation end */



/**
 * tetrisEndAnimation
 */
tetrisEndAnimation:
		.DEF	rRow		= r16
	push	rRow

	initializeTimeri updateTimer, TETRIS_END_UPDATE_TIME

	// Start with row 8 (one past bottom row)
	ldi		rRow, 8

tetrisEndLoop:
	// if filled all rows, end loop
	dec		rRow
	cpi		rRow, -1
	breq	tetrisEndReturn

		.DEF	rRowMask	= r18
		.DEF	rZero		= r19

	// load adress to current row
	ldi		YL, LOW(matrix)
	ldi		YH, HIGH(matrix)
	add		YL, rRow
	adc		YH, rZero

	// Load, fill and store row
	ld		rRowMask, Y
	ldi		rRowMask, 0xFF
	st		Y, rRowMask
		
		.UNDEF	rRowMask
		.UNDEF	rZero

tetrisEndRender:
	// if time, fill next row
	checkTimeri updateTimer
	cpi		rReturnL, 1
	breq	tetrisEndLoop
	
	call	render
	jmp		tetrisEndRender

tetrisEndReturn:

	pop		rRow
		.UNDEF	rRow	

	ret
/* tetrisEndAnimation end */



/**
 * clearFullRows
 */
tetrisClearFullRows:

	call	clearTetrisBlock

		.DEF	rRow			= r18
		.DEF	rRowCounter		= r19
		.DEF	rRowCopyCounter	= r20

	ldi		YL, LOW(matrix)
	ldi		YH, HIGH(matrix)
	adiw	Y, 7

	ldi		rRowCounter, 8

tetrisClearRowsLoop:
	ld		rRow, Y
	// Skip clear if not full
	cpi		rRow, 0xFF
	brne	tetrisSkipClear
	clr		rRow
	st		Y, rRow

	mov		ZL, YL
	mov		ZH, YH
	sbiw	Z, 1
	mov		rRowCopyCounter, rRowCounter
	subi	rRowCopyCounter, 1

tetrisClearRowsCopyLoop:
	ld		rRow, Z
	adiw	Z, 1
	st		Z, rRow
	sbiw	Z, 2

	dec		rRowCopyCounter
	cpi		rRowCopyCounter, 0
	brne	tetrisClearRowsCopyLoop
	// Clear top row
	clr		rRow
	st		Z, rRow
	
	adiw	Y, 1
tetrisSkipClear:
	
	sbiw	Y, 1

	dec		rRowCounter
	cpi		rRowCounter, 0
	brne	tetrisClearRowsLoop

		.UNDEF	rRow
		.UNDEF	rRowCounter
		.UNDEF	rRowCopyCounter

	call	drawTetrisBlock

	ret
/* clearFullRows end */



/**
 * tetrisUpdate
 */
tetrisUpdate:
		.DEF	rBlockX			= r18
		.DEF	rBlockY			= r19
		.DEF	rBlockRotation	= r20

	// Clear old position
	call	clearTetrisBlock

	// Move down
	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldd		rBlockY, Y + oTetrisBlockY
	inc		rBlockY
	std		Y + oTetrisBlockY, rBlockY

	call	tetrisCheckCollision
	cpi		rReturnL, 0
	breq	tetrisNewBlock

	jmp		tetrisCanMoveEnd

tetrisNewBlock:
	// Move back up (can't move down)
	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldd		rBlockY, Y + oTetrisBlockY
	dec		rBlockY
	std		Y + oTetrisBlockY, rBlockY

	// Draw the old block back
	call	drawTetrisBlock

	// Generate the next block
	call	tetrisNextBlock

	// If new block collides on entry, Game Over and reset
	call	tetrisCheckCollision
	cpi		rReturnL, 1
	breq	tetrisCanMoveEnd
	call	tetrisEndAnimation
	jmp		tetrisGame

tetrisCanMoveEnd:
	call	drawTetrisBlock

		.UNDEF	rBlockX
		.UNDEF	rBlockY
		.UNDEF	rBlockRotation

	ret
/* tetrisUpdate end */



/**
 * tetrisJoyStickUpdate
 */
tetrisJoyStickUpdate:
		.DEF	rDirectionX		= r18
		.DEF	rDirectionY		= r19
		.DEF	rSpeedEnabled	= r20

	call	clearTetrisBlock

	// choose action from joystick
	call	readJoystickDirection5
	mov		rDirectionX, rReturnL
	mov		rDirectionY, rReturnH

	cpi		rDirectionY, 1			// joystick down - speeds up block decent
	breq	tetrisSpeed

	// Load speed is enabled
	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldd		rSpeedEnabled, Y + oTetrisSpeedEnabled
	
	// If speed was enabled
	cpi		rSpeedEnabled, 0
	breq	tetrisSkipResetSpeed

	// Disable speed and store it
	ldi		rSpeedEnabled, 0
	std		Y + oTetrisSpeedEnabled, rSpeedEnabled

		.UNDEF	rSpeedEnabled	
		.DEF	tempL = r20
		.DEF	tempH = r21

	// Update timer
	ldi		YL, LOW(updateTimer)
	ldi		YH, HIGH(updateTimer)
	ldi		tempL, LOW(TETRIS_UPDATE_TIME)
	ldi		tempH, HIGH(TETRIS_UPDATE_TIME)
	std		Y + oTimerTargetTimeL, tempL
	std		Y + oTimerTargetTimeH, tempH

		.UNDEF	tempL
		.UNDEF	tempH

tetrisSkipResetSpeed:

	cpi		rDirectionY, -1			// joystick up - rotates block
	breq	tetrisRotate
	cpi		rDirectionX, 0			// joystick right or left
	brne	tetrisMoveSideways

	// if nothing, skip action
	jmp		tetrisJoystickEnd

tetrisSpeed:
		.DEF	rSpeedEnabled	= r20

	// Load speed is enabled
	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldd		rSpeedEnabled, Y + oTetrisSpeedEnabled

	// If speed was not enabled
	cpi		rSpeedEnabled, 1
	breq	tetrisSkipEnableSpeed

	// Enable speed and store it
	ldi		rSpeedEnabled, 1
	std		Y + oTetrisSpeedEnabled, rSpeedEnabled

		.UNDEF	rSpeedEnabled	
		.DEF	tempL = r20
		.DEF	tempH = r21

	// Update timer
	ldi		YL, LOW(updateTimer)
	ldi		YH, HIGH(updateTimer)
	ldi		tempL, LOW(TETRIS_SPEED_UPDATE_TIME)
	ldi		tempH, HIGH(TETRIS_SPEED_UPDATE_TIME)
	std		Y + oTimerTargetTimeL, tempL
	std		Y + oTimerTargetTimeH, tempH

		.UNDEF	tempL
		.UNDEF	tempH

tetrisSkipEnableSpeed:

	jmp		tetrisJoystickEnd

tetrisRotate:

		.DEF	rBlockRotation	= r20

	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldd		rBlockRotation, Y + oTetrisBlockRotation
	inc		rBlockRotation
	andi	rBlockRotation, 0b00000011					// rBlockRotation % 4
	std		Y + oTetrisBlockRotation, rBlockRotation

	push	rDirectionX
	push	rDirectionY
	call	tetrisCheckCollision
	pop		rDirectionY
	pop		rDirectionX

	cpi		rReturnL, 1
	breq	tetrisCanRotate

	// If Can not rotate, rotate back
	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldd		rBlockRotation, Y + oTetrisBlockRotation
	dec		rBlockRotation
	andi	rBlockRotation, 0b00000011					// rBlockRotation % 4
	std		Y + oTetrisBlockRotation, rBlockRotation
tetrisCanRotate:

	jmp		tetrisJoystickEnd

		.UNDEF	rBlockRotation
		.DEF	rBlockX			= r20
		.DEF	rBlockY			= r21

tetrisMoveSideways:
	// Move block sidways
	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldd		rBlockX, Y + oTetrisBlockX
	add		rBlockX, rDirectionX
	std		Y + oTetrisBlockX, rBlockX

	push	rDirectionX
	call	tetrisCheckCollision
	pop		rDirectionX

	cpi		rReturnL, 1
	breq	tetrisJoystickEnd

	// If Can not move sideways, move back
	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)
	ldd		rBlockX, Y + oTetrisBlockX
	sub		rBlockX, rDirectionX
	std		Y + oTetrisBlockX, rBlockX

		.UNDEF	rBlockX
		.UNDEF	rBlockY

tetrisJoystickEnd:

		.UNDEF	rDirectionX
		.UNDEF	rDirectionY

	call	drawTetrisBlock

	ret
/* tetrisJoyStickUpdate end */



/**
 * tetrisNextBlock
 */
tetrisNextBlock:	
		.DEF	rBlockX			= r18
		.DEF	rBlockY			= r19
		.DEF	rBlockRotation	= r20

	// Generate the next block
tetrisGenerateNextBlock:
	call	generateRandom3BitValue
	cpi		rReturnL, TETRIS_NONE_BLOCK
	breq	tetrisGenerateNextBlock			// while type is NONE_BLOCK, generate new

	// Load pointer
	ldi		YL, LOW(tetris)
	ldi		YH, HIGH(tetris)

	// Store type
	std		Y + oTetrisBlockType, rReturnL

	// Reset position and rotation
	ldi		rBlockX, 3
	ldi		rBlockY, 0
	ldi		rBlockRotation, 0
	std		Y + oTetrisBlockX, rBlockX
	std		Y + oTetrisBlockY, rBlockY	
	std		Y + oTetrisBlockRotation, rBlockRotation	

		.UNDEF	rBlockX
		.UNDEF	rBlockY
		.UNDEF	rBlockRotation

	ret
/* tetrisNextBlock end */



/**
 * tetrisCheckCollision
 * @return rReturnL - true/false
 */
tetrisCheckCollision:
		.DEF	rZero			= r18
		.DEF	rBlockType		= r19
		.DEF	rBlockX			= r3
		.DEF	rBlockY			= r4
		.DEF	rBlockRotation	= r5
	push	rBlockX
	push	rBlockY
	push	rBlockRotation

	ldi		YH, HIGH(tetris)
	ldi		YL, LOW(tetris)
	ldd		rBlockType, Y + oTetrisBlockType
	ldd		rBlockRotation, Y + oTetrisBlockRotation
	ldd		rBlockX, Y + oTetrisBlockX
	ldd		rBlockY, Y + oTetrisBlockY	

	// none is error
	cpi		rBlockType, TETRIS_NONE_BLOCK	
	brne	tetrisCheckValidBlock
	terminateErrori drawTemplarMatrix

tetrisCheckValidBlock:
	// Load block x/y array
	ldi		XL, LOW(tetrisBlockArrayX)
	ldi		XH, HIGH(tetrisBlockArrayX)
	ldi		YL, LOW(tetrisBlockArrayY)
	ldi		YH, HIGH(tetrisBlockArrayY)

	// offset to right block type
	lsl4	rBlockType				// times 16

	ldi		rZero, 0
	cp		rBlockRotation, rZero
	breq	tetrisCheckRotateOffsetLoopEnd
tetrisCheckRotateOffsetLoop:

	subi	rBlockType, -4
	dec		rBlockRotation

	ldi		rZero, 0
	cp		rBlockRotation, rZero
	brne	tetrisCheckRotateOffsetLoop
tetrisCheckRotateOffsetLoopEnd:

	ldi		rZero, 0
	add		XL, rBlockType
	adc		XH, rZero
	add		YL, rBlockType
	adc		YH, rZero

		.UNDEF	rBlockType
		.UNDEF	rZero
		.DEF	rCounter	= r19
		.DEF	rBlockXSum	= r20
		.DEF	rBlockYSum	= r21

	ldi		rCounter, 4

tetrisCheckLoop:
	ld		rBlockXSum, X+
	ld		rBlockYSum, Y+
	add		rBlockXSum, rBlockX
	add		rBlockYSum, rBlockY
	
	// if X is outside range (0, 7)
	ldi		rReturnL, 0
	cpi		rBlockXSum, 8
	brge	tetrisCheckReturn
	cpi		rBlockXSum, 0
	brlt	tetrisCheckReturn

	// if Y is outside range (0, 7)
	ldi		rReturnL, 0
	cpi		rBlockYSum, 8
	brge	tetrisCheckReturn
	cpi		rBlockYSum, 0
	brlt	tetrisCheckReturn

	// Check Pixels
	push	rCounter
	push	XL
	push	XH
	push	YL
	push	YH

	mov		rArgument0L, rBlockXSum
	mov		rArgument0H, rBlockYSum
	call	isPixelClear

	pop		YH
	pop		YL
	pop		XH
	pop		XL
	pop		rCounter

	// if Pixel not clear return false
	cpi		rReturnL, 0
	breq	tetrisCheckReturn

	dec		rCounter
	cpi		rCounter, 0
	brne	tetrisCheckLoop

	ldi		rReturnL, 1
	
tetrisCheckReturn:

	pop		rBlockRotation
	pop		rBlockY
	pop		rBlockX
		.UNDEF	rBlockX
		.UNDEF	rBlockY
		.UNDEF	rBlockRotation
		.UNDEF	rCounter
		.UNDEF	rBlockXSum
		.UNDEF	rBlockYSum

	ret
/* checkCanMove end */



/**
 * DrawTetrisBlock
 */
drawTetrisBlock:
		.DEF	rZero			= r18
		.DEF	rBlockType		= r19
		.DEF	rBlockX			= r3
		.DEF	rBlockY			= r4
		.DEF	rBlockRotation	= r5
	push	rBlockX
	push	rBlockY
	push	rBlockRotation

	ldi		YH, HIGH(tetris)
	ldi		YL, LOW(tetris)
	ldd		rBlockType, Y + oTetrisBlockType
	ldd		rBlockRotation, Y + oTetrisBlockRotation
	ldd		rBlockX, Y + oTetrisBlockX
	ldd		rBlockY, Y + oTetrisBlockY

	// none is error
	cpi		rBlockType, TETRIS_NONE_BLOCK	
	brne	tetrisDrawValidBlock
	terminateErrori drawTemplarMatrix

tetrisDrawValidBlock:
	// Load block x/y array
	ldi		XL, LOW(tetrisBlockArrayX)
	ldi		XH, HIGH(tetrisBlockArrayX)
	ldi		YL, LOW(tetrisBlockArrayY)
	ldi		YH, HIGH(tetrisBlockArrayY)

	// offset to right block type
	lsl4	rBlockType				// times 16

	ldi		rZero, 0
	cp		rBlockRotation, rZero
	breq	tetrisDrawRotateOffsetLoopEnd
tetrisDrawRotateOffsetLoop:

	subi	rBlockType, -4
	dec		rBlockRotation
	ldi		rZero, 0
	cp		rBlockRotation, rZero
	brne	tetrisDrawRotateOffsetLoop
tetrisDrawRotateOffsetLoopEnd:

	ldi		rZero, 0
	add		XL, rBlockType
	adc		XH, rZero
	add		YL, rBlockType
	adc		YH, rZero

		.UNDEF	rBlockType
		.UNDEF	rZero
		.DEF	rCounter	= r19
		.DEF	rBlockXSum	= r20
		.DEF	rBlockYSum	= r21

	ldi		rCounter, 4

tetrisDrawLoop:
	ld		rBlockXSum, X+
	ld		rBlockYSum, Y+
	add		rBlockXSum, rBlockX
	add		rBlockYSum, rBlockY

	// Draw pixels
	push	rCounter
	push	XL
	push	XH
	push	YL
	push	YH
	setPixelr rBlockXSum, rBlockYSum
	pop		YH
	pop		YL
	pop		XH
	pop		XL
	pop		rCounter

	dec		rCounter
	cpi		rCounter, 0
	brne	tetrisDrawLoop

	pop		rBlockRotation
	pop		rBlockY
	pop		rBlockX
		.UNDEF	rBlockX
		.UNDEF	rBlockY
		.UNDEF	rBlockRotation
		.UNDEF	rCounter
		.UNDEF	rBlockXSum
		.UNDEF	rBlockYSum

	ret
/* drawTetrisBlock end */



/**
 * clearTetrisBlock
 */
clearTetrisBlock:

		.DEF	rZero			= r18
		.DEF	rBlockType		= r19
		.DEF	rBlockX			= r3
		.DEF	rBlockY			= r4
		.DEF	rBlockRotation	= r5
	push	rBlockX
	push	rBlockY
	push	rBlockRotation

	ldi		YH, HIGH(tetris)
	ldi		YL, LOW(tetris)
	ldd		rBlockType, Y + oTetrisBlockType
	ldd		rBlockRotation, Y + oTetrisBlockRotation
	ldd		rBlockX, Y + oTetrisBlockX
	ldd		rBlockY, Y + oTetrisBlockY

	// none is error
	cpi		rBlockType, TETRIS_NONE_BLOCK	
	brne	tetrisClearValidBlock
	terminateErrori drawTemplarMatrix

tetrisClearValidBlock:
	// Load block x/y array
	ldi		XL, LOW(tetrisBlockArrayX)
	ldi		XH, HIGH(tetrisBlockArrayX)
	ldi		YL, LOW(tetrisBlockArrayY)
	ldi		YH, HIGH(tetrisBlockArrayY)

	// offset to right block type
	lsl4	rBlockType				// times 16

	ldi		rZero, 0
	cp		rBlockRotation, rZero
	breq	tetrisClearRotateOffsetLoopEnd
tetrisClearRotateOffsetLoop:
	subi	rBlockType, -4
	dec		rBlockRotation
	ldi		rZero, 0
	cp		rBlockRotation, rZero
	brne	tetrisClearRotateOffsetLoop
tetrisClearRotateOffsetLoopEnd:

	ldi		rZero, 0
	add		XL, rBlockType
	adc		XH, rZero
	add		YL, rBlockType
	adc		YH, rZero

		.UNDEF	rBlockType
		.UNDEF	rZero
		.DEF	rCounter	= r19
		.DEF	rBlockXSum	= r20
		.DEF	rBlockYSum	= r21

	ldi		rCounter, 4

tetrisClearLoop:
	ld		rBlockXSum, X+
	ld		rBlockYSum, Y+
	add		rBlockXSum, rBlockX
	add		rBlockYSum, rBlockY
	// Clear pixel
	push	rCounter
	push	XL
	push	XH
	push	YL
	push	YH
	clearPixelr rBlockXSum, rBlockYSum
	pop		YH
	pop		YL
	pop		XH
	pop		XL
	pop		rCounter

	dec		rCounter
	cpi		rCounter, 0
	brne	tetrisClearLoop

	pop		rBlockRotation
	pop		rBlockY
	pop		rBlockX
		.UNDEF	rBlockX
		.UNDEF	rBlockY
		.UNDEF	rBlockRotation
		.UNDEF	rCounter
		.UNDEF	rBlockXSum
		.UNDEF	rBlockYSum

	ret
/* clearTetrisBlock end */



/******************************************************************************************
 * End Tetris Game																	  
 *****************************************************************************************/



/******************************************************************************************
 * Program: Asteroids Game																  
 * The classical game of asteroids														  
 *****************************************************************************************/
asteroidsGame:
	call	clearMatrix
	
	// Hardware timer initializiton
	ldi		rArgument0L, TIMER2_PRE_1024
	call	initializeHardwareTimer2

	// Run the start animation
	call asteroidsStartAnimation

	// Initialize timers
	initializeTimeri updateTimer, ASTEROIDS_SHIP_UPDATE_TIME
	initializeTimeri bulletTimer, ASTEROIDS_BULLET_UPDATE_TIME
	initializeTimeri asteroidTimer, ASTEROIDS_ASTEROID_UPDATE_TIME
	initializeTimeri spawnTimer, ASTEROIDS_SPAWN_TIME
	initializeTimeri shootTimer, ASTEROIDS_SHOOT_TIME
	initializeTimeri flashTimer, ASTEROIDS_BULLET_FLASH_TIME


	// Give the ship a valid position and direction
	call	initializeShip

	// Initialize the empty bullet and asteroid arrays
	call	initializeAsteroidArray
	call	initializeBulletArray

	// Start the game with two asteroids already out
	call	spawnAsteroid
	call	spawnAsteroid
	
// The loop running the asteroids game
asteroidsGameLoop:

		.DEF	rJoystickDirectionX	= r16
		.DEF	rJoystickDirectionY	= r17

	// Get the joystick direction
	call	readJoystickDirection9
	mov		rJoystickDirectionX, rReturnL
	mov		rJoystickDirectionY, rReturnH

	// Only update the ship's direction if the joystick isn't neutral
	cpi		rJoystickDirectionX, 0
	brne	updateShipDirection
	cpi		rJoystickDirectionY, 0
	brne	updateShipDirection
	jmp		skipUpdateShipDirection

updateShipDirection:
	// Load a pointer to the ship
	ldi		YL, LOW(ship)		
	ldi		YH, HIGH(ship)

	// Update the ship direction
	std		Y + oShipDirectionX, rJoystickDirectionX
	std		Y + oShipDirectionY, rJoystickDirectionY
skipUpdateShipDirection:

	// Check if it's time for an asteroid update
	checkTimeri asteroidTimer
	cpi		rReturnL, 1
	brne	skipAsteroidUpdate

	// Move asteroids
	call	moveAsteroids
skipAsteroidUpdate:

	// Check if it's time to spawn a new asteroid
	checkTimeri spawnTimer
	cpi		rReturnL, 1
	brne	skipAsteroidSpawn
	
	// Spawn a new asteroid
	call	spawnAsteroid
skipAsteroidSpawn:

	// Check if it's time to update the ship
	checkTimeri updateTimer
	cpi		rReturnL, 1
	brne	skipShipUpdate
	
	// If the joystick is neutral, don't move the ship
	cpi		rJoystickDirectionX, 0
	brne	doMoveShip
	cpi		rJoystickDirectionY, 0
	brne	doMoveShip
	jmp		doShipCollision
doMoveShip:
	// Move the ship in the direction it's pointing
	call	moveShip
doShipCollision:
	// If the ship has collided with any asteroid, it's game over
	call	checkShipCollision
	cpi		rReturnL, 1
	breq	asteroidsGameOver
skipShipUpdate:

	// Check if it's time to update the bullets
	checkTimeri bulletTimer
	cpi		rReturnL, 1
	brne	skipBulletUpdate
	
	// Move the bullets and check for collisions
	call	moveBullets
	call	removeDeadBullets
	call	resolveBulletCollisions
skipBulletUpdate:

	// Check if it's time to flash the bullets
	checkTimeri flashTimer
	cpi		rReturnL, 1
	brne	skipBulletFlash
	
	// Toggle the bullets' visibilities
	call	flashBullets
skipBulletFlash:

	// Check if it's time to shoot
	checkTimeri shootTimer
	cpi		rReturnL, 1
	brne	skipShoot
	
	// Shoot a new bullet
	call	spawnBullet
skipShoot:

	// Render the current frame
	call	clearMatrix
	
	call	drawAsteroids
	call	drawShip
	call	drawBullets

	call	render

	// Run another iteration
	jmp		asteroidsGameLoop
		
		.UNDEF	rJoystickDirectionX
		.UNDEF	rJoystickDirectionY

asteroidsGameOver:
	// Play the end animation
	call	asteroidsEndAnimation
	jmp		asteroidsGame

	ret
/* asteroidsGame end */


/**
 * initializeAsteroidsArrays
 */
initializeAsteroidArray:
	
		.DEF	rZero = r18

	// Set the asteroid count to 0
	ldi		YL, LOW(asteroidCount)
	ldi		YH, HIGH(asteroidCount)
	ldi		rZero,	0
	st		Y, rZero

		.UNDEF	rZero

	ret
/* initializeAsteroidsArrays end */


/**
 * initializeAsteroidsArrays
 */
initializeBulletArray:

		.DEF	rZero = r18

	// Set the bullet count to 0
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	ldi		rZero,	0
	st		Y, rZero
		.UNDEF	rZero

	ret
/* initializeAsteroidsArrays end */



/**
 * Initialize the ship with its default values
 */
initializeShip:
		.DEF	rPositionX		= r18
		.DEF	rPositionY		= r19
		.DEF	rDirectionX		= r20
		.DEF	rDirectionY		= r21
	
	// Load a pointer to the ship
	ldi		YL, LOW(ship)
	ldi		YH, HIGH(ship)
	
	// Set the default values for the ship
	ldi		rPositionX, 3
	ldi		rPositionY, 4
	ldi		rDirectionX, 1
	ldi		rDirectionY, -1

	// Store the data
	std		Y + oShipPositionX, rPositionX
	std		Y + oShipPositionY, rPositionY
	std		Y + oShipDirectionX, rDirectionX
	std		Y + oShipDirectionY, rDirectionY

		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY

	ret
/* initializeShip end */




/**
 * Moves the ship in the direction it's pointing
 */
moveShip:
		.DEF	rPositionX		= r16
		.DEF	rPositionY		= r17
		.DEF	rDirectionX		= r18
		.DEF	rDirectionY		= r19

	// Save the registers
	push	rPositionX
	push	rPositionY

	// Load a pointer to the ship instance
	ldi		YL, LOW(ship)
	ldi		YH, HIGH(ship)

	// Load the data from the ship
	ldd		rPositionX, Y + oShipPositionX
	ldd		rPositionY, Y + oShipPositionY
	ldd		rDirectionX, Y + oShipDirectionX
	ldd		rDirectionY, Y + oShipDirectionY

	// Move the ship in its current direction
	add		rPositionX, rDirectionX
	add		rPositionY, rDirectionY

	// Wrap the position
	andi	rPositionX, 0b00000111
	andi	rPositionY, 0b00000111

	// Store the updated position
	std		Y + oShipPositionX, rPositionX
	std		Y + oShipPositionY, rPositionY

	// Restore the registers
	pop		rPositionY
	pop		rPositionX

		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
	ret
/* moveShip end */



/**
 * Draw the ship on the screen
 */
drawship:
		.DEF	rPositionX		= r2
		.DEF	rPositionY		= r3
		.DEF	rDirectionX		= r4
		.DEF	rDirectionY		= r5
		.DEF	rTailPositionX	= r18
		.DEF	rTailPositionY	= r19
		.DEF	rDirectionIndex	= r20

	// Save the registers
	push	rPositionX
	push	rPositionY
	push	rDirectionX
	push	rDirectionY

	// Load a pointer to the first asteroid instance
	ldi		YL, LOW(ship)
	ldi		YH, HIGH(ship)

	// Load the data about the ship
	ldd		rPositionX, Y + oShipPositionX
	ldd		rPositionY, Y + oShipPositionY
	ldd		rDirectionX, Y + oShipDirectionX
	ldd		rDirectionY, Y + oShipDirectionY

	// Draw the ship
	setPixelr	rPositionX, rPositionY

	// Get the index of the ship direction
	mov		rArgument0L, rDirectionX
	mov		rArgument1L, rDirectionY
	call	direction8ToIndex
	mov		rDirectionIndex, rReturnL

	// Rotate the index for first tail wing
	addi	rDirectionIndex, 3
	andi	rDirectionIndex, 0b00000111			// Wrap index

	// Save the index
	push	rDirectionIndex

	// Get the new offset
	mov		rArgument0L, rDirectionIndex
	call	indexToDirection8
	mov		rDirectionX, rReturnL				// Direction now represents the tail direction offset
	mov		rDirectionY, rReturnH

	// Apply the offset and draw
	mov		rTailPositionX, rPositionX			// Get the ship position
	mov		rTailPositionY, rPositionY
	add		rTailPositionX, rDirectionX			// Apply the offset for the first tail wing
	add		rTailPositionY, rDirectionY
	andi	rTailPositionX, 0b00000111			// Wrap position
	andi	rTailPositionY, 0b00000111			

	// Draw the first tail wing
	setPixelr	rTailPositionX, rTailPositionY

	// Restore the index
	pop		rDirectionIndex

	// Rotate the index for second tail wing
	addi	rDirectionIndex, 2
	andi	rDirectionIndex, 0b00000111			// Wrap index

	// Get the new offset
	mov		rArgument0L, rDirectionIndex
	call	indexToDirection8
	mov		rDirectionX, rReturnL
	mov		rDirectionY, rReturnH

	// Apply the offset and draw
	mov		rTailPositionX, rPositionX			// Get the ship position
	mov		rTailPositionY, rPositionY
	add		rTailPositionX, rDirectionX			// Apply the offset for the second tail wing
	add		rTailPositionY, rDirectionY
	andi	rTailPositionX, 0b00000111			// Wrap position
	andi	rTailPositionY, 0b00000111			

	// Draw the first tail wing
	setPixelr	rTailPositionX, rTailPositionY

	// Restore the registers
	pop		rDirectionY
	pop		rDirectionX
	pop		rPositionY
	pop		rPositionX

		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rTailPositionX
		.UNDEF	rTailPositionY
		.UNDEF	rDirectionIndex
	ret
/* drawShip end */


/**
 * Creates a new bullet in front of the ship, aimed in the direction the ship is pointing currently
 */
spawnBullet:
		.DEF	rDirectionX		= r4
		.DEF	rDirectionY		= r5
		.DEF	rPositionX		= r16
		.DEF	rPositionY		= r17

	// Save registers that are being used
	push	rDirectionX
	push	rDirectionY
	push	rPositionX
	push	rPositionY

		.DEF	rBulletCount	= r18

	// Load the asteroid count
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	ld		rBulletCount, Y

	// If the maximum amount of bullets has already been reached, crash
	cpi		rBulletCount, MAX_BULLETS
	brlo	generateBullet	
	crash

		.UNDEF	rBulletCount

generateBullet:
	
	// Load a pointer to the ship instance
	ldi		YL, LOW(ship)
	ldi		YH, HIGH(ship)
	
	// Load the data from the ship
	ldd		rPositionX, Y + oShipPositionX
	ldd		rPositionY, Y + oShipPositionY
	ldd		rDirectionX, Y + oShipDirectionX
	ldd		rDirectionY, Y + oShipDirectionY

	// Offset the bullet by one pixel in the ship's direction
	add		rPositionX, rDirectionX
	add		rPositionY, rDirectionY
	
	// Wrap the position
	andi	rPositionX, 0b00000111
	andi	rPositionY, 0b00000111

		.DEF	rBulletCount	= r18
		.DEF	rTempi			= r19

	// Load the bullet count
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	ld		rBulletCount, Y

	// Load a pointer to the first bullet instance
	ldi		YL, LOW(bulletArray)
	ldi		YH, HIGH(bulletArray)
	
	// Get the offset to the current bullet
	ldi		rTempi, BULLET_DATA_SIZE
	mul		rTempi, rBulletCount

	// Add it to the pointer
	ldi		rTempi, 0
	add		YL, rMulResL
	adc		YH, rTempi		// Add the carry if we get an overflow in the lower byte
	
	// Store the bullet data
	std		Y + oBulletPositionX, rPositionX
	std		Y + oBulletPositionY, rPositionY
	std		Y + oBulletDirectionX, rDirectionX
	std		Y + oBulletDirectionY, rDirectionY
	ldi		rTempi, 0
	std		Y + oBulletIsLit, rTempi
		
	// Increment the bullet count
	inc		rBulletCount
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	st		Y, rBulletCount

		.UNDEF	rTempi
		.UNDEF	rBulletCount

	// Restore registers that are used
	pop		rPositionY
	pop		rPositionX
	pop		rDirectionY
	pop		rDirectionX
		
		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY

	ret
/* spawnBullet end */



/**
 * Moves all the bullets in the direction they are pointing
 */
moveBullets:
		.DEF	rPositionX		= r16
		.DEF	rPositionY		= r17
		.DEF	rDirectionX		= r18
		.DEF	rDirectionY		= r19
		.DEF	rIterator		= r20
		.DEF	rBulletCount	= r21

	// Save the registers
	push	rPositionX
	push	rPositionY

	// Load the bullet count
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	ld		rbulletCount, Y

	// Load a pointer to the first bullet instance
	ldi		YL, LOW(bulletArray)
	ldi		YH, HIGH(bulletArray)

	// Set the iterator to the first index
	ldi		rIterator, 0

	// If there aren't any bullets, don't do anything
	cp		rIterator, rBulletCount
	brlo	moveBulletLoop
	jmp		moveBulletsEnd

moveBulletLoop:

	// Load the data from the asteroid
	ldd		rPositionX, Y + oBulletPositionX
	ldd		rPositionY, Y + oBulletPositionY
	ldd		rDirectionX, Y + oBulletDirectionX
	ldd		rDirectionY, Y + oBulletDirectionY

	// Move the bullet in its current direction (but don't wrap)
	add		rPositionX, rDirectionX
	add		rPositionY, rDirectionY

	// Store the updated position
	std		Y + oBulletPositionX, rPositionX
	std		Y + oBulletPositionY, rPositionY
	
	// Increment the bullet index
	inc		rIterator
	addiw	YL, YH, BULLET_DATA_SIZE			

	cp		rIterator, rBulletCount
	brlo	moveBulletLoop

moveBulletsEnd:

	// Restore the registers
	pop		rPositionY
	pop		rPositionX

		.UNDEF	rBulletCount
		.UNDEF	rIterator
		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY

	ret
/* moveBullets end */




/**
 * Display all the bullets that currently exist if they are currently lit
 */
drawBullets:
		.DEF	rBulletCount	= r16
		.DEF	rIterator		= r17
		.DEF	rPositionX		= r18
		.DEF	rPositionY		= r19
		.DEF	rIsLit			= r20

	// Save the registers
	push	rBulletCount
	push	rIterator

	// Load the bullet count
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	ld		rBulletCount, Y

	// Load a pointer to the first bullet instance
	ldi		YL, LOW(bulletArray)
	ldi		YH, HIGH(bulletArray)

	// Set the iterator to the first index
	ldi		rIterator, 0

	// If there are any bullets, draw them
	cp		rIterator, rBulletCount
	brlo	drawBulletLoop
	
	// Otherwise, skip drawing
	jmp		drawBulletsEnd

drawBulletLoop:

	// Load the position of the bullet
	ldd		rPositionX, Y + oBulletPositionX
	ldd		rPositionY, Y + oBulletPositionY
	ldd		rIsLit, Y + oBulletIsLit

	// If the bullet isn't lit, skip drawing it
	cpi		rIsLit, 0
	breq	skipDrawBullet

		.DEF	rTempi = r21

	//	TODO Remove this. It shouldn't be necessary. Positions shouldn't be out outside the screen!
	//andi	rPositionX, 0b00000111		// Wrap position
	//andi	rPositionY, 0b00000111

		.UNDEF	rTempi

	// Draw the bullet
	push	YL
	push	YH
	setPixelr	rPositionX, rPositionY
	pop		YH
	pop		YL

skipDrawBullet:

	// Increment the bullet index
	inc		rIterator
	addiw	YL, YH, BULLET_DATA_SIZE

	// If there are still bullets left to draw, run another iteration
	cp		rIterator, rBulletCount
	brlo	drawBulletLoop

drawBulletsEnd:

	// Restore the registers
	pop		rIterator
	pop		rBulletCount

		.UNDEF	rBulletCount
		.UNDEF	rIterator
		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rIsLit
	ret
/* drawBullets end */



/**
 * Toggles whether or not bullets are visible
 */
flashBullets:
		.DEF	rBulletCount	= r18
		.DEF	rIterator		= r19
		.DEF	rIsLit			= r20

	// Load the bullet count
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	ld		rBulletCount, Y

	// Load a pointer to the first bullet instance
	ldi		YL, LOW(bulletArray)
	ldi		YH, HIGH(bulletArray)

	// Set the iterator to the first index
	ldi		rIterator, 0

	cp		rIterator, rBulletCount
	brlo	flashBulletLoop
	
	// If there aren't any bullets, don't do anything
	jmp		flashBulletsEnd

flashBulletLoop:

	// Load the visibility of the bullet
	ldd		rIsLit, Y + oBulletIsLit
	
	// Toggle the visibility
	com		rIsLit
	andi	rIsLit, 0x1

	// Store the visibility back
	std		Y + oBulletIsLit, rIsLit

	// Increment the bullet index
	inc		rIterator
	addiw	YL, YH, BULLET_DATA_SIZE

	// If there are still bullets left to flash, run another iteration
	cp		rIterator, rBulletCount
	brlo	flashBulletLoop

flashBulletsEnd:

		.UNDEF	rBulletCount
		.UNDEF	rIterator
		.UNDEF	rIsLit
	ret
/* flashBullets end */




/**
 * Removes a bullet from the list of bullets currently in the game
 * @param rArgument0L - the index of the bullet to remove
 */
removeBullet:
		.DEF	rPositionX		= r2
		.DEF	rPositionY		= r3
		.DEF	rDirectionX		= r4
		.DEF	rDirectionY		= r5
		.DEF	rBulletCount	= r18
		.DEF	rTempi			= r19
		.DEF	rRemoveIndex	= r20

	// Save the registers that are used
	push	rPositionX
	push	rPositionY
	push	rDirectionX
	push	rDirectionY

	// Get the argument
	mov		rRemoveIndex, rArgument0L

	// Load the bullet count
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	ld		rBulletCount, Y

	// If the removed index is less than 0, crash
	cpi		rRemoveIndex, 0
	brlt	invalidBulletIndex	
	
	// If the removed index is higher than the highest index (bulletCount - 1), crash
	cp		rRemoveIndex, rBulletCount
	brge	invalidBulletIndex

	jmp		doRemoveBullet

invalidBulletIndex:
	terminateErrori	drawTemplarMatrix

doRemoveBullet:

	// Load a pointer to the first bullet instance
	ldi		YL, LOW(bulletArray)
	ldi		YH, HIGH(bulletArray)
	
	// Get the offset to the last bullet
	ldi		rTempi, BULLET_DATA_SIZE
	mul		rTempi, rBulletCount
	sub		rMulResL, rTempi	// Go one step back, since the index = count - 1

	// Add it to the pointer
	ldi		rTempi, 0
	add		YL, rMulResL
	adc		YH, rTempi		// Add the carry if we get an overflow in the lower byte
	
	// Get the data from the last bullet instance
	ldd		rPositionX, Y + oBulletPositionX
	ldd		rPositionY, Y + oBulletPositionY
	ldd		rDirectionX, Y + oBulletDirectionX
	ldd		rDirectionY, Y + oBulletDirectionY
	
	// Load a pointer to the first bullet instance
	ldi		YL, LOW(bulletArray)
	ldi		YH, HIGH(bulletArray)
	
	// Get the offset to the removed bullet
	ldi		rTempi, BULLET_DATA_SIZE
	mul		rTempi, rRemoveIndex

	// Add it to the pointer
	ldi		rTempi, 0
	add		YL, rMulResL
	adc		YH, rTempi		// Add the carry if we get an overflow in the lower byte

	// Move the data from the last index to the removed index
	std		Y + oBulletPositionX, rPositionX
	std		Y + oBulletPositionY, rPositionY
	std		Y + oBulletDirectionX, rDirectionX
	std		Y + oBulletDirectionY, rDirectionY

	// Decrement the bullet count
	dec		rBulletCount
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	st		Y, rBulletCount

	// Restore registers that are used
	pop		rDirectionY
	pop		rDirectionX
	pop		rPositionY
	pop		rPositionX

		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
		.UNDEF	rBulletCount
		.UNDEF	rTempi	
		.UNDEF	rRemoveIndex

	ret
/* removeBullet end */



/**
 * Removes all bullets that have ended up outside the screen
 */
removeDeadBullets:
		.DEF	rIterator		= r16
		.DEF	rBulletCount	= r17
		.DEF	rPositionX		= r18
		.DEF	rPositionY		= r19
		.DEF	rTempi			= r20

	// Save the registers that are used
	push	rIterator
	push	rBulletCount

	// Load the bullet count
	ldi		YL, LOW(bulletCount)
	ldi		YH, HIGH(bulletCount)
	ld		rBulletCount, Y

	// Load a pointer to the first bullet instance
	ldi		YL, LOW(bulletArray)
	ldi		YH, HIGH(bulletArray)
	
	// Get the offset to the last bullet
	ldi		rTempi, BULLET_DATA_SIZE
	mul		rTempi, rBulletCount
	sub		rMulResL, rTempi	// Go one step back, since the index = count - 1

	// Add it to the pointer
	ldi		rTempi, 0
	add		YL, rMulResL
	adc		YH, rTempi		// Add the carry if we get an overflow in the lower byte

	// Set the iterator to the last index
	mov		rIterator, rBulletCount
	dec		rIterator

	// If there aren't any bullets, don't do anything
	cpi		rBulletCount, 1
	brge	removeDeadBulletLoop
	jmp		removeDeadBulletEnd

removeDeadBulletLoop:

	// Load the position from the bullet
	ldd		rPositionX, Y + oBulletPositionX
	ldd		rPositionY, Y + oBulletPositionY

	// Remove the position bits. If there has been an overflow, the result is not zero
	andi	rPositionX, 0b11111000
	andi	rPositionY, 0b11111000

	// Check if the position is outside the screen by looking at the overflow
	cpi		rPositionX, 0
	brne	doRemoveDeadBullet
	cpi		rPositionY, 0
	brne	doRemoveDeadBullet
	jmp		skipRemoveBullet

doRemoveDeadBullet:
	// If the bullet is outside the screen, remove it
	push	YL
	push	YH
	mov		rArgument0L, rIterator
	call	removeBullet
	pop		YH
	pop		YL

skipRemoveBullet:

	// Decrement the bullet index and the pointer
	dec		rIterator
	subiw	YL, YH, BULLET_DATA_SIZE

	// If the iterator isn't yet below zero, run another iteration
	cpi		rIterator, 0
	brge	removeDeadBulletLoop

removeDeadBulletEnd:

	// Restore registers
	pop		rBulletCount
	pop		rIterator

		.UNDEF	rTempi
		.UNDEF	rBulletCount
		.UNDEF	rIterator
		.UNDEF	rPositionX
		.UNDEF	rPositionY

	ret
/* removeDeadBullets end */



/**
 * Creates a new asteroid, which is placed randomly along one of the edges of the
 * screen and given a random movement direction
 */
spawnAsteroid:
		.DEF	rDirectionX		= r4
		.DEF	rDirectionY		= r5
		.DEF	rPositionX		= r16
		.DEF	rPositionY		= r17

	// Save registers that are being used
	push	rDirectionX
	push	rDirectionY
	push	rPositionX
	push	rPositionY

		.DEF	rAsteroidCount	= r18

	// Load the asteroid count
	ldi		YL, LOW(asteroidCount)
	ldi		YH, HIGH(asteroidCount)
	ld		rAsteroidCount, Y

	// If the maximum amount of asteroids has already been reached, crash
	cpi		rAsteroidCount, MAX_ASTEROIDS
	brlo	generateAsteroid	
	crash

		.UNDEF	rAsteroidCount

generateAsteroid:
	// Generate 4 random bits for the direction (most random to the left)
	ldi		rArgument0L, JOYSTICK_X_AXIS
	call	generateRandom4BitValue
	
	//ldi		rReturnL, 0b0001		// TODO Remove manual override

		.DEF	rDirectionIndex = r18
		.DEF	rTempi			= r19
		.DEF	rAxis			= r20
		
	// Get the direction index (upper 3 bits of 4)
	mov		rDirectionIndex, rReturnL
	lsr		rDirectionIndex

	// Get the axis bit (Y = 0, X = 1)
	andi	rReturnL, 0x0001
	mov		rAxis, rReturnL

	// Rotate axis aligned directions by 90 degrees
	ldi		rTempi, 0						// Use rTempi as a boolean

	bst		rDirectionIndex, 0				// If the first bit equals 1 (odd index), the direction points diagonally, i.e. not axis aligned
	bld		rTempi, 0
	cpi		rTempi, 1
	breq	notAxisAligned

	bst		rDirectionIndex, 1				// The second bit tells the axis (Y = 0, X = 1)
	bld		rTempi, 0
	cp		rTempi, rAxis					// Compare the direction to the axis and if they are aligned rotate it
	brne	notAxisAligned

	// If the direction was aligned with the axis, add 2 to the direction index to rotate 90 degrees
	ldi		rTempi, 2
	add		rDirectionIndex, rTempi
	andi	rDirectionIndex, 0b00000111		// Wrap the index if it overflowed

notAxisAligned:

	// Get the direction as a vector
	mov		rArgument0L, rDirectionIndex
	push	rAxis							// Save the axis register before the call
	call	indexToDirection8
	pop		rAxis							// Restore the axis register
	mov		rDirectionX, rReturnL
	mov		rDirectionY, rReturnH

		.UNDEF	rDirectionIndex
		.UNDEF	rTempi

	// Generate 3 random bits for the position
	ldi		rArgument0L, JOYSTICK_Y_AXIS
	call	generateRandom3BitValue

	//ldi		rReturnL, 0b100		// TODO Remove manual override

		/* Create a register containing 0 */
		.DEF	rZero = r19
	ldi		rZero, 0

	// Place the position value on the right axis
	cpi		rAxis, 1
	breq	setHorizontalPosition

setVerticalPosition:
	// Set the Y coordinate
	mov		rPositionY, rReturnL			

	// If the asteroid is pointing right, spawn it to the left
	ldi		rPositionX, 0					
	cp		rDirectionX, rZero				
	brge	setHorizontalPosition

	// If the asteroid is pointing left, spawn it to the right
	ldi		rPositionX, 7					

	jmp		storeAsteroidData

setHorizontalPosition:
	// Set the X coordinate
	mov		rPositionX, rReturnL

	// If the asteroid is pointing down, spawn it at the top
	ldi		rPositionY, 0					
	cp		rDirectionY, rZero
	brge	storeAsteroidData

	// If the asteroid is pointing up, spawn it at the bottom
	ldi		rPositionY, 7					

		.UNDEF	rZero
		.UNDEF	rAxis
	
storeAsteroidData:
		.DEF	rAsteroidCount	= r18
		.DEF	rTempi			= r19

	// Load the asteroid count
	ldi		YL, LOW(asteroidCount)
	ldi		YH, HIGH(asteroidCount)
	ld		rAsteroidCount, Y

	// Load a pointer to the first asteroid instance
	ldi		YL, LOW(asteroidArray)
	ldi		YH, HIGH(asteroidArray)
	
	// Get the offset to the current asteroid
	ldi		rTempi, ASTEROID_DATA_SIZE
	mul		rTempi, rAsteroidCount

	// Add it to the pointer
	ldi		rTempi, 0
	add		YL, rMulResL
	adc		YH, rTempi		// Add the carry if we get an overflow in the lower byte
	
	// Store the data
	std		Y + oAsteroidPositionX, rPositionX
	std		Y + oAsteroidPositionY, rPositionY
	std		Y + oAsteroidDirectionX, rDirectionX
	std		Y + oAsteroidDirectionY, rDirectionY
		
	// Increment the asteroid count
	inc		rAsteroidCount
	ldi		YL, LOW(asteroidCount)
	ldi		YH, HIGH(asteroidCount)
	st		Y, rAsteroidCount

		.UNDEF	rTempi
		.UNDEF	rAsteroidCount

	// Restore registers that are used
	pop		rPositionY
	pop		rPositionX
	pop		rDirectionY
	pop		rDirectionX
		
		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY

	ret
/* spawnAsteroid end */



/**
 * Moves all the asteroids in the direction they are pointing
 */
moveAsteroids:
		.DEF	rPositionX		= r16
		.DEF	rPositionY		= r17
		.DEF	rDirectionX		= r18
		.DEF	rDirectionY		= r19
		.DEF	rIterator		= r20
		.DEF	rAsteroidCount	= r21

	// Save the registers
	push	rPositionX
	push	rPositionY

	// Load the asteroid count
	ldi		YL, LOW(asteroidCount)
	ldi		YH, HIGH(asteroidCount)
	ld		rAsteroidCount, Y

	// Load a pointer to the first asteroid instance
	ldi		YL, LOW(asteroidArray)
	ldi		YH, HIGH(asteroidArray)

	// Set the iterator to the first index
	ldi		rIterator, 0

	// If there aren't any asteroids, don't do anything
	cp		rIterator, rAsteroidCount
	brlo	moveAsteroidLoop
	jmp		moveAsteroidsEnd

moveAsteroidLoop:

	// Load the data from the asteroid
	ldd		rPositionX, Y + oAsteroidPositionX
	ldd		rPositionY, Y + oAsteroidPositionY
	ldd		rDirectionX, Y + oAsteroidDirectionX
	ldd		rDirectionY, Y + oAsteroidDirectionY

	// Move the asteroid in its current direction
	add		rPositionX, rDirectionX
	add		rPositionY, rDirectionY

	// Wrap the position
	andi	rPositionX, 0b00000111
	andi	rPositionY, 0b00000111

	// Store the updated position
	std		Y + oAsteroidPositionX, rPositionX
	std		Y + oAsteroidPositionY, rPositionY
	
	// Increment the asteroid index
	inc		rIterator
	addiw	YL, YH, ASTEROID_DATA_SIZE			

	cp		rIterator, rAsteroidCount
	brlo	moveAsteroidLoop

moveAsteroidsEnd:

	// Restore the registers
	pop		rPositionY
	pop		rPositionX

		.UNDEF	rAsteroidCount
		.UNDEF	rIterator
		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
	ret
/* moveAsteroid end */



/**
 * Display all the asteroids that currently exist
 */
drawAsteroids:
		.DEF	rPositionX		= r19
		.DEF	rPositionY		= r18
		.DEF	rAsteroidCount	= r4
		.DEF	rIterator		= r16

	// Save the registers
	push	rAsteroidCount
	push	rIterator

	// Load the asteroid count
	ldi		YL, LOW(asteroidCount)
	ldi		YH, HIGH(asteroidCount)
	ld		rAsteroidCount, Y

	// Load a pointer to the first asteroid instance
	ldi		YL, LOW(asteroidArray)
	ldi		YH, HIGH(asteroidArray)

	// Set the iterator to the first index
	ldi		rIterator, 0

	cp		rIterator, rAsteroidCount
	brlo	drawAsteroidLoop
	
	// If there aren't any asteroids, don't do anything
	jmp		drawAsteroidsEnd

drawAsteroidLoop:

	// Load the position of the asteroid
	ldd		rPositionX, Y + oAsteroidPositionX
	ldd		rPositionY, Y + oAsteroidPositionY

		.DEF	rTempi = r20

	//	TODO Remove this. It shouldn't be necessary. Positions shouldn't be out outside the screen!
	//andi	rPositionX, 0b00000111
	//andi	rPositionY, 0b00000111

		.UNDEF	rTempi

	// Draw the asteroid
	push	YL
	push	YH
	setPixelr	rPositionX, rPositionY
	pop		YH
	pop		YL

	// Increment the asteroid index
	inc		rIterator
	addiw	YL, YH, ASTEROID_DATA_SIZE

	cp		rIterator, rAsteroidCount
	brlo	drawAsteroidLoop

drawAsteroidsEnd:

	// Restore the registers
	pop		rIterator
	pop		rAsteroidCount

		.UNDEF	rAsteroidCount
		.UNDEF	rIterator
		.UNDEF	rPositionX
		.UNDEF	rPositionY
	ret
/* drawAsteroids end */




/**
 * Removes an asteroid from the list of asteroids currently in the game
 * @param rArgument0L - the index of the asteroid to remove
 */
removeAsteroid:
		.DEF	rPositionX		= r2
		.DEF	rPositionY		= r3
		.DEF	rDirectionX		= r4
		.DEF	rDirectionY		= r5
		.DEF	rAsteroidCount	= r18
		.DEF	rTempi			= r19
		.DEF	rRemoveIndex	= r20

	// Save the registers that are used
	push	rPositionX
	push	rPositionY
	push	rDirectionX
	push	rDirectionY

	// Get the argument
	mov		rRemoveIndex, rArgument0L

	// Load the asteroid count
	ldi		YL, LOW(asteroidCount)
	ldi		YH, HIGH(asteroidCount)
	ld		rAsteroidCount, Y

	// If the removed index is less than 0, crash
	cpi		rRemoveIndex, 0
	brlt	invalidAsteroidIndex	
	
	// If the removed index is higher than the highest index (asteroidCount - 1), crash
	cp		rRemoveIndex, rAsteroidCount
	brge	invalidAsteroidIndex

	jmp		doRemoveAsteroid

invalidAsteroidIndex:
	terminateErrori	drawTemplarMatrix

doRemoveAsteroid:

	// Load a pointer to the first asteroid instance
	ldi		YL, LOW(asteroidArray)
	ldi		YH, HIGH(asteroidArray)
	
	// Get the offset to the last asteroid
	ldi		rTempi, ASTEROID_DATA_SIZE
	mul		rTempi, rAsteroidCount
	sub		rMulResL, rTempi	// Go one step back, since the index = count - 1

	// Add it to the pointer
	ldi		rTempi, 0
	add		YL, rMulResL
	adc		YH, rTempi		// Add the carry if we get an overflow in the lower byte
	
	// Get the data from the last asteroid instance
	ldd		rPositionX, Y + oAsteroidPositionX
	ldd		rPositionY, Y + oAsteroidPositionY
	ldd		rDirectionX, Y + oAsteroidDirectionX
	ldd		rDirectionY, Y + oAsteroidDirectionY
	
	// Load a pointer to the first asteroid instance
	ldi		YL, LOW(asteroidArray)
	ldi		YH, HIGH(asteroidArray)
	
	// Get the offset to the removed asteroid
	ldi		rTempi, ASTEROID_DATA_SIZE
	mul		rTempi, rRemoveIndex

	// Add it to the pointer
	ldi		rTempi, 0
	add		YL, rMulResL
	adc		YH, rTempi		// Add the carry if we get an overflow in the lower byte

	// Move the data from the last index to the removed index
	std		Y + oAsteroidPositionX, rPositionX
	std		Y + oAsteroidPositionY, rPositionY
	std		Y + oAsteroidDirectionX, rDirectionX
	std		Y + oAsteroidDirectionY, rDirectionY

	// Decrement the asteroid count
	dec		rAsteroidCount
	ldi		YL, LOW(asteroidCount)
	ldi		YH, HIGH(asteroidCount)
	st		Y, rAsteroidCount

	// Restore registers that are used
	pop		rDirectionY
	pop		rDirectionX
	pop		rPositionY
	pop		rPositionX

		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
		.UNDEF	rAsteroidCount
		.UNDEF	rTempi	
		.UNDEF	rRemoveIndex

	ret
/* removeAsteroid end */



/**
 * Determine if the ship has collided with any asteroid
 * @return rReturnL - Whether or not the ship has collided with an asteroid
 */
checkShipCollision:

		.DEF	rPositionX = r18
		.DEF	rPositionY = r19

	// Load a pointer to the ship instance
	ldi		YH, HIGH(ship)
	ldi		YL, LOW(ship)
	ldd		rPositionX, Y + oShipPositionX
	ldd		rPositionY, Y + oShipPositionY

	// Compare the ship position with all the asteroids
	mov		rArgument0L, rPositionX
	mov		rArgument1L, rPositionY
	call	collidesWithAnyAsteroid

		.UNDEF	rPositionX
		.UNDEF	rPositionY

	ret
/* checkShipCollision end */



/**
 * Goes through the list of bullets and resolves any collisions with asteroids that occur.
 */
resolveBulletCollisions:
		
		.DEF	rBulletIndex	= r16

	push	rBulletIndex				// Save register

	// Start the iterator at the last index
	ldi		YH, HIGH(bulletCount)
	ldi		YL, LOW(bulletCount)
	ld		rBulletIndex, Y
	dec		rBulletIndex

	// If there aren't any bullets, do nothing
	cpi		rBulletIndex, 0
	brlt	resolveBulletsEnd

		.DEF	rTempi = r18
	
	// Get a pointer to the last instance
	ldi		YH, HIGH(bulletArray)		// Load a pointer to the bullet array
	ldi		YL, LOW(bulletArray)

	ldi		rTempi, BULLET_DATA_SIZE	// Move the pointer to the last instance
	mul		rBulletIndex, rTempi
	add		YL, rMulResL 
	adc		YH, rMulResH
		.UNDEF	rTempi

bulletCollisionLoop:
		
		.DEF	rPositionX				= r18
		.DEF	rPositionY				= r19

	// Load the bullet position
	ldd		rPositionX, Y + oBulletPositionX
	ldd		rPositionY, Y + oBulletPositionY
	
	push	YL								// Save the pointer registers during subroutine calls
	push	YH

	// Check if the bullet collides with any asteroid
	mov		rArgument0L, rPositionX	
	mov		rArgument1L, rPositionY
	call	collidesWithAnyAsteroid	
 
	 // If the bullet collided with an asteroid, remove it
	cpi		rReturnL, 1						// rReturnL = Whether there was a collision
	brne	skipRemoveCollidedBullet

	// Remove the bullet and the asteroid
	mov		rArgument0L, rReturnH			// rReturnH = The index of the asteroid that was collided with
	call	removeAsteroid					// Remove the asteroid
	mov		rArgument0L, rBulletIndex		
	call	removeBullet					// Remove the bullet

		.UNDEF	rPositionX
		.UNDEF	rPositionY

 skipRemoveCollidedBullet:

	pop		YH								// Restore the pointer registers after subroutine calls
	pop		YL

	// Move the index and pointer to the next bullet
	dec		rBulletIndex
	subiw	YL, YH, BULLET_DATA_SIZE

	// If there are any bullets left, run another iteration
	cpi		rBulletIndex, 0
	brge	bulletCollisionLoop

resolveBulletsEnd:

	pop		rBulletIndex					// Restore register

		.UNDEF	rBulletIndex
	
	ret
/* resolveBulletCollisions end */



/**
 * Compares a certain position with all the asteroids and determines if there has been a collision
 * @param rArgument0L - X coordinate of the position being tested
 * @param rArgument1L - Y coordinate of the position being tested
 * @return rReturnL - Whether or not a collision has occured
 * @return rReturnH - The index of the asteroid being collided with
 */
collidesWithAnyAsteroid:
		
		.DEF	rPositionX = r2
		.DEF	rPositionY = r3
		.DEF	rAsteroidPositionX = r18
		.DEF	rAsteroidPositionY = r19
		.DEF	rAsteroidIndex = r16
		.DEF	rHasCollided = r20

	// Save registers
	push	rPositionX
	push	rPositionY
	push	rAsteroidIndex

	// Copy the arguments
	mov		rPositionX, rArgument0L
	mov		rPositionY, rArgument1L

	// Start the iterator at the last index
	ldi		YH, HIGH(asteroidCount)
	ldi		YL, LOW(asteroidCount)
	ld		rAsteroidIndex, Y
	dec		rAsteroidIndex

	// Set a default return value to false
	ldi		rHasCollided, 0

	// If there aren't any asteroids, return false
	cpi		rAsteroidIndex, 0
	brlt	asteroidCollisionReturn

	// Load a pointer to the asteorid array
	ldi		YH, HIGH(asteroidArray)
	ldi		YL, LOW(asteroidArray)

		.DEF	rTempi = r21
	// Move the pointer to the last instance
	ldi		rTempi, ASTEROID_DATA_SIZE
	mul		rAsteroidIndex, rTempi
	add		YL, rMulResL 
	adc		YH, rMulResH
		.UNDEF	rTempi

asteroidCollisionLoop:

	// Load the asteroid position
	ldd		rAsteroidPositionX, Y + oAsteroidPositionX
	ldd		rAsteroidPositionY, Y + oAsteroidPositionY

	// Compare the tested position with one of the asteroids 
	mov		rArgument0L, rPositionX
	mov		rArgument0H, rPositionY
	mov		rArgument1L, rAsteroidPositionX
	mov		rArgument1H, rAsteroidPositionY
	call	checkCollision					// (the Y registers are not saved for optimization purposes as checkCollision doesn't use them)
	mov		rHasCollided, rReturnL

	// If we collided with an asteroid, return true
	cpi		rHasCollided, 1
	breq	asteroidCollisionReturn

	// Move the index and pointer to the next asteroid
	dec		rAsteroidIndex
	subiw	YL, YH, ASTEROID_DATA_SIZE

	// If there are any asteroids left, run another iteration
	cpi		rAsteroidIndex, 0
	brge	asteroidCollisionLoop

asteroidCollisionReturn:
	
	// Return whether there has been a collision and the index of the collision (-1 or an undefined negative number otherwise)
	mov		rReturnL, rHasCollided
	mov		rReturnH, rAsteroidIndex

	// Restore registers
	pop		rAsteroidIndex
	pop		rPositionY
	pop		rPositionX

		.UNDEF	rPositionX
		.UNDEF	rPositionY
		.UNDEF	rAsteroidPositionX
		.UNDEF	rAsteroidPositionY
		.UNDEF	rAsteroidIndex
		.UNDEF	rHasCollided

	ret
/* collidesWithAnyAsteroid end */





/**
 * Draw a blinking ship at the start of the game
 */
asteroidsStartAnimation:
		/** The counter that keeps track of how many blinks we have left */
		.DEF	rRemainingBlinks = r16
		.DEF	rTemp			 = r18
	push	rRemainingBlinks

	initializeTimeri boardFlashTimer, ASTEROIDS_BOARD_FLASH_TIME

	call	drawShipMatrix
	ldi		rRemainingBlinks, ASTEROIDS_BOARD_BLINKS

asteroidsStartRender:
	call	render

	// Wait for an update and then blink
	checkTimeri boardFlashTimer			// returns boolean whether the timer has reached it's target time and reset	
	cpi		rReturnL, 1
	breq	asteroidsStartBlink			// If an update was recieved, blink
	jmp		asteroidsStartRender		// If an update didn't occur, render and wait some more

	// Blink, decrement the remaining blinks and wait for the next blink
asteroidsStartBlink:
	mov		rTemp, rRemainingBlinks	
	andi	rTemp, 0x01								// Mask out whether the remaining blinks are an odd or even number
	cpi		rTemp, (ASTEROIDS_BOARD_BLINKS & 0x01)
	brne	asteroidsStartDrawShip

	call	clearMatrix
	jmp		asteroidsStartBlinkEnd

asteroidsStartDrawShip:
	call	drawShipMatrix

asteroidsStartBlinkEnd:
	dec		rRemainingBlinks
	cpi		rRemainingBlinks, 0
	brne	asteroidsStartRender

	pop		rRemainingBlinks
		.UNDEF	rRemainingBlinks 
		.UNDEF	rTemp

	ret
/* asteroidsStartAnimation end */




/**
 * Renders an animation of the ship hitting an asteroid and exploding after the game 
 * has been lost.
 */
asteroidsEndAnimation:
	
		.DEF	rCurrentFrame = r16	
	
	// Save the register that is used
	push	rCurrentFrame

	// Set the up a frame timer
	initializeTimeri renderTimer, ASTEROIDS_ANIMATION_FRAME_TIME

	// Start the frame 
	ldi		rCurrentFrame, 0

asteroidsEndAnimationLoop:
	
	// Draw the current frame of the animation
	mov		rArgument0L, rCurrentFrame
	call	drawAsteroidsExplosionAnimationFrame

	// Render the frame
	call	render

	// Check if it's time to spawn a new asteroid
	checkTimeri renderTimer
	cpi		rReturnL, 1
	brne	asteroidsEndAnimationLoop

	// Increment the frame index
	inc		rCurrentFrame

	// Run the loop for 13 frames
	cpi		rCurrentFrame, 13
	brlo	asteroidsEndAnimationLoop

	// Restore the register
	pop		rCurrentFrame

		.UNDEF	rCurrentFrame 
	
	ret
/* asteroidsEndAnimation end */


/**
 * Draws a frame from the explosion animation in the game asteroids. 
 * @param rArgument0L - The index of the frame to be drawn
 */
drawAsteroidsExplosionAnimationFrame:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)


	// Select the correct frame to draw. Branching is unfortunately out of range, so a jump is required
	cpi		rArgument0L, 0
	brne	skipAsteroidsExplosionFrame0
	jmp		asteroidsExplosionFrame0
skipAsteroidsExplosionFrame0:

	cpi		rArgument0L, 1
	brne	skipAsteroidsExplosionFrame1
	jmp		asteroidsExplosionFrame1
skipAsteroidsExplosionFrame1:

	cpi		rArgument0L, 2
	brne	skipAsteroidsExplosionFrame2
	jmp		asteroidsExplosionFrame2
skipAsteroidsExplosionFrame2:

	cpi		rArgument0L, 3
	brne	skipAsteroidsExplosionFrame3
	jmp		asteroidsExplosionFrame3
skipAsteroidsExplosionFrame3:

	cpi		rArgument0L, 4
	brne	skipAsteroidsExplosionFrame4
	jmp		asteroidsExplosionFrame4
skipAsteroidsExplosionFrame4:

	cpi		rArgument0L, 5
	brne	skipAsteroidsExplosionFrame5
	jmp		asteroidsExplosionFrame5
skipAsteroidsExplosionFrame5:

	cpi		rArgument0L, 6
	brne	skipAsteroidsExplosionFrame6
	jmp		asteroidsExplosionFrame6
skipAsteroidsExplosionFrame6:

	cpi		rArgument0L, 7
	brne	skipAsteroidsExplosionFrame7
	jmp		asteroidsExplosionFrame7
skipAsteroidsExplosionFrame7:

	cpi		rArgument0L, 8
	brne	skipAsteroidsExplosionFrame8
	jmp		asteroidsExplosionFrame8
skipAsteroidsExplosionFrame8:

	cpi		rArgument0L, 9
	brne	skipAsteroidsExplosionFrame9
	jmp		asteroidsExplosionFrame9
skipAsteroidsExplosionFrame9:

	cpi		rArgument0L, 10
	brne	skipAsteroidsExplosionFrame10
	jmp		asteroidsExplosionFrame10
skipAsteroidsExplosionFrame10:

	cpi		rArgument0L, 11
	brne	skipAsteroidsExplosionFrame11
	jmp		asteroidsExplosionFrame11
skipAsteroidsExplosionFrame11:

	cpi		rArgument0L, 12
	brne	skipAsteroidsExplosionFrame12
	jmp		asteroidsExplosionFrame12
skipAsteroidsExplosionFrame12:


	// The list of frames to draw

asteroidsExplosionFrame0:
	ldi		rRowBits, 0b00000011
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame1:
	ldi		rRowBits, 0b00000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000111
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000011
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b01000000
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame2:
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000100
	st		Y+, rRowBits
	ldi		rRowBits, 0b00001111
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00110000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame3:
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b10101000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00111010
	st		Y+, rRowBits
	ldi		rRowBits, 0b00011110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00100100
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00001001
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame4:
	ldi		rRowBits, 0b10000100
	st		Y+, rRowBits
	ldi		rRowBits, 0b00101001
	st		Y+, rRowBits
	ldi		rRowBits, 0b01011101
	st		Y+, rRowBits
	ldi		rRowBits, 0b00111101
	st		Y+, rRowBits
	ldi		rRowBits, 0b01011110
	st		Y+, rRowBits
	ldi		rRowBits, 0b01101010
	st		Y+, rRowBits
	ldi		rRowBits, 0b10010101
	st		Y+, rRowBits
	ldi		rRowBits, 0b00100100
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame5:
	ldi		rRowBits, 0b11110100
	st		Y+, rRowBits
	ldi		rRowBits, 0b01011101
	st		Y+, rRowBits
	ldi		rRowBits, 0b01111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111101
	st		Y+, rRowBits
	ldi		rRowBits, 0b01111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111110
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111011
	st		Y+, rRowBits
	ldi		rRowBits, 0b01011101
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame6:
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame7:
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11100111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11101111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame8:
	ldi		rRowBits, 0b0111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b01111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11110111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000010
	st		Y+, rRowBits
	ldi		rRowBits, 0b11100111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11011111
	st		Y+, rRowBits
	ldi		rRowBits, 0b01110111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11110101
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame9:
	ldi		rRowBits, 0b00111010
	st		Y+, rRowBits
	ldi		rRowBits, 0b01110101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10010111
	st		Y+, rRowBits
	ldi		rRowBits, 0b01000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11100111
	st		Y+, rRowBits
	ldi		rRowBits, 0b00110011
	st		Y+, rRowBits
	ldi		rRowBits, 0b01100100
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame10:
	ldi		rRowBits, 0b10000100
	st		Y+, rRowBits
	ldi		rRowBits, 0b01001001
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00100010
	st		Y+, rRowBits
	ldi		rRowBits, 0b01000110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00010000
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame11:
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000010
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits

	ret									// Return

asteroidsExplosionFrame12:
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00000000
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawAsteroidsExplosionAnimationFrame end */	



/******************************************************************************************
 * End Asteroids Game																	  
 *****************************************************************************************/



/******************************************************************************************
 * Program: FillBoard
 * Fill the board and show it
 *****************************************************************************************/
fillBoard:
	call	setMatrix

fillBoardLoop:
	// Simply show the filled board 'til the end of time
	call	render
	jmp		fillBoardLoop

	ret
/* fillBoard end */

/******************************************************************************************
 * End Fill Board																	  
 *****************************************************************************************/



/******************************************************************************************
 * Program: Render Joystick
 * renders the positon of the joystick
 *****************************************************************************************/
renderJoystick:

renderJoystickLoop:
	call	clearMatrix
		
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
	ldi		rArgument0L, JOYSTICK_X_AXIS
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

	// reverse order rColumn (7-0 -> 0-7)
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
	setPixelr rColumn, rRow

		.UNDEF	rJoystickX
		.UNDEF	rJoystickY
		.UNDEF	rRow
		.UNDEF	rColumn
		.UNDEF	rTemp
		.UNDEF	rTempI

	// Show the joystick position
	call	render
	jmp		renderJoystickLoop

	ret
/* renderJoystick end */

/******************************************************************************************
 * End Render Joystick															  
 *****************************************************************************************/



 /******************************************************************************************
 * Program: Error Test
 * Renders error images
 *****************************************************************************************/
errorTest:
	call	clearMatrix

	// Timer initializiton
	ldi		rArgument0L, TIMER2_PRE_1024
	call	initializeHardwareTimer2

	initializeTimeri updateTimer, ERROR_DISPLAY_TIME

		.DEF	rIndex		= r16
		.DEF	rImageCount	= r17

	ldi		rImageCount, 6
	ldi		rIndex, 0
	call	drawCrossMatrix
errorLoop:
	// If timer update, swap image
	checkTimeri updateTimer
	cpi		rReturnL, 1
	brne	errorLoopEnd
	
	// Increment the index and wrap if past the last index
	inc		rIndex
	cp		rIndex, rImageCount
	brne	skipWrapIndex
	ldi		rIndex, 0
skipWrapIndex:
	
	// Draw the correct image
	call	clearMatrix

	cpi		rIndex, 0
	breq	drawErrorImage0
	cpi		rIndex, 1
	breq	drawErrorImage1
	cpi		rIndex, 2
	breq	drawErrorImage2
	cpi		rIndex, 3
	breq	drawErrorImage3
	cpi		rIndex, 4
	breq	drawErrorImage4
	cpi		rIndex, 5
	breq	drawErrorImage5

drawErrorImage0:
	call	drawCrossMatrix
	jmp		errorLoopEnd
drawErrorImage1:
	call	drawSkullMatrix
	jmp		errorLoopEnd
drawErrorImage2:
	call	drawOutOfBoundsWriteMatrix
	jmp		errorLoopEnd
drawErrorImage3:
	call	drawOutOfBoundsReadMatrix
	jmp		errorLoopEnd
drawErrorImage4:
	call	drawTemplarMatrix
	jmp		errorLoopEnd
drawErrorImage5:
	call	drawSmileyMatrix
	jmp		errorLoopEnd

errorLoopEnd:

	call	render
	jmp		errorLoop
	
		.UNDEF	rIndex
		.UNDEF	rImageCount

	ret
/* errorTest end */

/******************************************************************************************
 * End Error Test													  
 *****************************************************************************************/



/******************************************************************************************
 * Program: Exit
 * exit it all
 *****************************************************************************************/
exit:

	ret
/* exit end */

/******************************************************************************************
 * End Exit												  
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
 * Draws the icon for the program 'Error Test', alternating between two different frames.
 * @param rArgument0L - Which of the two frames that is draw
 */
drawErrorTestIcon:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Go to the correct version of the icon and draw it
	cpi		rArgument0L, 0
	brne	errorIconAlt

	// Draw the first version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111101
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

errorIconAlt:
	// Draw the second version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100101
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawErrorTestIcon end */	



/**
 * Draws the icon for the program 'Exit', alternating between two different frames.
 * @param rArgument0L - Which of the two frames that is draw
 */
drawExitIcon:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Go to the correct version of the icon and draw it
	cpi		rArgument0L, 0
	brne	exitIconAlt

	// Draw the first version of the icon
	ldi		rRowBits, 0b00011000
	st		Y+, rRowBits
	ldi		rRowBits, 0b01011010
	st		Y+, rRowBits
	ldi		rRowBits, 0b11011011
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000011
	st		Y+, rRowBits
	ldi		rRowBits, 0b01100110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00111100
	st		Y+, rRowBits

	ret									// Return

exitIconAlt:
	// Draw the second version of the icon
	ldi		rRowBits, 0b00011000
	st		Y+, rRowBits
	ldi		rRowBits, 0b01011010
	st		Y+, rRowBits
	ldi		rRowBits, 0b11011011
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000011
	st		Y+, rRowBits
	ldi		rRowBits, 0b01100110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00111100
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawExitIcon end */	



/**
 * Draws the icon for the program 'Snake Game', alternating between two different frames.
 * @param rArgument0L - Which of the two frames that is draw
 */
drawSnakeIcon:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Go to the correct version of the icon and draw it
	cpi		rArgument0L, 0
	brne	snakeIconAlt

	// Draw the first version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

snakeIconAlt:
	// Draw the second version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10110101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10110001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawSnakeIcon end */	



/**
 * Draws the icon for the program 'Tetris', alternating between two different frames.
 * @param rArgument0L - Which of the two frames that is draw
 */
drawTetrisIcon:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Go to the correct version of the icon and draw it
	cpi		rArgument0L, 0
	brne	tetrisIconAlt

	// Draw the first version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10010001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10110001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10010001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000101
	st		Y+, rRowBits
	ldi		rRowBits, 0b11101111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

tetrisIconAlt:
	// Draw the second version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11010101
	st		Y+, rRowBits
	ldi		rRowBits, 0b11101111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawTetrisIcon end */	




/**
 * Draws the icon for the program 'Asteroids', alternating between two different frames.
 * @param rArgument0L - Which of the two frames that is draw
 */
drawAsteroidsIcon:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Go to the correct version of the icon and draw it
	cpi		rArgument0L, 0
	brne	asteroidsIconAlt

	// Draw the first version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10001001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10110011
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

asteroidsIconAlt:
	// Draw the second version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10110001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawAsteroidsIcon end */	



/**
 * Draws the icon for the program 'Timer', alternating between two different frames.
 * @param rArgument0L - Which of the two frames that is draw
 */
drawTimerIcon:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Go to the correct version of the icon and draw it
	cpi		rArgument0L, 0
	brne	timerIconAlt

	// Draw the first version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11010011
	st		Y+, rRowBits
	ldi		rRowBits, 0b11101111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11110111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000011
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

timerIconAlt:
	// Draw the second version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000011
	st		Y+, rRowBits
	ldi		rRowBits, 0b11100111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11100111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11010011
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111101
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawTimerIcon end */	



/**
 * Draws the icon for the program 'Random', alternating between two different frames.
 * @param rArgument0L - Which of the two frames that is draw
 */
drawRandomIcon:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Go to the correct version of the icon and draw it
	cpi		rArgument0L, 0
	brne	randomIconAlt

	// Draw the first version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10001001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10110101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11001011
	st		Y+, rRowBits
	ldi		rRowBits, 0b10010101
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

randomIconAlt:
	// Draw the second version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10010001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000011
	st		Y+, rRowBits
	ldi		rRowBits, 0b10001001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10100101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10001011
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawRandomIcon end */	




/**
 * Draws the icon for the program 'Render Joystick', alternating between two different frames.
 * @param rArgument0L - Which of the two frames that is draw
 */
drawJoystickIcon:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Go to the correct version of the icon and draw it
	cpi		rArgument0L, 0
	brne	joystickIconAlt

	// Draw the first version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

joystickIconAlt:
	// Draw the second version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10001101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10011001
	st		Y+, rRowBits
	ldi		rRowBits, 0b10111101
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawJoystickIcon end */	



/**
 * Draws the icon for the program 'Fill Board', alternating between two different frames.
 * @param rArgument0L - Which of the two frames that is draw
 */
drawFillBoardIcon:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Get a pointer to the matrix
	ldi		YH, HIGH(matrix)
	ldi		YL, LOW(matrix)

	// Go to the correct version of the icon and draw it
	cpi		rArgument0L, 0
	brne	fillBoardIconAlt

	// Draw the first version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits

	ret									// Return

fillBoardIconAlt:
	// Draw the second version of the icon
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits
	ldi		rRowBits, 0b10000001
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111111
	st		Y+, rRowBits

	ret									// Return

		.UNDEF	rRowBits
/* drawFillBoardIcon end */	


/**
 * Draws a frame of the ship to the screen, flickering every other frame.
 * @param rArgument0L - 
 */
drawShipMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Initialize the matrix with a smiley set
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rRowBits, 0b00010000
	st		Y+, rRowBits
	ldi		rRowBits, 0b00100000
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111000
	st		Y+, rRowBits
	ldi		rRowBits, 0b11111100
	st		Y+, rRowBits
	ldi		rRowBits, 0b00001101
	st		Y+, rRowBits
	ldi		rRowBits, 0b00001110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00001100
	st		Y+, rRowBits
	ldi		rRowBits, 0b00001100
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* drawShipMatrix end */	

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
/* drawSmileyMatrix end */	



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
/* drawTemplarMatrix end */	



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
 * Set the bits in the matrix with a cross
 */
drawCrossMatrix:
		/* Register used for the pixels in a row */
		.DEF	rRowBits	= r18

	// Initialize the matrix with a cross
	ldi		YH, HIGH(matrix)	// Set Y to matrix address
	ldi		YL, LOW(matrix)
	ldi		rRowBits, 0b11000011 
	st		Y+, rRowBits
	ldi		rRowBits, 0b11100111
	st		Y+, rRowBits
	ldi		rRowBits, 0b01111110
	st		Y+, rRowBits
	ldi		rRowBits, 0b00111100
	st		Y+, rRowBits
	ldi		rRowBits, 0b00111100
	st		Y+, rRowBits
	ldi		rRowBits, 0b01111110 
	st		Y+, rRowBits
	ldi		rRowBits, 0b11100111
	st		Y+, rRowBits
	ldi		rRowBits, 0b11000011
	st		Y+, rRowBits

		.UNDEF	rRowBits

	ret
/* drawCrossMatrix end */	



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
 * Reads and returns the current joystick direction, including the corners (8 directions + neutral)
 * @return rReturnL - Returns the joystick X direction (-1 is left, 0 is neutral, 1 is right)
 * @return rReturnH - Returns the joystick Y direction (-1 is up, 0 is neutral, 1 is down)
 */
 readJoystickDirection9:
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
	call	joystickValuesToDirection9

	pop		rJoystickY
	pop		rJoystickX

		.UNDEF	rJoystickY
		.UNDEF	rJoystickX

	ret
/* readJoystickDirection9 end */



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
 * Get the current direction based on the joystick position. Both axis aligned and diagonal
 * directions are valid. 
 * @param rArgument0L - The 8 bit X position of the joystick (0 - 255)
 * @param rArgument1L - The 8 bit Y position of the joystick (0 - 255)
 * @return rReturnL - Returns the joystick X direction (-1 is left, 0 is neutral, 1 is right)
 * @return rReturnH - Returns the joystick Y direction (-1 is up, 0 is neutral, 1 is down)
 */
joystickValuesToDirection9:
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

	// Compare all the directions based on the diagonal threshold (narrow)

	cpi		rJoystickY, 128 + (JOYSTICK_DIAGONAL_THRESHOLD - 1)
	brlo	diagonalCompareUpEnd
	ldi		rDirectionY, -1
diagonalCompareUpEnd:
	
	cpi		rJoystickY, 128 - (JOYSTICK_DIAGONAL_THRESHOLD - 1)
	brsh	diagonalCompareDownEnd
	ldi		rDirectionY, 1
diagonalCompareDownEnd:

	cpi		rJoystickX, 128 + (JOYSTICK_DIAGONAL_THRESHOLD - 1)
	brlo	diagonalCompareLeftEnd
	ldi		rDirectionX, -1
diagonalCompareLeftEnd:

	cpi		rJoystickX, 128 - (JOYSTICK_DIAGONAL_THRESHOLD - 1)
	brsh	diagonalCompareRightEnd
	ldi		rDirectionX, 1
diagonalCompareRightEnd:
	
	// If it's a straight or neutral value, compare it again with the straight threshold 
	cpi		rDirectionX, 0
	breq	compareStraightDirections
	cpi		rDirectionY, 0
	breq	compareStraightDirections

	// If it's a diagonal value, return it
	jmp		returnJoystickDirection9

compareStraightDirections:
	ldi		rDirectionY, 0
	ldi		rDirectionX, 0
	
	// Compare all the directions based on the normal threshold (wider)
	 
	cpi		rJoystickY, 128 + (JOYSTICK_THRESHOLD - 1)
	brlo	straightCompareUpEnd
	ldi		rDirectionY, -1
straightCompareUpEnd:

	cpi		rJoystickY, 128 - (JOYSTICK_THRESHOLD - 1)
	brsh	straightCompareDownEnd
	ldi		rDirectionY, 1
straightCompareDownEnd:

	cpi		rJoystickX, 128 + (JOYSTICK_THRESHOLD - 1)
	brlo	straightCompareLeftEnd
	ldi		rDirectionX, -1
straightCompareLeftEnd:

	cpi		rJoystickX, 128 - (JOYSTICK_THRESHOLD - 1)
	brsh	straightCompareRightEnd
	ldi		rDirectionX, 1
straightCompareRightEnd:

	// Return the directions
returnJoystickDirection9:
	mov		rReturnL, rDirectionX
	mov		rReturnH, rDirectionY

		.UNDEF	rJoystickX
		.UNDEF	rJoystickY
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY

	ret
/* joystickValuesToDirection9 */



/**
 * Returns a direction vector based on a 3 bit value. Starting with 0 straight up, the directions move
 * clockwise byt 45 degrees with each index.
 * @param rArgumen0L - 3 bit value used as direction index
 * @return rReturnL - Signed X direction (-1, 0, 1)
 * @return rReturnH - Signed Y direction (-1, 0, 1)
 */
indexToDirection8:
		.DEF	rDirectionIndex = r18
		.DEF	rDirectionX		= r19
		.DEF	rDirectionY		= r20

	// Load the direction index value and mask out the lowest 3 bits
	mov		rDirectionIndex, rArgument0L
	andi	rDirectionIndex, 0b00000111
	
	// Jump to the correct index
	cpi		rDirectionIndex, 0
	breq	directionIndex0
	cpi		rDirectionIndex, 1
	breq	directionIndex1
	cpi		rDirectionIndex, 2
	breq	directionIndex2
	cpi		rDirectionIndex, 3
	breq	directionIndex3
	cpi		rDirectionIndex, 4
	breq	directionIndex4
	cpi		rDirectionIndex, 5
	breq	directionIndex5
	cpi		rDirectionIndex, 6
	breq	directionIndex6
	cpi		rDirectionIndex, 7
	breq	directionIndex7

	// Set the direction
directionIndex0:
	ldi		rDirectionX, 0
	ldi		rDirectionY, -1
	jmp		indexToDirection8End
directionIndex1:
	ldi		rDirectionX, 1
	ldi		rDirectionY, -1
	jmp		indexToDirection8End
directionIndex2:
	ldi		rDirectionX, 1
	ldi		rDirectionY, 0
	jmp		indexToDirection8End
directionIndex3:
	ldi		rDirectionX, 1
	ldi		rDirectionY, 1
	jmp		indexToDirection8End
directionIndex4:
	ldi		rDirectionX, 0
	ldi		rDirectionY, 1
	jmp		indexToDirection8End
directionIndex5:
	ldi		rDirectionX, -1
	ldi		rDirectionY, 1
	jmp		indexToDirection8End
directionIndex6:
	ldi		rDirectionX, -1
	ldi		rDirectionY, 0
	jmp		indexToDirection8End
directionIndex7:
	ldi		rDirectionX, -1
	ldi		rDirectionY, -1
	jmp		indexToDirection8End

indexToDirection8End:
	
	// Set the return values
	mov		rReturnL, rDirectionX
	mov		rReturnH, rDirectionY
		
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
		.UNDEF	rDirectionIndex

	ret
/* indexToDirection8 end */



/**
 * Return the 3 bit index representing a specific direction offset. If the offset isn't a valid direction
 * an error is raised.
 * @param rArgumen0L - Signed X direction (-1, 0, 1)
 * @param rArgumen1L - Signed Y direction (-1, 0, 1)
 * @return rReturnL - 3 bit value used as direction index
 */
direction8ToIndex:
		.DEF	rDirectionIndex = r18
		.DEF	rDirectionX		= r19
		.DEF	rDirectionY		= r20

	// Copy the arguments
	mov		rDirectionX, rArgument0L
	mov		rDirectionY, rArgument1L
	
	// Jump to the correct index
	cpi		rDirectionX, -1
	breq	directionLeft
	cpi		rDirectionX, 0
	breq	directionMiddle
	cpi		rDirectionX, 1
	breq	directionRight

	// If it's neither -1, 0 or 1, it's an invalid offset
	jmp		invalidDirection8

directionLeft:
	cpi		rDirectionY, -1
	breq	returnDirectionIndex7
	cpi		rDirectionY, 0
	breq	returnDirectionIndex6
	cpi		rDirectionY, 1
	breq	returnDirectionIndex5

	// If it's neither -1, 0 or 1, it's an invalid offset
	jmp		invalidDirection8

directionMiddle:
	cpi		rDirectionY, -1
	breq	returnDirectionIndex0
	cpi		rDirectionY, 1
	breq	returnDirectionIndex4

	// If it's neither -1 or 1, it's an invalid offset
	jmp		invalidDirection8

directionRight:
	cpi		rDirectionY, -1
	breq	returnDirectionIndex1
	cpi		rDirectionY, 0
	breq	returnDirectionIndex2
	cpi		rDirectionY, 1
	breq	returnDirectionIndex3

	// If it's neither -1, 0 or 1, it's an invalid offset
	jmp		invalidDirection8

	// If there isn't a valid direction, crash
invalidDirection8:
	crash

	// Set the direction
returnDirectionIndex0:
	ldi		rDirectionIndex, 0
	jmp		direction8ToIndexEnd
returnDirectionIndex1:
	ldi		rDirectionIndex, 1
	jmp		direction8ToIndexEnd
returnDirectionIndex2:
	ldi		rDirectionIndex, 2
	jmp		direction8ToIndexEnd
returnDirectionIndex3:
	ldi		rDirectionIndex, 3
	jmp		direction8ToIndexEnd
returnDirectionIndex4:
	ldi		rDirectionIndex, 4
	jmp		direction8ToIndexEnd
returnDirectionIndex5:
	ldi		rDirectionIndex, 5
	jmp		direction8ToIndexEnd
returnDirectionIndex6:
	ldi		rDirectionIndex, 6
	jmp		direction8ToIndexEnd
returnDirectionIndex7:
	ldi		rDirectionIndex, 7
	jmp		direction8ToIndexEnd

direction8ToIndexEnd:
	
	// Set the return values
	mov		rReturnL, rDirectionIndex
		
		.UNDEF	rDirectionX
		.UNDEF	rDirectionY
		.UNDEF	rDirectionIndex

	ret
/* direction8ToIndex end */



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
 * Add programs to the main menu
 * @param rArgument0L - the lower byte of the icon label address
 * @param rArgument0H - the upper byte of the icon label address
 * @param rArgument1L - the lower byte of the program label address
 * @param rArgument1H - the upper byte of the program label address
 */
addProgram:

		.DEF	rProgramCount = r18
		.DEF	rTempi		  = r19

	// Load the current program count
	ldi		YL, LOW(programCount)
	ldi		YH, HIGH(programCount)
	ld		rProgramCount, Y
	
	// If the maximum amount of programs has already been reached, crash
	cpi		rProgramCount, MAX_PROGRAMS
	brlo	initializeProgram	
	crash

initializeProgram:

	// Load a pointer to the first program
	ldi		YL, LOW(programs)
	ldi		YH, HIGH(programs)
	
	// Get the offset to the current program
	ldi		rTempi, PROGRAM_DATA_SIZE
	mul		rTempi, rProgramCount

	// Add it to the pointer
	ldi		rTempi, 0
	add		YL, rMulResL
	adc		YH, rTempi		// Add the carry if we get an overflow in the lower byte
	
	// Store the arguments
	std		Y + oProgramIconL, rArgument0L
	std		Y + oProgramIconH, rArgument0H
	std		Y + oProgramAdressL, rArgument1L
	std		Y + oProgramAdressH, rArgument1H

	// Increment the program count
	inc		rProgramCount

	ldi		YL, LOW(programCount)
	ldi		YH, HIGH(programCount)
	st		Y, rProgramCount

		.UNDEF	rProgramCount
		.UNDEF	rTempi
		
	ret
/* addProgram end */


/**
 * Display a graphical menu that can be used to select a program. Programs are represented by icons
 * that flicker between two different frames. By moving the joystick left or right, the program 
 * selection can be cycled. Moving the joystick up or down runs the program.
 */
programSelectMenu:

	initializeTimeri	updateTimer, PROGRAM_SWAP_TIME
	initializeTimeri	renderTimer, PROGRAM_FRAME_TIME

		.DEF	rProgramCount		= r2
		.DEF	rProgramIndex		= r16
		.DEF	rFrameIndex			= r17
		.DEF	rJoystickDirectionX = r3
		.DEF	rJoystickDirectionY = r4
		.DEF	rZero				= r5
		
	// Load the program count
	ldi		YL, LOW(programCount)
	ldi		YH, HIGH(programCount)
	ld		rProgramCount, Y

	// Initialize various variables
	loadConstant	rZero, 0
	mov		rProgramIndex, rZero		// Set the index to 0
	mov		rFrameIndex, rZero			// Set the icon frame index to 0
	mov		rJoystickDirectionX, rZero	// Initialize the joystick direction to the neutral position
	mov		rJoystickDirectionY, rZero
	
programSelectLoop:
	
	// If the render timer has reset, update the icon
	checkTimeri		renderTimer
	cpi		rReturnL, 1
	brne	skipIconUpdate

	// Flip between the two icon frames
	inc		rFrameIndex
	andi	rFrameIndex, 0x1

skipIconUpdate:
	call	readJoystickDirection5
	
	mov		rJoystickDirectionX, rReturnL
	mov		rJoystickDirectionY, rReturnH

	// If the update timer has reset, cycle the program selection
	checkTimeri		updateTimer
	cpi		rReturnL, 1
	brne	skipProgramUpdate

	// If the joystick isn't neutral in X, swap selection
	cp		rJoystickDirectionX, rZero
	breq	skipProgramUpdate

	// Reset frame index
	ldi		rFrameIndex, 0

	// Move program index in the direction the joystick is pointing
	add		rProgramIndex, rJoystickDirectionX
	cp		rProgramIndex, rZero					// If the index goes lower than the first index, select the last
	brlt	selectLastProgram
	cp		rProgramindex, rProgramCount			// If the index goes beyond the last index, select the first
	brge	selectFirstProgram
	jmp		resetJoystickDirection							// If the selection moved to a valid index, keep the new value

selectLastProgram:
	mov		rProgramIndex, rProgramCount			// Wrap around to the first index
	dec		rProgramIndex

	jmp		resetJoystickDirection
selectFirstProgram:
	mov		rProgramIndex, rZero					// Wrap around to the last index

resetJoystickDirection:
	mov		rJoystickDirectionX, rZero
	mov		rJoystickDirectionY, rZero

skipProgramUpdate:

	// Load a pointer to the program array
	ldi		YL, LOW(programs)
	ldi		YH, HIGH(programs)

		.DEF	rTemp = r18

	// Move the pointer to the selected program
	ldi		rTemp, PROGRAM_DATA_SIZE
	mul		rProgramIndex, rTemp
	add		YL, rMulResL
	adc		YH, rZero
		
		.UNDEF	rTemp	

	// Moving the joystick up or down runs the selected program
	cp		rJoystickDirectionY, rZero				// If neutral, don't run
	breq	skipProgramExecution

	// Run the program
	ldd		ZL, Y + oProgramAdressL
	ldd		ZH, Y + oProgramAdressH
	icall

	call	terminateExit

skipProgramExecution:

	// Draw the icon
	mov		rArgument0L, rFrameIndex
	ldd		ZL, Y + oProgramIconL
	ldd		ZH, Y + oProgramIconH
	icall

	// Render the screen and run another iteration
	call	render
	jmp		programSelectLoop
	
	ret
		.UNDEF	rZero
		.UNDEF	rProgramCount
		.UNDEF	rProgramIndex
		.UNDEF	rFrameIndex	
		.UNDEF	rJoystickDirectionX
		.UNDEF	rJoystickDirectionY

/* programSelectMenu end */




/**
 * Entry point after the hardware has been initialized. Runs the code for a menu
 * where you can select between different programs.
 */
main:
		.DEF	rProgramCount	= r18

	// Initialize the program count 
	ldi		YL, LOW(programCount)
	ldi		YH, HIGH(programCount)
	ldi		rProgramCount, 0
	st		Y, rProgramCount

		.UNDEF	rProgramCount

	// Add programs
	addProgrami drawSnakeIcon, snakeGame
	addProgrami drawTetrisIcon, tetrisGame
	addProgrami drawAsteroidsIcon, asteroidsGame
	
	addProgrami drawTimerIcon, timerTest
	addProgrami drawRandomIcon, randomPixelDraw
	addProgrami drawJoystickIcon, renderJoystick 
	addProgrami drawErrorTestIcon, errorTest
	addProgrami drawFillBoardIcon, fillBoard

	addProgrami drawExitIcon, exit

	// Hardware timer initializiton
	ldi		rArgument0L, TIMER2_PRE_1024
	call	initializeHardwareTimer2

	// Run the menu GUI
	call	programSelectMenu

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
	call	terminateExit		// if returned from main, terminate

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

/**
 * Terminate the program
 */
terminateExit:
	cli								// no more interupts after termination
	call	drawCrossMatrix

terminateExitLoop:
	call	render
	jmp		terminateExitLoop

	// no ret since the program was terminated
/* terminateExit end */
