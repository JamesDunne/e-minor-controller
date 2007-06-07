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
	unsigned char chars[5], index;

	init();
//	controllerinit();
	
	chars[0] = ' ';
	chars[1] = 'p';
	chars[2] = 'a';
	chars[3] = 'r';
	chars[4] = 'c';
	SetDispAscii(chars);
	SendDataToShiftReg(0xAA);

/*
	ProgMemAddr.s_form = 0x4000;
	
	USBEP0DataInBuffer[4] = 0xAA;
	USBEP0DataInBuffer[5] = 0x65;
	USBEP0DataInBuffer[6] = 0x75;
	USBEP0DataInBuffer[7] = 0x85;
	USBEP0DataInBuffer[8] = 0x95;
	
	for (index=0;index<32;index++)
	ProgmemBuffer[index] = USBEP0DataInBuffer[index+4];
	
	EraseProgMem();	//uses global ProgMemAddr
	
	WriteProgMem();	//uses global ProgMemAddr and ProgmemBuffer[]
*/

	for(;;) {
		if (Systick) {

			ReadButtons();

//			ProcessControl();
//			if (LATE == 0x05) LATE = 0x2;
//			else LATE = 0x05;
			ProcessLeds();
			//ServiceRequests();
			
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
