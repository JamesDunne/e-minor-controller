//This header file contains the global ram definitions for the project

//----------------------------Main variables----------------------------------------
extern TwoBytes NVRCommAddr;
extern TwoBytes RAMCommAddr;
extern TwoBytes ROMCommAddr;

extern BitField CommFlags1;
#define	ProcessCommRequest		CommFlags1.bit0
#define	TildeFlg				CommFlags1.bit1
#define	SendingOutString		CommFlags1.bit2
#define	StringInEEPROM			CommFlags1.bit3
#define	USBQuery				CommFlags1.bit4
#define	ServiceEP1Data			CommFlags1.bit5
#define	ProdTestCmdsAllowed		CommFlags1.bit6
#define	StringInRAM				CommFlags1.bit7

extern unsigned char ProgmemBuffer[32];
extern TwoBytes	ProgMemAddr;

extern BitField ArbFlags1;
#define Systick		ArbFlags1.bit0
#define	ExpPedalSvc	ArbFlags1.bit1
#define	ButtonsSvc	ArbFlags1.bit2

extern BitField MiscFlags1;
#define	ModeSwitchState		MiscFlags1.bit0

extern BitField DispSegData[5];		//0 = a, 1 = b, etc.. 
extern unsigned char DispNumOfCommons;
extern unsigned char LedStates;			//footswitch leds
extern unsigned long	ButtonState;
extern unsigned char ExpPedalInst;
extern unsigned char SystickCntr;
extern unsigned char SystickCntr2;
extern unsigned char SystickCntr3;

extern unsigned char ScrollingDisplayData[64];
extern unsigned char ScrollingDisplayLength;
extern unsigned char ScrollingDisplayIndex;

//---------------------USB stuff---------------------------------
extern unsigned char USBDataPointer;
extern unsigned char USBEP0DataInBuffer[64];
extern unsigned char ResponseType;

