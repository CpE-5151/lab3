;********************************************************************************************
;       Measure_Conversion_Source.s
;       Measurement Conversion Assembly Code for experiment #3
;
;       Project Team Members: Albert Perlman
;
;********************************************************************************************

        AREA program, CODE, READONLY
    ALIGN
      
;***************************************************************************************
;      int CONVERT_MEASUREMENT(int);
;      convert TIM2 CCR1 counts to distance measurement in q8 format
;**************************************************************************************

    EXPORT CONVERT_MEASUREMENT

; STEP #9: convert TIM2 CCR1 counts to distance measurement in q8 format
;____________________________________________________________________________   

CONVERT_MEASUREMENT
  PUSH {R14}

  ; distance in feet = [ TIM_CCR1 * 1,125 (feet/sec) ] / [ 2 * 4,000,000 (1/sec) ]
  ;
  ; to calculate result in q8 format,
  ;   maintain precision by dividing the equation's denominator by 256
  ;
  ;   [ 2 * 4,000,000 (1/sec) ] / 256   =   31,250
  ;
  ;
  ; therefore the measurement conversion equation is:
  ;
  ; distance in feet = [ TIM_CCR1 * 1,125 ] / 31,250

  MOV R1, #1125   ; constant speed of sound in feet/second
  MOV R2, #31250  ; constant divisor
  
  MUL R3, R0, R1    ; R3 = TIM_CCR1 * 1,125
  UDIV R0, R3, R2   ; R0 = R3 / 31,250

  POP {R14}
  BX R14

  END