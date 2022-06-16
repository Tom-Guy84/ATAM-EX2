.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input 
.section .bss
.lcomm path, 1024

.section .text
read_input: # rdi is pointer to the array to fill
    pushq %rbp
    movq %rsp, %rbp
    pushq %r12
    pushq %r13
    pushq $0
    movq %rdi, %r8 #r8 is now holding the pointer to the array
    leaq path(%rip), %rdi
    pushq %r8
    call get_path
    popq %r8
    movq $2, %rax #starting prep to open the file
    leaq path(%rip), %rdi
    movq $0, %rsi
    movq $0655, %rdx
    syscall #after this line rax should contain file descriptor
    movq %rax, %r13
    movq $0xa, %r9
    movq $0, %r10
    movq %r13, %rdi #rdi = fd
find_number:
    movq $0, %rax
    movq %rsp, %rsi
    movq $1, %rdx
    syscall
    inc %rsp
    inc %r10
    cmpb -1(%rsp), %r9b
    

    #break READ_INPUT
    je null_terminator
    jmp find_number
null_terminator:
    subq $0xa, (%rsp)
    movq (%rsp), %r9
    subq %r10, %rsp
    movq %rsp, %rdi
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %rdi
    pushq %rsi
    call atam_atol
    popq %rsi
    popq %rdi
    popq %r10
    popq %r9
    popq %r8
    movq %r13, %rdi
    movq %rax, %rdx
    push %rdx
    movq $0, %rax
    movq %r8, %rsi
    syscall
    pushq %rax
    movq $3, %rax
    movq %r13, %rdi
    syscall #close file
    popq %rax
    popq %rdx
    movq %rdx, %rax
    shr $3, %rax
    popq %r13
    popq %r12
    leave
  ret

hamming_weight:
    pushq %rbp
    movq %rsp, %rbp
    xor %rax, %rax # counter
loop_calc:
    mov (%rdi), %r11
    popcnt %r11, %r10
    addq %r10, %rax
    addq $8, %rdi 
    dec %rsi
    test %rsi, %rsi
    jne loop_calc

    leave
    ret


negate_first_k: # rdi is the code word, rsi is the number of bits to flip
#rdi doesnt contain the whole word...
# we need to go 8 by 8 bits 
    pushq %rbp
    movq %rsp, %rbp
    movq $1, %rdx
loop_shift_hw2:
    cmp $0,%rsi
    jz plz
    shl $1,%rdx
    dec %rsi
    jmp loop_shift_hw2
plz:
    dec %rdx
    xorq %rdx, %rdi
    movq %rdi, %rax
    leave
  ret


bring_balance_to_the_word:
#bring_balance_to_the_word(unsigned long* codeword, unsigned long len)
#rdi=codeword, %rsi=long len
pushq %rbp
movq %rsp,%rbp
pushq %r13 # r13 is our counter
pushq %r14 #%r14 is k 
push %r15 #r15 is codeword forever and ever 
pushq %rbx
movq %rdi,%r15 #r15 is rdi forever and ever v2
movq %rsi,%rbx
movq %rsi, %r8 #when ever call hamming_weight do rsi = r8)
shlq $5,%rbx # %rbx now contains n/2.




#### starting preps for the flips.
xorq %r13, %r13 #offset in bytes from the beginning of codeword.
xorq %r14, %r14 #k=0


loop_hw2:
xorq %r10, %r10
movq %r15,%rdi #setup rdi to be codeword for calc
movq %r8, %rsi #for hamming weight
pushq %r8
pushq %rdi #rdi contains the adress to codeword
pushq %rsi #rsi contains n/8(=len)
pushq %rbx # rbx contains n/2
call hamming_weight 
popq %rbx #rdi keeps the adress of codeword  
popq %rsi  # rsi <- keep now n/8
popq %rdi #rbx <- keeps n/2 
popq %r8
cmp %rax,%rbx # we ask if our current hamming weight equals to n/2
je end 


inc %r14
cmp $65, %r14
jne negate_last_byte_flipped
movq $1, %r14
inc %r13 #if number of fliped bits was 64, inc r13 and set k=1

# now do the next filp
### goal - to filp only the next index mod 64 in the wanted byte.
flip:
##movq %r15, %r10
##addq %r13, %r10 #now r10 contains the address fo the wanted byte to flip
leaq (%r15, %r13, 8) , %r10
movq (%r10), %rdi #now rdi contains the watned byte to flip
movq %r14,  %rsi #rsi is k for negate
pushq %r10
pushq %r8
pushq %rbx
call negate_first_k
pop %rbx
pop %r8
popq %r10
movq %rax, (%r10) #update codeword
jmp loop_hw2
###now need to check hamming weight, if not good then do the last part


negate_last_byte_flipped:
cmp $1, %r14
je flip
decq %r14
##movq %r15, %r10
##addq %r13, %r10 #now r10 contains the address fo the wanted byte to flip
leaq (%r15, %r13, 8) , %r10
movq (%r10), %rdi #now rdi contains the watned byte to flip
movq %r14,  %rsi #rsi is k for negate
pushq %r10
pushq %r8
pushq %rbx
call negate_first_k
pop %rbx
pop %r8
popq %r10
movq %rax, (%r10) #update codeword 
inc %r14
jmp flip






##end_internal_loop:
###xorq %rdx, %rdx #for idiv
###movq %r14, %rax #for idiv
###movq $64, %r9
###div %r9 #rax = k/64, #rsi = k mod 64
### call negate one more time with k mod 64
###leaq (%r15, %r13, 8) , %r10
###movq (%r10), %rdi
###movq %rdx, %rsi
###pushq %r10
###pushq %rbx
###pushq %r8
###call negate_first_k
###popq %r8
###popq %rbx
###popq %r10
###movq %rax, (%r10)
###incq %r14 #k++ 
###jmp loop_hw2





end:
shl $6, %r13
add %r13, %r14
movq %r14,%rax #return k.
popq %rbx #pushed in line 94 
popq %r15
popq %r14 #pushed in line 101
popq %r13 # in teh begginging
leave
ret
