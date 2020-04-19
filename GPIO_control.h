/**
  ******************************************************************************
  *   GPIO_control.h
  *   Founction prototypes for the GPIO_control.s source code
  *                   
  ******************************************************************************
  *   Project Team Members: Albert Perlman
  *
  ******************************************************************************
  */


/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __GPIO_CONTROL_H
#define __GPIO_CONTROL_H

#include <stdint.h>

void DISPLAY_INIT(void);
void DISPLAY_UPDATE(uint8_t value);
void LED_INIT(void);
void LED_CONTROL(uint8_t LED_value);

#endif /* __GPIO_CONTROL_H */
