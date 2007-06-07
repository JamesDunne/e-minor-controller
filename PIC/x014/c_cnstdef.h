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
#define	MAX_RX_LENGTH		9
#define	MAX_TX_LENGTH		64

#define	HEADER_CHAR			0x7E		//~
#define	COMMAND_REJECTED	0x01		//UPS->Computer
#define	COMMAND_ACCEPTED	0x02		//UPS->Computer
#define	POLLING_COMMAND		0x03		//Computer->UPS
#define	SET_COMMAND			0x04		//Computer->UPS
#define	DATA_RETURNED		0x05		//UPS->Computer
#define	INVALID_REQUEST		0xff

#define	DEFAULT_PREDELAY	3			//in seconds, +0/-1

#define	EE_SKU_STRING		0x3E		//6 bytes
#define	EE_USB_ID_STRING	0x44		//to 67h, 36 registers

#define	ERASE_32			0x30
#define	WRITE_32			0x31
#define	READ_32				0x32


//EEPROM locations:
#define	EE_SYS_PWR_RATING_H		0x06
#define	EE_SYS_PWR_RATING_L		0x07
#define	EE_NOM_VAC				0x0A
#define	EE_NOM_VDC_BATT			0x0B
#define	EE_SW_LD_BNKS			0x0C
#define	EE_NOM_INV_AC_OUTPUT	0x10
#define	EE_RPT_HIGH_LINE_SET_H	0x11
#define	EE_RPT_HIGH_LINE_SET_L	0x12
#define	EE_RPT_LOW_LINE_SET		0x13
#define	EE_VBATT_MULTIPLIER		0x14		//nominalvbatt/12
#define	EE_VRMS_MULTIPLIER		0x15		//67
//-----------------------------------------------------------------------------
//Update history:
