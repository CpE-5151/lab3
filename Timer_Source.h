/**
  ******************************************************************************
  *   Timer_Source.h
  *   Founction prototypes for the Timer_Source.s source code
  *                   
  ******************************************************************************
  *   Project Team Members: Albert Perlman
  *
  ******************************************************************************
  */


/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __TIMER_SOURCE_H
#define __TIMER_SOURCE_H

#include <stdint.h>

void TIMER2_INIT(void);
void TIMER3_INIT(void);
void TIMER4_INIT(void);
void TIMER5_INIT(void);
void TIMER2_ENABLE_CC1_INTERRUPT(void);
void TIMER2_DISABLE_CC1_INTERRUPT(void);
void START_MEASUREMENT(void);
uint32_t READ_MEASUREMENT(void);

#endif /* __TIMER_SOURCE_H */
