//#######################################################################
/**
* @file main.c
* This file some initialization code for C and the C arbitrator portion.
*
* @author Joe Dunne
* @date 2/02/05
* @brief RS232/USB communication routine
*/
//			*See Updates section at bottom of file*
//#######################################################################

#include "c_system.h"


#pragma code InterruptVectorHigh = 0xA08
void
InterruptVectorHigh (void)
{
  _asm
	goto InterruptHandlerHigh //jump to interrupt routine
  _endasm
}


//----------------------------------------------------------------------------
// High priority interrupt routine

#pragma code
#pragma interrupt InterruptHandlerHigh

void
InterruptHandlerHigh ()
{
  if (INTCONbits.TMR0IF)
    {                                   //check for TMR0 overflow
      INTCONbits.TMR0IF = 0;            //clear interrupt flag
      //Flags.Bit.Timeout = 1;            //indicate timeout
      //LATBbits.LATB0 = !LATBbits.LATB0; //toggle LED on RB0
    }
}

//----------------------------------------------------------------------------
