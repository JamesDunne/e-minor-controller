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

// Set high bit #"Place" located in a register called "VAR"  // Place : 0 -> 7
#define setbit(VAR,Place) VAR |= 1 << Place

// Set low bit #"Place" located in a register called "VAR"  // Place : 0 -> 7
#define clrbit(VAR,Place) VAR &= (1 << Place)^255
#define chkbit(VAR,Place) (VAR & 1 << Place)
#define tglbit(VAR,Place) VAR ^= 1 << Place

#define	midi_channel	0

u8	active_preset;
u32	sw_curr, sw_last;

u8 preset_programs[4];
u8 control_values[4];

u8 preset_controltoggle;
u8 preset_controltoggle_init[4];

/* concert/practice main mode switch */
enum mainmode mode;

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
void show_program(u8 value) {
	char	a[LEDS_MAX_ALPHAS];

	/* convert value to ASCII: */
	itoa_fixed(value + 1, a);
	/* leading 'P' char: */
	a[0] = 'P';
	leds_show_4alphas(a);
	leds_show_1digit(1);
}

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

void set_toggle_leds(void) {
	if (chkbit(preset_controltoggle,0)) fsw_led_enable(0); else fsw_led_disable(0);
	if (chkbit(preset_controltoggle,1)) fsw_led_enable(1); else fsw_led_disable(1);
	if (chkbit(preset_controltoggle,2)) fsw_led_enable(2); else fsw_led_disable(2);
	if (chkbit(preset_controltoggle,3)) fsw_led_enable(3); else fsw_led_disable(3);
}

void activate_preset(u8 idx) {
	if (idx > 3) return;

	/* Send the MIDI PROGRAM CHANGE message: */
	midi_send_cmd1(0xC, midi_channel, preset_programs[idx]);
	/* Display the program value on the 4-digit display */
	show_program(preset_programs[idx]);

	/* Revert the continuous controller toggle state to initial for this preset: */
	preset_controltoggle = preset_controltoggle_init[idx];
	set_toggle_leds();

	/* Record the current preset number: */
	active_preset = idx;
}

void toggle_control(u8 idx) {
	u8 togglevalue = 0x00;

	/* Toggle on/off the selected continuous controller: */
	tglbit(preset_controltoggle, idx);
	set_toggle_leds();

	/* Determine the MIDI value to use depending on the newly toggled state: */
	if (chkbit(preset_controltoggle,idx)) togglevalue = 0x7F;
	midi_send_cmd2(0xB, midi_channel, control_values[idx], togglevalue);
}

/* ------------------------- Actual controller logic ------------------------- */

/* set the controller to an initial state */
void controller_init(void) {
	/* MIDI program values corresponding to 4 preset buttons: */
	preset_programs[0] = 0;		// heavy modern bright
	preset_programs[1] = 1;		// deep modern crunch
	preset_programs[2] = 2;		// lead w/ delay
	preset_programs[3] = 3;		// clean sparkle w/ reverb

	/* controller numbers for Bn commands that will be toggled on|off with 0|127 data */
	control_values[0] = 0x54;	// compressor
	control_values[1] = 0x5D;	// chorus
	control_values[2] = 0x5E;	// delay
	control_values[3] = 0x5B;	// reverb

	/* default bitfield states for preset programs: */
	preset_controltoggle_init[0] = 1 | 8;		// compressor, reverb
	preset_controltoggle_init[1] = 1;			// compressor
	preset_controltoggle_init[2] = 1 | 4 | 8;	// compressor, delay, reverb
	preset_controltoggle_init[3] = 1 | 8;		// compressor, reverb

	activate_preset(0);
}

/* called every 10ms */
void controller_10msec_timer(void) {
	
}

/* main control loop */
void controller_handle(void) {
	/* poll foot-switch depression status: */
	sw_curr = fsw_poll();

	/* determine mode */
	if (slider_poll() == 0) {
		if (mode != MODE_PRACTICE) {
			/* switched to PRACTICE mode */
			mode = MODE_PRACTICE;
		}
	} else {
		if (mode != MODE_CONCERT) {
			/* switched to CONCERT mode */
			mode = MODE_CONCERT;
		}
	}

	if (mode == MODE_PRACTICE) goto practicemode;
	if (mode == MODE_CONCERT) goto concertmode;

cleanup:
	sw_last = sw_curr;
	return;

practicemode:
	goto concertmode;
	goto cleanup;

concertmode:
	/* one of preset 1-4 pressed: */
	if (button_pressed(FSM_PRESET_1)) {
		activate_preset(0);
	}
	if (button_pressed(FSM_PRESET_2)) {
		activate_preset(1);
	}
	if (button_pressed(FSM_PRESET_3)) {
		activate_preset(2);
	}
	if (button_pressed(FSM_PRESET_4)) {
		activate_preset(3);
	}

	/* one of control 1-4 pressed: */
	if (button_pressed(FSM_CONTROL_1)) {
		toggle_control(0);
	}
	if (button_pressed(FSM_CONTROL_2)) {
		toggle_control(1);
	}
	if (button_pressed(FSM_CONTROL_3)) {
		toggle_control(2);
	}
	if (button_pressed(FSM_CONTROL_4)) {
		toggle_control(3);
	}

	goto cleanup;
}
