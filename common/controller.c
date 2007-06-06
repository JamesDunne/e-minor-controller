/*

	A programmable MIDI foot controller.

	Written by James S. Dunne
	04/05/2007

	Possible hardware layout diagram:

	(o)     = SPST rugged foot-switch
	(*)     = Single on/off LED
	[ ... ] = LED 7-segment (or more) display
	{\}		= slider switch

 PWR  MIDI OUT EXPR IN (opt)
  |      ||      ||
/--------------------\
|                    |
| [8 8 8 8] {\}  [8] |
|                    |
| (*)  (*)  (*)  (*) |
| (o)  (o)  (o)  (o) |
|  1    2    3    4  |
|                    |
| (o)  (o)  (o)  (o) |
| DEC  INC  ENTR NEXT|
|                    |
\--------------------/

*/

#include "../common/types.h"
#include "../common/hardware.h"

const u8 midi_channel = 0;

u8      bank[BANK_PRESET_COUNT];
u8		bankcontroller[BANK_PRESET_COUNT];
u8		bankmap[BANK_MAP_COUNT];
u8		bankmap_count;
char	bankname[BANK_NAME_MAXLENGTH];

/* current settings */
u8      curr_program;
u8      curr_preset;
u8      curr_mapindex;
u16     curr_bank, loaded_bank;
u16		curr_sortedbank;

u16		bank_count;

u32		preset_held = 0;

/* decrement timer in ms: */
u16		accel_time;
u8		accel_count;

u16		cdtimer_value = 0;
u16		cdtimer_flash = 0;
u16		cdtimer_store = 0;
u16		cdtimer_incdec_held = 0;
u16		cdtimer_holdenter = 0;

enum acceleration_state {
	ACCEL_NONE,
	ACCEL_INC_SLOW,
	ACCEL_INC_MEDIUM,
	ACCEL_INC_FAST,
	ACCEL_DEC_SLOW,
	ACCEL_DEC_MEDIUM,
	ACCEL_DEC_FAST
} accel_state = ACCEL_NONE;

enum flashing_led_state {
	FLASH_NONE,
	FLASH_STORE,
	FLASH_BANK_SELECT_MODE,
	FLASH_PRGM_SELECT_MODE
} flash_state = FLASH_NONE;

enum program_modes {
	PROGRAM_NONE,
	PROGRAM_SEQUENCE,
	PROGRAM_COMPLETE
} program_mode = PROGRAM_NONE;

u8		flash_led = 0;

/* time period in ms before value is changed */
const u16 accel_time_slow	= 15;
const u16 accel_time_medium	=  5;
const u16 accel_time_fast	=  2;

const u16 value_flashtime	= 75;

/* concert/practice main mode switch */
enum mainmode {
	MODE_PRACTICE = 0,
	MODE_CONCERT = 1
} mode;

/* convert integer to ASCII in fixed number of chars, right-aligned */
void itoa_fixed(u8 n, char s[LEDS_MAX_ALPHAS]) {
	u8 i = LEDS_MAX_ALPHAS - 1;

	do {
		s[i--] = (n%10) + '0';
	} while ((n /= 10) > 0);

	/* pad the left chars with spaces: */
	for (;i > 0;--i) s[i] = ' ';
	s[i] = ' ';
}

/* display a program value in decimal with a leading 'P': */
void show_program() {
	char	a[LEDS_MAX_ALPHAS];

	/* convert curr_program to ASCII: */
	itoa_fixed(curr_program + 1, a);
	/* leading 'P' char: */
	a[0] = 'P';
	leds_show_4alphas(a);

	/* start timer to revert the display: */
	cdtimer_value = value_flashtime;
}

/* send the MIDI program change message */
void program_activate(u8 notify) {
	midi_send_cmd1(0xC, midi_channel, curr_program);
	if (notify) {
		/* show the program value: */
		show_program();
	}
}

/* activate current preset */
void preset_activate(u8 notify) {
	/* grab the program # from the bank */
	curr_program = bank[curr_preset];
	program_activate(notify);
	/* activate the footswitch LED: */
	fsw_led_set_active(curr_preset);
}

/* display the sequence index on the 1-digit LED display: */
void bankmap_show() {
	leds_show_1digit(curr_mapindex + 1);
}

/* activate the preset for the current bank map index */
void bankmap_activate(u8 notify) {
	/* switch preset */
	loaded_bank = curr_bank;
	curr_preset = bankmap[curr_mapindex];
	preset_activate(notify);
	/* always show the bank map index */
	bankmap_show();
}

/* load current bank but do not switch to a preset */
void bank_activate(u8 notify) {
	/* load up the selected bank: */
	bank_load(curr_bank, bankname, bank, bankcontroller, bankmap, &bankmap_count);
	curr_mapindex = 0;
	/* always show the bank map index */
	leds_show_1digit(curr_mapindex + 1);
	if (notify) {
		/* display bank name: */
		leds_show_4alphas(bankname);
	}
}

/* load the real bank # from the sorted index */
void sortedbank_activate(u8 notify) {
	curr_bank = bank_getsortedindex(curr_sortedbank);
	bank_activate(notify);
}

/* load only current bank name and display it on 4-digit display */
void bank_showname() {
	bank_loadname(curr_bank, bankname);
	leds_show_4alphas(bankname);
}

/* load only current bank name from the sorted index and display it on 4-digit display */
void sortedbank_showname() {
	if (program_mode != PROGRAM_NONE) {
		leds_show_4alphas("SEQ-");
	} else {
		curr_bank = bank_getsortedindex(curr_sortedbank);
		bank_loadname(curr_bank, bankname);
		leds_show_4alphas(bankname);
	}
}

/* current and previous foot-switch states: */
u32		sw_curr = 0, sw_last = 0;
u8		cc_curr = 0, cc_last = 0;
u8		switch_state = 0, store_state = 0;
u8		incdec_mode = 0;

/* determine if a footswitch was pressed: */
u8 button_pressed(u32 mask) {
	return ((sw_curr & mask) == mask) && ((sw_last & mask) == 0);
}

/* determine if still holding footswitch: */
u8 button_held(u32 mask) {
	return (sw_curr & mask) == mask;
}

/* determine if a footswitch was released: */
u8 button_released(u32 mask) {
	return ((sw_last & mask) == mask) && ((sw_curr & mask) == 0);
}

/* called every 10ms */
void controller_10msec_timer() {
	/* handle inc/dec acceleration: */
	if (accel_state != ACCEL_NONE) {
		if (accel_time > 0) --accel_time;
	}

	/* handle simple count-down timers: */
	if (cdtimer_store > 0) --cdtimer_store;
	if (cdtimer_incdec_held > 0) --cdtimer_incdec_held;
	if (cdtimer_value > 0) {
		--cdtimer_value;
		if (cdtimer_value == 0) {
			if (mode == MODE_CONCERT) bank_showname();
			else sortedbank_showname();
		}
	}
	if (cdtimer_holdenter > 0) --cdtimer_holdenter;

	/* handle LED flashing states: */
	if (cdtimer_flash > 0) {
		switch (flash_state) {
			case FLASH_STORE:
				if ((cdtimer_flash & 31) == 0) {
					fsw_led_enable(flash_led);
				} else if ((cdtimer_flash & 31) == 15) {
					fsw_led_disable(flash_led);
				}
				break;
			case FLASH_BANK_SELECT_MODE:
				if ((cdtimer_flash & 31) == 0) {
					fsw_led_enable(0);
					fsw_led_enable(1);
					fsw_led_disable(2);
					fsw_led_disable(3);
				} else if ((cdtimer_flash & 31) == 15) {
					fsw_led_disable(0);
					fsw_led_disable(1);
					fsw_led_disable(2);
					fsw_led_disable(3);
				}
				break;
			case FLASH_PRGM_SELECT_MODE:
				if ((cdtimer_flash & 31) == 0) {
					fsw_led_disable(0);
					fsw_led_disable(1);
					fsw_led_enable(2);
					fsw_led_enable(3);
				} else if ((cdtimer_flash & 31) == 15) {
					fsw_led_disable(0);
					fsw_led_disable(1);
					fsw_led_disable(2);
					fsw_led_disable(3);
				}
				break;
		}

		--cdtimer_flash;
		if (cdtimer_flash == 0) {
			/* reset LEDs to proper state */
			fsw_led_set_active(curr_preset);
		}
	}
}

void inc_practice_value() {
	if (incdec_mode == 0) {
		if (curr_sortedbank == bank_count - 1) curr_sortedbank = 0;
		else ++curr_sortedbank;
	} else {
		if (curr_program == 127) curr_program = 0;
		else ++curr_program;
	}
}

void dec_practice_value() {
	if (incdec_mode == 0) {
		if (curr_sortedbank == 0) curr_sortedbank = bank_count - 1;
		else --curr_sortedbank;
	} else {
		if (curr_program == 0) curr_program = 127;
		else --curr_program;
	}
}

void notify_practice_value() {
	if (incdec_mode == 0) {
		sortedbank_showname();
	} else {
		show_program();
	}
}

void activate_practice_value() {
	if (incdec_mode == 0) {
		sortedbank_activate(0);
	} else {
		program_activate(1);
	}
}

/* sequence programming completed, set state to repeat the sequence back: */
void sequence_complete() {
	/* set the sequence length and store to the ROM: */
	bankmap_count = curr_mapindex;
	bank_store(curr_bank, bank, bankcontroller, bankmap, bankmap_count);
	/* set up state to repeat the stored sequence back on the preset LEDs: */
	program_mode = PROGRAM_COMPLETE;
	cdtimer_holdenter = 50;
	curr_mapindex = 0;
}

/* set the controller to an initial state */
void controller_init() {
	bank_count = banks_count();

	curr_bank = 0;
	bank_activate(1);

	curr_mapindex = 0;
	bankmap_activate(1);

	sw_curr = sw_last = 0;
	cc_curr = cc_last = expr_poll();
	mode = slider_poll();
}

/* main control loop */
void controller_handle() {
	/* poll foot-switch depression status: */
	sw_curr = fsw_poll();
	/* poll expression pedal value: */
	cc_curr = expr_poll();

	/* send CC message only if changed: */
	if (cc_curr != cc_last) {
		midi_send_cmd2(0xB, midi_channel, bankcontroller[curr_preset], cc_curr & 0x7F);
	}

	/* determine mode */
	if (slider_poll() == 0) {
		if (mode == MODE_CONCERT) {
			/* switched from CONCERT to PRACTICE */
			mode = MODE_PRACTICE;
			/* load the alphabetically first bank and start from the beginning of its program */
			curr_sortedbank = 0;
			sortedbank_activate(1);
			curr_mapindex = 0;
			bankmap_activate(0);
		}
	} else {
		if (mode == MODE_PRACTICE) {
			/* switched from PRACTICE to CONCERT */
			mode = MODE_CONCERT;
			/* load the sequentially first bank and start from the beginning of its program */
			curr_bank = 0;
			bank_activate(1);
			curr_mapindex = 0;
			bankmap_activate(0);
		}
	}

	/* NEXT never changes function depending on mode */

	/* NEXT pressed: */
	if (button_pressed(FSM_NEXT)) {
		if (loaded_bank != curr_bank) {
			/* prepared to switch to a bank, but did not activate the first map */
			bankmap_activate(1);
		} else {
			if (curr_mapindex == bankmap_count - 1) {
				/* crossed the upper bank-map boundary, load the next bank */
				if (mode == MODE_PRACTICE) {
					/* PRACTICE mode cycles through banks by sorted index #: */
					if (curr_sortedbank == bank_count - 1) {
						curr_sortedbank = 0;
					} else {
						++curr_sortedbank;
					}
					/* show the bank name */
					sortedbank_activate(1);
				} else {
					/* CONCERT mode cycles through banks by index #: */
					if (curr_bank == bank_count - 1) {
						curr_bank = 0;
					} else {
						++curr_bank;
					}
					/* show the bank name */
					bank_activate(1);
				}
				/* activate the first map for the new bank, but do not display the MIDI program # */
				curr_mapindex = 0;
				bankmap_activate(0);
			} else {
				/* activate the next map for the new bank, and display the MIDI program # */
				++curr_mapindex;
				bankmap_activate(1);
			}
		}
	}

	/* PRACTICE vs. CONCERT modes: */
	switch (mode) {
		case MODE_PRACTICE:
			/* PRACTICE mode has sub-modes of its own: */
			switch (program_mode) {
				case PROGRAM_NONE:
					/* one of preset 1-4 pressed: */
					if (button_pressed(FSM_PRESET_1)) {
						curr_preset = 0;
						if (incdec_mode == 1) {
							/* check if held for ~300msec */
							cdtimer_store = 30;
							store_state = 0;
						} else {
							preset_activate(1);
						}
					}
					if (button_pressed(FSM_PRESET_2)) {
						curr_preset = 1;
						if (incdec_mode == 1) {
							/* check if held for ~300msec */
							cdtimer_store = 30;
							store_state = 0;
						} else {
							preset_activate(1);
						}
					}
					if (button_pressed(FSM_PRESET_3)) {
						curr_preset = 2;
						if (incdec_mode == 1) {
							/* check if held for ~300msec */
							cdtimer_store = 30;
							store_state = 0;
						} else {
							preset_activate(1);
						}
					}
					if (button_pressed(FSM_PRESET_4)) {
						curr_preset = 3;
						if (incdec_mode == 1) {
							/* check if held for ~300msec */
							cdtimer_store = 30;
							store_state = 0;
						} else {
							preset_activate(1);
						}
					}
					if (incdec_mode == 1) {
						/* check if the store-timer ran out and we're able to store: */
						if ((cdtimer_store == 0) && (store_state == 0)) {
							/* still holding a button? */
							if (button_held(FSM_PRESET_1) || button_held(FSM_PRESET_2) || button_held(FSM_PRESET_3) || button_held(FSM_PRESET_4)) {
								/* store the program */
								store_state = 1;
								bank[curr_preset] = curr_program;
								bank_store(curr_bank, bank, bankcontroller, bankmap, bankmap_count);
								preset_activate(1);
								/* flash the stored LED */
								flash_state = FLASH_STORE;
								flash_led = curr_preset;
								cdtimer_flash = 100;
							}
						}
						/* check if a button was released: */
						if (button_released(FSM_PRESET_1) || button_released(FSM_PRESET_2) || button_released(FSM_PRESET_3) || button_released(FSM_PRESET_4)) {
							if ((cdtimer_store > 0) && (store_state == 0)) {
								/* was only tapped (held less than ~300msec) */
								preset_activate(1);
								cdtimer_store = 0;
							}
						}
					}

					/* INC pressed: */
					if (button_pressed(FSM_INC) && !button_held(FSM_DEC) && (cdtimer_incdec_held == 0)) {
						/* INC pushed first */
						cdtimer_incdec_held = 30;
					}
					/* Still holding INC alone after ~300 ms: */
					if ((accel_state == ACCEL_NONE) && button_held(FSM_INC) && !button_held(FSM_DEC) && (cdtimer_incdec_held == 0)) {
						accel_time = 0;
						accel_count = 0;
						accel_state = ACCEL_INC_SLOW;
					}
					/* INC released: */
					if (button_released(FSM_INC)) {
						if (cdtimer_incdec_held > 0) {
							inc_practice_value();
							notify_practice_value();
						}
						accel_state = ACCEL_NONE;
						activate_practice_value();
					}

					/* DEC pressed: */
					if (button_pressed(FSM_DEC) && !button_held(FSM_INC) && (cdtimer_incdec_held == 0)) {
						/* DEC pushed first */
						cdtimer_incdec_held = 30;
					}
					/* Still holding DEC alone after ~300 ms: */
					if ((accel_state == ACCEL_NONE) && button_held(FSM_DEC) && !button_held(FSM_INC) && (cdtimer_incdec_held == 0)) {
						accel_time = 0;
						accel_count = 0;
						accel_state = ACCEL_DEC_SLOW;
					}
					/* DEC released: */
					if (button_released(FSM_DEC)) {
						if (cdtimer_incdec_held > 0) {
							dec_practice_value();
							notify_practice_value();
						}
						accel_state = ACCEL_NONE;
						activate_practice_value();
					}

					/* ENTER pressed */
					if (button_pressed(FSM_ENTER)) {
						cdtimer_holdenter = 30;
					}
					/* ENTER held at least ~300msec: */
					if (button_held(FSM_ENTER) && (cdtimer_holdenter == 0) && (program_mode == PROGRAM_NONE)) {
						/* enter sequence program mode */
						program_mode = PROGRAM_SEQUENCE;
						curr_mapindex = 0;
						curr_preset = 4;
						sortedbank_showname();
					}
					/* ENTER released before ~300msec was up: */
					if (button_released(FSM_ENTER) && (cdtimer_holdenter > 0)) {
						if (incdec_mode == 0) {
							/* program-select mode */
							incdec_mode = 1;
							flash_state = FLASH_PRGM_SELECT_MODE;
							cdtimer_flash = 100;
							notify_practice_value();
						} else {
							/* bank-select mode by alphabetical order */
							incdec_mode = 0;
							flash_state = FLASH_BANK_SELECT_MODE;
							cdtimer_flash = 100;
							notify_practice_value();
						}
					}

					/* acceleration countdown timer hit 0 and we're incrementing slowly */
					if ((accel_state != ACCEL_NONE) && (accel_time == 0)) {
						switch (accel_state) {
							case ACCEL_INC_SLOW:
								inc_practice_value();
								notify_practice_value();

								/* if we cycled more than 5 values, ramp up to next speed */
								if (accel_count++ == 5) {
									accel_count = 0;
									accel_state = ACCEL_INC_MEDIUM;
									accel_time = accel_time_medium;
								} else {
									accel_time = accel_time_slow;
								}
								break;
							case ACCEL_INC_MEDIUM:
								inc_practice_value();
								notify_practice_value();

								/* if we cycled more than 5 values, ramp up to next speed */
								if (accel_count++ == 20) {
									accel_count = 0;
									accel_state = ACCEL_INC_FAST;
									accel_time = accel_time_fast;
								} else {
									accel_time = accel_time_medium;
								}
								break;
							case ACCEL_INC_FAST:
								inc_practice_value();
								notify_practice_value();

								accel_time = accel_time_fast;
								break;

							case ACCEL_DEC_SLOW:
								dec_practice_value();
								notify_practice_value();

								/* if we cycled more than 5 values, ramp up to next speed */
								if (accel_count++ == 5) {
									accel_count = 0;
									accel_state = ACCEL_DEC_MEDIUM;
									accel_time = accel_time_medium;
								} else {
									accel_time = accel_time_slow;
								}
								break;
							case ACCEL_DEC_MEDIUM:
								dec_practice_value();
								notify_practice_value();

								/* if we cycled more than 5 values, ramp up to next speed */
								if (accel_count++ == 20) {
									accel_count = 0;
									accel_state = ACCEL_DEC_FAST;
									accel_time = accel_time_fast;
								} else {
									accel_time = accel_time_medium;
								}
								break;
							case ACCEL_DEC_FAST:
								dec_practice_value();
								notify_practice_value();

								accel_time = accel_time_fast;
								break;
						}
					}
					break;

				/* sequence programming mode: */
				case PROGRAM_SEQUENCE:
					/* one of preset 1-4 pressed: */
					if (button_pressed(FSM_PRESET_1)) {
						if (curr_preset != 0) {
							curr_preset = 0;
							preset_activate(1);
							bankmap[curr_mapindex++] = curr_preset;
							bankmap_show();
							/* just stored our last sequence: */
							if (curr_mapindex == 8) {
								sequence_complete();
							}
						}
					}
					if (button_pressed(FSM_PRESET_2)) {
						if (curr_preset != 1) {
							curr_preset = 1;
							preset_activate(1);
							bankmap[curr_mapindex++] = curr_preset;
							bankmap_show();
							/* just stored our last sequence: */
							if (curr_mapindex == 8) {
								sequence_complete();
							}
						}
					}
					if (button_pressed(FSM_PRESET_3)) {
						if (curr_preset != 2) {
							curr_preset = 2;
							preset_activate(1);
							bankmap[curr_mapindex++] = curr_preset;
							bankmap_show();
							/* just stored our last sequence: */
							if (curr_mapindex == 8) {
								sequence_complete();
							}
						}
					}
					if (button_pressed(FSM_PRESET_4)) {
						if (curr_preset != 3) {
							curr_preset = 3;
							preset_activate(1);
							bankmap[curr_mapindex++] = curr_preset;
							bankmap_show();
							/* just stored our last sequence: */
							if (curr_mapindex == 8) {
								sequence_complete();
							}
						}
					}

					/* ENTER pressed */
					if (button_pressed(FSM_ENTER)) {
						/* stop programming early and save the sequence: */
						sequence_complete();
					}
					break;

				/* sequence repeat mode: */
				case PROGRAM_COMPLETE:
					if (cdtimer_holdenter == 0) {
						if (curr_mapindex == bankmap_count) {
							/* we're done! */
							program_mode = PROGRAM_NONE;
							curr_mapindex = 0;
							bankmap_activate(1);
						} else {
							/* set the next LED active */
							bankmap_show();
							curr_preset = bankmap[curr_mapindex];
							fsw_led_set_active(curr_preset);
							curr_program = bank[curr_preset];
							show_program();
							++curr_mapindex;
							cdtimer_holdenter = 50;
						}
					}
					break;
			}
			break;

		case MODE_CONCERT:
			/*
				next/prev buttons move bank map index pointer up/down by 1, cycling up/down bank # when bank
				map boundaries are crossed.  Single-digit 7-segment display shows map index # as 1-8.
				inc/dec buttons move through banks, resetting bank map index to 0.  Bank name displays on 4-digit display.
				preset button 1-4: change program # immediately, showing program # on 4-digit display for .5 sec,
				reverting display back to bank name.
			*/

			/* one of preset 1-4 pressed: */
			if (button_pressed(FSM_PRESET_1)) {
				curr_preset = 0;
				preset_activate(1);
			}
			if (button_pressed(FSM_PRESET_2)) {
				curr_preset = 1;
				preset_activate(1);
			}
			if (button_pressed(FSM_PRESET_3)) {
				curr_preset = 2;
				preset_activate(1);
			}
			if (button_pressed(FSM_PRESET_4)) {
				curr_preset = 3;
				preset_activate(1);
			}

			/* INC pressed: */
			if (button_pressed(FSM_INC)) {
				if (curr_bank == bank_count - 1) curr_bank = 0;
				else ++curr_bank;
				bank_showname();

				accel_state = ACCEL_NONE;
				accel_time = accel_time_slow;
				accel_count = 0;
				accel_state = ACCEL_INC_SLOW;
			}
			/* INC released: */
			if (button_released(FSM_INC)) {
				accel_state = ACCEL_NONE;
				/* load the bank, but don't change program # */
				bank_activate(0);
			}

			/* DEC pressed: */
			if (button_pressed(FSM_DEC)) {
				if (curr_bank == 0) curr_bank = bank_count - 1;
				else --curr_bank;
				bank_showname();

				accel_state = ACCEL_NONE;
				accel_time = accel_time_slow;
				accel_count = 0;
				accel_state = ACCEL_DEC_SLOW;
			}
			/* DEC released: */
			if (button_released(FSM_DEC)) {
				accel_state = ACCEL_NONE;
				/* load the bank, but don't change program # */
				bank_activate(0);
			}

			/* PREV/ENTER pressed: */
			if (button_pressed(FSM_ENTER)) {
				if (loaded_bank != curr_bank) {
					/* prepared to switch to a bank, but did not activate the first map */
					bankmap_activate(1);
				} else {
					if (curr_mapindex == 0) {
						/* crossed the lower bank-map boundary, load the previous bank */
						if (mode == MODE_PRACTICE) {
							/* PRACTICE mode cycles through banks by sorted index #: */
							if (curr_sortedbank == 0) {
								curr_sortedbank = bank_count - 1;
							} else {
								--curr_sortedbank;
							}
							/* show the bank name */
							sortedbank_activate(1);
						} else {
							/* CONCERT mode cycles through banks by index #: */
							if (curr_bank == 0) {
								curr_bank = bank_count - 1;
							} else {
								--curr_bank;
							}
							/* show the bank name */
							bank_activate(1);
						}
						/* activate the last map for the new bank, but do not display the MIDI program # */
						curr_mapindex = bankmap_count - 1;
						bankmap_activate(0);
					} else {
						/* activate the previous map for the new bank, and display the MIDI program # */
						--curr_mapindex;
						bankmap_activate(1);
					}
				}
			}

			/* acceleration countdown timer hit 0 and we're incrementing slowly */
			if ((accel_state != ACCEL_NONE) && (accel_time == 0)) {
				switch (accel_state) {
					case ACCEL_INC_SLOW:
						if (curr_bank == bank_count - 1) curr_bank = 0;
						else ++curr_bank;
						bank_showname();

						/* if we cycled more than 5 values, ramp up to next speed */
						if (accel_count++ == 5) {
							accel_count = 0;
							accel_state = ACCEL_INC_MEDIUM;
							accel_time = accel_time_medium;
						} else {
							accel_time = accel_time_slow;
						}
						break;
					case ACCEL_INC_MEDIUM:
						if (curr_bank == bank_count - 1) curr_bank = 0;
						else ++curr_bank;
						bank_showname();

						/* if we cycled more than 5 values, ramp up to next speed */
						if (accel_count++ == 20) {
							accel_count = 0;
							accel_state = ACCEL_INC_FAST;
							accel_time = accel_time_fast;
						} else {
							accel_time = accel_time_medium;
						}
						break;
					case ACCEL_INC_FAST:
						if (curr_bank == bank_count - 1) curr_bank = 0;
						else ++curr_bank;
						bank_showname();

						accel_time = accel_time_fast;
						break;
					case ACCEL_DEC_SLOW:
						if (curr_bank == 0) curr_bank = bank_count - 1;
						else --curr_bank;
						bank_showname();

						/* if we cycled more than 5 values, ramp up to next speed */
						if (accel_count++ == 5) {
							accel_count = 0;
							accel_state = ACCEL_DEC_MEDIUM;
							accel_time = accel_time_medium;
						} else {
							accel_time = accel_time_slow;
						}
						break;
					case ACCEL_DEC_MEDIUM:
						if (curr_bank == 0) curr_bank = bank_count - 1;
						else --curr_bank;
						bank_showname();

						/* if we cycled more than 5 values, ramp up to next speed */
						if (accel_count++ == 20) {
							accel_count = 0;
							accel_state = ACCEL_DEC_FAST;
							accel_time = accel_time_fast;
						} else {
							accel_time = accel_time_medium;
						}
						break;
					case ACCEL_DEC_FAST:
						if (curr_bank == 0) curr_bank = bank_count - 1;
						else --curr_bank;
						bank_showname();

						accel_time = accel_time_fast;
						break;
				}
			}
			break;
	}
	sw_last = sw_curr;
}
