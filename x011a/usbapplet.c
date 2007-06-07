
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
{    byte index, counter;


//diag.. test..    
//    if(Testvar)
    if(HIDRxReport((byte*)&dataPacket,sizeof(dataPacket)))
    {
	    Testvar = false;
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
                dataPacket.CMD = 44;
                
                dataPacket._byte[2] = 0x01;
                dataPacket._byte[3] = 0x02;
                counter=64;
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


#define	WRITE_NVR		3
#define	READ_NVR		4

unsigned char PresentCmd;

//This handles data over report ID 44
//Device to host must always follow a host to device
unsigned char	ProcessGenericTransferd2h(void) {
	unsigned char index, cmdrecognized;
	
	cmdrecognized = true;
	
	switch (PresentCmd) {
		case	WRITE_NVR:		//the response to a write nvr request is simply a readback of that data
			for (index=0;index<64;index++) {
				TXENQ(2);
			}
			break;
		case	READ_NVR:		//use address set previously to send out new data
			TXENQ(5);
			TXENQ(6);
			for (index=0;index<62;index++) {
				TXENQ(0);
			}
			break;
		default:
			cmdrecognized = false;
			break;
	}
	return cmdrecognized;
}


//This handles data over report ID 44.	
unsigned char	ProcessGenericTransferh2d(void) {
	unsigned char index, cmdrecognized;
	
	cmdrecognized = true;
	PresentCmd = USBEP0DataInBuffer[1];
	switch (USBEP0DataInBuffer[1]) {
		case	WRITE_NVR:
			
			break;
		case	READ_NVR:
			//address = whatever..
			break;
		default:
			cmdrecognized = false;
			break;
	}
	return cmdrecognized;
}
