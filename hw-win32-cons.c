/*
    Hardware abstraction layer implementation for stdio
*/

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include "types.h"
#include "hardware.h"

/* --------------- MIDI I/O functions: */

/* Send a single MIDI byte. */
void midi_send_byte(u8 data) {
    printf("MIDI: 0x%02X\r\n", data);
}

/* Send formatted MIDI commands.

    0 <= cmd <= F       - MIDI command
    0 <= channel <= F   - MIDI channel to send command to
    00 <= data1 <= FF   - first data byte of MIDI command
    00 <= data2 <= FF   - second (optional) data byte of MIDI command
*/
void midi_send_cmd1(u8 cmd, u8 channel, u8 data1) {
    midi_send_byte(((cmd & 0xF) << 4) | (channel & 0xF));
    midi_send_byte(data1);
}

void midi_send_cmd2(u8 cmd, u8 channel, u8 data1, u8 data2) {
    midi_send_byte(((cmd & 0xF) << 4) | (channel & 0xF));
    midi_send_byte(data1);
    midi_send_byte(data2);
}

/* --------------- LED read-out display functions: */

void leds_show_digits(u8 value) {
    printf("VALU:  %03d\r\n", value);
}
void leds_show_alphas(char text[LEDS_MAX_ALPHAS]) {
    printf("TEXT: %." "16" "s\r\n", text);
}

/* --------------- Momentary toggle foot-switches: */

/* Total count of footswitches used for program switching, must be <= 32 */
const u8 fsw_preset_count = 8;

/* Poll up to 32 foot-switch toggles simultaneously (implementation limited by fsw_count) */
u32 fsw_poll_presets() {
    if (!kbhit()) return 0;

    int c = getch();
    switch (c) {
        case 'Q': case 'q': return 0x01;
        case 'W': case 'w': return 0x02;
        case 'E': case 'e': return 0x04;
        case 'R': case 'r': return 0x08;
        case 'A': case 'a': return 0x10;
        case 'S': case 's': return 0x20;
        case 'D': case 'd': return 0x40;
        case 'F': case 'f': return 0x80;
        default: ungetch(c);
    }
    return 0;
}

/* Set currently active program foot-switch's LED indicator and disable all others */
void fsw_led_set_active(int idx) {
    printf("ACTV: %d\r\n", idx);
}

/* --------------- Data persistence functions: */

/* Gets total number of programmed songs */
u16 songs_count() {
    u16 song_count;
    FILE *f;

    f = fopen("eeprom.bin", "rb");
    if (f == NULL) {
        printf("fake 1\r\n");
        return 1;
    }

    /* read the count of song records: */
    fread(&song_count, sizeof(u16), 1, f);
    return song_count;
}

/* Loads the name of the song, given the song_index */
int song_load_name(u16 song_index, char name[SONG_NAME_MAXLENGTH]) {
    u8  song_record_size = SONG_NAME_MAXLENGTH + fsw_preset_count;
    u16 song_count;
    FILE *f;

    f = fopen("eeprom.bin", "rb");
    if (f == NULL) {
        printf("fake name\r\n");
        strncpy(name, "GENERAL ", SONG_NAME_MAXLENGTH);
        return 0;
    }

    /* read the count of song records: */
    fread(&song_count, sizeof(u16), 1, f);
    if (song_index >= song_count) return 1;

    /* seek to song_index record, at the 'name' position: */
    fseek(f, (song_record_size * song_index), SEEK_CUR);
    fseek(f, (fsw_preset_count * sizeof(u8)), SEEK_CUR);
    fread(name, sizeof(char), SONG_NAME_MAXLENGTH, f);
    fclose(f);

    return 0;
}

/* Loads preset bank for the given song_index into programs and the count into *preset_count */
int song_load_presets(u16 song_index, u8 programs[fsw_preset_count], int* preset_count) {
    u8  song_record_size = SONG_NAME_MAXLENGTH + fsw_preset_count;
    u16 song_count;
    int i;
    FILE *f;

    /* try to load 'eeprom.bin': */
    f = fopen("eeprom.bin", "rb");
    if (f == NULL) {
        printf("fake programs\r\n");
        programs[0] = 0;
        programs[1] = 1;
        programs[2] = 20;
        programs[3] = 21;
        programs[4] = 22;
        programs[5] = 23;
        programs[6] = 24;
        programs[7] = 25;
        *preset_count = 8;
        return 0;
    }

    /* read the count of song records: */
    fread(&song_count, sizeof(u16), 1, f);
    if (song_index >= song_count) {
        printf("index out of range\r\n");
        return 1;
    }

    /* seek to song_index record: */
    fseek(f, (song_record_size * song_index), SEEK_CUR);
    fread(programs, sizeof(u8), fsw_preset_count, f);
    fclose(f);

    /* find first occurence of invalid 0xFF program number to determine # of presets in the song */
    for (i = 0; i < fsw_preset_count; ++i) {
        if (programs[i] == 0xFF) break;
    }
    *preset_count = i;

    return 0;
}

/* Saves preset bank for the given song_index from programs and the count from preset_count */
int song_store_presets(u16 song_index, u8 programs[fsw_preset_count], int preset_count, char name[SONG_NAME_MAXLENGTH]) {
    u8  song_record_size = SONG_NAME_MAXLENGTH + fsw_preset_count;
    u8  invalid = 0xFF;
    u16 song_count;
    FILE *f;
    int i;

    /* try to load 'eeprom.bin': */
    f = fopen("eeprom.bin", "r+b");
    if (f == NULL) {
        f = fopen("eeprom.bin", "wb");
        song_count = 1;
        fwrite(&song_count, sizeof(u16), 1, f);
        fwrite(programs, sizeof(u8), preset_count, f);
        for (i = preset_count; i < fsw_preset_count; ++i)
            fwrite(&invalid, sizeof(u8), 1, f);
        fwrite(name, sizeof(char), SONG_NAME_MAXLENGTH, f);
        fclose(f);
        return 0;
    }

    /* read the count of song records: */
    fread(&song_count, sizeof(u16), 1, f);
    if (song_index >= song_count) {
        printf("index out of range\r\n");
        return 1;
    }

    /* seek to song_index record: */
    fseek(f, (song_record_size * song_index), SEEK_CUR);
    fwrite(programs, sizeof(u8), preset_count, f);
    for (i = preset_count; i < fsw_preset_count; ++i)
        fwrite(&invalid, sizeof(u8), 1, f);
    fwrite(name, sizeof(char), SONG_NAME_MAXLENGTH, f);
    fclose(f);

    return 0;    
}

/* ---------------- Extra user-interface switches: */

/* Total count of footswitches used for extra UI, must be <= 32 */
const int fsw_extra_count = 9;

/* Poll the extra footswitches */
u32 fsw_poll_extras() {
    if (!kbhit()) return 0;
    int c = getch();
    switch (c) {
        case 'Z': case 'z': return 0x01;
        case 'X': case 'x': return 0x02;
        case 'C': case 'c': return 0x04;
        case 'V': case 'v': return 0x08;
        case 'I': case 'i': return 0x10;
        case 'K': case 'k': return 0x20;
        case 'O': case 'o': return 0x40;
        case 'L': case 'l': return 0x80;
        case 'P': case 'p': return 0x100;
        default: ungetch(c);
    }
    return 0;
}
