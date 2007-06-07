//This file contains the global ram definitions for the project
#include	"c_system.h"

//----------------------------Main variables----------------------------------------
TwoBytes NVRCommAddr;
TwoBytes RAMCommAddr;
TwoBytes ROMCommAddr;

BitField	CommFlags1;

unsigned char WpmCounter;
unsigned char WpmCounter1;
unsigned char ProgmemBuffer[64];

#pragma udata RamData
BitField ArbFlags1;
BitField MiscFlags1;
BitField DispSegData[5];
unsigned char DispNumOfCommons;
unsigned char LedStates;			//footswitch leds
unsigned long	ButtonState;
unsigned char ExpPedalInst;

TwoBytes ExpPedalAvg;

//----------------------------USB stuff----------------------------------
unsigned char USBDataPointer;
unsigned char USBEP0DataInBuffer[8];
unsigned char RxBuffer[9];
unsigned char TxBuffer[MAX_TX_LENGTH];
unsigned char RxBufPtr;
unsigned char TxBufPtr;
unsigned char TxBufOutPtr;
unsigned char CmdLength;
unsigned char StringPtr;
unsigned char StringPtr_H;
unsigned char StringChksum;
unsigned char ResponseType;

