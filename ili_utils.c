#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
asm("sidt %0;"
:"+m"(*idtr)
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

	char* loc = (char*)&addr;
	unsigned int high = *((unsigned int*)(loc + 4));
	unsigned short middle = *((unsigned short*)(loc + 2));
	unsigned short low = *((unsigned short*)loc);
	gate->offset_high = high;
	gate->offset_middle = middle;
	gate->offset_low = low;
	return;
}

unsigned long my_get_gate_offset(gate_desc *gate) {
    unsigned short low = gate->offset_low;;
	unsigned short middle = gate->offset_middle;
	unsigned int high = gate->offset_high;;
	unsigned long addr = 0;
	addr = high;
	addr = addr << 16;
	addr = addr + middle;
	addr = addr << 16;
	addr = addr + low;
	return addr;
}
