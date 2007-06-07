//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 4/06/07					      						  #
//;#			Main arbitrator									  			  #
//;#			File Name: main.c   										  #
//;#																		  #
//;############################################################################


#include "c_system.h"


void init(void) {
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
}
