//##############################################################################
//	Test code
//##############################################################################
//------------------------------------------------------------------------------


#include "c_system.h"

#include "usb.h"

unsigned char	ADC_CONVERSION(unsigned char Channel);

extern unsigned char InputDataPointer;


void	ServiceUSB(void);

#define	RX_TRIS_BIT		TRISCbits.TRISC7		// Receive direction bit
#define	TX_TRIS_BIT		TRISCbits.TRISC6		// Transmit direction bit

void main() {
	unsigned char i, test;

	TRISE = 0x00;		//assert all pins on portd as outputs
	TRISD = 0x00;		//assert all pins on portd as outputs
	TRISC = 0xBF;
//	TRISCbits.TRISC6 = false;
//	RCSTA = 0x90;
//	TXSTA = 0xA2;		//0x46;

//	SPBRG = 204;

//	TRISD = 0x00;		//assert all pins on portd as outputs
//Initialize the USART control registers
	TXSTA = 0xA6;			//master,8bit,async,high speed
	RCSTA = 0x90;			//enabled,8bit, continuous
//	BAUDCONbits.BRG16 = true;


//These constants setup the application's MCU Analog-to-Digital Converter module.
	ADCON0	= 0b01000000;		//AN0, off
	ADCON1	= 0b00001001;		//6 analog + 2 digital channels
	ADCON2	= 0b10000110;		//Right justified, 0 TAD(manual), FOSC/32


	SPBRG = 16;			//115200 baud
	SPBRGH = 0x01;


/*
//set up timer0 to interrupt at some interval..
	INTCON = 0x20;                //disable global and enable TMR0 interrupt
	INTCON2 = 0x84;               //TMR0 high priority
	RCONbits.IPEN = 1;            //enable priority levels
	TMR0H = 0;                    //clear timer
	TMR0L = 0;                    //clear timer
	T0CON = 0x82;                 //set up timer0 - prescaler 1:8
	INTCONbits.GIEH = 1;          //enable interrupts
*/

	mInitializeUSBDriver();

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
