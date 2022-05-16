#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
asm("sidt %0"
:"=m"(*idtr)
:
);
}

void my_load_idt(struct desc_ptr *idtr) {
asm("lidt %0"
:
:"m"(*idtr)
);
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
	
	if(gate == NULL) {
		return;
	}
	gate->offset_high = (u32)(addr>>32);
	gate->offset_middle = (u16)((addr<<32)>>48);
	gate->offset_low = (u16)((addr<<48)>>48);
/*
	
   unsigned long cal = 0xffff;
   unsigned long my_offset_middle;
   unsigned long my_offset_high;
   unsigned long my_offset_low;

   my_offset_low = addr & cal;
   addr = addr >> 16;
   my_offset_middle = addr & cal;
   cal = cal << 16;
   cal = cal | 0xffff;
   addr = addr >> 16;
   my_offset_high = addr & cal;
   //my_offset_high = my_offset_high >> 32;

   gate->offset_low = (u16)my_offset_low;
   gate->offset_middle = (u16)my_offset_middle;
   gate->offset_high = (u32)my_offset_high;
*/
}

unsigned long my_get_gate_offset(gate_desc *gate) {
    if(gate == NULL) {
        return 0;
    }
    unsigned long high = (unsigned long)(gate->offset_high);
    high<<32;
    unsigned long mid = (unsigned long)(gate->offset_middle);
    mid<<16;
    unsigned long low = (unsigned long)(gate->offset_low);
    unsigned long addr = high | mid | low;
    return addr;
}
