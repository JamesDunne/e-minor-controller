#include	"c_system.h"

//global ram

#pragma udata RamData


unsigned char Sample;
TwoBytes SampleData;
TwoBytes DataBuffer[220];

//assembly code:
unsigned char EEAddress;



//----------------------------USB stuff----------------------------------
unsigned char TxBufPtr;
unsigned char TxBufOutPtr;
unsigned char CmdLength;
unsigned char RxBufPtr;
unsigned char StringPtr;
unsigned char StringPtr_H;
unsigned char StringChksum;
unsigned char ResponseType;
BitField	CommFlags1;
unsigned char USBDataPointer;
TwoBytes NVRCommAddr;
TwoBytes RAMCommAddr;
TwoBytes ROMCommAddr;
unsigned char USBEP0DataInBuffer[8];
unsigned char	RxBuffer[9];
unsigned char	TxBuffer[64];
TwoBytes tempreg;
unsigned char Temp6;
