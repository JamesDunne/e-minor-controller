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

/* concert/practice main mode switch */
enum mainmode {
	MODE_PRACTICE,
	MODE_CONCERT
} mode;

/* activate current preset and send the MIDI program change message */
void preset_activate() {
	/* send the MIDI message */
    curr_program = bank[curr_preset];
    midi_send_cmd1(0xC, midi_channel, curr_program);
	/* show the program value: */
    leds_show_4digits(curr_program);
	/* activate the footswitch LED: */
    fsw_led_set_active(curr_preset);
}

void bankmap_activate() {
	curr_preset = bankmap[curr_mapindex];
	preset_activate();
	leds_show_1digit(curr_mapindex + 1);
}

/* load current bank but do not switch to a preset */
void bank_activate() {
    /* load up the selected bank: */
    bank_load(curr_bank, bankname, bank, bankmap, &bankmap_count);
	/* display bank name: */
	leds_show_4alphas(bankname);
}

/* set the controller to an initial state */
void controller_init() {
	bank_count = banks_count();

	curr_bank = 0;
	bank_activate();

	curr_preset = 0;
	preset_activate();

	if (slider_poll() == 0) {
		mode = MODE_PRACTICE;
	} else {
		mode = MODE_CONCERT;
	}
}

u32		sw_curr = 0, sw_last = 0;

u8 button_pressed(u32 mask) {
	return ((sw_curr & mask) == mask) && ((sw_last & mask) == 0);
}

u8 button_released(u32 mask) {
	return ((sw_last & mask) == mask) && ((sw_curr & mask) == 0);
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

			/* PREV pressed: */
			if (button_pressed(FSM_PREV)) {
				printf("prev pressed\r\n");
				if (curr_mapindex == 0) {
					if (curr_bank == 0) {
						curr_bank = bank_count - 1;
					} else {
						--curr_bank;
					}
					bank_activate();
					curr_mapindex = bankmap_count - 1;
				} else {
					--curr_mapindex;
				}
				bankmap_activate();
			}
			/* NEXT pressed: */
			if (button_pressed(FSM_NEXT)) {
				printf("next pressed\r\n");
				if (curr_mapindex == bankmap_count - 1) {
					if (curr_bank == bank_count - 1) {
						curr_bank = 0;
					} else {
						++curr_bank;
					}
					bank_activate();
					curr_mapindex = 0;
				} else {
					++curr_mapindex;
				}
				bankmap_activate();
			}
			break;
	}
	sw_last = sw_curr;
}
