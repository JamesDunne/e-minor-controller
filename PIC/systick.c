//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 6/01/07					      						  #
//;#			System time routine								  			  #
//;#			File Name: systick.c   										  #
//;#																		  #
//;############################################################################


#include "c_system.h"
#include "typedefs.h"
#include "hardware.h"

//1mS time keeping routine:
void	SystemTimeRoutine(void) {

//1mS routines:
	Handle7segs = true;

	SystickCntr2++;
	if (SystickCntr2 == SYSTEM_TIME_10MS) {
		SystickCntr2 = 0;

//10mS routines:
		ExpPedalSvc = true;
		CheckButtons = true;
		HandleController = true;
		ControllerTiming = true;

		SystickCntr3++;
		if (SystickCntr3 == SYSTEM_TIME_1S) {
			SystickCntr3 = 0;
//1S routines:
			HandleLeds = true;
			if (Scroll7Segs) Scroll7SegDisp();
		}
	}
}