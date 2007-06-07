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

extern unsigned char InputDataPointer;


void	ServiceUSB(void);

#define	RX_TRIS_BIT		TRISCbits.TRISC7		// Receive direction bit
#define	TX_TRIS_BIT		TRISCbits.TRISC6		// Transmit direction bit

void main() {
	unsigned char i, test;


	for(;;) {
		Sample = ADC_CONVERSION((unsigned char)0x01);		//read channel AN0
		LATD = Sample;

		LATE = 0x55;
		test = 0xAA;
		for (;;) {
			for(i=0;i<220;i++) {
				//ServiceUSB();
				ADC_CONVERSION((unsigned char)0x01);		//read channel AN0
	
//	adcHI = (char)((adcValue >> 5)& 0x1f);	// 0|0|0|d9|d8|d7|d6|d5
//	adcLO = (char)((adcValue & 0x1f)|0x80);	// 1|0|0|d4|d3|d2|d1|d0
				//result in ADRESH:ADRESL
				SampleData.s_form = ADRES;
//				SampleData.b_form.low = (ADRESL&0x1F)|0x80;
	
				DataBuffer[i].s_form = SampleData.s_form;			//store sample in buffer.

				//flicker test leds to indicate sampling rate..
				LATE = ~LATE;

			}
			InputDataPointer = 0;
			do {
				ServiceUSB();
				ADC_CONVERSION((unsigned char)0x01);		//This is just to provide a short delay between sets of TX data.
			} while (InputDataPointer != 255);
		}
	}
}

unsigned char	ADC_CONVERSION(unsigned char Channel) {
	unsigned char tempcntr;
	ADCON0 = Channel;

//Wait for the converter's holding capacitor to charge up.
ADC_CHARGING_DELAY_LOOP:
	for(tempcntr = 10;tempcntr!=0;tempcntr--);

//Start the conversion
	ADCON0bits.GO = true;

//Wait for the conversion to complete, then exit
ADC_CONVERSION_DELAY:
	for(;ADCON0bits.GO;);
	
	return ADRESH;
}



void	ServiceUSB(void) {
	USBCheckBusStatus();                    // Must use polling method
    if(UCFGbits.UTEYE!=1) {
        USBDriverService();                 // Interrupt or polling method
	}
}
