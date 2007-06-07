//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 4/06/07					      						  #
//;#			Main arbitrator									  			  #
//;#			File Name: main.c   										  #
//;#																		  #
//;############################################################################


#include "c_system.h"
#include "usb.h"

unsigned char	ADC_CONVERSION(unsigned char Channel);
void	ServiceUSB(void);

//#define	RX_TRIS_BIT		TRISCbits.TRISC7		// Receive direction bit
//#define	TX_TRIS_BIT		TRISCbits.TRISC6		// Transmit direction bit

#pragma code	main_code=0xA2A

void main() {
	unsigned char chars[5];

	init();
//	controllerinit();
	
	chars[0] = ' ';
	chars[1] = 'p';
	chars[2] = 'a';
	chars[3] = 'r';
	chars[4] = 'c';
	SetDispAscii(chars);
	SendDataToShiftReg(0xAA);


	chars[0] = ROM_SAVEDATA[0];
	chars[1] = ROM_SAVEDATA[1];

	ProgmemBuffer[0] = 0xAA;
	ProgmemBuffer[1] = 0x55;
	Write64BytesProgMem(ROM_SAVEDATA,ProgmemBuffer);
	chars[0] = ROM_SAVEDATA[0];
	chars[1] = ROM_SAVEDATA[1];


	for(;;) {
		if (Systick) {

			ReadButtons();

//			ProcessControl();
//			if (LATE == 0x05) LATE = 0x2;
//			else LATE = 0x05;
			ProcessLeds();
		}
		ServiceUSB();
	}
}

void	ServiceUSB(void) {
	USBCheckBusStatus();                    // Must use polling method
    if(UCFGbits.UTEYE!=1) {
        USBDriverService();                 // Interrupt or polling method
	}
}
