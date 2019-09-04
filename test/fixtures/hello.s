.text
.globl _main

_main:
call HelloWorld.main
xor %rax, %rax
ret

HelloWorld.main:
mov $9, %r12
mov %r12, %rdi
call __println
ret

__println:
mov %edi, %eax
mov $10, %ecx
push %rcx
mov %rsp, %rsi

.digit:
xor %edx, %edx
div %ecx
add $48, %edx
dec %rsi
mov %dl, (%rsi)
test %eax, %eax
jnz .digit

mov $0x2000004, %eax
mov $1, %edi
lea 1(%rsp), %edx
sub %esi, %edx
syscall

add $8, %rsp
ret
