//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 4/06/07					      						  #
//;#			Main arbitrator									  			  #
//;#			File Name: hwcalls.c   										  #
//;#																		  #
//;############################################################################


#include "c_system.h"
#include "typedefs.h"
#include "hardware.h"

unsigned char	ADC_CONVERSION(unsigned char Channel) {
	unsigned char tempcntr;
	ADCON0 = Channel;

//Wait for the converter's holding capacitor to charge up.
ADC_CHARGING_DELAY_LOOP:
	for(tempcntr = 10;tempcntr!=0;tempcntr--);

//Start the conversion
	ADCON0bits.GO = true;

//Wait for the conversion to complete, then exit
ADC_CONVERSION_DELAY:
	for(;ADCON0bits.GO;);
	
	return ADRESH;
}

/* Send a single MIDI byte. */
void midi_send_byte(u8 data) {
	unsigned char temp;
	//send out first byte.
	TXREG = data;
	temp = PIR1;			//clear TXIF..
	while(!PIR1bits.TXIF);
}

//******************************************************************************
//JDunne 5/27/07 - Converted routine from assembly to C.  (used to be called SEND_TO_LATCHES)
//------------------------------------------------------------------------------
void	SendDataToShiftReg(unsigned char dataToSend) {
	unsigned char DataCounter;
//SEND_SPEC_TO_LATCHES
	DataCounter = 8;								//Load number of bits to be transfered

//	bcf	SRCK_LAT_BIT						//Control clock signal, also prevent IIC start
	SHIFTREG_RCK_LAT_BIT = true;			//Flush out garbage
	SHIFTREG_RCK_LAT_BIT = false;

//STL_TRANSMIT_BIT
	do {
		SHIFTREG_SRCK_LAT_BIT = false;				//Clear strobe pin
		if (!chkbit(dataToSend, 7)) {		//MSB high?
			SHIFTREG_SER_IN_LAT_BIT = false;		//No, set data signal low
		}
		else {								//MSB low?
			SHIFTREG_SER_IN_LAT_BIT = true;		//No, release data signal
		}
		dataToSend <<=1;					//Shift next bit to MSB position
		SHIFTREG_SRCK_LAT_BIT = true;

//STL_RESET_CLOCK_LEVEL
	} while (--DataCounter!=0);				//All 8 bits transfered? No, go transfer next bit

//STL_STROBE
	SHIFTREG_RCK_LAT_BIT = true;			//Strobe the data

//STL_STROBE_DELAY
	for (DataCounter = LATCH_STROBE_DELAY; DataCounter !=0;DataCounter--);		//Pause for data transfer from external latch_1's input to its output

	SHIFTREG_RCK_LAT_BIT = false;
	SHIFTREG_SER_IN_LAT_BIT = true;				//Release data signal
	SHIFTREG_SRCK_LAT_BIT = true;			//Release serial clk
}
//------------------------------------------------------------------------------

//returns data into ButtonState.
void	ReadButtons(void) {
	unsigned char BtnAddress, bitloc, i;
	BitField TempButtons;

//the following only reads 7 buttons from the multiplexor, and the 8th from the pin directly.
//the 7th bit of the multiplexor is the modeswitch which is read below.
	bitloc = 1;
	TempButtons.byte = 0;
	for (BtnAddress = 0;BtnAddress<=6;BtnAddress++) {
		SetDipAddress(BtnAddress);

		for (i = BTN_SAMPLE_DELAY;i!=0;i--);		//delay for a sampling delay

		if (BTN_IN_PIN) TempButtons.byte |= bitloc;		//Or in the current bit if it is set.
		bitloc <<= 1;										//shift the bit over to the next
	}

	ButtonState = TempButtons.byte;
	ButtonState <<=1;			//shift everything over one because the 0th bit is supposed
								//to be PRESET_1, which is on another pin.

	ButtonState |= 0xFFFFFF00;
	if (BTN_PRESET_1_PIN) setbit(ButtonState,0);

	//all buttons are backwards logic, so simply invert the state of ButtonState.
	ButtonState = ~ButtonState;

	//read the 7th bit of the shift register.  (Which is the slider mode switch)
	BtnAddress = 0x07;
	SetDipAddress(BtnAddress);
	ModeSwitchState = true;
	if (BTN_IN_PIN) ModeSwitchState = false;
}

///Average = ((Inst-Avg)/(2^Tau))+Avg
TwoBytes Filtered2SampleAvg(TwoBytes Avg, unsigned char Inst, unsigned char Tau) {
	unsigned char positive;
	TwoBytes diff;

	diff.s_form = 0;
	if (Inst >= Avg.b_form.high) {
		diff.b_form.high = Inst - Avg.b_form.high;
		setbit(positive,0);
	}
	else {
		diff.b_form.high = Avg.b_form.high - Inst;
		clrbit(positive,0);
	}

	diff.s_form >>= Tau;

	if (chkbit(positive,0)) {
		Avg.s_form += diff.s_form;
	}
	else {
		Avg.s_form -= diff.s_form;
	}
	return Avg;
}

void	Write64BytesProgMem(rom unsigned char *RomPtr, unsigned char *RamPtr) {
	TBLPTR = (unsigned long)RomPtr;
	FSR0 = (unsigned short)RamPtr;
	WRITE_BLOCK_INTO_ROM();
}

void	SetDipAddress(unsigned char Address) {
	BTN_S0_LAT_BIT = false;
	BTN_S1_LAT_BIT = false;
	BTN_S2_LAT_BIT = false;
	if (chkbit(Address,0)) BTN_S0_LAT_BIT = true;
	if (chkbit(Address,1)) BTN_S1_LAT_BIT = true;
	if (chkbit(Address,2)) BTN_S2_LAT_BIT = true;
}

/* --------------- LED read-out display functions: */
u32 fsw_poll(){
	FourBytes TempButtons;

	TempButtons.l_form = 0;
	TempButtons.b_form.byte3 = ButtonState&0xF0;
	TempButtons.b_form.byte0 = ButtonState&0x0F;

	return TempButtons.l_form;
}

void	UpdateLeds(void) {
	SendDataToShiftReg(LedStates);
}
/* Set currently active program foot-switch's LED indicator and disable all others */
void fsw_led_set_active(int idx){
	LedStates = 0;
	setbit(LedStates,idx);
}

/* Explicitly enable a single LED without affecting the others */
void fsw_led_enable(int idx){
	setbit(LedStates,idx);
}

/* Explicitly disable a single LED without affecting the others */
void fsw_led_disable(int idx){
	clrbit(LedStates,idx);
}

/* Poll the slider switch to see which mode we're in: */
u8 slider_poll(){
	return	ModeSwitchState;
}

/* Poll the expression pedal's data (0-127): */
u8 expr_poll(){
	
	ADC_CONVERSION(EXP_PEDAL_CHANNEL);
}

/* --------------- Data persistence functions: */

/* Gets number of stored banks */
u16 banks_count(){
}

/* Loads a bank into the specified arrays: */
void bank_load(u16 bank_index, char name[BANK_NAME_MAXLENGTH], u8 bank[BANK_PRESET_COUNT], u8 bankcontroller[BANK_PRESET_COUNT], u8 bankmap[BANK_MAP_COUNT], u8 *bankmap_count){
}

/* Stores the programs back to the bank: */
void bank_store(u16 bank_index, u8 bank[BANK_PRESET_COUNT], u8 bankcontroller[BANK_PRESET_COUNT], u8 bankmap[BANK_MAP_COUNT], u8 bankmap_count){
}

/* Load bank name for browsing through banks: */
void bank_loadname(u16 bank_index, char name[BANK_NAME_MAXLENGTH]){
}

/* Get the alphabetically sorted bank index */
u16 bank_getsortedindex(u16 sort_index){
}

/* --------------- MIDI I/O functions: */

/* Send formatted MIDI commands.

    0 <= cmd <= F       - MIDI command
    0 <= channel <= F   - MIDI channel to send command to
    00 <= data1 <= FF   - first data byte of MIDI command
    00 <= data2 <= FF   - second (optional) data byte of MIDI command
*/
void midi_send_cmd1(u8 cmd, u8 channel, u8 data1){
}

void midi_send_cmd2(u8 cmd, u8 channel, u8 data1, u8 data2){
}



