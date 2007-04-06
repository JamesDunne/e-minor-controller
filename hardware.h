/*
    Defined hardware I/O functions that the controller software
    needs to interface with.  This includes MIDI I/O, 4-digit LED
    display, foot-switch momentary toggle switch indicators, and
    LED "active" indicators above foot-switches.

    NOTE: it is expected that 'types.h' is #included before this file
*/

#define SONG_NAME_MAXLENGTH 8
#define LEDS_MAX_ALPHAS 16

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

/* --------------- LED read-out display functions: */

void leds_show_digits(u8 value);
void leds_show_alphas(char text[LEDS_MAX_ALPHAS]);

/* --------------- Momentary toggle foot-switches: */

/* Total count of footswitches used for program switching, must be <= 32 */
extern const u8 fsw_preset_count;

/* Poll up to 32 foot-switch toggles simultaneously (implementation limited by fsw_count) */
u32 fsw_poll_presets();

/* Set currently active program foot-switch's LED indicator and disable all others */
void fsw_led_set_active(int idx);

/* --------------- Data persistence functions: */

/* Gets total number of programmed songs */
u16 songs_count();

/* Loads the name of the song, given the song_index */
int song_load_name(u16 song_index, char name[SONG_NAME_MAXLENGTH]);

/* Loads preset bank for the given song_index into programs and the count into *preset_count */
int song_load_presets(u16 song_index, u8 programs[fsw_preset_count], int* preset_count);
/* Saves preset bank for the given song_index from programs and the count from preset_count */
int song_store_presets(u16 song_index, u8 programs[fsw_preset_count], int preset_count, char name[SONG_NAME_MAXLENGTH]);

/* ---------------- Extra user-interface switches: */

extern const int fsw_extra_count;

enum fsw_extra_switches {
    FSW_SONG_DEC,
    FSW_SONG_INC,

    FSW_SONGPRESET_DEC,
    FSW_SONGPRESET_INC,

    FSW_PROGRAM1_INC,
    FSW_PROGRAM1_DEC,
    FSW_PROGRAM10_INC,
    FSW_PROGRAM10_DEC,

    FSW_PROGRAM_STORE,
};

/* Poll the extra footswitches */
u32 fsw_poll_extras();
