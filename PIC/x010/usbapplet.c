
/** I N C L U D E S **********************************************************/
#include "p18f4455.h"
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

/*
void ServiceEP1(void) {
	ServiceEP1Data = false;

	BitField ByteToSend, NumBytes;
	unsigned char tempvar1, tempvar0;

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
*/

typedef union DATA_PACKET
{
    byte _byte[HID_INT_OUT_EP_SIZE];  //For byte access
    word _word[HID_INT_OUT_EP_SIZE/2];//For word access(USBGEN_EP_SIZE msut be even)
    struct
    {
        enum
        {
            READ_VERSION    = 0x00,
            /*
            READ_FLASH      = 0x01,
            WRITE_FLASH     = 0x02,
            ERASE_FLASH     = 0x03,
            READ_EEDATA     = 0x04,
            WRITE_EEDATA    = 0x05,
            READ_CONFIG     = 0x06,
            WRITE_CONFIG    = 0x07,
            */
            ID_BOARD        = 0x31,
            UPDATE_LED      = 0x32,
            SET_TEMP_REAL   = 0x33,
            RD_TEMP         = 0x34,
            SET_TEMP_LOGGING= 0x35,
            RD_TEMP_LOGGING = 0x36,
            RD_POT          = 0x37,
            RESET           = 0xFF
        }CMD;
        byte len;
    };
    struct
    {
        unsigned :8;
        byte ID;
    };
    struct
    {
        unsigned :8;
        byte led_num;
        byte led_status;
    };
    struct
    {
        unsigned :8;
        word word_data;
    };
} DATA_PACKET;

DATA_PACKET dataPacket;

void ServiceRequests(void)
{
    byte index, counter;
    
    if(HIDRxReport((byte*)&dataPacket,sizeof(dataPacket)))
    {
        counter = 0;
        switch(dataPacket.CMD)
        {
            case READ_VERSION:
                //dataPacket._byte[1] is len
                dataPacket._byte[2] = 0x01;
                dataPacket._byte[3] = 0x02;
                counter=0x04;
                break;

            default:
                //dataPacket._byte[1] is len
                dataPacket._byte[2] = 0x01;
                dataPacket._byte[3] = 0x02;
                counter=0x05;
                break;

                break;
        }//end switch()
        if(counter != 0)
        {
            if(!mHIDTxIsBusy())
                HIDTxReport((byte*)&dataPacket,counter);
        }//end if
    }//end if

}//end ServiceRequests


