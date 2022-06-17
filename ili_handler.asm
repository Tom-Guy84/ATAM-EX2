.global my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
    push %rax
    push %rdi
    push %rsi
    push %rdx
    push %rcx
    push %r8
    push %r9
    push %r10
    push %r11
    push %rbx
    push %rsp
    push %rbp
    push %r12
    push %r13
    push %r14
    push %r15
    xorq %r12, %r12 #tp change the rip in the needed offset
    xorq %rdi, %rdi
    xorq %rcx, %rcx
    movq 128(%rsp), %rax #rax is users rip
    leaq 128(%rsp), %r13 #rip to change
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
    
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %rbp
    pop %rsp
    pop %rbx
    pop %r11
    pop %r10
    pop %r9
    pop %r8
    pop %rcx
    pop %rdx
    pop %rsi
    pop %rdi 
    pop %rax
    jmp *old_ili_handler
    
return_from_handler:   
    addq %r12, (%r13)
    
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %rbp
    pop %rsp
    pop %rbx
    pop %r11
    pop %r10
    pop %r9
    pop %r8
    pop %rcx
    pop %rdx
    pop %rsi
    pop %rax 
    pop %rax
   

  iretq
