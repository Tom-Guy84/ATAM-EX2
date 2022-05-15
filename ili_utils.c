#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
asm("%sidt %0;"
:
:"=m"(idtr)
);
sidt %rdi
}

void my_load_idt(struct desc_ptr *idtr) {
asm("lidt %0;"
:"=m"(idtr)
);
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
set_trap_gate(gate, addr);
/*
low = addr 0:15
mid = addr 16:31
high = addr 32:63
gate->offset_low = low
...
*/
}

unsigned long my_get_gate_offset(gate_desc *gate) {
return (unsigned long)((unsigned long)gate->offset_high<<32|
            (unsigned long)gate->offset_middle<<16| (unsigned long)gate->offset_low);
}
