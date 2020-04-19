;********************************************************************************************
;       Timer_Source.s
;       Timer Assembly Code for experiment #3
;
;       Project Team Members: Albert Perlman
;
;********************************************************************************************

        INCLUDE STM32L4R5xx_constants.inc


        AREA program, CODE, READONLY
		ALIGN
			

	
;***************************************************************************************
;      void TIMER3_INIT(void);
;      Sets up TIM3, CH1 to be a 40KHz PWM (Output on PA6)
;**************************************************************************************
	    EXPORT TIMER3_INIT
			
TIMER3_INIT
	PUSH {R14}
	LDR R0, =RCC_BASE
	LDR R1, [R0, #RCC_AHB2ENR]
	ORR R1, R1, #(RCC_AHB2ENR_GPIOAEN)      ; Enables clock for GPIOA
	STR R1, [R0, #RCC_AHB2ENR]
	LDR R1, [R0, #RCC_APB1ENR1]
	ORR R1, R1, #(RCC_APB1ENR1_TIM3EN)
	STR R1, [R0, #RCC_APB1ENR1]
	; MODE: 00: Input mode, 01: General purpose output mode
    ;       10: Alternate function mode, 11: Analog mode (reset state)
	LDR R0, =GPIOA_BASE      	; Base address for GPIOF
	; Set GPIO mode to alternate function for PA6 (Timer3, CH1)
	LDR R1,[R0,#GPIO_MODER]
	BIC R1, R1, #(3<<(2*6))
	ORR R1, R1, #(2<<(2*6))
	STR R1,[R0,#GPIO_MODER]
	; Set output type to push-pull for PA6
	LDR R1,[R0,#GPIO_OTYPER]
	BIC R1, R1, #(1<<(6))
	STR R1,[R0,#GPIO_OTYPER]
	; Disable pull-up and pull-down resistors
	LDR R1,[R0,#GPIO_PUPDR]
	BIC R1, R1, #(3<<(2*6))
	STR R1,[R0,#GPIO_PUPDR]
	; Set Alternate Function on PA6 to 2 (Timer 3, CH1)
	LDR R1, [R0, #GPIO_AFRL]
	BIC R1, R1, #(0x0F<<(4*6))
	ORR R1, R1, #(2<<(4*6))
	STR R1, [R0, #GPIO_AFRL]
	; Set up Timer 3 as a PWM with a 40KHz output (50% duty cycle)
	LDR R0, =TIM3_BASE
	; Set compare mode to PWM mode 1
	LDR R1, [R0, #TIM_CCMR1]
	BIC R1, R1, #0xFF             ; clears all of the CH1 bits
	ORR R1, R1, #(7<<4)  ; PWM mode 2, and preload enable
	STR R1, [R0, #TIM_CCMR1]
	; Enable CH1 with active high output
	LDR R1, [R0, #TIM_CCER]
	BIC R1, R1, #(0x0B)          ; clear all bit for CH1
	ORR R1, R1, #((0<<1):OR:(1<<0))  ; Active high output and output is enabled
	STR R1, [R0, #TIM_CCER]
	; Set the output frequency to 40KHZ and duty cycle to 50%
	MOV R1, #100       ; value = 4MHz/40KHz = 100
	STR R1, [R0, #TIM_ARR]
	MOV R1, #50
	STR R1, [R0, #TIM_CCR1]
	; Update the preload registers and enable the timer
	MOV R1, #((5):OR:(3<<4))          ; Gated mode controled by Timer 4
	;ORR R1, R1, #(1<<15)
	STR R1, [R0, #TIM_SMCR]
	MOV R1, #1      ; set the UG (update generation bit
	STR R1, [R0, #TIM_EGR]
	MOV R1, #1
	STR R1, [R0, #TIM_CR1]
	POP {R14}
	BX R14
	
;***************************************************************************************
;      void TIMER4_INIT(void);
;      Creates a 106us high pulse that is used to gate Timer3 to create a burst of 40KHz
;      Pulse is started by resetting Timer3.
;**************************************************************************************
	EXPORT TIMER4_INIT
		
TIMER4_INIT
	PUSH {R14}
	LDR R0, =RCC_BASE
	LDR R1, [R0, #RCC_AHB2ENR]
	ORR R1, R1, #(RCC_AHB2ENR_GPIODEN)      ; Enables clock for GPIOD
	STR R1, [R0, #RCC_AHB2ENR]
	LDR R1, [R0, #RCC_APB1ENR1]
	ORR R1, R1, #(RCC_APB1ENR1_TIM4EN)
	STR R1, [R0, #RCC_APB1ENR1]
	; MODE: 00: Input mode, 01: General purpose output mode
    ;       10: Alternate function mode, 11: Analog mode (reset state)
	LDR R0, =GPIOD_BASE      	; Base address for GPIOF
	; Set GPIO mode to alternate function for PD15 (Timer4, CH4) and PD14 (Timer4,  CH3)
	LDR R1,[R0,#GPIO_MODER]
	BIC R1, R1, #(3<<(2*14))
	ORR R1, R1, #(2<<(2*14))
	STR R1,[R0,#GPIO_MODER]
	; Set output type to push-pull for PA6
	LDR R1,[R0,#GPIO_OTYPER]
	BIC R1, R1, #(1<<(14))
	STR R1,[R0,#GPIO_OTYPER]
	; Disable pull-up and pull-down resistors
	LDR R1,[R0,#GPIO_PUPDR]
	BIC R1, R1, #(3<<(2*14))
	STR R1,[R0,#GPIO_PUPDR]
	; Set Alternate Function on PA6 to 2 (Timer 3, CH1)
	LDR R1, [R0, #GPIO_AFRH]
	BIC R1, R1, #(0x0F<<(4*6))
	ORR R1, R1, #(2<<(4*6))
	STR R1, [R0, #GPIO_AFRH]
	; Set up Timer 3 as a PWM with a 40KHz output (50% duty cycle)
	LDR R0, =TIM4_BASE
	; Set compare mode to PWM mode 2
	LDR R1, [R0, #TIM_CCMR2]
	BIC R1, R1, #0xFF             ; clears all of the CH3 bits
	ORR R1, R1, #((7<<4):OR:(0<<3))  ; PWM mode 2
	STR R1, [R0, #TIM_CCMR2]
	; Set the counts for a delay and then 106us pulse
	MOV R1, #434       ; stopping point for 106us (106us*4MHz=424 + 10 for delay)
	STR R1, [R0, #TIM_ARR]
	MOV R1, #10             ; allows for over 4 cycles of 40KHz  (trying to start and stop when 40KHz is low)
	STR R1, [R0, #TIM_CCR3] 
	; Set Slave Mode
	MOV R1, #((2<<4):OR:(6<<0))  ; Trigger Mode (start timer), Trigger is TIM2 TGRO (Update)
	STR R1, [R0, #TIM_SMCR]      
	; Set CH3 to be the TRGO
	LDR R1, [R0, #TIM_CR2]
	BIC R1, R1, #(7<<4)
	ORR R1, R1, #(6<<4)       ; CH3 is the Trigger Output (TRGO) for gating TIM3, CH1
	STR R1, [R0, #TIM_CR2]
	MOV R1, #1      ; set the UG (update generation bit)
	STR R1, [R0, #TIM_EGR]
	; Enable the output for CH3 and CH4
	LDR R1, [R0, #TIM_CCER]
	BIC R1, R1, #(0x0B<<(4*2))          ; clear all bit for CH3
	ORR R1, R1, #((1<<(4*2)))  ; Active high output and output is enabled
	STR R1, [R0, #TIM_CCER]
	MOV R1, #0x08           ; Enables counter, update request, One Pulse Mode
	STR R1, [R0, #TIM_CR1]
	POP {R14}
	BX R14
	
;***************************************************************************************
;      void TIMER5_INIT(void);
;      Creates a 1ms low pulse that is used to block the transmitted signal.
;      Pulse is started by resetting Timer3.
;**************************************************************************************
	EXPORT TIMER5_INIT

TIMER5_INIT
	PUSH {R14}
	LDR R0, =RCC_BASE
	LDR R1, [R0, #RCC_AHB2ENR]
	ORR R1, R1, #(RCC_AHB2ENR_GPIOAEN)      ; Enables clock for GPIOD
	STR R1, [R0, #RCC_AHB2ENR]
	LDR R1, [R0, #RCC_APB1ENR1]
	ORR R1, R1, #(RCC_APB1ENR1_TIM5EN)
	STR R1, [R0, #RCC_APB1ENR1]
	; MODE: 00: Input mode, 01: General purpose output mode
    ;       10: Alternate function mode, 11: Analog mode (reset state)
	LDR R0, =GPIOA_BASE      	; Base address for GPIOF
	; Set GPIO mode to alternate function for PD15 (Timer4, CH4) and PD14 (Timer4,  CH3)
	LDR R1,[R0,#GPIO_MODER]
	BIC R1, R1, #(3<<(2*3))
	ORR R1, R1, #(2<<(2*3))
	STR R1,[R0,#GPIO_MODER]
	; Set output type to push-pull for PA6
	LDR R1,[R0,#GPIO_OTYPER]
	BIC R1, R1, #(1<<(3))
	STR R1,[R0,#GPIO_OTYPER]
	; Disable pull-up and pull-down resistors
	LDR R1,[R0,#GPIO_PUPDR]
	BIC R1, R1, #(3<<(2*3))
	STR R1,[R0,#GPIO_PUPDR]
	; Set Alternate Function on PA6 to 2 (Timer 3, CH1)
	LDR R1, [R0, #GPIO_AFRL]
	BIC R1, R1, #(0x0F<<(4*3))
	ORR R1, R1, #(2<<(4*3))
	STR R1, [R0, #GPIO_AFRL]
	; Set up Timer 3 as a PWM with a 40KHz output (50% duty cycle)
	LDR R0, =TIM5_BASE
	; Set compare mode to PWM mode 1
	LDR R1, [R0, #TIM_CCMR2]
	BIC R1, R1, #0xFF00           ; clears all of the CH4 bits
	ORR R1, R1, #((7<<12):OR:(0<<11))  ; PWM Mode 2
	;ORR R1, R1, #(1<<24)
	STR R1, [R0, #TIM_CCMR2]
	; Set for 1ms pulse after short delay
	MOV R1, #4010       ; counts = time * (clock_freq) = 0.001 * 4,000,000 = 4000 + delay
	STR R1, [R0, #TIM_ARR]
	MOV R1, #10             ; delay time (must match delay time used for 106us pulse
	STR R1, [R0, #TIM_CCR4] 
	; Slave Mode Control Register
	MOV R1, #((1<<4):OR:(6<<0))  ; Trigger (start timer), Trigger is TIM3 TGRO (Update) 
	STR R1, [R0, #TIM_SMCR]
	MOV R1, #1      ; set the UG (update generation bit)
	STR R1, [R0, #TIM_EGR]
	; Enable the output for CH4
	LDR R1, [R0, #TIM_CCER]
	BIC R1, R1, #(0x0B<<(4*3))          ; clear all bit for CH4
	ORR R1, R1, #((3<<(4*3)))  ; Active low output and output is enabled
	STR R1, [R0, #TIM_CCER]
	MOV R1, #0x08           ; One Pulse Mode
	STR R1, [R0, #TIM_CR1]
	POP {R14}
	BX R14
	
;***************************************************************************************
;      void TIMER2_INIT(void);
;      Sets Timer2 to input capture mode on CH1
;**************************************************************************************
	EXPORT TIMER2_INIT

TIMER2_INIT
	PUSH {R14}
	LDR R0, =RCC_BASE
	LDR R1, [R0, #RCC_AHB2ENR]
	ORR R1, R1, #(RCC_AHB2ENR_GPIOAEN)      ; Enables clock for GPIOF
	STR R1, [R0, #RCC_AHB2ENR]
	LDR R1, [R0, #RCC_APB1ENR1]
	ORR R1, R1, #(RCC_APB1ENR1_TIM2EN)
	STR R1, [R0, #RCC_APB1ENR1]
	; MODE: 00: Input mode, 01: General purpose output mode
    ;       10: Alternate function mode, 11: Analog mode (reset state)
	LDR R0, =GPIOA_BASE      	; Base address for GPIOF
	; Set GPIO mode to alternate function for PA5 (Timer2, CH1)
	LDR R1,[R0,#GPIO_MODER]
	BIC R1, R1, #(3<<(2*5))
	ORR R1, R1, #(2<<(2*5))
	STR R1,[R0,#GPIO_MODER]
	; Set output type to push-pull for PA6
	LDR R1,[R0,#GPIO_OTYPER]
	BIC R1, R1, #(1<<(5))
	STR R1,[R0,#GPIO_OTYPER]
	; Disable pull-up and pull-down resistors
	LDR R1,[R0,#GPIO_PUPDR]
	BIC R1, R1, #(3<<(2*5))
	STR R1,[R0,#GPIO_PUPDR]
	; Set Alternate Function on PA5 to 2 (Timer 2, CH1)
	LDR R1, [R0, #GPIO_AFRL]
	BIC R1, R1, #(0x0F<<(4*5))
	ORR R1, R1, #(1<<(4*5))
	STR R1, [R0, #GPIO_AFRL]
	; Set up Timer 3 as a PWM with a 40KHz output (50% duty cycle)
	LDR R0, =TIM2_BASE
	; Set compare mode to PWM mode 1
	LDR R1, [R0, #TIM_CCMR1]
	BIC R1, R1, #0xFF             ; clears all of the CH1 bits
	ORR R1, R1, #(1<<0)          ; Capture Mode, No Prescale or Filter
	STR R1, [R0, #TIM_CCMR1]
	LDR R1, [R0, #TIM_CR2]
	BIC R1, R1, #0xF0          ; UG assert is TRGO and TI1 connected to CH1
	STR R1, [R0, #TIM_CR2]
	LDR R1, [R0, #TIM_CCER]
	BIC R1, R1, #(0x0B)          ; clear all bit for CH1
	ORR R1, R1, #(1<<0)        ; Enable the CH1 Input
	STR R1, [R0, #TIM_CCER]
	LDR R1, [R0, #TIM_SMCR]
	MOV R1, #((2<<4):OR:(4<<0))  ; Reset count, Trigger is TIM3 TGRO (Update) 	
	MOV R1, #1
	STR R1, [R0, #TIM_CR1]
	POP {R14}
	BX R14

; STEP #2
;***************************************************************************************
;      void TIMER2_ENABLE_CC1_INTERRUPT(void);
;      enable TIM2_CC1 interrupt
;**************************************************************************************
  EXPORT TIMER2_ENABLE_CC1_INTERRUPT

TIMER2_ENABLE_CC1_INTERRUPT
  ;2a
  PUSH {R14,R0,R1}
  ;2b
  LDR R0, =TIM2_BASE
  ;2c
  MOV R1, #0
  STR R1, [R0, #TIM_SR]   ; clear all pending interrupts
  ;2d
  LDR R1, [R0, #TIM_DIER]
  ORR R1, R1, #(1<<1)     ; set TIM_DIER CC1IE bit to enable interrupt
  STR R1, [R0, #TIM_DIER]
  ;2e
  POP {R14,R0,R1}
  ;2f
  BX R14

; STEP #3
;***************************************************************************************
;      void TIMER2_DISABLE_CC1_INTERRUPT(void);
;      disable TIM2_CC1 interrupt
;**************************************************************************************
  EXPORT TIMER2_DISABLE_CC1_INTERRUPT

TIMER2_DISABLE_CC1_INTERRUPT
  ;3a
  PUSH {R14,R0,R1}
  ;3b
  LDR R0, =TIM2_BASE
  ;3c
  LDR R1, [R0, #TIM_DIER]
  BIC R1, R1, #(1<<1)     ; clear TIM_DIER CC1IE bit to disable interrupt
  STR R1, [R0, #TIM_DIER]
  ;3d
  POP {R14,R0,R1}
  ;3e
  BX R14

; STEP #4
;***************************************************************************************
;      uint32_t READ_MEASUREMENT(void);
;      read the TIM2_CCR1 value
;**************************************************************************************
  EXPORT READ_MEASUREMENT

READ_MEASUREMENT
  ;4a
  PUSH {R14,R1}
  ;4b
  LDR R1, =TIM2_BASE
  ;4c
  LDR R0, [R1, #TIM_CCR1] ; read TIM_CCR1 value
  ;4d
  POP {R14,R1}
  ;4e
  BX R14  ; return TIM_CCR1 value in R0

; STEP #5
;***************************************************************************************
;      void START_MEASUREMENT(void);
;      reset and trigger timers for a distance measurement
;**************************************************************************************
  EXPORT START_MEASUREMENT

START_MEASUREMENT
  ;5a
  PUSH {R14,R0,R1}
  
  ;5b
  LDR R0, =TIM4_BASE
  ;5c
  LDR R1, [R0, #TIM_EGR]
  ORR R1, R1, #1          ; set UG bit to reset TIM4
  STR R1, [R0, #TIM_EGR]

  ;5d
  LDR R0, =TIM5_BASE
  ;5e
  LDR R1, [R0, #TIM_EGR]
  ORR R1, R1, #1          ; set UG bit to reset TIM5
  STR R1, [R0, #TIM_EGR]

  ;5f
  LDR R0, =TIM3_BASE
  ;5g
  LDR R1, [R0, #TIM_EGR]
  ORR R1, R1, #1          ; set UG bit to reset TIM3
  STR R1, [R0, #TIM_EGR]

  ;5h
  POP {R14,R0,R1}
  ;5i
  BX R14


  END
		
		