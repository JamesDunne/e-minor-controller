//###########################################################################
//#			Author: Joe Dunne											  #
//#			Date 1/27/05					      						  #
//#			PORT DEFINITIONS header file								  #
//#			File Name: c_portdef.h										  #
//#																		  #
//#			Updated 1/27/05 by JD										  #
//############################################################################

#define	INPUT						1
#define	OUTPUT						0

//PORTA Definitions
#define	V_BATT_BIT						0
#define	V_BATT_PIN						PORTAbits.RA0	//Pin 2
#define	V_BATT_LAT_BIT					LATAbits.LATA0
#define	V_BATT_LAT						LATA
#define	V_BATT_PORT						PORTA
#define	TRISA0							(INPUT<<V_BATT_BIT)

#define CHARGER_CURRENT_BIT				1
#define CHARGER_CURRENT_PIN				PORTAbits.RA1	//Pin 3
#define CHARGER_CURRENT_LAT_BIT			LATAbits.LATA1
#define CHARGER_CURRENT_LAT				LATA
#define CHARGER_CURRENT_PORT			PORTA
#define	TRISA1							(INPUT<<CHARGER_CURRENT_BIT)

#define TEMPRATURE_BIT					2
#define TEMPRATURE_PIN					PORTAbits.RA2	//Pin 4
#define TEMPRATURE_LAT_BIT				LATAbits.LATA2
#define TEMPRATURE_LAT					LATA
#define TEMPRATURE_PORT					PORTA
#define	TRISA2							(INPUT<<TEMPRATURE_BIT)

#define V_RMS_BIT						3
#define V_RMS_PIN						PORTAbits.RA3	//Pin 5
#define V_RMS_LAT_BIT					LATAbits.LATA3
#define V_RMS_LAT						LATA
#define V_RMS_PORT						PORTA
#define	TRISA3							(INPUT<<V_RMS_BIT)

#define	SCL_BIT							4
#define	SCL_PIN							PORTAbits.RA4	//Pin 6
#define	SCL_LAT_BIT						LATAbits.LATA4
#define	SCL_LAT							LATA
#define	SCL_PORT						PORTA
#define	LOAD_BANK2_OFF_BIT				4
#define	LOAD_BANK2_OFF_PIN				PORTAbits.RA4	//Pin 6
#define	LOAD_BANK2_OFF_LAT_BIT			LATAbits.LATA4
#define	LOAD_BANK2_OFF_LAT				LATA
#define	LOAD_BANK2_OFF_PORT				PORTA
#define	TRISA4							(OUTPUT<<LOAD_BANK2_OFF_BIT)

#define LOAD_CURRENT_BIT				5
#define LOAD_CURRENT_PIN				PORTAbits.RA5	//Pin 7
#define LOAD_CURRENT_LAT_BIT			LATAbits.LATA5
#define LOAD_CURRENT_LAT				LATA
#define LOAD_CURRENT_PORT				PORTA
#define	TRISA5							(INPUT<<LOAD_CURRENT_BIT)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//PORTB Definitions
#define	INVERTER_CURRENT_LIMIT_BIT		0
#define	INVERTER_CURRENT_LIMIT_PIN		PORTBbits.RB0	//Pin 33
#define	INVERTER_CURRENT_LIMIT_LAT_BIT	LATBbits.LATB0
#define	INVERTER_CURRENT_LIMIT_LAT		LATB
#define	INVERTER_CURRENT_LIMIT_PORT		PORTB
#define	TRISB0							(INPUT<<INVERTER_CURRENT_LIMIT_BIT)

#define	EMERGENCY_POWER_OFF_BIT			1
#define	EMERGENCY_POWER_OFF_PIN			PORTBbits.RB1	//Pin 34
#define	EMERGENCY_POWER_OFF_LAT_BIT		LATBbits.LATB1
#define	EMERGENCY_POWER_OFF_LAT			LATB
#define	EMERGENCY_POWER_OFF_PORT		PORTB
#define	TRISB1							(INPUT<<EMERGENCY_POWER_OFF_BIT)

#define	FAN_ON_BIT						2
#define	FAN_ON_PIN						PORTBbits.RB2	//Pin 35
#define	FAN_ON_LAT_BIT					LATBbits.LATB2
#define	FAN_ON_LAT						LATB
#define	FAN_ON_PORT						PORTB
#define	TRISB2							(OUTPUT<<FAN_ON_BIT)

#define	CUT_BIT							3
#define	CUT_PIN							PORTBbits.RB3	//Pin 36
#define	CUT_LAT_BIT						LATBbits.LATB3
#define	CUT_LAT							LATB
#define	CUT_PORT						PORTB
#define	TRISB3							(OUTPUT<<CUT_BIT)

#define	BOOST1_BIT						4
#define	BOOST1_PIN						PORTBbits.RB4	//Pin 37
#define	BOOST1_LAT_BIT					LATBbits.LATB4
#define	BOOST1_LAT						LATB
#define	BOOST1_PORT						PORTB
#define	TRISB4							(OUTPUT<<BOOST1_BIT)

#define	BOOST2_BIT						5
#define	BOOST2_PIN						PORTBbits.RB5	//Pin 38
#define	BOOST2_LAT_BIT					LATBbits.LATB5
#define	BOOST2_LAT						LATB
#define	BOOST2_PORT						PORTB
#define	TRISB5							(OUTPUT<<BOOST2_BIT)

#define	REGISTER_0_CLK_BIT				6
#define	REGISTER_0_CLK_PIN				PORTBbits.RB6	//Pin 39
#define	REGISTER_0_CLK_LAT_BIT			LATBbits.LATB6
#define	REGISTER_0_CLK_LAT				LATB
#define	REGISTER_0_CLK_PORT				PORTB
#define	LOAD_BANK1_OFF_BIT				6
#define	LOAD_BANK1_OFF_PIN				PORTBbits.RB6	//Pin 39
#define	LOAD_BANK1_OFF_LAT_BIT			LATBbits.LATB6
#define	LOAD_BANK1_OFF_LAT				LATB
#define	LOAD_BANK1_OFF_PORT				PORTB
#define	TRISB6							(OUTPUT<<LOAD_BANK1_OFF_BIT)

#define	SHUTDOWN_OFF_BIT				7
#define	SHUTDOWN_OFF_PIN				PORTBbits.RB7	//Pin 40
#define	SHUTDOWN_OFF_LAT_BIT			LATBbits.LATB7
#define	SHUTDOWN_OFF_LAT				LATB
#define	SHUTDOWN_OFF_PORT				PORTB
#define	TRISB7							(INPUT<<SHUTDOWN_OFF_BIT)

#define	OMNI_RELAY_LAT					LATB
#define	OMNI_RELAY_PORT					PORTB
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//PORTC Definitions
//This pin is double defined, it works in conjuction with the
//ReceptaclesOnChip bit in the NVR. See the NVR map doc (or see the ramdef
//file) for more details. 691160 x001 7/15/04 AR.
#define	LOAD_BANK3_OFF_BIT				0
#define	LOAD_BANK3_OFF_PIN				PORTCbits.RC0	//Pin 15
#define	LOAD_BANK3_OFF_LAT_BIT			LATCbits.LATC0
#define	LOAD_BANK3_OFF_LAT				LATC
#define	LOAD_BANK3_OFF_PORT				PORTC
#define	TRISC0							(OUTPUT<<LOAD_BANK3_OFF_BIT)
#define	REGISTER_1_CLK_BIT				0
#define	REGISTER_1_CLK_PIN				PORTCbits.RC0	//Pin 15
#define	REGISTER_1_CLK_LAT_BIT			LATCbits.LATC0
#define	REGISTER_1_CLK_LAT				LATC
#define	REGISTER_1_CLK_PORT				PORTC
//#define	TRISC0						(OUTPUT<<REGISTER_1_CLK_BIT)

#define	INVERTER_PWM_BIT				1
#define	INVERTER_PWM_PIN				PORTCbits.RC1	//Pin 16
#define	INVERTER_PWM_LAT_BIT			LATCbits.LATC1
#define	INVERTER_PWM_LAT				LATC
#define	INVERTER_PWM_PORT				PORTC
#define	TRISC1							(OUTPUT<<INVERTER_PWM_BIT)

#define	ZEROXING_BIT					2
#define	ZEROXING_PIN					PORTCbits.RC2	//Pin 17
#define	ZEROXING_LAT_BIT				LATCbits.LATC2
#define	ZEROXING_LAT					LATC
#define	ZEROXING_PORT					PORTC
#define	TRISC2							(INPUT<<ZEROXING_BIT)

//VUSB
#define	TRISC3							(INPUT<<3)	//input only

#define	USBDM_BIT						4
#define	USBDM_PIN						PORTCbits.RC4	//Pin 23
#define	USBDM_LAT_BIT					LATCbits.LATC4
#define	USBDM_LAT						LATC
#define	USBDM_PORT						PORTC
#define	TRISC4							(INPUT<<USBDM)		//input only

#define	USBDP_BIT						5
#define	USBDP_PIN						PORTCbits.RC5	//Pin 24
#define	USBDP_LAT_BIT					LATCbits.LATC5
#define	USBDP_LAT						LATC
#define	USBDP_PORT						PORTC
#define	TRISC5							(INPUT<<USBDP_BIT)	//input only

#define	TX_BIT							6
#define	TX_PIN							PORTCbits.RC6	//Pin 25
#define	TX_LAT_BIT						LATCbits.LATC6
#define	TX_LAT							LATC
#define	TX_PORT							PORTC
#define	TRISC6							(INPUT<<TX_BIT)

#define	RX_BIT							7
#define	RX_PIN							PORTCbits.RC7	//Pin 26
#define	RX_LAT_BIT						LATCbits.LATC7
#define	RX_LAT							LATC
#define	RX_PORT							PORTC
#define	TRISC7							(INPUT<<RX_BIT)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//PORTD Definitions
#define	INVERTER_PHASE_A_BIT			0
#define	INVERTER_PHASE_A_PIN			PORTDbits.RD0	//Pin 19
#define	INVERTER_PHASE_A_LAT_BIT		LATDbits.LATD0
#define	INVERTER_PHASE_A_LAT			LATD
#define	INVERTER_PHASE_A_PORT			PORTD
#define	TRISD0							(OUTPUT<<INVERTER_PHASE_A_BIT)

#define	LCR_BIT							1
#define	LCR_PIN							PORTDbits.RD1	//Pin 20
#define	LCR_LAT_BIT						LATDbits.LATD1
#define	LCR_LAT							LATD
#define	LCR_PORT						PORTD
#define	TRISD1							(OUTPUT<<LCR_BIT)

#define	MASTER_RELAY_BIT				2
#define	MASTER_RELAY_PIN				PORTDbits.RD2	//Pin 21
#define	MASTER_RELAY_LAT_BIT			LATDbits.LATD2
#define	MASTER_RELAY_LAT				LATD
#define	MASTER_RELAY_PORT				PORTD
#define	TRISD2							(OUTPUT<<MASTER_RELAY_BIT)

#define	CHARGER_SW_BIT					3
#define	CHARGER_SW_PIN					PORTDbits.RD3	//Pin 22
#define	CHARGER_SW_LAT_BIT				LATDbits.LATD3
#define	CHARGER_SW_LAT					LATD
#define	CHARGER_SW_PORT					PORTD
#define	TRISD3							(OUTPUT<<CHARGER_SW_BIT)

#define LCR_FDBCK_BIT					4
#define LCR_FDBCK_PIN					PORTDbits.RD4	//Pin 27
#define LCR_FDBCK_LAT_BIT				LATDbits.LATD4
#define LCR_FDBCK_LAT					LATD
#define LCR_FDBCK_PORT					PORTD
//#define	TRISA4						(INPUT<<LCR_FDBCK_BIT)
#define	KEEP_ALIVE_BIT					4
#define	KEEP_ALIVE_PIN					PORTDbits.RD4	//Pin 27
#define	KEEP_ALIVE_LAT_BIT				LATDbits.LATD4
#define	KEEP_ALIVE_LAT					LATD
#define	KEEP_ALIVE_PORT					PORTD
#define	TRISD4							(OUTPUT<<KEEP_ALIVE_BIT)
#define LCR_FDBCK_TRIS					TRISD, 4

#define	INVERTER_ON_BIT					5
#define	INVERTER_ON_PIN					PORTDbits.RD5	//Pin 28
#define	INVERTER_ON_LAT_BIT				LATDbits.LATD5
#define	INVERTER_ON_LAT					LATD
#define	INVERTER_ON_PORT				PORTD
#define	TRISD5							(OUTPUT<<INVERTER_ON_BIT)

#define	ON_OFF_SWITCH_BIT				6
#define	ON_OFF_SWITCH_PIN				PORTDbits.RD6	//Pin 29
#define	ON_OFF_SWITCH_LAT_BIT				LATDbits.LATD6
#define	ON_OFF_SWITCH_LAT				LATD
#define	ON_OFF_SWITCH_PORT				PORTD
#define	TRISD6							(INPUT<<ON_OFF_SWITCH_BIT)

#define	TEST_MUTE_SWITCH_BIT			7
#define	TEST_MUTE_SWITCH_PIN			PORTDbits.RD7	//Pin 30
#define	TEST_MUTE_SWITCH_LAT_BIT		LATDbits.LATD7
#define	TEST_MUTE_SWITCH_LAT			LATD
#define	TEST_MUTE_SWITCH_PORT			PORTD
#define	TRISD7							(INPUT<<TEST_MUTE_SWITCH_BIT)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//PORTE Definitions
#define	LINE_SENSITIVITY_BIT			0
#define	LINE_SENSITIVITY_PIN			PORTEbits.RE0	//Pin 8
#define	LINE_SENSITIVITY_LAT_BIT		LATEbits.LATE0
#define	LINE_SENSITIVITY_LAT			LATE
#define	LINE_SENSITIVITY_PORT			PORTE
#define	TRISE_0							(INPUT<<LINE_SENSITIVITY_BIT)

#define	SDA_BIT							1
#define	SDA_PIN							PORTEbits.RE1	//Pin 9
#define	SDA_LAT_BIT						LATEbits.LATE1
#define	SDA_LAT							LATE
#define	SDA_PORT						PORTE
#define	CHARGE_RATE_BIT					1
#define	CHARGE_RATE_PIN					PORTEbits.RE1	//Pin 9
#define	CHARGE_RATE_LAT_BIT				LATEbits.LATE1
#define	CHARGE_RATE_LAT					LATE
#define	CHARGE_RATE_PORT				PORTE
#define	TRISE_1							(INPUT<<CHARGE_RATE_BIT)

#define	AUX_POWER_OFF_BIT				2
#define	AUX_POWER_OFF_PIN				PORTEbits.RE2	//Pin 10
#define	AUX_POWER_OFF_LAT_BIT			LATEbits.LATE2
#define	AUX_POWER_OFF_LAT				LATE
#define	AUX_POWER_OFF_PORT				PORTE
#define	TRISE_2							(OUTPUT<<AUX_POWER_OFF_BIT)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



//-----------------------------------------------------------------------------
//Update history:
