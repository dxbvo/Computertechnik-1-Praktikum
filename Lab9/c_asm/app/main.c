
#include <stdint.h>
#include <stdbool.h>

// hw addresses of the periphery blocks used
const uint32_t ADDR_LED =  0x60000100;
const uint32_t ADDR_DIP =  0x60000200;

extern void out_word(uint32_t out_address, uint32_t out_value); 
extern uint32_t in_word(uint32_t in_address);

int main(void) {

    while (1)
    {
				// to be programmed ..
			
    		uint32_t dip_switch_value = in_word(ADDR_DIP);
				out_word(ADDR_LED, dip_switch_value);
			
				// .. end to be programmed
    }   
    
}


