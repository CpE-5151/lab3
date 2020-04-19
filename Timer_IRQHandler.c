/********************************************************************
*    Timer_IRQHandler.c
*    Timer2 ISR C function for experiment #3
*
*    Project Team Members: Albert Perlman
********************************************************************/

#include "Timer_Source.h"

/* global variable used to store Timer2 CCR1 value */
uint32_t count_g;

/* STEP #6 */
/********************************************************************
*     void TIM2_IRQHandler(void)
*     reads Timer 2 CCR1 value and stores in global variable
*     and disables subsequent Timer2 interrupts from occuring
********************************************************************/
void TIM2_IRQHandler(void)
{
  /* 6a) read Timer2 CCR1 value into global variable*/
  count_g = READ_MEASUREMENT();
  /* 6b) disable Timer2 CC1 interrupt */
  TIMER2_DISABLE_CC1_INTERRUPT();
}
