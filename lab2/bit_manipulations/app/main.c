/* -----------------------------------------------------------------
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
 * -- main for Computer Engineering "Bit Manipulations"
 * --
 * -- $Id: main.c 744 2014-09-24 07:48:46Z ruan $
 * ------------------------------------------------------------------
 */
//#include <reg_ctboard.h>
#include "utils_ctboard.h"

#define ADDR_DIP_SWITCH_31_0 0x60000200
#define ADDR_DIP_SWITCH_7_0  0x60000200
#define ADDR_LED_31_24       0x60000103
#define ADDR_LED_23_16       0x60000102
#define ADDR_LED_15_8        0x60000101
#define ADDR_LED_7_0         0x60000100
#define ADDR_BUTTONS         0x60000210

// define your own macros for bitmasks below (#define)

#define MASK_bright 0xC0
#define MASK_dark   0xCF
#define MASK_4bit   0x0F

/// STUDENTS: To be programmed



/// END: To be programmed

int main(void)
{
    uint8_t led_value = 0;
	  uint8_t button_value = 0;
	
	  uint8_t edge_index = 0;
	  uint8_t index = 0;
	  uint8_t old_value = 0;
	
	  uint8_t SW_value = 0;
	  uint8_t value_inverted = 0;

    // add variables below
    /// STUDENTS: To be programmed




    /// END: To be programmed
	SW_value = read_byte(ADDR_DIP_SWITCH_7_0);
	
    while (1) {
        // ---------- Task 3.1 ----------
        led_value = read_byte(ADDR_DIP_SWITCH_7_0);
			
        /// STUDENTS: To be programmed
 			  led_value = led_value | MASK_bright;
			  led_value = led_value & MASK_dark;
			
			  write_byte(ADDR_LED_7_0, led_value);       
        /// END: To be programmed
        
			  
			  // ---------- Task 3.2 and 3.3 ----------

  			button_value = read_byte(ADDR_BUTTONS);
			  button_value = button_value & MASK_4bit;
			  uint8_t edge = button_value & ~old_value;
			  old_value = button_value;
        
			
  			/// STUDENTS: To be programmed

 			  if (button_value & 0x01) {
					index += 1;
				}
				write_byte(ADDR_LED_15_8, index);				


			  // Task 3.2 und 3.3
				
				
				if (edge & 0x01) {
					edge_index += 1;						
				  write_byte(ADDR_LED_31_24, edge_index);
					SW_value = (SW_value >> 1);
					write_byte(ADDR_LED_23_16, SW_value);
			  } 
				if (edge & 0x02) {
					SW_value = (SW_value << 1);
					write_byte(ADDR_LED_23_16, SW_value);	
				}
				
				if (edge & 0x04) { 
					SW_value = read_byte(ADDR_DIP_SWITCH_7_0);
          value_inverted = ~SW_value;					
					write_byte(ADDR_LED_23_16, value_inverted);					
				}
				
				if (edge & 0x08) { 
					SW_value = read_byte(ADDR_DIP_SWITCH_7_0);
					write_byte(ADDR_LED_23_16, SW_value);
				}

        /// END: To be programmed
    }
}




