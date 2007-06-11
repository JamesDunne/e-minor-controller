//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 4/06/07					      						  #
//;#			Main arbitrator									  			  #
//;#			File Name: main.c   										  #
//;#																		  #
//;############################################################################


#include "c_system.h"
#include "usb.h"


void init(void) {
	CLEAR_RAM();

	LATA = 0;
	LATB = 0;
	LATC = 0;
	LATD = 0;
	LATE = 0;

	TRISA = INIT_TRISA;
	TRISB = INIT_TRISB;
	TRISC = INIT_TRISC;
	TRISD = INIT_TRISD;
	TRISE = INIT_TRISE;

	DispNumOfCommons = DISP_NUMBER_OF_COMMONS;

//	TRISCbits.TRISC6 = false;
//	RCSTA = 0x90;
//	TXSTA = 0xA2;		//0x46;

//	SPBRG = 204;


#ifdef UARTISRS232
//	TRISD = 0x00;		//assert all pins on portd as outputs
//Initialize the USART control registers
	TXSTA = 0xA6;			//master,8bit,async,high speed
	RCSTA = 0x90;			//enabled,8bit, continuous
//	BAUDCONbits.BRG16 = true;
	SPBRG = 16;			//115200 baud
	SPBRGH = 0x01;
#else
//	TRISD = 0x00;		//assert all pins on portd as outputs
//Initialize the USART control registers
	TXSTA = 0xE6;			//master,8bit,async, BRGH=1
	RCSTA = 0x90;			//enabled,8bit, continuous
//	BAUDCONbits.BRG16 = true;
	SPBRG = 63;			//31250 baud
	SPBRGH = 0x00;
#endif

//These constants setup the application's MCU Analog-to-Digital Converter module.
	ADCON0	= 0b01000000;		//AN0, off
	ADCON1	= 0b00001110;		//1 analog channels
	ADCON2	= 0b10000110;		//Right justified, 0 TAD(manual), FOSC/32

//set up timer0 to interrupt at some interval..
	INTCON = INIT_INTCON;
	INTCON2 = INIT_INTCON2;
	RCONbits.IPEN = 1;            //enable priority levels

	TMR0H = 0;                    //clear timer
	TMR0L = 0;                    //clear timer
	T0CON = INIT_T0CON;           //set up timer0

	TMR2 = 0;
	PR2 = INIT_PR2;
	T2CON = INIT_T2CON;				//enable the timer and set up the scalars
	PIE1 = INIT_PIE1;
	INTCONbits.GIEH = 1;          //enable interrupts


	mInitializeUSBDriver();
}
