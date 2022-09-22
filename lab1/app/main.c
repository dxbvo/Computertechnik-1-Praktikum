/* ------------------------------------------------------------------
 * --  _____       ______  _____                                    -
 * -- |_   _|     |  ____|/ ____|                                   -
 * --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
 * --   | | | '_ \|  __|  \___ \   Zurich University of             -
 * --  _| |_| | | | |____ ____) |  Applied Sciences                 -
 * -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
 * ------------------------------------------------------------------
 * --
 * -- main.c
 * --
 * -- main for CT1 P01 "CT Zielsystem"
 * --
 * ------------------------------------------------------------------
 */

#include "utils_ctboard.h"

#define SWITCH_ADDR 0x60000200
#define LED_ADDR 0x60000100
#define ROTSWITCH_ADDR 0x60000211
#define SEVSEGDISPLAY_ADDR 0x60000110

/* == main ================================================================ */

int main(void) {
	
	const uint8_t hex_value[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71};

    while (1) {
        // Task 1 - read from dip switches, write to leds
			uint32_t val = read_word(SWITCH_ADDR);
			write_word(LED_ADDR, val);

        // Task 2 - control of a seven-segment display
			uint8_t value = read_byte(ROTSWITCH_ADDR);
			value = value & 0b00001111;
			uint8_t pattern = ~hex_value[value]; // Tilde verursacht Invertierung
			write_byte(SEVSEGDISPLAY_ADDR, pattern);
			
    }
}
