//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 10/07/04					      						  #
//;#			MASTER SWITCH GENERATION 1.x								  #
//;#			System header File											  #
//;#			File Name: c_system.h										  #
//;#																		  #
//;############################################################################
#include "_tools.h"
#include "p18f4455.h"
#include "c_cnstdef.h"
#include "c_ramdef.h"
#include "c_portdef.h"

//-----------------------------------------------------------------------------
//Define function prototypes here
void	RTXB(void);
void	TXENQ(unsigned char Input);
void	RS232_ROUTINE(void);
void	PROCESS_COMM_REQUEST(void);

void InterruptHandlerHigh ();

#define	ENABLE_ALL_INTERRUPTS()		\
	INTCONbits.GIEH = true;			\
	INTCONbits.GIEL = true;

#define	DISABLE_ALL_INTERRUPTS()	\
	INTCONbits.GIEH = false;		\
	INTCONbits.GIEL = false;

//-----------------------------------------------------------------------------
//Update history:
