


//WRITE_BLOCK_INTO_ROM
//Before calling, set FSR0 = address of RAM buffer
//Also, set TBLPTR = address of ROM to write to  (must be on 64 byte boundary).
void	Write64BytesProgMem(rom unsigned char *RomPtr, unsigned char *RamPtr) {
	EECON1bits.EEPGD = true;	// point to Flash program memory
	EECON1bits.CFGS = false;	// access Flash program memory
	EECON1bits.WREN = true;		// enable write to memory
	EECON1bits.FREE = true;		// enable Row Erase operation
	INTCONbits.GIE = false; 	// disable interrupts

//perform erase opration:
	EECON2 = 0x55;				// write 55h
	EECON2 = 0xAA;				// write 0AAh
	EECON1bits.WR = true;		// start erase (CPU stall)

	INTCONbits.GIE = true; 		// re-enable interrupts
	TBLRD*- 			; dummy read decrement
;	MOVLW	BUFFER_ADDR_HIGH	; point to buffer
;	MOVWF	FSR0H
;	MOVLW	BUFFER_ADDR_LOW
;	MOVWF	FSR0L
	MOVLW	2
	MOVWF	WpmCounter1
WRITE_BUFFER_BACK
	MOVLW	32	 		; number of bytes in holding register
	MOVWF	WpmCounter
WRITE_BYTE_TO_HREGS
	MOVF	POSTINC0, W 		; get low byte of buffer data
	MOVWF	TABLAT 			; present data to table latch
	TBLWT+* 			; write data, perform a short write
					; to internal TBLWT holding register.
	DECFSZ	WpmCounter 		; loop until buffers are full
	BRA	WRITE_BYTE_TO_HREGS

PROGRAM_MEMORY
	BSF	EECON1, EEPGD		; point to Flash program memory
	BCF	EECON1, CFGS		; access Flash program memory
	BSF	EECON1, WREN		; enable write to memory
	BCF	INTCON, GIE		; disable interrupts

;Write to program memmory:
	MOVLW	55h
	MOVWF	EECON2			; write 55h
	MOVLW	0AAh
	MOVWF	EECON2			; write 0AAh
	BSF	EECON1, WR		; start program (CPU stall)

	DECFSZ	WpmCounter1
	BRA	WRITE_BUFFER_BACK
	BSF	INTCON, GIE		; re-enable interrupts
	BCF	EECON1, WREN		; disable write to memory
	return
