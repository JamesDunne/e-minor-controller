/*
    Defined hardware I/O functions that the controller software
    needs to interface with.  This includes MIDI I/O, 4-digit LED
    display, foot-switch momentary toggle switch indicators, and
    LED "active" indicators above foot-switches.

    NOTE: it is expected that 'types.h' is #included before this file
*/

#define LEDS_MAX_ALPHAS 4
#define BANK_PRESET_COUNT 4
#define BANK_MAP_COUNT 8
#define BANK_NAME_MAXLENGTH 4

/* --------------- LED read-out display functions: */

/* show 4 alphas on the 4-digit display */
void leds_show_4alphas(char text[LEDS_MAX_ALPHAS]);

/* show single digit on the single digit display */
void leds_show_1digit(u8 value);

/* --------------- Momentary toggle foot-switches: */

enum fsw_bits {
    FSB_PRESET_1 = 0,
    FSB_PRESET_2 = 1,
    FSB_PRESET_3 = 2,
    FSB_PRESET_4 = 3,

    FSB_DEC = 28,
    FSB_INC = 29,
    FSB_ENTER = 30,
    FSB_NEXT = 31,
};
enum fsw_masks {
	FSM_PRESET_1 = (1 << FSB_PRESET_1),
	FSM_PRESET_2 = (1 << FSB_PRESET_2),
	FSM_PRESET_3 = (1 << FSB_PRESET_3),
	FSM_PRESET_4 = (1 << FSB_PRESET_4),

    FSM_DEC = (1 << FSB_DEC),
    FSM_INC = (1 << FSB_INC),
    FSM_ENTER = (1 << FSB_ENTER),
    FSM_NEXT = (1 << FSB_NEXT)
};

/* Poll up to 28 foot-switch toggles simultaneously.  PREV NEXT DEC  INC map to 28-31 bit positions. */
u32 fsw_poll();

/* Set currently active program foot-switch's LED indicator and disable all others */
void fsw_led_set_active(int idx);

/* Explicitly enable a single LED without affecting the others */
void fsw_led_enable(int idx);

/* Explicitly disable a single LED without affecting the others */
void fsw_led_disable(int idx);

/* --------------- External inputs: */

/* Poll the slider switch to see which mode we're in: */
u8 slider_poll();

/* Poll the expression pedal's data (0-127): */
u8 expr_poll();

/* --------------- Data persistence functions: */

/* Gets number of stored banks */
u16 banks_count();

/* Loads a bank into the specified arrays: */
void bank_load(u16 bank_index, char name[BANK_NAME_MAXLENGTH], u8 bank[BANK_PRESET_COUNT], u8 bankcontroller[BANK_PRESET_COUNT], u8 bankmap[BANK_MAP_COUNT], u8 *bankmap_count);
/* Stores the programs back to the bank: */
void bank_store(u16 bank_index, u8 bank[BANK_PRESET_COUNT], u8 bankcontroller[BANK_PRESET_COUNT], u8 bankmap[BANK_MAP_COUNT], u8 bankmap_count);

/* Load bank name for browsing through banks: */
void bank_loadname(u16 bank_index, char name[BANK_NAME_MAXLENGTH]);

/* Get the alphabetically sorted bank index */
u16 bank_getsortedindex(u16 sort_index);

/* --------------- MIDI I/O functions: */

/* Send a single MIDI byte. */
void midi_send_byte(u8 data);

/* Send formatted MIDI commands.

    0 <= cmd <= F       - MIDI command
    0 <= channel <= F   - MIDI channel to send command to
    00 <= data1 <= FF   - first data byte of MIDI command
    00 <= data2 <= FF   - second (optional) data byte of MIDI command
*/
void midi_send_cmd1(u8 cmd, u8 channel, u8 data1);
void midi_send_cmd2(u8 cmd, u8 channel, u8 data1, u8 data2);

/* --------------- Controller logic interface functions: */

void controller_init();
void controller_10msec_timer();
void controller_handle();
