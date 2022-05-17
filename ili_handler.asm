.global my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
    pushq %r12
    pushq %r13
    xorq %r12, %r12 #tp change the rip in the needed offset
    xorq %rdi, %rdi
    xorq %rcx, %rcx
    movq 16(%rsp), %rax #rax is users rip
    leaq 16(%rsp), %r13 #rip to change
    movb (%rax), %cl
    cmpb $0x0f, %cl
    je opcode_is_last_byte
    movq $1, %r12
    movq %rcx, %rdi #rdi contains the upper byte of the opcode
    jmp call_what_to_do
opcode_is_last_byte:
    movb 1(%rax), %cl
    movq %rcx, %rdi #rdi contains the byte after 0x0f (lower byte)
    movq $2, %r12
call_what_to_do:
    call what_to_do
    movq %rax, %rdi
    cmp $0, %rdi
    jne return_from_handler
    
    popq %r13
    popq %r12
    jmp *old_ili_handler
    
return_from_handler:   
    addq %r12, (%r13)
    popq %r13
    popq %r12
      
  iretq
