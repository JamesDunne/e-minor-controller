//*;###########################################################################
//;#			Author: Ali Rizavi											  #
//;#			Date 10/07/04					      						  #
//;#			MASTER SWITCH GENERATION 1.x								  #
//;#			Init funtion header File									  #
//;#			File Name: init.h											  #
//;#																		  #
//;#			Updated 10/07/04 by AR										  #
//;############################################################################

//-----------------------------------------------------------------------------
//Define constants here

#define	DISP_NUMBER_OF_COMMONS	5	//5 is default, increase to reduce brightness

#define	LATCH_STROBE_DELAY		16	//4uS minimum
#define	BTN_SAMPLE_DELAY		5	//probably unnecessary
//-----------------------------------------------------------------------------
//Communication constants

#define	COMMAND_REJECTED	0x01		//UPS->Computer
#define	COMMAND_ACCEPTED	0x02		//UPS->Computer
#define	POLLING_COMMAND		0x03		//Computer->UPS
#define	SET_COMMAND			0x04		//Computer->UPS
#define	DATA_RETURNED		0x05		//UPS->Computer
#define	INVALID_REQUEST		0xff

//Report ID 44 commands:
#define	ERASE_32			0x30
#define	WRITE_32			0x31
#define	READ_32				0x32

//-----------------------------------------------------------------------------
//ROM DATA MAP
#define	ROM_BANK_COUNT			0

//-----------------------------------------------------------------------------
//Update history:
