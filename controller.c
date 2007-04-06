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
    (.)     = Rotary dial for digital increment/decrement
    [ ... ] = LED 7-segment (or more) display

           POWER                                      MIDI OUT   EXPR IN (opt)
            ||                                          | |         ||
        /------------------------------------------------------------------\
        |                                                                  |
        |  [ LED TEXT READOUT (16 chars)          ]   [ VALU ]  (.)        |
        |                                                                  |
        |  (*)   (*)   (*)   (*)  < PRVSNG NXTSNG >   INC 1 INC 10         |
        |  (o)   (o)   (o)   (o)     (o)    (o)        (o)   (o)           | 
        |   1     2     3     4                                     STORE  |
        |                                                            (o)   |
        |  (*)   (*)   (*)   (*)  < PREV   NEXT >     DEC 1 DEC 10         |
        |  (o)   (o)   (o)   (o)     (o)    (o)        (o)   (o)           |
        |   5     6     7     8                                            |
        \------------------------------------------------------------------/

*/

#include "types.h"
#include "hardware.h"

const u8 midi_channel = 0;

/* memory for the current program # setting, mapped to each preset switch */
u8      programs[32];

/* current settings */
u8      curr_program;
u8      curr_preset;
u8      curr_song;

/* song information */
char    song_name[SONG_NAME_MAXLENGTH];
int     song_count, song_presets;

/* controller state */
enum controller_state_t {
    STATE_PRESETS,
    STATE_PROGRAM_STORE,
} state;
u32 fsws, lastfsws;
u32 fswes, lastfswes;

char hexchar(u8 v) {
    return (v < 10) ? ('0' + v) : ('A' + (v - 10));
}

void show_message(char msg[LEDS_MAX_ALPHAS]) {
    int i = LEDS_MAX_ALPHAS - 1;
    while (i >= 0) {
        if (msg[i] == 0) msg[i] = ' ';
        else break;
    }
    leds_show_alphas(msg);
}

/* activate current preset and send the MIDI program change message */
void preset_activate() {
    char disp[LEDS_MAX_ALPHAS];
    int i;

    curr_program = programs[curr_preset];
    midi_send_cmd1(0xC, midi_channel, curr_program);
    fsw_led_set_active(curr_preset);
    leds_show_digits(curr_program);

    /* show song name with leading song # as "XXXX: " */
    disp[0] = hexchar((curr_song & 0xF000) >> 12);
    disp[1] = hexchar((curr_song & 0x0F00) >> 8);
    disp[2] = hexchar((curr_song & 0x00F0) >> 4);
    disp[3] = hexchar(curr_song & 0x000F);
    disp[4] = ':';
    disp[5] = ' ';
    /* copy song name until it fits in the LED alpha display */
    for (i = 6; (i < LEDS_MAX_ALPHAS) && (i - 6 < SONG_NAME_MAXLENGTH); ++i) {
        disp[i] = song_name[i - 6];
    }
    /* trailing spaces if necessary */
    for (; i < LEDS_MAX_ALPHAS; ++i)
        disp[i] = ' ';
    
    leds_show_alphas(disp);
}

/* activate current song */
void song_activate() {
    /* load up program mapping for current song: */
    song_load_name(curr_song, song_name);
    song_load_presets(curr_song, programs, &song_presets);

    /* activate the first preset: */
    curr_preset = 0;
    preset_activate();
}

/* find the first switch (bit) which was flipped off between the 'curr' and 'last' states: */
int find_released_switch(u32 curr, u32 last, u8 max) {
    /* don't waste time if nothing has changed this moment */
    if (curr == last) return -1;

    u32 m = 1;
    for (int i = 0; i < max; ++i, m <<= 1) {
        /* check for a switch release */
        if (((last & m) == m) && ((curr & m) == 0)) {
            return i;
        }
    }

    /* -1 indicates no switches have been released */
    return -1;
}

/* main control loop */
int main(int argc, char **argv) {
    int p;

    /* get number of programmed songs */
    song_count = songs_count();

    /* start at song #0 and load the presets, activating first preset implicitly */
    curr_song = 0;
    song_activate();

    /* begin our simple state machine */
    state = STATE_PRESETS;
    fsws = lastfsws = 0;

    for (;;) {
        /* handle non-state specific buttons: */
        fswes = fsw_poll_extras();
        if (fswes != lastfswes) {
            p = find_released_switch(fswes, lastfswes, fsw_extra_count);
            switch (p) {
                /* cycle forward/backward through the defined songs */
                case FSW_SONG_INC:
                    if (curr_song == (song_count - 1)) curr_song = 0;
                    else ++curr_song;
                    song_activate();
                    state = STATE_PRESETS;
                    break;
                case FSW_SONG_DEC:
                    if (curr_song == 0) curr_song = song_count - 1;
                    else --curr_song;
                    song_activate();
                    state = STATE_PRESETS;
                    break;

                /* cycle forward/backward through the song presets */
                case FSW_SONGPRESET_INC:
                    if (curr_preset == (song_presets - 1)) {
                        /* end of presets for one song cycles to beginning of next song */
                        if (curr_song == (song_count - 1)) curr_song = 0;
                        else ++curr_song;
                        song_activate();
                    } else {
                        ++curr_preset;
                        preset_activate();
                    }
                    break;
                case FSW_SONGPRESET_DEC:
                    if (curr_preset == 0) {
                        /* end of presets for one song cycles to beginning of previous song */
                        if (curr_song == 0) curr_song = song_count - 1;
                        else --curr_song;
                        song_activate();
                    } else {
                        --curr_preset;
                        preset_activate();
                    }
                    break;

                /* increment/decrement the current program # by 1 */
                case FSW_PROGRAM1_INC:
                    if (curr_program == 127) curr_program = 0;
                    else curr_program++;
                    leds_show_digits(curr_program);
                    break;
                case FSW_PROGRAM1_DEC:
                    if (curr_program == 0) curr_program = 127;
                    else curr_program--;
                    leds_show_digits(curr_program);
                    break;

                /* increment/decrement the current program # by 10 */
                case FSW_PROGRAM10_INC:
                    if (curr_program > 117) curr_program -= 117;
                    else curr_program += 10;
                    leds_show_digits(curr_program);
                    break;
                case FSW_PROGRAM10_DEC:
                    if (curr_program < 10) curr_program += 117;
                    else curr_program -= 10;
                    leds_show_digits(curr_program);
                    break;

                case FSW_PROGRAM_STORE:
                    if (state == STATE_PROGRAM_STORE) {
                        /* double tap on STORE cancels */
                        state = STATE_PRESETS;
                        show_message("CANCELLED");
                        /* TODO:  start a timer to refresh message */
                    } else {
                        /* switch state to program-store-to-preset: */
                        state = STATE_PROGRAM_STORE;
                        show_message("CHOOSE DEST");
                    }
                    break;
            }
        }
        lastfswes = fswes;

        /* handle state-specific buttons: */
        switch (state) {
            /* basic switching presets: */
            case STATE_PRESETS:
                /* poll all the footswitches */
                fsws = fsw_poll_presets();

                p = find_released_switch(fsws, lastfsws, fsw_preset_count);
                if (p != -1) {
                    if (p < song_presets) {
                        /* preset switch #p was released! */
                        curr_preset = p;
                        preset_activate();
                    } else {
                        show_message("INVALID!");
                        /* TODO:  start a timer to refresh message */
                    }
                }

                lastfsws = fsws;
                break;

            /* programming a preset in */
            case STATE_PROGRAM_STORE:
                /* poll all the footswitches */
                fsws = fsw_poll_presets();

                /* find which one to store to */
                p = find_released_switch(fsws, lastfsws, fsw_preset_count);
                if (p != -1) {
                    if (p < song_presets) {
                        /* preset switch #p was released! */
                        programs[p] = curr_program;
                        song_store_presets(curr_song, programs, song_presets, song_name);

                        curr_preset = p;
                        preset_activate();
                        state = STATE_PRESETS;
                    } else {
                        show_message("INVALID!");
                        /* TODO:  start a timer to refresh message */
                    }
                }

                lastfsws = fsws;
                break;
        }
    }

    return 0;
}
