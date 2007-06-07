
//-----------------------------------------------------------------------------
//Define variables here
extern unsigned char RxBuffer[MAX_RX_LENGTH];
extern unsigned char TxBuffer[MAX_TX_LENGTH];
extern unsigned char RxBufPtr;
extern unsigned char TxBufPtr;
extern unsigned char TxBufOutPtr;
extern unsigned char CmdLength;
extern unsigned char StringPtr;
extern unsigned char StringPtr_H;
extern unsigned char StringChksum;
extern unsigned char ResponseType;


//---------------------USB stuff---------------------------------
extern unsigned char USBDataPointer;
extern TwoBytes NVRCommAddr;
extern TwoBytes RAMCommAddr;
extern TwoBytes ROMCommAddr;
extern unsigned char USBEP0DataInBuffer[8];




//scope stuff.
extern TwoBytes DataBuffer[220];
extern unsigned char InputDataPointer;


extern unsigned char Sample;
extern TwoBytes SampleData;
extern TwoBytes DataBuffer[220];

extern BitField CommFlags1;
#define	ProcessCommRequest		CommFlags1.bit0
#define	TildeFlg				CommFlags1.bit1
#define	SendingOutString		CommFlags1.bit2
#define	StringInEEPROM			CommFlags1.bit3
#define	USBQuery				CommFlags1.bit4
#define	ServiceEP1Data			CommFlags1.bit5
#define	ProdTestCmdsAllowed		CommFlags1.bit6
#define	StringInRAM				CommFlags1.bit7
