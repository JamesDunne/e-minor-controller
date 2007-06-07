
/** I N C L U D E S **********************************************************/
//#include <p18cxxx.h>
#include "c_system.h"
#include "typedefs.h"
#include "usb.h"

void PROCESS_COMM_REQUEST(void);
//void RemCapCalculation(void);

void HIDSetReportHandler(void) {
	USBQuery = true;
	PROCESS_COMM_REQUEST();
	USBQuery = false;	
}
//-----------------------------------------------------------------------
void HIDGetReportHandler(void) {
//load up CtrlTrfData with data.
	USBQuery = true;
	PROCESS_COMM_REQUEST();
	ctrl_trf_session_owner = MUID_HID;
	pSrc.bRam = (byte*)&CtrlTrfData;
	usb_stat.ctrl_trf_mem = _RAM;       // Set memory type
	USBQuery = false;
}

unsigned char EP1Buffer[64];

extern TwoBytes DataBuffer[220];


unsigned char InputDataPointer;

void ServiceEP1(void) {
	BitField ByteToSend, NumBytes;
	unsigned char tempvar1, tempvar0;

	
	ServiceEP1Data = false;

	//report ID 52
	EP1Buffer[0] = 0xB0;				//0th byte is report id
	EP1Buffer[1] = InputDataPointer;

	tempvar1 = 0;
	for (tempvar0 = 0;tempvar0 < 30;tempvar0++) {
		EP1Buffer[tempvar1] = DataBuffer[tempvar0].b_form.low;
		tempvar1++;
		EP1Buffer[tempvar1] = DataBuffer[tempvar0].b_form.high;
		tempvar1++;
	}

	NumBytes.byte = 64;

    if(!mHIDTxIsBusy()) {
//put data on the endpoint:
		HIDTxReport((unsigned char *)&EP1Buffer[0],NumBytes.byte);
	}
}


