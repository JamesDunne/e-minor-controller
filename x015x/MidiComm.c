//*;###########################################################################
//;#			Author: Joe Dunne											  #
//;#			Date 5/28/07					      						  #
//;#			Midi Comm routine								  			  #
//;#			File Name: midicomm.c  										  #
//;#																		  #
//;############################################################################

void	RS232_COMM_ROUTINE() {
	unsigned char tReceivedChar, tempvar1, tempvar0;
	unsigned short RAMPtr;

//Check if we received a character:	
	if (!chkbit(SCISR, 5)) {
//If no character is received, check if any data is pending transmission
		if (TxBufOutPtr == TxBufPtr) {
			RTXB();						//no data to send, so reset transmit buffer.
			return;			//and exit
		}

//--------------------------------------------------------------
//						Handle transmitting responses
//--------------------------------------------------------------

		if (!chkbit(SCISR, 7)) return;	//USART transmit buffer full

		if (SendingOutString) {
			if (TxBufOutPtr > 3) {		//initial framing bytes sent as normal
				if (TxBufOutPtr == TxBufPtr-1) {	//checksum character
					clrbit(SCISR, 7);					//allow data to be transferred to the shift register.
					SCIDR = StringChksum;
					TxBufOutPtr++;
					return;
				}
				RAMPtr = StringPtr;
				RAMPtr += TxBufOutPtr*2 - 8;
				tempvar0 = *(unsigned char *)RAMPtr;
				clrbit(SCISR, 7);					//allow data to be transferred to the shift register.
				SCIDR = tempvar0;
				StringChksum += tempvar0;
				TxBufOutPtr++;
				return;
			}
		}			

//SCIDR doubles as both TXREG and RCREG
		clrbit(SCISR, 7);					//allow data to be transferred to the shift register.
		SCIDR = TxBuffer[TxBufOutPtr];		//Get character from buffer and store in transmit reg.  
		TxBufOutPtr++;							//increment transmit out pointer.
		return;						//exit
	}

//handle the received character:
	tempvar0 = SCISR;
//	if (RCSTAbits.OERR || RCSTAbits.FERR) {		//Overrun or framing error?
//		RCSTAbits.CREN = false;
//		tempvar1 = RCREG;
//		tempvar1 = RCREG;
//		RCSTAbits.CREN = true;
//		TildeFlg = false;
//		return;
//	}

//--------------------------------------------------------------
//						Handle receiving queries
//--------------------------------------------------------------

	tReceivedChar = SCIDR;		//read received byte

	if (!TildeFlg) {
		if (tReceivedChar == HEADER_CHAR) {		//check if we received header byte
			TildeFlg = true;
			CmdLength = 0;
			RxBufPtr = 1;
			RxBuffer[0] = tReceivedChar;		//store tilde character also..
		}
		return;
	}

//check for overflow
	if (RxBufPtr > MAX_RX_LENGTH) {
		TildeFlg = false;					//reset colon-received flag.
		RxBufPtr = 0;						//Reset buffer.
		CmdLength = 0;
	}
	
	RxBuffer[RxBufPtr] = tReceivedChar;		//store received character.
	RxBufPtr++;

//Check if we've received all of the bytes in the packet:
	if (RxBufPtr >= 5 && RxBufPtr == CmdLength+4) {			//the 4 is the number of framing bytes
		tempvar0 = 0;
//We've received all the bytes, so check the checksum:
		for (tempvar1 = 0;tempvar1 < RxBufPtr-1;tempvar1++) {
			tempvar0 += RxBuffer[tempvar1];
		}
//Reset RX registers.
		TildeFlg = false;					//reset colon-received flag.
		RxBufPtr = 0;						//Reset buffer.
		CmdLength = 0;
	
//Exit if checksum is invalid:
		if (tempvar0 != RxBuffer[tempvar1]) return;
//Checksum is valid, so request processing of the query.
		ProcessCommRequest = true;				
		uWatchDogCounter = uWatchDogDelay;		//reset watchdog timer
		return;
	}
//we haven't received all the characters yet.
	if (RxBufPtr == 2+1) {				//we just received the Length byte
		CmdLength = RxBuffer[2];		//store the length byte
	}
	return;
}