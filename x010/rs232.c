//###############################################################################
//#										       						       		#
//#			Author: Joe Dunne											 		#
//#			RS232 Communication ROUTINE											#
//#			File Name: RXCOMM.ASM												#
//#																				#
//#			Updated 2/02/05 by JD												#
//#									      	       	       	       	       		#
//###############################################################################

#include	"c_system.h"
#include "typedefs.h"
#include "usb.h"


#define	FW_REV						0x10

#define	UPS_TYPE					(2|FW_REV)
#define	INVALID_REQUEST				0xff
#define	PRODUCTION_TEST_PROTOCOL	0x0003

extern rom struct{byte bLength;byte bDscType;word string[];}SerialNum;
extern rom struct{byte bLength;byte bDscType;word string[24];}MfrString;

void	RemCapCalculation(void);
void	EE_READ(void);
void	D_DIV(void);
void	SQRT_16BIT(void);		//result is stored in RES0.
void	HIDGetReportHandler(void);
unsigned char	READ_SYSTEM_NVR(void);
void	EE_PAGE_WRITE(void);
void	BOOT_LOAD_MODE(void);



//--------------------------------------------------------------
//						Handle received query
//--------------------------------------------------------------
void	PROCESS_COMM_REQUEST(void) {
	unsigned char *RcvPtr;
	unsigned char tempvar1, tempvar0;
	far unsigned char *Data;
	BitField ByteToSend;
	TwoBytes tempreg, tempnum0, value;
	FourBytes longreg;

	ResponseType = 0xFF;		//no response

	if (!USBQuery) {
		//RS232 query
		ProcessCommRequest = false;
		//Prevent any communication in progress from being messed up.
		if (TxBufPtr != 0) return;
		SendingOutString = false;
		StringInEEPROM = false;
		TxBufPtr = 4;			//the header will be written later.
		RcvPtr = (unsigned char *)&RxBuffer[4];
	}
	else {
		//USB query
		USBDataPointer = 1;		//the 0th byte is the reportid
		RcvPtr = (unsigned char *)&USBEP0DataInBuffer[1];
	}


//Polling command:
	if (!USBQuery && RxBuffer[1] == 0x03 || \
		USBQuery && SetupPkt.bRequest == GET_REPORT) {
		switch ((USBQuery?SetupPkt._byte[2]:RxBuffer[3])) {

		case 13:
		case 14:
		case 40:
			//iProduct
			ResponseType = DATA_RETURNED;
			TxBuffer[2] = 22;			//number of bytes in response
			if (USBQuery) {
				TXENQ(INDEX_NAME);
				break;
			}
			TxBufPtr = TxBuffer[2]+4;					//override txbuffer pointer.
			StringChksum = RxBuffer[3]+(TxBufPtr-4)+HEADER_CHAR+DATA_RETURNED;
			SendingOutString = true;
			StringInEEPROM = true;
			StringInRAM = false;
			StringPtr = EE_USB_ID_STRING+2;	//Send out product string.
			break;
		case 41:
			//iSerialNumber
			ResponseType = DATA_RETURNED;
			TxBuffer[2] = 17;			//number of bytes in response
			if (USBQuery) {
				TXENQ(INDEX_SERIALNUM);
				break;
			}
			TxBufPtr = TxBuffer[2]+4;					//override txbuffer pointer.
			StringChksum = RxBuffer[3]+(TxBufPtr-4)+HEADER_CHAR+DATA_RETURNED;
			SendingOutString = true;
			StringInEEPROM = false;
			StringInRAM = true;
			tempreg.s_form = (unsigned short)(&SerialNum)+2;
			StringPtr_H = tempreg.b_form.high;
			StringPtr = tempreg.b_form.low;	//Send out serial string.
			break;
		case 98:	//iOEMInformation
		case 43:	//iManufacturer
			ResponseType = DATA_RETURNED;
			TxBuffer[2] = 12;			//number of bytes in response
			if (USBQuery) {
				TXENQ(INDEX_MANUFACTURER);
				break;
			}
			TxBufPtr = TxBuffer[2]+4;					//override txbuffer pointer.
			StringChksum = RxBuffer[3]+(TxBufPtr-4)+HEADER_CHAR+DATA_RETURNED;
			SendingOutString = true;
			StringInEEPROM = false;
			StringInRAM = false;
			tempreg.s_form = (unsigned short)&MfrString;
			StringPtr_H = tempreg.b_form.high;
			StringPtr = tempreg.b_form.low;	//Send out serial string.
			break;

//production test commands:			
		case 150:		//NVR Read
			ResponseType = DATA_RETURNED;
			if (1 && !PIE2bits.EEIE) { 
//				EEAddress = NVRCommAddr.b_form.low;
//				DISABLE_ALL_INTERRUPTS();
//				Temp6 = READ_SYSTEM_NVR();		//returns data through wreg
//				ENABLE_ALL_INTERRUPTS();
//				TXENQ(Temp6);
			}
			else {
				ResponseType = COMMAND_REJECTED;
				TXENQ(INVALID_REQUEST);
			}
			break;
			
		case 151:		//NVR Address
			ResponseType = DATA_RETURNED;
			if (1) { 
				TXENQ(NVRCommAddr.b_form.low);		//low byte
				TXENQ(NVRCommAddr.b_form.high);		//high byte
			}
			else {
				ResponseType = COMMAND_REJECTED;
				TXENQ(INVALID_REQUEST);		//low byte
				TXENQ(INVALID_REQUEST);		//high byte
			}
			break;
		case 152:		//RAM Read
			ResponseType = DATA_RETURNED;
			if (1) { 
				Data = (far unsigned char *)RAMCommAddr.s_form;
				TXENQ(*Data);
			}
			else {
				ResponseType = COMMAND_REJECTED;
				TXENQ(INVALID_REQUEST);
			}
			break;
	
		case 153:		//RAM Address
			ResponseType = DATA_RETURNED;
			if (1) { 
				TXENQ(RAMCommAddr.b_form.low);		//low byte
				TXENQ(RAMCommAddr.b_form.high);		//high byte
			}
			else {
				ResponseType = COMMAND_REJECTED;
				TXENQ(INVALID_REQUEST);
				TXENQ(INVALID_REQUEST);
			}
			break;
	
		case 156:		//ROM Read
			ResponseType = DATA_RETURNED;
			if (1) { 
				TXENQ(*(near unsigned char rom *)ROMCommAddr.s_form);
			}
			else {
				ResponseType = COMMAND_REJECTED;
				TXENQ(INVALID_REQUEST);
			}
			break;
	
		case 157:		//ROM Address
			ResponseType = DATA_RETURNED;
			if (1) { 
				TXENQ(ROMCommAddr.b_form.low);		//low byte
				TXENQ(ROMCommAddr.b_form.high);		//high byte
			}
			else {
				ResponseType = COMMAND_REJECTED;
				TXENQ(INVALID_REQUEST);
				TXENQ(INVALID_REQUEST);
			}
			break;


		case 155:		//production test protocol
			ResponseType = DATA_RETURNED;
			TXENQ(PRODUCTION_TEST_PROTOCOL&255);
			//TXENQ(PRODUCTION_TEST_PROTOCOL/256);
			TXENQ(PRODUCTION_TEST_PROTOCOL>>8);
			break;
	
		case 175:		//voltage data
			ResponseType = DATA_RETURNED;
			TXENQ(0);
			TXENQ(0);
			TXENQ(0);
			TXENQ(0);
			break;

		case 180:		//NVR Page Read
			ResponseType = DATA_RETURNED;
			if (1 && !PIE2bits.EEIE) {
				DISABLE_ALL_INTERRUPTS();
//				EEAddress = NVRCommAddr.b_form.low;
//				Temp6 = READ_SYSTEM_NVR();
//				TXENQ(Temp6);
//				EEAddress++;
//				Temp6 = READ_SYSTEM_NVR();
//				TXENQ(Temp6);
//				EEAddress++;
//				Temp6 = READ_SYSTEM_NVR();
//				TXENQ(Temp6);
//				EEAddress++;
//				Temp6 = READ_SYSTEM_NVR();
//				TXENQ(Temp6);
//				ENABLE_ALL_INTERRUPTS();
				break;
			}
			else {
				ResponseType = COMMAND_REJECTED;
				TXENQ(INVALID_REQUEST);
				TXENQ(INVALID_REQUEST);
				TXENQ(INVALID_REQUEST);
				TXENQ(INVALID_REQUEST);
				break;
			}				
		default:
			break;
		}
	}

//Set command:
	if (!USBQuery && RxBuffer[1] == 0x04 || \
		USBQuery && SetupPkt.bRequest == SET_REPORT) {
		switch ((USBQuery?SetupPkt._byte[2]:RxBuffer[3])) {
/*
		case 17:
			//AudibleAlarmControl
			if (RcvPtr[0] == 3) {
				MuteBeeper = true;
				ResponseType = COMMAND_ACCEPTED;
			}
			else ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);			//data
			break;
		case 16:		//Test
			if (MASTER_RELAY_LAT_BIT && LineValid) {	//check if Master receptacles off or Line invalid?
				if (RcvPtr[0] == 1) {
					RequestSelfTest = true;
					ResponseType = COMMAND_ACCEPTED;
				}
			}
			else ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);			//data
			break;
		case 21:		//DelayBeforeShutdown
			if (ContactClosureShutdownLatch || SelfTestMode) {
				ResponseType = COMMAND_REJECTED;
				TXENQ(RcvPtr[0]);			//data
				TXENQ(RcvPtr[1]);			//data
				break;
			}
			else ResponseType = COMMAND_ACCEPTED;
			TXENQ(RcvPtr[0]);			//data
			TXENQ(RcvPtr[1]);			//data

			PreDelayHighByte = RcvPtr[1];		//Store high byte value
			PreDelayLowByte = RcvPtr[0];		//Store low byte value
			PreDelayCntr_H = PreDelayHighByte;		//Load high byte counter
			PreDelayCntr_L = PreDelayLowByte;		//Load low byte counter

			if (RcvPtr[0] == 0xff && RcvPtr[1] == 0xff) {
				//Abort the inverter shutdown command
				CountOutPreDelay = false;
				RequestUnitShutDown = false;
				break;
			}
			if (RcvPtr[0] == 0 && RcvPtr[1] == 0) {
				PreDelayLowByte = DEFAULT_PREDELAY;		//load default predelay
				PreDelayCntr_L = PreDelayLowByte;		//Load low byte counter
			}
			RequestUnitShutDown = true;
			CountOutPreDelay = true;
			break;
		case 23:		//DelayBeforeReboot
			if (InverterON || Standby) {
				ResponseType = COMMAND_REJECTED;
			}
			else {
				ResponseType = COMMAND_ACCEPTED;
				RebootCounter = RcvPtr[0];
				RebootCounter_H = RcvPtr[1];
				RequestReboot = true;		//Request all active power outlets be turned off for 10 seconds
			}
			TXENQ(RcvPtr[0]);			//data
			TXENQ(RcvPtr[1]);			//data
			break;
		case 22:	//DelayBeforeStartup (vendor defined) (minutes)
		case 97:	//DelayBeforeStartup (seconds)
			if (ContactClosureShutdownLatch || SelfTestMode || !BatteryOK) {
				ResponseType = COMMAND_REJECTED;
				TXENQ(RcvPtr[0]);			//data
				TXENQ(RcvPtr[1]);			//data
				break;
			}
			else ResponseType = COMMAND_ACCEPTED;
			TXENQ(RcvPtr[0]);			//data
			TXENQ(RcvPtr[1]);			//data

			if (RcvPtr[3] == 22) {				//data is in minutes, so convert to seconds.
				tempreg.b_form.low = RcvPtr[0];
				tempreg.b_form.high = RcvPtr[1];
				longreg.l_form = tempreg.s_form*60;		//overflow not possible
				DelayedWUCntr_H = longreg.b_form.byte2;
				DelayedWUCntr_M = longreg.b_form.byte1;
				DelayedWUCntr_L = longreg.b_form.byte0;
			}
			else {									//data is in seconds, so just copy it over.
				DelayedWUCntr_H = 0;
				DelayedWUCntr_M = RcvPtr[1];
				DelayedWUCntr_L = RcvPtr[0];
			}
			
			if (RcvPtr[0] == 0xff && RcvPtr[1] == 0xff) {	//cancel command
				CountOutPreDelay = false;
				RequestUnitShutDown = false;	//Abort the inverter shutdown command
				DelayedWakeup = false;
			}

			if (DelayedWUCntr_L == 0 && DelayedWUCntr_M == 0 && DelayedWUCntr_H == 0) {
				DelayedWUCntr_L = 2;			//load default wakeup predelay
			}

			if (PreDelayCntr_H == 0 && PreDelayCntr_L == 0 || !MASTER_RELAY_LAT_BIT || !RequestUnitShutDown) {
				PreDelayCntr_H = 0;
				PreDelayCntr_L = DEFAULT_PREDELAY;	//load default predelay
			}
			
			if (!DelayedWakeup) {			//if we are not already in delayed wakeup..
				RequestDelayedWakeUp = true;
				CountOutPreDelay = true;
			}
			break;
		case 82:	//Watchdog
			if (RcvPtr[0] != 0) {
				ResponseType = COMMAND_ACCEPTED;
				ComWatchValue = RcvPtr[0];		//load watchdog counter.
				ComWatchCntr = ComWatchValue;
			}
			else ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);			//data
			break;
		case 105:	//SwitchOutletControlMap
			if (!CountOutPreDelay && !SelfTestMode) {
				ResponseType = COMMAND_ACCEPTED;
				ReceptacleStatus = ~RcvPtr[0];		//load desired outlet state.
				RequestOutletChange = true;
				CountOutPreDelay = true;
			}
			else ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);			//data
			break;	

		case 193:	//EnterBootload mode
			if (Standby) {
				if (RcvPtr[0] == 0xF6 && \
					RcvPtr[1] == 0x8C && \
					RcvPtr[2] == 0x2A && \
					RcvPtr[3] == 0x6B) {
						
//exit UPS functionality and enter bootload mode.
					DISABLE_ALL_INTERRUPTS();
					_asm	goto	BOOT_LOAD_MODE	_endasm
						
				} 
			}
			ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);			//data
			TXENQ(RcvPtr[1]);			//data
			TXENQ(RcvPtr[2]);			//data
			TXENQ(RcvPtr[3]);			//data
			break;	
*/			
//Production test commands
		case 150:		//NVR Write
			ResponseType = COMMAND_ACCEPTED;
			if (1 && !PIE2bits.EEIE) { 
//				DISABLE_ALL_INTERRUPTS();
//				EECounterB = 1;						//Number of bytes to write.
//				EEAddress = NVRCommAddr.b_form.low;	//EEPROM register starting address byte.
//				EEData = RcvPtr[0];					//First byte of data to write.
//diag disable ee_page_write
//				EE_PAGE_WRITE();
//				ENABLE_ALL_INTERRUPTS();
			}
			else ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);			//data
			break;
			
		case 151:		//NVR Address
			ResponseType = COMMAND_ACCEPTED;
			if (1) { 
				NVRCommAddr.b_form.low = RcvPtr[0];		//low byte
				NVRCommAddr.b_form.high = RcvPtr[1];	//high byte
			}
			else ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);			//data
			TXENQ(RcvPtr[1]);			//data
			break;
		case 152:		//RAM Write
			ResponseType = COMMAND_ACCEPTED;
			*(far unsigned char *)RAMCommAddr.s_form = RcvPtr[0];
			TXENQ(RcvPtr[0]);			//data
			break;
	
		case 153:		//RAM Address
			ResponseType = COMMAND_ACCEPTED;
			RAMCommAddr.b_form.low = RcvPtr[0];		//low byte
			RAMCommAddr.b_form.high = RcvPtr[1];	//high byte
			TXENQ(RcvPtr[0]);			//data
			TXENQ(RcvPtr[1]);			//data
			break;
		case 154:		//Password write (starting with low byte)
			ResponseType = COMMAND_ACCEPTED;
			if (RcvPtr[0] == 0x42 && \
				RcvPtr[1] == 0x19 && \
				RcvPtr[2] == 0x6E && \
				RcvPtr[3] == 0x86) {
				ProdTestCmdsAllowed = true;
			}
			//don't report command rejected because it'll make it easy to break the password.
			TXENQ(RcvPtr[0]);			//data
			TXENQ(RcvPtr[1]);			//data
			TXENQ(RcvPtr[2]);			//data
			TXENQ(RcvPtr[3]);			//data
			break;
		case 156:		//ROM Write (not supported)
//Writing a single byte is not supported by the chip.
			ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);			//data
			break;
	
		case 157:		//ROM Address
			ResponseType = COMMAND_ACCEPTED;
			if (1) { 
				ROMCommAddr.b_form.low = RcvPtr[0];		//low byte
				ROMCommAddr.b_form.high = RcvPtr[1];	//high byte
			}
			else ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);			//data
			TXENQ(RcvPtr[1]);			//data
			break;

		case 180:		//NVR Page Write
			ResponseType = COMMAND_ACCEPTED;
//			if (1 && !PIE2bits.EEIE && !RETRY_EEPROM_WRITE) {
//				DISABLE_ALL_INTERRUPTS();
//				EECounterB = 4;						//Number of bytes to write.
//				EEAddress = NVRCommAddr.b_form.low;	//EEPROM register starting address byte.
//				EEData = RcvPtr[0];					//First byte of data to write.
//				EEData1 = RcvPtr[1];				//Second byte of data to write.
//				EEData2 = RcvPtr[2];				//Third byte of data to write.
//				EEData3 = RcvPtr[3];				//Fourth byte of data to write.
//diag.. disable ee_page_write
//				EE_PAGE_WRITE();
//				ENABLE_ALL_INTERRUPTS();
//			}
//			else ResponseType = COMMAND_REJECTED;
			TXENQ(RcvPtr[0]);
			TXENQ(RcvPtr[1]);
			TXENQ(RcvPtr[2]);
			TXENQ(RcvPtr[3]);
			break;
		default:
			break;
		}
	}

	if (USBQuery) {
		if (ResponseType == 0xff) return;
//no response or ack?
		if (SetupPkt.bRequest == SET_REPORT) return;		//no response to set_report

		//USB query setup data:
		CtrlTrfData._byte[0] = SetupPkt._byte[2];
		wCount._word = USBDataPointer;		//Calculate number of bytes to send
		return;
	}
	else {
		//RS232 query setup data:
		TxBuffer[0] = HEADER_CHAR;
		TxBuffer[1] = ResponseType;
		TxBuffer[3] = RxBuffer[3];				//report ID.

		if (!SendingOutString) TxBuffer[2] = TxBufPtr-3;			//calculate the length of data returned
		//else TxBuffer[2] already written

		//if we've enqueued a byte, this indicates that the command was accepted.
		//In that case, we should compute the checksum and send the data out.
			if (!SendingOutString) {
				if (TxBufPtr > 2) {		
				//We've enqueued all other bytes, so write the checksum:
					tempvar0 = 0;
					for (tempvar1 = 0;tempvar1 < TxBufPtr;tempvar1++) {
						tempvar0 += TxBuffer[tempvar1];
					}
					TXENQ(tempvar0);			//enqueue checksum as final byte to send out.
					return;		//and exit
				}
			}
		//If the type of command received is neither a poll nor set command, 
		//or we dont recognize the reportID, cancel the command because it 
		//is not recognized.
		TildeFlg = false;					//reset colon-received flag.
		RxBufPtr = 0;						//Reset buffer.
		CmdLength = 0;
	}
	return;
}

//-----------------------------------------------------------------------
//This routine will store a character into the TxBuffer.
void	TXENQ(unsigned char Input) {
	if (!USBQuery) {
		//RS232 Query
		if (TxBufPtr >= MAX_TX_LENGTH) return;		//Exit if buffer full.
		TxBuffer[TxBufPtr] = Input;	//Store value in buffer.
		TxBufPtr++;					//Update input ptr.
	}
	else {
		//USB Query
		if (USBDataPointer >= 64) return;		//Exit if buffer full.
		CtrlTrfData._byte[USBDataPointer] = Input;
		USBDataPointer++;
	}
}
//-----------------------------------------------------------------------
//Reset TX Buffer.
void	RTXB(void) {
	TxBufPtr = 0;		//Point to buffer start.
	TxBufOutPtr = 0;		//Point to buffer start.
}
