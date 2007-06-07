//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 10/07/04					      						  #
//;#			MASTER SWITCH GENERATION 1.x								  #
//;#			System header File											  #
//;#			File Name: _System.h										  #
//;#																		  #
//;#			Updated 10/07/04 by AR										  #
//;############################################################################
#include "_tools.h"
#include "c_18f4455.h"
#include "c_cnstdef.h"
#include "c_ramdef.h"
#include "c_portdef.h"
#include "usb.h"

//-----------------------------------------------------------------------------
//Define function prototypes here
void	TXENQ(unsigned char Input);
void	RS232_ROUTINE(void);
void	PROCESS_COMM_REQUEST(void);


#define	ENABLE_ALL_INTERRUPTS()		\
	INTCONbits.GIEH = true;			\
	INTCONbits.GIEL = true;

#define	DISABLE_ALL_INTERRUPTS()	\
	INTCONbits.GIEH = false;		\
	INTCONbits.GIEL = false;

void InterruptHandlerHigh (void);


//-----------------------------------------------------------------------------
//Update history:
