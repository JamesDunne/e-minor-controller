//This file contains the global ram definitions for the project
#include	"c_system.h"

//----------------------------Main variables----------------------------------------
TwoBytes NVRCommAddr;
TwoBytes RAMCommAddr;
TwoBytes ROMCommAddr;

BitField	CommFlags1;

unsigned char ProgmemBuffer[32];
TwoBytes	ProgMemAddr;

#pragma udata RamData
BitField ArbFlags1;
BitField MiscFlags1;
BitField DispSegData[5];
unsigned char DispNumOfCommons;
unsigned char LedStates;			//footswitch leds
unsigned long	ButtonState;
unsigned char ExpPedalInst;
unsigned char SystickCntr;
unsigned char SystickCntr2;
unsigned char SystickCntr3;

unsigned char ScrollingDisplayData[64];
unsigned char ScrollingDisplayLength;
unsigned char ScrollingDisplayIndex;

TwoBytes ExpPedalAvg;

//----------------------------USB stuff----------------------------------
unsigned char USBDataPointer;
unsigned char USBEP0DataInBuffer[64];
unsigned char ResponseType;

