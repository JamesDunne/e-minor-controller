/*

    A programmable MIDI foot controller.

    Written by James S. Dunne
    04/05/2007

    Firmware Design:
        * 65,536 max (theoretical) song banks of presets to store
        * Up to 32 max (theoretical) presets to store per song bank
        * Hardware abstraction interface
        * No controller code references any standard C function

    Hardware design:
        * N program-change foot-switches, which act like radio-buttons
        * LED status indicators per each of N foot-switches indicate active preset
        * 4-digit LED 7-segment display
        * 16-alpha LED display for messages/song names
        * 4 foot-switches for generic increment/decrement program value
            (2 for single-digit increments, 2 for double-digit increments)
        ? optional rotary dial for program value
        * 2 foot-switches for increment/decrement of active preset footswitch

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
| PREV NEXT DEC  INC |
|                    |
\--------------------/

*/

#include "types.h"
#include "hardware.h"

const u8 midi_channel = 0;

u8      bank[BANK_PRESET_COUNT];
u8		bankmap[BANK_MAP_COUNT];
u8		bankmap_count;
char	bankname[BANK_NAME_MAXLENGTH];

/* current settings */
u8      curr_program;
u8      curr_preset;
u8      curr_mapindex;
u16     curr_bank;

u16		bank_count;

/* decrement timer in ms: */
u16		accel_time;
u8		accel_count;

u16		cdtimer1 = 0;
u16		cdtimer2 = 0;
u16		cdtimer3 = 0;

enum acceleration_state {
	ACCEL_NONE,
	ACCEL_INC_SLOW,
	ACCEL_INC_MEDIUM,
	ACCEL_INC_FAST,
	ACCEL_DEC_SLOW,
	ACCEL_DEC_MEDIUM,
	ACCEL_DEC_FAST
} accel_state = ACCEL_NONE;

/* time period in ms before value is changed */
const u16 accel_time_slow	= 15;
const u16 accel_time_medium	=  5;
const u16 accel_time_fast	=  2;

/* concert/practice main mode switch */
enum mainmode {
	MODE_PRACTICE,
	MODE_CONCERT
} mode;

/* send the MIDI program change message */
void program_activate(u8 notify) {
    midi_send_cmd1(0xC, midi_channel, curr_program);
	if (notify) {
		/* show the program value: */
		leds_show_4digits(curr_program);
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

/* activate the preset for the current bank map index */
void bankmap_activate(u8 notify) {
	/* switch preset */
	curr_preset = bankmap[curr_mapindex];
	preset_activate(notify);
	/* always show the bank map index */
	leds_show_1digit(curr_mapindex + 1);
}

/* load current bank but do not switch to a preset */
void bank_activate(u8 notify) {
    /* load up the selected bank: */
    bank_load(curr_bank, bankname, bank, bankmap, &bankmap_count);
	if (notify) {
		/* display bank name: */
		leds_show_4alphas(bankname);
	}
}

/* current and previous foot-switch states: */
u32		sw_curr = 0, sw_last = 0;

/* determine if a footswitch was pressed: */
u8 button_pressed(u32 mask) {
	return ((sw_curr & mask) == mask) && ((sw_last & mask) == 0);
}

/* determine if a footswitch was released: */
u8 button_released(u32 mask) {
	return ((sw_last & mask) == mask) && ((sw_curr & mask) == 0);
}

/* set the controller to an initial state */
void controller_init() {
	bank_count = banks_count();

	curr_bank = 0;
	bank_activate(1);

	curr_mapindex = 0;
	bankmap_activate(1);

	if (slider_poll() == 0) {
		mode = MODE_PRACTICE;
	} else {
		mode = MODE_CONCERT;
	}

	sw_curr = sw_last = 0;
}

/* called every 10ms */
void controller_10msec_timer() {
	/* handle inc/dec acceleration: */
	if (accel_state != ACCEL_NONE) {
		if (accel_time > 0) --accel_time;
	}

	/* handle simple count-down timers: */
	if (cdtimer1 > 0) --cdtimer1;
	if (cdtimer2 > 0) --cdtimer2;
	if (cdtimer3 > 0) --cdtimer3;
}

/* main control loop */
void controller_handle() {
	sw_curr = fsw_poll();
	mode = MODE_CONCERT;

	switch (mode) {
		case MODE_PRACTICE:
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

			/* NEXT pressed: */
			if (button_pressed(FSM_NEXT)) {
				if (curr_mapindex == bankmap_count - 1) {
					/* crossed the upper bank-map boundary, load the next bank */
					if (curr_bank == bank_count - 1) {
						curr_bank = 0;
					} else {
						++curr_bank;
					}
					/* show the bank name */
					bank_activate(1);
					/* activate the first map for the new bank, but do not display the MIDI program # */
					curr_mapindex = 0;
					bankmap_activate(0);
				} else {
					/* activate the next map for the new bank, and display the MIDI program # */
					++curr_mapindex;
					bankmap_activate(1);
				}
			}
			/* PREV pressed: */
			if (button_pressed(FSM_PREV)) {
				if (curr_mapindex == 0) {
					/* crossed the lower bank-map boundary, load the previous bank */
					if (curr_bank == 0) {
						curr_bank = bank_count - 1;
					} else {
						--curr_bank;
					}
					/* show the bank name */
					bank_activate(1);
					/* activate the last map for the new bank, but do not display the MIDI program # */
					curr_mapindex = bankmap_count - 1;
					bankmap_activate(0);
				} else {
					/* activate the previous map for the new bank, and display the MIDI program # */
					--curr_mapindex;
					bankmap_activate(1);
				}
			}

			/* INC pressed: */
			if (button_pressed(FSM_INC)) {
				if (curr_program == 127) curr_program = 0;
				else ++curr_program;
				program_activate(1);

				accel_state = ACCEL_NONE;
				accel_time = accel_time_slow;
				accel_count = 0;
				accel_state = ACCEL_INC_SLOW;
			}
			/* INC released: */
			if (button_released(FSM_INC)) {
				accel_state = ACCEL_NONE;
			}

			/* DEC pressed: */
			if (button_pressed(FSM_DEC)) {
				if (curr_program == 0) curr_program = 127;
				else --curr_program;
				program_activate(1);

				accel_state = ACCEL_NONE;
				accel_time = accel_time_slow;
				accel_count = 0;
				accel_state = ACCEL_DEC_SLOW;
			}
			/* DEC released: */
			if (button_released(FSM_DEC)) {
				accel_state = ACCEL_NONE;
			}

			/* acceleration countdown timer hit 0 and we're incrementing slowly */
			if ((accel_state != ACCEL_NONE) && (accel_time == 0)) {
				switch (accel_state) {
					case ACCEL_INC_SLOW:
						if (curr_program == 127) curr_program = 0;
						else ++curr_program;
						program_activate(1);
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
						if (curr_program == 127) curr_program = 0;
						else ++curr_program;
						program_activate(1);
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
						if (curr_program == 127) curr_program = 0;
						else ++curr_program;
						program_activate(1);
						accel_time = accel_time_fast;
						break;
					case ACCEL_DEC_SLOW:
						if (curr_program == 0) curr_program = 127;
						else --curr_program;
						program_activate(1);
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
						if (curr_program == 0) curr_program = 127;
						else --curr_program;
						program_activate(1);
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
						if (curr_program == 0) curr_program = 127;
						else --curr_program;
						program_activate(1);
						accel_time = accel_time_fast;
						break;
				}
			}
			break;
	}
	sw_last = sw_curr;
}
