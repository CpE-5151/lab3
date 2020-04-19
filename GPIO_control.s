;********************************************************************************************
;       GPIO_control.s
;       GPIO Assembly Code for experiment #3
;
;       Project Team Members: Roger Younger
;
;
;       Version 1.0      Mar. 24, 2020
;
;********************************************************************************************

        INCLUDE STM32L4R5xx_constants.inc


        AREA program, CODE, READONLY
		
		ALIGN
			
;***************************************************************************************
;      void DISPLAY_INIT(void);
;      Initializes the 4-bit LED Display
;      PF15 to PF12 set to push-pull output (no pull-up/pull-down)
;**************************************************************************************

		EXPORT DISPLAY_INIT

DISPLAY_INIT
	PUSH {R14}
	LDR R0, =RCC_BASE
	LDR R1, [R0, #RCC_AHB2ENR]
	ORR R1, R1, #(RCC_AHB2ENR_GPIOFEN)      ; Enables clock for GPIOF
	STR R1, [R0, #RCC_AHB2ENR]
	; MODE: 00: Input mode, 01: General purpose output mode
    ;       10: Alternate function mode, 11: Analog mode (reset state)
	LDR R0, =GPIOF_BASE      	; Base address for GPIOF
	; Set GPIO mode to output for P15 to P12
	LDR R1,[R0,#GPIO_MODER]
	BIC R1, R1, #((3<<(2*15)):OR:(3<<(2*14)):OR:(3<<(2*13)):OR:(3<<(2*12)))
	ORR R1, R1, #((1<<(2*15)):OR:(1<<(2*14)):OR:(1<<(2*13)):OR:(1<<(2*12)))
	STR R1,[R0,#GPIO_MODER]
	; Set output type to push-pull for P15 to PF12
	LDR R1,[R0,#GPIO_OTYPER]
	BIC R1, R1, #((1<<15):OR:(1<<14):OR:(1<<13):OR:(1<<12))
	STR R1,[R0,#GPIO_OTYPER]
	; Disable pull-up and pull-down resistors
	LDR R1,[R0,#GPIO_PUPDR]
	BIC R1, R1, #((3<<(2*15)):OR:(3<<(2*14)):OR:(3<<(2*13)):OR:(3<<(2*12)))
	STR R1,[R0,#GPIO_PUPDR]
	POP {R14}
	BX R14
	
;***************************************************************************************
;      void DISPLAY_UPDATE(uint8_t value);
;      Writes the 4-bit value (in the lower nibble of value) to the
;      4-bit LED display on PF15 to PF12.
;**************************************************************************************

		EXPORT DISPLAY_UPDATE

DISPLAY_UPDATE
	PUSH {R14}
	LDR R1,=GPIOF_BASE
	LDR R2,[R1,#GPIO_ODR]
	BIC R2, R2, #0xF000
	ORR R2, R2, R0, LSL#12
	STR R2,[R1,#GPIO_ODR]
	POP {R14}
	BX R14


;***************************************************************************************
;      void LED_INIT(void);
;      Sets the GPIO pin PE9 to a push-pull output (no pull-up/pull-down)
;      Single LED connected to this pin for user output.
;**************************************************************************************

		EXPORT LED_INIT
	
LED_INIT
	PUSH {R14}
	LDR R0, =RCC_BASE
	LDR R1, [R0, #RCC_AHB2ENR]
	ORR R1, R1, #(RCC_AHB2ENR_GPIOEEN)      ; Enables clock for GPIOE
	STR R1, [R0, #RCC_AHB2ENR]
	; MODE: 00: Input mode, 01: General purpose output mode
    ;       10: Alternate function mode, 11: Analog mode (reset state)
	LDR R0, =GPIOE_BASE      	; Base address for GPIOF
	; Set GPIO mode to output PE9
	LDR R1,[R0,#GPIO_MODER]
	BIC R1, R1, #(3<<(2*9))
	ORR R1, R1, #(1<<(2*9))
	STR R1,[R0,#GPIO_MODER]
	; Set output type to push-pull for PE9
	LDR R1,[R0,#GPIO_OTYPER]
	BIC R1, R1, #(1<<9)
	STR R1,[R0,#GPIO_OTYPER]
	; Disable pull-up and pull-down resistors
	LDR R1,[R0,#GPIO_PUPDR]
	BIC R1, R1, #(3<<(2*9))
	STR R1,[R0,#GPIO_PUPDR]
	POP {R14}
	BX R14
	
;***************************************************************************************
;      void LED_CONTROL(uint8_t LED_value);
;      Controls an LED connected to PE9
;      LED_value: '1' switches LED on, '0' switches LED off
;**************************************************************************************

		EXPORT LED_CONTROL
	
LED_CONTROL
	PUSH {R14}
	LDR R2, =GPIOE_BASE      	; Base address for GPIOE
	LDR R1,[R2,#GPIO_ODR]        ; read current ODR
	BIC R1,R1,#(1<<9)           ; Clear bit 9
	LSL R0,R0,#9                 ; Shift the pin_value to bit 9
	ORR R1,R1,R0                 ; OR the new pin_value into the ODR
	STR R1,[R2,#GPIO_ODR]
	POP {R14}
	BX R14
	
	
	END
	