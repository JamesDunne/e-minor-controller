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
//macros:
#define	ENABLE_ALL_INTERRUPTS()		\
	INTCONbits.GIEH = true;			\
	INTCONbits.GIEL = true;

#define	DISABLE_ALL_INTERRUPTS()	\
	INTCONbits.GIEH = false;		\
	INTCONbits.GIEL = false;


//-----------------------------------------------------------------------------
//Define function prototypes here
void	CLEAR_RAM(void);		//asm function.

void	TXENQ(unsigned char Input);
void	RS232_ROUTINE(void);
void	PROCESS_COMM_REQUEST(void);
void InterruptHandlerHigh ();
void init(void);
void	HandleDigit(unsigned char ComPointer);
void	AllDigitsOff(void);
unsigned char AsciiTo7Seg(unsigned char chr);
void	SendDataToShiftReg(unsigned char dataToSend);
void	SetDipAddress(unsigned char Address);
void	ReadButtons(void);
unsigned char	ADC_CONVERSION(unsigned char Channel);


extern rom unsigned char NumbersSegTable[10];
extern rom unsigned char LettersSegTable[26];
extern rom unsigned char ROM_SAVEDATA[0x1CFF];
//-----------------------------------------------------------------------------
//Update history:
