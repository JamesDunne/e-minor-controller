//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 4/06/07					      						  #
//;#			EXPPedal							  			  			  #
//;#			File Name: eeprom.c   										  #
//;#																		  #
//;############################################################################

#include "c_system.h"

void ExpPedalRead(void) {
	ExpPedalSvc = false;
	ExpPedalInst = ADC_CONVERSION(EXP_PEDAL_CHANNEL);
}