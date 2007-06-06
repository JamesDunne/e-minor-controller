//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 5/28/07					      						  #
//;#			Tables in the code								  			  #
//;#			File Name: tables.c   										  #
//;#																		  #
//;############################################################################


#include "c_system.h"
#include "usb.h"
#include "hardware.h"

#pragma romdata

rom unsigned char EXPP_PEDAL_LINEAR_CONV_TABLE[256] =
{    
	0
};

#pragma romdata ROMSAVEDATA=0x4300
rom unsigned char ROM_SAVEDATA[0x1CFF] = {
	0
};

#pragma code
