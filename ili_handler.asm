.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
    movq 8(%rsp), %rax #rax is users rip
    shr $48, %rax #ax contain the opcode
    xorq %rdi, %rdi
    movq $0xf00, %rdx
    andq %rax, %rdx
    cmpq $0xf00, %rdx
    je opcode_is_last_byte
    shr $8, %rax
    mov %ax, %di #rdi contains the upper byte of the opcode
    jmp call_what_to_do
opcode_is_last_byte:
    mov %ax, %di #rdi contains the byte after 0x0f (lower byte)
call_what_to_do:
    call what_to_do
    cmp 0$, rax
    jne return_from_handler
    movq old_ili_handler, %rax #if got here, need to activate the original ili handler.
    call *%rax
    
return_from_handler:
    movq %rax, imm(%rsp)
    
      
  iretq